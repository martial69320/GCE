----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.Reminders = {}
----------------------------------------

GuildCalendarEvent.Reminders.cReminderIntervals = {0, 60, 300, 900, 1800, 3600}
GuildCalendarEvent.Reminders.cNumReminderIntervals = #GuildCalendarEvent.Reminders.cReminderIntervals

function GuildCalendarEvent.Commands:reminder(pOption)
	if pOption:lower() == "off" then
		GuildCalendarEvent.Data.Prefs.DisableReminders = true
		GuildCalendarEvent:NoteMessage("Reminders disabled")
	elseif pOption:lower() == "on" then
		GuildCalendarEvent.Data.Prefs.DisableReminders = nil
		GuildCalendarEvent:NoteMessage("Reminders enabled")
		GuildCalendarEvent.Reminders:CalculateReminders()
	else
		GuildCalendarEvent:ErrorMessage("Unknown reminder option, use 'on' or 'off'")
	end
end

function GuildCalendarEvent.Commands:birth(pOption)
	if pOption:lower() == "off" then
		GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders = true
		GuildCalendarEvent:NoteMessage("Birthday reminders disabled")
	elseif pOption:lower() == "on" then
		GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders = nil
		GuildCalendarEvent:NoteMessage("Birthday reminders enabled")
		GuildCalendarEvent.Reminders:CalculateReminders()
	else
		GuildCalendarEvent:ErrorMessage("Unknown birthday option, use 'on' or 'off'")
	end
end

function GuildCalendarEvent.Commands:attend(pOption)
	if pOption:lower() == "off" then
		GuildCalendarEvent.Data.Prefs.DisableAttendNotices = true
		GuildCalendarEvent:NoteMessage("Attendance notices disabled")
	elseif pOption:lower() == "on" then
		GuildCalendarEvent.Data.Prefs.DisableAttendNotices = nil
		GuildCalendarEvent:NoteMessage("Attendance notices enabled")
	else
		GuildCalendarEvent:ErrorMessage("Unknown attendance notices option, use 'on' or 'off'")
	end
end

function GuildCalendarEvent.Reminders:EventConfirmMessage(pMessage, pName, pEvent)
	if GuildCalendarEvent.Data.Prefs.DisableAttendNotices then
		return
	end
	
	GuildCalendarEvent:NoteMessage(
			pMessage:gsub("%$(%w+)",
			{
				name = pName,
				event = pEvent.Title,
				date = GuildCalendarEvent.DateLib:GetShortDateString(GuildCalendarEvent.DateLib:ConvertMDYToDate(pEvent.Month, pEvent.Day, pEvent.Year), true)
			}))
end

function GuildCalendarEvent.Reminders:EventNeedsReminder(pEvent, pCurrentDateTimeStamp)
	-- Don't remind for events they're not attending
	
	if not pEvent:IsCooldownEvent()
	and not pEvent:IsAttending()
	and pEvent.TitleTag ~= "BRTH" then
		return false
	end
	
	-- Don't remind for events which don't have a start time (birthdays and vacations)
	
	if not pEvent.Hour then
		return false
	end
	
	-- Don't remind if all reminders have been issued
	
	if pEvent.ReminderIndex == 0 then
		return false
	end
	
	-- Don't remind if the event has passed
	
	if pEvent:HasPassed(pCurrentDateTimeStamp) then
		return false
	end
	
	-- Don't remind for dungeon resets
	
	if pEvent.CalendarType == "RAID_LOCKOUT" then
		return false
	end
	
	return true
end

function GuildCalendarEvent.Reminders:CalculateReminders()
	-- Gather up events
	
	local vCurrentDate, vCurrentTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	local vCurrentDateTimeStamp = vCurrentDate * 86400 + vCurrentTime * 60
	
	-- Recycle the previous event table
	
	if self.Events then
		for vKey, _ in pairs(self.Events) do
			self.Events[vKey] = nil
		end
	else
		self.Events = {}
	end
	
	-- Collect the events
	
	for vDate = vCurrentDate - 1, vCurrentDate + 1 do
		for vCalendarID, vCalendar in pairs(GuildCalendarEvent.Calendars) do
			local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vDate)
			local vSchedule = vCalendar:GetSchedule(vMonth, vDay, vYear)
			
			for _, vEvent in ipairs(vSchedule.Events) do
				if vEvent:EventIsVisible(vCalendar.CalendarID == "PLAYER") then
					if self:EventNeedsReminder(vEvent, vCurrentDateTimeStamp) then
						if not vEvent.ReminderIndex then
							vEvent.ReminderIndex = self.cNumReminderIntervals
						end
						
						table.insert(self.Events, vEvent)
					end
				end
			end
		end -- for vCalendar
	end -- for vDate
	
	-- Sort the events
	
	table.sort(self.Events, GuildCalendarEvent.CompareEventTimes)
	
	--GuildCalendarEvent:DebugTable(self.Events, "Reminder events")
	
	-- Calculate the time to the first event
	
	self:DoReminders()
end

function GuildCalendarEvent.Reminders:GetEventReminderInterval(pEvent, pCurrentDateTimeStamp)
	-- Ignore the event if the final reminder has already
	-- been issued
	
	if pEvent.ReminderIndex == 0 then
		return
	end
	
	-- Calculate the seconds remaining until the event starts
	
	local vTimeRemaining = pEvent:GetSecondsToStart(pCurrentDateTimeStamp)
	
	-- If the event is starting or started then skip
	-- right to the final reminder
	
	if vTimeRemaining <= 0 then
		pEvent.ReminderIndex = 0
		return nil, vTimeRemaining, true
	end
	
	-- Track intervals so the caller can be notified when it changes
	
	local vReminderIntervalPassed = false
	
	-- If the event hasn't gotten any reminders yet, see if it's time for the first one
	
	if not pEvent.ReminderIndex then
		local vReminderRemaining = vTimeRemaining - self.cReminderIntervals[self.cNumReminderIntervals]
		
		if vReminderRemaining > 0 then
			return vReminderRemaining, vTimeRemaining, false
		end
		
		pEvent.ReminderIndex = self.cNumReminderIntervals
		vReminderIntervalPassed = true
	end
	
	while vTimeRemaining <= self.cReminderIntervals[pEvent.ReminderIndex - 1] do
		pEvent.ReminderIndex = pEvent.ReminderIndex - 1
		
		vReminderIntervalPassed = true
		
		if pEvent.ReminderIndex == 0 then
			return nil, vTimeRemaining, vReminderIntervalPassed
		end
	end
	
	return vTimeRemaining - self.cReminderIntervals[pEvent.ReminderIndex - 1], vTimeRemaining, vReminderIntervalPassed
end

function GuildCalendarEvent.Reminders:DoReminders()
	local vCurrentDate, vCurrentTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	local vCurrentDateTimeStamp = vCurrentDate * 86400 + vCurrentTime * 60
	
	local vMinTimeRemaining = nil
	local vIndex = 1
	
	if not GuildCalendarEvent.Data.Prefs.DisableReminders then
		while vIndex <= #self.Events do
			local vEvent = self.Events[vIndex]

			if (vEvent:IsBirthdayEvent() and not GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders)
			or (vEvent:IsCooldownEvent() and not GuildCalendarEvent.Data.Prefs.DisableTradeskillReminders)
			or (not vEvent:IsBirthdayEvent() and not vEvent:IsCooldownEvent() and not GuildCalendarEvent.Data.Prefs.DisableEventReminders) then
				local vReminderTimeRemaining, vTimeRemaining, vReminderIntervalPassed = self:GetEventReminderInterval(vEvent, vCurrentDateTimeStamp)
				
				if vIndex == 1 then
					if vTimeRemaining <= 3600 then -- Show the icon for one hour before the event
						GuildCalendarEvent:ShowReminderIcon(vEvent:GetTexture())
					else
						GuildCalendarEvent:HideReminderIcon()
					end
				end
				
				if vReminderIntervalPassed then
					if vTimeRemaining <= 0 then
						if vEvent:IsBirthdayEvent() then
							if not not GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders then
								local vMessage = vEvent.Title
								
								if not vMessage or vMessage == "" then
									vMessage = string.format(GuildCalendarEvent.cHappyBirthdayFormat, vEvent.InvitedBy)
								end
								
								GuildCalendarEvent.MessageFrame:AddMessage(vMessage)
								GuildCalendarEvent:NoteMessage(vMessage)
							end
						elseif vEvent:IsCooldownEvent() then
							if not not GuildCalendarEvent.Data.Prefs.DisableTradeskillReminders then
								local vMessage = vEvent.Title
								
								if vEvent.OwnersName ~= GuildCalendarEvent.PlayerName then
									vMessage = vMessage..string.format(" (%s)", vEvent.OwnersName)
								end
								
								GuildCalendarEvent.MessageFrame:AddMessage(vMessage)
								GuildCalendarEvent:NoteMessage(vMessage)
							end
						elseif vTimeRemaining < -120 then
							local vMessage = string.format(GuildCalendarEvent.cAlreadyStartedFormat, vEvent.Title)
							
							if vEvent.OwnersName ~= GuildCalendarEvent.PlayerName then
								vMessage = vMessage..string.format(" (%s)", vEvent.OwnersName)
							end
							
							GuildCalendarEvent.MessageFrame:AddMessage(vMessage)
							GuildCalendarEvent:NoteMessage(vMessage)
						else
							local vMessage = string.format(GuildCalendarEvent.cStartingNowFormat, vEvent.Title)
							
							if vEvent.OwnersName ~= GuildCalendarEvent.PlayerName then
								vMessage = vMessage..string.format(" (%s)", vEvent.OwnersName)
							end
							
							GuildCalendarEvent.MessageFrame:AddMessage(vMessage)
							GuildCalendarEvent:NoteMessage(vMessage)
						end
					else
						local vMinutesRemaining = math.floor(vTimeRemaining / 60 + 0.5)
						local vFormat
						
						if vEvent:IsCooldownEvent() then
							if vMinutesRemaining == 1 then
								vFormat = GuildCalendarEvent.cAvailableMinuteFormat
							else
								vFormat = GuildCalendarEvent.cAvailableMinutesFormat
							end
						else
							if vMinutesRemaining == 1 then
								vFormat = GuildCalendarEvent.cStartsMinuteFormat
							else
								vFormat = GuildCalendarEvent.cStartsMinutesFormat
							end
						end
						
						local vMessage = string.format(vFormat, vEvent.Title, vMinutesRemaining)
						
						if vEvent.OwnersName ~= GuildCalendarEvent.PlayerName then
							vMessage = vMessage..string.format(" (%s)", vEvent.OwnersName)
						end
						
						GuildCalendarEvent.MessageFrame:AddMessage(vMessage)
						GuildCalendarEvent:NoteMessage(vMessage)
					end
				end -- if vReminderIntervalPassed
				
				if vReminderTimeRemaining
				and vReminderTimeRemaining > 0 then
					if not vMinTimeRemaining or vReminderTimeRemaining < vMinTimeRemaining then
						vMinTimeRemaining = vReminderTimeRemaining
					end
					
					if vEvent.ReminderIndex == self.cNumReminderIntervals then
						break
					end
					
					vIndex = vIndex + 1
				else
					table.remove(self.Events, vIndex)
				end
			else
				vIndex = vIndex + 1
			end -- if disabled
		end -- while
	end -- if
	
	--
	
	if vMinTimeRemaining then
		GuildCalendarEvent.SchedulerLib:ScheduleUniqueTask(vMinTimeRemaining, self.DoReminders, self)
	else
		GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.DoReminders, self)
		GuildCalendarEvent:HideReminderIcon()
	end
end

function GuildCalendarEvent.Reminders:DumpReminders()
	GuildCalendarEvent:DebugTable(GuildCalendarEvent.Reminders, "Reminders")
end

function GuildCalendarEvent.Reminders:PlayerEnteringWorld()
	GuildCalendarEvent.SchedulerLib:ScheduleUniqueTask(30, self.CalculateReminders, self)
end

function GuildCalendarEvent.Reminders:EventChanged()
	GuildCalendarEvent.SchedulerLib:ScheduleUniqueTask(5, self.CalculateReminders, self)
end

GuildCalendarEvent.EventLib:RegisterEvent("PLAYER_ENTERING_WORLD", GuildCalendarEvent.Reminders.PlayerEnteringWorld, GuildCalendarEvent.Reminders)
GuildCalendarEvent.EventLib:RegisterEvent("GC5_EVENT_CHANGED", GuildCalendarEvent.Reminders.EventChanged, GuildCalendarEvent.Reminders)
GuildCalendarEvent.EventLib:RegisterEvent("GC5_EVENT_ADDED", GuildCalendarEvent.Reminders.EventChanged, GuildCalendarEvent.Reminders)
GuildCalendarEvent.EventLib:RegisterEvent("GC5_EVENT_DELETED", GuildCalendarEvent.Reminders.EventChanged, GuildCalendarEvent.Reminders)
