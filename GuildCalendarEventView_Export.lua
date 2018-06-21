----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._ExportView = {}
----------------------------------------

function GuildCalendarEvent.UI._ExportView:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._ExportView:Construct(pParent)
	self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Title:SetPoint("TOP", self, "TOP", 17, -7)
	self.Title:SetText(GuildCalendarEvent.cExportTitle)
	
	self.SummaryText = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.SummaryText:SetPoint("TOP", self, "TOP", 0, -50)
	self.SummaryText:SetWidth(430)
	self.SummaryText:SetJustifyH("CENTER")
	self.SummaryText:SetText(GuildCalendarEvent.cExportSummary)
	
	self.InstructionsText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	self.InstructionsText:SetPoint("TOP", self.SummaryText, "BOTTOM", 0, -15)
	self.InstructionsText:SetWidth(400)
	self.InstructionsText:SetJustifyH("LEFT")
	self.InstructionsText:SetText(table.concat(GuildCalendarEvent.cExportInstructions, FONT_COLOR_CODE_CLOSE.."\r\n\r\n"))
	
	self.IncludeGuildEvents = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cGuildEvents)
	self.IncludeGuildEvents:SetPoint("TOPLEFT", self.InstructionsText, "BOTTOMLEFT", -30, -15)
	self.IncludeGuildEvents:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportGuildEvents = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.IncludeHolidays = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cHolidays)
	self.IncludeHolidays:SetPoint("TOPLEFT", self.IncludeGuildEvents, "TOPLEFT", 0, -30)
	self.IncludeHolidays:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportHolidays = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.IncludePrivateEvents = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cPrivateEvents)
	self.IncludePrivateEvents:SetPoint("TOPLEFT", self.IncludeGuildEvents, "TOPLEFT", 180, 0)
	self.IncludePrivateEvents:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportPrivateEvents = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.IncludeTradeskills = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cTradeskills)
	self.IncludeTradeskills:SetPoint("TOPLEFT", self.IncludePrivateEvents, "TOPLEFT", 0, -30)
	self.IncludeTradeskills:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportTradeskillCooldowns = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.IncludeAltEvents = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cAlts)
	self.IncludeAltEvents:SetPoint("TOPLEFT", self.IncludePrivateEvents, "TOPLEFT", 180, 0)
	self.IncludeAltEvents:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportAltEvents = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.IncludePersonalEvents = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cPersonalEvents)
	self.IncludePersonalEvents:SetPoint("TOPLEFT", self.IncludeAltEvents, "TOPLEFT", 0, -30)
	self.IncludePersonalEvents:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Data.Prefs.ExportPersonalEvents = pCheckButton:GetChecked() ~= nil
		self:Refresh()
	end)

	self.ExportData = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._ScrollingEditBox, self, GuildCalendarEvent.cExportData, 32000, 400, 150)
	self.ExportData:SetPoint("TOPLEFT", self.IncludeHolidays, "TOPLEFT", 50, -50)
	self.ExportData.EditBox:SetFontObject(GameFontHighlightSmall)
	
	self:SetScript("OnShow", self.Refresh)
end

function GuildCalendarEvent.UI._ExportView:Refresh()
	self.IncludePrivateEvents:SetChecked(GuildCalendarEvent.Data.Prefs.ExportPrivateEvents)
	self.IncludeGuildEvents:SetChecked(GuildCalendarEvent.Data.Prefs.ExportGuildEvents)
	self.IncludeHolidays:SetChecked(GuildCalendarEvent.Data.Prefs.ExportHolidays)
	self.IncludeTradeskills:SetChecked(GuildCalendarEvent.Data.Prefs.ExportTradeskillCooldowns)
	self.IncludeAltEvents:SetChecked(GuildCalendarEvent.Data.Prefs.ExportAltEvents)
	self.IncludePersonalEvents:SetChecked(GuildCalendarEvent.Data.Prefs.ExportPersonalEvents)
	
	local vData = GuildCalendarEvent.iCal:GetReport("GETTEXT")
	
	if type(vData) == "table" then
		vData = table.concat(vData, "\r\n")
	end
	
	self.ExportData:SetText(vData)
	self.ExportData.EditBox:SetFocus()
	self.ExportData.EditBox:HighlightText()
end
