local gAddonName = ...

GuildCalendarEventClock_Data = nil

if not GuildCalendarEvent.cHelpClock then
	GuildCalendarEvent.cHelpClock = "Sets the minimap clock to display local time or server time"
end

function GuildCalendarEvent.Clock:Initialize()
	if not GuildCalendarEventClock_Data then
		GuildCalendarEventClock_Data =
		{
			ShowLocalTime = false,
			HideMinimapClock = false
		}
	end
	
	self.Data = GuildCalendarEventClock_Data
	
	self.Frame = GuildCalendarEvent:New(GuildCalendarEvent._Clock, 40, GameTimeFrame, -1, 1, true, true)
	self.Frame:SetShowLocalTime(self.Data.ShowLocalTime)
	if self.Data.HideMinimapClock then
		self.Frame:Hide()
	end
end

function GuildCalendarEvent.Clock:PrefsChanged()
	if self.Data.HideMinimapClock then
		self.Frame:Hide()
	else
		self.Frame:Show()
	end
end

function GuildCalendarEvent:HookScript(pFrame, pScriptID, pFunction)
	if not pFrame:GetScript(pScriptID) then
		pFrame:SetScript(pScriptID, pFunction)
	else
		pFrame:HookScript(pScriptID, pFunction)
	end
end

----------------------------------------
-- /cal
----------------------------------------

if not GuildCalendarEvent.InstallSlashCommand then
	function GuildCalendarEvent:InstallSlashCommand()
		SlashCmdList.CAL = function (...) GuildCalendarEvent:ExecuteCommand(...) end
		SLASH_CAL1 = "/cal"
	end

	function GuildCalendarEvent:ExecuteCommand(pCommandString, ...)
		local _, _, vCommand, vParameter = string.find(pCommandString, "([^%s]+) ?(.*)")
		local vCommandFunc = self.Commands[strlower(vCommand or "help")] or self.Commands.help
		
		vCommandFunc(self, vParameter)
	end
	
	GuildCalendarEvent.CommandHelp = {}
	GuildCalendarEvent.Commands = {}
end

if GuildCalendarEvent.EventLib then
	GuildCalendarEvent.EventLib:RegisterEvent("GuildCalendarEvent_INIT", function () GuildCalendarEvent.Clock:Initialize() end)
	GuildCalendarEvent.EventLib:RegisterEvent("GC5_PREFS_CHANGED", GuildCalendarEvent.Clock.PrefsChanged, GuildCalendarEvent.Clock)
else
	GuildCalendarEvent:HookScript(GameTimeFrame, "OnEvent", function (pFrame, pEventID, pAddonName) if pEventID == "ADDON_LOADED" and pAddonName == gAddonName then GuildCalendarEvent.Clock:Initialize() end end)
	GameTimeFrame:RegisterEvent("ADDON_LOADED")
end

----------------------------------------
-- Commands
----------------------------------------

table.insert(GuildCalendarEvent.CommandHelp, HIGHLIGHT_FONT_COLOR_CODE.."/cal clock [local|server]"..NORMAL_FONT_COLOR_CODE.." "..GuildCalendarEvent.cHelpClock)

function GuildCalendarEvent.Commands:clock(pParam)
	local vParam = pParam:lower()
	
	if vParam == "local" then
		self.Clock.Data.ShowLocalTime = true
	elseif vParam == "server" then
		self.Clock.Data.ShowLocalTime = false
	elseif vParam == "on" then
		self.Clock.Data.HideMinimapClock = false
	elseif vParam == "off" then
		self.Clock.Data.HideMinimapClock = true
	end
	
	if GuildCalendarEvent.EventLib then
		GuildCalendarEvent.EventLib:DispatchEvent("GC5_PREFS_CHANGED")
	end
end
