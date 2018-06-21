----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._EventViewer = {}
----------------------------------------

function GuildCalendarEvent.UI._EventViewer:New(pParentFrame)
	return CreateFrame("Frame", nil, pParentFrame)
end

function GuildCalendarEvent.UI._EventViewer:Construct(pParentFrame)
	self:SetAllPoints()
	
	self.Background = self:CreateTexture(nil, "BACKGROUND")
	self.Background:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -25)
	self.Background:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -7, 32)
	self.Background:SetVertexColor(0.3, 0.3, 0.3, 1)
	
	self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Title:SetHeight(0)
	self.Title:SetPoint("TOPLEFT", self, "TOPLEFT", 20, -35)
	self.Title:SetPoint("TOPRIGHT", self, "TOPRIGHT", -20, -35)
	self.Title:SetText("Event Title")
	
	self.DateTime = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.DateTime:SetHeight(0)
	self.DateTime:SetPoint("TOPLEFT", self, "TOPLEFT", 20, -70)
	self.DateTime:SetPoint("TOPRIGHT", self, "TOPRIGHT", -20, -70)
	
	self.Levels = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Levels:SetHeight(0)
	self.Levels:SetPoint("TOPLEFT", self.DateTime, "BOTTOMLEFT", 0, -10)
	self.Levels:SetPoint("TOPRIGHT", self.DateTime, "BOTTOMRIGHT", 0, -10)
	self.Levels:SetText("Levels 70 and up")
	
	self.Description = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Description:SetPoint("TOPLEFT", self.Levels, "BOTTOMLEFT", 0, -20)
	self.Description:SetPoint("TOPRIGHT", self.Levels, "BOTTOMRIGHT", 0, -20)
	self.Description:SetWidth(300)
	self.Description:SetText("")
	
	self.YesCheckButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.YesCheckButton:SetTitle(GuildCalendarEvent.cYes)
	self.YesCheckButton:SetAnchorMode("TITLE")
	self.YesCheckButton.Title:SetPoint("CENTER", self.Description, "BOTTOM", 10, -25)
	self.YesCheckButton:SetScript("OnClick", function (checkButton) self:YesButtonClicked() end)
	
	self.MaybeCheckButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.MaybeCheckButton:SetTitle(GuildCalendarEvent.cMaybe)
	self.MaybeCheckButton:SetAnchorMode("TITLE")
	self.MaybeCheckButton.Title:SetPoint("TOP", self.YesCheckButton.Title, "BOTTOM", 0, -20)
	self.MaybeCheckButton:SetScript("OnClick", function (checkButton) self:MaybeButtonClicked() end)
	
	self.NoCheckButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self)
	self.NoCheckButton:SetTitle(GuildCalendarEvent.cNo)
	self.NoCheckButton:SetAnchorMode("TITLE")
	self.NoCheckButton.Title:SetPoint("TOP", self.MaybeCheckButton.Title, "BOTTOM", 0, -20)
	self.NoCheckButton:SetScript("OnClick", function (checkButton) self:NoButtonClicked() end)
	
	self.RemoveAndReportButtonSpacing = -30
	
	self.RemoveButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, CALENDAR_VIEW_EVENT_REMOVE, 105)
	self.RemoveButton:SetPoint("TOP", self.NoCheckButton.Title, "BOTTOM", 0, self.RemoveAndReportButtonSpacing)
	self.RemoveButton:SetPoint("RIGHT", self.Description, "CENTER", -20, 0)
	self.RemoveButton:SetScript("OnClick", function (frame, ...)
		PlaySound("856")
		self.Event:Remove()
	end)
	
	self.ReportSpamButton = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._PushButton, self, REPORT_SPAM, 105)
	self.ReportSpamButton:SetPoint("TOP", self.NoCheckButton.Title, "BOTTOM", 0, self.RemoveAndReportButtonSpacing)
	self.ReportSpamButton:SetPoint("LEFT", self.Description, "CENTER", 20, 0)
	self.ReportSpamButton:SetScript("OnClick", function (frame, ...)
		PlaySound("856")
		self.Event:Complain()
	end)

	self.Status = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	self.Status:SetWidth(280)
	self.Status:SetHeight(0)
	self.Status:SetPoint("BOTTOM", self, "BOTTOM", 0, 40)
	
	self.CacheStatus = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	self.CacheStatus:SetWidth(280)
	self.CacheStatus:SetHeight(0)
	self.CacheStatus:SetPoint("BOTTOM", self.Status, "TOP", 0, 10)
	
	self:SetScript("OnShow", function ()
		PlaySound("839")
		GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
		self:Refresh()
	end)
	
	self:SetScript("OnHide", function ()
		GuildCalendarEvent.EventLib:UnregisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
	end)
end

GuildCalendarEvent.UI._EventViewer.cStatusMessages =
{
	[CALENDAR_INVITESTATUS_INVITED] = GuildCalendarEvent.cInvitedStatus,
	[CALENDAR_INVITESTATUS_ACCEPTED] = GuildCalendarEvent.cAcceptedStatus,
	[CALENDAR_INVITESTATUS_DECLINED] = GuildCalendarEvent.cDeclinedStatus,
	[CALENDAR_INVITESTATUS_CONFIRMED] = GuildCalendarEvent.cConfirmedStatus,
	[CALENDAR_INVITESTATUS_TENTATIVE] = GuildCalendarEvent.cTentativeStatus,
	[CALENDAR_INVITESTATUS_OUT] = GuildCalendarEvent.cOutStatus,
	[CALENDAR_INVITESTATUS_STANDBY] = GuildCalendarEvent.cStandbyStatus,
	[CALENDAR_INVITESTATUS_SIGNEDUP] = GuildCalendarEvent.cSignedUpStatus,
	[CALENDAR_INVITESTATUS_NOT_SIGNEDUP] = GuildCalendarEvent.cNotSignedUpStatus,
}

GuildCalendarEvent.UI._EventViewer.cStatusAttending =
{
	[CALENDAR_INVITESTATUS_INVITED] = nil,
	[CALENDAR_INVITESTATUS_ACCEPTED] = "Y",
	[CALENDAR_INVITESTATUS_TENTATIVE] = "?",
	[CALENDAR_INVITESTATUS_DECLINED] = "N",
	[CALENDAR_INVITESTATUS_CONFIRMED] = "Y",
	[CALENDAR_INVITESTATUS_OUT] = "N",
	[CALENDAR_INVITESTATUS_STANDBY] = "Y",
	[CALENDAR_INVITESTATUS_SIGNEDUP]   = "Y",
	[CALENDAR_INVITESTATUS_NOT_SIGNEDUP]   = "N",
}

function GuildCalendarEvent.UI._EventViewer:SetEvent(pEvent, pIsNewEvent)
	GuildCalendarEvent.BroadcastLib:StopListening(nil, self.EventMessage, self)
	
	self.Event = pEvent
	
	if not self.Event then
		return
	end
	
	self:Refresh()
	
	GuildCalendarEvent.BroadcastLib:Listen(self.Event, self.EventMessage, self)
end

function GuildCalendarEvent.UI._EventViewer:EventMessage(pEvent, pMessageID)
	if pMessageID == "CHANGED"
	or pMessageID == "INVITES_CHANGED" then
		self:Refresh()
	end
end

function GuildCalendarEvent.UI._EventViewer:SaveEventFields()
	-- Nothing to do, event is updated as the user manipulates it
end

function GuildCalendarEvent.UI._EventViewer:Refresh()
	-- Set the fields
	
	self.Title:SetText(self.Event.Title)
	
	self.YesCheckButton:SetTitle(GuildCalendarEvent.cYes:format(self.Event.OwnersName))
	self.NoCheckButton:SetTitle(GuildCalendarEvent.cNo:format(self.Event.OwnersName))
	
	local vDate = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Event.Month, self.Event.Day, self.Event.Year)
	local vDateTimeString
	
	if not self.Event:IsAllDayEvent() then
		local vTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour or 0, self.Event.Minute or 0)
		
		if GuildCalendarEvent.Clock.Data.ShowLocalTime then
			vDate, vTime = GuildCalendarEvent.DateLib:GetLocalDateTimeFromServerDateTime(vDate, vTime)
		end
		
		local vDateString = GuildCalendarEvent.DateLib:GetLongDateString(vDate, true)
		
		if self.Event.Duration and self.Event.Duration ~= 0 then
			local vEndTime = math.fmod(vTime + self.Event.Duration, 1440)
			
			vDateTimeString = string.format(
								GuildCalendarEvent.cTimeDateRangeFormat,
								vDateString,
								GuildCalendarEvent.DateLib:GetShortTimeString(vTime),
								GuildCalendarEvent.DateLib:GetShortTimeString(vEndTime))
		else
			vDateTimeString = string.format(
								GuildCalendarEvent.cSingleTimeDateFormat,
								vDateString,
								GuildCalendarEvent.DateLib:GetShortTimeString(vTime))
		end
	else
		local vDateString = GuildCalendarEvent.DateLib:GetLongDateString(vDate, true)
	
		vDateTimeString = string.format(
							GuildCalendarEvent.cSingleTimeDateFormat,
							vDateString,
							GuildCalendarEvent.cAllDay)
	end

	self.DateTime:SetText(vDateTimeString)
	
	-- Update the level range
	
	local vMinLevel, vMaxLevel = self.Event:GetLevelRange()
	
	if self.Event:UsesLevelLimits() then
		if vMinLevel ~= nil then
			if vMaxLevel ~= nil then
				if vMinLevel == vMaxLevel then
					self.Levels:SetText(string.format(GuildCalendarEvent.cSingleLevel, vMinLevel))
				else
					self.Levels:SetText(string.format(GuildCalendarEvent.cLevelRangeFormat, vMinLevel, vMaxLevel))
				end
			else
				if vMinLevel == 80 then
					self.Levels:SetText(string.format(GuildCalendarEvent.cSingleLevel, vMinLevel))
				else
					self.Levels:SetText(string.format(GuildCalendarEvent.cMinLevelFormat, vMinLevel))
				end
			end
			
			self.Levels:Show()
		else
			if vMaxLevel ~= nil then
				self.Levels:SetText(string.format(GuildCalendarEvent.cMaxLevelFormat, vMaxLevel))
			else
				self.Levels:SetText(GuildCalendarEvent.cAllLevels)
			end
			
			self.Levels:Show()
		end
		
		if self.Event:PlayerIsQualified() then
			self.Levels:SetTextColor(1.0, 0.82, 0)
		else
			self.Levels:SetTextColor(1.0, 0.2, 0.2)
		end
	else
		self.Levels:Hide()
	end
	
	self.Description:SetText(self.Event.Description or "")
	
	if self.Event:CanRemove() then
		self.RemoveButton:Show()
	else
		self.RemoveButton:Hide()
	end
	
	if self.Event:CanComplain() then
		self.ReportSpamButton:Show()
	else
		self.ReportSpamButton:Hide()
	end
	
	-- Adjust the positions of Report and Remove buttons
	
	self.RemoveButton:ClearAllPoints()
	self.RemoveButton:SetPoint("TOP", self.NoCheckButton.Title, "BOTTOM", 0, self.RemoveAndReportButtonSpacing)
	
	self.ReportSpamButton:ClearAllPoints()
	self.ReportSpamButton:SetPoint("TOP", self.NoCheckButton.Title, "BOTTOM", 0, self.RemoveAndReportButtonSpacing)
	
	if self.Event:CanRemove() and self.Event:CanComplain() then
		self.RemoveButton:SetPoint("RIGHT", self.Description, "CENTER", -20, 0)
		self.ReportSpamButton:SetPoint("LEFT", self.Description, "CENTER", 20, 0)
	elseif self.Event:CanRemove() then
		self.RemoveButton:SetPoint("CENTER", self.Description, "CENTER", 0, 0)
	elseif self.Event:CanComplain() then
		self.ReportSpamButton:SetPoint("CENTER", self.Description, "CENTER", 0, 0)
	end
	
	-- Update the status
	
	self:UpdateInviteStatus()
	
	if self.Event.OwnersName == GuildCalendarEvent.PlayerName then
		if self.Event:IsExpired() then
			self.CacheStatus:SetText(GuildCalendarEvent.cExpiredEventNote)
		else
			self.CacheStatus:SetText("")
		end
	elseif self.Event.OwnersName == GuildCalendarEvent.cBlizzardOwner then
		self.CacheStatus:SetText("")
	else
		self.CacheStatus:SetText(
				GuildCalendarEvent.cCachedEventStatus:gsub("%$(%w+)",
				{
					Name = self.Event.OwnersName,
					Time = GuildCalendarEvent.DateLib:GetShortTimeString(self.Event.CacheUpdateTime) or "unknown time",
					Date = GuildCalendarEvent.DateLib:GetLongDateString(self.Event.CacheUpdateDate) or "unknown date"
				}))
	end
	
	-- Adjust the background
	
	GuildCalendarEvent:SetEventBackground(self.Event, self.Background, self:GetWidth(), self:GetHeight())
end

function GuildCalendarEvent.UI._EventViewer:UpdateInviteStatus()
	if self.Event:UsesAttendance() then
		local vInviteStatus = self.Event:GetInviteStatus(self.Event.OwnersName)
		local vStatus = self.cStatusMessages[vInviteStatus] or string.format("Unknown (%s)", tostring(vInviteStatus))
		
		self.Status:SetText(GuildCalendarEvent.cStatusFormat:format(vStatus).."\r"..CALENDAR_EVENT_CREATORNAME:format(self.Event.Creator or "unknown"))
		
		local vAttending = self.cStatusAttending[vInviteStatus]
		
		self.YesCheckButton:SetChecked(vAttending == "Y")
		self.MaybeCheckButton:SetChecked(vAttending == "?")
		self.NoCheckButton:SetChecked(vAttending == "N")
		
		self.Status:Show()
		self.YesCheckButton:Show()
		self.MaybeCheckButton:Show()
		self.NoCheckButton:Show()
		
		local vCanRSVP = self.Event:CanRSVP()
		
		self.YesCheckButton:SetEnabled(vCanRSVP and (not self.Event:IsSignupEvent() or vAttending ~= "?"))
		self.MaybeCheckButton:SetEnabled(vCanRSVP and (not self.Event:IsSignupEvent() or vAttending ~= "Y"))
		self.NoCheckButton:SetEnabled(vCanRSVP)
	else
		self.Status:Hide()
		self.YesCheckButton:Hide()
		self.MaybeCheckButton:Hide()
		self.NoCheckButton:Hide()
	end
end

function GuildCalendarEvent.UI._EventViewer:YesButtonClicked()
	self.Event:SetConfirmedStatus()
	self:Refresh()
end

function GuildCalendarEvent.UI._EventViewer:MaybeButtonClicked()
	self.Event:SetTentativeStatus()
	self:Refresh()
end

function GuildCalendarEvent.UI._EventViewer:NoButtonClicked()
	self.Event:SetDeclinedStatus()
	self:Refresh()
end

function GuildCalendarEvent:SetEventBackground(pEvent, pTexture, pWidth, pHeight)
	local vTextureID
	
	if pEvent:IsPlayerCreated() and pEvent.TextureIndex then
		local vEventTypeTextures = GuildCalendarEvent:GetEventTypeTextures(pEvent.EventType)
		local vTexture = vEventTypeTextures[pEvent.TextureIndex]
		
		vTextureID = vTexture and vTexture.TextureName
	else
		vTextureID = pEvent.TextureID
	end
	
	local vTexturePath, vTexCoords = GuildCalendarEvent:GetTextureFile(vTextureID, pEvent.CalendarType, pEvent.NumSequenceDays ~= 2 and pEvent.SequenceType or "", pEvent.EventType, pEvent.TitleTag)
	
	if pEvent.SequenceType == "ONGOING" then
		vTexturePath, vTexCoords = GuildCalendarEvent:GetTextureFile(vTextureID, pEvent.CalendarType, "START", pEvent.EventType)
	end
	
	GuildCalendarEvent:SetClippedTexture(pTexture, vTexturePath, vTexCoords, pWidth, pHeight)
end

function GuildCalendarEvent:SetClippedTexture(pTexture, pTexturePath, pTexCoords, pWidth, pHeight)
	pTexture:SetTexture(pTexturePath)
	
	local vAspectRatio = pWidth / pHeight

	local vTexCenter, vTexWidth
	local vTexTop, vTexBottom
	
	if pTexCoords then
		vTexCenter = 0.5 * (pTexCoords.right + pTexCoords.left)
		vTexWidth = pTexCoords.right - pTexCoords.left
		vTexTop, vTexBottom = pTexCoords.top, pTexCoords.bottom
	else
		vTexCenter = 0.5
		vTexWidth = 1
		vTexTop, vTexBottom = 0, 1
	end
	
	local vClippedWidth = vTexWidth * vAspectRatio
	local vClippedLeft = vTexCenter - 0.5 * vClippedWidth
	local vClippedRight = vClippedLeft + vClippedWidth
	
	pTexture:SetTexCoord(
			vClippedLeft, vClippedRight,
			vTexTop, vTexBottom)
end
