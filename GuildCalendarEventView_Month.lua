----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

local _

----------------------------------------
GuildCalendarEvent.UI._MonthView = {}
----------------------------------------

function GuildCalendarEvent.UI._MonthView:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._MonthView:Construct(pParent)
	GC5FontMonthView = CreateFont("GC5FontMonthView")
	GC5FontMonthView:SetFontObject(SystemFont_Tiny)
	GC5FontMonthView:SetTextColor(1, 1, 1)
	GC5FontMonthView:SetShadowColor(0, 0, 0)
	GC5FontMonthView:SetShadowOffset(1, -1)
	
	-- Create the month navigation
	
	self.MonthYearText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.MonthYearText:SetPoint("TOP", self, "TOP", 17, -7)
	
	self.PreviousMonthButton = CreateFrame("Button", nil, self)
	self.PreviousMonthButton:SetWidth(32)
	self.PreviousMonthButton:SetHeight(32)
	self.PreviousMonthButton:SetPoint("CENTER", self.MonthYearText, "CENTER", -100, 0)
	self.PreviousMonthButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up");
	self.PreviousMonthButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down");
	self.PreviousMonthButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled");
	self.PreviousMonthButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
	self.PreviousMonthButton:SetScript("OnClick", function () self:ShowPreviousMonth() end)
	
	self.NextMonthButton = CreateFrame("Button", nil, self)
	self.NextMonthButton:SetWidth(32)
	self.NextMonthButton:SetHeight(32)
	self.NextMonthButton:SetPoint("CENTER", self.MonthYearText, "CENTER", 100, 0)
	self.NextMonthButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
	self.NextMonthButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down");
	self.NextMonthButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled");
	self.NextMonthButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
	self.NextMonthButton:SetScript("OnClick", function () self:ShowNextMonth() end)
	
	self.TodayButton = CreateFrame("Button", nil, self)
	self.TodayButton:SetWidth(32)
	self.TodayButton:SetHeight(32)
	self.TodayButton:SetPoint("CENTER", self.NextMonthButton, "CENTER", 30, 0)
	self.TodayButton:SetNormalTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\TodayIcon-Up");
	self.TodayButton:SetPushedTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\TodayIcon-Down");
	self.TodayButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
	self.TodayButton:SetScript("OnClick", function ()
		local _, vMonth, vDay, vYear = GuildCalendarEvent.WoWCalendar:CalendarGetDate()
		GuildCalendarEvent.UI.Window:ShowDaySidebar(vMonth, vDay, vYear)
		self:ShowCurrentMonth()
	end)
	
	-- Create the 'today' highlight
	
	self.TodayHighlight = CreateFrame("Frame", "GuildCalendarEventTodayHighlight", self, "AutoCastShineTemplate")
	self.TodayHighlight:SetWidth(64)
	self.TodayHighlight:SetHeight(64)
	self.TodayHighlight:SetScript("OnShow", AutoCastShine_AutoCastStart)
	self.TodayHighlight:SetScript("OnHide", AutoCastShine_AutoCastStop)
	
	AutoCastShine_OnLoad(self.TodayHighlight)
	
	self.TodayHighlight:SetFrameLevel(self.TodayHighlight:GetFrameLevel() + 10)
	self.TodayHighlight:Hide()
	
	-- Create the weekday labels
	
	self.WeekdayTitles = {}
	self.WeekdaySpacing = 72
	
	for vIndex = 1, 7 do
		local vTitle = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		
		vTitle:SetPoint("CENTER", self, "TOPLEFT", 65 + (vIndex - 1) * self.WeekdaySpacing, -48)
		
		self.WeekdayTitles[vIndex] = vTitle
	end
	
	--
	
	self.DayFrames = {}
	
	local vFirstDayFrame
	
	for vWeek = 1, 6 do
		for vWeekday = 1, 7 do
			local vShading = ((vWeek - 1) * (vWeek - 1) + (vWeekday - 1) * (vWeekday - 1)) / 61
			
			vShading = 1 - (vShading * 0.5)
			
			if vShading > 1 then
				vShading = 1
			end
			
			local vDayFrame = GuildCalendarEvent:New(GuildCalendarEvent._DayFrame, self, self.WeekdaySpacing, vShading)
			
			if not vFirstDayFrame then
				vFirstDayFrame = vDayFrame
				vDayFrame:SetPoint("TOP", self.WeekdayTitles[1], "BOTTOM", 0, -8)
			else
				vDayFrame:SetPoint("TOPLEFT", vFirstDayFrame, "TOPLEFT", (vWeekday - 1) * self.WeekdaySpacing, -(vWeek - 1) * self.WeekdaySpacing)
			end
			
			vDayFrame:SetMonthPosition(vWeekday, vWeek)
			
			table.insert(self.DayFrames, vDayFrame)
			
			-- Leave room for the calendars picker
			
			if vWeek == 6
			and vWeekday == 4 then
				break
			end
		end
	end
	
	self.MonthViewOptions = GuildCalendarEvent:New(GuildCalendarEvent.UI._MonthViewOptions, self)
	self.MonthViewOptions:SetPoint("TOPLEFT", self.DayFrames[#self.DayFrames], "TOPRIGHT", 4, 0)
	self.MonthViewOptions:SetPoint("RIGHT", self.DayFrames[7], "RIGHT", -7, 0)
	self.MonthViewOptions:SetPoint("BOTTOM", self.DayFrames[36], "BOTTOM", 0, 4)
	
	--
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	self:SetScript("OnEvent", self.OnEvent)
end

function GuildCalendarEvent.UI._MonthView:SetThemeID(pThemeID)
	local vTheme = GuildCalendarEvent.Themes[pThemeID]
	if not vTheme then
		vTheme = GuildCalendarEvent.Themes.PARCHMENT
	end
	for _, vDayFrame in ipairs(self.DayFrames) do
		vDayFrame:SetTheme(vTheme)
	end
end

function GuildCalendarEvent.UI._MonthView:AdjustWeekdayTitles()
	local vWeekdayNames =
	{
		WEEKDAY_SUNDAY,
		WEEKDAY_MONDAY,
		WEEKDAY_TUESDAY,
		WEEKDAY_WEDNESDAY,
		WEEKDAY_THURSDAY,
		WEEKDAY_FRIDAY,
		WEEKDAY_SATURDAY,
	}
	
	for vIndex = 1, 7 do
		self.WeekdayTitles[vIndex]:SetText(vWeekdayNames[(vIndex + (GuildCalendarEvent.Data.StartDay or 1) - 2) % 7 + 1])
	end
end

function GuildCalendarEvent.UI._MonthView:SetStartDay(pStartDay)
	local vStartDay = tonumber(pStartDay)
	if vStartDay < 1 then vStartDay = 1
	elseif vStartDay > 7 then vStartDay = 7 end
end

function GuildCalendarEvent.UI._MonthView:OnShow()
	-- Create the menus if they're not present yet
	if not self.DayMenu then
		self.DayMenu = GuildCalendarEvent:New(GuildCalendarEvent._DayContextMenu, self)
	end
	if not self.EventMenu then
		self.EventMenu = GuildCalendarEvent:New(GuildCalendarEvent._EventContextMenu, self)
	end
	
	GuildCalendarEvent.EventLib:RegisterEvent("GC5_CALENDAR_CHANGED", self.Refresh, self)
	GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
	
	self:RegisterEvent("CVAR_UPDATE")
	self:AdjustWeekdayTitles()
	self:ShowCurrentMonth()
end

function GuildCalendarEvent.UI._MonthView:OnHide()
	if GuildCalendarEvent.UI.Window then
		GuildCalendarEvent.UI.Window:HideSidebars()
	end
	
	GuildCalendarEvent.EventLib:UnregisterEvent("GC5_CALENDAR_CHANGED", self.Refresh, self)
	GuildCalendarEvent.EventLib:UnregisterEvent("GC5_PREFS_CHANGED", self.Refresh, self)
	
	self:UnregisterEvent("CVAR_UPDATE")
end

function GuildCalendarEvent.UI._MonthView:OnEvent(pEventID, ...)
	if pEventID == "CVAR_UPDATE" then
		local vName = select(1, ...)
		
		if vName == "calendarShowDarkmoon"
		or vName == "calendarShowWeeklyHolidays"
		or vName == "calendarShowBattlegrounds" then
			self:BlizzardCalendarChanged()
		end
	end
end

function GuildCalendarEvent.UI._MonthView:BlizzardCalendarChanged()
	GuildCalendarEvent.Calendars.BLIZZARD:FlushCaches()
	
	if IsAddOnLoaded("Blizzard_Calendar") then
		CalendarFrame_Update()
	end
	
	self:Refresh()
end

function GuildCalendarEvent.UI._MonthView:ShowPreviousMonth()
	self.Month = self.Month - 1
	
	if self.Month == 0 then
		self.Month = 12
		self.Year = self.Year - 1
	end
	
	GuildCalendarEvent.WoWCalendar:CalendarSetAbsMonth(self.Month, self.Year)
	
	self:Refresh()
end

function GuildCalendarEvent.UI._MonthView:ShowNextMonth()
	self.Month = self.Month + 1
	
	if self.Month == 13 then
		self.Month = 1
		self.Year = self.Year + 1
	end
	
	GuildCalendarEvent.WoWCalendar:CalendarSetAbsMonth(self.Month, self.Year)
	
	self:Refresh()
end

function GuildCalendarEvent.UI._MonthView:ShowCurrentMonth()
	if GuildCalendarEvent.Clock.Data.ShowLocalTime then
		self.TodaysMonth, self.TodaysDay, self.TodaysYear = GuildCalendarEvent.DateLib:GetLocalMDY()
	else
		_, self.TodaysMonth, self.TodaysDay, self.TodaysYear = GuildCalendarEvent.WoWCalendar:CalendarGetDate()
	end
	
	self.Month = self.TodaysMonth
	self.Year = self.TodaysYear
	
	GuildCalendarEvent.WoWCalendar:CalendarSetAbsMonth(self.Month, self.Year)
	
	self:Refresh()
end

function GuildCalendarEvent.UI._MonthView:SelectDate(pMonth, pDay, pYear)
	local vDayFrame
	
	-- Deselect the currently selected date
	
	if self.SelectedMonth then
		vDayFrame = self:GetDayFrameByDate(self.SelectedMonth, self.SelectedDay, self.SelectedYear)
		if vDayFrame then vDayFrame:SetSelected(false) end
	end
	
	-- Done if nothing being selected
	
	self.SelectedMonth, self.SelectedDay, self.SelectedYear = pMonth, pDay, pYear
	
	if not self.SelectedMonth then
		return
	end
	
	-- Highlight the new selection
	
	local vDayFrame = self:GetDayFrameByDate(self.SelectedMonth, self.SelectedDay, self.SelectedYear)
	if vDayFrame then vDayFrame:SetSelected(true) end
end

function GuildCalendarEvent.UI._MonthView:GetDayFrameByDate(pMonth, pDay, pYear)
	local vPreviousMonth, vPreviousYear, vPreviousNumDays = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(-1)
	local vMonth, vYear, vNumDays, vFirstDay = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(0)
	local vNextMonth, vNextYear  = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(1)
	local vDayFrameIndex
	
	vFirstDay = (vFirstDay - (GuildCalendarEvent.Data.StartDay or 1)) % 7 + 1
	
	if pMonth == vPreviousMonth and pYear == vPreviousYear then
		vDayFrameIndex = vFirstDay + pDay - vPreviousNumDays - 1
		
	elseif pMonth == vMonth and pYear == vYear then
		vDayFrameIndex = vFirstDay + pDay - 1
	
	elseif pMonth == vNextMonth and pYear == vNextYear then
		vDayFrameIndex = vFirstDay + vNumDays + pDay - 1
	end
	
	return self.DayFrames[vDayFrameIndex]
end

function GuildCalendarEvent.UI._MonthView:Refresh()
	local vPreviousMonth, vPreviousYear, vPreviousNumDays = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(-1)
	local vMonth, vYear, vNumDays, vFirstDay = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(0)
	local vNextMonth, vNextYear  = GuildCalendarEvent.WoWCalendar:CalendarGetMonth(1)
	
	self.MonthYearText:SetText(string.format("%s %04d", GuildCalendarEvent.CALENDAR_MONTH_NAMES[vMonth], vYear))
	
	vFirstDay = (vFirstDay - (GuildCalendarEvent.Data.StartDay or 1)) % 7 + 1
	
	-- 
	
	local vDidShowToday
	
	for vDayFrameIndex, vDayFrame in ipairs(self.DayFrames) do
		local vFrameMonth, vFrameDay, vFrameYear
		
		if vDayFrameIndex < vFirstDay then
			vFrameMonth = vPreviousMonth
			vFrameDay = vPreviousNumDays + vDayFrameIndex - vFirstDay + 1
			vFrameYear = vPreviousYear
		else
			vFrameDay = vDayFrameIndex - vFirstDay + 1
			
			if vFrameDay <= vNumDays then
				vFrameMonth = vMonth
				vFrameYear = vYear
			else
				vFrameMonth = vNextMonth
				vFrameDay = vFrameDay - vNumDays
				vFrameYear = vNextYear
			end
		end
		
		vDayFrame:SetDate(vFrameMonth, vFrameDay, vFrameYear, vMonth)
		vDayFrame:Show()
		
		if vFrameMonth == self.TodaysMonth
		and vFrameDay == self.TodaysDay
		and vFrameYear == self.TodaysYear then
			self.TodayHighlight:SetPoint("CENTER", vDayFrame, "CENTER")
			self.TodayHighlight:Show()
			
			vDidShowToday = true
		end
		
		if vFrameMonth == self.SelectedMonth
		and vFrameDay == self.SelectedDay
		and vFrameYear == self.SelectedYear then
			vDayFrame:SetSelected(true)
		end
	end
	
	if not vDidShowToday then
		self.TodayHighlight:Hide()
	end
end

----------------------------------------
GuildCalendarEvent._DayFrame = {}
----------------------------------------

local gDayFrameID = 1

GuildCalendarEvent._DayFrame.cCooldownEventDogEarIndex =
{
	XMUT = 2, -- Transmutes
	ALCH = 2, -- Alchemy Research
	
	VOID = 27, -- Void Shatter
	SPHR = 27, -- Void Sphere 
	
	MOON = 0, -- Mooncloth
	PMON = 0, -- Primal Mooncloth
	SPEL = 0, -- Spellcloth
	SHAD = 0, -- Shadowcloth
	EBON = 0, -- Ebonweave
	SWEV = 0, -- Spellweave
	SHRD = 0, -- Moonshroud
	
	GLSS = 26, -- Brilliant Glass
	ICYP = 26, -- Icy Prism
	
	INSC = 4, -- Inscription Research
	INSN = 4, -- Northrend Inscription Research
	
	TITN = 12, -- Smelt Titansteel
}

function GuildCalendarEvent._DayFrame:New(pParent, pSize, pShading)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent._DayFrame:Construct(pParent, pSize, pShading)
	self:SetWidth(pSize)
	self:SetHeight(pSize)
	
	self.BackgroundTile = self:CreateTexture(nil, "BACKGROUND")
	
	self.Shading = pShading
	self.Theme = GuildCalendarEvent.Themes[GuildCalendarEvent.Data.ThemeID or "SEASONAL"] or GuildCalendarEvent.Themes.PARCHMENT
	self.BackgroundTile:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.BackgroundTile:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	
	self.BackgroundFrame = CreateFrame("Frame", nil, self)
	self.BackgroundFrame:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.BackgroundFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	
	self.DayIcon = self.BackgroundFrame:CreateTexture(nil, "BORDER")
	self.DayIcon:SetTexture(0, 0, 0, 0)
	self.DayIcon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
	self.DayIcon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	self.DayIcon:SetVertexColor(0.6, 0.6, 0.6, 1)
	self.DayIcon:Hide()
	
	self.OverlayIcon = self.BackgroundFrame:CreateTexture(nil, "OVERLAY")
	self.OverlayIcon:SetTexture()
	self.OverlayIcon:SetPoint("TOPLEFT", self, "TOPLEFT", 3, -3)
	self.OverlayIcon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -3, 3)
	self.OverlayIcon:Hide()
	
	self.OverlayIconShadow = self.BackgroundFrame:CreateTexture(nil, "ARTWORK")
	self.OverlayIconShadow:SetTexture()
	self.OverlayIconShadow:SetPoint("TOPLEFT", self.OverlayIcon, "TOPLEFT", 2, -2)
	self.OverlayIconShadow:SetPoint("BOTTOMRIGHT", self.OverlayIcon, "BOTTOMRIGHT", 2, -2)
	self.OverlayIconShadow:SetVertexColor(0, 0, 0, 0.5)
	self.OverlayIconShadow:Hide()
	
	self.BirthdayIcon = self.BackgroundFrame:CreateTexture(nil, "OVERLAY")
	self.BirthdayIcon:SetTexture()
	self.BirthdayIcon:SetPoint("BOTTOMRIGHT", self.OverlayIcon, "BOTTOMRIGHT")
	self.BirthdayIcon:SetWidth(48)
	self.BirthdayIcon:SetHeight(48)
	
	self.SelectedTexture = self.BackgroundFrame:CreateTexture("GC5_DayFrameHighlight"..gDayFrameID, "ARTWORK")
	self.SelectedTexture:SetTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\DateButtonHighlight")
	self.SelectedTexture:SetVertexColor(1, 1, 0.4, 0.5)
	self.SelectedTexture:SetBlendMode("ADD")
	self.SelectedTexture:SetAllPoints()
	self.SelectedTexture:Hide()
	
	self.ButtonFrame = CreateFrame("Button", nil, self)
	self.ButtonFrame:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.ButtonFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.ButtonFrame:SetFrameLevel(self:GetFrameLevel() + 10)
	self.ButtonFrame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	self.ButtonFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.ButtonFrame:SetScript("OnEnter", function (pButtonFrame, ...) self:OnEnter(...) end)
	self.ButtonFrame:SetScript("OnLeave", function (pButtonFrame, ...) self:OnLeave(...) end)
	self.ButtonFrame:SetScript("OnClick", function (pButtonFrame, ...) self:OnClick(...) end)
	
	self.ForegroundFrame = CreateFrame("Frame", nil, self)
	self.ForegroundFrame:SetFrameLevel(self:GetFrameLevel() + 20)
	self.ForegroundFrame:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.ForegroundFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	
	self.DogEarIcon = self.ForegroundFrame:CreateTexture(nil, "BACKGROUND")
	self.DogEarIcon:SetTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\CooldownIcons")
	self.DogEarIcon:SetWidth(pSize * 0.3)
	self.DogEarIcon:SetHeight(pSize * 0.3)
	self.DogEarIcon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	
	self.ForegroundTile = self.ForegroundFrame:CreateTexture(nil, "BORDER")
	self.ForegroundTile:SetAllPoints()
	
	self.DateText = self.ForegroundFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.DateText:SetWidth(36)
	self.DateText:SetHeight(10)
	self.DateText:SetPoint("TOPLEFT", self, "TOPLEFT", -4, -7)
	self.DateText:SetText("10")
	
	self.CircledDate = self.ForegroundFrame:CreateTexture(nil, "ARTWORK")
	self.CircledDate:SetWidth(20)
	self.CircledDate:SetHeight(17)
	self.CircledDate:SetPoint("CENTER", self.DateText, "CENTER", 0, -1)
	self.CircledDate:SetTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\CircledDate")

	self.MoreText = self.ForegroundFrame:CreateFontString(nil, "OVERLAY", "GC5FontMonthView")
	self.MoreText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	self.MoreText:SetText(GuildCalendarEvent.cMore)
	self.MoreText:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 2)
	
	self.EventFrames = {}
	self.Events = {}
	
	self:SetDogEarIndex(0)
	
	gDayFrameID = gDayFrameID + 1
end

function GuildCalendarEvent._DayFrame:SetTheme(pTheme)
	self.Theme = pTheme
	self:ApplyTheme()
end

function GuildCalendarEvent._DayFrame:ApplyTheme()
	self.ForegroundTile:SetTexture(self.Theme.Foreground)

	if type(self.Theme.Background) == "table" then
		self.BackgroundTile:SetTexture(self.Theme.Background[self.ViewMonth or 1])
	else
		self.BackgroundTile:SetTexture(self.Theme.Background)
	end
	
	if self.Theme.RandomTile then
		local vTileTexLeft, vTileTexRight, vTileTexTop, vTileTexBottom
		local vColumn = math.floor(math.random() * self.Theme.TilesH)
		local vRow = math.floor(math.random() * self.Theme.TilesV)
		
		vTileTexLeft = vColumn / self.Theme.TilesH
		vTileTexRight = (vColumn + 1) / self.Theme.TilesH
		vTileTexTop = vRow / self.Theme.TilesV
		vTileTexBottom = (vRow + 1) / self.Theme.TilesV
		
		self.ForegroundTile:SetTexCoord(vTileTexLeft, vTileTexRight, vTileTexTop, vTileTexBottom)
		self.BackgroundTile:SetTexCoord(vTileTexLeft, vTileTexRight, vTileTexTop, vTileTexBottom)
	else
		self.BackgroundTile:SetTexCoord(
				(self.Weekday - 1) / 7,
				self.Weekday / 7,
				(self.Week - 1) / 6,
				self.Week / 6)
		
		self.ForegroundTile:SetTexCoord(0, 0.5, 0, 0.5)
	end
	
	local vShading = self.Month == self.ViewMonth and 1 or 0.25
	local vBackgroundShading = vShading * self.Theme.BackgroundBrightness * (self.Theme.UseShading and self.Shading or 1)
	
	self.BackgroundTile:SetVertexColor(vBackgroundShading, vBackgroundShading, vBackgroundShading, 1)
	
	self.BackgroundFrame:SetAlpha(vShading)
	self.ForegroundFrame:SetAlpha(vShading)
end

function GuildCalendarEvent._DayFrame:SetMonthPosition(pWeekday, pWeek)
	self.Weekday = pWeekday
	self.Week = pWeek
	
	self:ApplyTheme()
end

function GuildCalendarEvent._DayFrame:SetDogEarIndex(pIndex)
	local vRow = math.floor(pIndex / 8)
	local vColumn = math.fmod(pIndex, 8)
	
	self.DogEarIcon:SetTexCoord(vColumn / 8, (vColumn + 1) / 8, vRow / 4, (vRow + 1) / 4)
end

function GuildCalendarEvent._DayFrame:SetDate(pMonth, pDay, pYear, pViewMonth)
	if self.Month ~= pMonth 
	or self.Day ~= pDay
	or self.Year ~= pYear
	or self.ViewMonth ~= pViewMonth then
		self.Month = pMonth
		self.Day = pDay
		self.Year = pYear
		self.Date = GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Month, self.Day, self.Year)
		
		self.ViewMonth = pViewMonth
		
		self:ApplyTheme()
	end
	
	if not self.IsFlashing and not self.Selected then
		self.SelectedTexture:Hide()
	end
	
	self:Update()
end

function GuildCalendarEvent._DayFrame:GetMergedSchedules(pMonth, pDay, pYear)
end

function GuildCalendarEvent._DayFrame:Update()
	local vCurrentDateTimeStamp = GuildCalendarEvent.DateLib:GetServerDateTimeStamp()
	
	self.Events = GuildCalendarEvent:GetDayEvents(self.Month, self.Day, self.Year, self.Events)
	
	--
	
	if self.SummaryEvents then
		for vKey, _ in pairs(self.SummaryEvents) do
			self.SummaryEvents[vKey] = nil
		end
	else
		self.SummaryEvents = {}
	end
		
	--
	
	local vDidSetOverlay, vDidSetIcon, vDidSetCooldown, vDidSetBirthday
	local vSetIconEventData
	
	self.DateText:SetText(self.Day)
	
	local vEvent
	
	local vHasAppointment, vAppointmentEventData
	local vHasNewEvent
	local vHasMore
	
	for vEventIndex, vEvent in ipairs(self.Events) do
		-- Set the cooldown icon
		
		if vEvent:IsCooldownEvent()
		and not vDidSetCooldown then
			vDidSetCooldown = true
			self.DogEarIcon:Show()
			self:SetDogEarIndex(self.cCooldownEventDogEarIndex[vEvent.TitleTag] or 5)
		end
		
		if vEvent.Unseen then
			vHasNewEvent = true
		end
		
		-- Set the main texture for the frame
		
		if vEvent.SequenceType ~= "ONGOING"
		and not vEvent:IsCooldownEvent()
		and not vEvent:IsBirthdayEvent()
		and vEvent.InviteStatus ~= CALENDAR_INVITESTATUS_DECLINED then
			if vDidSetIcon
			and (vSetIconEventData.CalendarType == "HOLIDAY" or vSetIconEventData:HasPassed(vCurrentDateTimeStamp))
			and vEvent:IsPlayerCreated() then
				vDidSetIcon = false -- Un-set the icon so it'll get re-set by this event
			end
			
			if not vDidSetIcon then
				local vTexturePath, vTexCoords = GuildCalendarEvent:GetTextureFile(vEvent.TextureID, vEvent.CalendarType, vEvent.NumSequenceDays ~= 2 and vEvent.SequenceType or "", vEvent.EventType, vEvent.TitleTag)
				
				if vTexturePath then
					vDidSetIcon = true
					vSetIconEventData = vEvent
					
					-- GuildCalendarEvent:DebugMessage(" TexturePath: %s", vTexturePath or "nil")
					
					self.DayIcon:SetTexture(vTexturePath)
					self.DayIcon:SetTexCoord(vTexCoords.left, vTexCoords.right, vTexCoords.top, vTexCoords.bottom)
					self.DayIcon:Show()
				end
			end
		end
		
		if not vHasAppointment then
			if vEvent:IsAttending() then
				vHasAppointment = true
				vAppointmentEventData = vEvent
			end
		end
		
		-- Set the holiday overlay
		
		if not vDidSetOverlay
		and vEvent.CalendarType == "HOLIDAY"
		and vEvent.TextureID ~= "Calendar_FishingExtravaganza" then
--		and vEvent.SequenceType == "ONGOING" then
			local vTexturePath, vTexCoords = GuildCalendarEvent:GetTextureFile(vEvent.TextureID, vEvent.CalendarType, vEvent.NumSequenceDays ~= 2 and "ONGOING" or "", vEvent.EventType, vEvent.TitleTag)
			
			if vTexturePath then
				vDidSetOverlay = true
				
				self.OverlayIcon:SetTexture(vTexturePath)
				self.OverlayIcon:SetTexCoord(vTexCoords.left, vTexCoords.right, vTexCoords.top, vTexCoords.bottom)
				self.OverlayIcon:SetVertexColor(1, 1, 1, 1)
				self.OverlayIcon:Show()
				
				self.OverlayIconShadow:SetTexture(vTexturePath)
				self.OverlayIconShadow:SetTexCoord(vTexCoords.left, vTexCoords.right, vTexCoords.top, vTexCoords.bottom)
				self.OverlayIconShadow:Show()
			end
		end
		
		-- Light the candle if there's a birthday
		
		if not vDidSetBirthday
		and vEvent.TitleTag == "BRTH" then
			self.BirthdayIcon:SetTexture(GuildCalendarEvent.TitleTagInfo.BRTH.Texture)
			self.BirthdayIcon:Show()
			vDidSetBirthday = true
		end
		
		-- Display regular events in the in-date list
		
		if vEvent.CalendarType ~= "HOLIDAY"
		and vEvent.CalendarType ~= "RAID_LOCKOUT"
		and vEvent.CalendarType ~= "RAID_RESET"
		and vEvent.CalendarType ~= "ARENA"
		and not vEvent:IsCooldownEvent()
		and not vEvent:IsBirthdayEvent() then
			local vNeedToBump = #self.SummaryEvents >= 2
			
			if vNeedToBump then
				vHasMore = true
			end
			
			if not vNeedToBump then
				table.insert(self.SummaryEvents, vEvent)
			
			-- See if an event should be bumped
			
			-- ACCEPTED/TENTATIVE/CONFIRMED/STANDBY can bump anything except other ACCEPTED/TENTATIVE/CONFIRMED/STANDBY
			-- and the last INVITED response
			
			elseif vEvent.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
			    or vEvent.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
			    or vEvent.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP
				or vEvent.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
				or vEvent.InviteStatus == CALENDAR_INVITESTATUS_STANDBY then
				
				local vLastInvitedIndex
				
				for vExistingEventIndex = #self.SummaryEvents, 1, -1 do
					local vExistingEventData = self.SummaryEvents[vExistingEventIndex]
					
					if vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_INVITED then
						if vLastInvitedIndex then
							table.remove(self.SummaryEvents, vLastInvitedIndex)
							table.insert(self.SummaryEvents, vEvent)
							
							vLastInvitedIndex = vExistingEventIndex
							break
						end
						
						vLastInvitedIndex = vExistingEventIndex
					elseif (vExistingEventData.InviteStatus ~= CALENDAR_INVITESTATUS_ACCEPTED
					and vExistingEventData.InviteStatus ~= CALENDAR_INVITESTATUS_TENTATIVE
					and vExistingEventData.InviteStatus ~= CALENDAR_INVITESTATUS_SIGNEDUP
					and vExistingEventData.InviteStatus ~= CALENDAR_INVITESTATUS_CONFIRMED
					and vExistingEventData.InviteStatus ~= CALENDAR_INVITESTATUS_STANDBY)
					or vExistingEventData:HasPassed(vCurrentDateTimeStamp) then
						table.remove(self.SummaryEvents, vExistingEventIndex)
						table.insert(self.SummaryEvents, vEvent)
						break
					end
				end -- for vExistingEventIndex
				
			-- Invited can bump one ACCEPTED/CONFIRMED/STANDBY if no currently-selected events
			-- are INVITED responses
			
			elseif vEvent.InviteStatus == CALENDAR_INVITESTATUS_INVITED then
				local vHasInvited
				
				for vExistingEventIndex, vExistingEventData in ipairs(self.SummaryEvents) do
					if vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_INVITED then
						vHasInvited = true
						
						-- Replace the existing one if it's in the past
						
						if vExistingEventData:HasPassed(vCurrentDateTimeStamp) then
							table.remove(self.SummaryEvents, vExistingEventIndex)
							table.insert(self.SummaryEvents, vEvent)
						end
						
						break
					end
				end
				
				if not vHasInvited then
					for vExistingEventIndex = #self.SummaryEvents, 1, -1 do
						local vExistingEventData = self.SummaryEvents[vExistingEventIndex]
						
						if vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_ACCEPTED
						or vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_TENTATIVE
						or vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP
						or vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_CONFIRMED
						or vExistingEventData.InviteStatus == CALENDAR_INVITESTATUS_STANDBY then
							table.remove(self.SummaryEvents, vExistingEventIndex)
							table.insert(self.SummaryEvents, vEvent)
							break
						end
					end
				end
				
			-- DECLINED and OUT can't bump anything
			
			else
			end
		end
	end -- for vEvent

	if not vDidSetCooldown then
		self.DogEarIcon:Hide()
	end
	
	if not vDidSetIcon then
		self.DayIcon:SetTexture()
		self.DayIcon:Hide()
	end
	
	if not vDidSetOverlay then
		self.OverlayIcon:SetTexture()
		self.OverlayIcon:Hide()
		
		self.OverlayIconShadow:SetTexture()
		self.OverlayIconShadow:Hide()
	end
	
	if not vDidSetBirthday then
		self.BirthdayIcon:SetTexture()
		self.BirthdayIcon:Hide()
	end
	
	if vHasNewEvent then
		self:StartFlashing()
	else
		self:StopFlashing()
	end
	
	if vHasMore then
		self.MoreText:Show()
	else
		self.MoreText:Hide()
	end
	
	-- Circle the date if appropriate
	
	if vHasAppointment then
		local vColor = vAppointmentEventData:GetEventColor()
		
		self.CircledDate:SetVertexColor(vColor.r, vColor.g, vColor.b, 0.7)
		self.CircledDate:SetAlpha(vAppointmentIsDimmed and 0.4 or 1.0)
		self.CircledDate:Show()
	else
		self.CircledDate:Hide()
	end
	
	-- Set the summary
	
	local vDisplayIndex = #self.SummaryEvents - 1
	
	for vIndex, vEvent in ipairs(self.SummaryEvents) do
		local vEventFrame = self.EventFrames[vIndex]
		
		if not vEventFrame then
			vEventFrame = GuildCalendarEvent.DayFrameEventPool:GetFrame()
			self.EventFrames[vIndex] = vEventFrame
		end
		
		vEventFrame:SetDayFrame(self, vDisplayIndex, vHasMore)
		vEventFrame:SetEvent(vEvent)
		
		vDisplayIndex = vDisplayIndex - 1
	end
	
	while #self.EventFrames > #self.SummaryEvents do
		GuildCalendarEvent.DayFrameEventPool:ReleaseFrame(self.EventFrames[#self.EventFrames])
		table.remove(self.EventFrames, #self.EventFrames)
	end
end

function GuildCalendarEvent._DayFrame:OnEnter()
	if #self.Events == 0 then
		return
	end
	
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(GuildCalendarEvent.DateLib:GetLongDateString(self.Date, true), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	GuildCalendarEvent:AddTooltipEvents(GameTooltip, self.Events, GuildCalendarEvent.Clock.Data.ShowLocalTime)
	GameTooltip:Show()
end

function GuildCalendarEvent._DayFrame:OnLeave()
	GameTooltip:Hide()
end

function GuildCalendarEvent._DayFrame:OnClick(pButton)
	if pButton == "RightButton" then
		self:GetParent().DayMenu:Toggle(self.Month, self.Day, self.Year)
	else
		GuildCalendarEvent.UI.Window:ShowDaySidebar(self.Month, self.Day, self.Year)
	end
end

function GuildCalendarEvent._DayFrame:SetSelected(pSelected)
	self.Selected = pSelected
	
	if pSelected then
		self.SelectedTexture:Show()
	elseif not self.IsFlashing then
		self.SelectedTexture:Hide()
	end
end

function GuildCalendarEvent._DayFrame:StartFlashing()
	if self.IsFlashing then
		return
	end
	
	self.IsFlashing = true
	
	if not self.FlashAnimationGroup then
		self.FlashAnimationGroup = self.SelectedTexture:CreateAnimationGroup()
		local fadeIn = self.FlashAnimationGroup:CreateAnimation("Alpha")
		fadeIn:SetDuration(0.5)
		fadeIn:SetFromAlpha(0)
		fadeIn:SetToAlpha(1)
		fadeIn:SetOrder(1)
		fadeIn:SetEndDelay(0.4)
		
		local fadeOut = self.FlashAnimationGroup:CreateAnimation("Alpha")
		fadeOut:SetDuration(0.5)
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetOrder(2)
		fadeOut:SetEndDelay(0.2)
		
		self.FlashAnimationGroup:SetLooping("REPEAT")
	end
	
	self.SelectedTexture:Show()
	self.FlashAnimationGroup:Play()
end

function GuildCalendarEvent._DayFrame:StopFlashing()
	if not self.IsFlashing then
		return
	end
	
	self.IsFlashing = false
	self.FlashAnimationGroup:Stop()
	self.SelectedTexture:SetAlpha(0.5)
	
	if self.Selected then
		self.SelectedTexture:Show()
	else
		self.SelectedTexture:Hide()
	end
end

----------------------------------------
GuildCalendarEvent._DayFrameEvent = {}
----------------------------------------

GuildCalendarEvent._DayFrameEvent.Height = 20

function GuildCalendarEvent._DayFrameEvent:New()
	return CreateFrame("Button", nil, UIParent)
end

function GuildCalendarEvent._DayFrameEvent:Construct()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self:SetHeight(self.Height)
	
	self.Title = self:CreateFontString(nil, "OVERLAY", "GC5FontMonthView")
	self.Title:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	self.Title:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -10)
	self.Title:SetHeight(10)
	self.Title:SetJustifyH("LEFT")
	
	self.Time = self:CreateFontString(nil, "OVERLAY", "GC5FontMonthView")
	self.Time:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT", 0, 0)
	self.Time:SetPoint("BOTTOMRIGHT", self.Title, "BOTTOMRIGHT", 0, -10)
	self.Time:SetHeight(10)
	self.Time:SetJustifyH("LEFT")
	
	self.Highlight = self:CreateTexture(nil, "HIGHLIGHT")
	self.Highlight:SetAllPoints()
	self.Highlight:SetTexture("Interface\\HelpFrame\\HelpFrameButton-Highlight")
	self.Highlight:SetTexCoord(0, 1, 0, 0.578125)
	self.Highlight:SetBlendMode("ADD")
	
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnClick", self.OnClick)
	
	self:EnableMouse(true)
end

function GuildCalendarEvent._DayFrameEvent:SetDayFrame(pDayFrame, pEventLevel, pHasMore)
	self.DayFrame = pDayFrame
	
	self:SetParent(pDayFrame.ForegroundFrame)
	self:SetFrameLevel(pDayFrame.ForegroundFrame:GetFrameLevel() + 20)
	
	self:ClearAllPoints()
	
	local vY = 4 + pEventLevel * self.Height
	
	if pHasMore then
		vY = vY + 8
	end
	
	self:SetPoint("BOTTOMLEFT", pDayFrame, "BOTTOMLEFT", 4, vY)
	self:SetPoint("BOTTOMRIGHT", pDayFrame, "BOTTOMRIGHT", 0, vY)
	
	self:Show()
end

function GuildCalendarEvent._DayFrameEvent:SetEvent(pEvent)
	self.Event = pEvent
	
	local vColor = self.Event:GetEventColor()
	
	self.Title:SetTextColor(vColor.r, vColor.g, vColor.b)
	
	if self.Event:IsAllDayEvent() then
		self.Title:SetText(self.Event.Title)
		self.Time:SetText("")
	else
		local vTime = GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour, self.Event.Minute)
		
		if GuildCalendarEvent.Clock.Data.ShowLocalTime then
			vTime = GuildCalendarEvent.DateLib:GetLocalTimeFromServerTime(vTime)
		end
		
		local vTimeString = GuildCalendarEvent.DateLib:GetShortTimeString(vTime)

		self.Title:SetText(self.Event.Title)
		self.Time:SetText(vTimeString)
	end
end

function GuildCalendarEvent._DayFrameEvent:AddTooltipAttendees(pTitle, pAttendees, pColor)
	if not pAttendees then
		return
	end
	
	local vAttendees = table.concat(pAttendees, ", ")
	
	GameTooltip:AddLine(pTitle..": "..vAttendees, pColor.r, pColor.g, pColor.b, 1)
end

function GuildCalendarEvent._DayFrameEvent:OnEnter()
	local vTimeString = GuildCalendarEvent.DateLib:GetShortTimeString(GuildCalendarEvent.DateLib:ConvertHMToTime(self.Event.Hour, self.Event.Minute))
	
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.Event.Title, vTimeString)
	GameTooltip:AddLine(self.Event.Description, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
	
	local vAttendeesByStatus = {}
	
	if self.Event.Attendance then
		for vName, vInfo in pairs(self.Event.Attendance) do
			local vInviteStatus = vInfo.InviteStatus
			
			-- Put "Signed up" people with "Accepted" people
			
			if vInviteStatus == CALENDAR_INVITESTATUS_SIGNEDUP then
				vInviteStatus = CALENDAR_INVITESTATUS_ACCEPTED
			end
			
			if not vAttendeesByStatus[vInfo.InviteStatus] then
				vAttendeesByStatus[vInfo.InviteStatus] = {}
			end
			
			table.insert(vAttendeesByStatus[vInfo.InviteStatus], vName)
		end
	end
	
	for _, vAttendees in pairs(vAttendeesByStatus) do
		table.sort(vAttendees)
	end
	
	self:AddTooltipAttendees(CALENDAR_STATUS_CONFIRMED, vAttendeesByStatus[CALENDAR_INVITESTATUS_CONFIRMED], GREEN_FONT_COLOR)
	self:AddTooltipAttendees(CALENDAR_STATUS_STANDBY, vAttendeesByStatus[CALENDAR_INVITESTATUS_STANDBY], {r=0.5,g=0.5,b=1})
	self:AddTooltipAttendees(CALENDAR_STATUS_ACCEPTED, vAttendeesByStatus[CALENDAR_INVITESTATUS_ACCEPTED], NORMAL_FONT_COLOR)
	self:AddTooltipAttendees(CALENDAR_STATUS_TENTATIVE, vAttendeesByStatus[CALENDAR_INVITESTATUS_TENTATIVE], YELLOW_FONT_COLOR)
	self:AddTooltipAttendees(CALENDAR_STATUS_DECLINED, vAttendeesByStatus[CALENDAR_INVITESTATUS_DECLINED], RED_FONT_COLOR)
	self:AddTooltipAttendees(CALENDAR_STATUS_OUT, vAttendeesByStatus[CALENDAR_INVITESTATUS_OUT], RED_FONT_COLOR)
	
	GameTooltip:Show()
end

function GuildCalendarEvent._DayFrameEvent:OnLeave()
	GameTooltip:Hide()
end

function GuildCalendarEvent._DayFrameEvent:OnClick(pButton)
	if pButton == "RightButton" then
		self.DayFrame:GetParent().EventMenu:Toggle(self.DayFrame.Month, self.DayFrame.Day, self.DayFrame.Year, self.Event)
	else
		GuildCalendarEvent.UI.Window:ShowEventSidebar(self.Event)
	end
end

----------------------------------------
GuildCalendarEvent.DayFrameEventPool = {}
----------------------------------------

GuildCalendarEvent.DayFrameEventPool.Frames = {}

function GuildCalendarEvent.DayFrameEventPool:GetFrame()
	local vFrame = table.remove(self.Frames)
	
	if not vFrame then
		vFrame = GuildCalendarEvent:New(GuildCalendarEvent._DayFrameEvent)
	end
	
	return vFrame
end

function GuildCalendarEvent.DayFrameEventPool:ReleaseFrame(pFrame)
	pFrame:Hide()
	pFrame:SetParent(UIParent)
	
	table.insert(self.Frames, pFrame)
end

----------------------------------------
GuildCalendarEvent.UI._MonthViewOptions = {}
----------------------------------------

function GuildCalendarEvent.UI._MonthViewOptions:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._MonthViewOptions:Construct(pParent)
	self:SetWidth(210)
	self:SetHeight(60)
	
	self.UseServerTimeCheckbox = GuildCalendarEvent:New(GuildCalendarEvent.UIElementsLib._CheckButton, self, GuildCalendarEvent.cUseServerDateTime)
	self.UseServerTimeCheckbox:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -10)
	self.UseServerTimeCheckbox.Title:SetWidth(175)
	self.UseServerTimeCheckbox:SetScript("OnClick", function (pCheckButton)
		GuildCalendarEvent.Clock.Data.ShowLocalTime = not pCheckButton:GetChecked()
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_PREFS_CHANGED")
	end)
	
	--[[
	self.ShowCalendarLabel = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	self.ShowCalendarLabel:SetPoint("TOP", self.UseServerTimeCheckbox.Title, "BOTTOM", 0, -13)
	self.ShowCalendarLabel:SetPoint("LEFT", self.UseServerTimeCheckbox, "LEFT", 10, 0)
	self.ShowCalendarLabel:SetText(GuildCalendarEvent.cShowCalendarLabel)
	]]
	self.ShowDarkmoonCalendar = GuildCalendarEvent:New(GuildCalendarEvent._EventFilterButton, self, "Interface\\Calendar\\Holidays\\Calendar_DarkmoonFaireTerokkarStart")
	self.ShowDarkmoonCalendar.NormalTexture:SetTexCoord(0, 0.7109375, 0, 0.7109375)
	self.ShowDarkmoonCalendar:SetPoint("TOPLEFT", self.UseServerTimeCheckbox, "BOTTOMLEFT", 0, -13)
	self.ShowDarkmoonCalendar.OnClick = function (pCheckButton, pMouseButton) self:SetShowDarkmoonCalendar(pCheckButton:GetChecked()) end
	self.ShowDarkmoonCalendar.NewbieTooltipTitle = CALENDAR_FILTER_DARKMOON
	self.ShowDarkmoonCalendar.NewbieTooltipDescription = GuildCalendarEvent.cShowDarkmoonCalendarDescription
	
	self.ShowWeeklyCalendar = GuildCalendarEvent:New(GuildCalendarEvent._EventFilterButton, self, "Interface\\Calendar\\Holidays\\Calendar_FishingExtravaganza")
	self.ShowWeeklyCalendar.NormalTexture:SetTexCoord(0, 0.7109375, 0, 0.7109375)
	self.ShowWeeklyCalendar:SetPoint("LEFT", self.ShowDarkmoonCalendar, "RIGHT", 6, 0)
	self.ShowWeeklyCalendar.OnClick = function (pCheckButton, pMouseButton) self:SetShowWeeklyCalendar(pCheckButton:GetChecked()) end
	self.ShowWeeklyCalendar.NewbieTooltipTitle = CALENDAR_FILTER_WEEKLY_HOLIDAYS
	self.ShowWeeklyCalendar.NewbieTooltipDescription = GuildCalendarEvent.cShowWeeklyCalendarDescription
	
	self.ShowPvPCalendar = GuildCalendarEvent:New(GuildCalendarEvent._EventFilterButton, self, "Interface\\Icons\\Ability_Hunter_RapidKilling")
	self.ShowPvPCalendar:SetPoint("LEFT", self.ShowWeeklyCalendar, "RIGHT", 6, 0)
	self.ShowPvPCalendar.OnClick = function (pCheckButton, pMouseButton) self:SetShowPvPCalendar(pCheckButton:GetChecked()) end
	self.ShowPvPCalendar.NewbieTooltipTitle = CALENDAR_FILTER_BATTLEGROUND
	self.ShowPvPCalendar.NewbieTooltipDescription = GuildCalendarEvent.cShowPvPCalendarDescription
	
	self.ShowLockoutCalendar = GuildCalendarEvent:New(GuildCalendarEvent._EventFilterButton, self, "Interface\\Icons\\INV_Misc_Key_03")
	self.ShowLockoutCalendar:SetPoint("LEFT", self.ShowPvPCalendar, "RIGHT", 6, 0)
	self.ShowLockoutCalendar.OnClick = function (pCheckButton, pMouseButton) self:SetShowLockoutCalendar(pCheckButton:GetChecked()) end
	self.ShowLockoutCalendar.NewbieTooltipTitle = CALENDAR_FILTER_RAID_LOCKOUTS
	self.ShowLockoutCalendar.NewbieTooltipDescription = GuildCalendarEvent.cShowLockoutCalendarDescription
	
	self.ShowAltsCalendar = GuildCalendarEvent:New(GuildCalendarEvent._EventFilterButton, self, "Interface\\Icons\\INV_Misc_Head_Dwarf_02")
	self.ShowAltsCalendar:SetPoint("LEFT", self.ShowLockoutCalendar, "RIGHT", 6, 0)
	self.ShowAltsCalendar.OnClick = function (pCheckButton, pMouseButton) self:SetShowAltsCalendar(pCheckButton:GetChecked()) end
	self.ShowAltsCalendar.NewbieTooltipTitle = GuildCalendarEvent.cShowAlts
	self.ShowAltsCalendar.NewbieTooltipDescription = GuildCalendarEvent.cShowAltsDescription
	
	self:SetScript("OnShow", self.OnShow)
end

function GuildCalendarEvent.UI._MonthViewOptions:OnShow()
	self.UseServerTimeCheckbox:SetChecked(not GuildCalendarEvent.Clock.Data.ShowLocalTime)
	self.ShowDarkmoonCalendar:SetChecked(GetCVarBool("calendarShowDarkmoon"))
	self.ShowWeeklyCalendar:SetChecked(GetCVarBool("calendarShowWeeklyHolidays"))
	self.ShowPvPCalendar:SetChecked(GetCVarBool("calendarShowBattlegrounds"))
	self.ShowLockoutCalendar:SetChecked(GuildCalendarEvent.PlayerData.Prefs.ShowLockouts)
	self.ShowAltsCalendar:SetChecked(GuildCalendarEvent.PlayerData.Prefs.ShowAlts)
end

function GuildCalendarEvent.UI._MonthViewOptions:SetShowAltsCalendar(pShow)
	GuildCalendarEvent.PlayerData.Prefs.ShowAlts = pShow
	self.ShowAltsCalendar:SetChecked(pShow)
	GuildCalendarEvent.EventLib:DispatchEvent("GC5_PREFS_CHANGED")
end

function GuildCalendarEvent.UI._MonthViewOptions:SetShowLockoutCalendar(pShow)
	GuildCalendarEvent.PlayerData.Prefs.ShowLockouts = pShow
	self.ShowLockoutCalendar:SetChecked(pShow)
	GuildCalendarEvent.EventLib:DispatchEvent("GC5_PREFS_CHANGED")
end

function GuildCalendarEvent.UI._MonthViewOptions:SetShowPvPCalendar(pShow)
	SetCVar("calendarShowBattlegrounds", pShow and "1" or "0")
	
	self.ShowPvPCalendar:SetChecked(pShow)
	
	self:GetParent():BlizzardCalendarChanged()
end

function GuildCalendarEvent.UI._MonthViewOptions:SetShowWeeklyCalendar(pShow)
	SetCVar("calendarShowWeeklyHolidays", pShow and "1" or "0")
	
	self.ShowWeeklyCalendar:SetChecked(pShow)
	
	self:GetParent():BlizzardCalendarChanged()
end

function GuildCalendarEvent.UI._MonthViewOptions:SetShowDarkmoonCalendar(pShow)
	SetCVar("calendarShowDarkmoon", pShow and "1" or "0")
	
	self.ShowDarkmoonCalendar:SetChecked(pShow)
	
	self:GetParent():BlizzardCalendarChanged()
end

----------------------------------------
GuildCalendarEvent._EventFilterButton = {}
----------------------------------------

function GuildCalendarEvent._EventFilterButton:New(pParent, pIconTexture)
	return CreateFrame("CheckButton", nil, pParent)
end

function GuildCalendarEvent._EventFilterButton:Construct(pParent, pIconTexture)
	self:SetWidth(26)
	self:SetHeight(26)
	
	if pIconTexture then
		self.NormalTexture = self:CreateTexture(nil, "BACKGROUND")
		self.NormalTexture:SetTexture(pIconTexture)
		self.NormalTexture:SetAllPoints()
	end
	
	self:SetCheckedTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\DateButtonHighlight")
	self:GetCheckedTexture():SetVertexColor(0.2, 0.8, 0.2)
	
	self:SetHighlightTexture(GuildCalendarEvent.UI.AddonPath.."Textures\\DateButtonHighlight")
	self:GetHighlightTexture():SetBlendMode("ADD")
	
	self:SetScript("OnClick", self._OnClick)
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
end

function GuildCalendarEvent._EventFilterButton:_OnClick(...)
	if self:GetChecked() then
		PlaySound("856")
	else
		PlaySound("857")
	end
	
	if self.OnClick then
		self:OnClick(...)
	end
end

function GuildCalendarEvent._EventFilterButton:OnEnter()
	if self.NewbieTooltipTitle then
		GuildCalendarEvent:ShowTooltip(self, self.NewbieTooltipTitle, self.NewbieTooltipDescription)
	end
end

function GuildCalendarEvent._EventFilterButton:OnLeave()
	GuildCalendarEvent:HideTooltip()
end

----------------------------------------
GuildCalendarEvent._DayContextMenu = {}
----------------------------------------

function GuildCalendarEvent._DayContextMenu:New(pParent)
	return GuildCalendarEvent.UIElementsLib._ContextMenu:New(pParent)
end

function GuildCalendarEvent._DayContextMenu:Construct(pParent)
	self:Inherit(GuildCalendarEvent.UIElementsLib._ContextMenu, pParent)
end

function GuildCalendarEvent._DayContextMenu:Toggle(pMonth, pDay, pYear)
	self.Month, self.Day, self.Year = pMonth, pDay, pYear
	
	self:ToggleMenu()
end

function GuildCalendarEvent._DayContextMenu:InitMenu(pLevel, pMenuList)
	if not self.Month then
		return
	end
	
	self:AddCategoryItem(GuildCalendarEvent.DateLib:GetLongDateString(GuildCalendarEvent.DateLib:ConvertMDYToDate(self.Month, self.Day, self.Year), true))
	
	self:AddNormalItem(CALENDAR_CREATE_EVENT, "PLAYER")
	if CanEditGuildEvent() then
		self:AddNormalItem(CALENDAR_CREATE_GUILD_EVENT, "GUILD_EVENT")
		self:AddNormalItem(CALENDAR_CREATE_GUILD_ANNOUNCEMENT, "GUILD_ANNOUNCEMENT")
	end
	
	local vCanCreate = GuildCalendarEvent:CanCreateEventOnDate(self.Month, self.Day, self.Year)
	local vCanPaste = vCanCreate and GuildCalendarEvent.WoWCalendar:CalendarContextEventClipboard()
	
	if vCanCreate and vCanPaste then
		self:AddDivider()
		self:AddNormalItem(CALENDAR_PASTE_EVENT, "PASTE")
	end
end

function GuildCalendarEvent._DayContextMenu:ItemClicked(pValue)
	if pValue == "PLAYER"
	or pValue == "GUILD_EVENT"
	or pValue == "GUILD_ANNOUNCEMENT" then
		GuildCalendarEvent.UI.Window:OpenNewEvent(self.Month, self.Day, self.Year, pValue)
	elseif pValue == "PASTE" then
		GuildCalendarEvent.WoWCalendar:CalendarContextEventPaste(GuildCalendarEvent.WoWCalendar:CalendarGetMonthOffset(self.Month, self.Year), self.Day);
	end
end

----------------------------------------
GuildCalendarEvent._EventContextMenu = {}
----------------------------------------

function GuildCalendarEvent._EventContextMenu:New(pParent)
	return GuildCalendarEvent._DayContextMenu:New(pParent)
end

function GuildCalendarEvent._EventContextMenu:Construct(pParent)
	self:Inherit(GuildCalendarEvent._DayContextMenu, pParent)
end

function GuildCalendarEvent._EventContextMenu:Toggle(pMonth, pDay, pYear, pEvent)
	self.Event = pEvent
	self.Inherited.Toggle(self, pMonth, pDay, pYear)
end

function GuildCalendarEvent._EventContextMenu:AddTitleDivider()
	if not self.AddedTitle then
		self:AddCategoryItem(self.Event.Title)
		self.AddedTitle = true
	else
		self:AddDivider()
	end
end

function GuildCalendarEvent._EventContextMenu:InitMenu(pLevel, pMenuList)
	if not self.Event then
		return
	end
	
	self.Inherited.InitMenu(self, pLevel, pMenuList)
	
	self.AddedTitle = false
	
	-- Add editing items
	
	if self.Event:CanEdit() then
		self:AddTitleDivider()
		self:AddNormalItem(CALENDAR_COPY_EVENT, "COPY")
		self:AddNormalItem(CALENDAR_DELETE_EVENT, "DELETE")
	end
	
	-- Add response items

	if self.Event.CalendarType ~= "GUILD_ANNOUNCEMENT" then
		if self.Event:CanRSVP() then
			self:AddTitleDivider()

			local vAttending = GuildCalendarEvent.UI._EventViewer.cStatusAttending[self.Event.InviteStatus]
			
			self:AddNormalItem(GuildCalendarEvent.cYes:format(self.Event.OwnersName), "YES", nil, vAttending == "Y", self.Event.ModStatus == "CREATOR")
			self:AddNormalItem(GuildCalendarEvent.cMaybe, "MAYBE", nil, vAttending == "?", self.Event.ModStatus == "CREATOR")
			self:AddNormalItem(GuildCalendarEvent.cNo:format(self.Event.OwnersName), "NO", nil, vAttending == "N", self.Event.ModStatus == "CREATOR")
		end
		
		if self.Event:CanRemove() then
			self:AddTitleDivider()
			self:AddNormalItem(CALENDAR_REMOVE_INVITATION, "REMOVE")
		end
		
		if self.Event:CanComplain() then
			self:AddTitleDivider()
			self:AddNormalItem(REPORT_SPAM, "REPORT")
		end
	end
end

function GuildCalendarEvent._EventContextMenu:ItemClicked(pValue)
	if pValue == "COPY" then
		self.Event:Copy()
	elseif pValue == "DELETE" then
		if self.Event then
			GuildCalendarEvent.UI:ShowConfirmDeleteEvent(function ()
				self.Event:Delete()
			end)
		else
			self.Event:Delete()
		end
	elseif pValue == "YES" then
		self.Event:SetConfirmedStatus()
	elseif pValue == "MAYBE" then
		self.Event:SetTentativeStatus()
	elseif pValue == "NO" then
		self.Event:SetDeclinedStatus()
	elseif pValue == "REMOVE" then
		self.Event:Remove()
	elseif pValue == "REPORT" then
		self.Event:Complain()
	else
		self.Inherited.ItemClicked(self, pValue)
	end
end
