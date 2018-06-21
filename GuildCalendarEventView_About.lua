----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

----------------------------------------
GuildCalendarEvent.UI._AboutView = {}
----------------------------------------

function GuildCalendarEvent.UI._AboutView:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent.UI._AboutView:Construct(pParent)
	self.Title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Title:SetPoint("TOP", self, "TOP", 17, -7)
	self.Title:SetText(GuildCalendarEvent.cAboutTitle:format(GuildCalendarEvent.cVersionString))
	
	self.AuthorText = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.AuthorText:SetPoint("TOP", self, "TOP", 5, -50)
	self.AuthorText:SetWidth(470)
	self.AuthorText:SetJustifyH("CENTER")
	self.AuthorText:SetText(GuildCalendarEvent.cAboutAuthor)
	
	self.CopyrightText = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.CopyrightText:SetPoint("TOP", self.AuthorText, "BOTTOM", 0, -10)
	self.CopyrightText:SetWidth(470)
	self.CopyrightText:SetJustifyH("CENTER")
	self.CopyrightText:SetText(GuildCalendarEvent.cAboutCopyright)
	
	self.ThanksText = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.ThanksText:SetPoint("TOP", self.CopyrightText, "BOTTOM", 0, -20)
	self.ThanksText:SetWidth(470)
	self.ThanksText:SetJustifyH("CENTER")
	self.ThanksText:SetText(GuildCalendarEvent.cAboutThanks)
	
	self.Credits = GuildCalendarEvent:New(GuildCalendarEvent._Credits, self)
	self.Credits:SetPoint("TOP", self.ThanksText, "BOTTOM", 0, -20)
	self.Credits:SetWidth(470)
	self.Credits:SetHeight(300)
end

----------------------------------------
GuildCalendarEvent._Credits = {}
----------------------------------------

-- 0 Friend
-- 1 Tester
-- 2 Localizer
-- 3 Donor

GuildCalendarEvent._Credits.PlayersByRealm =
{
	
	[GuildCalendarEvent.cGermanLocalization] =
	{
		["Palyr"] = 2,
		["Dania"] = 2,
		["OweH"] = 2,
		["AvernaMan"] = 2,
		["Macniel"] = 2,
		["ReiTung"] = 2,
		["Brilhasti\n<Risen>"] = 2,
	},
	[GuildCalendarEvent.cChineseLocalization] =
	{
		["AndyAska"] = 2,
		["Displace"] = 2,
	},
	[GuildCalendarEvent.cFrenchLocalization] =
	{
		["Kisanth"] = 2,
		["Nico806"] = 2,
		["Ekhurr"] = 2,
	},
	[GuildCalendarEvent.cSpanishLocalization] =
	{
		["Marutak"] = 2,
		["Marosth"] = 2,
	},
	[GuildCalendarEvent.cRussianLocalization] =
	{
		["StingerSoft"] = 2,
	},
	[GuildCalendarEvent.cContributingDeveloper] =
	{
		["Dridzt"] = 1,
		["AJ Henderson"] = 1,
		["Aquaflare7"] = 1,
		["Arrath"] = 1,
		["ShadowsBane"] = 1,
		["Ryhawk"] = 1,
		["ObiChad"] = 1,
		["Maqjav"] = 1,
	},
}

function GuildCalendarEvent._Credits:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent._Credits:Construct(pParent)
	self.CreditFrames = {}
	self.AvailableCreditFrames = {}
	
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	self:SetScript("OnUpdate", self.OnUpdate)
	
	-- Compile the list
	
	-- Add everything except the current realm
	
	self.Players = {}
	
	for vRealm, vRealmPlayers in pairs(self.PlayersByRealm) do
		if vRealm ~= GuildCalendarEvent.RealmName then
			for vPlayerName, vPlayerInfo in pairs(vRealmPlayers) do
				if type(vPlayerInfo) == "number" then
					table.insert(self.Players,
					{
						Name = vPlayerName,
						Realm = vRealm,
						Level = vPlayerInfo
					})
				end
			end
		end
	end -- for
	
	-- Add the current realm
	
	local vRealmPlayers = self.PlayersByRealm[GuildCalendarEvent.RealmName]
	
	if vRealmPlayers then
		-- Calculate how many players there are in the current realm
		
		local vNumRealmPlayers = 0
		
		for vPlayerName, vPlayerInfo in pairs(vRealmPlayers) do
			vNumRealmPlayers = vNumRealmPlayers + 1
		end
		
		-- Calculate the desired percentage of players from this realm.  This
		-- ensures that donors and other contributors will show up more often
		-- to themselves and other players on their realms
		
		local vLocalPercentage = 0.02 * vNumRealmPlayers
		
		if vLocalPercentage > 0.5 then
			vLocalPercentage = 0.5
		end
		
		-- Calculate the minimum number of players to add and repeatedly add the
		-- realm until that minimum is met
		
		local vMinRealmPlayers = #self.Players * vLocalPercentage / (1 - vLocalPercentage)
		
		repeat
			for vPlayerName, vPlayerInfo in pairs(vRealmPlayers) do
				if type(vPlayerInfo) == "number" then
					table.insert(self.Players,
					{
						Name = vPlayerName,
						Realm = GuildCalendarEvent.RealmName,
						Level = vPlayerInfo
					})
				end
				
				vMinRealmPlayers = vMinRealmPlayers - 1
			end
		until vMinRealmPlayers <= 0
	end
	
	self:Shuffle()
	
	self.PlayerIndex = 1
	self.NextPlayerTime = 0
end

function GuildCalendarEvent._Credits:Shuffle()
	for _, vPlayerInfo in ipairs(self.Players) do
		vPlayerInfo.SortValue = math.random()
	end
	
	table.sort(self.Players, function (pInfo1, pInfo2)
		return pInfo1.SortValue < pInfo2.SortValue
	end)
end

function GuildCalendarEvent._Credits:OnShow()
	while next(self.AvailableCreditFrames) do
		table.remove(self.AvailableCreditFrames)
	end
	
	for _, vCreditFrame in ipairs(self.CreditFrames) do
		table.insert(self.AvailableCreditFrames, vCreditFrame)
	end
end

function GuildCalendarEvent._Credits:OnHide()
end

function GuildCalendarEvent._Credits:OnUpdate(pElapsed)
	self.NextPlayerTime = self.NextPlayerTime - pElapsed
	
	if self.NextPlayerTime > 0 then
		return
	end
	
	self.NextPlayerTime = 0.6
	
	local vCreditFrame = table.remove(self.AvailableCreditFrames)
	
	if not vCreditFrame then
		vCreditFrame = GuildCalendarEvent:New(GuildCalendarEvent._CreditFrame, self)
		table.insert(self.CreditFrames, vCreditFrame)
	end
	
	vCreditFrame:SetPlayer(self.Players[self.PlayerIndex])
	vCreditFrame:Animate("DROPLET")
	
	self.PlayerIndex = self.PlayerIndex + 1
	
	if self.PlayerIndex > #self.Players then
		self:Shuffle()
		self.PlayerIndex = 1
	end
end

function GuildCalendarEvent._Credits:ReleaseCreditFrame(pCreditFrame)
	table.insert(self.AvailableCreditFrames, pCreditFrame)
end

----------------------------------------
GuildCalendarEvent._CreditFrame = {}
----------------------------------------

function GuildCalendarEvent._CreditFrame:New(pParent)
	return CreateFrame("Frame", nil, pParent)
end

function GuildCalendarEvent._CreditFrame:Construct(pParent)
	self.Line1 = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	self.Line1:SetPoint("TOP", self, "TOP")
	self.Line1:SetWidth(250)
	
	self.Line2 = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Line2:SetPoint("TOP", self.Line1, "BOTTOM")
	self.Line2:SetWidth(250)
	
	self:SetWidth(250)
	self:SetHeight(100)
	
	self:SetScript("OnUpdate", self.OnUpdate)
end

function GuildCalendarEvent._CreditFrame:SetPlayer(pPlayerInfo)
	self.Line1:SetText(pPlayerInfo.Name)
	self.Line2:SetText(pPlayerInfo.Realm)
end

function GuildCalendarEvent._CreditFrame:Animate(pStyle)
	self.AnimationStyle = pStyle
	self.AnimationElapsed = 0
	
	if self.AnimationStyle == "DROPLET" then
		self.HorizPos = math.random() * 300 - 150
		self.VertPos = 0
		
		self:SetPoint("TOP", self:GetParent(), "TOP", self.HorizPos, self.VertPos)
		self:SetAlpha(0)
		
		self.FadeInTime = 0.8
		
		self.VertVelocity = 0
		self.VertAccel = 0
	end
end

function GuildCalendarEvent._CreditFrame:OnUpdate(pElapsed)
	if self.AnimationStyle == "DROPLET" then
		self.AnimationElapsed = self.AnimationElapsed + pElapsed
		
		if self.AnimationElapsed > self.FadeInTime then
			self:SetAlpha(1)
			
			self.VertAccel = -120
			self.VertVelocity = self.VertVelocity + self.VertAccel * pElapsed
			self.VertPos = self.VertPos + self.VertVelocity * pElapsed
			
			self:SetPoint("TOP", self:GetParent(), "TOP", self.HorizPos, self.VertPos)
			
			if self.VertPos < -self:GetParent():GetHeight() then
				self.AnimationStyle = nil
				self:SetAlpha(0)
				self:GetParent():ReleaseCreditFrame(self)
			end
		else
			self:SetAlpha(self.AnimationElapsed / self.FadeInTime)
		end
	end
end
