----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unuauthorized redistribution is prohibited
----------------------------------------

GuildCalendarEvent_Data = nil

function GuildCalendarEvent:Initialize()
	-- Not sure if I still need MonitorCalendarAPIRecursion, so I'm disabling it to see what happens
	-- GuildCalendarEvent:MonitorCalendarAPIRecursion()
	
	GuildCalendarEvent.EventLib:UnregisterEvent("PLAYER_ENTERING_WORLD", GuildCalendarEvent.Initialize, GuildCalendarEvent)
	
	if not self.WoWCalendar then
		self.WoWCalendar = GuildCalendarEvent:New(self._WoWCalendar)
	end
	
	GuildCalendarEvent:InitializeData()
	
	self:InitializeRealm()
	self:InitializeCharacter()
	self.Alts = GuildCalendarEvent:New(GuildCalendarEvent._Alts)
	self.WhisperLog = GuildCalendarEvent:New(GuildCalendarEvent._WhisperLog)
	
	self:InitializeCalendars()

	self:InitializeTradeskill()
	
	self:InstallSlashCommand()
	
	-- Queue a command to start loading the calendar data
	
	self.SchedulerLib:ScheduleTask(5, function ()
		local _, vMonth, vDay, vYear = GuildCalendarEvent.WoWCalendar:CalendarGetDate()
		
		GuildCalendarEvent.WoWCalendar:CalendarSetAbsMonth(vMonth, vYear)
		OpenCalendar()
	end)
	
	--
	
	self.MessageFrame = GuildCalendarEvent:New(GuildCalendarEvent._MessageFrame)
	
	GameTimeFrame:SetScript("OnEnter", function (...) self:GameTimeFrame_OnEnter(...) end)
	GameTimeFrame:SetScript("OnUpdate", function (...) self:GameTimeFrame_OnUpdate(...) end)
	
	self.EventLib:RegisterEvent("GC5_CALENDAR_CHANGED", self.CheckForNewEvents, self)
	
	-- Disable the built-in reminder glow/icon
	
	GameTimeCalendarInvitesTexture:SetTexture("")
	GameTimeCalendarInvitesGlow:SetTexture("")
	
	--
	
	self.EventLib:DispatchEvent("GuildCalendarEvent_INIT")
	self:DebugMessage("Guild Event Calendar initialized")
end

function GuildCalendarEvent:ShowTooltip(pOwnerFrame, pTitle, pDescription)
	--[[
	GameTooltip:SetOwner(pOwnerFrame, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
	GameTooltip:SetText(pTitle, 1, 1, 1)
	GameTooltip:AddLine(pDescription, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	GameTooltip:Show()
	]]
	GameTooltip_AddNewbieTip(pOwnerFrame, pTitle, 1, 1, 1, pDescription)
end

function GuildCalendarEvent:HideTooltip()
	GameTooltip:Hide()
end

function GuildCalendarEvent:FlushEventCaches()
	for _, vCalendar in pairs(self.Calendars) do
		vCalendar:FlushCaches()
	end
end

function GuildCalendarEvent:GetLatestVersionInfo()
	if not self.LatestVersionInfo then
		self.LatestVersionInfo = GuildCalendarEvent:New(GuildCalendarEvent._Version, "5.0")
	end
	
	return self.LatestVersionInfo
end

function GuildCalendarEvent:GameTimeFrame_OnEnter(pGameTimeFrame)
	local vDate, vTime, vMonth, vDay, vYear = self.DateLib:GetServerDateTime()
	local vEvents = self:GetDayEvents(vMonth, vDay, vYear)
	local vLocalDate, vLocalTime = self.DateLib:GetLocalDateTime()
	
	local vDateString, vTimeString
	
	if GuildCalendarEvent.Clock.Data.ShowLocalTime then
		vDateString = GuildCalendarEvent.DateLib:GetLongDateString(vLocalDate, true)
		vTimeString = GuildCalendarEvent.DateLib:GetShortTimeString(vLocalTime, true).." "..GuildCalendarEvent.cServerTimeNote:format(GuildCalendarEvent.DateLib:GetShortTimeString(vTime, true))
	else
		vDateString = GuildCalendarEvent.DateLib:GetLongDateString(vDate, true)
		vTimeString = GuildCalendarEvent.DateLib:GetShortTimeString(vTime, true).." "..GuildCalendarEvent.cLocalTimeNote:format(GuildCalendarEvent.DateLib:GetShortTimeString(vLocalTime, true))
	end
	
	GameTooltip:SetOwner(pGameTimeFrame, "ANCHOR_BOTTOMLEFT")
	GameTooltip:AddDoubleLine(
			vDateString,
			vTimeString,
			NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b,
			NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GuildCalendarEvent:AddTooltipEvents(GameTooltip, vEvents, GuildCalendarEvent.Clock.Data.ShowLocalTime)
	
	GameTooltip:AddLine(GuildCalendarEvent.cMinimapButtonHint)
	GameTooltip:AddLine(GuildCalendarEvent.cMinimapButtonHint2)
	
	GameTooltip:Show()
end

function GuildCalendarEvent:GameTimeFrame_OnUpdate()
end

function GuildCalendarEvent:GetDayEvents(pMonth, pDay, pYear, pRecycleTable)
	local vEvents = pRecycleTable
	
	if vEvents then
		for vKey, _ in pairs(vEvents) do
			vEvents[vKey] = nil
		end
	end
	
	for vCalendarID, vCalendar in pairs(GuildCalendarEvent.Calendars) do
		if vCalendarID == "BLIZZARD" or vCalendarID == "PLAYER" or GuildCalendarEvent.PlayerData.Prefs.ShowAlts then
			local vCalendarDay = vCalendar:GetSchedule(pMonth, pDay, pYear)
			
			for _, vEvent in ipairs(vCalendarDay.Events) do
				if vEvent:EventIsVisible(vCalendarID == "PLAYER")
				and (self.PlayerData.Prefs.ShowLockouts or vEvent.CalendarType ~= "RAID_LOCKOUT") then
					if not vEvents then
						vEvents = {}
					end
					
					table.insert(vEvents, vEvent)
				end
			end
		end
	end
	
	if GuildCalendarEvent.Clock.Data.ShowLocalTime then
		local vDay2Offset
		
		if GuildCalendarEvent.DateLib:GetServerToLocalOffset() < 0 then
			vDay2Offset = 1
		else
			vDay2Offset = -1
		end
		
		local vMonth2, vDay2, vYear2 = GuildCalendarEvent.DateLib:ConvertDateToMDY(GuildCalendarEvent.DateLib:ConvertMDYToDate(pMonth, pDay, pYear) + vDay2Offset)
		
		for vCalendarID, vCalendar in pairs(GuildCalendarEvent.Calendars) do
			local vCalendarDay = vCalendar:GetSchedule(vMonth2, vDay2, vYear2)
			
			for _, vEvent in ipairs(vCalendarDay.Events) do
				if vEvent:EventIsVisible(vCalendarID == "PLAYER")
				and (self.PlayerData.Prefs.ShowLockouts or vEvent.CalendarType ~= "RAID_LOCKOUT") then
					if not vEvents then
						vEvents = {}
					end
					
					table.insert(vEvents, vEvent)
				end
			end
		end
	end
	
	if vEvents then
		table.sort(vEvents, GuildCalendarEvent.CompareEventTimes)

		-- Prune out events outside the range if we're using local date/times
		
		if GuildCalendarEvent.Clock.Data.ShowLocalTime then
			local vNumEvents = #vEvents
			local vIndex = 1
			
			while vIndex <= vNumEvents do
				local vEvent = vEvents[vIndex]
				local vLocalDate, vLocalTime = GuildCalendarEvent.DateLib:GetLocalDateTimeFromServerDateTime(GuildCalendarEvent.DateLib:ConvertMDYToDate(vEvent.Month, vEvent.Day, vEvent.Year), GuildCalendarEvent.DateLib:ConvertHMToTime(vEvent.Hour, vEvent.Minute))
				local vLocalMonth, vLocalDay, vLocalYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vLocalDate)
				
				if vLocalMonth ~= pMonth
				or vLocalDay ~= pDay
				or vLocalYear ~= pYear then
					table.remove(vEvents, vIndex)
					vNumEvents = vNumEvents - 1
				else
					vIndex = vIndex + 1
				end
			end
		end
	end
	
	return vEvents
end

function GuildCalendarEvent:CanCreateEventOnDate(pMonth, pDay, pYear)
	return self:IsTodayOrLater(pMonth, pDay, pYear)
	   and not self:IsAfterMaxCreateDate(pMonth, pDay, pYear)
end

function GuildCalendarEvent:IsTodayOrLater(pMonth, pDay, pYear)
	local _, vMonth, vDay, vYear = GuildCalendarEvent.WoWCalendar:CalendarGetDate()
	
	if pYear > vYear then
		return true
	elseif pYear < vYear then
		return false
	elseif pMonth > vMonth then
		return true
	elseif pMonth < vMonth then
		return false
	else
		return pDay >= vDay
	end
end

function GuildCalendarEvent:IsAfterMaxCreateDate(pMonth, pDay, pYear)
	local _, vMonth, vDay, vYear = GuildCalendarEvent.WoWCalendar:CalendarGetMaxCreateDate()
	
	if pYear > vYear then
		return true
	elseif pYear < vYear then
		return false
	elseif pMonth > vMonth then
		return true
	elseif pMonth < vMonth then
		return false
	else
		return pDay > vDay
	end
end

----------------------------------------
-- Utilities
----------------------------------------

function GuildCalendarEvent:ReverseTable(pTable)
	local vTable = {}
	
	for vKey, vValue in pairs(pTable) do
		vTable[vValue] = vKey
	end
	
	return vTable
end

function GuildCalendarEvent:SetEditBoxAutoCompleteText(pEditBox, pText)
	local vEditBoxText = pEditBox:GetText():upper()
	local vEditBoxTextLength = vEditBoxText:len()
	
	pEditBox:SetText(pText)
	pEditBox:HighlightText(vEditBoxTextLength, -1)
end

GuildCalendarEvent.cDeformat =
{
	s = "(.-)",
	d = "(-?[%d]+)",
	f = "(-?[%d%.e%+%-]+)",
	g = "(-?[%d%.]+)",
	["%"] = "%%",
}

function GuildCalendarEvent:ConvertFormatStringToSearchPattern(pFormat)
	local vFormat = pFormat:gsub(
			"[%[%]%.]",
			function (pChar) return "%"..pChar end)
	
	return vFormat:gsub(
			"%%[%-%d%.]-([sdgf%%])",
			self.cDeformat)
end

function GuildCalendarEvent:FormatItemList(pList)
	local vNumItems = #pList
	
	if vNumItems == 0 then
		return ""
	elseif vNumItems == 1 then
		return string.format(self.cSingleItemFormat, pList[1])
	elseif vNumItems == 2 then
		return string.format(self.cTwoItemFormat, pList[1], pList[2])
	else
		local vStartIndex, vEndIndex, vPrefix, vRepeat, vSuffix = string.find(self.cMultiItemFormat, "(.*){{(.*)}}(.*)")
		local vResult
		local vParamIndex = 1
		
		if vPrefix and string.find(vPrefix, "%%") then
			vResult = string.format(vPrefix, pList[1])
			vParamIndex = 2
		else
			vResult = vPrefix or ""
		end
		
		if vRepeat then
			for vIndex = vParamIndex, vNumItems - 1 do
				vResult = vResult..string.format(vRepeat, pList[vIndex])
			end
		end
			
		if vSuffix then
			vResult = vResult..string.format(vSuffix, pList[vNumItems])
		end
		
		return vResult
	end
end

function GuildCalendarEvent:Reset()
	GuildCalendarEvent_Data = nil
	ReloadUI()
end

function GuildCalendarEvent:ConfirmDelete(pMessage, pParam, pConfirmFunc)
	if not StaticPopupDialogs.GC5_CONFIRM_DELETE then
		StaticPopupDialogs.GC5_CONFIRM_DELETE =
		{
			preferredIndex = 3,
			text = "",
			button1 = DELETE,
			button2 = CANCEL,
			OnAccept = nil,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		}
	end
	StaticPopupDialogs.GC5_CONFIRM_DELETE.text = pMessage
	StaticPopupDialogs.GC5_CONFIRM_DELETE.OnAccept = pConfirmFunc
	StaticPopup_Show("GC5_CONFIRM_DELETE", pParam)
end

----------------------------------------
-- /cal
----------------------------------------

function GuildCalendarEvent:InstallSlashCommand()
	SlashCmdList.CAL = function (...) GuildCalendarEvent:ExecuteCommand(...) end
	SLASH_CAL1 = "/cal"
end

function GuildCalendarEvent:ExecuteCommand(pCommandString, ...)
	local _, _, vCommand, vParameter = string.find(pCommandString, "([^%s]+)%s*(.*)")
	local vCommandFunc = self.Commands[strlower(vCommand or "help")] or self.Commands.help
	
	vCommandFunc(self, vParameter)
end

GuildCalendarEvent.CommandHelp =
{
	GuildCalendarEvent.cHelpHeader,
	HIGHLIGHT_FONT_COLOR_CODE.."/cal help"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpHelp,
	HIGHLIGHT_FONT_COLOR_CODE.."/cal reset"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpReset,
	HIGHLIGHT_FONT_COLOR_CODE.."/cal debug switch on|off"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpDebug,
}

----------------------------------------
GuildCalendarEvent.Commands = {}
----------------------------------------

function GuildCalendarEvent.Commands:help()
	for _, vString in ipairs(self.CommandHelp) do
		self:NoteMessage(vString)
	end
end

function GuildCalendarEvent.Commands:reset()
	if not StaticPopupDialogs.GC5_CONFIRM_RESET then
		StaticPopupDialogs.GC5_CONFIRM_RESET =
		{
			preferredIndex = 3,
			text = GuildCalendarEvent.cConfirmReset,
			button1 = RESET,
			button2 = CANCEL,
			OnAccept = function() GuildCalendarEvent:Reset() end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		}
	end
	StaticPopup_Show("GC5_CONFIRM_RESET")	
end

function GuildCalendarEvent.Commands:debug(pParameter)
	local _, _, vSwitch, vState = pParameter:find("([^%s]+) ?(.*)")
	
	vSwitch = vSwitch:lower()
	vState = vState:lower()
	
	if vSwitch == "off" then
		for vKey, _ in pairs(GuildCalendarEvent.Debug) do
			GuildCalendarEvent.Debug[vKey] = nil
		end
		
		GuildCalendarEvent:NoteMessage("All debug messages disabled")
	else
		GuildCalendarEvent.Debug[vSwitch] = vState == "on" or vState == "true"
		GuildCalendarEvent:NoteMessage("Debug flag %s is now set to %s", vSwitch, tostring(GuildCalendarEvent.Debug[vSwitch]))
	end
end

----------------------------------------
GuildCalendarEvent._MinimapReminder = {}
----------------------------------------

function GuildCalendarEvent._MinimapReminder:New()
	return CreateFrame("Frame", nil, GameTimeFrame)
end

function GuildCalendarEvent._MinimapReminder:Construct()
	self:SetAllPoints()
	self:SetFrameLevel(GameTimeFrame:GetFrameLevel() + 2)
	
	self.Enabled = false
	self.OnDuration = 0.4
	self.OffDuration = 0.2
	self.FadeDuration = 0.5
	self.FlashDuration = 60 * 60
	self.ShowingIcon = false
	self.Icon = nil
	--[[
	self.Texture = self:CreateTexture(nil, "BACKGROUND")
	self.Texture:SetWidth(32)
	self.Texture:SetHeight(32)
	self.Texture:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8)
	self.Texture:SetTexture("")
	]]
	self.OverlayTexture = self:CreateTexture(nil, "BORDER")
	self.OverlayTexture:SetAllPoints(true)
	self.OverlayTexture:SetTexture(GuildCalendarEvent.AddonPath.."Textures\\CalendarButton-ReminderFrame")
	self.OverlayTexture:SetTexCoord(0, 0.78125, 0, 0.78125)
	
	self.HighlightTexture = self:CreateTexture("GC5MinimapHighlight", "OVERLAY")
	self.HighlightTexture:SetBlendMode("ADD")
	self.HighlightTexture:SetAllPoints(true)
	self.HighlightTexture:SetTexture(GuildCalendarEvent.AddonPath.."Textures\\CalendarButton-Hilight")
	self.HighlightTexture:SetTexCoord(0, 0.78125, 0, 0.78125)
	
	self.HighlightTexture:Hide()
end

function GuildCalendarEvent._MinimapReminder:ShowIcon(pIcon, pTexCoords)
	--GuildCalendarEvent.Clock.Frame:SetBackground(pIcon, pTexCoords)
end

function GuildCalendarEvent._MinimapReminder:HideIcon()
	--GuildCalendarEvent.Clock.Frame:SetBackground(nil)
end

function GuildCalendarEvent._MinimapReminder:StartFlashing(pIcon, pTexCoords)
	if pIcon then
		self:ShowIcon(pIcon, pTexCoords)
	end
	
	if not self.Enabled then
		self.Enabled = true
		self:UpdateIcon()
	end
end

function GuildCalendarEvent._MinimapReminder:StopFlashing()
	self.Enabled = false
	self:UpdateIcon()
end

function GuildCalendarEvent._MinimapReminder:Stop()
	self:StopFlashing()
	self:HideIcon()
end

function GuildCalendarEvent._MinimapReminder:UpdateIcon()
	local vShowNotifyIcon = false
	
	if self.FlashAnimation then
		self.FlashAnimation:Stop()
		self.HighlightTexture:Hide()
	end
	
	if self.Enabled then
		if not self.FlashAnimation then
			self.FlashAnimation = self.HighlightTexture:CreateAnimationGroup()
			local fadeIn = self.FlashAnimation:CreateAnimation("Alpha")
			fadeIn:SetDuration(self.FadeDuration)
			fadeIn:SetFromAlpha(0)
			fadeIn:SetToAlpha(1)
			fadeIn:SetOrder(1)
			fadeIn:SetEndDelay(self.OnDuration)
			
			local fadeOut = self.FlashAnimation:CreateAnimation("Alpha")
			fadeOut:SetDuration(self.FadeDuration)
			fadeIn:SetFromAlpha(1)
			fadeIn:SetToAlpha(0)
			fadeOut:SetOrder(2)
			fadeOut:SetEndDelay(self.OffDuration)
			
			self.FlashAnimation:SetLooping("REPEAT")
		end

		self.HighlightTexture:SetAlpha(0)
		self.HighlightTexture:Show()
		self.HighlightTexture:SetVertexColor(1, 0.6, 0.2)
		
		self.FlashAnimation:Play()
		
		vShowNotifyIcon = true
	else
		self.HighlightTexture:Hide()
	end

	if vShowNotifyIcon then
		self:Show()
	else
		self:Hide()
	end
end

function GuildCalendarEvent:StartFlashingReminder()
	if not self.MinimapReminder then
		self.MinimapReminder = GuildCalendarEvent:New(GuildCalendarEvent._MinimapReminder)
	end
	
	self.MinimapReminder:StartFlashing()
end
	
function GuildCalendarEvent:StopFlashingReminder()
	if self.MinimapReminder then
		self.MinimapReminder:Stop()
	end
end

function GuildCalendarEvent:ShowReminderIcon(pIcon, pTexCoords)
	if not self.MinimapReminder then
		self.MinimapReminder = GuildCalendarEvent:New(GuildCalendarEvent._MinimapReminder)
	end
	
	self.MinimapReminder:ShowIcon(pIcon, pTexCoords)
end

function GuildCalendarEvent:HideReminderIcon()
	if self.MinimapReminder then
		self.MinimapReminder:HideIcon()
	end
end

function GuildCalendarEvent:CheckForNewEvents()
	GuildCalendarEvent.SchedulerLib:RescheduleTask(1, self.CheckForNewEventsNow, self)
end

function GuildCalendarEvent:CheckForNewEventsNow()
	local vCalendar = GuildCalendarEvent.Calendars.PLAYER
	
	for vDate, vSchedule in pairs(vCalendar.Schedules) do
		for _, vEvent in pairs(vSchedule.Events) do
			if vEvent.Unseen then
				GuildCalendarEvent:StartFlashingReminder()
				return
			end
		end
	end
	
	GuildCalendarEvent:StopFlashingReminder()
end

function GuildCalendarEvent:MarkAllEventsAsSeen()
	local vCalendar = GuildCalendarEvent.Calendars.PLAYER
	
	for vDate, vSchedule in pairs(vCalendar.Schedules) do
		for _, vEvent in pairs(vSchedule.Events) do
			vEvent.Unseen = nil
		end
	end
	
	GuildCalendarEvent:StopFlashingReminder()
end

----------------------------------------
GuildCalendarEvent._MessageFrame = {}
----------------------------------------

function GuildCalendarEvent._MessageFrame:New()
	return CreateFrame("MessageFrame", nil, UIParent)
end

function GuildCalendarEvent._MessageFrame:Construct()
	self:SetFading(true)
	self:SetFadeDuration(3)
	self:SetTimeVisible(10)
	
	self:SetInsertMode("BOTTOM")
	self:SetFrameStrata("HIGH")
	self:SetWidth(768)
	self:SetHeight(100)
	self:SetPoint("TOP", UIParent, "TOP", 0, -122)
	self:SetFontObject(PVPInfoTextFont)
	self:SetJustifyH("CENTER")
end

----------------------------------------
GuildCalendarEvent._Version = {}
----------------------------------------

GuildCalendarEvent._Version.cBuildLevelByCode =
{
	d = 4,
	a = 3,
	b = 2,
	f = 1,
}

GuildCalendarEvent._Version.cBuildCodeByLevel = GuildCalendarEvent:ReverseTable(GuildCalendarEvent._Version.cBuildLevelByCode)

function GuildCalendarEvent._Version:Construct(pString)
	if pString then
		self:FromString(pString)
	end
end

function GuildCalendarEvent._Version:FromString(pString)
	local _, _, vMajor, vMinor, vBugFix, vBuildLevelCode, vBuildNumber = string.find(pString, "[vV]?(%d+)%.(%d+)%.?(%d*)(%w?)(%d*)")
	local vBuildLevel
	
	vMajor = tonumber(vMajor)
	
	if not vMajor then
		vMajor = 0
	end
	
	vMinor = tonumber(vMinor)
	
	if not vMinor then
		vMinor = 0
	end
	
	vBugFix = tonumber(vBugFix)
	
	if not vBugFix then
		vBugFix = 0
	end
	
	if vBuildLevelCode == "" then
		vBuildLevel = 0
	else
		vBuildLevel = self.cBuildLevelByCode[vBuildLevelCode]
		
		if not vBuildLevel then
			vBuildLevel = 5
		end
	end
	
	vBuildNumber = tonumber(vBuildNumber)
	
	if not vBuildNumber then
		vBuildNumber = 0
	end
	
	self.Major = vMajor
	self.Minor = vMinor
	self.BugFix = vBugFix
	self.BuildLevel = vBuildLevel
	self.BuildNumber = vBuildNumber
end

function GuildCalendarEvent._Version:LessThan(pVersion)
	if self.Major ~= pVersion.Major then
		return self.Major < pVersion.Major
	end
	
	if self.Minor ~= pVersion.Minor then
		return self.Minor < pVersion.Minor
	end
	
	if self.BugFix ~= pVersion.BugFix then
		return self.BugFix < pVersion.BugFix
	end
	
	if self.BuildLevel ~= pVersion.BuildLevel then
		return self.BuildLevel > pVersion.BuildLevel
	end
	
	if self.BuildNumber ~= pVersion.BuildNumber then
		return self.BuildNumber < pVersion.BuildNumber
	end
	
	return false
end

function GuildCalendarEvent._Version:ToString()
	local vString = string.format("%d.%d", self.Major, self.Minor)
	
	if self.BugFix > 0 then
		vString = vString.."."..self.BugFix
	end
	
	if self.BuildLevel > 0 then
		vString = string.format("%s%s%d", vString, GuildCalendarEvent._Version.cBuildCodeByLevel[self.BuildLevel] or "?", self.BuildNumber)
	end
	
	return vString
end

----------------------------------------
-- Calendars
----------------------------------------

function GuildCalendarEvent:InitializeCalendars()
	self.Calendars = {}
	
	self.Calendars.BLIZZARD = GuildCalendarEvent:New(GuildCalendarEvent._Calendar, GuildCalendarEvent.cBlizzardOwner, "BLIZZARD", nil, false)
	
	for vRealmName, vRealmData in pairs(self.Data.Realms) do
		for vCharacterGUID, vCharacterData in pairs(vRealmData.Characters) do
			local vCalendarID, vReadOnly
			
			if vCharacterData == self.PlayerData then
				vCalendarID = "PLAYER"
				vReadOnly = false
			else
				vCalendarID = vCharacterData.GUID
				vReadOnly = true
			end
			
			self.Calendars[vCalendarID] = GuildCalendarEvent:New(GuildCalendarEvent._Calendar, vCharacterData.Name, vCalendarID, vCharacterData.Events, vReadOnly)
		end
	end
end

----------------------------------------
-- Roles
----------------------------------------

function GuildCalendarEvent:GetPlayerDefaultRoleCode(pPlayerName, pClassID)
	if not self.RealmData.DefaultRoles
	or not self.RealmData.DefaultRoles[pPlayerName] then
		if not pClassID or pClassID == "" then
			return "?"
		end
		
		if not self.ClassInfoByClassID[pClassID] then
			error(string.format("Unknown class ID %s", tostring(pClassID)))
		end
		
		return self.ClassInfoByClassID[pClassID].DefaultRole
	end
	
	return self.RealmData.DefaultRoles[pPlayerName]
end

function GuildCalendarEvent:SetPlayerDefaultRoleCode(pPlayerName, pRoleCode)
	if not self.RealmData.DefaultRoles then
		self.RealmData.DefaultRoles = {}
	end
	
	self.RealmData.DefaultRoles[pPlayerName] = pRoleCode
end

----------------------------------------
-- Event templates
----------------------------------------

function GuildCalendarEvent:AutoCompleteEventTitle(pEditBox)
	local vEditBoxText = pEditBox:GetText()
	local vUpperEditBoxText = vEditBoxText:upper()
	local vUpperEditBoxTextLen = vUpperEditBoxText:len()
	
	local vTemplate = self:FindEventTemplateByPartialTitle(vEditBoxText)
	
	if vTemplate then
		GuildCalendarEvent:SetEditBoxAutoCompleteText(pEditBox, vTemplate.Title)
		return nil, nil, vTemplate
	end
	
	for vEventType = CALENDAR_EVENTTYPE_RAID, CALENDAR_EVENTTYPE_OTHER do
		local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(vEventType)
		
		for vTextureIndex, vTextureInfo in ipairs(vEventTypeTextures) do
			local vName
			
			if vTextureInfo.DifficultyName == "" then
				vName = vTextureInfo.Name
			else
				vName = DUNGEON_NAME_WITH_DIFFICULTY:format(vTextureInfo.Name, vTextureInfo.DifficultyName)
			end
			
			if vName:upper():sub(1, vUpperEditBoxTextLen) == vUpperEditBoxText then
				GuildCalendarEvent:SetEditBoxAutoCompleteText(pEditBox, vName)
				return vEventType, vTextureIndex
			end
		end
	end
end

function GuildCalendarEvent:FindEventTemplateByTitle(pTitle)
	local vUpperTitle = pTitle:upper()
	
	for vIndex, vTemplate in ipairs(self.PlayerData.EventTemplates) do
		local vTemplateTitle = GuildCalendarEvent.WoWCalendar:CalendarGetDisplayTitle(vTemplate.CalendarType, vTemplate.SequenceType, vTemplate.Title or "")
		local vTemplateUpperTitle = vTemplateTitle:upper()
		
		if vTemplateUpperTitle == vUpperTitle then
			return vTemplate, vIndex
		end
	end
end

function GuildCalendarEvent:FindEventTemplateByPartialTitle(pTitle)
	if not self.PlayerData.EventTemplates then
		return
	end
	
	local vUpperTitle = pTitle:upper()
	local vUpperTitleLen = vUpperTitle:len()
	
	for vIndex, vTemplate in ipairs(self.PlayerData.EventTemplates) do
		local vTemplateTitle = GuildCalendarEvent.WoWCalendar:CalendarGetDisplayTitle(vTemplate.CalendarType, vTemplate.SequenceType, vTemplate.Title or "")
		local vTemplateUpperTitle = vTemplateTitle:upper()
		
		if vTemplateUpperTitle:sub(1, vUpperTitleLen) == vUpperTitle then
			return vTemplate, vIndex
		end
	end
end

function GuildCalendarEvent:FindEventTemplateByEvent(pEvent)
	if not self.PlayerData.EventTemplates then
		return
	end
	
	for vIndex, vTemplate in ipairs(self.PlayerData.EventTemplates) do
		if pEvent.CalendarType == vTemplate.CalendarType
		and pEvent.EventType == vTemplate.EventType
		and pEvent.TitleTag == vTemplate.TitleTag
		and pEvent.TextureIndex == vTemplate.TextureIndex then
			if not vTemplate.Title then
				vTemplate.Title = "" -- Fix missing Title field
			end
			
			return vTemplate, vIndex
		end
	end
end

GuildCalendarEvent.EventTemplateFields =
{
	Hour = true,
	Minute = true,
	Second = true,
	
	Limits = true,
	CalendarType = true,
	Description = true,
	DescriptionTag = true,
	Title = true,
	TitleTag = true,
	TextureIndex = true,
	TextureID = true,
	EventType = true,
	MinLevel = true,
	MaxLevel = true,
	
	Attendance = true,
}

function GuildCalendarEvent:SaveEventTemplate(pEvent)
	-- Remove any existing template
	
	if self.PlayerData.EventTemplates then
		local _, vIndex = self:FindEventTemplateByEvent(pEvent)
		
		if vIndex then
			table.remove(self.PlayerData.EventTemplates, vIndex)
		end
	else
		self.PlayerData.EventTemplates = {}
	end
	
	-- Make a deep duplicate of the event
	
	local vTemplate = {}
	
	for vField, _ in pairs(GuildCalendarEvent.EventTemplateFields) do
		if type(pEvent[vField]) == "table" then
			vTemplate[vField] = GuildCalendarEvent:DuplicateTable(pEvent[vField], true)
		else
			vTemplate[vField] = pEvent[vField]
		end
	end
	
	-- Change all attendance to "invited" in the template
	
	if vTemplate.Attendance then
		for _, vInfo in pairs(vTemplate.Attendance) do
			vInfo.InviteStatus = self.CALENDAR_INVITESTATUS_INVITED
		end
	end
	
	-- Eliminate fields we want ignored
	
	vTemplate.Year = nil
	vTemplate.Month = nil
	vTemplate.Day = nil
	
	vTemplate.CacheUpdateDate = nil
	vTemplate.CacheUpdateTime = nil
	
	vTemplate.Group = nil
	
	-- Ensure required fields are present
	
	if not vTemplate.Title then
		vTemplate.Title = ""
	end
	
	-- Save the template at the front of the list to give it
	-- higher priority next time around
	
	table.insert(self.PlayerData.EventTemplates, 1, vTemplate)
end

----------------------------------------
-- Database repairs/upgrades
----------------------------------------

function GuildCalendarEvent:InitializeData()
	-- Purge the data if the user is downgrading from a newer build
	
	if GuildCalendarEvent_Data then
		local vThisVersion = GuildCalendarEvent:New(GuildCalendarEvent._Version, GuildCalendarEvent.cVersionString)
		local vLastVersion = GuildCalendarEvent:New(GuildCalendarEvent._Version, GuildCalendarEvent_Data.LastVersion)
		
		if not GuildCalendarEvent_Data.LastVersion
		or vThisVersion:LessThan(vLastVersion) then -- Downgrading, purge the old data
			GuildCalendarEvent_Data = nil
		end
	end
	
	-- Initialize the data
	
	if not GuildCalendarEvent_Data
	or not GuildCalendarEvent_Data.LastVersion then
		GuildCalendarEvent_Data =
		{
			Realms = {},
			Prefs = {},
			Debug = {},
			LastVersion = GuildCalendarEvent.cVersionString,
		}
	end
	
	-- Perform repairs and upgrades
	
	-- Done
	
	self.Debug = GuildCalendarEvent_Data.Debug
	self.Data = GuildCalendarEvent_Data
	
	GuildCalendarEvent_Data.LastVersion = GuildCalendarEvent.cVersionString
end

----------------------------------------
-- Running event
----------------------------------------

function GuildCalendarEvent:GetEventElapsedSeconds(pEvent)
	local vEvent = pEvent.OriginalEvent or pEvent
	local vElapsed = vEvent.ElapsedSeconds or 0
	
	if self.RunningEvent == pEvent then
		local vDate, vTime60 = GuildCalendarEvent.DateLib:GetServerDateTime60()
		
		vElapsed = vElapsed + (vDate * GuildCalendarEvent.DateLib.cSecondsPerDay + vTime60)
					        - (vEvent.StartDate * GuildCalendarEvent.DateLib.cSecondsPerDay + vEvent.StartTime60)
	end
	
	return vElapsed
end

function GuildCalendarEvent:StartEvent(pEvent, pNotificationFunc)
	if self.RunningEvent then
		self:StopEvent(self.RunningEvent)
	end
	
	self.RunningEvent = pEvent
	
	local vEvent = self.RunningEvent.OriginalEvent or self.RunningEvent
	
	if not vEvent.StartDate then
		vEvent.StartDate, vEvent.StartTime60 = GuildCalendarEvent.DateLib:GetServerDateTime60()
	end
	
	GuildCalendarEvent.EventLib:RegisterEvent("MC2RAIDLIB_RAID_CHANGED", self.EventRaidChanged, self)
	
	GuildCalendarEvent.EventLib:DispatchEvent("GC5_EVENT_START", self.RunningEvent)
	
	self:EventRaidChanged()
	
	self.RaidInvites = GuildCalendarEvent:New(GuildCalendarEvent._RaidInvites)
	self.RaidInvites:BeginInvites(pEvent.Title, true, pNotificationFunc)
end

function GuildCalendarEvent:StopEvent()
	if not self.RunningEvent then
		return
	end
	
	self.RaidInvites:EndInvites()
	self.RaidInvites = nil
	
	local vSavedRunningEvent = self.RunningEvent
	local vEvent = self.RunningEvent.OriginalEvent or self.RunningEvent
	
	vEvent.ElapsedSeconds = self:GetEventElapsedSeconds(self.RunningEvent)
	vEvent.StartDate, vEvent.StartTime60 = nil, nil
	
	self.RunningEvent = nil
	
	GuildCalendarEvent.EventLib:UnregisterEvent("MC2RAIDLIB_RAID_CHANGED", self.EventRaidChanged, self)
	
	GuildCalendarEvent.EventLib:DispatchEvent("GC5_EVENT_STOP")
	
	GuildCalendarEvent.BroadcastLib:Broadcast(vSavedRunningEvent, "INVITES_CHANGED")
end

function GuildCalendarEvent:RestartEvent(pEvent)
	if pEvent == self.RunningEvent then
		self:StopEvent()
	end
	
	local vEvent = pEvent.OriginalEvent or pEvent
	
	pEvent.Group = nil
	vEvent.Group = nil
	vEvent.StartDate = nil
	vEvent.StartTime60 = nil
	vEvent.ElapsedSeconds = nil
	
	for vName, vPlayerInfo in pairs(vEvent:GetAttendance()) do
		vPlayerInfo.RaidInviteStatus = nil
	end
	
	GuildCalendarEvent.BroadcastLib:Broadcast(pEvent, "INVITES_CHANGED")
end

function GuildCalendarEvent:EventRaidChanged()
	if not self.RunningEvent.Group then
		self.RunningEvent.Group = {}
		
		if self.RunningEvent.OriginalEvent then
			self.RunningEvent.OriginalEvent.Group = self.RunningEvent.Group
		end
	else
		for _, vMemberInfo in pairs(self.RunningEvent.Group) do
			vMemberInfo.LeftGroup = true
		end
	end
	
	for vMemberName, vPlayerInfo in pairs(GuildCalendarEvent.RaidLib.PlayersByName) do
		local vMemberInfo = self.RunningEvent.Group[vMemberName]
		
		if not vMemberInfo then
			self.RunningEvent.Group[vMemberName] = GuildCalendarEvent:DuplicateTable(vPlayerInfo, true)
		else
			vMemberInfo.LeftGroup = nil
			
			for vKey, vValue in pairs(vPlayerInfo) do
				vMemberInfo[vKey] = vValue
			end
		end
	end
	
	GuildCalendarEvent.BroadcastLib:Broadcast(self.RunningEvent, "INVITES_CHANGED")
end

----------------------------------------
-- Initialize after saved variables are loaded
----------------------------------------

GuildCalendarEvent.EventLib:RegisterEvent("PLAYER_ENTERING_WORLD", GuildCalendarEvent.Initialize, GuildCalendarEvent)
