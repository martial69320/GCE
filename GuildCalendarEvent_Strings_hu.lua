----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "huHU" then

GuildCalendarEvent.cTitle = "Guild Event Calendar %s"
GuildCalendarEvent.cCantReloadUI = "You must completely restart WoW to upgrade to this version of Guild Event Calendar"

GuildCalendarEvent.cHelpHeader = "Guild Event Calendar Commands"
GuildCalendarEvent.cHelpHelp = "Shows this list of commands"
GuildCalendarEvent.cHelpReset = "Resets all saved data and settings"
GuildCalendarEvent.cHelpDebug = "Enables or disables the debug code"
GuildCalendarEvent.cHelpClock = "Sets the minimap clock to display local time or server time"
GuildCalendarEvent.cHelpiCal = "Generates iCal data (default is 'all')"
GuildCalendarEvent.cHelpReminder = "Turns reminders on or off"
GuildCalendarEvent.cHelpBirth = "Turns birthday announcements on or off"
GuildCalendarEvent.cHelpAttend = "Turns attendance reminders on or off"
GuildCalendarEvent.cHelpShow = "Shows the calendar window"

GuildCalendarEvent.cTooltipScheduleItemFormat = "%s (%s)"

GuildCalendarEvent.cForeignRealmFormat = "%s of %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s and %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} and %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "General"
GuildCalendarEvent.cPersonalEventGroup = "Personal (not shared)"
GuildCalendarEvent.cRaidClassicEventGroup = "Raids (Classic)"
GuildCalendarEvent.cTBCRaidEventGroup = "Raids (Burning Crusade)"
GuildCalendarEvent.cWotLKRaidEventGroup = "Raids (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "Dungeons (Classic)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "Dungeons (Burning Crusade)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "Dungeons (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "Heroics (Burning Crusade)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "Heroics (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "PvP"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Outdoor Raids"

GuildCalendarEvent.cMeetingEventName = "Meeting"
GuildCalendarEvent.cBirthdayEventName = "Birthday"
GuildCalendarEvent.cRoleplayEventName = "Roleplaying"
GuildCalendarEvent.cHolidayEventName = "Holiday"
GuildCalendarEvent.cDentistEventName = "Dentist"
GuildCalendarEvent.cDoctorEventName = "Doctor"
GuildCalendarEvent.cVacationEventName = "Vacation"
GuildCalendarEvent.cOtherEventName = "Other"

GuildCalendarEvent.cCooldownEventName = "%s Available"

GuildCalendarEvent.cPersonalEventOwner = "Private"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "None"

GuildCalendarEvent.cAvailableMinutesFormat = "%s in %d minutes"
GuildCalendarEvent.cAvailableMinuteFormat = "%s in %d minute"
GuildCalendarEvent.cStartsMinutesFormat = "%s starts in %d minutes"
GuildCalendarEvent.cStartsMinuteFormat = "%s starts in %d minute"
GuildCalendarEvent.cStartingNowFormat = "%s is starting now"
GuildCalendarEvent.cAlreadyStartedFormat = "%s has already started"
GuildCalendarEvent.cHappyBirthdayFormat = "Happy birthday %s!"

GuildCalendarEvent.cLocalTimeNote = "(%s local)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "Healer"
GuildCalendarEvent.cTRole = "Tank"
GuildCalendarEvent.cRRole = "Ranged"
GuildCalendarEvent.cMRole = "Melee"

GuildCalendarEvent.cHPluralRole = "Healers"
GuildCalendarEvent.cTPluralRole = "Tanks"
GuildCalendarEvent.cRPluralRole = "Ranged"
GuildCalendarEvent.cMPluralRole = "Melee"

GuildCalendarEvent.cHPluralLabel = GuildCalendarEvent.cHPluralRole..":"
GuildCalendarEvent.cTPluralLabel = GuildCalendarEvent.cTPluralRole..":"
GuildCalendarEvent.cRPluralLabel = GuildCalendarEvent.cRPluralRole..":"
GuildCalendarEvent.cMPluralLabel = GuildCalendarEvent.cMPluralRole..":"

-- iCalendar export

GuildCalendarEvent.cExportTitle = "Export to iCalendar"
GuildCalendarEvent.cExportSummary = "Addons can not write files directly to your computer for you, so exporting the iCalendar data requires a few easy steps you must complete yourself"
GuildCalendarEvent.cExportInstructions =
{
	"Step 1: "..HIGHLIGHT_FONT_COLOR_CODE.."Select the event types to be included",
	"Step 2: "..HIGHLIGHT_FONT_COLOR_CODE.."Copy the text in the Data box",
	"Step 3: "..HIGHLIGHT_FONT_COLOR_CODE.."Create a new file using any text editor and paste in the text",
	"Step 4: "..HIGHLIGHT_FONT_COLOR_CODE.."Save the file with an extension of '.ics' (ie, Calendar.ics)",
	RED_FONT_COLOR_CODE.."IMPORTANT: "..HIGHLIGHT_FONT_COLOR_CODE.."You must save the file as plain text or it will not be usable",
	"Step 5: "..HIGHLIGHT_FONT_COLOR_CODE.."Import the file into your calendar application",
}

GuildCalendarEvent.cPrivateEvents = "Private events"
GuildCalendarEvent.cGuildEvents = "Guild events"
GuildCalendarEvent.cHolidays = "Holidays"
GuildCalendarEvent.cTradeskills = "Cooldown events"
GuildCalendarEvent.cPersonalEvents = "Personal events"
GuildCalendarEvent.cAlts = "Alts"
GuildCalendarEvent.cOthers = "Others"

GuildCalendarEvent.cExportData = "Data"

-- Event Edit tab

GuildCalendarEvent.cLevelRangeFormat = "Levels %i to %i"
GuildCalendarEvent.cMinLevelFormat = "Levels %i and up"
GuildCalendarEvent.cMaxLevelFormat = "Up to level %i"
GuildCalendarEvent.cAllLevels = "All levels"
GuildCalendarEvent.cSingleLevel = "Level %i only"

GuildCalendarEvent.cYes = "Yes! %s will attend this event"
GuildCalendarEvent.cNo = "No. %s won't attend this event"
GuildCalendarEvent.cMaybe = "Maybe. I'm not sure yet"

GuildCalendarEvent.cStatusFormat = "Status: %s"
GuildCalendarEvent.cInvitedByFormat = "Invited by %s"

GuildCalendarEvent.cInvitedStatus = "Invited, awaiting your response"
GuildCalendarEvent.cAcceptedStatus = "Accepted, awaiting confirmation"
GuildCalendarEvent.cTentativeStatus = "Tentative, awaiting confirmation"
GuildCalendarEvent.cDeclinedStatus = CALENDAR_STATUS_DECLINED
GuildCalendarEvent.cConfirmedStatus = CALENDAR_STATUS_CONFIRMED
GuildCalendarEvent.cOutStatus = CALENDAR_STATUS_OUT
GuildCalendarEvent.cStandbyStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cSignedUpStatus = CALENDAR_STATUS_SIGNEDUP
GuildCalendarEvent.cNotSignedUpStatus = CALENDAR_STATUS_NOT_SIGNEDUP

GuildCalendarEvent.cAllDay = "All day"

GuildCalendarEvent.cEventModeLabel = "Mode:"
GuildCalendarEvent.cTimeLabel = "Time:"
GuildCalendarEvent.cDurationLabel = "Duration:"
GuildCalendarEvent.cEventLabel = "Event:"
GuildCalendarEvent.cTitleLabel = "Title:"
GuildCalendarEvent.cLevelsLabel = "Levels:"
GuildCalendarEvent.cLevelRangeSeparator = "to"
GuildCalendarEvent.cDescriptionLabel = "Description:"
GuildCalendarEvent.cCommentLabel = "Comment:"
GuildCalendarEvent.cRepeatLabel = "Repeat:"
GuildCalendarEvent.cAutoConfirmLabel = "Auto confirm"
GuildCalendarEvent.cLockoutLabel = "Auto-close:"
GuildCalendarEvent.cEventClosedLabel = "Signups closed"
GuildCalendarEvent.cAutoConfirmRoleLimitsTitle = "Auto confirm limits"
GuildCalendarEvent.cAutoConfirmLimitsLabel = "Limits..."
GuildCalendarEvent.cNormalMode = "Private event"
GuildCalendarEvent.cAnnounceMode = "Guild announcement"
GuildCalendarEvent.cSignupMode = "Guild event"

GuildCalendarEvent.cLockout0 = "at the start"
GuildCalendarEvent.cLockout15 = "15 minutes early"
GuildCalendarEvent.cLockout30 = "30 minutes early"
GuildCalendarEvent.cLockout60 = "1 hour early"
GuildCalendarEvent.cLockout120 = "2 hours early"
GuildCalendarEvent.cLockout180 = "3 hours early"
GuildCalendarEvent.cLockout1440 = "1 day early"

GuildCalendarEvent.cPluralMinutesFormat = "%d minutes"
GuildCalendarEvent.cSingularHourFormat = "%d hour"
GuildCalendarEvent.cPluralHourFormat = "%d hours"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d hour %d minutes"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d hours %d minutes"

GuildCalendarEvent.cNewerVersionMessage = "A newer version is available (%s)"

GuildCalendarEvent.cDelete = "Delete"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Group by"
GuildCalendarEvent.cViewByStatus = "Status"
GuildCalendarEvent.cViewByClass = "Class"
GuildCalendarEvent.cViewByRole = "Role"
GuildCalendarEvent.cViewSortBy = "Sort by"
GuildCalendarEvent.cViewByDate = "Date"
GuildCalendarEvent.cViewByRank = "Rank"
GuildCalendarEvent.cViewByName = "Name"

GuildCalendarEvent.cInviteButtonTitle = "Invite Selected"
GuildCalendarEvent.cAutoSelectButtonTitle = "Select Players..."
GuildCalendarEvent.cAutoSelectWindowTitle = "Select Players"

GuildCalendarEvent.cNoSelection = "No players selected"
GuildCalendarEvent.cSingleSelection = "1 player selected"
GuildCalendarEvent.cMultiSelection = "%d players selected"

GuildCalendarEvent.cInviteNeedSelectionStatus = "Select players to be invited"
GuildCalendarEvent.cInviteReadyStatus = "Ready to invite"
GuildCalendarEvent.cInviteInitialInvitesStatus = "Sending initial invitations"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "Waiting for initial acceptance"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "Converting to raid"
GuildCalendarEvent.cInviteInvitingStatus = "Sending invitations"
GuildCalendarEvent.cInviteCompleteStatus = "Invitations completed"
GuildCalendarEvent.cInviteReadyToRefillStatus = "Ready to fill vacant slots"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "No more players available to fill the group"
GuildCalendarEvent.cRaidFull = "Raid full"

GuildCalendarEvent.cWhisperPrefix = "[Guild Event Calendar]"
GuildCalendarEvent.cInviteWhisperFormat = "%s You are being invited to the event '%s'.  Please accept the invitation if you wish to join this event."
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s You are already in a group.  Please /w back when you leave your group."

GuildCalendarEvent.cJoinedGroupStatus = "Joined"
GuildCalendarEvent.cInvitedGroupStatus = "Invited"
GuildCalendarEvent.cReadyGroupStatus = "Ready"
GuildCalendarEvent.cGroupedGroupStatus = "In another group"
GuildCalendarEvent.cStandbyGroupStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cMaybeGroupStatus = "Maybe"
GuildCalendarEvent.cDeclinedGroupStatus = "Declined invitation"
GuildCalendarEvent.cOfflineGroupStatus = "Offline"
GuildCalendarEvent.cLeftGroupStatus = "Left group"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "Auto Confirm by Class"
GuildCalendarEvent.cRoleConfirmationTitle = "Auto Confirm by Role"
GuildCalendarEvent.cManualConfirmationTitle = "Manual Confirmations"
GuildCalendarEvent.cClosedEventTitle = "Closed Event"
GuildCalendarEvent.cMinLabel = "min"
GuildCalendarEvent.cMaxLabel = "max"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "Maximum party size:"
GuildCalendarEvent.cMinPartySizeLabel = "Minimum party size:"
GuildCalendarEvent.cNoMinimum = "No minimum"
GuildCalendarEvent.cNoMaximum = "No maximum"
GuildCalendarEvent.cPartySizeFormat = "%d players"

GuildCalendarEvent.cAddPlayerTitle = "Add..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "Settings..."

GuildCalendarEvent.cClassLimitDescription = "Set the minimum and maximum number of players for each class.  Minimums will be met first, extra spots beyond the minimum will be filled until the maximum is reached or the group is full."
GuildCalendarEvent.cRoleLimitDescription = "Set the minimum and maximum numbers of players for each role.  Minimums will be met first, extra spots beyond the minimum will be filled until the maximum is reached or the group is full.  You can also reserve spaces within each role for particular classes (requiring one ranged dps to be a shadow priest for example)"

GuildCalendarEvent.cPriorityLabel = "Priority:"
GuildCalendarEvent.cPriorityDate = "Date"
GuildCalendarEvent.cPriorityRank = "Rank"

GuildCalendarEvent.cCachedEventStatus = "This event is a cached copy from $Name's calendar\rLast refreshed on $Date at $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "Druids"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "Hunters"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "Mages"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "Paladins"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "Priests"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "Rogues"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "Shaman"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "Warlocks"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "Warriors"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "Death Knights"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Current party or raid"

GuildCalendarEvent.cViewByFormat = "View by %s / %s"

GuildCalendarEvent.cConfirm = "Confirm"

GuildCalendarEvent.cSingleTimeDateFormat = "%s\r%s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s\rfrom %s to %s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00joined",
	CONFIRMED = "|cff88ff00confirmed",
	STANDBY = "|cffffff00standby",
	INVITED = "|cff00ff00invited",
	DECLINED = "|cffff0000declined",
	BUSY = "|cffff0000already grouped",
	OFFLINE = "|cff888888offline",
	LEFT = "|cff0000ffleft group",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "About Guild Event Calendar %s"
GuildCalendarEvent.cAboutAuthor = "Designed and written by John Stephen"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "Add Player..."
GuildCalendarEvent.cRemovePlayer = "Remove Player..."

GuildCalendarEvent.cPartnersLabel = NORMAL_FONT_COLOR_CODE.."Partners:"..FONT_COLOR_CODE_CLOSE.." %s"
GuildCalendarEvent.cSync = "Sync"

GuildCalendarEvent.cConfirmDeletePartnerGuild = "Are you sure you want to delete your partnership with <%s>?"
GuildCalendarEvent.cConfirmDeletePartner = "Are you sure you want to remove %s from your partnerships?"
GuildCalendarEvent.cConfirmPartnerRequest = "[Guild Event Calendar]: %s is requesting a partnership with you."

GuildCalendarEvent.cLastPartnerUpdate = "Last synchronized %s %s"
GuildCalendarEvent.cNoPartnerUpdate = "Not synchronized"

GuildCalendarEvent.cPartnerStatus =
{
	PARTNER_SYNC_CONNECTING = "Connecting to %s",
	PARTNER_SYNC_CONNECTED = "Synchronizing with %s",
}

-- Settings tab

GuildCalendarEvent.cSettingsTitle = "Settings"
GuildCalendarEvent.cThemeLabel = "Theme"
GuildCalendarEvent.cParchmentThemeName = "Parchment"
GuildCalendarEvent.cLightParchmentThemeName = "Light Parchment"
GuildCalendarEvent.cSeasonalThemeName = "Seasonal"
GuildCalendarEvent.cTwentyFourHourTime = "24 hour time"
GuildCalendarEvent.cAnnounceBirthdays = "Show birthday reminders"
GuildCalendarEvent.cAnnounceEvents = "Show event reminders"
GuildCalendarEvent.cAnnounceTradeskills = "Show tradeskill reminders"
GuildCalendarEvent.cRecordTradeskills = "Record tradeskill cooldowns"
GuildCalendarEvent.cRememberInvites = "Remember event invitations for use in future events"

GuildCalendarEvent.cUnderConstruction = "This area is under construction"

GuildCalendarEvent.cUnknown = "Unknown"

-- Main window

GuildCalendarEvent.cCalendar = "Calendar"
GuildCalendarEvent.cSettings = "Settings"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "About"

GuildCalendarEvent.cUseServerDateTime = "Use server dates and times"
GuildCalendarEvent.cUseServerDateTimeDescription = "Turn on to show events using the server date and time, turn off to use your local date and time"
GuildCalendarEvent.cShowCalendarLabel = "Show:"
GuildCalendarEvent.cShowAlts = "Show alts"
GuildCalendarEvent.cShowAltsDescription = "Turn on to show events cached from your other characters"
GuildCalendarEvent.cShowDarkmoonCalendarDescription = "Turn on to show the Darkmoon Faire schedule"
GuildCalendarEvent.cShowWeeklyCalendarDescription = "Turn on to show weekly events such as the Fishing Extravaganza"
GuildCalendarEvent.cShowPvPCalendarDescription = "Turn on to show PvP weekends"
GuildCalendarEvent.cShowLockoutCalendarDescription = "Turn on to show you active dungeon lockouts"

GuildCalendarEvent.cMinimapButtonHint = "Left-click to show Guild Event Calendar."
GuildCalendarEvent.cMinimapButtonHint2 = "Right-click to show the WoW calendar."

GuildCalendarEvent.cNewEvent = "New Event..."
GuildCalendarEvent.cPasteEvent = "Paste Event"

GuildCalendarEvent.cConfirmDelete = "Are you sure you want to delete this event?  This will remove the event from all calendars, including other players."

GuildCalendarEvent.cGermanLocalization = "German Localization"
GuildCalendarEvent.cChineseLocalization = "Chinese Localization"
GuildCalendarEvent.cFrenchLocalization = "French Localization"
GuildCalendarEvent.cSpanishLocalization = "Spanish Localization"
GuildCalendarEvent.cRussianLocalization = "Russian Localization"
GuildCalendarEvent.cContributingDeveloper = "Contributing Developer"
GuildCalendarEvent.cGuildCreditFormat = "The guild of %s"

GuildCalendarEvent.cExpiredEventNote = "This event has already occurred and can no longer be modified"

GuildCalendarEvent.cMore = "more..."

GuildCalendarEvent.cRespondedDateFormat = "Responded on %s"

GuildCalendarEvent.cStartDayLabel = "Start week on:"

end -- huHU
