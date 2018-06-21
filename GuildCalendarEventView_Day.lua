----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._DaySidebar = {}
----------------------------------------

function GuildCalendarEvent.UI._DaySidebar:New(pParent)
	return GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._SidebarWindowFrame, pParent)
end

function GuildCalendarEvent.UI._DaySidebar:Construct(pParent)
	self:SetWidth(350)
	self:SetHeight(500)
	self:SetPoint("TOPLEFT", pParent, "TOPRIGHT", -1, -20)
	
	self.DateText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.DateText:SetPoint("TOP", self, "TOP", 0, -33)
	
	self.BottomTrim = self:CreateTexture(nil, "ARTWORK")
	self.BottomTrim:SetHeight(32)
	self.BottomTrim:SetWidth(256)
	self.BottomTrim:SetTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\HorizontalTrim")
	self.BottomTrim:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 4)
	self.BottomTrim:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 4)
	
	self.NewEventButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cNewEvent, 120)
	self.NewEventButton:SetPoint("RIGHT", self.BottomTrim, "RIGHT", 0, -2)
	self.NewEventButton:SetScript("OnClick", function (pButton, pMouseButton)
		GuildCalendarEvent.UI.Window:OpenNewEvent(self.Month, self.Day, self.Year)
	end)
	
	self.PasteEventButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cPasteEvent, 120)
	self.PasteEventButton:SetPoint("RIGHT", self.NewEventButton, "LEFT")
	self.PasteEventButton:SetScript("OnClick", function (pButton, pMouseButton)
		GuildCalendarEvent.WoWCalendar:CalendarContextEventPaste(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day)
	end)
	self.PasteEventButton:SetScript("OnUpdate", function (pButton)
		pButton:SetEnabled(GuildCalendarEvent.WoWCalendar:CalendarContextEventClipboard() and not self.ReadOnly)
	end)
	
	--
	
	self.ItemHeight = 22
	
	self.ScrollingList = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingItemList, self, self._ListItem, self.ItemHeight)
	self.ScrollingList.RedrawFunc = function () self:Refresh() end
	self.ScrollingList:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -62)
	self.ScrollingList:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -9, 32)
	
	self.ItemFrames = {}
	
	self.Events = {}
	
	self:SetScript("OnShow", function (self)
		PlaySound("839")
		self:Refresh()
		GuildCalendarEvent.EventLib:RegisterEvent("GC5_CALENDAR_CHANGED", self.Rebuild, self)
		GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", self.Rebuild, self)
		
		GuildCalendarEvent.UI.Window.MonthView:SelectDate(self.Month, self.Day, self.Year)
	end)

	self:SetScript("OnHide", function (self)
		--
		
		for vEventIndex, vEvent in ipairs(self.Events) do
			vEvent.Unseen = nil
		end
		
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_CALENDAR_CHANGED")
		
		--
		
		PlaySound("840")
		GuildCalendarEvent.EventLib:UnregisterEvent("GC5_CALENDAR_CHANGED", self.Rebuild, self)
		GuildCalendarEvent.EventLib:UnregisterEvent("GC5_PREFS_CHANGED", self.Rebuild, self)
		
		GuildCalendarEvent.UI.Window.MonthView:SelectDate(nil)
	end)
end

function GuildCalendarEvent.UI._DaySidebar:SetDate(pMonth, pDay, pYear)
	if self.Month ~= pMonth
	or self.Day ~= pDay
	or self.Year ~= pYear then
		for vEventIndex, vEvent in ipairs(self.Events) do
			vEvent.Unseen = nil
		end
		
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_CALENDAR_CHANGED")
	end
	
	self.Month = pMonth
	self.Day = pDay
	self.Year = pYear
	
	self.ReadOnly = not GuildCalendarEvent:CanCreateEventOnDate(pMonth, pDay, pYear)
	
	self.NewEventButton:SetEnabled(not self.ReadOnly)
	
	self:Rebuild()
end

function GuildCalendarEvent.UI._DaySidebar:Rebuild()
	if GuildCalendarEvent.Calendars.PLAYER:IsAfterMaxCreateDate(self.Month, self.Day, self.Year) then
		self.NewEventButton:Hide()
	else
		self.NewEventButton:Show()
	end
	
	self:Refresh()
end

function GuildCalendarEvent.CompareEventTimes(pEvent1, pEvent2)
	if pEvent1.Year < pEvent2.Year then
		return true
	elseif pEvent1.Year > pEvent2.Year then
		return false
	end

	if pEvent1.Month < pEvent2.Month then
		return true
	elseif pEvent1.Month > pEvent2.Month then
		return false
	end

	if pEvent1.Day < pEvent2.Day then
		return true
	elseif pEvent1.Day > pEvent2.Day then
		return false
	end

	if (pEvent1.Hour or -1) < (pEvent2.Hour or -1) then
		return true
	elseif (pEvent1.Hour or -1) > (pEvent2.Hour or -1) then
		return false
	end
	
	if (pEvent1.Minute or 0) < (pEvent2.Minute or 0) then
		return true
	elseif (pEvent1.Minute or 0) > (pEvent2.Minute or 0) then
		return false
	end
	
	return (pEvent1.Title or "") < (pEvent2.Title or "")
end
	
function GuildCalendarEvent.UI._DaySidebar:Refresh()
	-- Rebuild the event list
	
	self.Events = GuildCalendarEvent:GetDayEvents(self.Month, self.Day, self.Year, self.Events)
	
	-- Update the date text
	
	self.DateText:SetText(GuildCalendarEvent.DateLib:GetLongDateString(GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Month, self.Day, self.Year), true))
	
	-- Update the list
	
	self.ScrollingList:SetNumItems(#self.Events)
	
	for vEventIndex, vEventData in ipairs(self.Events) do
		local vItemFrame = self.ScrollingList.ItemFrames[vEventIndex]
		if vItemFrame then vItemFrame:SetEvent(vEventData) end
	end
end

----------------------------------------
GuildCalendarEvent.UI._DaySidebar._ListItem = {}
----------------------------------------

function GuildCalendarEvent.UI._DaySidebar._ListItem:New(pParent)
	return CreateFrame("Button", nil, pParent)
end

function GuildCalendarEvent.UI._DaySidebar._ListItem:Construct(pParent)
	local vWidth = 288
	
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	
	self:SetWidth(vWidth)
	self:SetHeight(pParent.ItemHeight)
	
	local vIconWidth = pParent.ItemHeight - 2
	local vTimeTextWidth = 65
	local vOwnerTextWidth = 60
	local vRightMargin = 3
	local vTitleTextWidth = vWidth - vTimeTextWidth - vOwnerTextWidth
	
	self.IconTexture = self:CreateTexture(nil, "BORDER")
	self.IconTexture:SetWidth(vIconWidth)
	self.IconTexture:SetHeight(vIconWidth)
	self.IconTexture:SetTexture(0, 1, 0)
	self.IconTexture:SetPoint("LEFT", self, "LEFT", 0, 0)
	
	self.OwnerText = self:CreateFontString(nil, "BORDER", "SystemFont_Tiny")
	self.OwnerText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	self.OwnerText:SetJustifyH("RIGHT")
	self.OwnerText:SetJustifyV("BOTTOM")
	-- self.OwnerText:SetWidth(vOwnerTextWidth)
	self.OwnerText:SetHeight(pParent.ItemHeight)
	self.OwnerText:SetPoint("RIGHT", self, "RIGHT", -vRightMargin, 6)
	self.OwnerText:SetText("Gizmodo")
	
	self.OwnerIcon = self:CreateTexture(nil, "BORDER")
	self.OwnerIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	self.OwnerIcon:SetWidth(16)
	self.OwnerIcon:SetHeight(16)
	self.OwnerIcon:SetPoint("RIGHT", self.OwnerText, "LEFT", 0, -6)
	
	self.TitleText = self:CreateFontString(nil, "BORDER", "GameFontNormal")
	self.TitleText:SetJustifyH("LEFT")
	self.TitleText:SetJustifyV("BOTTOM")
	self.TitleText:SetHeight(pParent.ItemHeight)
	self.TitleText:SetPoint("LEFT", self.IconTexture, "RIGHT", vTimeTextWidth + 6, 5)
	self.TitleText:SetPoint("RIGHT", self.OwnerIcon, "LEFT")
	self.TitleText:SetText("Uldar")
	
	self.TimeText = self:CreateFontString(nil, "BORDER", "GameFontNormal")
	self.TimeText:SetJustifyH("RIGHT")
	self.TimeText:SetJustifyV("BOTTOM")
	self.TimeText:SetWidth(vTimeTextWidth)
	self.TimeText:SetHeight(pParent.ItemHeight)
	self.TimeText:SetPoint("LEFT", self.IconTexture, "RIGHT", 0, 5)
	self.TimeText:SetText("12:59pm")
	
	self.Circled = self:CreateTexture(nil, "BACKGROUND")
	self.Circled:SetTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\CircledDate")
	self.Circled:SetPoint("TOPLEFT", self.TimeText, "TOPLEFT", 5, -5)
	self.Circled:SetPoint("BOTTOMRIGHT", self.TimeText, "BOTTOMRIGHT", 7, -6)
	
	self:SetHighlightTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	local vHighlightTexture = self:GetHighlightTexture()
	vHighlightTexture:SetTexCoord(0, 1, 0, 0.578125)
	vHighlightTexture:SetBlendMode("ADD")
	
	self:SetScript("OnClick", self.OnClick)
end

function GuildCalendarEvent.UI._DaySidebar._ListItem:SetEvent(pEvent)
	self.Event = pEvent
	
	if not self.Event then
		return
	end
	
	local vColor = self.Event:GetEventColor()
	
	self.TitleText:SetTextColor(vColor.r, vColor.g, vColor.b)
	
	if self.Event:IsAllDayEvent() then
		self.TitleText:SetText(self.Event.Title)
		self.TimeText:SetText(GuildCalendarEvent.cAllDay)
	else
		local vTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour, self.Event.Minute)
		
		if GuildCalendarEvent.Clock.Data.ShowLocalTime then
			vTime = GuildCalendarEvent.DateLib:GetLocalTimeFromServerTime(vTime)
		end
		
		local vTimeString = GuildCalendarEvent.DateLib:GetShortTimeString(vTime)
		
		self.TitleText:SetText(self.Event.Title)
		self.TimeText:SetText(vTimeString)
	end

	self.OwnerText:SetText(self.Event.OwnersName or "")
	
	if self.Event.ModStatus == "CREATOR" then
		self.OwnerIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
		self.OwnerIcon:Show()
	elseif self.Event.ModStatus == "MODERATOR" then
		self.OwnerIcon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
		self.OwnerIcon:Show()
	else
		self.OwnerIcon:Hide()
	end
	
	local vTexturePath, vTexCoords = GuildCalendarEvent:GetTextureFile(pEvent.TextureID, pEvent.CalendarType, pEvent.NumSequenceDays ~= 2 and pEvent.SequenceType or "", pEvent.EventType, pEvent.TitleTag)
	
	if pEvent.SequenceType == "ONGOING" then
		-- start texture is right before ongoing texture. this works, probably not a good idea in the long run though.
		vTexturePath = vTexturePath - 1
	end
	
	self.IconTexture:SetTexture(vTexturePath)
	
	if vTexCoords then
		self.IconTexture:SetTexCoord(vTexCoords.left, vTexCoords.right, vTexCoords.top, vTexCoords.bottom)
	else
		self.IconTexture:SetTexCoord(0, 1, 0, 1)
	end

	-- Circle the date if necessary
	
	if pEvent:IsAttending() then
		self.Circled:SetVertexColor(vColor.r, vColor.g, vColor.b, 0.7)
		self.Circled:Show()
	else
		self.Circled:Hide()
	end
end

function GuildCalendarEvent.UI._DaySidebar._ListItem:OnClick(pButton)
	if pButton == "RightButton" then
		GuildCalendarEvent.UI.Window.MonthView.EventMenu:Toggle(self.Event.Month, self.Event.Day, self.Event.Year, self.Event)
	else
		GuildCalendarEvent.UI.Window:ShowEventSidebar(self.Event)
	end
end