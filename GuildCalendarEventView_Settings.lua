----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._SettingsView = {}
----------------------------------------

function GuildCalendarEvent.UI._SettingsView:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._SettingsView:Construct(pParent)
	self:SetScript("OnShow", self.OnShow)
end

function GuildCalendarEvent.UI._SettingsView:OnShow()
	if not self.Initialized then
		self.Initialized = true
		self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		self.Title:SetPoint("TOP", self, "TOP", 17, -7)
		self.Title:SetText(GuildCalendarEvent.cSettingsTitle)
		
		self.ThemeMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:ThemeMenuFunc(...) end, 130)
		self.ThemeMenu:SetPoint("TOPLEFT", self, "TOPLEFT", 200, -90)
		self.ThemeMenu:SetTitle(GuildCalendarEvent.cThemeLabel)
		function self.ThemeMenu.ItemClicked(pMenu, pItemID)
			GuildCalendarEvent.Data.ThemeID = pItemID
			pMenu:SetSelectedValue(GuildCalendarEvent.Data.ThemeID)
			GuildCalendarEvent.UI.Window.MonthView:SetThemeID(GuildCalendarEvent.Data.ThemeID)
		end
		
		self.StartDayMenu = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._DropDownMenu, self, function (...) self:StartDayMenuFunc(...) end, 130)
		self.StartDayMenu:SetPoint("TOPLEFT", self.ThemeMenu, "BOTTOMLEFT", 0, -15)
		self.StartDayMenu:SetTitle(GuildCalendarEvent.cStartDayLabel)
		function self.StartDayMenu.ItemClicked(pMenu, pItemID)
			GuildCalendarEvent.Data.StartDay = pItemID
			pMenu:SetSelectedValue(GuildCalendarEvent.Data.StartDay)
			GuildCalendarEvent.UI.Window.MonthView:SetStartDay(GuildCalendarEvent.Data.StartDay)
		end
		
		self.TwentyFourHourTime = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cTwentyFourHourTime)
		self.TwentyFourHourTime:SetPoint("TOPLEFT", self.StartDayMenu, "BOTTOMLEFT", 0, -15)
		self.TwentyFourHourTime:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.TwentyFourHourTime = pCheckButton:GetChecked() ~= nil
			SetCVar("timeMgrUseMilitaryTime", GuildCalendarEvent.Data.TwentyFourHourTime and 1 or 0)
			self.TwentyFourHourTime:SetChecked(GetCVarBool("timeMgrUseMilitaryTime"))
		end)
		
		self.RecordTradeskills = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cRecordTradeskills)
		self.RecordTradeskills:SetPoint("TOPLEFT", self.TwentyFourHourTime, "BOTTOMLEFT", 0, -30)
		self.RecordTradeskills:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.Prefs.DisableTradeskills = not pCheckButton:GetChecked()
			self.RecordTradeskills:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableTradeskills)
		end)
		
		self.RememberInvites = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cRememberInvites)
		self.RememberInvites:SetPoint("TOPLEFT", self.RecordTradeskills, "BOTTOMLEFT", 0, -15)
		self.RememberInvites:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.Prefs.DisableInviteMemory = not pCheckButton:GetChecked()
			self.RememberInvites:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableInviteMemory)
		end)
		
		self.AnnounceEvents = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cAnnounceEvents)
		self.AnnounceEvents:SetPoint("TOPLEFT", self.RememberInvites, "BOTTOMLEFT", 0, -30)
		self.AnnounceEvents:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.Prefs.DisableEventReminders = not pCheckButton:GetChecked()
			GuildCalendarEvent.Reminders:CalculateReminders()
			self.AnnounceEvents:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableEventReminders)
		end)
		
		self.AnnounceTradeskills = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cAnnounceTradeskills)
		self.AnnounceTradeskills:SetPoint("TOPLEFT", self.AnnounceEvents, "BOTTOMLEFT", 0, -15)
		self.AnnounceTradeskills:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.Prefs.DisableTradeskillReminders = not pCheckButton:GetChecked()
			GuildCalendarEvent.Reminders:CalculateReminders()
			self.AnnounceTradeskills:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableTradeskillReminders)
		end)
		
		self.AnnounceBirthdays = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cAnnounceBirthdays)
		self.AnnounceBirthdays:SetPoint("TOPLEFT", self.AnnounceTradeskills, "BOTTOMLEFT", 0, -15)
		self.AnnounceBirthdays:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders = not pCheckButton:GetChecked()
			GuildCalendarEvent.Reminders:CalculateReminders()
			self.AnnounceBirthdays:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders)
		end)
		
		self.ShowMinimapClock = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cShowMinimapClock)
		self.ShowMinimapClock:SetPoint("TOPLEFT", self.AnnounceBirthdays, "BOTTOMLEFT", 0, -15)
		self.ShowMinimapClock:SetScript("OnClick", function (pCheckButton)
			GuildCalendarEvent.Clock.Data.HideMinimapClock = not pCheckButton:GetChecked()
			self.ShowMinimapClock:SetChecked(not GuildCalendarEvent.Clock.Data.HideMinimapClock)
			GuildCalendarEvent.EventLib:DispatchEvent("GC5_PREFS_CHANGED")
		end)
	end
	self.ThemeMenu:SetSelectedValue(GuildCalendarEvent.Data.ThemeID or "SEASONAL")
	self.StartDayMenu:SetSelectedValue(GuildCalendarEvent.Data.StartDay)
	self.TwentyFourHourTime:SetChecked(GetCVarBool("timeMgrUseMilitaryTime"))
	self.AnnounceBirthdays:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableBirthdayReminders)
	self.AnnounceEvents:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableEventReminders)
	self.AnnounceTradeskills:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableTradeskillReminders)
	self.RecordTradeskills:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableTradeskills)
	self.RememberInvites:SetChecked(not GuildCalendarEvent.Data.Prefs.DisableInviteMemory)
	self.ShowMinimapClock:SetChecked(not GuildCalendarEvent.Clock.Data.HideMinimapClock)
end

function GuildCalendarEvent.UI._SettingsView:ThemeMenuFunc(pMenu, pMenuID)
	local vCurrentThemeID = GuildCalendarEvent.Data.ThemeID or "SEASONAL"
	for vThemeID, vThemeData in pairs(GuildCalendarEvent.Themes) do
		pMenu:AddNormalItem(vThemeData.Name, vThemeID, nil, GuildCalendarEvent.Data.ThemeID == vThemeID)
	end
end

function GuildCalendarEvent.UI._SettingsView:StartDayMenuFunc(pMenu, pMenuID)
	pMenu:AddNormalItem(WEEKDAY_SUNDAY, 1, nil, not GuildCalendarEvent.Data.StartDay or GuildCalendarEvent.Data.StartDay == 1)
	pMenu:AddNormalItem(WEEKDAY_MONDAY, 2, nil, GuildCalendarEvent.Data.StartDay == 2)
	pMenu:AddNormalItem(WEEKDAY_TUESDAY, 3, nil, GuildCalendarEvent.Data.StartDay == 3)
	pMenu:AddNormalItem(WEEKDAY_WEDNESDAY, 4, nil, GuildCalendarEvent.Data.StartDay == 4)
	pMenu:AddNormalItem(WEEKDAY_THURSDAY, 5, nil, GuildCalendarEvent.Data.StartDay == 5)
	pMenu:AddNormalItem(WEEKDAY_FRIDAY, 6, nil, GuildCalendarEvent.Data.StartDay == 6)
	pMenu:AddNormalItem(WEEKDAY_SATURDAY, 7, nil, GuildCalendarEvent.Data.StartDay == 7)
end
