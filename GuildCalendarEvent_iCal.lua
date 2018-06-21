----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.iCal = {}
----------------------------------------
--[[
table.insert(GuildCalendarEvent.CommandHelp, HIGHLIGHT_FONT_COLOR_CODE.."/cal export [all raids dungeons cooldowns]"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpiCal)

function GuildCalendarEvent.Commands:export(pOptions)
	GuildCalendarEvent.iCal:Export(pOptions)
end
]]
function GuildCalendarEvent.iCal:Export(pOptions)
	if not GuildCalendarEvent.ReportWindow then
		GuildCalendarEvent.ReportWindow = GuildCalendarEvent:New(GuildCalendarEvent._ReportWindow)
	end
	
	GuildCalendarEvent.ReportWindow:ShowReport(self.GetReport, self)
end

function GuildCalendarEvent.iCal:GetReport(pOpcode)
	if pOpcode ~= "GETTEXT" then
		return
	end
	
	local vIncludeHolidays = GuildCalendarEvent.Data.Prefs.ExportHolidays
	local vIncludeAlts = GuildCalendarEvent.Data.Prefs.ExportAltEvents
	local vIncludePersonal = GuildCalendarEvent.Data.Prefs.ExportPersonalEvents
	local vIncludePrivate = GuildCalendarEvent.Data.Prefs.ExportPrivateEvents
	local vIncludeGuild = GuildCalendarEvent.Data.Prefs.ExportGuildEvents
	local vIncludeTradeskills = GuildCalendarEvent.Data.Prefs.ExportTradeskillCooldowns
	
	local vReport = {}
	
	table.insert(vReport, "BEGIN:VCALENDAR")
	table.insert(vReport, "VERSION:2.0")
	table.insert(vReport, "GuildCalendarEvent"..GuildCalendarEvent.cVersionString)
	
	local vCurrentDate, vCurrentTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	
	local vStartDate = vCurrentDate - 14
	local vEndDate = vCurrentDate + 60
	
	for vDate = vStartDate, vEndDate do
		local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vDate)
		local vEvents = GuildCalendarEvent:GetDayEvents(vMonth, vDay, vYear)
		
		if vEvents then
			for _, vEvent in ipairs(vEvents) do
				local vSkip = false
				
				if vEvent.CalendarType == "HOLIDAY" and not vIncludeHolidays then
					vSkip = true
				elseif vEvent.OwnersName ~= GuildCalendarEvent.PlayerName
				and vEvent:IsPlayerCreated()
				and not vIncludeAlts then
					vSkip = true
				elseif vEvent.CalendarType == "PLAYER" then
					if vEvent:IsPersonalEvent() and not vIncludePersonal then
						vSkip = true
					elseif not vEvent:IsPersonalEvent() and not vIncludePrivate then
						vSkip = true
					end
				elseif (vEvent.CalendarType == "GUILD" or vEvent.CalendarType == "GUILD_EVENT" or vEvent.CalendarType == "GUILD_ANNOUNCEMENT") and not vIncludeGuild then
					vSkip = true
				end
				
				if not vSkip then
					local vStartDate = vDate
					local vEndDate = vStartDate
					local vStartTime = GuildCalendarEvent.DateLib:ConvertHMToTime(vEvent.Hour, vEvent.Minute)
					local vEndTime
					
					if vStartTime then
						if vEvent.Duration then
							vEndTime = vStartTime + vEvent.Duration
						else
							vEndTime = vStartTime
						end
						
						if vEndTime >= GuildCalendarEvent.DateLib.cMinutesPerDay then
							vEndTime = vEndTime - GuildCalendarEvent.DateLib.cMinutesPerDay
							vEndDate = vEndDate + 1
						end
					end
					
					table.insert(vReport, "BEGIN:VEVENT")
					table.insert(vReport, "UID:GCE//"..vEvent:GetUID())
					table.insert(vReport, "SEQUENCE:1")
					table.insert(vReport, "CREATED"..self:GetDateString(vEvent:GetCreationDateTime()))
					table.insert(vReport, "DTSTART"..self:GetDateString(vStartDate, vStartTime))
					table.insert(vReport, "DTEND"..self:GetDateString(vEndDate, vEndTime))
					table.insert(vReport, "DTSTAMP"..self:GetDateString(vEvent:GetModifiedDateTime()))
					table.insert(vReport, "SUMMARY:"..self:EncodeParam(vEvent.Title))
					table.insert(vReport, "DESCRIPTION:"..self:EncodeParam(vEvent.Description))
					table.insert(vReport, "LOCATION:"..self:EncodeParam(vEvent:GetLocation()))
					table.insert(vReport, "ORGANIZER;"..self:GetPlayerCN(vEvent.OwnersName, vEvent.RealmName))
					if vStartTime then
						table.insert(vReport, "TRANSP:OPAQUE")
					end
					
					--[[
					STATUS:CONFIRMED
					ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;CN=Gi
					 zmodo:mailto:gizmodo@thorium_brotherhood.wobbleworks.com
					ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=Sumitr
					 a:mailto:sumitra@thorium_brotherhood.wobbleworks.com
					]]
					table.insert(vReport, "END:VEVENT")
				end
			end
		end
	end
	
	table.insert(vReport, "END:VCALENDAR")
	
	return vReport
end

function GuildCalendarEvent.iCal:GetPlayerCN(pName, pRealm)
	return string.format("CN=%s:mailto:%s@%s.worldofwarcraft", pName, pName:lower(), pRealm:lower():gsub(" ", "_"))
end

function GuildCalendarEvent.iCal:GetDateString(pDate, pTime)
	if not pTime then
		local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(pDate)
		return string.format(";VALUE=DATE:%04d%02d%02d", vYear, vMonth, vDay)
	end
	
	local vTime = pTime + GuildCalendarEvent.DateLib:GetServerUTCOffset()
	local vDate
	
	if vTime < 0 then
		vDate = pDate - 1
		vTime = vTime + GuildCalendarEvent.DateLib.cMinutesPerDay
	elseif vTime >= GuildCalendarEvent.DateLib.cMinutesPerDay then
		vDate = pDate + 1
		vTime = vTime - GuildCalendarEvent.DateLib.cMinutesPerDay
	else
		vDate = pDate
	end
	
	local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vDate)
	local vHour, vMinute = GuildCalendarEvent.DateLib:ConvertTimeToHM(vTime)
		
	return string.format(":%04d%02d%02dT%02d%02d00Z", vYear, vMonth, vDay, vHour, vMinute)
end

GuildCalendarEvent.iCal.EscapedChar =
{
	["\\"] = "\\\\",
	["\""] = "\\\"",
	[";"] = "\\;",
	[":"] = "\\:",
	[","] = "\\,",
	["\r"] = "",
	["\n"] = "\\n",
}

function GuildCalendarEvent.iCal:EncodeParam(pParam)
	if not pParam then
		return ""
	end
	
	return pParam:gsub("([\";:,\r\n])", self.EscapedChar)
end

--[[
	local vCompiledSchedule = GuildCalendarEvent.Database.GetCompiledScheduleRange(GuildCalendarEvent.Calendar.ActualDate - 30, GuildCalendarEvent.Calendar.ActualDate + 30, false, true)
	
	for vEventIndex, vCompiledEvent in ipairs(vCompiledSchedule) do
		local vEventInfo = GuildCalendarEvent.EventInfoByID[vCompiledEvent.mEvent.mType]
		
		vReport:AddLine("BEGIN:VEVENT")
		vReport:AddLine("UID:wobbleworks.com//GC//"..vCompiledEvent.mRealm.."//"..vCompiledEvent.mOwner.."//"..vCompiledEvent.mEvent.mID)
		vReport:AddLine("SEQUENCE:"..vCompiledEvent.mDatabase.Revision)
		vReport:AddLine("CLASS:PUBLIC")
		
		CREATED:20080818T000000Z
		DTSTART:20080818T030000Z
		DTEND:20080818T050000Z
		DTSTAMP:20080819T195132Z
		SUMMARY:Zul'Aman
		DESCRIPTION:Zul'Aman will start at 7:30\, but may start late if people can'
		 t make it that early
		LOCATION:Zul'Aman
		STATUS:CONFIRMED
		ORGANIZER;CN=Tiae:mailto:tiae@thorium_brotherhood.worldofwarcraft
		ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;CN=Gi
		 zmodo:mailto:gizmodo@thorium_brotherhood.wobbleworks.com
		ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=Sumitr
		 a:mailto:sumitra@thorium_brotherhood.wobbleworks.com
		TRANSP:OPAQUE

		vReport:AddLine("END:VEVENT")
	end
	
	vReport:AddLine("END:VCALENDAR")
end
]]

----------------------------------------
GuildCalendarEvent._ReportWindow = {}
----------------------------------------

GuildCalendarEvent._ReportWindow.ContentMargin = {Left = 5, Top = 5, Right = 5, Bottom = 5}

function GuildCalendarEvent._ReportWindow:New()
	return GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._FloatingWindow)
end

function GuildCalendarEvent._ReportWindow:Construct()
	self:SetTitle("iCal Export")
	self:SetWidth(350)
	self:SetHeight(500)
	
	self:SetPoint("TOP", UIParent, "CENTER", 0, 300)
	
	self.ScrollingEditBox = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingEditBox, self)
	self.ScrollingEditBox:SetPoint("TOPLEFT", self, "TOPLEFT", self.ContentMargin.Left, -self.ContentMargin.Top)
	self.ScrollingEditBox:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -self.ContentMargin.Right, self.ContentMargin.Bottom)
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	
	self.Cancel = self.Close
	
	self:Hide()
end

function GuildCalendarEvent._ReportWindow:ShowReport(pReportFunction, pReportParam)
	self.ReportFunction = pReportFunction
	self.ReportParam = pReportParam
	
	self:Show()
end

function GuildCalendarEvent._ReportWindow:OnShow()
	self.ReportFunction(self.ReportParam, "NEW")
	self:Refresh()
end

function GuildCalendarEvent._ReportWindow:OnHide()
	if self.ReportFunction then
		self.ReportFunction(self.ReportParam, "DELETE")
		self.ReportFunction = nil
		self.ReportParam = nil
	end
end

function GuildCalendarEvent._ReportWindow:Refresh()
	if not self:IsVisible()
	or not self.ReportFunction then
		return
	end
	
	self.ScrollingEditBox.EditBox:SetText("")
	
	local vText = self.ReportFunction(self.ReportParam, "GETTEXT")
	
	if type(vText) == "table" then
		vText = table.concat(vText, "\r\n")
	end
	
	local vLength = string.len(vText)
	local vChunkMaxLength = 200
	local vStartPos = 1
	
	self.ScrollingEditBox.EditBox:SetMaxLetters(vLength + 200)
	
	while vStartPos <= vLength do
		local vChunkLength = vLength - vStartPos + 1
		
		if vChunkLength > vChunkMaxLength then
			vChunkLength = vChunkMaxLength
		end
		
		local vChunkText = string.sub(vText, vStartPos, vStartPos + vChunkLength - 1)
		
		self.ScrollingEditBox.EditBox:HighlightText(vStartPos)
		self.ScrollingEditBox.EditBox:Insert(vChunkText)
		
		vStartPos = vStartPos + vChunkLength
	end
	
	self.ScrollingEditBox.EditBox:SetFocus()
	self.ScrollingEditBox.EditBox:HighlightText(0)
end

