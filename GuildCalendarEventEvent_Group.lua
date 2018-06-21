----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

GuildCalendarEvent.cInviteStatusMessages =
{
	SELECT = GuildCalendarEvent.cInviteNeedSelectionStatus,
	READY = GuildCalendarEvent.cInviteReadyStatus,
	INVITING = GuildCalendarEvent.cInviteInvitingStatus,
	COMPLETE = GuildCalendarEvent.cInviteCompleteStatus,
	CONVERTING = GuildCalendarEvent.cInviteConvertingToRaidStatus,
	WAITING = GuildCalendarEvent.cInviteAwaitingAcceptanceStatus,
	FULL = GuildCalendarEvent.cRaidFull,
}

----------------------------------------
GuildCalendarEvent.UI._EventGroup = {}
----------------------------------------

GuildCalendarEvent.UI._EventGroup.GroupByTitle =
{
	ROLE = GuildCalendarEvent.cViewByRole,
	CLASS = GuildCalendarEvent.cViewByClass,
	STATUS = GuildCalendarEvent.cViewByStatus,
}

GuildCalendarEvent.UI._EventGroup.SortByTitle =
{
	DATE = GuildCalendarEvent.cViewByDate,
	RANK = GuildCalendarEvent.cViewByRank,
	NAME = GuildCalendarEvent.cViewByName,
}

function GuildCalendarEvent.UI._EventGroup:New(pParentFrame)
	return CreateFrame("Frame", nil, pParentFrame)
end

function GuildCalendarEvent.UI._EventGroup:Construct(pParentFrame)
	self:SetAllPoints()
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	
	self.Groups = {}
	self.SelectedPlayers = {}
end

function GuildCalendarEvent.UI._EventGroup:Initialize()
	if self.Initialized then return end
	self.Initialized = true
	self.ViewMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:ViewMenuFunc(...) end, 180)
	self.ViewMenu:SetPoint("TOPRIGHT", self, "TOPRIGHT", -9, -29)
	self.ViewMenu.ItemClicked = function (pMenu, pItemID)
		if pItemID:sub(1, 6) == "GROUP_" then
			self:SetGroupBy(pItemID:sub(7))
		elseif pItemID:sub(1, 5) == "SORT_" then
			self:SetSortBy(pItemID:sub(6))
		end
	end
	
	self.TotalsSection = CreateFrame("Frame", nil, self)
	self.TotalsSection:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -9, 32)
	self.TotalsSection:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 32)
	self.TotalsSection:SetHeight(64)
	self.TotalsSection.Background = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._StretchTextures, GuildCalendarEvent.UIElementsLib._PanelSectionBackgroundInfo, self.TotalsSection, "BACKGROUND")
	
	self.TotalLabelH = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalLabelH:SetPoint("TOPRIGHT", self.TotalsSection, "TOPRIGHT", -45, -6)
	self.TotalLabelH:SetText(GuildCalendarEvent.RAID_CLASS_COLOR_CODES.PRIEST..GuildCalendarEvent.cHPluralLabel)
	
	self.TotalValues = {}
	
	self.TotalValues.H = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalValues.H:SetPoint("LEFT", self.TotalLabelH, "RIGHT", 4, 0)
	self.TotalValues.H:SetText("7 (+4)")
	
	self.TotalLabelT = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalLabelT:SetPoint("TOPRIGHT", self.TotalLabelH, "TOPRIGHT", 0, -14)
	self.TotalLabelT:SetText(GuildCalendarEvent.RAID_CLASS_COLOR_CODES.WARRIOR..GuildCalendarEvent.cTPluralLabel)
	
	self.TotalValues.T = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalValues.T:SetPoint("LEFT", self.TotalLabelT, "RIGHT", 4, 0)
	self.TotalValues.T:SetText("0")
	
	self.TotalLabelR = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalLabelR:SetPoint("TOPRIGHT", self.TotalLabelT, "TOPRIGHT", 0, -14)
	self.TotalLabelR:SetText(GuildCalendarEvent.RAID_CLASS_COLOR_CODES.MAGE..GuildCalendarEvent.cRPluralLabel)
	
	self.TotalValues.R = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalValues.R:SetPoint("LEFT", self.TotalLabelR, "RIGHT", 4, 0)
	self.TotalValues.R:SetText("0")
	
	self.TotalLabelM = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalLabelM:SetPoint("TOPRIGHT", self.TotalLabelR, "TOPRIGHT", 0, -14)
	self.TotalLabelM:SetText(GuildCalendarEvent.RAID_CLASS_COLOR_CODES.ROGUE..GuildCalendarEvent.cMPluralLabel)
	
	self.TotalValues.M = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.TotalValues.M:SetPoint("LEFT", self.TotalLabelM, "RIGHT", 4, 0)
	self.TotalValues.M:SetText("0")
	
	self.StartEventHelp = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.StartEventHelp:SetPoint("TOPLEFT", self.TotalsSection, "TOPLEFT", 15, -5)
	self.StartEventHelp:SetPoint("BOTTOMRIGHT", self.TotalsSection, "BOTTOMRIGHT", -100, 5)
	self.StartEventHelp:SetText(GuildCalendarEvent.cStartEventHelp)
	
	--
	
	self.StatusSection = CreateFrame("Frame", nil, self)
	self.StatusSection:SetPoint("BOTTOMRIGHT", self.TotalsSection, "TOPRIGHT", 0, 0)
	self.StatusSection:SetPoint("BOTTOMLEFT", self.TotalsSection, "TOPLEFT", 0, 0)
	self.StatusSection:SetHeight(25)
	self.StatusSection.Background = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._StretchTextures, GuildCalendarEvent.UIElementsLib._PanelSectionBackgroundInfo, self.StatusSection, "BACKGROUND")
	
	self.StartEventButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self.StatusSection, GuildCalendarEvent.cStart, 100)
	self.StartEventButton:SetPoint("LEFT", self.StatusSection, "LEFT", 15, 0)
	self.StartEventButton:SetScript("OnClick", function ()
		local vEvent = self.Event.OriginalEvent or self.Event
		
		if GuildCalendarEvent.RunningEvent ~= self.Event
		and (vEvent.StartDate or vEvent.ElapsedSeconds)
		and IsModifierKeyDown() then
			GuildCalendarEvent:RestartEvent(self.Event)
			self:Rebuild()
		else
			GuildCalendarEvent:StopEvent()
			GuildCalendarEvent:StartEvent(self.Event, function (...) self:InviteNotification(...) end)
		end
	end)
	
	self.StartEventButton:SetScript("OnUpdate", function (pButton)
		local vEvent = self.Event.OriginalEvent or self.Event
		
		if vEvent.StartDate or vEvent.ElapsedSeconds then -- The event has been started before
			if IsModifierKeyDown() then
				pButton:SetTitle(GuildCalendarEvent.cRestart)
			else
				pButton:SetTitle(GuildCalendarEvent.cResume)
			end
		else -- It's a fresh event
			pButton:SetTitle(GuildCalendarEvent.cStart)
		end
	end)
	
	self.StopEventButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self.StatusSection, GuildCalendarEvent.cPause, 100)
	self.StopEventButton:SetPoint("LEFT", self.StartEventButton, "LEFT")
	self.StopEventButton:SetScript("OnClick", function ()
		self:ClearSelection()
		
		GuildCalendarEvent:StopEvent()

		if IsModifierKeyDown() then
			GuildCalendarEvent:RestartEvent(self.Event)
			GuildCalendarEvent:StartEvent(self.Event, function (...) self:InviteNotification(...) end)
		end
	end)
	self.StopEventButton:SetScript("OnUpdate", function (pButton)
		if IsModifierKeyDown() then
			pButton:SetTitle(GuildCalendarEvent.cRestart)
		else
			pButton:SetTitle(GuildCalendarEvent.cPause)
		end
	end)
	
	self.EventStatus = self.StatusSection:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.EventStatus:SetPoint("LEFT", self.StartEventButton, "RIGHT", 10, 0)
	self.EventStatus:SetText("99:99:99")
	
	self.GrandTotalLabel = self.StatusSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.GrandTotalLabel:SetPoint("RIGHT", self.StatusSection, "RIGHT", -45, 0)
	self.GrandTotalLabel:SetText(GuildCalendarEvent.cTotalLabel)
	
	self.GrandTotalValue = self.StatusSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.GrandTotalValue:SetPoint("LEFT", self.GrandTotalLabel, "RIGHT", 4, 0)
	self.GrandTotalValue:SetText("0")
	
	--
	
	self.AutoSelectButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self.TotalsSection, "Select...", 100)
	self.AutoSelectButton:SetPoint("TOPLEFT", self.TotalsSection, "TOPLEFT", 15, -6)
	self.AutoSelectButton:SetScript("OnClick", function ()
		GuildCalendarEvent.UI.RoleLimitsDialog:SetParent(self)
		GuildCalendarEvent.UI.RoleLimitsDialog:SetFrameLevel(self:GetFrameLevel() + 30)
		GuildCalendarEvent.UI.RoleLimitsDialog:ClearAllPoints()
		GuildCalendarEvent.UI.RoleLimitsDialog:SetPoint("CENTER", self, "CENTER")
		GuildCalendarEvent.UI.RoleLimitsDialog:Open(self.AutoSelectLimits or self.Event.Limits, GuildCalendarEvent.cAutoConfirmRoleLimitsTitle, true, function (pLimits)
			self.AutoSelectLimits = pLimits
			self:AutoSelectFromLimits(pLimits)
		end)
	end)
	
	self.AutoSelectHelp = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.AutoSelectHelp:SetPoint("LEFT", self.AutoSelectButton, "RIGHT", 10, 0)
	self.AutoSelectHelp:SetPoint("RIGHT", self.StartEventHelp, "RIGHT", 0, 0)
	self.AutoSelectHelp:SetPoint("TOP", self.AutoSelectButton, "TOP", 0, 5)
	self.AutoSelectHelp:SetPoint("BOTTOM", self.AutoSelectButton, "BOTTOM", 0, -5)
	self.AutoSelectHelp:SetText(GuildCalendarEvent.cNoSelection)
	self.AutoSelectHelp:SetJustifyH("LEFT")
	
	self.InviteSelectedButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self.TotalsSection, INVITE, 100)
	self.InviteSelectedButton:SetPoint("TOPLEFT", self.AutoSelectButton, "BOTTOMLEFT", 0, -5)
	self.InviteSelectedButton:SetScript("OnClick", function (pFrame, pButton)
		self:InviteSelectedPlayers()
	end)
	
	self.InviteSelectedHelp = self.TotalsSection:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.InviteSelectedHelp:SetPoint("LEFT", self.InviteSelectedButton, "RIGHT", 10, 0)
	self.InviteSelectedHelp:SetPoint("RIGHT", self.StartEventHelp, "RIGHT", 0, 0)
	self.InviteSelectedHelp:SetPoint("TOP", self.InviteSelectedButton, "TOP", 0, 5)
	self.InviteSelectedHelp:SetPoint("BOTTOM", self.InviteSelectedButton, "BOTTOM", 0, -5)
	self.InviteSelectedHelp:SetText(GuildCalendarEvent.cInviteNeedSelectionStatus)
	self.InviteSelectedHelp:SetJustifyH("LEFT")
	
	self.ScrollingList = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingItemList, self, self._ListItem, self._ListItem.cItemHeight)
	self.ScrollingList.DrawingFunc = function () self:Refresh() end
	
	self.ScrollingList:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -62)
	self.ScrollingList:SetPoint("BOTTOMRIGHT", self.StatusSection, "TOPRIGHT", 0, 0)
	
	self.ExpandAll = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ExpandAllButton, self)
	self.ExpandAll:SetPoint("TOPLEFT", self.ScrollingList, "TOPLEFT", 5, 25)
	self.ExpandAll:SetScript("OnClick", function (pButton)
		self:SetExpandAll(not not pButton:GetChecked()) -- I don't like using 'not not', but it's the easiest way to force a boolean value :/
	end)
	
	self.SelectAllButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, ALL)
	self.SelectAllButton:SetWidth(14)
	self.SelectAllButton:SetHeight(14)
	self.SelectAllButton:SetPoint("LEFT", self.ExpandAll.TabRight, "RIGHT", 3, -2)
	self.SelectAllButton:SetScript("OnClick", function (pButton)
		if pButton:GetChecked() then
			self:SelectAll()
		else
			self:ClearSelection()
		end
	end)
end

function GuildCalendarEvent.UI._EventGroup:SetEvent(pEvent, pIsNewEvent)
	self:Initialize()
	GuildCalendarEvent.EventLib:UnregisterEvent("GROUP_ROSTER_UPDATE", self.ScheduleRebuild, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("PARTY_LEADER_CHANGED", self.ScheduleRebuild, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
	
	GuildCalendarEvent.BroadcastLib:StopListening(nil, self.EventMessage, self)
	
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.UpdateElapsed, self)
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.Rebuild, self)
	
	--
	
	self.Event = pEvent
	self.IsNewEvent = pIsNewEvent
	
	if not self.Event then
		for vKey, _ in ipairs(self.Groups) do
			self.Groups[vKey] = nil
		end
		
		self.InvitedGroup = nil
		self.AcceptedGroup = nil
		self.TentativeGroup = nil
		self.ConfirmedGroup = nil
		self.StandbyGroup = nil
		self.DeclinedGroup = nil
		self.OutGroup = nil
		
		return
	end
	
	self.InvitedGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_INVITED, self.Event, false)
	self.AcceptedGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_ACCEPTED, self.Event, true)
	self.TentativeGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_TENTATIVE, self.Event, true)
	self.ConfirmedGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup,CALENDAR_STATUS_CONFIRMED, self.Event, true)
	self.StandbyGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_STANDBY, self.Event, true)
	self.DeclinedGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_DECLINED, self.Event, false)
	self.OutGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, CALENDAR_STATUS_OUT, self.Event, false)
	self.LeftGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, "Left Group", self.Event, false)
	self.UnknownGroup = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, GuildCalendarEvent.cUnknown, self.Event, false)
	
	self.SortBy = "NAME"
	self:SetGroupBy("ROLE")
	
	GuildCalendarEvent.BroadcastLib:Listen(self.Event, self.EventMessage, self)
	
	GuildCalendarEvent.EventLib:RegisterEvent("GROUP_ROSTER_UPDATE", self.ScheduleRebuild, self, true)
	GuildCalendarEvent.EventLib:RegisterEvent("PARTY_LEADER_CHANGED", self.ScheduleRebuild, self, true)
	GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
end

function GuildCalendarEvent.UI._EventGroup:SaveEventFields()
	-- Nothing to do, event is updated as the user manipulates it
end

function GuildCalendarEvent.UI._EventGroup:SetExpandAll(pExpandAll)
	for vIndex, vGroup in ipairs(self.Groups) do
		if vGroup:GetNumMembers() > 0 then
			vGroup.Expanded = pExpandAll
		end
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._EventGroup:AllSelected()
	local vAttendance = self.Event:GetAttendance()
	
	if not vAttendance then
		return false
	end
	
	for vName, vPlayerInfo in pairs(vAttendance) do
		if self:IsSelectAllCandidate(vPlayerInfo)
		and not self.SelectedPlayers[vName] then
			return false
		end
	end
	
	if next(self.SelectedPlayers) then
		return true
	else
		return false
	end
end

function GuildCalendarEvent.UI._EventGroup:SelectAll()
	local vAttendance = self.Event:GetAttendance()
	
	for vKey, _ in pairs(self.SelectedPlayers) do
		self.SelectedPlayers[vKey] = nil
	end
	
	for vName, vPlayerInfo in pairs(vAttendance) do
		if self:IsSelectAllCandidate(vPlayerInfo) then
			self.SelectedPlayers[vName] = true
		end
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._EventGroup:IsSelectAllCandidate(pPlayerInfo)
	return (pPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
	     or pPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
	     or pPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP
	     or pPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_STANDBY
	     or pPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED)
	and (not self.Event.Group
	  or not self.Event.Group[pPlayerInfo.Name]
	  or self.Event.Group[pPlayerInfo.Name].LeftGroup)
end

function GuildCalendarEvent.UI._EventGroup:ClearSelection()
	for vKey, _ in pairs(self.SelectedPlayers) do
		self.SelectedPlayers[vKey] = nil
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._EventGroup:AutoSelectFromLimits(pLimits)
	local vAvailableSlots = GuildCalendarEvent:New(GuildCalendarEvent._AvailableSlots, pLimits, "ROLE")
	local vAttendance = self.Event:GetAttendance()
	
	vAvailableSlots:AddEventGroup(self.Event)
	
	self:ClearSelection()
	
	for vName, vPlayerInfo in pairs(vAttendance) do
		if (vPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_STANDBY
		or vPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
		or vPlayerInfo.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE)
		and (not self.Event.Group
		 or not self.Event.Group[vName]
		 or self.Event.Group[vName].LeftGroup) then
			if vAvailableSlots:AddPlayer(vPlayerInfo) then
				self.SelectedPlayers[vName] = true
			end
		end
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._EventGroup:InviteSelectedPlayers()
	local vAttendance = self.Event:GetAttendance()
	
	for vPlayerName, _ in pairs(self.SelectedPlayers) do
		local vPlayerInfo = vAttendance and vAttendance[vPlayerName]
		local vPlayerGroupInfo = self.Event.Group and self.Event.Group[vPlayerName]
		
		if (vPlayerInfo or vPlayerGroupInfo)
		and (not vPlayerGroupInfo or vPlayerGroupInfo.LeftGroup) then
			GuildCalendarEvent.RaidInvites:InvitePlayer(vPlayerName)
		end
	end
end

function GuildCalendarEvent.UI._EventGroup:InviteNotification(pMessageID, ...)
	if not self.Event then
		return
	end
	
	if pMessageID == "STATUS" then
		local vStatus = select(1, ...)
		self.RaidInviteStatus = vStatus
		self:Rebuild()
	elseif pMessageID == "PLAYER" then
		local vPlayerName = select(1, ...)
		local vStatus = select(2, ...)
		local vPlayerInfo = self.Event:GetAttendance()[vPlayerName]
		
		if not vPlayerInfo then
			return
		end
		
		if vStatus == "JOINED" then
			vStatus = nil
			self.SelectedPlayers[vPlayerName] = nil
		end
		
		vPlayerInfo.RaidInviteStatus = vStatus
		self:Rebuild()
	end
end

function GuildCalendarEvent.UI._EventGroup:EventMessage(pEvent, pMessageID)
	if pMessageID == "INVITES_CHANGED" then
		self:Rebuild()
	end
end

function GuildCalendarEvent.UI._EventGroup:OnShow()
	PlaySound("839")
	self:Initialize()
	self:Rebuild()
	GuildCalendarEvent.SchedulerLib:ScheduleUniqueRepeatingTask(0.25, self.UpdateElapsed, self)
end

function GuildCalendarEvent.UI._EventGroup:OnHide()
	PlaySound("840")
	
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.UpdateElapsed, self)
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.Rebuild, self)
end

function GuildCalendarEvent.UI._EventGroup:UpdateElapsed()
	local vElapsed = GuildCalendarEvent:GetEventElapsedSeconds(self.Event)
	
	if vElapsed == 0 then
		self.EventStatus:SetText("")
	else
		local vHours = math.floor(vElapsed / 3600)
		local vHoursRemainder = vElapsed - vHours * 3600
		local vMinutes = math.floor(vHoursRemainder / 60)
		local vSeconds = vHoursRemainder - vMinutes * 60
		
		self.EventStatus:SetText(string.format("%02d:%02d:%02d", vHours, vMinutes, vSeconds))
	end
end

function GuildCalendarEvent.UI._EventGroup:SetGroupBy(pGroupBy)
	for vKey, _ in ipairs(self.Groups) do
		self.Groups[vKey] = nil
	end
	
	self.GroupBy = pGroupBy
	
	table.insert(self.Groups, self.InvitedGroup)
	table.insert(self.Groups, self.AcceptedGroup)
	table.insert(self.Groups, self.TentativeGroup)
	
	self.RoleGroups = nil
	self.ClassGroups = nil
	
	if self.GroupBy == "ROLE" then
		self.RoleGroups = {}
		
		self.RoleGroups.H = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, GuildCalendarEvent.cHPluralRole, self.Event, true)
		self.RoleGroups.T = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, GuildCalendarEvent.cTPluralRole, self.Event, true)
		self.RoleGroups.R = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, GuildCalendarEvent.cRPluralRole, self.Event, true)
		self.RoleGroups.M = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, GuildCalendarEvent.cMPluralRole, self.Event, true)
		
		table.insert(self.Groups, self.RoleGroups.H)
		table.insert(self.Groups, self.RoleGroups.T)
		table.insert(self.Groups, self.RoleGroups.R)
		table.insert(self.Groups, self.RoleGroups.M)
	elseif self.GroupBy == "CLASS" then
		self.ClassGroups = {}
		
		for _, vClassID in ipairs(CLASS_SORT_ORDER) do
			self.ClassGroups[vClassID] = GuildCalendarEvent:New(GuildCalendarEvent._PlayerGroup, LOCALIZED_CLASS_NAMES_MALE[vClassID], self.Event, true)
			table.insert(self.Groups, self.ClassGroups[vClassID])
		end
	elseif self.GroupBy == "STATUS" then
		table.insert(self.Groups, self.ConfirmedGroup)
	end
	
	table.insert(self.Groups, self.UnknownGroup)
	table.insert(self.Groups, self.StandbyGroup)
	table.insert(self.Groups, self.LeftGroup)
	table.insert(self.Groups, self.DeclinedGroup)
	table.insert(self.Groups, self.OutGroup)
	
	self:Rebuild()
end

function GuildCalendarEvent.UI._EventGroup:SetSortBy(pSortBy)
	self.SortBy = pSortBy
	self:Rebuild()
end

function GuildCalendarEvent.UI._EventGroup:ScheduleRebuild()
	GuildCalendarEvent.SchedulerLib:ScheduleUniqueTask(0.5, self.Rebuild, self)
end

function GuildCalendarEvent.UI._EventGroup:RefreshMetaTable()
	-- Attach the meta table to each member
	
	GuildCalendarEvent._GroupPlayerMethods.EventGroup = self
	
	local vAttendance = self.Event:GetAttendance()
	
	if vAttendance then
		for _, vInfo in pairs(vAttendance) do
			setmetatable(vInfo, GuildCalendarEvent.GroupPlayerMetaTable)
		end
	end
	
	if self.Event.Group then
		for _, vInfo in pairs(self.Event.Group) do
			setmetatable(vInfo, GuildCalendarEvent.GroupPlayerMetaTable)
		end
	end
end

function GuildCalendarEvent.UI._EventGroup:Rebuild()
	GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.Rebuild, self)
	
	if not self.Event then
		error("No event")
	end
	
	self:RefreshMetaTable()
	
	-- Rebuild the groups
	
	self:BeginRebuildGroups()
	
	local vAttendance = self.Event:GetAttendance()
	
	if vAttendance then
		for _, vInfo in pairs(vAttendance) do
			self:AddGroupPlayer(vInfo)
		end
	end
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		for vName, vPlayerInfo in pairs(self.Event.Group) do
			if not vAttendance or not vAttendance[vName] then
				self:AddGroupPlayer(vPlayerInfo)
			end
		end
	end

	self:EndRebuildGroups()
end

function GuildCalendarEvent.UI._EventGroup:BeginRebuildGroups()
	for _, vGroup in ipairs(self.Groups) do
		vGroup:BeginRebuild()
	end
end

function GuildCalendarEvent.UI._EventGroup:AddGroupPlayer(pPlayerInfo)
	-- Figure out which group to put it in
	
	local vInviteStatus = pPlayerInfo:GetInviteStatus()
	local vGroup
	
	-- Players who left the group always go into LeftGroup
	
	if vInviteStatus == "LEFT" then
		vGroup = self.LeftGroup
	elseif vInviteStatus == "STANDBY" then
		vGroup = self.StandbyGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_INVITED then
		vGroup = self.InvitedGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
	or vInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP then
		vGroup = self.AcceptedGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE then
		vGroup = self.TentativeGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_STANDBY then
		vGroup = self.StandbyGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_DECLINED then
		vGroup = self.DeclinedGroup
	elseif vInviteStatus == CALENDAR_INVITESTATUS_OUT then
		vGroup = self.OutGroup
	elseif self.ClassGroups then
		vGroup = self.ClassGroups[pPlayerInfo.ClassID] or self.UnknownGroup
	elseif self.RoleGroups then
		local vRoleCode = (pPlayerInfo and pPlayerInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(pPlayerInfo.Name, pPlayerInfo.ClassID)

		vGroup = self.RoleGroups[vRoleCode] or self.UnknownGroup
	else
		vGroup = self.ConfirmedGroup
	end
	
	vGroup:AddPlayerInfo(pPlayerInfo)
end

function GuildCalendarEvent.UI._EventGroup:EndRebuildGroups()
	for _, vGroup in ipairs(self.Groups) do
		vGroup:EndRebuild()
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._EventGroup:Refresh()
	self:RefreshMetaTable()
	
	local vNumItems = 0
	local vAllExpanded = true
	
	for vIndex, vGroup in ipairs(self.Groups) do
		if vGroup:GetNumMembers() > 0 then
			vNumItems = vNumItems + self:GetGroupVisibleItems(vGroup)
			
			if not vGroup.Expanded then
				vAllExpanded = false
			end
		end
	end
	
	self.ScrollingList:SetNumItems(vNumItems)
	
	self.ExpandAll:SetChecked(vAllExpanded)
	
	--
	
	local vNumVisibleItems = self.ScrollingList:GetNumVisibleItems()
	local vItemIndex = 1 - self.ScrollingList:GetOffset()
	
	for vIndex, vGroup in ipairs(self.Groups) do
		if vGroup:GetNumMembers() > 0 then
			vItemIndex = self:AddGroupItem(vGroup, vItemIndex, vNumVisibleItems, 0)
			
			if vItemIndex > vNumVisibleItems then
				break
			end
		end
	end
	
	self.ViewMenu:SetCurrentValueText(string.format(GuildCalendarEvent.cViewByFormat, self.GroupByTitle[self.GroupBy], self.SortByTitle[self.SortBy]))
	
	--
	
	
	local vEvent = self.Event.OriginalEvent or self.Event
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		self.StartEventButton:Hide()
		self.StopEventButton:Show()
		self.StartEventHelp:Hide()
		
		self.AutoSelectButton:Show()
		self.AutoSelectHelp:Show()
		self.InviteSelectedButton:Show()
		self.InviteSelectedHelp:Show()
		
		self.SelectAllButton:Show()
	else
		self.StartEventButton:Show()
		self.StopEventButton:Hide()
		self.StartEventHelp:Show()
		
		self.AutoSelectButton:Hide()
		self.AutoSelectHelp:Hide()
		self.InviteSelectedButton:Hide()
		self.InviteSelectedHelp:Hide()
		
		self.SelectAllButton:Hide()
		
		if vEvent.StartDate or vEvent.ElapsedSeconds then
			self.StartEventHelp:SetText(GuildCalendarEvent.cResumeEventHelp)
		else
			self.StartEventHelp:SetText(GuildCalendarEvent.cStartEventHelp)
		end

	end
	
	-- Total up the selected players
	
	local vTotals =
	{
		H = {Confirmed = 0, Standby = 0},
		T = {Confirmed = 0, Standby = 0},
		R = {Confirmed = 0, Standby = 0},
		M = {Confirmed = 0, Standby = 0},
		["?"] = {Confirmed = 0, Standby = 0},
	}
	
	local vNumSelected = 0
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		local vAttendance = self.Event:GetAttendance()
		
		-- When the event is running the confirmed count is players
		-- who are in the group or invited to the group or selected
		-- and the standby count is all other players who are eligible
		-- to be invited
		
		if vAttendance then
			for vName, vPlayerInfo in pairs(vAttendance) do
				local vInviteStatus = vPlayerInfo:GetInviteStatus()
				local vRoleCode = (vPlayerInfo and vPlayerInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(vName, vPlayerInfo.ClassID)
				
				if self.SelectedPlayers[vName]
				or vInviteStatus == "INVITED"
				or vInviteStatus == "JOINED" then
					if self.SelectedPlayers[vName] then
						vNumSelected = vNumSelected + 1
					end
					
					if vRoleCode then
						vTotals[vRoleCode].Confirmed = vTotals[vRoleCode].Confirmed + 1
					end
				elseif vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
				or vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
				or vInviteStatus == CALENDAR_INVITESTATUS_STANDBY
				or vInviteStatus == "OFFLINE" then
					if vRoleCode then
						vTotals[vRoleCode].Standby = vTotals[vRoleCode].Standby + 1
					end
				end
			end
		end
		
		for vName, vPlayerInfo in pairs(self.Event.Group) do
			if not vAttendance or not vAttendance[vName] then -- If they're in the main attendance list they've already been processed
				local vInviteStatus = vPlayerInfo:GetInviteStatus()
				local vRoleCode = (vPlayerInfo and vPlayerInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(vName, vPlayerInfo.ClassID)
				
				if self.SelectedPlayers[vName]
				or vInviteStatus == "INVITED"
				or vInviteStatus == "JOINED" then
					if self.SelectedPlayers[vName] then
						vNumSelected = vNumSelected + 1
					end
					
					if vRoleCode then
						vTotals[vRoleCode].Confirmed = vTotals[vRoleCode].Confirmed + 1
					end
				elseif vInviteStatus == "OFFLINE" then
					if vRoleCode then
						vTotals[vRoleCode].Standby = vTotals[vRoleCode].Standby + 1
					end
				end
			end
		end
	else
		-- When the event is not running the confirmed count is players who are
		-- confirmed for the event and the standby count is only players are are
		-- on standby for the event
		
		local vAttendance = self.Event:GetAttendance()
		
		if vAttendance then
			for vName, vPlayerInfo in pairs(vAttendance) do
				local vRoleCode = (vPlayerInfo and vPlayerInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(vName, vPlayerInfo.ClassID)
				
				if vRoleCode then
					local vInviteStatus = vPlayerInfo:GetInviteStatus()
					
					if vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED then
						vTotals[vRoleCode].Confirmed = vTotals[vRoleCode].Confirmed + 1
					elseif vInviteStatus == CALENDAR_INVITESTATUS_STANDBY
					or vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE then
						vTotals[vRoleCode].Standby = vTotals[vRoleCode].Standby + 1
					end
				end
			end
		end
	end
	
	local vTotalConfirmed, vTotalStandby = 0, 0
	
	for vRoleCode, vRoleTotals in pairs(vTotals) do
		if self.TotalValues[vRoleCode] then
			if vRoleTotals.Standby > 0 then
				self.TotalValues[vRoleCode]:SetText(string.format("%d (+%d)", vRoleTotals.Confirmed, vRoleTotals.Standby))
			else
				self.TotalValues[vRoleCode]:SetText(vRoleTotals.Confirmed)
			end
		end
		
		vTotalConfirmed = vTotalConfirmed + vRoleTotals.Confirmed
		vTotalStandby = vTotalStandby + vRoleTotals.Standby
	end
	
	if vTotalStandby > 0 then
		self.GrandTotalValue:SetText(string.format("%d (+%d)", vTotalConfirmed, vTotalStandby))
	else
		self.GrandTotalValue:SetText(vTotalConfirmed)
	end
	
	-- Update the selection status text
	
	if vNumSelected == 0 then
		self.AutoSelectHelp:SetText(GuildCalendarEvent.cNoSelection)
	elseif vNumSelected == 1 then
		self.AutoSelectHelp:SetText(GuildCalendarEvent.cSingleSelection)
	else
		self.AutoSelectHelp:SetText(string.format(GuildCalendarEvent.cMultiSelection, vNumSelected))
	end
	
	self.SelectAllButton:SetChecked(self:AllSelected())
	
	-- Update the invite status text
	
	local vRaidInviteStatus = self.RaidInviteStatus or "READY"
	
	if vRaidInviteStatus == "READY"
	and vNumSelected == 0 then
		vRaidInviteStatus = "SELECT"
	end
	
	self.InviteSelectedHelp:SetText(GuildCalendarEvent.cInviteStatusMessages[vRaidInviteStatus] or tostring(vRaidInviteStatus))
end

function GuildCalendarEvent.UI._EventGroup:GetGroupVisibleItems(pGroup)
	local vNumItems = 1
	
	if pGroup.Expanded then
		local vNumMembers = pGroup:GetNumMembers()
		
		for vIndex = 1, vNumMembers do
			local vMemberGroup, vMemberInfo = pGroup:GetIndexedMember(vIndex)
			
			if vMemberGroup then
				vNumItems = vNumItems + self:GetGroupVisibleItems(vMemberGroup)
			else
				vNumItems = vNumItems + 1
			end
		end
	end
	
	return vNumItems
end

function GuildCalendarEvent.UI._EventGroup:PlayerMenuFunc(pItem, pMenu, pMenuID)
	local vMemberGroup, vMemberInfo = pItem.Group:GetIndexedMember(pItem.MemberIndex)
	
	if not pMenuID then
		local vAttendance = self.Event:GetAttendance()
		local vAttendanceInfo = vAttendance and vAttendance[vMemberInfo.Name]
		local vPlayerInfo = GuildCalendarEvent.RaidLib.PlayersByName[vMemberInfo.Name]
		local vSelfPlayerInfo = GuildCalendarEvent.RaidLib.PlayersByName[GuildCalendarEvent.PlayerName]
		local vCanSendInvite = self.Event:CanEdit()
		local vIsGuildEvent = self.Event:IsGuildWide()
		local vIsCreator = vMemberInfo.Name == self.Event.Creator
		
		pMenu:AddCategoryItem(vMemberInfo.Name)
		pMenu:AddNormalItem(REMOVE, "PLAYER_REMOVE", nil, nil, not vCanSendInvite)
		
		if vAttendanceInfo then
			pMenu:AddCategoryItem(STATUS)
			
			-- Invited status can't be set, so only display it if that's their current status
			
			if vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_INVITED then
				pMenu:AddNormalItem(CALENDAR_STATUS_INVITED, "STATUS_INVITED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_INVITED, not vCanSendInvite)
			end
			
			if vIsGuildEvent then
				-- Accepted status can't be set, so only display it if that's their current status
				
				if vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED then
					pMenu:AddNormalItem(CALENDAR_STATUS_ACCEPTED, "STATUS_ACCEPTED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED, not vCanSendInvite)
				end
				
				-- Signed up status can't be set, so only display it if that's their current status
				
				if vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP then
					pMenu:AddNormalItem(CALENDAR_STATUS_SIGNEDUP, "STATUS_SIGNEDUP", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP, not vCanSendInvite)
				end
				
				pMenu:AddNormalItem(CALENDAR_STATUS_TENTATIVE, "STATUS_TENTATIVE", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE, not vCanSendInvite)
				
				-- Declined status can't be set, so only display it if that's their current status
				
				if vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_DECLINED then
					pMenu:AddNormalItem(CALENDAR_STATUS_DECLINED, "STATUS_DECLINED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_DECLINED, not vCanSendInvite)
				end
			else
				pMenu:AddNormalItem(CALENDAR_STATUS_ACCEPTED, "STATUS_ACCEPTED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED, not vCanSendInvite)
				pMenu:AddNormalItem(CALENDAR_STATUS_TENTATIVE, "STATUS_TENTATIVE", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE, not vCanSendInvite)
				pMenu:AddNormalItem(CALENDAR_STATUS_DECLINED, "STATUS_DECLINED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_DECLINED, not vCanSendInvite)
			end
			
			pMenu:AddNormalItem(CALENDAR_STATUS_CONFIRMED, "STATUS_CONFIRMED", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED, not vCanSendInvite)
			pMenu:AddNormalItem(CALENDAR_STATUS_STANDBY, "STATUS_STANDBY", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_STANDBY, not vCanSendInvite)
			pMenu:AddNormalItem(CALENDAR_STATUS_OUT, "STATUS_OUT", nil, vAttendanceInfo.InviteStatus == CALENDAR_INVITESTATUS_OUT, not vCanSendInvite)
		end
		
		pMenu:AddDivider()
		pMenu:AddNormalItem(CALENDAR_INVITELIST_SETMODERATOR, "MODERATOR", nil, vAttendanceInfo and (vAttendanceInfo.ModStatus == "MODERATOR" or vAttendanceInfo.ModStatus == "CREATOR"), (vAttendanceInfo and vAttendanceInfo.ModStatus == "CREATOR") or not vCanSendInvite)
		
		local vInRaid = vPlayerInfo ~= nil
		
		pMenu:AddCategoryItem(VOICE_CHAT_PARTY_RAID)
		pMenu:AddNormalItem(CALENDAR_INVITELIST_INVITETORAID, "GROUP_INVITE", nil, nil, vInRaid or vSelfPlayerInfo.Rank == 0)
		pMenu:AddNormalItem(REMOVE, "GROUP_REMOVE", nil, nil, not vInRaid or vSelfPlayerInfo.Rank <= vPlayerInfo.Rank)
		pMenu:AddNormalItem(PARTY_PROMOTE, "GROUP_LEADER", nil, nil, not vInRaid or vPlayerInfo.Rank == 2 or vSelfPlayerInfo.Rank ~= 2)
		pMenu:AddNormalItem(SET_RAID_ASSISTANT, "GROUP_PROMOTE", nil, nil, not vInRaid or vPlayerInfo.Rank > 0 or vSelfPlayerInfo.Rank ~= 2)
		pMenu:AddNormalItem(DEMOTE, "GROUP_DEMOTE", nil, nil, not vInRaid or vSelfPlayerInfo.Rank <= vPlayerInfo.Rank or vPlayerInfo.Rank == 0)
		
		local vClassID = (vAttendanceInfo and vAttendanceInfo.ClassID) or vPlayerInfo.ClassID
		local vRoleCode = (vAttendanceInfo and vAttendanceInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(vMemberInfo.Name, vClassID)
		
		pMenu:AddCategoryItem("Role")
		pMenu:AddNormalItem(GuildCalendarEvent.cHRole, "ROLE_H", nil, vRoleCode == "H")
		pMenu:AddNormalItem(GuildCalendarEvent.cTRole, "ROLE_T", nil, vRoleCode == "T")
		pMenu:AddNormalItem(GuildCalendarEvent.cRRole, "ROLE_R", nil, vRoleCode == "R")
		pMenu:AddNormalItem(GuildCalendarEvent.cMRole, "ROLE_M", nil, vRoleCode == "M")
	end
end

function GuildCalendarEvent.UI._EventGroup:AddGroupItem(pGroup, pFirstItemIndex, pNumVisibleItems, pIndent)
	local vNumMembers = pGroup:GetNumMembers()
	local vItemIndex = pFirstItemIndex
	
	if vItemIndex > 0 then
		local vItemFrame = self.ScrollingList.ItemFrames[vItemIndex]
		
		vItemFrame:SetCategory(
				pGroup:GetColorCode(), pGroup.Title, nil, pGroup:GetInfoText(),
				pGroup.Expanded,
				pIndent,
				function (...) self:ListItemFunc(...) end)
		
		vItemFrame.Group = pGroup
		vItemFrame.MemberIndex = nil
	end
	
	vItemIndex = vItemIndex + 1
	
	if vItemIndex > pNumVisibleItems then
		return vItemIndex
	end
	
	--
	
	if not pGroup.Expanded then
		return vItemIndex
	end
	
	local vMemberIndent = pIndent + 10
	
	for vIndex = 1, vNumMembers do
		local vMemberGroup, vMemberInfo = pGroup:GetIndexedMember(vIndex)
		
		if vItemIndex > 0 then
			local vItemFrame = self.ScrollingList.ItemFrames[vItemIndex]
			local vInfoText
			
			if vMemberInfo.ResponseDate then
				local vDate, vTime = vMemberInfo.ResponseDate, vMemberInfo.ResponseTime
				
				if GuildCalendarEvent.Clock.Data.ShowLocalTime then
					vDate, vTime = GuildCalendarEvent.DateLib:GetLocalDateTimeFromServerDateTime(vDate, vTime)
				end
				
				vInfoText = GuildCalendarEvent.DateLib:GetShortDateString(vDate).." "..GuildCalendarEvent.DateLib:GetShortTimeString(vTime)
			end
			
			vItemFrame:SetPlayer(
					self.Event,
					vMemberInfo, vInfoText,
					self.SelectedPlayers[vMemberInfo.Name] ~= nil,
					vMemberIndent,
					function (...) self:ListItemFunc(...) end,
					function (...) self:PlayerMenuFunc(...) end)
			
			vItemFrame.Group = pGroup
			vItemFrame.MemberIndex = vIndex
		end
		
		vItemIndex = vItemIndex + 1
		
		if vItemIndex > pNumVisibleItems then
			return vItemIndex
		end
	end
	
	return vItemIndex
end

function GuildCalendarEvent.UI._EventGroup:ViewMenuFunc(pMenu, pMenuID)
	pMenu:AddCategoryItem(GuildCalendarEvent.cViewGroupBy)
	pMenu:AddNormalItem(self.GroupByTitle.ROLE, "GROUP_ROLE", nil, self.GroupBy == "ROLE")
	pMenu:AddNormalItem(self.GroupByTitle.CLASS, "GROUP_CLASS", nil, self.GroupBy == "CLASS")
	pMenu:AddNormalItem(self.GroupByTitle.STATUS, "GROUP_STATUS", nil, self.GroupBy == "STATUS")
	pMenu:AddCategoryItem(GuildCalendarEvent.cViewSortBy)
	pMenu:AddNormalItem(self.SortByTitle.DATE, "SORT_DATE", nil, self.SortBy == "DATE")
	pMenu:AddNormalItem(self.SortByTitle.RANK, "SORT_RANK", nil, self.SortBy == "RANK")
	pMenu:AddNormalItem(self.SortByTitle.NAME, "SORT_NAME", nil, self.SortBy == "NAME")
end

function GuildCalendarEvent.UI._EventGroup:ListItemFunc(pItem, pButton, pPartID)
	local vMemberGroup, vMemberInfo
	
	if pItem.MemberIndex then
		vMemberGroup, vMemberInfo = pItem.Group:GetIndexedMember(pItem.MemberIndex)
	end
	
	if pButton == "LeftButton" then
		if pPartID == "EXPAND" then
			pItem.Group.Expanded = not pItem.Group.Expanded
			self:Refresh()
		elseif pPartID == "CHECKBOX" then
			if vMemberInfo.Name then
				if self.SelectedPlayers[vMemberInfo.Name] then
					self.SelectedPlayers[vMemberInfo.Name] = nil
				else
					self.SelectedPlayers[vMemberInfo.Name] = true
				end
				
				self:Refresh()
			end
		elseif pPartID == "ASSIST" then
			local vAttendanceInfo = self.Event:GetAttendance()[vMemberInfo.Name]
			
			if not vAttendanceInfo then
				return
			end
			
			self.Event:SetModerator(vMemberInfo.Name, vAttendanceInfo.ModStatus ~= "MODERATOR")
			self:Refresh()
		elseif pPartID == "LEADER" then
			self:Refresh()
		elseif pPartID == "CONFIRM" then
			self.Event:SetInviteStatus(vMemberInfo.Name, CALENDAR_INVITESTATUS_CONFIRMED)
		elseif pPartID == "STANDBY" then
			self.Event:SetInviteStatus(vMemberInfo.Name, CALENDAR_INVITESTATUS_STANDBY)
		elseif pPartID == "INVITE" then
			GuildCalendarEvent.RaidInvites:InvitePlayer(vMemberInfo.Name)
		end
	elseif pButton == "MENU" then
		if pPartID:sub(1, 7) == "PLAYER_" then
			local vOp = pPartID:sub(8)
			
			if vOp == "EDIT" then
			elseif vOp == "REMOVE" then
				self.Event:UninvitePlayer(vMemberInfo.Name)
			end
			
		elseif pPartID:sub(1, 7) == "STATUS_" then
			local vStatus = pPartID:sub(8)
			
			self.Event:SetInviteStatus(vMemberInfo.Name, _G["CALENDAR_INVITESTATUS_"..vStatus])
		
		elseif pPartID:sub(1, 5) == "ROLE_" then
			local vRoleCode = pPartID:sub(6)
			
			if self.Event:GetAttendance()[vMemberInfo.Name] then
				self.Event:SetInviteRoleCode(vMemberInfo.Name, vRoleCode)
			end
			
			GuildCalendarEvent:SetPlayerDefaultRoleCode(vMemberInfo.Name, vRoleCode)
			
			self:Rebuild()
			
		elseif pPartID:sub(1, 6) == "GROUP_" then
			local vOp = pPartID:sub(8)
			
			if vOp == "INVITE" then
				GuildCalendarEvent.RaidInvites:InvitePlayer(vMemberInfo.Name)
			elseif vOp == "REMOVE" then
				UninviteUnit(vMemberInfo.Name)
			elseif vOp == "LEADER" then
				PromoteToLeader(vMemberInfo.Name)
			elseif vOp == "PROMOTE" then
				PromoteToAssistant(vMemberInfo.Name)
			elseif vOp == "DEMOTE" then
				DemoteAssistant(vMemberInfo.Name)
			end
		elseif pPartID == "MODERATOR" then
			local vAttendanceInfo = self.Event:GetAttendance()[vMemberInfo.Name]
			
			self.Event:SetModerator(vMemberInfo.Name, vAttendanceInfo.ModStatus ~= "MODERATOR")
			self:Refresh()
		end
	end
end

----------------------------------------
GuildCalendarEvent.UI._EventGroup._ListItem = {}
----------------------------------------

GuildCalendarEvent.UI._EventGroup._ListItem.cItemHeight = 16

function GuildCalendarEvent.UI._EventGroup._ListItem:New(pParent)
	return CreateFrame("Button", nil, pParent)
end

function GuildCalendarEvent.UI._EventGroup._ListItem:Construct(pParent)
	self:SetHeight(self.cItemHeight)
	
	if not GuildCalendarEvent_ListFont_Tiny then
		GuildCalendarEvent_ListFont_Tiny = CreateFont("GuildCalendarEvent_ListFont_Tiny")
		GuildCalendarEvent_ListFont_Tiny:SetFontObject(SystemFont_Tiny)
		GuildCalendarEvent_ListFont_Tiny:SetTextColor(1, 1, 1)
	end
	
	self.CheckButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.CheckButton:SetWidth(self.cItemHeight - 2)
	self.CheckButton:SetHeight(self.cItemHeight - 2)
	self.CheckButton:SetPoint("LEFT", self.ExpandButton, "RIGHT")
	self.CheckButton:SetScript("OnClick", function (pCheckButton, pMouseButton)
		self.SelectionFunc(self, pMouseButton, pCheckButton.DisplayMode)
	end)
	
	self.Menu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenuButton, self, function (...) if self.MenuFunc then self:MenuFunc(...) end end, self.cItemHeight + 3)
	self.Menu:SetPoint("RIGHT", self, "RIGHT")
	self.Menu.ItemClicked = function (pMenu, pItemID)
		self.SelectionFunc(self, "MENU", pItemID)
	end
	
	--
	
	self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	self.Title:SetPoint("LEFT", self.CheckButton, "RIGHT", 2, 0)
	self.Title:SetJustifyH("LEFT")
	self.Title:SetWordWrap(false)

	self.InfoText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	self.InfoText:SetPoint("RIGHT", self.Menu, "LEFT")
	self.InfoText:SetPoint("BOTTOM", self.Title, "BOTTOM", 0, 1)
	self.InfoText:SetJustifyH("RIGHT")
	self.InfoText:SetWordWrap(false)
	
	self.TitleNote = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	self.TitleNote:SetPoint("RIGHT", self.InfoText, "LEFT")
	self.TitleNote:SetPoint("LEFT", self.Title, "RIGHT")
	self.TitleNote:SetPoint("BOTTOM", self.InfoText, "BOTTOM")
	self.TitleNote:SetJustifyH("LEFT")
	self.TitleNote:SetWordWrap(false)
	
	--
	
	self.InviteButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, INVITE, 60)
	self.InviteButton:SetHeight(self.cItemHeight)
	self.InviteButton.Text:SetFontObject(GameFontNormalSmall)
	self.InviteButton:SetPoint("RIGHT", self.Menu, "LEFT", -3, 0)
	self.InviteButton:SetScript("OnClick", function (pButtonFrame, pMouseButton)
		self.SelectionFunc(self, pMouseButton, "INVITE")
	end)
	self.InviteButton:SetScript("OnEnter", function () self:OnEnter() end)
	self.InviteButton:SetScript("OnLeave", function () self:OnLeave() end)
	
	--
	
	self.StandbyButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cStandby, 60)
	self.StandbyButton:SetHeight(self.cItemHeight)
	self.StandbyButton.Text:SetFontObject(GameFontNormalSmall)
	self.StandbyButton:SetPoint("RIGHT", self.InviteButton, "RIGHT")
	self.StandbyButton:SetScript("OnClick", function (pButtonFrame, pMouseButton)
		self.SelectionFunc(self, pMouseButton, "STANDBY")
	end)
	self.StandbyButton:SetScript("OnEnter", function () self:OnEnter() end)
	self.StandbyButton:SetScript("OnLeave", function () self:OnLeave() end)
	
	self.ConfirmButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cConfirm, 60)
	self.ConfirmButton:SetHeight(self.cItemHeight)
	self.ConfirmButton.Text:SetFontObject(GameFontNormalSmall)
	self.ConfirmButton:SetPoint("RIGHT", self.StandbyButton, "LEFT", -3, 0)
	self.ConfirmButton:SetScript("OnClick", function (pButtonFrame, pMouseButton)
		self.SelectionFunc(self, pMouseButton, "CONFIRM")
	end)
	self.ConfirmButton:SetScript("OnEnter", function () self:OnEnter() end)
	self.ConfirmButton:SetScript("OnLeave", function () self:OnLeave() end)
	
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
end

function GuildCalendarEvent.UI._EventGroup._ListItem:OnEnter()
	if not self.PlayerInfo then
		return
	end
	
	local vStatus
	
	if GuildCalendarEvent.CALENDAR_INVITESTATUS_NAMES[self.PlayerInfo.InviteStatus] then
		vStatus = GuildCalendarEvent.CALENDAR_INVITESTATUS_COLOR_CODES[self.PlayerInfo.InviteStatus]..GuildCalendarEvent.CALENDAR_INVITESTATUS_NAMES[self.PlayerInfo.InviteStatus]
	else
		vStatus = ""
	end
	
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddDoubleLine(self.ClassColorCode..self.PlayerInfo.Name, vStatus or "nil")
	GameTooltip:AddDoubleLine(string.format(TOOLTIP_UNIT_LEVEL_CLASS,
			self.PlayerInfo.Level and self.PlayerInfo.Level or "?",
			self.PlayerInfo.ClassID and GuildCalendarEvent.cClassName[self.PlayerInfo.ClassID] and GuildCalendarEvent.cClassName[self.PlayerInfo.ClassID].Male or UNKNOWN),
			self.PlayerRoleCode and GuildCalendarEvent.RoleInfoByID[self.PlayerRoleCode].Name or "")
	
	if self.PlayerInfoText then
		GameTooltip:AddLine("")
		GameTooltip:AddLine(string.format(GuildCalendarEvent.cRespondedDateFormat, self.PlayerInfoText))
	end
	
	GameTooltip:Show()
end

function GuildCalendarEvent.UI._EventGroup._ListItem:OnLeave()
	if not self.PlayerInfo then
		return
	end
	
	GameTooltip:Hide()
end

function GuildCalendarEvent.UI._EventGroup._ListItem:FormatTitle(pColorCode, pTitle, pTitleNote)
	return (pColorCode or "")..pTitle..(pTitleNote and string.format(" (%s)", pTitleNote) or "")
end

function GuildCalendarEvent.UI._EventGroup._ListItem:SetCategory(pColorCode, pTitle, pTitleNote, pInfoText, pExpanded, pIndent, pSelectionFunc)
	self.PlayerInfo = nil
	self.PlayerInfoText = nil
	self.Event = nil
	
	self.CheckButton:ClearAllPoints()
	self.CheckButton:SetPoint("LEFT", self, "LEFT", pIndent or 0, 0)
	self.CheckButton:SetDisplayMode("EXPAND")
	self.CheckButton:SetChecked(pExpanded)
	self.CheckButton:SetEnabled(true)
	self.CheckButton:Show()
	
	self.Title:SetFontObject(GameFontNormal)
	self.TitleNote:SetFontObject(GameFontNormalSmal)
	self.InfoText:SetFontObject(GameFontNormal)
	self.InfoText:SetPoint("BOTTOM", self.Title, "BOTTOM")

	self.Title:SetText((pColorCode or "")..pTitle)
	self.TitleNote:SetText(pTitleNote and string.format(" (%s)", pTitleNote) or "")
	
	self.InviteButton:Hide()
	self.ConfirmButton:Hide()
	self.StandbyButton:Hide()
	self.Menu:Hide()
	
	self.InfoText:SetPoint("RIGHT", self, "RIGHT")
	self.InfoText:SetText((pColorCode or "")..(pInfoText or ""))
	
	self.SelectionFunc = pSelectionFunc
end

function GuildCalendarEvent.UI._EventGroup._ListItem:SetPlayer(
			pEvent,
			pPlayerInfo, pInfoText,
			pSelected,
			pIndent,
			pSelectionFunc,
			pMenuFunc)
	
	self.PlayerInfo = pPlayerInfo
	self.PlayerInfoText = pInfoText
	self.Event = pEvent
	
	self.CheckButton:ClearAllPoints()
	self.CheckButton:SetPoint("LEFT", self, "LEFT", pIndent or 0, 0)
	
	self.Title:SetFontObject(GameFontNormal)
	self.TitleNote:SetFontObject(GuildCalendarEvent_ListFont_Tiny)
	self.InfoText:SetFontObject(GuildCalendarEvent_ListFont_Tiny)
	self.InfoText:SetPoint("BOTTOM", self.Title, "BOTTOM", 0, 1)
	
	self.CheckButton:SetChecked(pSelected)
	
	local vEventIsRunning = GuildCalendarEvent.RunningEvent == pEvent
	
	if not vEventIsRunning then
		if pPlayerInfo.ModStatus == "CREATOR" then
			self.CheckButton:SetDisplayMode("LEADER")
			self.CheckButton:SetChecked(true)
			
		elseif pPlayerInfo.ModStatus == "MODERATOR" then
			self.CheckButton:SetDisplayMode("ASSIST")
			self.CheckButton:SetChecked(true)
		
		else
			self.CheckButton:SetDisplayMode("ASSIST")
			self.CheckButton:SetChecked(false)
		end
		
		local vAttendanceInfo = self.Event:GetAttendance()[GuildCalendarEvent.PlayerName] -- Use the current player's name to determine enabling
		
		self.CheckButton:SetEnabled(vAttendanceInfo and (vAttendanceInfo.ModStatus == "CREATOR" or vAttendanceInfo.ModStatus == "MODERATOR"))
		self.CheckButton:Show()
	elseif pEvent.Group
	and pEvent.Group[pPlayerInfo.Name]
	and not pEvent.Group[pPlayerInfo.Name].LeftGroup then
		self.CheckButton:Hide()
	
	else
		self.CheckButton:SetDisplayMode("CHECKBOX")
		self.CheckButton:SetEnabled(true)
		self.CheckButton:Show()
	end
	
	--
	
	local vRosterInfo = GuildCalendarEvent.GuildLib.Roster.Players[pPlayerInfo.Name]
	local vOfflineGuildMember = vEventIsRunning and vRosterInfo and vRosterInfo.Offline
	
	self.ClassColorCode = (not vOfflineGuildMember and pPlayerInfo.ClassID and GuildCalendarEvent.RAID_CLASS_COLOR_CODES[pPlayerInfo.ClassID]) or "|cff888888"
	
	local vAttendance = pEvent:GetAttendance()
	local vAttendanceInfo = vAttendance and vAttendance[pPlayerInfo.Name]
	
	local vClassID = (vAttendanceInfo and vAttendanceInfo.ClassID) or pPlayerInfo.ClassID
	self.PlayerRoleCode = (vAttendanceInfo and vAttendanceInfo.RoleCode) or GuildCalendarEvent:GetPlayerDefaultRoleCode(pPlayerInfo.Name, vClassID)
	local vRoleInfo = GuildCalendarEvent.RoleInfoByID[self.PlayerRoleCode]
	
	local vInviteStatus = pPlayerInfo:GetInviteStatus()
	
	local vTitleNote
	
	if vInviteStatus == CALENDAR_INVITESTATUS_INVITED
	or vInviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
	or vInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
	or vInviteStatus == CALENDAR_INVITESTATUS_DECLINED
	or vInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP
	or vInviteStatus == CALENDAR_INVITESTATUS_OUT then
		vTitleNote = tostring(vRoleInfo and (vRoleInfo.ColorCode..vRoleInfo.Name))
	elseif vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED then
		vTitleNote = GuildCalendarEvent.cInviteStatusText.CONFIRMED
	elseif vInviteStatus == CALENDAR_INVITESTATUS_STANDBY then
		vTitleNote = GuildCalendarEvent.cInviteStatusText.STANDBY
	else
		vTitleNote = GuildCalendarEvent.cInviteStatusText[vInviteStatus]
		
		if not vTitleNote then vTitleNote = tostring(vInviteStatus).."?" end
	end
	
	vTitleNote = string.format("%s%s, %s %s", vTitleNote, self.ClassColorCode, pPlayerInfo.Level or "", GuildCalendarEvent.cClassName[vClassID] and GuildCalendarEvent.cClassName[vClassID].Male or "")
	
	--
	
	self.Title:SetText((self.ClassColorCode or "")..pPlayerInfo.Name)
	self.TitleNote:SetText(vTitleNote and (" "..vTitleNote) or "")
	
	self.MenuFunc = pMenuFunc
	
	if self.MenuFunc then
		self.Menu:Show()
	else
		self.Menu:Hide()
	end
	
	local vActualInviteStatus = pEvent:GetAttendance()[pPlayerInfo.Name] and pEvent:GetAttendance()[pPlayerInfo.Name].InviteStatus
	
	self.NeedsConfirm = pEvent:CanEdit()
	                  and (vActualInviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
	                    or vActualInviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
	                    or vActualInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP)
	
	local vIsConfirmedOrStandby = vActualInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
	                           or vActualInviteStatus == CALENDAR_INVITESTATUS_STANDBY
	
	if self.NeedsConfirm then
		self.InviteButton:Hide()
		self.ConfirmButton:Show()
		self.StandbyButton:Show()
		self.InfoText:SetPoint("RIGHT", self.ConfirmButton, "LEFT")
		self.InfoText:SetText("")
	else
		local vSelfPlayerInfo = GuildCalendarEvent.RaidLib.PlayersByName[GuildCalendarEvent.PlayerName]
		
		if vIsConfirmedOrStandby
		and GuildCalendarEvent.RunningEvent == pEvent
		and not GuildCalendarEvent.RaidLib.PlayersByName[pPlayerInfo.Name]
		and vSelfPlayerInfo.Rank > 0 then
			self.InviteButton:Show()
			self.InfoText:SetPoint("RIGHT", self.InviteButton, "LEFT")
		else
			self.InviteButton:Hide()
			self.InfoText:SetPoint("RIGHT", self.Menu, "LEFT")
		end
		
		self.ConfirmButton:Hide()
		self.StandbyButton:Hide()
		
		self.InfoText:SetText((self.ClassColorCode or "")..(self.PlayerInfoText or ""))
	end
	
	self.SelectionFunc = pSelectionFunc
end

----------------------------------------
GuildCalendarEvent._PlayerGroup = {}
----------------------------------------

function GuildCalendarEvent._PlayerGroup:Construct(pTitle, pEvent, pExpanded)
	self.Title = pTitle
	self.Event = pEvent
	self.Expanded = pExpanded
	
	self.Members = {}
end

function GuildCalendarEvent._PlayerGroup:BeginRebuild()
	for vKey, _ in pairs(self.Members) do
		self.Members[vKey] = nil
	end
end

function GuildCalendarEvent._PlayerGroup:AddPlayerInfo(pPlayerInfo)
	table.insert(self.Members, pPlayerInfo)
end

function GuildCalendarEvent._PlayerGroup:EndRebuild()
	table.sort(self.Members, GuildCalendarEvent._GroupPlayerMethods.LessThanByStatus)
end

function GuildCalendarEvent._PlayerGroup:GetColorCode()
	return nil
end

function GuildCalendarEvent._PlayerGroup:GetInfoText()
	if #self.Members == 0 then
		return GuildCalendarEvent.cNone
	else
		return string.format(GuildCalendarEvent.cPartySizeFormat, #self.Members)
	end
end

function GuildCalendarEvent._PlayerGroup:GetNumMembers()
	return #self.Members
end

function GuildCalendarEvent._PlayerGroup:GetIndexedMember(pIndex)
	return nil, self.Members[pIndex]
end

----------------------------------------
GuildCalendarEvent._StatusGroup = {}
----------------------------------------

function GuildCalendarEvent._StatusGroup:Construct(pTitle, pEvent, pStatus, pExpanded)
	self.Title = pTitle
	self.Event = pEvent
	self.Status = pStatus
	self.Expanded = pExpanded
	
	if self.Status == CALENDAR_INVITESTATUS_ACCEPTED then
		self.Status2 = CALENDAR_INVITESTATUS_SIGNEDUP
	end
	
	self.Members = {}
end

function GuildCalendarEvent._StatusGroup:Rebuild()
	for vKey, _ in pairs(self.Members) do
		self.Members[vKey] = nil
	end
	
	local vAttendance = self.Event:GetAttendance()
	
	if not vAttendance then
		return
	end
	
	for _, vInfo in pairs(vAttendance) do
		local vInviteStatus, vInviteStatus2 = vInfo.InviteStatus, vInfo:GetInviteStatus()
		
		if (vInviteStatus == self.Status
		or vInviteStatus2 == self.Status
		or vInviteStatus == self.Status2
		or vInviteStatus2 == self.Status2)
		and not vInfo:IsGroupMember() then
			table.insert(self.Members, vInfo)
		end
	end
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		for vName, vPlayerInfo in pairs(self.Event.Group) do
			local vInviteStatus, vInviteStatus2 = vPlayerInfo.InviteStatus, vPlayerInfo:GetInviteStatus()
			
			if not vAttendance[vName]
			and (vInviteStatus == self.Status
			or vInviteStatus2 == self.Status
			or vInviteStatus == self.Status2
			or vInviteStatus2 == self.Status2)
			and not vPlayerInfo:IsGroupMember() then
				table.insert(self.Members, vPlayerInfo)
			end
		end
	end
	
	table.sort(self.Members, GuildCalendarEvent._GroupPlayerMethods.LessThanByStatus)
end

function GuildCalendarEvent._StatusGroup:GetColorCode()
	return nil
end

function GuildCalendarEvent._StatusGroup:GetInfoText()
	if #self.Members == 0 then
		return "none"
	else
		return string.format("%s players", #self.Members)
	end
end

function GuildCalendarEvent._StatusGroup:GetNumMembers()
	return #self.Members
end

function GuildCalendarEvent._StatusGroup:GetIndexedMember(pIndex)
	return nil, self.Members[pIndex]
end

----------------------------------------
GuildCalendarEvent._ClassGroup = {}
----------------------------------------

function GuildCalendarEvent._ClassGroup:Construct(pTitle, pEvent, pClassID)
	self.Title = pTitle
	self.Event = pEvent
	self.ClassID = pClassID
	
	self.Members = {}
	
	self.Expanded = true

	self.ClassColor = RAID_CLASS_COLORS[self.ClassID]
	self.ColorCode = GuildCalendarEvent.RAID_CLASS_COLOR_CODES[self.ClassID]
end

function GuildCalendarEvent._ClassGroup:Rebuild()
	for vKey, _ in pairs(self.Members) do
		self.Members[vKey] = nil
	end
	
	self.NumConfirmed = 0
	self.NumStandby = 0
	self.NumJoined = 0
	
	local vAttendance = self.Event:GetAttendance()
	
	if not vAttendance then
		return
	end
	
	for _, vInfo in pairs(vAttendance) do
		local vInviteStatus = vInfo:GetInviteStatus()
		
		if vInfo.ClassID == self.ClassID
		and vInfo:IsGroupMember() then
			if vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
			or vInviteStatus == "INVITED"
			or vInviteStatus == "JOINED" then
				self.NumConfirmed = self.NumConfirmed + 1
			else
				self.NumStandby = self.NumStandby + 1
			end
			
			table.insert(self.Members, vInfo)
		end
	end
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		for vName, vPlayerInfo in pairs(self.Event.Group) do
			if vPlayerInfo.ClassID == self.ClassID then
				if GuildCalendarEvent.RaidLib.PlayersByName[vName] then
					self.NumJoined = self.NumJoined + 1
				end
				
				if not vAttendance[vName] then
					self.NumConfirmed = self.NumConfirmed + 1
					
					table.insert(self.Members, vPlayerInfo)
				end
			end
		end
	end
	
	table.sort(self.Members, GuildCalendarEvent._GroupPlayerMethods.LessThanByStatus)
end

function GuildCalendarEvent._ClassGroup:GetColorCode()
	return self.ColorCode
end

function GuildCalendarEvent._ClassGroup:GetInfoText()
	if self.NumJoined > 0 then
		return string.format("%s joined", self.NumJoined)
	elseif self.NumConfirmed == 0 and self.NumStandby == 0 then
		return "none"
	elseif self.NumStandby == 0 then
		return string.format("%s confirmed", self.NumConfirmed)
	else
		return string.format("%s confirmed, %s standby", self.NumConfirmed, self.NumStandby)
	end
end

function GuildCalendarEvent._ClassGroup:GetNumMembers()
	return #self.Members
end

function GuildCalendarEvent._ClassGroup:GetIndexedMember(pIndex)
	return nil, self.Members[pIndex]
end

----------------------------------------
GuildCalendarEvent._RoleGroup = {}
----------------------------------------

function GuildCalendarEvent._RoleGroup:Construct(pTitle, pEvent, pRoleCode)
	self.Title = pTitle
	self.Event = pEvent
	self.RoleCode = pRoleCode
	
	self.Members = {}

	self.Expanded = true
end

function GuildCalendarEvent._RoleGroup:Rebuild()
	while self.Members[1] do
		table.remove(self.Members)
	end
	
	self.NumConfirmed = 0
	self.NumStandby = 0
	self.NumJoined = 0
	
	local vAttendance = self.Event:GetAttendance()
	
	if not vAttendance then
		return
	end
	
	for _, vInfo in pairs(vAttendance) do
		local vInviteStatus = vInfo:GetInviteStatus()
		
		if vInfo.RoleCode == self.RoleCode
		and vInfo:IsGroupMember() then
			if vInfo:IsConfirmedMember() then
				self.NumConfirmed = self.NumConfirmed + 1
			else
				self.NumStandby = self.NumStandby + 1
			end
			
			table.insert(self.Members, vInfo)
		end
	end
	
	if GuildCalendarEvent.RunningEvent == self.Event then
		for vName, vPlayerInfo in pairs(self.Event.Group) do
			local vRoleCode = GuildCalendarEvent:GetPlayerDefaultRoleCode(vName, vPlayerInfo.ClassID)
			
			if vRoleCode == self.RoleCode then
				if GuildCalendarEvent.RaidLib.PlayersByName[vName] then
					self.NumJoined = self.NumJoined + 1
				end
				
				if not vAttendance[vName]
				and vPlayerInfo:IsGroupMember() then
					self.NumConfirmed = self.NumConfirmed + 1
					
					table.insert(self.Members, vPlayerInfo)
				end
			end
		end
	end
	
	table.sort(self.Members, GuildCalendarEvent._GroupPlayerMethods.LessThanByStatus)
end

function GuildCalendarEvent._RoleGroup:GetColorCode()
	return nil
end

function GuildCalendarEvent._RoleGroup:GetInfoText()
	if self.NumJoined > 0 then
		return string.format("%s joined", self.NumJoined)
	elseif self.NumConfirmed == 0 and self.NumStandby == 0 then
		return "none"
	elseif self.NumStandby == 0 then
		return string.format("%s confirmed", self.NumConfirmed)
	else
		return string.format("%s confirmed, %s standby", self.NumConfirmed, self.NumStandby)
	end
end

function GuildCalendarEvent._RoleGroup:GetNumMembers()
	return #self.Members
end

function GuildCalendarEvent._RoleGroup:GetIndexedMember(pIndex)
	return nil, self.Members[pIndex]
end

----------------------------------------
GuildCalendarEvent._GroupPlayerMethods = {}
----------------------------------------

function GuildCalendarEvent._GroupPlayerMethods:IsGroupMember()
	local vInviteStatus = self:GetInviteStatus()
	
	return self.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
	    or self.InviteStatus == CALENDAR_INVITESTATUS_STANDBY
	    or vInviteStatus == "INVITED"
	    or vInviteStatus == "JOINED"
end

function GuildCalendarEvent._GroupPlayerMethods:IsConfirmedMember()
	local vInviteStatus = self:GetInviteStatus()
	
	return vInviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
	    or vInviteStatus == "INVITED"
	    or vInviteStatus == "JOINED"
	    or vInviteStatus == "OFFLINE"
end

function GuildCalendarEvent._GroupPlayerMethods:GetInviteStatus()
	-- The status is generated based on several items: the invitation (attendance), the raid record,
	-- and the invite engine data.
	
	if GuildCalendarEvent.RunningEvent == self.EventGroup.Event then
		-- If the player is currently in the group then the status is always "JOINED"
		
		local vPlayerGroupInfo = self.EventGroup.Event.Group and self.EventGroup.Event.Group[self.Name]
		
		if vPlayerGroupInfo then
			if vPlayerGroupInfo.LeftGroup then
				return "LEFT"
			else
				return "JOINED"
			end
		end
		
		if self.LeftGroup then
			return "LEFT"
		end
		
		-- If they are invited, then determine the status from the invitation data
		
		local vAttendanceInfo = self.EventGroup.Event:GetAttendance()[self.Name]
		
		if vAttendanceInfo then
			return vAttendanceInfo.RaidInviteStatus or vAttendanceInfo.InviteStatus
		end
		
		-- Otherwise they were never invited but joined and then left the group, so use "LEFT" for their status
		
		return "LEFT"
	else
		-- If they are invited, then determine the status from the invitation data
		
		local vAttendanceInfo = self.EventGroup.Event:GetAttendance()[self.Name]
		
		if vAttendanceInfo then
			return vAttendanceInfo.InviteStatus or vAttendanceInfo.RaidInviteStatus
		end
		
		-- If the player is currently in the group then the status is always "JOINED"
		
		local vPlayerGroupInfo = self.EventGroup.Event.Group and self.EventGroup.Event.Group[self.Name]
		
		if vPlayerGroupInfo then
			if vPlayerGroupInfo.LeftGroup then
				return "LEFT"
			else
				return "JOINED"
			end
		end
		
		-- Otherwise they were never invited but joined and then left the group, so use "LEFT" for their status
		
		return "LEFT"
	end
end

GuildCalendarEvent._GroupPlayerMethods.InviteStatusSortOrder =
{
	[CALENDAR_INVITESTATUS_INVITED] = 1,
	[CALENDAR_INVITESTATUS_ACCEPTED] = 2,
	[CALENDAR_INVITESTATUS_SIGNEDUP] = 3,
	[CALENDAR_INVITESTATUS_TENTATIVE] = 4,
	JOINED = 5,
	INVITED = 6,
	[CALENDAR_INVITESTATUS_CONFIRMED] = 7,
	[CALENDAR_INVITESTATUS_STANDBY] = 8,
	BUSY = 9,
	DECLINED = 10,
	OFFLINE = 11,
	LEFT = 12,
	[CALENDAR_INVITESTATUS_OUT] = 13,
	[CALENDAR_INVITESTATUS_DECLINED] = 14,
}

function GuildCalendarEvent._GroupPlayerMethods:LessThanByStatus(pPlayerInfo)
	local vPriority1 = self.InviteStatusSortOrder[self:GetInviteStatus()]
	local vPriority2 = self.InviteStatusSortOrder[pPlayerInfo:GetInviteStatus()]
	
	if vPriority1 ~= vPriority2 then
		if not vPriority1 then
			return false
		elseif not vPriority2 then
			return true
		elseif vPriority1 < vPriority2 then
			return true
		else
			return false
		end
	end -- if
	
	return self:LessThanByDate(pPlayerInfo)
end

function GuildCalendarEvent._GroupPlayerMethods:LessThanByDate(pPlayerInfo)
	local vResult, vEqual = GuildCalendarEvent.DateLib:CompareDateTime(self.ResponseDate, self.ResponseTime, pPlayerInfo.ResponseDate, pPlayerInfo.ResponseTime)
	
	if not vEqual then
		return vResult
	else
		return self.Name < pPlayerInfo.Name
	end
end

GuildCalendarEvent.GroupPlayerMetaTable = {__index = GuildCalendarEvent._GroupPlayerMethods}
