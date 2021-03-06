----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

function GuildCalendarEvent:InitializeRealm()
	self.RealmName = GetRealmName()
	self.RealmData = self.Data.Realms[self.RealmName]
	
	if not self.RealmData then
		self.RealmData =
		{
			Name = self.RealmName,
			Prefs = {},
			Guilds = {},
			Characters = {},
			DefaultRoles = {},
		}
		
		self.Data.Realms[self.RealmName] = self.RealmData
	end
	
	-- Attach the guild roster to the realm and
	-- activate the other rosters
	
	if IsInGuild() then
		local vPlayerGuild = GetGuildInfo("player")
		
		if vPlayerGuild then
			self.RealmData.Guilds[vPlayerGuild] = self.GuildLib.Roster
		end
	end
	
	for vGuildName, vGuildRoster in pairs(self.RealmData.Guilds) do
		if vGuildName ~= vPlayerGuild then
			self.GuildLib:ActivateRosterData(vGuildRoster)
		end
	end
end

function GuildCalendarEvent:InitializeCharacter()
	local _
	self.PlayerName = UnitName("player")
	self.PlayerGUID = UnitGUID("player")
	self.PlayerData = self.RealmData.Characters[self.PlayerGUID]
	self.PlayerGuild, _, self.PlayerGuildRank = GetGuildInfo("player")
	
	if not self.PlayerData then
		self.PlayerData =
		{
			Name = self.PlayerName,
			Faction = UnitFactionGroup("player"),
			Prefs = {},
			Events = {},
			GUID = self.PlayerGUID,
			EventTemplates = {},
			Guild = self.PlayerGuild,
			GuildRank = self.PlayerGuildRank,
		}
		
		self.RealmData.Characters[self.PlayerGUID] = self.PlayerData
	end
	
	self.PlayerData.Name = self.PlayerName
	
	self.PlayerData.Guild = self.PlayerGuild
	self.PlayerData.GuildRank = self.PlayerGuildRank
	
	if self.PlayerGuild then
		self.RealmData.Guilds[self.PlayerGuild] = self.GuildLib.Roster
	end
	
	GuildCalendarEvent.EventLib:RegisterEvent(
		"PLAYER_GUILD_UPDATE",
		function (...)
			local vGuild, _, vRank = GetGuildInfo("player")
			
			if vGuild ~= self.PlayerGuild
			or vRank ~= self.PlayerGuildRank then
				self.PlayerGuild = vGuild
				self.PlayerGuildRank = vRank
				
				self.PlayerData.Guild = vGuild
				self.PlayerData.GuildRank = vRank
				
				GuildCalendarEvent.EventLib:DispatchEvent("GC5_GUILD_CHANGED")
				
				if self.PlayerGuild then
					local vRoster = GuildCalendarEvent.RealmData.Guilds[self.PlayerGuild]
					
					self.GuildLib.Roster = vRoster or self.GuildLib:NewRosterData(self.PlayerGuild)
					self.GuildLib.Roster:Synchronize()
					
					self.RealmData.Guilds[self.PlayerGuild] = self.GuildLib.Roster
				end
			end
		end
	)
	
	if GuildCalendarEvent.Data.TwentyFourHourTime ~= nil then
		SetCVar("timeMgrUseMilitaryTime", GuildCalendarEvent.Data.TwentyFourHourTime and 1 or 0)
	end
	
	-- Run CleanUpRosters in case this player's guild changed
	-- and the old one is no longer needed
	
	GuildCalendarEvent:CleanUpRosters()
end

function GuildCalendarEvent:CleanUpRosters()
	for vGuildName, vRoster in pairs(self.RealmData.Guilds) do
		if not self:RosterInUse(vGuildName) then
			self.RealmData.Guilds[vGuildName] = nil
		end
	end
end

function GuildCalendarEvent:RosterInUse(pGuildName)
	for vPlayerGUID, vPlayerData in pairs(self.RealmData.Characters) do
		-- Return true if its one of our own character's guilds
		
		if vPlayerData.Guild == pGuildName then
			return true
		end
		
		-- Return true if it's a partnered guild
		
		if vPlayerData.PartnerConfigs then
			local _
			for _, vPartnerConfig in ipairs(vPlayerData.PartnerConfigs) do
				if vPartnerConfig.GuildName == pGuildName then
					return true
				end
			end
		end
	end
	
	-- Not used
	
	return false
end