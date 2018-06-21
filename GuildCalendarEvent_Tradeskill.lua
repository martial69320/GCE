----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

local _

function GuildCalendarEvent:InitializeTradeskill()
	self.Tradeskill = GuildCalendarEvent:New(GuildCalendarEvent._Tradeskill)
end

----------------------------------------
GuildCalendarEvent._Tradeskill = {}
----------------------------------------

function GuildCalendarEvent._Tradeskill:Construct()
	GuildCalendarEvent.EventLib:RegisterEvent("TRADE_SKILL_SHOW", self.TradeSkillShow, self)
	GuildCalendarEvent.EventLib:RegisterEvent("TRADE_SKILL_CLOSE", self.TradeSkillClose, self)
end

function GuildCalendarEvent._Tradeskill:TradeSkillShow()
	self.TradeSkillOpen = true
	self:UpdateCurrentTradeskillCooldown()
end

function GuildCalendarEvent._Tradeskill:TradeSkillClose()
	self:UpdateCurrentTradeskillCooldown()

	self.TradeSkillOpen = false
	
	if self.NewEvent then
		if self.NewEvent:IsOpened() then
			self.NewEvent:Save()
		end
		
		self.NewEvent = nil
	end
end

function GuildCalendarEvent._Tradeskill:UpdateCurrentTradeskillCooldown()
	if GuildCalendarEvent.Data.Prefs.DisableTradeskills then
		return
	end
	
	local vServerDate, vServerTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	local vRecipeIDs = C_TradeSkillUI.GetAllRecipeIDs()

	for _, vRecipeID in ipairs(vRecipeIDs) do
		local vRecipeInfo = C_TradeSkillUI.GetRecipeInfo(vRecipeID)
		local vCooldown = C_TradeSkillUI.GetRecipeCooldown(vRecipeID)

		if vCooldown and vCooldown > 0 then
			local vCooldownID = "RECIPE_"..vRecipeID

			local vCooldownDate, vCooldownTime = GuildCalendarEvent.DateLib:AddOffsetToDateTime(vServerDate, vServerTime, vCooldown / 60)
			local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vCooldownDate)
			local vHour, vMinute = GuildCalendarEvent.DateLib:ConvertTimeToHM(vCooldownTime)
			
			-- Add an event for the new cooldown if there isn't already one
				
			if not self:HasCooldownIDEvent(vCooldownID, vMonth, vDay, vYear) then
				self.NewEvent = GuildCalendarEvent.Calendars.PLAYER:NewEvent(vMonth, vDay, vYear, "PLAYER")
					
				self.NewEvent:Open()
				self.NewEvent:SetTitle(vRecipeInfo.name)
				self.NewEvent:SetTitleTag(vCooldownID)
				self.NewEvent:SetType(CALENDAR_EVENTTYPE_OTHER, 1)
				self.NewEvent:SetTime(vHour, vMinute)
				self.NewEvent:SetDuration(nil)
				self.NewEvent:Save()
			end -- if not HasCooldownIDEvent
				
			-- Delete any older occurances of this cooldown
				
			for vDate = vCooldownDate - 30, vCooldownDate - 1 do
				local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vDate)
				local vMonthOffset = GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(vMonth, vYear)
				local vNumEvents = GuildCalendarEvent.WoWCalendar:CalendarGetNumDayEvents(vMonthOffset, vDay) 
					
				for vEventIndex = 1, vNumEvents do
					local vTitle, vHour, vMinute,
							vCalendarType, vSequenceType, vEventType,
							vTextureID,
							vModStatus, vInviteStatus, vInvitedBy = GuildCalendarEvent.WoWCalendar:CalendarGetDayEvent(vMonthOffset, vDay, vEventIndex)
					local vTitleTag = GuildCalendarEvent.WoWCalendar:CalendarEventGetTitleTag()
						
					if vTitleTag == vCooldownID then
						GuildCalendarEvent.WoWCalendar:CalendarContextEventRemove(vMonthOffset, vDay, vEventIndex)
						break
					end
				end -- for vEventIndex
			end -- for vDate
		end -- if vCooldown
	end -- for vSkillIndex
end

function GuildCalendarEvent._Tradeskill:HasCooldownIDEvent(pCooldownID, pMonth, pDay, pYear)
	local vNumEvents = GuildCalendarEvent.WoWCalendar:CalendarGetNumAbsDayEvents(pMonth, pDay, pYear)
	
	for vEventIndex = 1, vNumEvents do
		local vTitle, vHour, vMinute = GuildCalendarEvent.WoWCalendar:CalendarGetAbsDayEvent(pMonth, pDay, pYear, vEventIndex)
		local vTitleTag = GuildCalendarEvent.WoWCalendar:CalendarEventGetTitleTag()

		if vTitleTag == pCooldownID then
			return true, vEventIndex
		end
	end
end
