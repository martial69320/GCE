----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

local _

GuildCalendarEvent.cBlizzardCalendarFunctionNames =
{
	"CalendarAddEvent",
	"CalendarCanAddEvent",
	"CalendarCanSendInvite",
	"CalendarCloseEvent",
	"CalendarContextEventCanComplain",
	"CalendarContextEventCanEdit",
	"CalendarContextEventClipboard",
	"CalendarContextEventComplain",
	"CalendarContextEventCopy",
	"CalendarContextEventIsGuildWide",
	"CalendarContextInviteAvailable",
	"CalendarContextInviteDecline",
	"CalendarContextInviteRemove",
	"CalendarContextInviteTentative",
	"CalendarContextEventPaste",
	"CalendarContextEventRemove",
	"CalendarContextEventSignUp",
	"CalendarContextInviteIsPending",
	"CalendarContextInviteStatus",
	"CalendarContextSelectEvent",
	"CalendarDefaultGuildFilter",
	"CalendarEventAvailable",
	"CalendarEventCanEdit",
	"CalendarEventClearAutoApprove",
	"CalendarEventClearLocked",
	"CalendarEventClearModerator",
	"CalendarEventDecline",
	"CalendarEventGetInvite",
	"CalendarEventGetInviteResponseTime",
	"CalendarEventGetInviteSortCriterion",
	"CalendarEventGetNumInvites",
	"CalendarEventGetRepeatOptions",
	"CalendarEventGetSelectedInvite",
	"CalendarEventGetStatusOptions",
	"CalendarEventGetTextures",
	"CalendarEventGetTypes",
	"CalendarEventHasPendingInvite",
	"CalendarEventHaveSettingsChanged",
	"CalendarEventInvite",
	"CalendarEventIsGuildWide",
	"CalendarEventRemoveInvite",
	"CalendarEventSelectInvite",
	"CalendarEventSetAutoApprove",
	"CalendarEventSetDate",
	"CalendarEventSetDescription",
	"CalendarEventSetLocked",
	"CalendarEventSetLockoutDate",
	"CalendarEventSetLockoutTime",
	"CalendarEventSetModerator",
	"CalendarEventSetRepeatOption",
	"CalendarEventSetSize",
	"CalendarEventSetStatus",
	"CalendarEventSetTextureID",
	"CalendarEventSetTime",
	"CalendarEventSetTitle",
	"CalendarEventSetType",
	"CalendarEventSortInvites",
	"CalendarEventSignUp",
	"CalendarEventTentative",
	"CanSendInvite",
	"CalendarGetAbsMonth",
	"CalendarGetDate",
	"CalendarGetDay",
	"CalendarGetDayEvent",
	"CalendarGetEventIndex",
	"CalendarGetEventInfo",
	"CalendarGetFirstPendingInvite",
	"CalendarGetHolidayInfo",
	"CalendarGetMaxCreateDate",
	"CalendarGetMinDate",
	"CalendarGetMonth",
	"CalendarGetNumDayEvents",
	"CalendarGetNumPendingInvites",
	"CalendarGetRaidInfo",
	"CalendarIsActionPending",
	"CalendarMassInviteGuild",
	"CalendarNewArenaTeamEvent",
	"CalendarNewEvent",
	"CalendarNewGuildEvent",
	"CalendarNewGuildAnnouncement",
	"CalendarOpenEvent",
	"CalendarRemoveEvent",
	"CalendarSetAbsMonth",
	"CalendarSetMonth",
	"CalendarUpdateEvent",
}

-- Invite Statuses

GuildCalendarEvent.CALENDAR_EVENTCOLOR_MODERATOR = {r = 0.54, g = 0.75, b = 1.0}

GuildCalendarEvent.CALENDAR_INVITESTATUS_COLORS =
{
	[CALENDAR_INVITESTATUS_CONFIRMED]     = GREEN_FONT_COLOR,
	[CALENDAR_INVITESTATUS_ACCEPTED]      = {r = 0.6, g = 1, b = 1},
	[CALENDAR_INVITESTATUS_TENTATIVE]     = ORANGE_FONT_COLOR,
	[CALENDAR_INVITESTATUS_DECLINED]      = GRAY_FONT_COLOR,
	[CALENDAR_INVITESTATUS_OUT]           = RED_FONT_COLOR,
	[CALENDAR_INVITESTATUS_STANDBY]       = YELLOW_FONT_COLOR,
	[CALENDAR_INVITESTATUS_INVITED]       = NORMAL_FONT_COLOR,
	[CALENDAR_INVITESTATUS_SIGNEDUP]      = {r = 0.6, g = 1, b = 1},
	[CALENDAR_INVITESTATUS_NOT_SIGNEDUP]  = NORMAL_FONT_COLOR,
}

GuildCalendarEvent.CALENDAR_INVITESTATUS_COLOR_CODES = {}

for vKey, vColor in pairs(GuildCalendarEvent.CALENDAR_INVITESTATUS_COLORS) do
	GuildCalendarEvent.CALENDAR_INVITESTATUS_COLOR_CODES[vKey] = string.format("|cff%02x%02x%02x", vColor.r * 255 + 0.5, vColor.g * 255 + 0.5, vColor.b * 255 + 0.5)
end

GuildCalendarEvent.CALENDAR_INVITESTATUS_NAMES =
{
	[CALENDAR_INVITESTATUS_CONFIRMED]    = CALENDAR_STATUS_CONFIRMED,
	[CALENDAR_INVITESTATUS_ACCEPTED]     = CALENDAR_STATUS_ACCEPTED,
	[CALENDAR_INVITESTATUS_TENTATIVE]    = CALENDAR_STATUS_TENTATIVE,
	[CALENDAR_INVITESTATUS_DECLINED]     = CALENDAR_STATUS_DECLINED,
	[CALENDAR_INVITESTATUS_OUT]          = CALENDAR_STATUS_OUT,
	[CALENDAR_INVITESTATUS_STANDBY]      = CALENDAR_STATUS_STANDBY,
	[CALENDAR_INVITESTATUS_INVITED]      = CALENDAR_STATUS_INVITED,
	[CALENDAR_INVITESTATUS_SIGNEDUP]     = CALENDAR_STATUS_SIGNEDUP,
	[CALENDAR_INVITESTATUS_NOT_SIGNEDUP] = nil,
}

GuildCalendarEvent.CALENDAR_CALENDARTYPE_COLORS =
{
--	["PLAYER"]				= ,
--	["GUILD_ANNOUNCEMENT"]	= ,
--	["GUILD_EVENT"]			= ,
	["SYSTEM"]				= {r=1.0, g=1.0, b=0.6},
	["HOLIDAY"]				= HIGHLIGHT_FONT_COLOR,
	["RAID_LOCKOUT"]		= NORMAL_FONT_COLOR,
	["RAID_RESET"]			= HIGHLIGHT_FONT_COLOR,
}

GuildCalendarEvent.EVENT_MAX_TITLE_LENGTH = 31
GuildCalendarEvent.EVENT_MAX_DESCRIPTION_LENGTH = 255

----------------------------------------
GuildCalendarEvent._Calendar = {}
----------------------------------------

GuildCalendarEvent._Calendar.cMaxHistory = 14

function GuildCalendarEvent._Calendar:Construct(pOwnersName, pCalendarID, pCalendarData, pReadOnly)
	self.OwnersName = pOwnersName
	self.CalendarID = pCalendarID
	self.CalendarData = pCalendarData
	self.ReadOnly = pReadOnly
	
	self.Schedules = {}
	
	-- Add the method table to all of the events in the calendar
	
	local vMetaTable = (pReadOnly and GuildCalendarEvent._CachedEventMetaTable) or GuildCalendarEvent._APIEventMetaTable
	
	if self.CalendarData then
		for vDate, vEvents in pairs(self.CalendarData) do
			for _, vEvent in ipairs(vEvents) do
				setmetatable(vEvent, vMetaTable)
			end
		end
	end
	
	--
	
	if not self.ReadOnly then
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST", self.CalendarUpdateEventList, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CVAR_UPDATE", self.CVarUpdate, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", self.Synchronize, self)
	end
	
	-- Install event monitoring to aid in debugging
	--[[
	if pCalendarID == "PLAYER" then
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_OPEN_EVENT", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_CLOSE_EVENT", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_EVENT", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_INVITE_LIST", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("GC5_EVENT_CHANGED", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("GC5_CALENDAR_CHANGED", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_ACTION_PENDING", self.DebugEvents, self)
		GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_NEW_EVENT", self.DebugEvents, self)
	end
	]]
end

function GuildCalendarEvent._Calendar:DebugEvents(pEventID, ...)
	if GuildCalendarEvent.Debug.events then
		local vParam = select(1, ...) or ""
		
		GuildCalendarEvent:DebugMessage("Calendar:DebugEvents: %s%s: %s", GREEN_FONT_COLOR_CODE, pEventID, tostring(vParam))
	end
end

function GuildCalendarEvent._Calendar:CalendarUpdateEventList()
	GuildCalendarEvent.BlizzardCalendarReady = true
	self:FlushCaches()
end

function GuildCalendarEvent._Calendar:GetSelectedEvent()
	if GuildCalendarEvent.WoWCalendar.OpenedEvent then
		return GuildCalendarEvent.WoWCalendar.OpenedEvent
	end
	
	if not self.CalendarData then
		return
	end
	
	local vDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(
						GuildCalendarEvent.WoWCalendar.SelectedEventMonth,
						GuildCalendarEvent.WoWCalendar.SelectedEventDay,
						GuildCalendarEvent.WoWCalendar.SelectedEventYear)
	local vEvents = self.CalendarData[vDate]
	
	if not vEvents then
		return
	end
	
	for _, vEvent in ipairs(vEvents) do
		if vEvent.Index == GuildCalendarEvent.WoWCalendar.SelectedEventIndex then
			return vEvent
		end
	end
end

function GuildCalendarEvent._Calendar:FlushCaches()
	if self.ReadOnly then
		return
	end
	
	if self.CalendarID ~= "PLAYER" then
		for vDate, vSchedule in pairs(self.Schedules) do
			self.Schedules[vDate] = nil
		end
	else
		self:Synchronize()
	end
	
	GuildCalendarEvent.EventLib:DispatchEvent("GC5_CALENDAR_CHANGED")
end

function GuildCalendarEvent._Calendar:CVarUpdate(pName, pValue)
	if pName == "calendarShowDarkmoon"
	or pName == "calendarShowWeeklyHolidays"
	or pName == "calendarShowBattlegrounds" then
		self:FlushCaches()
	end
end

function GuildCalendarEvent._Calendar:GetSchedule(pMonth, pDay, pYear)
	if not pMonth or not pDay or not pYear then
		error("GetSchedule: month, day and year expected")
	end
	
	local vDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(pMonth, pDay, pYear)
	local vSchedule = self.Schedules[vDate]
	
	if not vSchedule then
		vSchedule = GuildCalendarEvent:New(GuildCalendarEvent._CalendarDay, self.OwnersName, self.CalendarID, self.CalendarData, self.ReadOnly)
		vSchedule:SetDate(pMonth, pDay, pYear)
		self.Schedules[vDate] = vSchedule
	end
	
	return vSchedule
end

function GuildCalendarEvent._Calendar:GetLocalSchedule(pMonth, pDay, pYear)
	
end

function GuildCalendarEvent._Calendar:Synchronize()
	_, self.CurrentMonth, self.CurrentDay, self.CurrentYear = GuildCalendarEvent.WoWCalendar:CalendarGetDate()
	self.CurrentDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.CurrentMonth, self.CurrentDay, self.CurrentYear)
	
	local vCutoffDate = self.CurrentDate - self.cMaxHistory
	
	-- Mark the schedules so we can tell which ones don't get used
	
	for vDate, vSchedule in pairs(self.Schedules) do
		vSchedule.Unused = true
	end
	
	for vDate = vCutoffDate, self.CurrentDate + 365 do
		local vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vDate)
		
		if self:HasDayEvents(vMonth, vDay, vYear) then
			local vSchedule = self.Schedules[vDate]
			
			if not vSchedule then
				vSchedule = GuildCalendarEvent:New(GuildCalendarEvent._CalendarDay, self.OwnersName, self.CalendarID, self.CalendarData, self.ReadOnly)
				self.Schedules[vDate] = vSchedule
			else
				vSchedule.Unused = nil
			end
			
			vSchedule:SetDate(vMonth, vDay, vYear)
		end
	end
	
	-- Remove unused schedules
	
	for vDate, vSchedule in pairs(self.Schedules) do
		if vSchedule.Unused then
			self.Schedules[vDate] = nil
		end 
	end
end

function GuildCalendarEvent._Calendar:HasDayEvents(pMonth, pDay, pYear)
	local vMonthOffset = GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(pMonth, pYear)
	local vNumEvents = GuildCalendarEvent.WoWCalendar:CalendarGetNumDayEvents(vMonthOffset, pDay) 
	
	SetCVar("calendarShowLockouts", 1)
	
	for vEventIndex = 1, vNumEvents do
		local vTitle, vHour, vMinute,
		      vCalendarType, vSequenceType, vEventType,
		      vTextureID, vModStatus, vInviteStatus, vInvitedBy,
		      vDifficulty, vInviteType, vSequenceIndex, vNumSequenceDays, vDifficultyName = GuildCalendarEvent.WoWCalendar:CalendarGetDayEvent(vMonthOffset, pDay, vEventIndex)
		
		if (self.CalendarID == GuildCalendarEvent._CalendarDay.cBlizzardCalendarIDs[vCalendarType])
		or (self.CalendarID ~= "BLIZZARD" and not GuildCalendarEvent._CalendarDay.cBlizzardCalendarIDs[vCalendarType]) then
			return true
		end
	end
	
	return false
end

function GuildCalendarEvent._Calendar:NewEvent(pMonth, pDay, pYear, pCalendarType)
	if self.ReadOnly then
		error("Can't create new events in a read-only calendar")
	end
	
	if self:IsAfterMaxCreateDate(pMonth, pDay, pYear) then
		error("Can't create events that far in the future")
	end
	
	local vEvent = {}
	setmetatable(vEvent, GuildCalendarEvent._APIEventMetaTable)
	vEvent:NewEvent(self.OwnersName, pMonth, pDay, pYear, pCalendarType)
	
	return vEvent
end

function GuildCalendarEvent._Calendar:IsAfterMaxCreateDate(pMonth, pDay, pYear)
	if not pMonth or not pDay or not pYear then
		error("Expected month, day, year")
	end
	
	local _, vMaxMonth, vMaxDay, vMaxYear = GuildCalendarEvent.WoWCalendar:CalendarGetMaxCreateDate()
	
	if pYear > vMaxYear then
		return true
	elseif pYear < vMaxYear then
		return false
	elseif pMonth > vMaxMonth then
		return true
	elseif pMonth < vMaxMonth then
		return false
	else
		return pDay > vMaxDay
	end
end

----------------------------------------
GuildCalendarEvent._CalendarDay = {}
----------------------------------------

function GuildCalendarEvent._CalendarDay:Construct(pOwnersName, pCalendarID, pCalendarData, pReadOnly)
	self.OwnersName = pOwnersName
	self.CalendarID = pCalendarID
	self.CalendarData = pCalendarData
	self.ReadOnly = pReadOnly
	
	self.Events = nil
end

GuildCalendarEvent._CalendarDay.cBlizzardCalendarIDs =
{
	SYSTEM = "BLIZZARD",
	HOLIDAY = "BLIZZARD",
	RAID_RESET = "BLIZZARD"
}

function GuildCalendarEvent._CalendarDay:SetDate(pMonth, pDay, pYear)
	local vDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(pMonth, pDay, pYear)
	
	if not self.Events then
		if self.CalendarData then
			self.Events = self.CalendarData[vDate]
		end
		
		if not self.Events then
			self.Events = {}
		end
	end
	
	-- Synchronize to the Blizzard database if we're not read-only
	
	if not self.ReadOnly then
		self:SynchronizeEvents(pMonth, pDay, pYear)
		
		if self.CalendarData then
			if #self.Events > 0 then
				self.CalendarData[vDate] = self.Events
			else
				self.CalendarData[vDate] = nil
			end
		end
	end
end

function GuildCalendarEvent._CalendarDay:SynchronizeEvents(pMonth, pDay, pYear)
	if self.CalendarID == "PLAYER"
	and not GuildCalendarEvent.BlizzardCalendarReady then
		return -- Can't do anything until the WoW calendar's have loaded
	end
	
	-- Mark existing event records so we can determine if
	-- they're still active once we're done
	
	if self.Events then
		for _, vEvent in ipairs(self.Events) do
			vEvent.Orphaned = true
		end
	else
		self.Events = {}
	end
	
	-- Collect the events from the WoW calendar
	
	local vMonthOffset = GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(pMonth, pYear)
	local vNumEvents = GuildCalendarEvent.WoWCalendar:CalendarGetNumDayEvents(vMonthOffset, pDay) 
	
	SetCVar("calendarShowLockouts", 1)
	
	local vAPIEvent = {}
	
	setmetatable(vAPIEvent, GuildCalendarEvent._APIEventMetaTable)
	
	local vCurrentDateTimeStamp = GuildCalendarEvent.DateLib:GetServerDateTimeStamp()
	
	local vCalendarChanged
	
	for vEventIndex = 1, vNumEvents do
		vAPIEvent:SetEvent(self.OwnersName, pMonth, pDay, pYear, vEventIndex)
		
		if (self.CalendarID == self.cBlizzardCalendarIDs[vAPIEvent.CalendarType])
		or (self.CalendarID ~= "BLIZZARD" and not self.cBlizzardCalendarIDs[vAPIEvent.CalendarType]) then
			local vEvent = self:FindExistingEvent(vAPIEvent)
			
			if vEvent then
				local vChanged
				
				for vKey, vValue in pairs(vAPIEvent) do
					if vEvent[vKey] ~= vValue then
						vEvent[vKey] = vValue
						vChanged = true
					end
				end
				
				vEvent.CacheUpdateDate, vEvent.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
				
				vEvent.Orphaned = nil
				
				if vChanged then
					vCalendarChanged = true
					GuildCalendarEvent.BroadcastLib:Broadcast(vEvent, "CHANGED")
				end
			else
				vEvent = GuildCalendarEvent:DuplicateTable(vAPIEvent, true)
				setmetatable(vEvent, GuildCalendarEvent._APIEventMetaTable)
				
				vEvent.CreationDate, vEvent.CreationTime = GuildCalendarEvent.DateLib:GetServerDateTime()
				vEvent.CacheUpdateDate, vEvent.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
				
				if self.CalendarID == "PLAYER"
				and not vEvent:IsCooldownEvent()
				and not vEvent:HasPassed(vCurrentDateTimeStamp)
				and vEvent.InvitedBy ~= GuildCalendarEvent.PlayerName then
					vEvent.Unseen = true
				end
				
				if not self.Events then
					self.Events = {}
				end
				
				table.insert(self.Events, vEvent)
				
				vCalendarChanged = true
				GuildCalendarEvent.EventLib:DispatchEvent("GC5_EVENT_ADDED", vEvent)
			end
		end
	end
	
	for vIndex = #self.Events, 1, -1 do
		local vEvent = self.Events[vIndex]
		
		if vEvent.Orphaned then
			vCalendarChanged = true
			table.remove(self.Events, vIndex)
			GuildCalendarEvent.BroadcastLib:Broadcast(vEvent, "DELETED")
		end
	end
	
	if vCalendarChanged then
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_CALENDAR_CHANGED", vEvent)
	end
end

function GuildCalendarEvent._CalendarDay:FindExistingEvent(pEvent)
	local vBestScore, vBestEvent

	for _, vEvent in ipairs(self.Events) do
		if vEvent.Orphaned then
			if pEvent.CalendarType == vEvent.CalendarType
			and pEvent.SequenceType == vEvent.SequenceType then
				local vScore = 0
				
				if pEvent.Title == vEvent.Title then vScore = vScore + 1 end
				if pEvent.TitleTag == vEvent.TitleTag then vScore = vScore + 1 end
				
				if pEvent.Hour == vEvent.Hour
				and pEvent.Minute == vEvent.Minute then vScore = vScore + 1 end
				
				if pEvent.Month == vEvent.Month
				and pEvent.Day == vEvent.Day
				and pEvent.Year == vEvent.Year then vScore = vScore + 1 end
				
				if pEvent.EventType == vEvent.EventType
				and pEvent.TextureID == vEvent.TextureID
				and pEvent.Difficulty == vEvent.Difficulty then vScore = vScore + 1 end
				
				if pEvent.ModStatus == vEvent.ModStatus then vScore = vScore + 0.25 end
				if pEvent.InviteStatus == vEvent.InviteStatus then vScore = vScore + 0.25 end
				if pEvent.InviteType == vEvent.InviteType then vScore = vScore + 0.25 end
				if pEvent.InvitedBy == vEvent.InvitedBy then vScore = vScore + 0.5 end
				
				if vScore and vScore >= 3 and (not vBestScore or vScore > vBestScore) then
					vBestScore = vScore
					vBestEvent = vEvent
				end
			end -- if pCalendarTYpe
		end -- if Orphaned
	end -- for
	
	return vBestEvent
end

function GuildCalendarEvent:AddTooltipEvents(pTooltip, pEvents, pUseLocalTime)
	if not pEvents then
		return
	end
	
	for vIndex, vEvent in ipairs(pEvents) do
		local vColor = vEvent:GetEventColor()
		local vOwner = tern((vEvent.RealmName ~= GuildCalendarEvent.RealmName) and vEvent.OwnersName,
		                       string.format(GuildCalendarEvent.cForeignRealmFormat, vEvent.OwnersName, vEvent.RealmName),
		                       vEvent.OwnersName)
		
		local vEventFormat = vEvent.InvitedBy and vEvent.InvitedBy ~= "" and GuildCalendarEvent.cTooltipScheduleItemFormat or "%s"
		local vTitle = vEventFormat:format(vEvent.Title, vOwner)
		
		if vEvent:IsAllDayEvent() then
			pTooltip:AddDoubleLine(
					GuildCalendarEvent.cAllDay,
					vTitle,
					vColor.r, vColor.g, vColor.b, vColor.r, vColor.g, vColor.b)
		else
			local vTime = GuildCalendarEvent.DateLib:ConvertHMToTime(vEvent.Hour, vEvent.Minute)
			
			if pUseLocalTime then
				vTime = GuildCalendarEvent.DateLib:GetLocalTimeFromServerTime(vTime)
			end
			
			pTooltip:AddDoubleLine(
					GuildCalendarEvent.DateLib:GetShortTimeString(vTime),
					vTitle,
					vColor.r, vColor.g, vColor.b, vColor.r, vColor.g, vColor.b)
		end
	end
end

function GuildCalendarEvent:GetEventTypeTextures(pEventType)
	if not self.EventTypeTextures then
		self.EventTypeTextures = {}
	end
	
	local vEventTypeTextures = self.EventTypeTextures[pEventType]
	
	if not vEventTypeTextures then
		vEventTypeTextures = {}
		
		local vTextures = {GuildCalendarEvent.WoWCalendar:CalendarEventGetTextures(pEventType)}
		local vTextureIndex = 1

		for vIndex = 1, #vTextures, 6 do
			vEventTypeTextures[vTextureIndex] = {
				Name = vTextures[vIndex],
				TextureName = vTextures[vIndex + 1],
				ExpLevel = vTextures[vIndex + 2],
				DifficultyName = vTextures[vIndex + 3]
			}
			vTextureIndex = vTextureIndex + 1
		end

		self.EventTypeTextures[pEventType] = vEventTypeTextures
	end
	
	return vEventTypeTextures
end

function GuildCalendarEvent:InitializeEventDefaults()
	GuildCalendarEvent.DefaultEventLimits = {}
	GuildCalendarEvent.DefaultEventLevel = {}
	
	local vEventTypeNames = {GuildCalendarEvent.WoWCalendar:CalendarEventGetTypes()}
	
	for vEventType, vEventTypeName in ipairs(vEventTypeNames) do
		GuildCalendarEvent.DefaultEventLimits[vEventType] = {}
		GuildCalendarEvent.DefaultEventLevel[vEventType] = {}
		
		if vEventType == CALENDAR_EVENTTYPE_RAID or vEventType == CALENDAR_EVENTTYPE_DUNGEON or vEventType == CALENDAR_EVENTTYPE_HEROIC_DUNGEON then
			local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(vEventType)
			
			for vTextureIndex, vTextureInfo in ipairs(vEventTypeTextures) do
				local vLimit, vMinLevel
				
				-- Dungeons are always 5-man
				
				if vEventType == CALENDAR_EVENTTYPE_DUNGEON or vEventType == CALENDAR_EVENTTYPE_HEROIC_DUNGEON then
					vLimit = 5
					
					if vTextureInfo.ExpLevel == 1 then
						vMinLevel = 60
					elseif vTextureInfo.ExpLevel == 2 then
						vMinLevel = 70
					else
						vMinLevel = 10
					end
					
				-- Classic raids are 20 for ZG and AQR and 40 for everything else
				
				elseif vTextureInfo.ExpLevel == 0 then
					
					if vTextureInfo.TextureName == "LFGIcon-ZulGurub"
					or vTextureInfo.TextureName == "LFGIcon-AQRuins" then
						vLimit = 20
						vMinLevel = 58
					else
						vLimit = 40
						vMinLevel = 58
					end
				
				-- TBC raids are 10-man for Karazhan and Zul'Aman, 25 for everything else
				
				elseif vTextureInfo.ExpLevel == 0 then
					
					if vTextureInfo.TextureName == "LFGIcon-Karazhan"
					or vTextureInfo.TextureName == "LFGIcon-ZulAman" then
						vLimit = 10
						vMinLevel = 68
					else
						vLimit = 25
						vMinLevel = 70
					end
					
				-- WotLK raids are 10-man for non-heroic, 25 for
				-- heroic (I'm assuming this is the default for the future too)
				
				else
					
					if vTextureInfo.Name and vTextureInfo.Name:sub(-1) == ")" then -- Cheesy, but what else is there?
						vLimit = 25
						vMinLevel = 80
					else
						vLimit = 10
						vMinLevel = 78
					end
				end
				
				GuildCalendarEvent.DefaultEventLimits[vEventType][vTextureIndex] = vLimit
				GuildCalendarEvent.DefaultEventLevel[vEventType][vTextureIndex] = vMinLevel
			end -- for vTextureIndex
		end -- if vEventType
	end -- for vEventType
end

----------------------------------------
GuildCalendarEvent._BaseEventMethods = {}
----------------------------------------

----------------------------------------
-- Get

function GuildCalendarEvent._BaseEventMethods:GetTexture()
	if not GuildCalendarEvent.EventTypeTextures then
		GuildCalendarEvent.EventTypeTextures = {}
	end
	
	local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(self.EventType)
	
	return GuildCalendarEvent:GetTextureFile(
		self.TextureIndex and vEventTypeTextures[self.TextureIndex] and vEventTypeTextures[self.TextureIndex].TextureName,
		self.CalendarType, self.NumSequenceDays ~= 2 and self.SequenceType or "", self.EventType, self.TitleTag)
end

function GuildCalendarEvent._BaseEventMethods:GetLocation()
	local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(self.EventType)
	
	if not vEventTypeTextures
	or not vEventTypeTextures[self.TextureIndex] then
		return ""
	end
	
	return vEventTypeTextures[self.TextureIndex].Name
end

function GuildCalendarEvent._BaseEventMethods:GetEventColor()
	if self:IsPlayerCreated() then
		if GuildCalendarEvent.CALENDAR_INVITESTATUS_COLORS[self.InviteStatus] then
			return GuildCalendarEvent.CALENDAR_INVITESTATUS_COLORS[self.InviteStatus]
		end
	elseif GuildCalendarEvent.CALENDAR_CALENDARTYPE_COLORS[self.CalendarType] then
		return GuildCalendarEvent.CALENDAR_CALENDARTYPE_COLORS[self.CalendarType]
	end
	
	-- Default to normal color
	
	return NORMAL_FONT_COLOR
end

function GuildCalendarEvent._BaseEventMethods:GetLevelRange()
	return self.MinLevel, self.MaxLevel
end

function GuildCalendarEvent._BaseEventMethods:GetLimits()
	return self.Limits
end

function GuildCalendarEvent._BaseEventMethods:GetDefaultPartySize()
	if not GuildCalendarEvent.DefaultEventLimits then
		GuildCalendarEvent:InitializeEventDefaults()
	end
	
	if not GuildCalendarEvent.DefaultEventLimits[self.EventType] then
		return
	else
		return GuildCalendarEvent.DefaultEventLimits[self.EventType][self.TextureIndex],
		       GuildCalendarEvent.DefaultEventLevel[self.EventType][self.TextureIndex]
	end
end

function GuildCalendarEvent._BaseEventMethods:GetUID()
	if self.CalendarType == "HOLIDAY"
	or self.CalendarType == "SYSTEM"
	or self.CalendarType == "RAID_RESET" then
		return string.format("%s//%04d%02d%02d//%d", self.CalendarType, self.Year, self.Month, self.Day, self.Index)
	end
	
	if not self.UID then
		self.UID = math.random(1000000)
	end
	
	return self.RealmName.."//"..self.OwnersName.."//"..self.UID
end

function GuildCalendarEvent._BaseEventMethods:GetCreationDateTime()
	if not self.CreationDate then
		self.CreationDate, self.CreationTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	end
	
	return self.CreationDate, self.CreationTime
end

function GuildCalendarEvent._BaseEventMethods:GetModifiedDateTime()
	if not self.CreationDate then
		self.CacheUpdateDate, self.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	end
	
	return self.CacheUpdateDate, self.CacheUpdateTime
end

function GuildCalendarEvent._BaseEventMethods:GetSecondsToStart(pCurrentDateTimeStamp)
	local vDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Month, self.Day, self.Year)
	local vTime60 = GuildCalendarEvent.DateLib:ConvertHMSToTime60(self.Hour, self.Minute, 0) or 0
	local vDateTimeStamp = vDate * GuildCalendarEvent.DateLib.cSecondsPerDay + vTime60
	
	return vDateTimeStamp - pCurrentDateTimeStamp
end

function GuildCalendarEvent._BaseEventMethods:HasPassed(pCurrentDateTimeStamp)
	local vDuration = (self.Duration or (4 * 60)) * 60
	
	return self:GetSecondsToStart(pCurrentDateTimeStamp) + vDuration < 0
end

----------------------------------------
-- Status

function GuildCalendarEvent._BaseEventMethods:IsAllDayEvent()
	if self.SequenceType == "ONGOING" then
		return true
	end

	if self.TitleTag
	and GuildCalendarEvent.TitleTagInfo[self.TitleTag] then
		return GuildCalendarEvent.TitleTagInfo[self.TitleTag].AllDay
	end
	
	return false
end

function GuildCalendarEvent._BaseEventMethods:IsCooldownEvent()
	if self.CalendarType == "RAID_LOCKOUT" then
		return true
	end
	    
	if self.TitleTag
	and GuildCalendarEvent.TitleTagInfo[self.TitleTag] then
		return GuildCalendarEvent.TitleTagInfo[self.TitleTag].IsCooldown
	end
	
	return self.TitleTag ~= nil
end

function GuildCalendarEvent._BaseEventMethods:IsBirthdayEvent()
	return self.TitleTag == "BRTH"
end

function GuildCalendarEvent._BaseEventMethods:IsPersonalEvent()
	if self.TitleTag
	and GuildCalendarEvent.TitleTagInfo[self.TitleTag] then
		return GuildCalendarEvent.TitleTagInfo[self.TitleTag].IsPersonal
	end
	
	return (self.CalendarType == "PLAYER" or self.CalendarType == "GUILD_EVENT" or self.CalendarType == "GUILD" or self.CalendarType == "GUILD_ANNOUNCEMENT")
	   and self.TitleTag ~= nil
end

function GuildCalendarEvent._BaseEventMethods:IsDungeonEvent()
	return (self.CalendarType == "PLAYER" or self.CalendarType == "GUILD_EVENT" or self.CalendarType == "GUILD" or self.CalendarType == "GUILD_ANNOUNCEMENT")
	   and self.TitleTag == nil
end

function GuildCalendarEvent._BaseEventMethods:IsSignupEvent()
	return self.InviteType == CALENDAR_INVITETYPE_SIGNUP
end

function GuildCalendarEvent._BaseEventMethods:IsAnnouncementEvent()
	return self.CalendarType == "GUILD_ANNOUNCEMENT" or self.CalendarType == "GUILD"
end

function GuildCalendarEvent._BaseEventMethods:IsPlayerCreated()
	return self.CalendarType == "PLAYER"
	    or self.CalendarType == "GUILD"
		or self.CalendarType == "GUILD_ANNOUNCEMENT"
		or self.CalendarType == "GUILD_EVENT"
		or self.CalendarType == "ARENA"
end

function GuildCalendarEvent._BaseEventMethods:UsesLevelLimits()
	if self.TitleTag
	and GuildCalendarEvent.TitleTagInfo[self.TitleTag] then
		return GuildCalendarEvent.TitleTagInfo[self.TitleTag].UsesLevelLimits
	end
	
	return (self.CalendarType == "PLAYER"
	     or self.CalendarType == "GUILD"
	     or self.CalendarType == "GUILD_EVENT"
	     or self.CalendarType == "GUILD_ANNOUNCEMENT")
	   and self.TitleTag == nil
end

function GuildCalendarEvent._BaseEventMethods:UsesAttendance()
	if self.TitleTag
	and GuildCalendarEvent.TitleTagInfo[self.TitleTag] then
		return GuildCalendarEvent.TitleTagInfo[self.TitleTag].UsesAttendance
	end
	
	return (self.CalendarType == "PLAYER"
	     or self.CalendarType == "GUILD_EVENT")
	   and (self.TitleTag == nil or self.TitleTag == "")
end

function GuildCalendarEvent._BaseEventMethods:PlayerIsQualified()
	return true
end

function GuildCalendarEvent._BaseEventMethods:IsExpired()
	local vServerDate, vServerTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	local vEventDate, vEventTime = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Month, self.Day, self.Year), GuildCalendarEvent.DateLib:ConvertHMToTime(self.Hour, self.Minute)
	
	return vEventDate < vServerDate or (vEventDate == vServerDate and vEventTime and vEventTime < vServerTime)
end

function GuildCalendarEvent._BaseEventMethods:EventIsVisible(pIsPlayerEvent)
	if not self:IsPlayerCreated() then
		return true
	end
	
	if pIsPlayerEvent then
		return true
	end
	
	return self.ModStatus == "CREATOR" or self:IsAttending()
end

function GuildCalendarEvent._BaseEventMethods:IsAttending()
	return not self.TitleTag
	and (self.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
	    or self.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
	    or self.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP
	    or self.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
	    or self.InviteStatus == CALENDAR_INVITESTATUS_STANDBY)
end

function GuildCalendarEvent._BaseEventMethods:GetAttendance()
	return self.Attendance
end

function GuildCalendarEvent._BaseEventMethods:GetInviteStatus(pPlayerName)
	local vAttendance = self:GetAttendance()
	
	if not vAttendance then
		if pPlayerName == self.OwnersName then
			return self.InviteStatus
		elseif self.CalendarType == "GUILD_EVENT" then
			return CALENDAR_INVITESTATUS_NOT_SIGNEDUP
		else
			return
		end
	end
	
	if not vAttendance[pPlayerName] then
		if self.CalendarType == "GUILD_EVENT" then
			return CALENDAR_INVITESTATUS_NOT_SIGNEDUP
		else
			return
		end
	end
	
	return vAttendance[pPlayerName].InviteStatus
end

----------------------------------------
GuildCalendarEvent._APIEventMethods = {}
----------------------------------------

for vKey, vValue in pairs(GuildCalendarEvent._BaseEventMethods) do
	GuildCalendarEvent._APIEventMethods[vKey] = vValue
end

function GuildCalendarEvent._APIEventMethods:NewEvent(pOwnersName, pMonth, pDay, pYear, pCalendarType)
	self.Month = pMonth
	self.Day = pDay
	self.Year = pYear
	self.Index = nil
	
	self.OwnersName = pOwnersName
	self.RealmName = GuildCalendarEvent.RealmName
	
	self.Title = ""
	self.TitleTag = nil
	self.Hour = 20
	self.Minute = 0
	self.Duration = 180
	self.MinLevel = nil
	self.MaxLevel = nil
	
	if pCalendarType then
		self.CalendarType = pCalendarType
	elseif CanEditGuildEvent() then
		self.CalendarType = "GUILD_EVENT"
	else
		self.CalendarType = "PLAYER"
	end
	
	self.SequenceType = nil
	self.EventType = CALENDAR_EVENTTYPE_OTHER
	self.TextureID = nil
	self.ModStatus = "CREATOR"
	self.InviteStatus = CALENDAR_INVITESTATUS_CONFIRMED
	self.InvitedBy = GuildCalendarEvent.PlayerName
	self.InviteType = CALENDAR_INVITETYPE_NORMAL
	
	self.Difficulty = nil
	
	self.Description = ""
	self.DescriptionTag = nil
end

function GuildCalendarEvent._APIEventMethods:SetEvent(pOwnersName, pMonth, pDay, pYear, pIndex)
	if not pIndex then
		return self:NewEvent(pOwnersName, pMonth, pDay, pYear)
	end
	
	local vMonthOffset = GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(pMonth, pYear)
	
	self.Month = pMonth
	self.Day = pDay
	self.Year = pYear
	self.Index = pIndex
	
	self.OwnersName = pOwnersName
	self.RealmName = GuildCalendarEvent.RealmName
	
	local event = GuildCalendarEvent.WoWCalendar:CalendarGetDayEvent(vMonthOffset, self.Day, self.Index)

	self.Title = event.title

	if (event.sequenceType == "END") then
		self.Hour = event.endTime.hour;
		self.Minute = event.endTime.minute;
	else
		self.Hour = event.startTime.hour;
		self.Minute = event.startTime.minute;
	end

	self.CalendarType = event.calendarType
	self.SequenceType = event.sequenceType
	self.EventType = event.eventType
	self.TextureID = event.iconTexture
	self.ModStatus = event.modStatus
	self.InviteStatus = event.inviteStatus
	self.InvitedBy = event.invitedBy
	self.Difficulty = event.difficulty
	self.InviteType = event.inviteType
	self.SequenceIndex = event.sequenceType
	self.NumSequenceDays = event.numSequenceDays
	self.DifficultyName = event.difficultyName

	self.TitleTag = GuildCalendarEvent.WoWCalendar:CalendarEventGetTitleTag()
	
	self.EventCanComplain = GuildCalendarEvent.WoWCalendar:CalendarContextEventCanComplain(vMonthOffset, self.Day, self.Index)
	
	if self.CalendarType == "GUILD"
	and CalendarContextEventIsGuildWide
	and not GuildCalendarEvent.WoWCalendar:CalendarContextEventIsGuildWide(vMonthOffset, self.Day, self.Index) then
		self.CalendarType = "PLAYER"
	end
	
	if self.Difficulty == ""
	or self.Difficulty == 0 then
		self.Difficulty = nil
	end
	
	if self.Difficulty then
		self.Title = string.format(DUNGEON_NAME_WITH_DIFFICULTY, self.Title or "nil", self.DifficultyName or "nil")
	end
	
	self.Title = GuildCalendarEvent.WoWCalendar:CalendarGetDisplayTitle(self.CalendarType, self.SequenceType, self.Title)
	
	if self.CalendarType == "HOLIDAY" then
		_, self.Description, _ = GuildCalendarEvent.WoWCalendar:CalendarGetHolidayInfo(vMonthOffset, self.Day, self.Index)
	elseif self.CalendarType == "RAID_LOCKOUT"
	or self.CalendarType == "RAID_RESET" then
		self.Description = ""
	end
	
	if self.SequenceType == "ONGOING" then
		self.Hour = nil
		self.Minute = nil
	end
	
	if not self.InvitedBy or self.InvitedBy == "" then
		self.InvitedBy = (self.CalendarType == "RAID_LOCKOUT" and GuildCalendarEvent.PlayerData.Name)
		              or (self.CalendarType == "HOLIDAY" and "Holiday")
		              or (self.CalendarType == "SYSTEM" and GuildCalendarEvent.cBlizzardOwner)
		              or (self.CalendarType == "RAID_RESET" and GuildCalendarEvent.cBlizzardOwner)
	end
end

function GuildCalendarEvent._APIEventMethods:Open()
	if GuildCalendarEvent.WoWCalendar.OpenedEvent then
		GuildCalendarEvent.WoWCalendar.OpenedEvent:Close()
	end
	
	SetCVar("calendarShowLockouts", 1) -- Make sure this is on so indices are correct
	
	if self.Index then
		GuildCalendarEvent.WoWCalendar:CalendarOpenEvent(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
		GuildCalendarEvent.WoWCalendar.OpenedEvent = self
	else
		if self.CalendarType == "GUILD_EVENT" then
			GuildCalendarEvent.WoWCalendar:CalendarNewGuildEvent()
		elseif self.CalendarType == "GUILD_ANNOUNCEMENT" then
			GuildCalendarEvent.WoWCalendar:CalendarNewGuildAnnouncement()
		else
			GuildCalendarEvent.WoWCalendar:CalendarNewEvent()
		end
		
		GuildCalendarEvent.WoWCalendar.OpenedEvent = self
		
		self:InitializeNewEvent()
	end
	
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_OPEN_EVENT", self.CalendarOpenEvent, self)
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_CLOSE_EVENT", self.EventClosed, self)
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_EVENT", self.CalendarUpdateEvent, self)
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_INVITE_LIST", self.CalendarUpdateEventInvites, self)
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_ERROR", self.CalendarUpdateError, self)
	
	if self.OriginalEvent then
		GuildCalendarEvent.BroadcastLib:Listen(self.OriginalEvent, self.ShadowEventMessage, self)
	end
end

function GuildCalendarEvent._APIEventMethods:InitializeNewEvent()
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDate(self.Month, self.Day, self.Year)
	
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTime(self.Hour or 0, self.Minute or 0)
	
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTitle(self.Title)
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTitleTag(self.TitleTag)
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDescription(self.Description)
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDescriptionTag(self.DescriptionTag)
	GuildCalendarEvent.WoWCalendar:CalendarEventSetType(self.EventType)
	if self.TextureIndex then
		GuildCalendarEvent.WoWCalendar:CalendarEventSetTextureID(self.TextureIndex)
	end
	GuildCalendarEvent.WoWCalendar:CalendarEventSetRepeatOption(self.RepeatOption)
	
	self:GetEventInfo()
end

function GuildCalendarEvent._APIEventMethods:SetEventMode(pMode)
	if self.Index then
		return -- Can't change mode on an existing event
	end
	
	if pMode == "SIGNUP"
	and CanEditGuildEvent() then
		if self.CalendarType == "GUILD_EVENT" then
			return
		end
		
		self.ChangingMode = true
		GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
		GuildCalendarEvent.WoWCalendar:CalendarNewGuildEvent()
		self.ChangingMode = nil
	
		self.CalendarType = "GUILD_EVENT"
		self.InviteType = CALENDAR_INVITETYPE_NORMAL
	elseif pMode == "ANNOUNCE"
	and CanEditGuildEvent() then
		if self.CalendarType == "GUILD_ANNOUNCEMENT" then
			return
		end
		
		self.ChangingMode = true
		GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
		GuildCalendarEvent.WoWCalendar:CalendarNewGuildAnnouncement()
		self.ChangingMode = nil
		
		self.CalendarType = "GUILD_ANNOUNCEMENT"
		self.InviteType = CALENDAR_INVITETYPE_NORMAL
	else
		if self.CalendarType == "PLAYER" then
			return
		end
		
		self.ChangingMode = true
		GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
		GuildCalendarEvent.WoWCalendar:CalendarNewEvent()
		self.ChangingMode = nil
		
		self.CalendarType = "PLAYER"
		self.InviteType = CALENDAR_INVITETYPE_NORMAL
	end
	
	GuildCalendarEvent.WoWCalendar.OpenedEvent = self
	
	self:InitializeNewEvent()
	
	GuildCalendarEvent.BroadcastLib:Broadcast(self, "CHANGED")
end

function GuildCalendarEvent._APIEventMethods:Close()
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
end

function GuildCalendarEvent._APIEventMethods:GetShadowCopy()
	local vEvent = GuildCalendarEvent:DuplicateTable(self, true)
	
	vEvent.OriginalEvent = self
	vEvent.Group = self.Group -- Don't clone the group
	
	setmetatable(vEvent, getmetatable(self))
	
	return vEvent
end

function GuildCalendarEvent._APIEventMethods:ShadowEventMessage(pEvent, pMessageID, ...)
	if pMessageID == "CHANGED" then
		for vField, vValue in pairs(self.OriginalEvent) do
			if type(vValue) ~= "table" then
				self[vField] = vValue
			else
				-- Attendance needs to be merged?
			end
		end
	end
	
	GuildCalendarEvent.BroadcastLib:Broadcast(self, pMessageID, ...)
end

function GuildCalendarEvent._APIEventMethods:IsOpened()
	return GuildCalendarEvent.WoWCalendar.OpenedEvent == self
end

function GuildCalendarEvent._APIEventMethods:Save()
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self:UpdateDescriptionTag()
	
	if self.Index then
		GuildCalendarEvent.WoWCalendar:CalendarUpdateEvent()
	else
		GuildCalendarEvent.WoWCalendar:CalendarAddEvent()
	end
end

function GuildCalendarEvent._APIEventMethods:Copy()
	GuildCalendarEvent.WoWCalendar:CalendarContextEventCopy(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
end

function GuildCalendarEvent._APIEventMethods:Delete()
	if self.Index then
		if self.ModStatus == "CREATOR" then
			GuildCalendarEvent.WoWCalendar:CalendarContextEventRemove(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
		else
			GuildCalendarEvent.WoWCalendar:CalendarContextInviteRemove(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index) 
		end
	else
		-- Nothing to do for new events
	end
end

function GuildCalendarEvent._APIEventMethods:LoadDefaults()
	local vPartySize, vMinLevel = self:GetDefaultPartySize()
	
	--[[ Don't bother setting default limits since they're not supported yet
	if vPartySize then
		self.Limits = GuildCalendarEvent:DuplicateTable(GuildCalendarEvent.DefaultLimits[vPartySize], true)
	end
	]]
	
	self:SetLevelRange(vMinLevel, nil)
	
	local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(self.EventType)
	
	if vEventTypeTextures and vEventTypeTextures[self.TextureIndex] then
		self:SetTitle(vEventTypeTextures[self.TextureIndex].Name)
	end
	
	local vDefaults = self.TitleTag
	              and GuildCalendarEvent.TitleTagInfo[self.TitleTag]
	              and GuildCalendarEvent.TitleTagInfo[self.TitleTag].Defaults
	
	if vDefaults then
		-- Change the mode
		
		if vDefaults.CalendarType == "GUILD_ANNOUNCEMENT" then
			self:SetEventMode("ANNOUNCE")
		elseif vDefaults.CalendarType == "GUILD_EVENT" then
			self:SetEventMode("SIGNUP")
		elseif vDefaults.CalendarType == "PLAYER" then
			self:SetEventMode("NORMAL")
		end
		
		-- Set the title
		
		if vDefaults.Title then
			self:SetTitle(vDefaults.Title:format(GuildCalendarEvent.PlayerName))
		end
	end
	
	-- Clear out fields which aren't used
	
	if self:IsAllDayEvent() then
		self.Hour = 0 -- Midnight
		self.Minute = 0
		self.Duration = 1440 -- 24 hours
	end
	
	if not self:UsesLevelLimits() then
		self.MinLevel = nil
		self.MaxLevel = nil
	end
end

----------------------------------------
-- Get

function GuildCalendarEvent._APIEventMethods:CanSendInvite(pIgnoreOpenedEvent)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self or pIgnoreOpenedEvent)
	
	return GuildCalendarEvent.WoWCalendar:CalendarCanSendInvite()
end

function GuildCalendarEvent._APIEventMethods:GetEventInfo(pIgnoreOpenedEvent)
	local vChanged
	
	if not pIgnoreOpenedEvent then
		assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	end
	
	if self.ChangingMode then
		return
	end
	
	local vTitle,
	      vDescription,
	      vCreator,
	      vEventType,
	      vRepeatOption,
	      vMaxSize,
	      vTextureIndex,
	      vWeekday,
	      vMonth,
	      vDay,
	      vYear,
	      vHour,
	      vMinute,
	      vLockoutWeekday,
	      vLockoutMonth,
	      vLockoutDay,
	      vLockoutYear,
	      vLockoutHour,
	      vLockoutMinute,
	      vLocked,
	      vAutoApprove,
	      vPendingInvite,
	      vInviteStatus,
	      vInviteType,
	      vCalendarType = GuildCalendarEvent.WoWCalendar:CalendarGetEventInfo()
	
	if vTextureIndex == 0 then vTextureIndex = nil end
	
	if self.TextureIndex ~= vTextureIndex then
		self.TextureIndex = vTextureIndex
		vChanged = true
	end
	
	if self.Description ~= vDescription then
		self.Description = vDescription
		vChanged = true
	end
	
	if self.Creator ~= vCreator then
		self.Creator = vCreator
		vChanged = true
	end
	
	if self.RepeatOption ~= vRepeatOption then
		self.RepeatOption = vRepeatOption
		vChanged = true
	end
	
	if self.MaxSize ~= vMaxSize then
		self.MaxSize = vMaxSize
		vChanged = true
	end
	
	if self.LockoutWeekday ~= vLockoutWeekday then
		self.LockoutWeekday = vLockoutWeekday
		vChanged = true
	end
	
	if self.LockoutMonth ~= vLockoutMonth then
		self.LockoutMonth = vLockoutMonth
		vChanged = true
	end
	
	if self.LockoutDay ~= vLockoutDay then
		self.LockoutDay = vLockoutDay
		vChanged = true
	end
	
	if self.LockoutYear ~= vLockoutYear then
		self.LockoutYear = vLockoutYear
		vChanged = true
	end
	
	if self.LockoutHour ~= vLockoutHour then
		self.LockoutHour = vLockoutHour
		vChanged = true
	end
	
	if self.LockoutMinute ~= vLockoutMinute then
		self.LockoutMinute = vLockoutMinute
		vChanged = true
	end
	
	if self.Locked ~= vLocked then
		self.Locked = vLocked
		vChanged = true
	end
	
	if self.AutoApprove ~= vAutoApprove then
		self.AutoApprove = vAutoApprove
		vChanged = true
	end
	
	if self.PendingInvite ~= vPendingInvite then
		self.PendingInvite = vPendingInvite
		vChanged = true
	end
	
	if self.InviteStatus ~= vInviteStatus then
		self.InviteStatus = vInviteStatus
		vChanged = true
	end
	
	if self.InviteType ~= vInviteType then
		self.InviteType = vInviteType
		vChanged = true
	end
	
	if self.CalendarType ~= vCalendarType then
		self.CalendarType = vCalendarType
		vChanged = true
	end
	
	if self:DecodeDescriptionTag() then
		vChanged = true
	end
	
	if self:RefreshAttendance(pIgnoreOpenedEvent) then
		vChanged = true
	end
	
	self.CacheUpdateDate, self.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	
	if vChanged then
		GuildCalendarEvent.BroadcastLib:Broadcast(self, "CHANGED")
	end
	
	if self.OriginalEvent then
		self.OriginalEvent:GetEventInfo(true)
	end
	
	return vChanged
end

function GuildCalendarEvent._APIEventMethods:GetEventAttendance(pIgnoreOpenedEvent)
	if not pIgnoreOpenedEvent then
		assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	end
	
	if self.ChangingMode then
		return
	end
	
	local vChanged
	
	if self:RefreshAttendance(pIgnoreOpenedEvent) then
		vChanged = true
	end
	
	self.CacheUpdateDate, self.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	
	if vChanged then
		GuildCalendarEvent.BroadcastLib:Broadcast(self, "CHANGED")
	end
	
	if self.OriginalEvent then
		self.OriginalEvent:GetEventAttendance(true)
	end
	
	return vChanged
end

function GuildCalendarEvent._APIEventMethods:DecodeDescriptionTag()
	local vDescriptionTag = GuildCalendarEvent.WoWCalendar:CalendarEventGetDescriptionTag()
	local vChanged
	
	if not self.DescriptionTags then
		self.DescriptionTags = {}
	else
		for vKey, _ in pairs(self.DescriptionTags) do
			self.DescriptionTags[vKey] = nil
		end
	end
	
	if vDescriptionTag then
		for vTag, vParameters in vDescriptionTag:gmatch("(%w+):?([^/]*)") do
			self.DescriptionTags[vTag] = vParameters
		end
	end
	
	if self.DescriptionTags.L then
		local _, _, vMin, vMax = self.DescriptionTags.L:find("(.*),(.*)")
		
		vMin = tonumber(vMin)
		vMax = tonumber(vMax)
		
		if vMin ~= self.MinLevel then
			self.MinLevel = vMin
			vChanged = true
		end
		
		if vMax ~= self.MaxLevel then
			self.MaxLevel = vMax
			vChanged = true
		end
	else
		if self.MinLevel then
			self.MinLevel = nil
			vChanged = true
		end
		
		if self.MaxLevel then
			self.MaxLevel = nil
			vChanged = true
		end
	end
	
	if self.DescriptionTags.D then
		local vDuration = tonumber(self.DescriptionTags.D)
		
		if vDuration ~= self.Duration then
			self.Duration = vDuration
			vChanged = true
		end
	elseif self.Duration then
		self.Duration = nil
		vChanged = true
	end
	
	if self.DescriptionTags.C then
		self.Limits = {}
		
		for vTagData in self.DescriptionTags.C:gmatch("[^:]+") do
			if vTagData == "ROLE" then
				self.Limits.Mode = "ROLE"
				self.Limits.RoleLimits = {}
			else
				local _, _, vRoleCode, vMin, vMax, vClassReservations = vTagData:find("(.)(%d*),?(%d*)(.*)")
				
				if vRoleCode == "X" then
					self.Limits.MaxAttendance = tonumber(vMin)
				elseif vRoleCode == "H"
				    or vRoleCode == "T"
				    or vRoleCode == "R"
				    or vRoleCode == "M" then
					local vRoleLimit = {}
					
					vRoleLimit.Min = tonumber(vMin)
					vRoleLimit.Max = tonumber(vMax)
					
					if vClassReservations ~= "" then
						vRoleLimit.Class = {}
						
						for vClassCode, vClassMin in vClassReservations:gmatch("([A-Z])(%d*)") do
							local vClassID = GuildCalendarEvent.ClassInfoByClassCode[vClassCode].ClassID
							vRoleLimit.Class[vClassID] = tonumber(vClassMin)
						end
					end
					
					self.Limits.RoleLimits[vRoleCode] = vRoleLimit
				end
			end
		end
	elseif self.Limits then
		self.Limits = nil
		vChanged = true
	end

	return vChanged
end

----------------------------------------
-- Set

function GuildCalendarEvent._APIEventMethods:SetDate(pMonth, pDay, pYear)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.Month, self.Day, self.Year = pMonth, pDay, pYear
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDate(pMonth, pDay, pYear)
end

function GuildCalendarEvent._APIEventMethods:SetTime(pHour, pMinute)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.Hour, self.Minute = pHour, pMinute
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTime(pHour or 0, pMinute or 0)
end

function GuildCalendarEvent._APIEventMethods:SetLockoutDate(pMonth, pDay, pYear)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.LockoutMonth, self.LockoutDay, self.LockoutYear = pMonth, pDay, pYear
	GuildCalendarEvent.WoWCalendar:CalendarEventSetLockoutDate(pMonth, pDay, pYear)
end

function GuildCalendarEvent._APIEventMethods:SetLockoutTime(pHour, pMinute)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.LockoutHour, self.LockoutMinute = pHour, pMinute
	GuildCalendarEvent.WoWCalendar:CalendarEventSetLockoutTime(pHour, pMinute)
end

function GuildCalendarEvent._APIEventMethods:SetTitle(pTitle)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.Title = pTitle
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTitle(pTitle)
end

function GuildCalendarEvent._APIEventMethods:SetTitleTag(pTitleTag)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.TitleTag = pTitleTag
	GuildCalendarEvent.WoWCalendar:CalendarEventSetTitleTag(pTitleTag)
end

function GuildCalendarEvent._APIEventMethods:SetDescription(pDescription)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.Description = pDescription
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDescription(pDescription)
end

function GuildCalendarEvent._APIEventMethods:SetDescriptionTag(pDescriptionTag)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.DescriptionTag = pDescriptionTag
	GuildCalendarEvent.WoWCalendar:CalendarEventSetDescriptionTag(pDescriptionTag)
	GuildCalendarEvent.BroadcastLib:Broadcast(self, "CHANGED")
end

function GuildCalendarEvent._APIEventMethods:SetType(pEventType, pTextureIndex)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.EventType = pEventType
	self.TextureIndex = pTextureIndex
	
	GuildCalendarEvent.WoWCalendar:CalendarEventSetType(pEventType)
	
	if self.TextureIndex then
		GuildCalendarEvent.WoWCalendar:CalendarEventSetTextureID(self.TextureIndex)
	end
end

function GuildCalendarEvent._APIEventMethods:SetRepeatOption(pRepeatOption)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.RepeatOption = pRepeatOption
	GuildCalendarEvent.WoWCalendar:CalendarEventSetRepeatOption(pRepeatOption)
end

function GuildCalendarEvent._APIEventMethods:SetLocked(pLocked)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	if pLocked then
		GuildCalendarEvent.WoWCalendar:CalendarEventSetLocked()
	else
		GuildCalendarEvent.WoWCalendar:CalendarEventClearLocked()
	end
end

function GuildCalendarEvent._APIEventMethods:SetDuration(pMinutes)
	self.Duration = pMinutes
	self:UpdateDescriptionTag()
end

function GuildCalendarEvent._APIEventMethods:SetLimits(pLimits)
	self.Limits = GuildCalendarEvent:DuplicateTable(pLimits, true)
	self:UpdateDescriptionTag()
end

function GuildCalendarEvent._APIEventMethods:SetLevelRange(pMinLevel, pMaxLevel)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	self.MinLevel = pMinLevel
	self.MaxLevel = pMaxLevel
	
	self:UpdateDescriptionTag()
end

function GuildCalendarEvent._APIEventMethods:UpdateDescriptionTag()
	if not self.DescriptionTags then
		self.DescriptionTags = {}
	end
	
	if self.MinLevel or self.MaxLevel then
		self.DescriptionTags.L = (self.MinLevel or "")..","..(self.MaxLevel or "")
	else
		self.DescriptionTags.L = nil
	end
	
	if self.Duration then
		self.DescriptionTags.D = tostring(self.Duration)
	else
		self.DescriptionTags.D = nil
	end
	
	if self.Limits then
		self.DescriptionTags.C = self:GetAutoConfirmString()
	else
		self.DescriptionTags.C = nil
	end
	
	local vDescriptionTag
	
	for vTag, vValue in pairs(self.DescriptionTags) do
		if vDescriptionTag then
			vDescriptionTag = vDescriptionTag.."/"..vTag..":"..vValue
		else
			vDescriptionTag = vTag..":"..vValue
		end
	end
	
	self:SetDescriptionTag(vDescriptionTag)
end

function GuildCalendarEvent._APIEventMethods:GetAutoConfirmString()
	local vString = "ROLE"
	
	if self.Limits then
		if self.Limits.MaxAttendance then
			vString = vString..":X"..self.Limits.MaxAttendance
		end
		
		if self.Limits.RoleLimits then
			for vRoleCode, vRoleLimit in pairs(self.Limits.RoleLimits) do
				vString = vString..":"..vRoleCode..(vRoleLimit.Min or "")..","..(vRoleLimit.Max or "")
				
				if vRoleLimit.Class then
					for vClassID, vClassLimit in pairs(vRoleLimit.Class) do
						local vClassCode = GuildCalendarEvent.ClassInfoByClassID[vClassID].ClassCode
						
						vString = vString..vClassCode..vClassLimit
					end
				end
			end
		end
	end
	
	return vString
end

----------------------------------------
-- Attendance

function GuildCalendarEvent._APIEventMethods:RefreshAttendance(pIgnoreOpenedEvent)
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self or pIgnoreOpenedEvent)
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(NORMAL_FONT_COLOR_CODE.."RefreshAttendance, MinLevel=%s", tostring(self.MinLevel))
	end
	
	local vChanged
	
	if not self.Attendance then
		self.Attendance = {}
	else
		for vName, vInfo in pairs(self.Attendance) do
			vInfo.Unused = true
		end
	end
	
	self.NumInvites = GuildCalendarEvent.WoWCalendar:CalendarEventGetNumInvites() or 0
	
	for vIndex = 1, self.NumInvites do
		local vName, vLevel, vClassName, vClassFileName, vInviteStatus, vModStatus, vInviteIsMine = GuildCalendarEvent.WoWCalendar:CalendarEventGetInvite(vIndex)
		local vResponseDate, vResponseTime
		
		if CalendarEventGetInviteResponseTime then
			local vWeekday, vMonth, vDay, vYear, vHour, vMinute = GuildCalendarEvent.WoWCalendar:CalendarEventGetInviteResponseTime(vIndex)
			
			if vYear and vYear ~= 0 then
				vResponseDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(vMonth, vDay, vYear)
				vResponseTime = GuildCalendarEvent.DateLib:ConvertHMToTime(vHour, vMinute)
			end
		end
		
		local vInfo = self.Attendance[vName or ""]
		if not vName then
			-- The server didn't respond, probably laggy
		elseif not vInfo then
			-- Use the current date/time if no stamp is found
			
			if not vResponseDate
			and (vInviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
			  or vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
			  or vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
			  or vInviteStatus == CALENDAR_INVITESTATUS_STANDBY
			  or vInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP) then
				vResponseDate, vResponseTime = GuildCalendarEvent.DateLib:GetServerDateTime()
			end
			
			-- Create the new record
			
			vInfo =
			{
				Name = vName,
				Level = vLevel,
				ClassName = vClassName,
				ClassID = vClassFileName,
				RoleCode = GuildCalendarEvent:GetPlayerDefaultRoleCode(vName, vClassFileName),
				InviteStatus = vInviteStatus,
				ModStatus = vModStatus,
				InviteIsMine = vInviteIsMine,
				ResponseDate = vResponseDate,
				ResponseTime = vResponseTime,
			}
			
			self.Attendance[vName] = vInfo
			vChanged = true
		else
			vInfo.Unused = nil
			
			if vInfo.Name ~= vName then
				vInfo.Name = vName
				vChanged = true
			end
			
			if vInfo.Level ~= vLevel then
				vInfo.Level = vLevel
				vChanged = true
			end
			
			if vInfo.ClassName ~= vClassName then
				vInfo.ClassName = vClassName
				vChanged = true
			end
			
			if vInfo.ClassID ~= vClassFileName then
				vInfo.ClassID = vClassFileName
				vChanged = true
			end
			
			if vInfo.InviteStatus ~= vInviteStatus then
				vInfo.InviteStatus = vInviteStatus
				vChanged = true
			end
			
			if vInfo.ModStatus ~= vModStatus then
				vInfo.ModStatus = vModStatus
				vChanged = true
			end
			
			if vInfo.InviteIsMine ~= vInviteIsMine then
				vInfo.InviteIsMine = vInviteIsMine
				vChanged = true
			end
			
			if not vResponseDate then
				if not vInfo.ResponseDate
				and (vInviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
				  or vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
				  or vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
				  or vInviteStatus == CALENDAR_INVITESTATUS_STANDBY
				  or vInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP) then
					vInfo.ResponseDate, vInfo.ResponseTime = GuildCalendarEvent.DateLib:GetServerDateTime()
					vChanged = true
				end
			
			elseif vInfo.ResponseDate ~= vResponseDate
			or vInfo.ResponseTime ~= vResponseTime then
				vInfo.ResponseDate = vResponseDate
				vInfo.ResponseTime = vResponseTime
				
				vChanged = true
			end
		end
	end -- for vIndex
	
	for vName, vInfo in pairs(self.Attendance) do
		if vInfo.Unused then
			self.Attendance[vName] = nil
			vChanged = true
		end
	end
	
	self.CacheUpdateDate, self.CacheUpdateTime = GuildCalendarEvent.DateLib:GetServerDateTime()
	
	if vChanged then
		if GuildCalendarEvent.Debug.invites then
			GuildCalendarEvent:DebugMessage(NORMAL_FONT_COLOR_CODE.."Sending INVITES_CHANGED, MinLevel=%s", tostring(self.MinLevel))
		end
		
		GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITES_CHANGED")

		if GuildCalendarEvent.Debug.invites then
			GuildCalendarEvent:DebugMessage(NORMAL_FONT_COLOR_CODE.."Sent INVITES_CHANGED, MinLevel=%s", tostring(self.MinLevel))
		end
	end
	
	if self.OriginalEvent then
		if GuildCalendarEvent.Debug.invites then
			GuildCalendarEvent:DebugMessage(NORMAL_FONT_COLOR_CODE.."Refreshing OriginalEvent, MinLevel=%s", tostring(self.MinLevel))
		end
		
		self.OriginalEvent:RefreshAttendance(true)

		if GuildCalendarEvent.Debug.invites then
			GuildCalendarEvent:DebugMessage(NORMAL_FONT_COLOR_CODE.."Refreshed OriginalEvent, MinLevel=%s", tostring(self.MinLevel))
		end
	end
	
	return vChanged
end

function GuildCalendarEvent._APIEventMethods:MassInvite(pMinLevel, pMaxLevel, pMinRank)
	local _, vDefaultMaxLevel = GuildCalendarEvent.WoWCalendar:CalendarDefaultGuildFilter()
	
	GuildCalendarEvent.WoWCalendar:CalendarMassInviteGuild(pMinLevel or 1, pMaxLevel or vDefaultMaxLevel, pMinRank)
end

function GuildCalendarEvent._APIEventMethods:ReadyToContinueInvites()
	if not self.DesiredAttendance then
		return false
	end
	
	if self.WaitingForEventID then
		return false
	end
	
	if GuildCalendarEvent.WoWCalendar:CalendarIsActionPending() then
		-- Listen for action pending events so we can tell when the API is available again
		
		if not GuildCalendarEvent.EventLib:EventIsRegistered("CALENDAR_ACTION_PENDING", self.CalendarActionPending, self) then
			GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_ACTION_PENDING", self.CalendarActionPending, self)
		end
		
		return false
	end
	
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_ACTION_PENDING", self.CalendarActionPending, self)
	
	if not GuildCalendarEvent.WoWCalendar:CalendarCanSendInvite() then
		-- Start the timer so we can tell when invites are available again
		GuildCalendarEvent.SchedulerLib:ScheduleUniqueRepeatingTask(0.1, self.CheckCanSendInvite, self)
		return false
	end
	
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.CheckCanSendInvite, self)
	
	return true
end

function GuildCalendarEvent._APIEventMethods:CalendarActionPending(pEventID, pBusy)
	if pBusy then return end
	
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_ACTION_PENDING", self.CalendarActionPending, self)
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage("CalendarActionPending: Free")
	end
	
	self:CheckDesiredAttendance()
end

function GuildCalendarEvent._APIEventMethods:WaitForEvent(pEventID)
	assert(self.WaitingForEventID == nil)
	
	self.WaitingForEventID = pEventID
	GuildCalendarEvent.EventLib:RegisterEvent(self.WaitingForEventID, self.ProcessWaitForEvent, self)
end

function GuildCalendarEvent._APIEventMethods:ProcessWaitForEvent(pEventID, pParam)
	assert(self.WaitingForEventID ~= nil)
	
	if self.WaitingForEventID ~= pEventID then
		error("Unexpected event "..tostring(pEventID))
	end
	
	GuildCalendarEvent.EventLib:UnregisterEvent(self.WaitingForEventID, self.ProcessWaitForEvent, self)
	
	self.WaitingForEventID = nil
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage("CalendarActionPending: Found event %s", pEventID)
	end
	
	self:CheckDesiredAttendance()
end

function GuildCalendarEvent._APIEventMethods:CheckCanSendInvite()
	if not GuildCalendarEvent.WoWCalendar:CalendarCanSendInvite() then
		return
	end
	
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.CheckCanSendInvite, self)
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(GREEN_FONT_COLOR_CODE.."CanSendInvite")
	end
	
	self:CheckDesiredAttendance()
end

function GuildCalendarEvent._APIEventMethods:FindInviteByName(pName)
	local vNumInvites = GuildCalendarEvent.WoWCalendar:CalendarEventGetNumInvites()
	
	for vIndex = 1, vNumInvites do
		local vName, vLevel, vClassName, vClassFileName, vInviteStatus, vModStatus, vInviteIsMine = GuildCalendarEvent.WoWCalendar:CalendarEventGetInvite(vIndex)
		
		if vName == pName then
			return vIndex, vName, vLevel, vClassName, vClassFileName, vInviteStatus, vModStatus, vInviteIsMine
		end
	end
end

function GuildCalendarEvent._APIEventMethods:GetDesiredAttendanceCount()
	if not self.DesiredAttendance then
		return 0
	end
	
	local vTotalChanges = 0
	
	-- Removed players
	
	for vName, vInfo in pairs(self.Attendance) do
		if not self.DesiredAttendance[vName] then
			vTotalChanges = vTotalChanges + 1
		end
	end
	
	-- New/updated players

	for vName, vInfo in pairs(self.DesiredAttendance) do
		local vCurrentInfo = self.Attendance[vName]
		
		if not vCurrentInfo then
			vTotalChanges = vTotalChanges + 1
		elseif vCurrentInfo.ModStatus ~= "CREATOR"
		and (vCurrentInfo.ModStatus ~= vInfo.ModStatus or vCurrentInfo.InviteStatus ~= vInfo.InviteStatus) then
			vTotalChanges = vTotalChanges + 1
		end
	end

	return vTotalChanges
end

function GuildCalendarEvent._APIEventMethods:GetDesiredNewAttendanceCount()
	if not self.DesiredAttendance then
		return 0
	end
	
	local vTotalChanges = 0
	
	for vName, vInfo in pairs(self.DesiredAttendance) do
		local vCurrentInfo = self.Attendance[vName]
		
		if not vCurrentInfo then
			vTotalChanges = vTotalChanges + 1
		end
	end
	
	return vTotalChanges
end

function GuildCalendarEvent._APIEventMethods:AllDesiredAttendanceIsInGuild()
	local vMinLevel, vMaxLevel, vMinRank
	
	for vName, vInfo in pairs(self.DesiredAttendance) do
		local vPlayerInfo = GuildCalendarEvent.GuildLib:GetPlayer(vName)
		
		if not vPlayerInfo then
			return false
		end
		
		if not self.Attendance[vName]
		or self.Attendance[vName].ModStatus ~= "CREATOR" then
			if not vMinLevel or vPlayerInfo.Level < vMinLevel then
				vMinLevel = vPlayerInfo.Level
			end
			
			if not vMaxLevel or vPlayerInfo.Level > vMaxLevel then
				vMaxLevel = vPlayerInfo.Level
			end
			
			if not vMinRank or vPlayerInfo.GuildRank > vMinRank then
				vMinRank = vPlayerInfo.GuildRank
			end
		end
	end

	return true, vMinLevel, vMaxLevel, vMinRank
end

function GuildCalendarEvent._APIEventMethods:CheckDesiredAttendance()
	if self.CheckingDesiredAttendance then
		return
	end
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage("CheckDesiredAttendance")
	end
	
	self.CheckingDesiredAttendance = true
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_UPDATE_INVITE_LIST", self.CalendarUpdateEventInvites, self)
	
	self:CheckDesiredAttendance_Body()
	
	self.CheckingDesiredAttendance = nil
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_INVITE_LIST", self.CalendarUpdateEventInvites, self)

	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage("CheckDesiredAttendance: Done")
	end
	
	self:RefreshAttendance()
end

function GuildCalendarEvent._APIEventMethods:CheckDesiredAttendance_Body()
	local vEventMinLevel = self.MinLevel or 1
	local vEventMaxLevel = self.MaxLevel or MAX_PLAYER_LEVEL_TABLE[#MAX_PLAYER_LEVEL_TABLE]
	
	-- If this is a new private event, and everyone on the list is a guild member,
	-- and there are invitees missing, use the mass invite feature
	
	if not self.Index -- New event
	and self.CalendarType ~= "GUILD_EVENT"
	and CanEditGuildEvent()  -- Mass invite is available to this player
	and self:GetDesiredNewAttendanceCount() > 0 then
		local vAllGuild, vMinLevel, vMaxLevel, vMinRank = self:AllDesiredAttendanceIsInGuild()
		
		if vAllGuild then
			if not self:ReadyToContinueInvites() then
				return
			end
			
			if vMinLevel < vEventMinLevel then
				vMinLevel = vEventMinLevel
			end
			
			if vMaxLevel > vEventMaxLevel then
				vMaxLevel = vEventMaxLevel
			end
			
			GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_UPDATE", GuildCalendarEvent.cWaitingForServerInvite)
			
			self:WaitForEvent("CALENDAR_UPDATE_INVITE_LIST")
			
			self:MassInvite(1, nil, vMinRank + 1)
		end
	end
	
	--
	
	while self.DesiredAttendance ~= nil do
		-- Remove unwanted players
		
		for vName, vInfo in pairs(self.Attendance) do
			if not self:ReadyToContinueInvites() then
				return
			end
			
			if not self.DesiredAttendance[vName] then
				GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_UPDATE", string.format("Removing %s", vName))
				
				local vIndex, vName, vLevel, vClassName, vClassFileName, vInviteStatus, vModStatus, vInviteIsMine = self:FindInviteByName(vName)
				
				assert(vIndex ~= nil)
				assert(vModStatus ~= "CREATOR")
				
				if GuildCalendarEvent.Debug.invites then
					GuildCalendarEvent:DebugMessage("CalendarEventRemoveInvite(%s)", vName)
				end
				
				self:WaitForEvent("CALENDAR_UPDATE_INVITE_LIST")
				GuildCalendarEvent.WoWCalendar:CalendarEventRemoveInvite(vIndex)
				
				if GuildCalendarEvent.Debug.invites then
					GuildCalendarEvent:DebugMessage("CalendarEventRemoveInvite(%s): Done", vName)
				end
			end
		end
		
		-- Invite missing players
		
		if not self:ReadyToContinueInvites() then
			return
		end
		
		for vName, vInfo in pairs(self.DesiredAttendance) do
			GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_UPDATE", string.format(GuildCalendarEvent.cAddingInviteFormat, vName))
			
			if not self.Attendance[vName] then
				if GuildCalendarEvent.Debug.invites then
					GuildCalendarEvent:DebugMessage("CalendarEventInvite(%s)", vName)
				end
				
				self:WaitForEvent("CALENDAR_UPDATE_INVITE_LIST")
				GuildCalendarEvent.WoWCalendar:CalendarEventInvite(vName)
			end
			
			if not self:ReadyToContinueInvites() then
				return
			end
		end
		
		-- Update mis-matched player status
		
		if not self:ReadyToContinueInvites() then
			return
		end
		
		for vName, vInfo in pairs(self.DesiredAttendance) do
			local vCurrentInfo = self.Attendance[vName]
			
			if (vCurrentInfo.ModStatus ~= "CREATOR" and vCurrentInfo.ModStatus ~= vInfo.ModStatus)
			or vCurrentInfo.InviteStatus ~= vInfo.InviteStatus then
				GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_UPDATE", string.format("Updating %s", vName))
				
				local vIndex, vName, vLevel, vClassName, vClassFileName, vInviteStatus, vModStatus, vInviteIsMine = self:FindInviteByName(vName)
				
				assert(vIndex ~= nil)
				
				if GuildCalendarEvent.Debug.invites then
					GuildCalendarEvent:DebugMessage("CalendarEventSetStatus/Moderator(%s): Index=%s, Status=%s", vName, tostring(vIndex), tostring(vInfo.InviteStatus))
				end
				
				if vCurrentInfo.InviteStatus ~= vInfo.InviteStatus then
					GuildCalendarEvent.WoWCalendar:CalendarEventSetStatus(vIndex, vInfo.InviteStatus)
				end
				
				if vCurrentInfo.ModStatus ~= "CREATOR" and vCurrentInfo.ModStatus ~= vInfo.ModStatus then
					if vInfo.ModStatus == "MODERATOR" then
						GuildCalendarEvent.WoWCalendar:CalendarEventSetModerator(vIndex)
					else
						GuildCalendarEvent.WoWCalendar:CalendarEventClearModerator(vIndex)
					end
				end
			end
			
			if not self:ReadyToContinueInvites() then
				return
			end
		end
		
		-- All clear
		
		self.DesiredAttendance = nil
		GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_END")
	end -- while
end

function GuildCalendarEvent._APIEventMethods:PlayerInviteIsPending(pPlayerName)
	if not self.DesiredAttendance then
		return false
	end
	
	local vCurrentInfo = self.Attendance and self.Attendance[pPlayerName]
	local vDesiredInfo = self.DesiredAttendance[pPlayerName]
	
	if (vCurrentInfo == nil) ~= (vDesiredInfo == nil) then
		return true
	end
	
	if not vCurrentInfo then
		return false
	end
	
	return vCurrentInfo.InviteStatus ~= vDesiredInfo.InviteStatus
	   or vCurrentInfo.ModStatus ~= vDesiredInfo.ModStatus
end

----------------------------------------
-- Invites

function GuildCalendarEvent._APIEventMethods:BeginBatchInvites()
	self.DoingBatchInvites = true
end

function GuildCalendarEvent._APIEventMethods:EndBatchInvites()
	self.DoingBatchInvites = nil
	self:DesiredAttendanceChanged()
end

function GuildCalendarEvent._APIEventMethods:CancelPendingInvites()
	if not self.DesiredAttendance then
		return
	end
	
	self.DesiredAttendance = nil
	
	if self.WaitingForEventID then
		GuildCalendarEvent.EventLib:UnregisterEvent(self.WaitingForEventID, self.ProcessWaitForEvent, self)
		self.WaitingForEventID = nil
	end

	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_ACTION_PENDING", self.CalendarActionPending, self)
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.CheckCanSendInvite, self)
	
	GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_END")
end

function GuildCalendarEvent._APIEventMethods:CalendarUpdateError(pEvent, pMessage)
	if not self.DesiredAttendance then
		return
	end
	
	self:CancelPendingInvites()
	
	GuildCalendarEvent:ErrorMessage(GuildCalendarEvent.cInviteErrorMessage, tostring(pMessage))
end

function GuildCalendarEvent._APIEventMethods:InvitePlayer(pPlayerName)
	if self.Attendance and self.Attendance[pPlayerName] then
		return
	end
	
	local vDesiredAttendance = self:GetDesiredAttendance(true)
	
	if vDesiredAttendance[pPlayerName] then
		return
	end
	
	vDesiredAttendance[pPlayerName] =
	{
		Name = pPlayerName,
		InviteStatus = CALENDAR_INVITESTATUS_INVITED,
		ModStatus = "",
	}
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."InvitePlayer(%s)", pPlayerName)
	end
	
	if not self.DoingBatchInvites then
		self:DesiredAttendanceChanged()
	end
end

function GuildCalendarEvent._APIEventMethods:UninvitePlayer(pPlayerName)
	local vCurrentInfo = self.Attendance[pPlayerName]
	
	if not vCurrentInfo and not self.DesiredAttendance then
		return
	end
	
	if vCurrentInfo and vCurrentInfo.ModStatus == "CREATOR" then
		return -- Can't uninvite the creator
	end
	
	local vDesiredAttendance = self:GetDesiredAttendance(true)
	
	vDesiredAttendance[pPlayerName] = nil
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."UninvitePlayer(%s)", pPlayerName)
	end
	
	if not self.DoingBatchInvites then
		self:DesiredAttendanceChanged()
	end
end

function GuildCalendarEvent._APIEventMethods:ContextSelectEvent()
	GuildCalendarEvent.WoWCalendar:CalendarContextSelectEvent(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
end

function GuildCalendarEvent._APIEventMethods:SetConfirmedStatus()
	-- If it's a new event or if the event is open and it's for
	-- the creator then set the status manually since the normal
	-- APIs won't work
	
	if not self.Index
	or (GuildCalendarEvent.WoWCalendar.OpenedEvent == self and self.ModStatus == "CREATOR") then
		self:SetInviteStatus(GuildCalendarEvent.PlayerName, CALENDAR_INVITESTATUS_CONFIRMED)
		
		return
	end
	
	-- If the event isn't currently open then use the context APIs
	-- to set the status.  These APIs don't work for the creator
	
	if self.ModStatus == "CREATOR" then
		return -- Can't use context APIs for creator
	end
	
	if GuildCalendarEvent.WoWCalendar.OpenedEvent ~= self then
		self:ContextSelectEvent()
		
		if self:IsSignupEvent() then
			GuildCalendarEvent.WoWCalendar:CalendarContextEventSignUp()
		else
			GuildCalendarEvent.WoWCalendar:CalendarContextInviteAvailable()
		end
		
		return
	end
	
	-- The event is currently opened and it isn't the creator. Use
	-- the normal event response APIs
	
	if self:IsSignupEvent() then
		GuildCalendarEvent.WoWCalendar:CalendarEventSignUp()
	else
		GuildCalendarEvent.WoWCalendar:CalendarEventAvailable()
	end
end

function GuildCalendarEvent._APIEventMethods:SetTentativeStatus()
	-- If it's a new event or if the event is open and it's for
	-- the creator then set the status manually since the normal
	-- APIs won't work
	
	if not self.Index
	or (GuildCalendarEvent.WoWCalendar.OpenedEvent == self and self.ModStatus == "CREATOR") then
		self:SetInviteStatus(GuildCalendarEvent.PlayerName, CALENDAR_INVITESTATUS_TENTATIVE)
		
		return
	end
	
	-- If the event isn't currently open then use the context APIs
	-- to set the status.  These APIs don't work for the creator
	
	if self.ModStatus == "CREATOR" then
		return -- Can't use context APIs for creator
	end
	
	if GuildCalendarEvent.WoWCalendar.OpenedEvent ~= self then
		self:ContextSelectEvent()
		GuildCalendarEvent.WoWCalendar:CalendarContextInviteTentative()
		
		return
	end
	
	-- The event is currently opened and it isn't the creator. Use
	-- the normal event response APIs
	
	GuildCalendarEvent.WoWCalendar:CalendarEventTentative()
end

function GuildCalendarEvent._APIEventMethods:SetDeclinedStatus()
	-- If it's a new event or if the event is open and it's for
	-- the creator then set the status manually since the normal
	-- APIs won't work
	
	if not self.Index
	or (GuildCalendarEvent.WoWCalendar.OpenedEvent == self and self.ModStatus == "CREATOR") then
		if self.CalendarType == "GUILD_EVENT" then
			self:SetInviteStatus(GuildCalendarEvent.PlayerName, CALENDAR_INVITESTATUS_OUT)
		else
			self:SetInviteStatus(GuildCalendarEvent.PlayerName, CALENDAR_INVITESTATUS_DECLINED)
		end
		
		return
	end
	
	-- If the event isn't currently open then use the context APIs
	-- to set the status.  These APIs don't work for the creator
	
	if self.ModStatus == "CREATOR" then
		return -- Can't use context APIs for creator
	end
	
	if GuildCalendarEvent.WoWCalendar.OpenedEvent ~= self then
		self:ContextSelectEvent()
		
		if self:IsSignupEvent() then
			GuildCalendarEvent.WoWCalendar:CalendarContextInviteRemove()
		else
			GuildCalendarEvent.WoWCalendar:CalendarContextInviteDecline()
		end
		
		return
	end
	
	-- The event is currently opened and it isn't the creator. Use
	-- the normal event response APIs
	
	if self:IsSignupEvent() then
		GuildCalendarEvent.WoWCalendar:CalendarRemoveEvent()
	else
		GuildCalendarEvent.WoWCalendar:CalendarEventDecline()
	end
end

function GuildCalendarEvent._APIEventMethods:SetInviteStatus(pPlayerName, pInviteStatus)
	local vDesiredAttendance = self:GetDesiredAttendance(true)
	
	assert(vDesiredAttendance[pPlayerName] ~= nil)
	
	vDesiredAttendance[pPlayerName].InviteStatus = pInviteStatus
	vDesiredAttendance[pPlayerName].Queued = false
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."SetInviteStatus(%s, %s)", pPlayerName, tostring(pInviteStatus))
	end

	if not self.DoingBatchInvites then
		self:DesiredAttendanceChanged()
	end
end

function GuildCalendarEvent._APIEventMethods:SetModerator(pPlayerName, pModerator)
	local vDesiredAttendance = self:GetDesiredAttendance(true)
	
	assert(vDesiredAttendance[pPlayerName] ~= nil)
	
	vDesiredAttendance[pPlayerName].ModStatus = pModerator and "MODERATOR"
	vDesiredAttendance[pPlayerName].Queued = false
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."SetModerator(%s, %s)", pPlayerName, tostring(pModerator))
	end
	
	if not self.DoingBatchInvites then
		self:DesiredAttendanceChanged()
	end
end

function GuildCalendarEvent._APIEventMethods:SetInviteRoleCode(pPlayerName, pRoleCode)
	assert(self.Attendance[pPlayerName] ~= nil)
	
	self.Attendance[pPlayerName].RoleCode = pRoleCode
	
	if self.OriginalEvent then
		self.OriginalEvent:SetInviteRoleCode(pPlayerName, pRoleCode)
	end
end

function GuildCalendarEvent._APIEventMethods:GetAttendance()
	if self.DesiredAttendance then
		return self.DesiredAttendance
	end
	
	return self.Attendance
end

function GuildCalendarEvent._APIEventMethods:GetDesiredAttendance(pCreate)
	if not self.DesiredAttendance and pCreate then
		if self.Attendance then
			self.DesiredAttendance = GuildCalendarEvent:DuplicateTable(self.Attendance, true)
		else
			self.DesiredAttendance = {}
		end
		
		GuildCalendarEvent.BroadcastLib:Broadcast(self, "INVITE_QUEUE_BEGIN")
		GuildCalendarEvent.WoWCalendar:ResetInviteActionCount()
	end
	
	return self.DesiredAttendance
end

function GuildCalendarEvent._APIEventMethods:GetPlayerInvite(pPlayerName)
	local vAttendance = self:GetAttendance()
	
	return vAttendance and vAttendance[pPlayerName]
end

function GuildCalendarEvent._APIEventMethods:DesiredAttendanceChanged()
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage("DesiredAttendanceChanged")
	end
	
	self:CheckDesiredAttendance()
end

----------------------------------------
-- Status

function GuildCalendarEvent._APIEventMethods:CanDelete()
	if not self:IsPlayerCreated() then
		return false
	end
	
	if self.Index then
		return GuildCalendarEvent.WoWCalendar:CalendarContextEventCanEdit(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
	else
		return true
	end
end

function GuildCalendarEvent._APIEventMethods:CanEdit()
	if self.ModStatus ~= "MODERATOR"
	and self.ModStatus ~= "CREATOR" then
		return false
	end
	
	if not self:IsPlayerCreated() then
		return false
	end
	
	if self.TitleTag
	and (not GuildCalendarEvent.TitleTagInfo[self.TitleTag]
	  or not GuildCalendarEvent.TitleTagInfo[self.TitleTag].CanEdit) then
		return false
	end
	
	if self.Index then
		return GuildCalendarEvent.WoWCalendar:CalendarContextEventCanEdit(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
	else
		return true
	end
end

function GuildCalendarEvent._APIEventMethods:CanCopy()
	return self.Index and self:CanEdit()
end

function GuildCalendarEvent._APIEventMethods:CanComplain()
	if not self.Index then
		return false
	end
	
	return self.EventCanComplain
end

function GuildCalendarEvent._APIEventMethods:Complain()
	GuildCalendarEvent.WoWCalendar:CalendarContextSelectEvent(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
	GuildCalendarEvent.WoWCalendar:CalendarContextEventComplain()
end

function GuildCalendarEvent._APIEventMethods:CanRemove()
	return self.Index
	and self.ModStatus ~= "CREATOR"
	and (self.CalendarType == "PLAYER"
	or (self.CalendarType == "GUILD_EVENT" and self.InviteType == CALENDAR_INVITETYPE_NORMAL))
end

function GuildCalendarEvent._APIEventMethods:Remove()
	GuildCalendarEvent.WoWCalendar:CalendarContextSelectEvent(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day, self.Index)
	GuildCalendarEvent.WoWCalendar:CalendarContextInviteRemove()
end

function GuildCalendarEvent._APIEventMethods:IsGuildWide()
	return self.CalendarType == "GUILD_ANNOUNCEMENT" or self.CalendarType == "GUILD" or self.CalendarType == "GUILD_EVENT"
end

function GuildCalendarEvent._APIEventMethods:CanRSVP()
	if not self:UsesAttendance() then
		return false
	end
	
	return not self:IsExpired()
end

----------------------------------------
-- Events

function GuildCalendarEvent._APIEventMethods:CalendarOpenEvent()
	self:GetEventInfo()
end

function GuildCalendarEvent._APIEventMethods:EventClosed()
	assert(GuildCalendarEvent.WoWCalendar.OpenedEvent == self)
	
	if self.ChangingMode then
		if GuildCalendarEvent.Debug.invites then
			GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."Ignoring event closed -- event is transitioning")
		end
		
		return
	end
	
	if GuildCalendarEvent.Debug.invites then
		GuildCalendarEvent:DebugMessage(RED_FONT_COLOR_CODE.."Event closed")
	end
	
	GuildCalendarEvent.WoWCalendar:ClearQueue()
	
	GuildCalendarEvent.WoWCalendar.OpenedEvent = nil
	
	if self.DesiredAttendance then
		self:CancelPendingInvites()
		GuildCalendarEvent:NoteMessage(GuildCalendarEvent.cInvitesCanceledMessage)
	end
	
	
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_OPEN_EVENT", self.CalendarOpenEvent, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_CLOSE_EVENT", self.EventClosed, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_UPDATE_EVENT", self.CalendarUpdateEvent, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_UPDATE_INVITE_LIST", self.CalendarUpdateEventInvites, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_UPDATE_ERROR", self.CalendarUpdateError, self)
	
	GuildCalendarEvent.BroadcastLib:StopListening(nil, self.ShadowEventMessage, self)

	GuildCalendarEvent.BroadcastLib:Broadcast(self, "CLOSED")
end

function GuildCalendarEvent._APIEventMethods:CalendarUpdateEvent()
	self:GetEventInfo()
end

function GuildCalendarEvent._APIEventMethods:CalendarUpdateEventInvites()
	self:GetEventAttendance()
end

----------------------------------------
GuildCalendarEvent._CachedEventMethods = {}
----------------------------------------

for vName, vFunction in pairs(GuildCalendarEvent._BaseEventMethods) do
	GuildCalendarEvent._CachedEventMethods[vName] = vFunction
end

function GuildCalendarEvent._CachedEventMethods:Open()
end

function GuildCalendarEvent._CachedEventMethods:Close()
end

function GuildCalendarEvent._CachedEventMethods:Save()
	error("Can't save cached events")
end

function GuildCalendarEvent._CachedEventMethods:Delete()
	error("Can't delete cached events")
end

function GuildCalendarEvent._CachedEventMethods:CanEdit()
	return false
end

function GuildCalendarEvent._CachedEventMethods:CanCopy()
	return false
end

function GuildCalendarEvent._CachedEventMethods:CanDelete()
	return false
end

function GuildCalendarEvent._CachedEventMethods:CanRSVP()
	return false
end

function GuildCalendarEvent._CachedEventMethods:CanComplain()
	return false
end

function GuildCalendarEvent._CachedEventMethods:CanRemove()
	return false
end

function GuildCalendarEvent._CachedEventMethods:IsGuildWide()
	return self.CalendarType == "GUILD_ANNOUNCEMENT"
end

function GuildCalendarEvent._CachedEventMethods:CanSendInvite(pIgnoreOpenedEvent)
	return false
end

function GuildCalendarEvent._CachedEventMethods:SetInviteRoleCode(pPlayerName, pRoleCode)
	assert(self.Attendance[pPlayerName] ~= nil)
	
	self.Attendance[pPlayerName].RoleCode = pRoleCode
end

function GuildCalendarEvent._CachedEventMethods:GetAttendance()
	return self.Attendance
end

function GuildCalendarEvent._CachedEventMethods:GetPlayerInvite(pPlayerName)
	local vAttendance = self:GetAttendance()
	
	return vAttendance and vAttendance[pPlayerName]
end

function GuildCalendarEvent._CachedEventMethods:PlayerInviteIsPending(pPlayerName)
	return false
end

----------------------------------------
GuildCalendarEvent._APIEventMetaTable = {__index = GuildCalendarEvent._APIEventMethods}
GuildCalendarEvent._CachedEventMetaTable = {__index = GuildCalendarEvent._CachedEventMethods}
----------------------------------------

----------------------------------------
GuildCalendarEvent._WoWCalendar = {}
----------------------------------------

function GuildCalendarEvent._WoWCalendar:Construct()
	self.Month = 0
	self.Year = 0
	
	self.GetExtendedInfoQueue = {}
	
	self.TitleTag = nil
	self.DescriptionTag = nil
	
	-- Hook the original APIs to extend the functionality with tag support
	
	for _, vName in ipairs(GuildCalendarEvent.cBlizzardCalendarFunctionNames) do
		if not self[vName] then
			self[vName] = function (pWoWCalendar, ...) return _G[vName](...) end
		end
	end
	
--	self.WoWAPIOrigs = {}
	
--	for vName, vFunction in pairs(self.WoWAPIHooks) do
--		hooksecurefunc(vName, function (...) vFunction(self, ...) end
--		self.WoWAPIOrigs[vName] = _G[vName]
--		_G[vName] = function (...) return vFunction(self, ...) end
--	end
	
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_NEW_EVENT", self.NewEventCreated, self)
end

function GuildCalendarEvent._WoWCalendar:ResetInviteActionCount(...)
end

function GuildCalendarEvent._WoWCalendar:QueueInviteAction(...)
end

function GuildCalendarEvent._WoWCalendar:PlayerHasInviteAction(...)
end

function GuildCalendarEvent._WoWCalendar:ClearQueue(...)
end

function GuildCalendarEvent._WoWCalendar:BeginHardwareEvent()
	self.HardwareEventAvailable = true
	self.InviteQueue:HardwareEvent()
end

function GuildCalendarEvent._WoWCalendar:EndHardwareEvent()
	self.HardwareEventAvailable = false
end

function GuildCalendarEvent._WoWCalendar:GetEventExtendedInfo(pEventData)
	if true or pEventData.SequenceType == "ONGOING" then
		return -- No extended info for ongoing events
	end
	
	GuildCalendarEvent:DebugMessage(HIGHLIGHT_FONT_COLOR_CODE.."GetEventExtendedInfo: %s (%s/%s/%s index %s)", tostring(pEventData.Title), tostring(pEventData.Month), tostring(pEventData.Day), tostring(pEventData.Year), tostring(pEventData.Index))
	table.insert(self.GetExtendedInfoQueue, pEventData)
	
	if #self.GetExtendedInfoQueue == 1 then
		self:GetNextExtendedInfo()
	end
end

function GuildCalendarEvent._WoWCalendar:GetNextExtendedInfo()
	if #self.GetExtendedInfoQueue == 0 then
		return
	end
	
	local vEvent = self.GetExtendedInfoQueue[1]
	
	--GuildCalendarEvent:DebugMessage("GetNextExtendedInfo: %s (%s/%s/%s index %s)", tostring(vEvent.Title), tostring(vEvent.Month), tostring(vEvent.Day), tostring(vEvent.Year), tostring(vEvent.Index))
	
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_OPEN_EVENT", self.UpdateNextQueuedEvent, self)
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_OPEN_EVENT", self.UpdateNextQueuedEvent, self)
	
	GuildCalendarEvent.SchedulerLib:ScheduleUniqueTask(2, self.GetNextExtendedInfo, self)
	
	-- GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
	
	local vMonthOffset = GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(vEvent.Month, vEvent.Year)
	--GuildCalendarEvent:DebugMessage("GetNextExtendedInfo: CalendarOpenEvent(%s, %s, %s)", tostring(vMonthOffset), tostring(vEvent.Day), tostring(vEvent.Index))
	GuildCalendarEvent.WoWCalendar:CalendarOpenEvent(vMonthOffset, vEvent.Day, vEvent.Index)
end

function GuildCalendarEvent._WoWCalendar:UpdateNextQueuedEvent()
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.GetNextExtendedInfo, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("CALENDAR_OPEN_EVENT", self.UpdateNextQueuedEvent, self)
	
	local vEvent = table.remove(self.GetExtendedInfoQueue, 1)
	
	if not vEvent then
		return
	end
	
	if vEvent:UpdateExtendedInfo() then
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_EVENT_CHANGED", vEvent)
	end
	
	GuildCalendarEvent.WoWCalendar:CalendarCloseEvent()
	
	self:GetNextExtendedInfo()
end

function GuildCalendarEvent._WoWCalendar:ProcessTitle(pTitle)
	local vTagStart, vTagEnd, vTagData
	
	if pTitle then
		vTagStart, vTagEnd, vTagData = pTitle:find("%s?%[(.*)%]")
	end
	
	if vTagStart then
		self.Title = pTitle:sub(1, vTagStart - 1)..pTitle:sub(vTagEnd + 1)
		self.TitleTag = vTagData
	else
		self.Title = pTitle
		self.TitleTag = nil
	end
	
	-- Process tradeskill cooldowns
	if self.TitleTag then
		local _, _, vRecipeIDString = self.TitleTag:find("RECIPE_(.*)")
		if vRecipeIDString then
			local vRecipeID = tonumber(vRecipeIDString)
			local vRecipeInfo = C_TradeSkillUI.GetRecipeInfo(vRecipeID)
			if vRecipeInfo then
				self.Title = GuildCalendarEvent.cCooldownEventName:format(vRecipeInfo.name)
			end
		end
	end
	
	return self.Title
end

function GuildCalendarEvent._WoWCalendar:ProcessDescription(pDescription)
	local vTagStart, vTagEnd, vTagData
	
	if pDescription then
		vTagStart, vTagEnd, vTagData = pDescription:find("%s?%[(.*)%]")
	end
	
	if vTagStart then
		self.Description = pDescription:sub(1, vTagStart - 1)..pDescription:sub(vTagEnd + 1)
		self.DescriptionTag = vTagData
	else
		self.Description = pDescription
		self.DescriptionTag = nil
	end
	
	return self.Description
end

function GuildCalendarEvent._WoWCalendar:NewEventCreated()
	if self.OpenedEvent then
		self.OpenedEvent:EventClosed()
		self.OpenedEvent = nil
	end
end

----------------------------------------
-- WoW API hooks and extensions
----------------------------------------

function GuildCalendarEvent._WoWCalendar:CalendarNewEvent(...)
	if self.OpenedEvent then
		self.OpenedEvent:Close()
	end
	
	self.SelectedEventMonth = nil
	self.SelectedEventYear = nil
	self.SelectedEventDay = nil
	self.SelectedEventIndex = nil
	
	self.Description = ""
	self.DescriptionTag = ""
	self.Title = ""
	self.TitleTag = ""
	
	return CalendarNewEvent(...)
end

function GuildCalendarEvent._WoWCalendar:CalendarNewGuildEvent(...)
	if self.OpenedEvent then
		self.OpenedEvent:Close()
	end
	
	self.SelectedEventMonth = nil
	self.SelectedEventYear = nil
	self.SelectedEventDay = nil
	self.SelectedEventIndex = nil
	
	self.Description = ""
	self.DescriptionTag = ""
	self.Title = ""
	self.TitleTag = ""
	
	return CalendarNewGuildEvent(...)
end

function GuildCalendarEvent._WoWCalendar:CalendarNewGuildAnnouncement(...)
	if self.OpenedEvent then
		self.OpenedEvent:Close()
	end
	
	self.SelectedEventMonth = nil
	self.SelectedEventYear = nil
	self.SelectedEventDay = nil
	self.SelectedEventIndex = nil
	
	self.Description = ""
	self.DescriptionTag = ""
	self.Title = ""
	self.TitleTag = ""
	
	return CalendarNewGuildAnnouncement(...)
end

function GuildCalendarEvent._WoWCalendar:CalendarOpenEvent(pMonthOffset, pDay, pIndex, ...)
	if self.OpenedEvent then
		self.OpenedEvent:Close()
	end
	
	self.SelectedEventMonth = self.Month + pMonthOffset
	self.SelectedEventYear = self.Year
	self.SelectedEventDay = pDay
	self.SelectedEventIndex = pIndex
	
	while self.SelectedEventMonth > 12 do
		self.SelectedEventMonth = self.SelectedEventMonth - 12
		self.SelectedEventYear = self.SelectedEventYear + 1
	end
	
	while self.SelectedEventMonth < 1 do
		self.SelectedEventMonth = self.SelectedEventMonth + 12
		self.SelectedEventYear = self.SelectedEventYear - 1
	end
	
	self.Description = nil
	self.DescriptionTag = nil
	self.Title = nil
	self.TitleTag = nil
	
	return CalendarOpenEvent(pMonthOffset, pDay, pIndex, ...)
end

function GuildCalendarEvent._WoWCalendar:CalendarEventSetDate(pMonth, pDay, pYear, ...)
	self.SelectedEventMonth = pMonth
	self.SelectedEventYear = pDay
	self.SelectedEventDay = pYear
	
	return CalendarEventSetDate(pMonth, pDay, pYear, ...)
end

function GuildCalendarEvent._WoWCalendar:CalendarCloseEvent(...)
	local vResult = CalendarCloseEvent(...)
	
	if self.OpenedEvent and not self.OpenedEvent.ChangingMode then
		self.OpenedEvent:EventClosed()
		self.OpenedEvent = nil
	end
	
	return vResult
end

function GuildCalendarEvent._WoWCalendar:CalendarNewArenaTeamEvent(...)
	if self.OpenedEvent then
		self.OpenedEvent:Close()
	end
	
	self.SelectedEventMonth = nil
	self.SelectedEventYear = nil
	self.SelectedEventDay = nil
	self.SelectedEventIndex = nil
	
	self.Description = ""
	self.DescriptionTag = ""
	self.Title = ""
	self.TitleTag = ""
	
	return CalendarNewArenaTeamEvent(...)
end

function GuildCalendarEvent._WoWCalendar:CalendarGetDayEvent(...)
	local vResult = C_Calendar.GetDayEvent(...)
	vResult.title = self:ProcessTitle(vResult.title)
	return vResult
end

function GuildCalendarEvent._WoWCalendar:CalendarEventSetTitle(pTitle)
	if not self.Title then
		CalendarGetEventInfo()
	end
	
	self.Title = pTitle or ""
	
	if self.TitleTag and self.TitleTag ~= "" then
		local vResult = self.Title.." ["..self.TitleTag.."]"
		local vTrunc = self.Title:len()
		
		local vCount = 10
		
		while vResult:len() > GuildCalendarEvent.EVENT_MAX_TITLE_LENGTH do
			vCount = vCount - 1
			
			if vCount == 0 then
				error("CalendarEventSetTitle locked up while truncating")
			end
			
			local vTrunc = vResult:len() - GuildCalendarEvent.EVENT_MAX_TITLE_LENGTH
			vResult = self.Title:sub(1, -(vTrunc + 1)).." ["..self.TitleTag.."]"
		end
		
		return CalendarEventSetTitle(vResult)
	else
		return CalendarEventSetTitle(self.Title)
	end
end

function GuildCalendarEvent._WoWCalendar:CalendarGetEventInfo()
	local vResult = {CalendarGetEventInfo()}
	
	vResult[1] = self:ProcessTitle(vResult[1])
	vResult[2] = self:ProcessDescription(vResult[2])
	
	return unpack(vResult)
end

function GuildCalendarEvent._WoWCalendar:CalendarEventSetDescription(pDescription)
	if not self.Description then
		CalendarGetEventInfo()
	end
	
	self.Description = pDescription
	
	if self.DescriptionTag and self.DescriptionTag ~= "" then
		local vResult = self.Description.."\r["..self.DescriptionTag.."]"
		local vTrunc = self.Description:len()
		
		while vResult:len() > GuildCalendarEvent.EVENT_MAX_DESCRIPTION_LENGTH do
			local vTrunc = vResult:len() - GuildCalendarEvent.EVENT_MAX_DESCRIPTION_LENGTH
			vResult = self.Description:sub(1, -(vTrunc + 1)).."\r["..self.DescriptionTag.."]"
		end
		
		return CalendarEventSetDescription(vResult)
	else
		return CalendarEventSetDescription(self.Description)
	end
end

function GuildCalendarEvent._WoWCalendar:CalendarEventSetTitleTag(pTitleTag)
	if not self.Title then
		CalendarGetEventInfo()
	end
	
	self.TitleTag = pTitleTag
	self:CalendarEventSetTitle(self.Title) -- This will update the title tag portion as well
end

function GuildCalendarEvent._WoWCalendar:CalendarEventGetTitleTag()
	if not self.Title then
		self:CalendarGetEventInfo()
	end
	
	return self.TitleTag
end

function GuildCalendarEvent._WoWCalendar:CalendarEventSetDescriptionTag(pDescriptionTag)
	if not self.Description then
		self:CalendarGetEventInfo()
	end
	
	self.DescriptionTag = pDescriptionTag
	self:CalendarEventSetDescription(self.Description) -- This will update the description tag portion as well
end

function GuildCalendarEvent._WoWCalendar:CalendarEventGetDescriptionTag()
	if not self.Description then
		self:CalendarGetEventInfo()
	end
	
	return self.DescriptionTag
end

function GuildCalendarEvent._WoWCalendar:CalendarSetAbsMonth(pMonth, pYear, ...)
	if self.Month == pMonth and self.Year == pYear then
		return
	end
	
	self.Month = pMonth
	self.Year = pYear
	
	return CalendarSetAbsMonth(pMonth, pYear, ...)
end

function GuildCalendarEvent._WoWCalendar:CalendarGetAbsDayEvent(pMonth, pDay, pYear, pEventIndex)
	return self:CalendarGetDayEvent(self:CalendarGetMonthOffset(pMonth, pYear), pDay, pEventIndex)
end

function GuildCalendarEvent._WoWCalendar:CalendarGetDisplayTitle(pCalendarType, pSequenceType, pTitle)
	local vTitleFormats = GuildCalendarEvent.CALENDAR_CALENDARTYPE_NAMEFORMAT[pCalendarType]
	local vTitleFormat
	
	if vTitleFormats then
		vTitleFormat = vTitleFormats[pSequenceType]
	end
	
	if not vTitleFormat then
		vTitleFormat = "%s"
	end
	
	return vTitleFormat:format(pTitle or "")
end

function GuildCalendarEvent._WoWCalendar:CalendarGetMonthOffset(pMonth, pYear)
	pMonth = pMonth + 12 * (pYear - self.Year)
	
	return pMonth - self.Month
end

function GuildCalendarEvent._WoWCalendar:CalendarGetNumAbsDayEvents(pMonth, pDay, pYear)
	return self:CalendarGetNumDayEvents(self:CalendarGetMonthOffset(pMonth, pYear), pDay)
end

function GuildCalendarEvent._WoWCalendar:CalendarRemoveAbsEvent(pMonth, pDay, pYear, pEventIndex)
	return self:CalendarContextEventRemove(self:CalendarGetMonthOffset(pMonth, pYear), pDay, pEventIndex)
end

----------------------------------------
--
----------------------------------------

GuildCalendarEvent.CALENDAR_CALENDARTYPE_TEXTURE_PATHS = {
--	["PLAYER"]				= "",
--	["GUILD_ANNOUNCEMENT"]	= "",
--	["GUILD_EVENT"]			= "",
--	["SYSTEM"]				= "",
	["HOLIDAY"]				= "Interface\\Calendar\\Holidays\\",
--	["RAID_LOCKOUT"]		= "",
--	["RAID_RESET"]			= "",
}

GuildCalendarEvent.CALENDAR_CALENDARTYPE_TEXTURES =
{
	["PLAYER"] = {
--		[""]				= "",
	},
	["GUILD_ANNOUNCEMENT"] = {
--		[""]				= "",
	},
	["GUILD_EVENT"] = {
--		[""]				= "",
	},
	["SYSTEM"] = {
--		[""]				= "",
	},
	["HOLIDAY"] = {
		["START"]			= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
--		["ONGOING"]			= "",
		["END"]				= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
		["INFO"]			= "Interface\\Calendar\\Holidays\\Calendar_DefaultHoliday",
--		[""]				= "",
	},
	["RAID_LOCKOUT"] = {
--		[""]				= "",
	},
	["RAID_RESET"] = {
--		[""]				= "",
	},
}

GuildCalendarEvent.CALENDAR_CALENDARTYPE_TEXTURE_APPEND =
{
--	["PLAYER"] = {
--	},
--	["GUILD_ANNOUNCEMENT"] = {
--	},
--	["GUILD_EVENT"] = {
--	},
--	["SYSTEM"] = {
--	},
	["HOLIDAY"] = {
		["START"]			= "Start",
		["ONGOING"]			= "Ongoing",
		["END"]				= "End",
		["INFO"]			= "Info",
		[""]				= "",
	},
--	["RAID_LOCKOUT"] = {
--	},
--	["RAID_RESET"] = {
--	},
}

GuildCalendarEvent.CALENDAR_CALENDARTYPE_TCOORDS =
{
	["PLAYER"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["GUILD_ANNOUNCEMENT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["GUILD_EVENT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["SYSTEM"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["HOLIDAY"] = {
		left	= 0.0,
		right	= 0.7109375,
		top		= 0.0,
		bottom	= 0.7109375,
	},
	["RAID_LOCKOUT"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	["RAID_RESET"] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
}

GuildCalendarEvent.CALENDAR_MONTH_NAMES =
{
	MONTH_JANUARY,
	MONTH_FEBRUARY,
	MONTH_MARCH,
	MONTH_APRIL,
	MONTH_MAY,
	MONTH_JUNE,
	MONTH_JULY,
	MONTH_AUGUST,
	MONTH_SEPTEMBER,
	MONTH_OCTOBER,
	MONTH_NOVEMBER,
	MONTH_DECEMBER,
}

GuildCalendarEvent.CALENDAR_FULLDATE_MONTH_NAMES =
{
	FULLDATE_MONTH_JANUARY,
	FULLDATE_MONTH_FEBRUARY,
	FULLDATE_MONTH_MARCH,
	FULLDATE_MONTH_APRIL,
	FULLDATE_MONTH_MAY,
	FULLDATE_MONTH_JUNE,
	FULLDATE_MONTH_JULY,
	FULLDATE_MONTH_AUGUST,
	FULLDATE_MONTH_SEPTEMBER,
	FULLDATE_MONTH_OCTOBER,
	FULLDATE_MONTH_NOVEMBER,
	FULLDATE_MONTH_DECEMBER,
}

-- Event Types

GuildCalendarEvent.CALENDAR_EVENTTYPE_TEXTURE_PATHS = {
	[CALENDAR_EVENTTYPE_RAID]		= "Interface\\LFGFrame\\LFGIcon-",
	[CALENDAR_EVENTTYPE_DUNGEON]	= "Interface\\LFGFrame\\LFGIcon-",
}
GuildCalendarEvent.CALENDAR_EVENTTYPE_TEXTURES = {
	[CALENDAR_EVENTTYPE_RAID]		= "Interface\\LFGFrame\\LFGIcon-Raid",
	[CALENDAR_EVENTTYPE_DUNGEON]	= "Interface\\LFGFrame\\LFGIcon-Dungeon",
	[CALENDAR_EVENTTYPE_PVP]		= "Interface\\Calendar\\UI-Calendar-Event-PVP",
	[CALENDAR_EVENTTYPE_MEETING]	= "Interface\\Calendar\\MeetingIcon",
	[CALENDAR_EVENTTYPE_OTHER]		= "Interface\\Calendar\\UI-Calendar-Event-Other",
}

GuildCalendarEvent.CALENDAR_EVENTTYPE_TCOORDS = {
	[CALENDAR_EVENTTYPE_RAID] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_DUNGEON] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_PVP] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_MEETING] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
	[CALENDAR_EVENTTYPE_OTHER] = {
		left	= 0.0,
		right	= 1.0,
		top		= 0.0,
		bottom	= 1.0,
	},
}

GuildCalendarEvent.CALENDAR_CALENDARTYPE_NAMEFORMAT =
{
	HOLIDAY =
	{
		START = CALENDAR_EVENTNAME_FORMAT_START,
		END = CALENDAR_EVENTNAME_FORMAT_END,
	},
	RAID_LOCKOUT =
	{
		[""] = CALENDAR_EVENTNAME_FORMAT_RAID_LOCKOUT,
	},
	RAID_RESET =
	{
		[""] = CALENDAR_EVENTNAME_FORMAT_RAID_RESET,
	},
}

GuildCalendarEvent.TitleTagInfo =
{
	BRTH =
	{
		CanEdit = true,
		AllDay = true,
		Texture = GuildCalendarEvent.AddonPath.."Textures\\Icon-Birth",
		IsPersonal = true,
		IsCooldown = false,
		UsesAttendance = true,
		Defaults = {CalendarType = "PLAYER", Title = GuildCalendarEvent.cBirthdayTitleFormat},
	},
	MD =
	{
		CanEdit = true,
		Texture = "Interface\\Icons\\Spell_Holy_SealOfSacrifice", -- Doctor
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		UsesAttendance = true,
		Defaults = {CalendarType = "PLAYER", Title = GuildCalendarEvent.cDoctorEventName},
	},
	DDS =
	{
		CanEdit = true,
		Texture = "Interface\\Icons\\INV_Misc_Bone_09", -- Dentist
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		UsesAttendance = true,
		Defaults = {CalendarType = "PLAYER", Title = GuildCalendarEvent.cDentistEventName},
	},
	VAC =
	{
		CanEdit = true,
		Texture = GuildCalendarEvent.AddonPath.."Textures\\Icon-Vacation", -- Vacation
		IsPersonal = true,
		UsesAttendance = true,
		Defaults = {CalendarType = "PLAYER", Title = GuildCalendarEvent.cVacationEventName},
	},
	RP =
	{
		CanEdit = true,
		Texture = GuildCalendarEvent.AddonPath.."Textures\\Icon-RP", -- Roleplaying
		IsPersonal = false,
		UsesAttendance = true,
		Defaults = {Title = GuildCalendarEvent.cRoleplayEventName},
	},
	
	-- Cooldowns
	
	XMUT =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\Trade_Alchemy", -- Transmutes
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	ALCH =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Potion_106", -- Alchemy Research
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	VOID =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Enchant_ShardPrismaticLarge", -- Void Shatter
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	SPHR =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Enchant_VoidSphere", -- Void Sphere 
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	MOON =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_MoonRag_01", -- Mooncloth
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	PMON = 
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Moonshroud", -- Primal Mooncloth
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	SPEL =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Spellfire", -- Spellcloth
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	SHAD =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Felcloth_Ebon", -- Shadowcloth
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	EBON =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Ebonweave", -- Ebonweave
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	SWEV =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Spellweave", -- Spellweave
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	SHRD =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Fabric_Moonshroud", -- Moonshroud
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	GLSS =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Misc_Gem_02", -- Brilliant Glass
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	ICYP =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Misc_Gem_Diamond_02", -- Icy Prism
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	FIRP =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Misc_Gem_Ruby_01", -- Fire Prism
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	INSC =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Inscription_Tradeskill01", -- Inscription Research
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	INSN =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Inscription_Tradeskill01", -- Northrend Inscription Research
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
	TITN =
	{
		CanEdit = false,
		Texture = "Interface\\Icons\\INV_Ingot_Titansteel_blue", -- Smelt Titansteel
		TexCoords = {left = 0.0625, right = 0.9375, top = 0.0625, bottom = 0.9375},
		IsPersonal = true,
		IsCooldown = true,
		UsesAttendance = false,
	},
}

GuildCalendarEvent.CALENDAR_TITLETAG_DEFAULT_TCOORDS =
{
	left	= 0.0,
	right	= 1.0,
	top		= 0.0,
	bottom	= 1.0,
}

GuildCalendarEvent.CALENDAR_TITLETAG_TCOORDS =
{
}

function GuildCalendarEvent:GetTextureFile(pTextureName, pCalendarType, pSequenceType, pEventType, pTitleTag)
	local vTexture, vTexCoords
	
	-- GuildCalendarEvent:DebugMessage("GetTextureFile: %s (CalType: %s SeqType: %s EventType: %s)", pTextureName or "nil", pCalendarType or "nil", pSequenceType or "nil", pEventType or "nil")
	
	if pTitleTag and self.TitleTagInfo[pTitleTag] then
		vTexture = self.TitleTagInfo[pTitleTag].Texture
		vTexCoords = self.TitleTagInfo[pTitleTag].TexCoords or GuildCalendarEvent.CALENDAR_TITLETAG_DEFAULT_TCOORDS
	elseif pTextureName and pTextureName ~= "" then
		-- pTextureName is actually a texture ID which can be used directly in the call to SetTexture()
		vTexture = pTextureName
		if self.CALENDAR_CALENDARTYPE_TEXTURE_PATHS[pCalendarType] then
			-- vTexture = self.CALENDAR_CALENDARTYPE_TEXTURE_PATHS[pCalendarType]..pTextureName
			-- if self.CALENDAR_CALENDARTYPE_TEXTURE_APPEND[pCalendarType] then
			-- 	vTexture = vTexture..self.CALENDAR_CALENDARTYPE_TEXTURE_APPEND[pCalendarType][pSequenceType]
			-- end
			vTexCoords = self.CALENDAR_CALENDARTYPE_TCOORDS[pCalendarType]
		elseif self.CALENDAR_EVENTTYPE_TEXTURE_PATHS[pEventType] then
			-- vTexture = self.CALENDAR_EVENTTYPE_TEXTURE_PATHS[pEventType]..pTextureName
			vTexCoords = self.CALENDAR_EVENTTYPE_TCOORDS[pEventType]
		elseif self.CALENDAR_CALENDARTYPE_TEXTURES[pCalendarType][pSequenceType] then
			-- vTexture = self.CALENDAR_CALENDARTYPE_TEXTURES[pCalendarType][pSequenceType]
			vTexCoords = self.CALENDAR_CALENDARTYPE_TCOORDS[pCalendarType]
		elseif self.CALENDAR_EVENTTYPE_TEXTURES[pEventType] then
			-- vTexture = self.CALENDAR_EVENTTYPE_TEXTURES[pEventType]
			vTexCoords = self.CALENDAR_EVENTTYPE_TCOORDS[pEventType]
		end
	elseif self.CALENDAR_CALENDARTYPE_TEXTURES[pCalendarType][pSequenceType] then
		vTexture = self.CALENDAR_CALENDARTYPE_TEXTURES[pCalendarType][pSequenceType]
		vTexCoords = self.CALENDAR_CALENDARTYPE_TCOORDS[pCalendarType]
	elseif self.CALENDAR_EVENTTYPE_TEXTURES[pEventType] then
		vTexture = self.CALENDAR_EVENTTYPE_TEXTURES[pEventType]
		vTexCoords = self.CALENDAR_EVENTTYPE_TCOORDS[pEventType]
	end
		
	return vTexture, vTexCoords
end

function GuildCalendarEvent:GetTextureCache()
	if not self.textureCache then
		self.textureCache = {}
		self.textureCache[CALENDAR_EVENTTYPE_RAID] = self:TextureCacheForEventType(CALENDAR_EVENTTYPE_RAID, CalendarEventGetTextures(CALENDAR_EVENTTYPE_RAID))
		self.textureCache[CALENDAR_EVENTTYPE_DUNGEON] = self:TextureCacheForEventType(CALENDAR_EVENTTYPE_DUNGEON, CalendarEventGetTextures(CALENDAR_EVENTTYPE_DUNGEON))
	end
	return self.textureCache
end

function GuildCalendarEvent:TextureCacheForEventType(eventType, ...)
	local eventTypeTextureCache = {}

	local STRIDE = 6
	local numTextures = select("#", ...) / STRIDE
	if numTextures <= 0 then
		return false
	end

	local overlappingMapIDs = (eventType == CALENDAR_EVENTTYPE_RAID or eventType == CALENDAR_EVENTTYPE_DUNGEON) and {}

	local cacheIndex = 1
	for textureIndex = 1, numTextures do
		if not eventTypeTextureCache[cacheIndex] then
			eventTypeTextureCache[cacheIndex] = {}
		end

		local title, texture, expansionLevel, difficultyID, mapID, isLFR = select((textureIndex - 1) * STRIDE + 1, ...)
		local difficultyName, instanceType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(difficultyID)
		if not difficultyName then
			difficultyName = ""
		end

		if overlappingMapIDs and overlappingMapIDs[mapID] then
			-- Already exists a map, collapse the difficulty
			local firstCacheIndex = overlappingMapIDs[mapID]
			local cacheEntry = eventTypeTextureCache[firstCacheIndex]

			if cacheEntry.isLFR and not isLFR then
				-- Prefer a non-LFR name over a LFR name
				cacheEntry.title = title
				cacheEntry.isLFR = nil
			end

			if cacheEntry.displayHeroic or cacheEntry.displayMythic and (not displayHeroic and not displayMythic) then
				-- Prefer normal difficulty name over higher difficulty
				cacheEntry.title = title
				cacheEntry.displayHeroic = nil
				cacheEntry.displayMythic = nil
			end

			table.insert(cacheEntry.difficulties, { textureIndex = textureIndex, difficultyName = difficultyName })
		else
			eventTypeTextureCache [cacheIndex].textureIndex = textureIndex
			eventTypeTextureCache [cacheIndex].title = title
			eventTypeTextureCache [cacheIndex].texture = texture
			eventTypeTextureCache [cacheIndex].expansionLevel = expansionLevel
			eventTypeTextureCache [cacheIndex].difficultyName = difficultyName
			eventTypeTextureCache [cacheIndex].isLFR = isLFR
			eventTypeTextureCache [cacheIndex].displayHeroic = displayHeroic
			eventTypeTextureCache [cacheIndex].displayMythic = displayMythic

			if overlappingMapIDs then
				if not overlappingMapIDs[mapID] then
					overlappingMapIDs[mapID] = cacheIndex
				end
				eventTypeTextureCache [cacheIndex].difficulties = { { textureIndex = textureIndex, difficultyName = difficultyName } }
			end

			cacheIndex = cacheIndex + 1
		end
	end

	return eventTypeTextureCache
end

function GuildCalendarEvent:GetEventTexture(index, eventType)
	local textureCache = self:GetTextureCache()
	local eventTextureCache = textureCache[eventType]

	if not eventTextureCache then
		return nil
	end

	for cacheIndex, textureInfo in ipairs(eventTextureCache) do
		if textureInfo.difficulties then
			for difficultyIndex, difficultyInfo in ipairs(textureInfo.difficulties) do
				if difficultyInfo.textureIndex == index then
					return textureInfo, difficultyInfo
				end
			end
		end

		if textureInfo.textureIndex and index == textureInfo.textureIndex then
			return textureInfo
		end
	end
	return nil
end

function GuildCalendarEvent:toluastring(pValue)
	if type(pValue) == "string" then
		return "\""..pValue.."\""
	else
		return tostring(pValue)
	end
end

function GuildCalendarEvent:ShowFunctionParameters(pFunctionName, pResult, ...)
	local vFunctionParams

	for vIndex = 1, select("#", ...) do
		if not vFunctionParams then
			vFunctionParams = self:toluastring(select(vIndex, ...))
		else
			vFunctionParams = vFunctionParams..", "..self:toluastring(select(vIndex, ...))
		end
	end
	
	local vResults
	
	for vIndex, vResult in ipairs(pResult) do
		if not vResults then
			vResults = self:toluastring(vResult)
		else
			vResults = vResults..", "..self:toluastring(vResult)
		end
	end
	
	GuildCalendarEvent:DebugMessage("%s(%s) returned %s", pFunctionName, vFunctionParams or "", vResults or "nil")
end

function GuildCalendarEvent:MonitorCalendarAPIRecursion()
	if self.PatchedWoWCalendarAPIRecursion then
		return
	end
	
	self.InWoWAPI = {}
	
	for _, vFunctionName in ipairs(self.cBlizzardCalendarFunctionNames) do
		local vOrigFunction = _G[vFunctionName]
		
		if vOrigFunction then
			_G[vFunctionName] = function (...)
				if self.InWoWAPI[vFunctionName] then
					GuildCalendarEvent:DebugMessage("Recursive call to %s", vFunctionName)
					GuildCalendarEvent:DebugStack()
					return
				end
				
				self.InWoWAPI[vFunctionName] = true
				
				local vResult = {vOrigFunction(...)}
				
				self.InWoWAPI[vFunctionName] = nil
				
				return unpack(vResult)
			end
		end
	end
	
	self.PatchedWoWCalendarAPIRecursion = true
end

function GuildCalendarEvent:MonitorCalendarAPI()
	if not self.PatchedWoWCalendarAPI then
		self.InWoWAPI = {}
		
		for _, vFunctionName in ipairs(self.cBlizzardCalendarFunctionNames) do
			local vOrigFunction = _G[vFunctionName]
			
			if vOrigFunction then
				if false
				and (vFunctionName == "CalendarCloseEvent"
				or vFunctionName == "CalendarNewEvent") then
					_G[vFunctionName] = function (...)
						local vResult = {vOrigFunction(...)}
						
						GuildCalendarEvent:ShowFunctionParameters(vFunctionName, vResult, ...)
						GuildCalendarEvent:DebugStack()
						
						return unpack(vResult)
					end
				else
					_G[vFunctionName] = function (...)
						local vResult = {vOrigFunction(...)}
						
						GuildCalendarEvent:ShowFunctionParameters(vFunctionName, vResult, ...)
						
						return unpack(vResult)
					end
				end
			end
		end
		
		self.PatchedWoWCalendarAPI = true
	end
end