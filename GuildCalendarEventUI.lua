----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

GuildCalendarEvent.UI =
{
	AddonPath = GuildCalendarEvent.AddonPath,
}

function GuildCalendarEvent.UI:ShowConfirmDeleteEvent(pAcceptFunc)
	if not StaticPopupDialogs.GC5_CONFIRM_DELETE_EVENT then
		StaticPopupDialogs.GC5_CONFIRM_DELETE_EVENT =
		{
			preferredIndex = 3,
			text = GuildCalendarEvent.cConfirmDelete,
			button1 = OKAY,
			button2 = CANCEL,
			whileDead = 1,
			OnAccept = function (self) end,
			timeout = 0,
			hideOnEscape = 1,
			enterClicksFirstButton = 1,
		}
	end
	StaticPopupDialogs.GC5_CONFIRM_DELETE_EVENT.OnAccept = pAcceptFunc
	StaticPopup_Show("GC5_CONFIRM_DELETE_EVENT")
end

function GuildCalendarEvent.UI:Initialize()
	self.Window = GuildCalendarEvent:New(GuildCalendarEvent.UI._Window)

	--SlashCmdList.CALENDAR = SlashCmdList.CAL
	--SLASH_CALENDAR1 = "/calendar"
	
	-- Prevent the Blizzard calendar from loading
	
	--function Calendar_LoadUI()
	--	return
	--end
	
	GameTimeFrame:SetScript("OnClick", function (pFrame, pButton, ...)
		if pButton == "RightButton" then
			if IsModifierKeyDown() then
				ToggleTimeManager()
			else
				SlashCmdList.CALENDAR("") -- Issue a fake /calendar command to toggle the Blizzard calendar (handles loading the addon)
			end
		else
			if GuildCalendarEvent.UI.Window:IsShown() then
				GuildCalendarEvent.UI.Window:Hide()
			else
				GuildCalendarEvent.UI.Window:Show()
			end
		end
	end)
	
	--
	
	self.ClassLimitsDialog = GuildCalendarEvent:New(GuildCalendarEvent.UI._ClassLimitsDialog, UIParent)
	self.ClassLimitsDialog:SetPoint("TOP", UIParent, "TOP", 0, -200)
	self.ClassLimitsDialog:Hide()
	
	self.RoleLimitsDialog = GuildCalendarEvent:New(GuildCalendarEvent.UI._RoleLimitsDialog, UIParent)
	self.RoleLimitsDialog:SetPoint("TOP", UIParent, "TOP", 0, -200)
	self.RoleLimitsDialog:Hide()
	
	GuildCalendarEvent.EventLib:RegisterEvent("CALENDAR_UPDATE_ERROR", self.CalendarUpdateError, self, true)
end

function GuildCalendarEvent.UI:CalendarUpdateError(pMessage)
	if not StaticPopupDialogs.CALENDAR_ERROR then
		StaticPopupDialogs.CALENDAR_ERROR =
		{
			preferredIndex = 3,
			text = CALENDAR_ERROR,
			button1 = OKAY,
			whileDead = 1,
			timeout = 0,
			showAlert = 1,
			hideOnEscape = 1,
			enterClicksFirstButton = 1,
		}
	end
	
	StaticPopup_Show("CALENDAR_ERROR", pMessage)
end

table.insert(GuildCalendarEvent.CommandHelp, HIGHLIGHT_FONT_COLOR_CODE.."/cal show"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpShow)

function GuildCalendarEvent.Commands:show()
	ShowUIPanel(self.UI.Window)
end

----------------------------------------
GuildCalendarEvent.Themes = {}
----------------------------------------

GuildCalendarEvent.Themes.PARCHMENT =
{
	Name = GuildCalendarEvent.cParchmentThemeName,
	Background = GuildCalendarEvent.UI.AddonPath.."Textures\\DayFrameBack",
	Foreground = GuildCalendarEvent.UI.AddonPath.."Textures\\DayFrameFront",
	TilesH = 2,
	TilesV = 2,
	RandomTile = true,
	UseShading = true,
	BackgroundBrightness = 1,
}

GuildCalendarEvent.Themes.LIGHT_PARCHMENT =
{
	Name = GuildCalendarEvent.cLightParchmentThemeName,
	Background = GuildCalendarEvent.UI.AddonPath.."Textures\\DayFrameBrightBack",
	Foreground = GuildCalendarEvent.UI.AddonPath.."Textures\\DayFrameFront",
	TilesH = 2,
	TilesV = 2,
	RandomTile = true,
	UseShading = true,
	BackgroundBrightness = 1,
}

GuildCalendarEvent.Themes.SEASONAL =
{
	Name = GuildCalendarEvent.cSeasonalThemeName,
	Background =
	{
		GuildCalendarEvent.UI.AddonPath.."Textures\\CrystalsongColdBackground", -- Jan
		GuildCalendarEvent.UI.AddonPath.."Textures\\GrizzlyHillsBackground", -- Feb
		GuildCalendarEvent.UI.AddonPath.."Textures\\GrizzlemawBackground", -- Mar
		GuildCalendarEvent.UI.AddonPath.."Textures\\NagrandBackground", -- Apr
		GuildCalendarEvent.UI.AddonPath.."Textures\\TeldrassilBackground", -- May
		GuildCalendarEvent.UI.AddonPath.."Textures\\FeralasBackground", -- Jun
		GuildCalendarEvent.UI.AddonPath.."Textures\\SteamwheedleBackground", -- Jul
		GuildCalendarEvent.UI.AddonPath.."Textures\\BarrensBackground", -- Aug
		GuildCalendarEvent.UI.AddonPath.."Textures\\AzsharaBackground", -- Sep
		GuildCalendarEvent.UI.AddonPath.."Textures\\HallowsEnd", -- Oct
		GuildCalendarEvent.UI.AddonPath.."Textures\\CrystalsongBackground", -- Nov
		GuildCalendarEvent.UI.AddonPath.."Textures\\WintergraspBackground", -- Dec
	},
	Foreground = GuildCalendarEvent.UI.AddonPath.."Textures\\DayFrameFront-Square",
	RandomTile = false,
	UseShading = false,
	BackgroundBrightness = 0.3,
}

----------------------------------------
--
----------------------------------------

GuildCalendarEvent.EventLib:RegisterEvent("GuildCalendarEvent_INIT", GuildCalendarEvent.UI.Initialize, GuildCalendarEvent.UI)
