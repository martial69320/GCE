----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent._RaidInvites = {}
----------------------------------------

function GuildCalendarEvent._RaidInvites:Construct()
	self.IsRaid = false
	self.Status = nil
	self.Inviting = false
	self.MaxInvitesPerTimeSlice = 1
	self.InvitationSliceInterval = 0.2
	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", function (...) return self:WhisperEventFilter(...) end)
end

GuildCalendarEvent.cWhisperPrefixLen = GuildCalendarEvent.cWhisperPrefix:len()

function GuildCalendarEvent._RaidInvites:WhisperEventFilter(pChatFrame, pEvent, pMessage, ...)
	if GuildCalendarEvent.Debug.raidinvites then
		return false
	end
	
	return pMessage:sub(1, GuildCalendarEvent.cWhisperPrefixLen) == GuildCalendarEvent.cWhisperPrefix
end

function GuildCalendarEvent._RaidInvites:BeginInvites(pEventTitle, pIsRaid, pNotifyFunc)
	self.EventTitle = pEventTitle
	self.IsRaid = pIsRaid
	self.NotifyFunc = pNotifyFunc
	self.PlayerQueue = {}
	self.NumInvited = 0
	self.WaitForRaid = false
	
	GuildCalendarEvent.EventLib:RegisterEvent("CHAT_MSG_SYSTEM", self.ChatMsgSystem, self)
	
	self:SetStatus("READY")
end

function GuildCalendarEvent._RaidInvites:EndInvites()
	GuildCalendarEvent.EventLib:UnregisterEvent("CHAT_MSG_SYSTEM", self.ChatMsgSystem, self)
end

function GuildCalendarEvent._RaidInvites:InvitePlayer(pPlayerName)
	table.insert(self.PlayerQueue, pPlayerName)
	
	if not self.Inviting then
		self.Inviting = true
		GuildCalendarEvent.SchedulerLib:ScheduleUniqueRepeatingTask(0.25, self.Update, self)
	end
end

function GuildCalendarEvent._RaidInvites:RemovePlayer(pPlayerName)
	for vIndex, vPlayerName in ipairs(self.PlayerQueue) do
		if vPlayerName == pPlayerName then
			table.remove(self.PlayerQueue, vIndex)
			if vIndex <= self.NumInvited then
				self.NumInvited = self.NumInvited - 1
			end
			return
		end
	end
end

function GuildCalendarEvent._RaidInvites:SetStatus(pStatus)
	self.NotifyFunc("STATUS", pStatus)
end

function GuildCalendarEvent._RaidInvites:SetPlayerStatus(pPlayerName, pStatus)
	self.NotifyFunc("PLAYER", pPlayerName, pStatus)
end

function GuildCalendarEvent._RaidInvites:Update(pElapsed)
	if not self.Inviting then
		GuildCalendarEvent.SchedulerLib:UnscheduleTask(self.Update, self)
		return
	end
	
	self:InviteNow()
end

function GuildCalendarEvent._RaidInvites:InviteNow()
	if self.WaitForRaid and not IsInRaid() then
		return
	end
	
	if self.WaitForRaid then
		-- Set the raid difficulty
		-- SetRaidDifficulty(#self.PlayerQueue > 10 and 1 or 2)
	end
	
	self.WaitForRaid = false
	
	-- Get the maximum size for the group
	
	local vNumJoined, vMaxPartyMembers
	
	self:SetStatus("INVITING")
	
	if not IsInRaid() then
		-- Adjust the 5-man difficulty if it's a new group
		if GetNumGroupMembers() == 0 then
		end
		
		vMaxPartyMembers = MAX_PARTY_MEMBERS + 1 -- +1 because Blizzard doesn't include the player in the MAX_PARTY_MEMBERS count
		vNumJoined = GetNumGroupMembers()
	else
		vMaxPartyMembers = MAX_RAID_MEMBERS
		vNumJoined = GetNumGroupMembers()
	end
	
	--
	
	if GuildCalendarEvent.Debug.raidinvites then
		GuildCalendarEvent:DebugMessage("Starting invites: MaxPartyMembers: %d", vMaxPartyMembers)
	end
	
	-- Count the number of outstanding invitations
	
	local vNumJoinedOrInvited = self.NumInvited + vNumJoined
	local vNumInvitesSent = 0
	
	for vExcessLooping = 1, 40 do
		-- Don't allow too many invitations in one burst in order to prevent
		-- Blizzard's spammer filters from kicking us offline
		
		if vNumInvitesSent >= self.MaxInvitesPerTimeSlice then
			if GuildCalendarEvent.Debug.raidinvites then
				GuildCalendarEvent:DebugMessage("Maximum invites per time slice reached")
			end
			
			return
		end
		
		if GuildCalendarEvent.Debug.raidinvites then
			GuildCalendarEvent:DebugMessage("NumJoinedOrInvited: %d", vNumJoinedOrInvited)
		end
		
		-- Done if there are no more players to add
		
		if self.NumInvited >= #self.PlayerQueue then
			self:SetStatus("COMPLETE")
			self.Inviting = false
			
			if GuildCalendarEvent.Debug.raidinvites then
				GuildCalendarEvent:DebugMessage("No more players to invite")
			end
			
			return
		end
		
		if vNumJoinedOrInvited >= vMaxPartyMembers then
			-- Convert to raid if needed and at least one person has accepted
			
			if self.IsRaid
			and not IsInRaid() then
				if GetNumGroupMembers() > 0 then
					if GuildCalendarEvent.Debug.raidinvites then
						GuildCalendarEvent:DebugMessage("Converting to raid")
					end
					self:SetStatus("CONVERTING")
					ConvertToRaid()
					self.WaitForRaid = true
					return
				else
					if GuildCalendarEvent.Debug.raidinvites then
						GuildCalendarEvent:DebugMessage("Waiting for players to accept")
					end
					self:SetStatus("WAITING")
					return
				end
			end
			
			-- Otherwise we're full
			
			if GuildCalendarEvent.Debug.raidinvites then
				GuildCalendarEvent:DebugMessage("Group is full")
			end
			self:SetStatus("FULL")
			return
		end
		
		-- Get the next player to invite
		
		local vInviteIndex = self.NumInvited + 1
		local vPlayerName = self.PlayerQueue[vInviteIndex]
		
		-- Invite the player
		
		if GuildCalendarEvent.Debug.raidinvites then
			GuildCalendarEvent:DebugMessage("Inviting "..vPlayerName)
		end
		
		SendChatMessage(
				GuildCalendarEvent.cInviteWhisperFormat:format(GuildCalendarEvent.cWhisperPrefix, self.EventTitle),
				"WHISPER",
				nil,
				vPlayerName)
		
		-- UninviteUnit(vPlayerName) -- This helps clean up Blizzard's internal state when it fails during invites
		InviteUnit(vPlayerName)
		
		self:SetPlayerStatus(vPlayerName, "INVITED")
		
		self.NumInvited = self.NumInvited + 1
		vNumInvitesSent = vNumInvitesSent + 1
		vNumJoinedOrInvited = vNumJoinedOrInvited + 1
	end -- for
	
	GuildCalendarEvent:ErrorMessage("Internal Error: InviteNow() not terminating properly")
end

GuildCalendarEvent.cAlreadyGroupedSysMsg = GuildCalendarEvent:ConvertFormatStringToSearchPattern(ERR_ALREADY_IN_GROUP_S)
GuildCalendarEvent.cInviteDeclinedSysMsg = GuildCalendarEvent:ConvertFormatStringToSearchPattern(ERR_DECLINE_GROUP_S)
GuildCalendarEvent.cNoSuchPlayerSysMsg = GuildCalendarEvent:ConvertFormatStringToSearchPattern(ERR_CHAT_PLAYER_NOT_FOUND_S)
GuildCalendarEvent.cJoinedGroupSysMsg = GuildCalendarEvent:ConvertFormatStringToSearchPattern(ERR_JOINED_GROUP_S)

function GuildCalendarEvent._RaidInvites:ChatMsgSystem(pEventID, pMessage)
	-- See if someone joined
	
	local _, _, vName = pMessage:find(GuildCalendarEvent.cJoinedGroupSysMsg)
	
	if vName then
		self:SetPlayerStatus(vName, "JOINED")
		self:RemovePlayer(vName)
		return
	end
	
	-- See if someone declined an invitation
	
	local _, _, vName = pMessage:find(GuildCalendarEvent.cInviteDeclinedSysMsg)
	
	if vName then
		self:SetPlayerStatus(vName, "DECLINED")
		self:RemovePlayer(vName)
		return
	end
	
	-- See if they are already in a group
	
	_, _, vName = pMessage:find(GuildCalendarEvent.cAlreadyGroupedSysMsg)
	
	if vName then
		self:SetPlayerStatus(vName, "BUSY")
		self:RemovePlayer(vName)
		return
	end
	
	-- See if they're not online
	
	_, _, vName = pMessage:find(GuildCalendarEvent.cNoSuchPlayerSysMsg)
	
	if vName then
		self:SetPlayerStatus(vName, "OFFLINE")
		self:RemovePlayer(vName)
		return
	end
end

----------------------------------------
GuildCalendarEvent._AttendanceList = {}
----------------------------------------

function GuildCalendarEvent._AttendanceList:Construct()
	self.NumCategories = 0
	self.NumPlayers = 0
	self.NumAttendees = 0
	self.Categories = {}
	self.SortedCategories = {}
	self.Items = {}
end

function GuildCalendarEvent._AttendanceList:RemoveCategory(pCategoryID)
	local vClassInfo = self.Categories[pCategoryID]
	
	if not vClassInfo then
		return false
	end
	
	self.NumPlayers = self.NumPlayers - #vClassInfo.Attendees
	self.NumCategories = self.NumCategories - 1
	
	-- Remove it from the sorted categories
	
	for vIndex, vCategoryID in ipairs(self.SortedCategories) do
		if vCategoryID == pCategoryID then
			table.remove(self.SortedCategories, vIndex)
		end
	end

	self.Categories[pCategoryID] = nil
	return true
end

function GuildCalendarEvent._AttendanceList:AddItem(pCategoryID, pItem, pStandby)
	if not pItem then
		error("pItem is nil")
	end
	
	if not pCategoryID then
		error("_pCategoryID is nil")
	end
	
	local vClassInfo = self.Categories[pCategoryID]
	
	if not vClassInfo then
		vClassInfo = {Count = 0, StandbyCount = 0, ClassCode = pCategoryID, Attendees = {}}
		self.Categories[pCategoryID] = vClassInfo
		
		self.NumCategories = self.NumCategories + 1
	end
	
	if pStandby then
		vClassInfo.StandbyCount = vClassInfo.StandbyCount + 1
	else
		-- If this is the first visible entry add the category to the sorted list
		
		if vClassInfo.Count == 0 then
			table.insert(self.SortedCategories, pCategoryID)
		end
		
		--
		
		vClassInfo.Count = vClassInfo.Count + 1
		
		table.insert(vClassInfo.Attendees, pItem)
	end
	
	self.NumPlayers = self.NumPlayers + 1
end

function GuildCalendarEvent._AttendanceList:AddWhisper(pPlayerName, pWhispers)
	local vPlayer =
	{
		mName = pPlayerName,
		mWhispers = pWhispers.Whispers,
	}
	
	local vMemberInfo = GuildCalendarEvent.GuildLib:GetPlayer(pPlayerName)
	
	if vMemberInfo then
		vPlayer.Level = vMemberInfo.Level
		vPlayer.ClassCode = vMemberInfo.ClassID
		vPlayer.Zone = vMemberInfo.Zone
		vPlayer.Online = not MemberInfo.Offline
	end
	
	vPlayer.Date = pWhispers.Date
	vPlayer.Time = pWhispers.Time
	vPlayer.Type = "Whisper"
	
	return self:AddItem("WHISPERS", vPlayer)
end

function GuildCalendarEvent._AttendanceList:AddEventAttendanceItems(pEvent)
	if not pEvent.Attendance then
		return
	end
	
	for vName, vInfo in pairs(pEvent.Attendance) do
		self.Items[vName] = vInfo
	end
end

function GuildCalendarEvent._AttendanceList:FindItem(pFieldName, pFieldValue, pCategoryID)
	if not pFieldValue then
		GuildCalendarEvent:DebugMessage("AttendanceList:FindItem: pFieldValue is nil for "..pFieldName)
		return nil
	end
	
	local vLowerFieldValue = pFieldValue:lower()
	
	-- Search all categories if none is specified
	
	if not pCategoryID then
		for vCategoryID, vCategoryInfo in pairs(self.Categories) do
			for vIndex, vItem in ipairs(vCategoryInfo.Attendees) do
				local vItemFieldValue = vItem[pFieldName]
				
				if vItemFieldValue
				and vItemFieldValue:lower() == vLowerFieldValue then
					return vItem
				end
			end
		end
	
	-- Search the specified category
	
	else
		local vCategoryInfo = self.Categories[pCategoryID]
		
		if not vCategoryInfo then
			return nil
		end
		
		for vIndex, vItem in ipairs(vCategoryInfo.Attendees) do
			if vItem[pFieldName]:lower() == vLowerFieldValue then
				return vItem
			end
		end
	end
	
	return nil
end

function GuildCalendarEvent._AttendanceList:SortIntoCategories(pGetItemCategoryFunction)
	-- Clear the existing categories
	
	self.Categories = {}
	self.SortedCategories = {}
	
	--
	
	local vTotalAttendees = 0
	local vTotalStandby = 0
	
	for vName, vItem in pairs(self.Items) do
		local vCategoryID, vRealCategoryID = pGetItemCategoryFunction(vItem)
		
		if vCategoryID then -- nil categories are to be ignored (canceled attendance requests)
			if vCategoryID ~= "NO"
			and vCategoryID ~= "BANNED"
			and vCategoryID ~= "MAYBE" then
				vTotalAttendees = vTotalAttendees + 1

				if vCategoryID == "STANDBY" then
					vTotalStandby = vTotalStandby + 1
					
					if vRealCategoryID then
						self:AddItem(vRealCategoryID, vItem, true)
					end
				end
			end
			
			self:AddItem(vCategoryID, vItem)
		end
	end
	
	self.NumAttendees = vTotalAttendees
	self.NumStandby = vTotalStandby
end

