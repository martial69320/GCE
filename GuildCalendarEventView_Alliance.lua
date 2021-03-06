----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._PartnersView = {}
----------------------------------------

function GuildCalendarEvent.UI._PartnersView:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._PartnersView:Construct(pParent)
	self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Title:SetPoint("TOP", self, "TOP", 17, -7)
	self.Title:SetText(GuildCalendarEvent.cPartnersTitle)
	
	self.HelpText = CreateFrame("SimpleHTML", nil, self)
	self.HelpText:SetPoint("TOP", self, "TOP", 0, -50)
	self.HelpText:SetPoint("BOTTOM", self, "BOTTOM", 0, 50)
	self.HelpText:SetWidth(470)
	self.HelpText:SetFontObject(GameFontNormalSmall)
	self.HelpText:SetFontObject("h1", GameFontNormal)
	self.HelpText:SetFontObject("h2", GameFontHighlight)
	self.HelpText:SetFontObject("h3", GameFontNormalSmall)
	self.HelpText:SetFontObject("p", GameFontHighlight)
	self.HelpText:SetSpacing("p", 5)
	self.HelpText:SetText(GuildCalendarEvent.cPartnersHelp)
	
	self.RemovePlayerButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, REMOVE, 100)
	self.RemovePlayerButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -15, 17)
	self.RemovePlayerButton:SetScript("OnClick", function ()
		local vPlayerName = strtrim(self.CharacterName:GetText())
		
		GuildCalendarEvent:ConfirmDelete(GuildCalendarEvent.cConfirmDeletePartner, vPlayerName, function ()
			GuildCalendarEvent.Partnerships:RemovePartnerPlayer(vPlayerName)
		end)
		
		self.CharacterName:HighlightText()
	end)
	
	self.AddPlayerButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, ADD, 100)
	self.AddPlayerButton:SetPoint("RIGHT", self.RemovePlayerButton, "LEFT", -10, 0)
	self.AddPlayerButton:SetScript("OnClick", function ()
		self:AddPartnerPlayer(strtrim(self.CharacterName:GetText()))
		self.CharacterName:HighlightText()
	end)
	
	self.CharacterName = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._EditBox, self, nil, 40, 140)
	self.CharacterName:SetPoint("RIGHT", self.AddPlayerButton, "LEFT", -10, 0)
	self.CharacterName:SetEmptyText(CALENDAR_PLAYER_NAME)
	self.CharacterName:SetAutoCompleteFunc(GuildCalendarEvent.PlayerNameAutocomplete)
	self.CharacterName:SetScript("OnEnterPressed", function ()
		self:AddPartnerPlayer(strtrim(self.CharacterName:GetText()))
		self.CharacterName:HighlightText()
	end)
	
	self.ProgressBar = GuildCalendarEvent:New(GuildCalendarEvent._PartnerProgressBar, self)
	self.ProgressBar:SetPoint("TOP", self.RemovePlayerButton, "TOP")
	self.ProgressBar:SetPoint("BOTTOM", self.RemovePlayerButton, "BOTTOM")
	self.ProgressBar:SetPoint("LEFT", self, "LEFT", 35, 0)
	self.ProgressBar:SetPoint("RIGHT", self.RemovePlayerButton, "RIGHT")
	self.ProgressBar:Hide()
	
	self.PartnerItems = {}
	self.FreePartnerItems = {}
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	
	GuildCalendarEvent.EventLib:RegisterEvent("GC5_PARTNERS_CHANGED", self.Refresh, self)
end

function GuildCalendarEvent.UI._PartnersView:OnShow()
	GuildCalendarEvent.Partnerships.NewPartnershipsEnabled = true
	self:Refresh()
end

function GuildCalendarEvent.UI._PartnersView:OnHide()
	GuildCalendarEvent.Partnerships.NewPartnershipsEnabled = false
end

function GuildCalendarEvent.UI._PartnersView:Refresh()
	-- Move existing items to the free list
	
	for vIndex, vPartnerItem in pairs(self.PartnerItems) do
		vPartnerItem:Hide()
		table.insert(self.FreePartnerItems, vPartnerItem)
		self.PartnerItems[vIndex] = nil
	end
	
	-- Add all the data
	
	for vIndex, vPartnerGuild in ipairs(GuildCalendarEvent.Partnerships.PartnerGuilds) do
		self:AddPartnerGuild(vPartnerGuild)
	end
	
	-- Stack the result
	
	self:StackPartners()
end

function GuildCalendarEvent.UI._PartnersView:SetStatusText(pStatus, pText)
	if not pStatus or pStatus == "PARTNER_SYNC_COMPLETE" then
		self.ProgressBar:Hide()
		self.RemovePlayerButton:Show()
		self.AddPlayerButton:Show()
		self.CharacterName:Show()
		
		return
	end
	
	if pStatus == "GC5_SEND_PROGRESS" then
		self.SendProgress = pText
		self.ProgressBar:SetProgress(self.SendProgress, self.ReceiveProgress)
	elseif pStatus == "GC5_RECEIVE_PROGRESS" then
		self.ReceiveProgress = pText
		self.ProgressBar:SetProgress(self.SendProgress, self.ReceiveProgress)
	else
		local vStatus = GuildCalendarEvent.cPartnerStatus[pStatus]
		
		if not vStatus then
			self.ProgressBar:SetText(pStatus)
		else
			self.ProgressBar:SetText(vStatus:format(pText))
		end
		
		self.ProgressBar:Show()
		
		self.RemovePlayerButton:Hide()
		self.AddPlayerButton:Hide()
		self.CharacterName:Hide()
	end
end

function GuildCalendarEvent.UI._PartnersView:AddPartnerPlayer(pPlayerName)
	self.CreatingGuild = GuildCalendarEvent.Partnerships:AddPartnerPlayer(pPlayerName)
	
	GuildCalendarEvent.BroadcastLib:Listen(self.CreatingGuild, self.CreatingGuildStatus, self)
	
	self:CreatingGuildStatus(self.CreatingGuild, self.CreatingGuild.Status, self.CreatingGuild.StatusMessage)
end

function GuildCalendarEvent.UI._PartnersView:CreatingGuildStatus(pPartnerGuild, pStatus, pMessage, pPlayerName)
	if GuildCalendarEvent.Debug.partners then
		GuildCalendarEvent:DebugMessage("PartnersView:CreatingGuildStatus(%s, %s, %s): GuildName=%s", tostring(pStatus), tostring(pMessage), tostring(pPlayerName), tostring(pPartnerGuild.Config.GuildName))
	end
	
	if pStatus == "GC5_CONNECT_FAILED" and pMessage == "NOT_FOUND" then
		GuildCalendarEvent.UI:CalendarUpdateError(ERR_CHAT_PLAYER_NOT_FOUND_S:format(pPlayerName))
		return
	end
	
	if pStatus == "PARTNER_SYNC_COMPLETE"
	and pPartnerGuild.Config.GuildName then
		-- Save the new info
		
		local vPartnerConfig = GuildCalendarEvent.Partnerships:FindPartnerConfigByGuild(pPartnerGuild.Config.GuildName)
		
		if vPartnerConfig then
			GuildCalendarEvent:DebugTable(vPartnerConfig, "ExistingConfig")
			table.insert(vPartnerConfig.Proxies, pPartnerGuild.Config.Proxies[1])
		else
			GuildCalendarEvent:DebugTable(pPartnerGuild.Config, "NewConfig")
			table.insert(GuildCalendarEvent.PlayerData.PartnerConfigs, pPartnerGuild.Config)
		end
		
		GuildCalendarEvent.Partnerships:PartnerConfigChanged()
	end
	
	self:SetStatusText(pStatus, pMessage)
end

function GuildCalendarEvent.UI._PartnersView:AddPartnerGuild(pPartnerGuild)
	local vPartnerItem = table.remove(self.FreePartnerItems)
	
	if not vPartnerItem then
		vPartnerItem = GuildCalendarEvent:New(GuildCalendarEvent.UI._PartnerItem, self)
	end
		
	table.insert(self.PartnerItems, vPartnerItem)
	
	vPartnerItem:SetPartnerGuild(pPartnerGuild)
	vPartnerItem:Show()
end

function GuildCalendarEvent.UI._PartnersView:StackPartners()
	local vPreviousItem
	
	for vIndex, vPartnerItem in ipairs(self.PartnerItems) do
		vPartnerItem:ClearAllPoints()
		
		if vIndex == 1 then
			vPartnerItem:SetPoint("TOP", self, "TOP", 0, -40)
		else
			vPartnerItem:SetPoint("TOPLEFT", vPreviousItem, "BOTTOMLEFT", 0, -10)
		end
		
		vPreviousItem = vPartnerItem
	end
	
	if not vPreviousItem then
		self.HelpText:Show()
	else
		self.HelpText:Hide()
	end
end

----------------------------------------
GuildCalendarEvent.UI._PartnerItem = {}
----------------------------------------

function GuildCalendarEvent.UI._PartnerItem:New(pParent)
	return GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PlainBorderedFrame, pParent)
end

function GuildCalendarEvent.UI._PartnerItem:Construct(pParent)
	self:SetWidth(490)
	self:SetHeight(75)
	
	self.TabardSize = 60
	self.HalfTabardSize = 0.5 * self.TabardSize
	
	self.EmblemBrightness = 0.7
	
	self.EmblemBgTL = self:CreateTexture(nil, "BORDER")
	self.EmblemBgTL:SetWidth(self.HalfTabardSize)
	self.EmblemBgTL:SetHeight(self.HalfTabardSize)
	self.EmblemBgTL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemBgTL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBgTL:SetPoint("TOPLEFT", self, "TOPLEFT", 15, -7)
	
	self.EmblemBgTR = self:CreateTexture(nil, "BORDER")
	self.EmblemBgTR:SetWidth(self.HalfTabardSize)
	self.EmblemBgTR:SetHeight(self.HalfTabardSize)
	self.EmblemBgTR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemBgTR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBgTR:SetPoint("TOPLEFT", self.EmblemBgTL, "TOPRIGHT")
	
	self.EmblemBgBL = self:CreateTexture(nil, "BORDER")
	self.EmblemBgBL:SetWidth(self.HalfTabardSize)
	self.EmblemBgBL:SetHeight(self.HalfTabardSize)
	self.EmblemBgBL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemBgBL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBgBL:SetPoint("TOP", self.EmblemBgTL, "BOTTOM")
	
	self.EmblemBgBR = self:CreateTexture(nil, "BORDER")
	self.EmblemBgBR:SetWidth(self.HalfTabardSize)
	self.EmblemBgBR:SetHeight(self.HalfTabardSize)
	self.EmblemBgBR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemBgBR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBgBR:SetPoint("TOP", self.EmblemBgTR, "BOTTOM")
	
	self.EmblemBorderTL = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBorderTL:SetWidth(self.HalfTabardSize)
	self.EmblemBorderTL:SetHeight(self.HalfTabardSize)
	self.EmblemBorderTL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemBorderTL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBorderTL:SetPoint("TOP", self.EmblemBgTL, "TOP")
	
	self.EmblemBorderTR = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBorderTR:SetWidth(self.HalfTabardSize)
	self.EmblemBorderTR:SetHeight(self.HalfTabardSize)
	self.EmblemBorderTR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemBorderTR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBorderTR:SetPoint("TOPLEFT", self.EmblemBorderTL, "TOPRIGHT")
	
	self.EmblemBorderBL = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBorderBL:SetWidth(self.HalfTabardSize)
	self.EmblemBorderBL:SetHeight(self.HalfTabardSize)
	self.EmblemBorderBL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemBorderBL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBorderBL:SetPoint("TOP", self.EmblemBorderTL, "BOTTOM")
	
	self.EmblemBorderBR = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBorderBR:SetWidth(self.HalfTabardSize)
	self.EmblemBorderBR:SetHeight(self.HalfTabardSize)
	self.EmblemBorderBR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemBorderBR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBorderBR:SetPoint("TOP", self.EmblemBorderTR, "BOTTOM")

	self.EmblemTL = self:CreateTexture(nil, "ARTWORK")
	self.EmblemTL:SetWidth(self.HalfTabardSize)
	self.EmblemTL:SetHeight(self.HalfTabardSize)
	self.EmblemTL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemTL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemTL:SetPoint("TOP", self.EmblemBgTL, "TOP")
	
	self.EmblemTR = self:CreateTexture(nil, "ARTWORK")
	self.EmblemTR:SetWidth(self.HalfTabardSize)
	self.EmblemTR:SetHeight(self.HalfTabardSize)
	self.EmblemTR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemTR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemTR:SetPoint("TOPLEFT", self.EmblemTL, "TOPRIGHT")
	
	self.EmblemBL = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBL:SetWidth(self.HalfTabardSize)
	self.EmblemBL:SetHeight(self.HalfTabardSize)
	self.EmblemBL:SetTexCoord(0.5, 1, 0, 1)
	self.EmblemBL:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBL:SetPoint("TOP", self.EmblemTL, "BOTTOM")
	
	self.EmblemBR = self:CreateTexture(nil, "ARTWORK")
	self.EmblemBR:SetWidth(self.HalfTabardSize)
	self.EmblemBR:SetHeight(self.HalfTabardSize)
	self.EmblemBR:SetTexCoord(1, 0.5, 0, 1)
	self.EmblemBR:SetVertexColor(self.EmblemBrightness, self.EmblemBrightness, self.EmblemBrightness, 1)
	self.EmblemBR:SetPoint("TOP", self.EmblemTR, "BOTTOM")
	
	self.GuildNameBackground = self:CreateTexture(nil, "ARTWORK")
	self.GuildNameBackground:SetHeight(55)
	self.GuildNameBackground:SetPoint("TOP", self, "TOP", 0, -5)
	self.GuildNameBackground:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.GuildNameBackground:SetPoint("LEFT", self.EmblemBR, "RIGHT", 0, 0)
	self.GuildNameBackground:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Title")
	self.GuildNameBackground:SetTexCoord(1, 0, 0.5, 1)
	self.GuildNameBackground:SetVertexColor(1, 1, 1, 0.6)
	
	self.GuildNameText = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.GuildNameText:SetPoint("TOP", self, "TOP", 0, -7)
	self.GuildNameText:SetWidth(340)
	self.GuildNameText:SetJustifyH("CENTER")
	
	self.Players = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.Players:SetPoint("TOP", self.GuildNameText, "BOTTOM", 0, -4)
	self.Players:SetWidth(480)
	self.Players:SetJustifyH("CENTER")
	
	self.DeleteButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, DELETE, 80)
	self.DeleteButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -10, 7)
	self.DeleteButton:SetHeight(18)
	self.DeleteButton.Text:SetFontObject(GameFontNormalSmall)
	self.DeleteButton:SetScript("OnClick", function ()
		GuildCalendarEvent:ConfirmDelete(GuildCalendarEvent.cConfirmDeletePartnerGuild, self.PartnerGuild.Config.GuildName, function ()
			GuildCalendarEvent.Partnerships:RemovePartnerGuild(self.PartnerGuild.Config.GuildName)
		end)
	end)
	
	self.SyncButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, GuildCalendarEvent.cSync, 80)
	self.SyncButton:SetPoint("RIGHT", self.DeleteButton, "LEFT", -10, 0)
	self.SyncButton:SetHeight(18)
	self.SyncButton.Text:SetFontObject(GameFontNormalSmall)
	self.SyncButton:SetScript("OnClick", function ()
		self.PartnerGuild:StartPartnerSync()
	end)
	
	self.ProgressBar = GuildCalendarEvent:New(GuildCalendarEvent._PartnerProgressBar, self)
	
	self.ProgressBar:SetPoint("TOP", self.SyncButton, "TOP")
	self.ProgressBar:SetPoint("BOTTOM", self.SyncButton, "BOTTOM")
	self.ProgressBar:SetPoint("RIGHT", self.SyncButton, "LEFT", -10, 0)
	self.ProgressBar:SetPoint("LEFT", self.EmblemTL, "LEFT", 0, 0)
end

function GuildCalendarEvent.UI._PartnerItem:SetPartnerGuild(pPartnerGuild)
	if self.PartnerGuild then
		GuildCalendarEvent.BroadcastLib:StopListening(self.PartnerGuild, self.PartnerGuildMessage, self)
	end
	
	self.PartnerGuild = pPartnerGuild
	
	if not self.PartnerGuild then
		return
	end
	
	GuildCalendarEvent.BroadcastLib:Listen(self.PartnerGuild, self.PartnerGuildMessage, self)
	
	self:Refresh()
	
	self:PartnerGuildMessage(self.PartnerGuild, self.PartnerGuild.Status, self.PartnerGuild.StatusMessage)
end

function GuildCalendarEvent.UI._PartnerItem:Refresh()
	self.GuildNameText:SetText("<"..self.PartnerGuild.Config.GuildName..">")
	self.Players:SetText(GuildCalendarEvent:FormatItemList(self.PartnerGuild.Config.Proxies))
	
	local vRoster = GuildCalendarEvent.RealmData.Guilds[self.PartnerGuild.Config.GuildName]
	
	if vRoster then
		self.EmblemBgTL:SetTexture(vRoster.BackgroundTop)
		self.EmblemBgTR:SetTexture(vRoster.BackgroundTop)
		self.EmblemBgBL:SetTexture(vRoster.BackgroundBottom)
		self.EmblemBgBR:SetTexture(vRoster.BackgroundBottom)
		self.EmblemBorderTL:SetTexture(vRoster.BorderTop)
		self.EmblemBorderTR:SetTexture(vRoster.BorderTop)
		self.EmblemBorderBL:SetTexture(vRoster.BorderBottom)
		self.EmblemBorderBR:SetTexture(vRoster.BorderBottom)
		self.EmblemTL:SetTexture(vRoster.EmblemTop)
		self.EmblemTR:SetTexture(vRoster.EmblemTop)
		self.EmblemBL:SetTexture(vRoster.EmblemBottom)
		self.EmblemBR:SetTexture(vRoster.EmblemBottom)
	else
		self.EmblemBgTL:SetTexture("")
		self.EmblemBgTR:SetTexture("")
		self.EmblemBgBL:SetTexture("")
		self.EmblemBgBR:SetTexture("")
		self.EmblemBorderTL:SetTexture("")
		self.EmblemBorderTR:SetTexture("")
		self.EmblemBorderBL:SetTexture("")
		self.EmblemBorderBR:SetTexture("")
		self.EmblemTL:SetTexture("")
		self.EmblemTR:SetTexture("")
		self.EmblemBL:SetTexture("")
		self.EmblemBR:SetTexture("")
	end
end

function GuildCalendarEvent.UI._PartnerItem:PartnerGuildMessage(pPartnerGuild, pMessageID, pDescription)
	if not pMessageID or pMessageID == "PARTNER_SYNC_COMPLETE" then
		self.ProgressBar:SetValue(0)
		
		if self.PartnerGuild.Config.LastUpdateDate then
			self.ProgressBar:SetText(string.format(GuildCalendarEvent.cLastPartnerUpdate,
					GuildCalendarEvent.DateLib:GetLongDateString(self.PartnerGuild.Config.LastUpdateDate),
					GuildCalendarEvent.DateLib:GetShortTimeString(self.PartnerGuild.Config.LastUpdateTime)))
		else
			self.ProgressBar:SetText(GuildCalendarEvent.cNoPartnerUpdate)
		end
		
		self:Refresh()
	elseif pMessageID == "GC5_SEND_PROGRESS"
	or pMessageID == "GC5_RECEIVE_PROGRESS" then
		if pMessageID == "GC5_SEND_PROGRESS" then
			self.SendProgress = pDescription
		else
			self.ReceiveProgress = pDescription
		end
		
		self.ProgressBar:SetProgress(self.SendProgress, self.ReceiveProgress)
	else
		local vStatus = GuildCalendarEvent.cPartnerStatus[pMessageID]
		
		if not vStatus then
			self.ProgressBar:SetText(pMessageID)
		else
			self.ProgressBar:SetText(vStatus:format(pDescription))
		end
	end
end

----------------------------------------
GuildCalendarEvent._PartnerProgressBar = {}
----------------------------------------

function GuildCalendarEvent._PartnerProgressBar:New(pParent)
	return CreateFrame("StatusBar", nil, pParent)
end

function GuildCalendarEvent._PartnerProgressBar:Construct()
	self:SetHeight(20)
	
	self.LabelText = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.LabelText:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.LabelText:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.LabelText:SetJustifyH("LEFT")
	self.LabelText:SetJustifyV("MIDDLE")
	
	self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	self:SetStatusBarColor(1, 0.7, 0)
	
	self:SetMinMaxValues(0, 1)
	self:SetValue(0)
end

function GuildCalendarEvent._PartnerProgressBar:SetText(pText)
	self.LabelText:SetText(pText)
end

function GuildCalendarEvent._PartnerProgressBar:SetProgress(pProgress1, pProgress2)
	local vProgress
	
	if not pProgress2 then
		vProgress = pProgress1
	elseif not pProgress1 then
		vProgress = pProgress2
	elseif pProgress2 < pProgress1 then
		vProgress = pProgress1
	else
		vProgress = pProgress2
	end
	
	if vProgress then
		self:SetValue(vProgress)
	else
		self:SetValue(0)
	end
end
