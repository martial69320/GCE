----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._EventEditor = {}
----------------------------------------

function GuildCalendarEvent.UI._EventEditor:New(pParentFrame)
	return CreateFrame("Frame", nil, pParentFrame)
end

GuildCalendarEvent.UI._EventEditor.ItemSpacing = 5

function GuildCalendarEvent.UI._EventEditor:Construct(pParentFrame)
	self:SetAllPoints()
	
	self.EventTypeNames = {CalendarEventGetTypes()}
	self.EventTextures = {}
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
end

function GuildCalendarEvent.UI._EventEditor:Initialize()
	if self.Initialized then return end
	self.Background = self:CreateTexture(nil, "BACKGROUND")
	self.Background:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -63)
	self.Background:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -9, 32)
	self.Background:SetVertexColor(0.3, 0.3, 0.3, 0.5)
	
	self.EventTypeMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:EventTypeMenuFunc(...) end, 150)
	self.EventTypeMenu:SetPoint("TOPLEFT", self, "TOPLEFT", 100, -78)
	self.EventTypeMenu:SetTitle(GuildCalendarEvent.cEventLabel)
	function self.EventTypeMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		
		local _, _, vEventType, vTextureIndex = pItemID:find("(.*)_(.*)")
		
		vEventType = tonumber(vEventType) or vEventType
		vTextureIndex = tonumber(vTextureIndex)

		self:SetEventType(vEventType, vTextureIndex)
		
		if not self.Event.Index
		and not self.DidLoadDefaultsFromTitle then
			self:LoadEventDefaults(GuildCalendarEvent:FindEventTemplateByEvent(self.Event))
			self.DidLoadDefaultsFromType = true
		end

		CloseDropDownMenus()
	end
	
	self.DifficultyMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:DifficultyMenuFunc(...) end, 65)
	self.DifficultyMenu:SetPoint("TOPLEFT", self.EventTypeMenu, "TOPRIGHT", 5, 0)
	function self.DifficultyMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		
		local vEventType = self.Event.EventType
		local vTextureIndex = tonumber(pItemID)

		self:SetEventType(vEventType, vTextureIndex)
	end
	
	self.EventTitle = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._EditBox, self, GuildCalendarEvent.cTitleLabel, 100, 220)
	self.EventTitle:SetPoint("TOPLEFT", self.EventTypeMenu, "BOTTOMLEFT", 0, -self.ItemSpacing)
	GuildCalendarEvent:HookScript(self.EventTitle, "OnChar", function (pEditBox)
		pEditBox.EventType, pEditBox.TextureIndex, pEditBox.EventTemplate = GuildCalendarEvent:AutoCompleteEventTitle(pEditBox)
		pEditBox.GotChar = true
	end)
	GuildCalendarEvent:HookScript(self.EventTitle, "OnTextChanged", function (pEditBox)
		if not pEditBox.GotChar then
			pEditBox.EventTemplate = nil
		end
		
		pEditBox.GotChar = false
	end)
	GuildCalendarEvent:HookScript(self.EventTitle, "OnEditFocusGained", function (pEditBox)
		pEditBox.GotChar = false
		pEditBox:HighlightText()
	end)
	GuildCalendarEvent:HookScript(self.EventTitle, "OnEditFocusLost", function (pEditBox)
		if not self.Event then
			return
		end
		
		if self.IsNewEvent
		and not self.DidLoadDefaultsFromType
		and pEditBox:GetText() ~= self.Event.Title
		and (pEditBox.EventType or pEditBox.EventTemplate) then
			if pEditBox.EventTemplate then
				self:SetEventType(pEditBox.EventTemplate.EventType, pEditBox.EventTemplate.TextureIndex)
				self:LoadEventDefaults(pEditBox.EventTemplate)
			else
				self:SetEventType(pEditBox.EventType, pEditBox.TextureIndex)
				self:LoadEventDefaults()
			end
			
			self.DidLoadDefaultsFromTitle = true
		end
		
		pEditBox.EventType, pEditBox.TextureIndex, pEditBox.EventTemplate = nil, nil, nil
		pEditBox:HighlightText(0, 0)
		
		self.Event:SetTitle(pEditBox:GetText())
	end)
	
	self.EventModeMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:EventModeMenuFunc(...) end, 220)
	self.EventModeMenu:SetPoint("TOPLEFT", self.EventTitle, "BOTTOMLEFT", 0, -self.ItemSpacing)
	self.EventModeMenu:SetTitle(GuildCalendarEvent.cEventModeLabel)
	function self.EventModeMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		self.Event:SetEventMode(pItemID)
	end

	self.LevelRangePicker = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._LevelRangePicker, self, GuildCalendarEvent.cLevelsLabel)
	self.LevelRangePicker:SetPoint("TOPLEFT", self.EventModeMenu, "BOTTOMLEFT", 0, -self.ItemSpacing)
	GuildCalendarEvent:HookScript(self.LevelRangePicker.MinLevel, "OnEditFocusLost", function (pEditBox)
		if not self.Event then
			return
		end
		
		local vMinLevel, vMaxLevel = self.LevelRangePicker:GetLevelRange()
		
		self.Event:SetLevelRange(vMinLevel, vMaxLevel)
	end)
	GuildCalendarEvent:HookScript(self.LevelRangePicker.MaxLevel, "OnEditFocusLost", function (pEditBox)
		if not self.Event then
			return
		end
		
		local vMinLevel, vMaxLevel = self.LevelRangePicker:GetLevelRange()
		
		self.Event:SetLevelRange(vMinLevel, vMaxLevel)
	end)
	
	--self.Description = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingEditBox, self, GuildCalendarEvent.cDescriptionLabel, 200, 220, 80)
	self.Description = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingEditBox, self, GuildCalendarEvent.cDescriptionLabel, 200, 220, 155)
	self.Description:ShowLimitText()
	self.Description:SetPoint("TOPLEFT", self.LevelRangePicker, "BOTTOMLEFT", 0, -self.ItemSpacing)
	GuildCalendarEvent:HookScript(self.Description.EditBox, "OnEditFocusLost", function (pEditBox)
		if not self.Event then
			return
		end
		
		self.Event:SetDescription(pEditBox:GetText())
	end)
	
	self.DatePicker = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DatePicker, self)
	self.DatePicker:SetPoint("TOP", self, "TOP", 0, -30)
	self.DatePicker.ValueChangedFunc = function ()
		local vHour, vMinute = self.TimePicker:GetTime()
		local vMonth, vDay, vYear = self.DatePicker:GetDate()
		
		if GuildCalendarEvent.Clock.Data.ShowLocalTime then
			local vLocalDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(vMonth, vDay, vYear)
			local vLocalTime = GuildCalendarEvent.DateLib:ConvertHMToTime(vHour, vMinute)
			
			local vServerDate, vServerTime = GuildCalendarEvent.DateLib:GetServerDateTimeFromLocalDateTime(vLocalDate, vLocalTime)
			
			vMonth, vDay, vYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vServerDate)
			vHour, vMinute = GuildCalendarEvent.DateLib:ConvertTimeToHM(vServerTime)
		end
		
		if self.Event.Hour ~= vHour
		or self.Event.Minute ~= vMinute
		or self.Event.Month ~= vMonth
		or self.Event.Day ~= vDay
		or self.Event.Year ~= vYear then
			self.Event:SetDate(vMonth, vDay, vYear)
			self.Event:SetTime(vHour, vMinute)
			
			self:ClearFocus()
		end
	end
	
	self.TimePicker = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._TimePicker, self, GuildCalendarEvent.cTimeLabel)
	self.TimePicker:SetPoint("TOPLEFT", self.Description, "BOTTOMLEFT", 0, -2 * self.ItemSpacing)
	self.TimePicker.ValueChangedFunc = self.DatePicker.ValueChangedFunc
	
	self.DurationMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:DurationMenuFunc(...) end)
	self.DurationMenu:SetPoint("TOPLEFT", self.TimePicker, "BOTTOMLEFT", 0, -self.ItemSpacing)
	self.DurationMenu:SetTitle(GuildCalendarEvent.cDurationLabel)
	function self.DurationMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		self.Event:SetDuration(tonumber(pItemID))
	end
	
	self.RepeatMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:RepeatMenuFunc(...) end)
	self.RepeatMenu:SetPoint("TOPLEFT", self.DurationMenu, "BOTTOMLEFT", 0, -self.ItemSpacing)
	self.RepeatMenu:SetTitle(GuildCalendarEvent.cRepeatLabel)
	function self.RepeatMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		self.Event:SetRepeatOption(pItemID)
	end
	self.RepeatMenu:SetEnabled(false)
	self.RepeatMenu:Hide()
	
	--
	
	self.AutoConfirmButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.AutoConfirmButton:SetTitle(GuildCalendarEvent.cAutoConfirmLabel)
	self.AutoConfirmButton:SetPoint("LEFT", self.RepeatMenu, "LEFT", -5, 0)
	self.AutoConfirmButton:SetPoint("TOP", self.RepeatMenu, "BOTTOM", 0, -2 * self.ItemSpacing)
	self.AutoConfirmButton:SetScript("OnClick", function ()
		self:ClearFocus()
		if self.Event.Limits then
			self.SavedLimits = GuildCalendarEvent:DuplicateTable(self.Event.Limits, true)
			self.Event:SetLimits(nil)
		elseif self.SavedLimits then
			self.Event:SetLimits(self.SavedLimits)
		else
			local vPartySize, vMinLevel = self.Event:GetDefaultPartySize()
			
			if vPartySize then
				self.Event:SetLimits(GuildCalendarEvent.DefaultLimits[vPartySize])
			end
		end
	end)
	self.AutoConfirmButton:Hide()
	
	self.AutoConfirmSettings = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cAutoConfirmLimitsLabel, 80)
	self.AutoConfirmSettings:SetHeight(20)
	self.AutoConfirmSettings.Text:SetFontObject(GameFontNormalSmall)
	self.AutoConfirmSettings:SetPoint("LEFT", self.AutoConfirmButton.Title, "RIGHT", 5, 0)
	self.AutoConfirmSettings:SetScript("OnClick", function (pFrame, pButton)
		self:ClearFocus()
		GuildCalendarEvent.UI.RoleLimitsDialog:SetParent(self)
		GuildCalendarEvent.UI.RoleLimitsDialog:SetFrameLevel(self:GetFrameLevel() + 30)
		GuildCalendarEvent.UI.RoleLimitsDialog:ClearAllPoints()
		GuildCalendarEvent.UI.RoleLimitsDialog:SetPoint("CENTER", self, "CENTER")
		GuildCalendarEvent.UI.RoleLimitsDialog:Open(self.Event.Limits, GuildCalendarEvent.cAutoConfirmRoleLimitsTitle, nil, function (pLimits)
			self.Event:SetLimits(pLimits)
		end)
	end)
	self.AutoConfirmSettings:Hide()
	
	--
	
	self.EventClosedButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.EventClosedButton:SetTitle(GuildCalendarEvent.cEventClosedLabel)
	self.EventClosedButton:SetPoint("LEFT", self.AutoConfirmButton, "LEFT")
	self.EventClosedButton:SetPoint("TOP", self.AutoConfirmSettings, "BOTTOM", 0, -2 * self.ItemSpacing + 50)
	self.EventClosedButton:SetScript("OnClick", function (pFrame, pButton)
		self:ClearFocus()
		self.Event:SetLocked(pFrame:GetChecked())
	end)
	
	self.LockoutMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:LockoutMenuFunc(...) end)
	self.LockoutMenu:SetPoint("TOP", self.EventClosedButton, "BOTTOM", 0, -self.ItemSpacing)
	self.LockoutMenu:SetPoint("LEFT", self.RepeatMenu, "LEFT")
	self.LockoutMenu:SetTitle(GuildCalendarEvent.cLockoutLabel)
	function self.LockoutMenu.ItemClicked(pMenu, pItemID)
		self:ClearFocus()
		if pItemID == "OFF" then
			--self.Event:SetLockoutDate(nil, nil, nil)
			--self.Event:SetLockoutTime(nil, nil)
		else
			local vEventDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Event.Month, self.Event.Day, self.Event.Year)
			local vEventTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour, self.Event.Minute)
			
			local vLockoutDate, vLockoutTime = GuildCalendarEvent.DateLib:AddOffsetToDateTime(vEventDate, vEventTime, -pItemID)
			
			self.Event:SetLockoutDate(GuildCalendarEvent.DateLib:ConvertDateToMDY(vLockoutDate))
			self.Event:SetLockoutTime(GuildCalendarEvent.DateLib:ConvertTimeToHM(vLockoutTime))
		end
	end
	self.LockoutMenu:SetEnabled(false)
	self.LockoutMenu:Hide()
	
	self.Initialized = true
end

function GuildCalendarEvent.UI._EventEditor:HasChangedEditFields()
	if not self:IsVisible() then
		return false
	end
	
	return self.EventTitle.TextHasChanged
	    or self.LevelRangePicker.MinLevel.TextHasChanged
	    or self.LevelRangePicker.MaxLevel.TextHasChanged
	    or self.Description.EditBox.TextHasChanged
end

function GuildCalendarEvent.UI._EventEditor:SetEvent(pEvent, pIsNewEvent)
	self:Initialize()
	GuildCalendarEvent.BroadcastLib:StopListening(nil, self.EventMessage, self)
	
	if pEvent and not pEvent:CanEdit() then
		self.Event = nil
	else
		self.Event = pEvent
	end
	
	if not self.Event then
		return
	end
	
	self.IsNewEvent = pIsNewEvent
	
	self:UpdateControlsFromEvent()
	
	GuildCalendarEvent.BroadcastLib:Listen(self.Event, self.EventMessage, self)
end

function GuildCalendarEvent.UI._EventEditor:EventMessage(pEvent, pMessageID)
	if pMessageID == "CHANGED" then
		self:UpdateControlsFromEvent()
	end
end

function GuildCalendarEvent.UI._EventEditor:OnShow()
	self:Initialize()
	PlaySound("839")

	GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", self.UpdateControlsFromEvent, self)
	
	if not self.Event then
		return
	end
	
	if self.EventTitle.Enabled then
		self.EventTitle:SetFocus()
	end
end

function GuildCalendarEvent.UI._EventEditor:OnHide()
	GuildCalendarEvent.EventLib:UnregisterEvent("GC5_PREFS_CHANGED", self.UpdateControlsFromEvent, self)
	
	if not self.Event then
		return
	end
end

function GuildCalendarEvent.UI._EventEditor:UpdateControlsFromEvent()
	local vCanEdit = not self.Event.Index -- new event
	              or not self.Event:IsExpired() -- not past event
	
	-- Set the mode
	
	if self.Event:IsAnnouncementEvent() then
		self.EventModeMenu:SetSelectedValue("ANNOUNCE")
	elseif self.Event.CalendarType == "GUILD_EVENT" then
		self.EventModeMenu:SetSelectedValue("SIGNUP")
	else
		self.EventModeMenu:SetSelectedValue("NORMAL")
	end
	
	self.EventModeMenu:SetEnabled(self.IsNewEvent and vCanEdit)
	
	-- Set title and description
	
	self.EventTitle:SetText(self.Event.Title or "")
	self.EventTitle:SetEnabled(vCanEdit)
	
	self.Description:SetText(self.Event.Description or "")
	self.Description:SetEnabled(vCanEdit)
	
	self.EventTypeMenu:SetSelectedValue(self:GetEventTypeID())
	self.EventTypeMenu:SetEnabled(vCanEdit)
	
	self.DifficultyMenu:SetSelectedValue(self.Event.TextureIndex)
	self.DifficultyMenu:SetEnabled(vCanEdit)

	if self.Event:IsAllDayEvent() then
		self.TimePicker:Hide()
		self.DurationMenu:Hide()
	else
		self.TimePicker:Show()
		self.TimePicker:SetEnabled(vCanEdit)
		
		self.DurationMenu:Show()
		self.DurationMenu:SetSelectedValue(self.Event.Duration)
		self.DurationMenu:SetEnabled(vCanEdit)
	end
	
	self.RepeatMenu:SetSelectedValue(self.Event.RepeatOption or 1)
	self.RepeatMenu:SetEnabled(vCanEdit)
	
	local vEventDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Event.Month, self.Event.Day, self.Event.Year)
	local vEventTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour, self.Event.Minute)
	
	if GuildCalendarEvent.Clock.Data.ShowLocalTime then
		local vLocalDate, vLocalTime = GuildCalendarEvent.DateLib:GetLocalDateTimeFromServerDateTime(vEventDate, vEventTime)
		local vLocalMonth, vLocalDay, vLocalYear = GuildCalendarEvent.DateLib:ConvertDateToMDY(vLocalDate)
		local vLocalHour, vLocalMinute = GuildCalendarEvent.DateLib:ConvertTimeToHM(vLocalTime)
		
		self.TimePicker:SetTime(vLocalHour, vLocalMinute)
		self.DatePicker:SetDate(vLocalMonth, vLocalDay, vLocalYear)
	else
		self.TimePicker:SetTime(self.Event.Hour, self.Event.Minute)
		self.DatePicker:SetDate(self.Event.Month, self.Event.Day, self.Event.Year)
	end
	
	self.DatePicker:SetEnabled(vCanEdit)
	
	if self.Event:UsesLevelLimits() then
		self.LevelRangePicker:SetLevelRange(self.Event.MinLevel, self.Event.MaxLevel)
		self.LevelRangePicker:SetEnabled(vCanEdit)
		self.LevelRangePicker:Show()
	else
		self.LevelRangePicker:Hide()
	end
	
	if self.Event:UsesAttendance() then
		self.EventClosedButton:SetChecked(self.Event.Locked)
		self.EventClosedButton:SetEnabled(vCanEdit)
		
		if not self.Event:IsAllDayEvent() then
			local vLockoutDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Event.LockoutMonth, self.Event.LockoutDay, self.Event.LockoutYear)
			local vLockoutTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.LockoutHour, self.Event.LockoutMinute)
			
			local vLockoutMinutes
			
			if vLockoutDate then
				vLockoutMinutes = (vEventDate * 1440 + vEventTime) - (vLockoutDate * 1440 + vLockoutTime)
			else
				vLockoutMinutes = "OFF"
			end
			
			self.LockoutMenu:SetSelectedValue(vLockoutMinutes)
			self.LockoutMenu:SetEnabled(vCanEdit)
		end
		
		self.AutoConfirmButton:SetChecked(self.Event.Limits ~= nil)
		self.AutoConfirmButton:SetEnabled(vCanEdit)
		
		--self.AutoConfirmButton:Show()
		--self.AutoConfirmSettings:Show()
		self.EventClosedButton:Show()
		--self.LockoutMenu:Show()
	else
		--self.AutoConfirmButton:Hide()
		--self.AutoConfirmSettings:Hide()
		self.EventClosedButton:Hide()
		--self.LockoutMenu:Hide()
	end
	
	GuildCalendarEvent:SetEventBackground(self.Event, self.Background, self:GetWidth(), self:GetHeight())
end

function GuildCalendarEvent.UI._EventEditor:ClearFocus()
	self.EventTitle:ClearFocus()
	self.LevelRangePicker:ClearFocus()
	self.Description:ClearFocus()
end

function GuildCalendarEvent.UI._EventEditor:LoadEventDefaults(pTemplate)
	-- Start with the defaults
	
	self.Event:LoadDefaults()
	
	-- Overlay any templated values
	
	if pTemplate then
		for vField, _ in pairs(GuildCalendarEvent.EventTemplateFields) do
			if type(pTemplate[vField]) == "table" then
				if vField ~= "Attendance"
				and vField ~= "Limits" then -- Limits should be allowed once they're actually supported, but for now ignore them
					self.Event[vField] = GuildCalendarEvent:DuplicateTable(pTemplate[vField], true)
				end
			else
				if vField ~= "CalendarType"
				and vField ~= "TitleTag" then
					self.Event[vField] = pTemplate[vField]
				end
			end
		end
		
		self.Event:InitializeNewEvent() -- Copy the new values to the APIs
		
		-- Change the event mode
		
		if pTemplate.CalendarType == "GUILD" or pTemplate.CalendarType == "GUILD_ANNOUNCEMENT" then
			self.Event:SetEventMode("ANNOUNCE")
		elseif pTemplate.CalendarType == "GUILD_EVENT" then
			self.Event:SetEventMode("SIGNUP")
		else
			self.Event:SetEventMode("NORMAL")
		end
	end
	
	-- Process invites
	
	if not GuildCalendarEvent.Data.Prefs.DisableInviteMemory then
		self.Event:BeginBatchInvites()
		
		if pTemplate and pTemplate.Attendance then
			for _, vInfo in pairs(pTemplate.Attendance) do
				self.Event:InvitePlayer(vInfo.Name)
			end
		end
		
		for vName, vInfo in pairs(self.Event.Attendance) do
			if (not pTemplate or not pTemplate.Attendance or not pTemplate.Attendance[vName])
			and vName ~= GuildCalendarEvent.PlayerName then
				self.Event:UninvitePlayer(vInfo.Name)
			end
		end
			
		self.Event:EndBatchInvites()
	end
	
	--
	
	GuildCalendarEvent.BroadcastLib:Broadcast(self.Event, "CHANGED")
end

function GuildCalendarEvent.UI._EventEditor:GetDefaultTitle()
	local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(self.Event.EventType)
	
	local vInfo = vEventTypeTextures[self.Event.TextureIndex]
	
	if not vInfo then
		return
	end
	
	if vInfo.DifficultyName == "" then
		return vInfo.Name
	else
		return DUNGEON_NAME_WITH_DIFFICULTY:format(vInfo.Name, vInfo.DifficultyName)
	end
end

function GuildCalendarEvent.UI._EventEditor:GetEventTypeID()
	if self.Event.TitleTag then
		return self.Event.TitleTag.."_"
	else
		local vEventType = self.Event.EventType
		local vTextureIndex = self.Event.TextureIndex

		-- Get the event's base textureIndex
		local vEventTextureInfo, vDifficultyInfo = GuildCalendarEvent:GetEventTexture(vTextureIndex, vEventType)

		-- Replace the textureIndex with the base textureIndex
		if vEventTextureInfo then
			vTextureIndex = vEventTextureInfo.textureIndex
		end

		return vEventType.."_"..(vTextureIndex or "")
	end
end

function GuildCalendarEvent.UI._EventEditor:SetEventType(pEventType, pTextureIndex)
	local vUseDefaultTitle = not self.DidLoadDefaultsFromTitle and (self.Event.Title == "" or self:GetDefaultTitle() == self.Event.Title)
	
	local vEventType, vTextureIndex, vTitleTag
	
	if GuildCalendarEvent.TitleTagInfo[pEventType] then
		vEventType = CALENDAR_EVENTTYPE_OTHER
		vTitleTag = pEventType
	else
		vEventType = pEventType
		vTextureIndex = pTextureIndex
	end
	
	self.Event:SetType(vEventType, vTextureIndex)
	self.Event:SetTitleTag(vTitleTag)
	
	if vUseDefaultTitle then
		self.Event:SetTitle(self:GetDefaultTitle())
	end
	
	-- Update the UI
	self.EventTypeMenu:SetSelectedValue(self:GetEventTypeID())
	self.DifficultyMenu:SetSelectedValue(pTextureIndex)
	
	-- Broadcast the change
	GuildCalendarEvent.BroadcastLib:Broadcast(self.Event, "CHANGED")
end

function GuildCalendarEvent.UI._EventEditor:AddEventGroupSubMenu(pMenu, pEventGroupID)
	pMenu:AddChildMenu(GuildCalendarEvent.EventTypes[pEventGroupID].Title or "nil", pEventGroupID or 0)
end

function GuildCalendarEvent.UI._EventEditor:AddEventGroupItems(pMenu, pEventGroupID)
	local vEventTypes = GuildCalendarEvent.EventTypes[pEventGroupID]
	
	for vIndex, vEventItem in ipairs(vEventTypes.Events) do
		pMenu:AddNormalItem(vEventItem.name or "nil", vEventItem.id or 0)
	end
end


function GuildCalendarEvent.UI._EventEditor:EventModeMenuFunc(pMenu, pMenuID, pLevel)
	pMenu:AddNormalItem(GuildCalendarEvent.cSignupMode, "SIGNUP", nil, nil, not CanEditGuildEvent())
	pMenu:AddNormalItem(GuildCalendarEvent.cAnnounceMode, "ANNOUNCE", nil, nil, not CanEditGuildEvent())
	pMenu:AddNormalItem(GuildCalendarEvent.cNormalMode, "NORMAL")
end
	
function GuildCalendarEvent.UI._EventEditor:EventTypeMenuFunc(pMenu, pMenuID, pLevel)
	if not pMenuID then
		local vOrderedEventTypes = {CalendarEventGetTypesDisplayOrdered()}
		for vIndex = 1, #vOrderedEventTypes, 2 do
			local vEventType = vOrderedEventTypes[vIndex + 1]
			local vEventTypeName = vOrderedEventTypes[vIndex]
			
			if vEventType == 1 or vEventType == 2 or vEventType == 6 then
				local vMaxExpansion = 6
				local vMinExpansion = vEventType == 6 and 1 or 0 -- Classic didn't have heroics
				for vExpLevel = vMaxExpansion, vMinExpansion, -1 do
					pMenu:AddChildMenu(
							vEventTypeName.." (".._G["EXPANSION_NAME"..vExpLevel]..")",
							{Type = vEventType, ExpLevel = vExpLevel})
				end
			else
				if vEventType == 3 then
					pMenu:AddDivider()
				end
				
				pMenu:AddNormalItem(
						vEventTypeName,
						""..vEventType.."_",
						GuildCalendarEvent:GetTextureFile(nil, "PLAYER", nil, vEventType),
						self.Event and self.Event.EventType == vEventType)
			end
		end
		
		pMenu:AddNormalItem(GuildCalendarEvent.cRoleplayEventName, "RP_", GuildCalendarEvent.TitleTagInfo.RP.Texture, self.Event and self.Event.TitleTag == "RP")
		pMenu:AddNormalItem(GuildCalendarEvent.cBirthdayEventName, "BRTH_", GuildCalendarEvent.TitleTagInfo.BRTH.Texture, self.Event and self.Event.TitleTag == "BRTH")
		pMenu:AddNormalItem(GuildCalendarEvent.cVacationEventName, "VAC_", GuildCalendarEvent.TitleTagInfo.VAC.Texture, self.Event and self.Event.TitleTag == "VAC")
		pMenu:AddNormalItem(GuildCalendarEvent.cDoctorEventName, "MD_", GuildCalendarEvent.TitleTagInfo.MD.Texture, self.Event and self.Event.TitleTag == "MD")
		pMenu:AddNormalItem(GuildCalendarEvent.cDentistEventName, "DDS_", GuildCalendarEvent.TitleTagInfo.DDS.Texture, self.Event and self.Event.TitleTag == "DDS")
	else
		local vTextureCache = GuildCalendarEvent:GetTextureCache()
		local vTextureCacheForType = vTextureCache[pMenuID.Type]

		local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(pMenuID.Type)
		
		for vCacheIndex, vTextureInfo in ipairs(vTextureCacheForType) do
			if vTextureInfo.expansionLevel == pMenuID.ExpLevel then
				pMenu:AddNormalItem(
						vTextureInfo.title,
						""..pMenuID.Type.."_"..vTextureInfo.textureIndex,
						GuildCalendarEvent:GetTextureFile(vTextureInfo.texture, "PLAYER", nil, pMenuID.Type),
						self.Event and self.Event.EventType == pMenuID.Type and self.Event.TextureIndex == vTextureInfo.textureIndex)
			end
		end
	end
end

function GuildCalendarEvent.UI._EventEditor:DifficultyMenuFunc(pMenu, pMenuID, pLevel)
	-- Return an empty menu if no event is set
	if not self.Event then
		return
	end

	-- Iterate the difficulties for the current event type
	local eventType = self.Event.EventType;
	local textureIndex = self.Event.TextureIndex;
	local eventTex = GuildCalendarEvent:GetEventTexture(textureIndex, eventType);
	if eventTex then
		local alreadyAddedDifficulties = {};
		for i, difficultyInfo in ipairs(eventTex.difficulties) do
			if not alreadyAddedDifficulties[difficultyInfo.difficultyName] then
				local checked = textureIndex == difficultyInfo.textureIndex or nil
				pMenu:AddNormalItem(difficultyInfo.difficultyName, difficultyInfo.textureIndex, nil, checked);
				alreadyAddedDifficulties[difficultyInfo.difficultyName] = true;
			end
		end
	end
end

function GuildCalendarEvent.UI._EventEditor:DurationMenuFunc(pMenu, pMenuID, pLevel)
	local vDurations = {15, 30, 60, 90, 120, 150, 180, 210, 240, 300, 360}

	for _, vDuration in ipairs(vDurations) do
		local vText

		local vMinutes = math.fmod(vDuration, 60)
		local vHours = (vDuration - vMinutes) / 60

		if vHours == 0 then
			vText = format(GuildCalendarEvent.cPluralMinutesFormat, vMinutes)
		else
			if vMinutes ~= 0 then
				if vHours == 1 then
					vText = format(GuildCalendarEvent.cSingularHourPluralMinutes, vHours, vMinutes)
				else
					vText = format(GuildCalendarEvent.cPluralHourPluralMinutes, vHours, vMinutes)
				end
			else
				if vHours == 1 then
					vText = format(GuildCalendarEvent.cSingularHourFormat, vHours)
				elseif vHours > 0 then
					vText = format(GuildCalendarEvent.cPluralHourFormat, vHours)
				end
			end
		end
		
		pMenu:AddNormalItem(vText, vDuration)
	end
end

function GuildCalendarEvent.UI._EventEditor:RepeatMenuFunc(pMenu, pMenuID, pLevel)
	local vOptions = {CalendarEventGetRepeatOptions()}
	
	for vOptionID, vOptionTitle in ipairs(vOptions) do
		pMenu:AddNormalItem(vOptionTitle, vOptionID)
	end
end

function GuildCalendarEvent.UI._EventEditor:LockoutMenuFunc(pMenu, pMenuID, pLevel)
	pMenu:AddNormalItem(OFF, "OFF")
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout0, 0)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout15, 15)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout30, 30)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout60, 60)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout120, 120)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout180, 180)
	pMenu:AddNormalItem(GuildCalendarEvent.cLockout1440, 1440)
end
