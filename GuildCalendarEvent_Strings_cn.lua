----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "zhCN" then

GuildCalendarEvent.cTitle = "团体行事历 v%s"
GuildCalendarEvent.cCantReloadUI = "你必须重新启动游戏来完成 Guild Event Calendar 的此次版本更新"

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

GuildCalendarEvent.cGeneralEventGroup = "综合"
GuildCalendarEvent.cPersonalEventGroup = "私人 (非共享)"
GuildCalendarEvent.cRaidClassicEventGroup = "团队 (艾泽拉斯)"
GuildCalendarEvent.cTBCRaidEventGroup = "团队 (外域)"
GuildCalendarEvent.cWotLKRaidEventGroup = "团队 (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "地下城 (艾泽拉斯)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "地下城 (外域)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "地下城 (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "英雄模式副本 (外域)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "英雄模式副本 (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "战场"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Outdoor Raids"

GuildCalendarEvent.cMeetingEventName = "聚会"
GuildCalendarEvent.cBirthdayEventName = "生日"
GuildCalendarEvent.cRoleplayEventName = "角色扮演"
GuildCalendarEvent.cHolidayEventName = "假期"
GuildCalendarEvent.cDentistEventName = "牙医"
GuildCalendarEvent.cDoctorEventName = "医生"
GuildCalendarEvent.cVacationEventName = "假期"
GuildCalendarEvent.cOtherEventName = "其它"

GuildCalendarEvent.cCooldownEventName = "%s 就绪"

GuildCalendarEvent.cPersonalEventOwner = "私人"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "None"

GuildCalendarEvent.cAvailableMinutesFormat = "%s 尚余 %d 分钟"
GuildCalendarEvent.cAvailableMinuteFormat = "%s 尚余 %d 分钟"
GuildCalendarEvent.cStartsMinutesFormat = "%s 将于 %d 分钟后开始"
GuildCalendarEvent.cStartsMinuteFormat = "%s 将于 in %d 分钟内开始"
GuildCalendarEvent.cStartingNowFormat = "%s 现在开始"
GuildCalendarEvent.cAlreadyStartedFormat = "%s 已经开始"
GuildCalendarEvent.cHappyBirthdayFormat = "%s 生日快乐!"

GuildCalendarEvent.cLocalTimeNote = "(%s 本地)"
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

GuildCalendarEvent.cLevelRangeFormat = "等级 %i 至 %i"
GuildCalendarEvent.cMinLevelFormat = "等级 %i 或以上"
GuildCalendarEvent.cMaxLevelFormat = "等级 %i 或以下"
GuildCalendarEvent.cAllLevels = "所有等级"
GuildCalendarEvent.cSingleLevel = "只限等级 %i"

GuildCalendarEvent.cYes = "嗯! 我会出席此活动"
GuildCalendarEvent.cNo = "不, 我不会出席此活动"
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
GuildCalendarEvent.cTimeLabel = "时间:"
GuildCalendarEvent.cDurationLabel = "需时:"
GuildCalendarEvent.cEventLabel = "活动:"
GuildCalendarEvent.cTitleLabel = "标题:"
GuildCalendarEvent.cLevelsLabel = "等级:"
GuildCalendarEvent.cLevelRangeSeparator = "至"
GuildCalendarEvent.cDescriptionLabel = "内容:"
GuildCalendarEvent.cCommentLabel = "备注:"
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

GuildCalendarEvent.cPluralMinutesFormat = "%d分钟"
GuildCalendarEvent.cSingularHourFormat = "%d小时"
GuildCalendarEvent.cPluralHourFormat = "%d小时"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d小时%d分钟"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d小时%d分钟"

GuildCalendarEvent.cNewerVersionMessage = "A newer version is available (%s)"

GuildCalendarEvent.cDelete = "删除"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Group by"
GuildCalendarEvent.cViewByStatus = "检视状态"
GuildCalendarEvent.cViewByClass = "Class"
GuildCalendarEvent.cViewByRole = "Role"
GuildCalendarEvent.cViewSortBy = "Sort by"
GuildCalendarEvent.cViewByDate = "检视日期"
GuildCalendarEvent.cViewByRank = "检视阶级"
GuildCalendarEvent.cViewByName = "检视名称"

GuildCalendarEvent.cInviteButtonTitle = "邀请已选玩家"
GuildCalendarEvent.cAutoSelectButtonTitle = "选取玩家..."
GuildCalendarEvent.cAutoSelectWindowTitle = "选取玩家"

GuildCalendarEvent.cNoSelection = "没有玩家选取"
GuildCalendarEvent.cSingleSelection = "选取了 1 位玩家"
GuildCalendarEvent.cMultiSelection = "选取了 %d 位玩家"

GuildCalendarEvent.cInviteNeedSelectionStatus = "选择准备邀请的玩家"
GuildCalendarEvent.cInviteReadyStatus = "准备邀请"
GuildCalendarEvent.cInviteInitialInvitesStatus = "传送首次的邀请"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "等待首次的邀请回应"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "转换至团队"
GuildCalendarEvent.cInviteInvitingStatus = "传送邀请"
GuildCalendarEvent.cInviteCompleteStatus = "邀请完毕"
GuildCalendarEvent.cInviteReadyToRefillStatus = "准备填补空缺"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "已经没有玩家可以填补队伍"
GuildCalendarEvent.cRaidFull = "团队已满"

GuildCalendarEvent.cWhisperPrefix = "[团体行事历]"
GuildCalendarEvent.cInviteWhisperFormat = "%s 您已经被邀请加入 '%s' 活动。若阁下想加入此活动，请接受此邀请。"
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s 您已经加入了一个队伍。请阁下您在取消您的队伍后，使用 /w 回覆。"

GuildCalendarEvent.cJoinedGroupStatus = "已加入"
GuildCalendarEvent.cInvitedGroupStatus = "已邀请"
GuildCalendarEvent.cReadyGroupStatus = "就绪"
GuildCalendarEvent.cGroupedGroupStatus = "在其他队伍"
GuildCalendarEvent.cStandbyGroupStatus = "等候"
GuildCalendarEvent.cMaybeGroupStatus = "Maybe"
GuildCalendarEvent.cDeclinedGroupStatus = "拒绝邀请"
GuildCalendarEvent.cOfflineGroupStatus = "下线"
GuildCalendarEvent.cLeftGroupStatus = "离开队伍"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "自动确认"
GuildCalendarEvent.cRoleConfirmationTitle = "Auto Confirm by Role"
GuildCalendarEvent.cManualConfirmationTitle = "手动确认"
GuildCalendarEvent.cClosedEventTitle = "关闭活动"

GuildCalendarEvent.cMinLabel = "最低"
GuildCalendarEvent.cMaxLabel = "最高"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "队伍人数上限:"
GuildCalendarEvent.cMinPartySizeLabel = "队伍人数下限:"
GuildCalendarEvent.cNoMinimum = "没有下限"
GuildCalendarEvent.cNoMaximum = "没有上限"
GuildCalendarEvent.cPartySizeFormat = "%d 位玩家"

GuildCalendarEvent.cAddPlayerTitle = "新增..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "设定..."

GuildCalendarEvent.cClassLimitDescription = "设定下列每种职业的最低及最高人数。若该职业的人数尚未符合最低要求，您将被自动填补空缺。当人数到达上限时，将会有额外的提示。"
GuildCalendarEvent.cRoleLimitDescription = "Set the minimum and maximum numbers of players for each role.  Minimums will be met first, extra spots beyond the minimum will be filled until the maximum is reached or the group is full.  You can also reserve spaces within each role for particular classes (requiring one ranged dps to be a shadow priest for example)"

GuildCalendarEvent.cPriorityLabel = "优先权:"
GuildCalendarEvent.cPriorityDate = "时间"
GuildCalendarEvent.cPriorityRank = "阶级"

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

GuildCalendarEvent.cSingleTimeDateFormat = "%s %s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s %s至%s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00已加入",
	CONFIRMED = "|cff88ff00就绪",
	STANDBY = "|cffffff00等候",
	INVITED = "|cff00ff00已邀请",
	DECLINED = "|cffff0000拒绝邀请",
	BUSY = "|cffff0000在其他队伍",
	OFFLINE = "|cff888888下线",
	LEFT = "|cff0000ff离开队伍",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "关于团体行事历 s"
GuildCalendarEvent.cAboutAuthor = "由 John Stephen 设计及编写"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "加入玩家"
GuildCalendarEvent.cRemovePlayer = "Remove Player"

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

GuildCalendarEvent.cUnknown = "未知"

-- Main window

GuildCalendarEvent.cCalendar = "行事历"
GuildCalendarEvent.cSetup = "设置"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "关于"

GuildCalendarEvent.cUseServerDateTime = "使用伺服器日期与时间"
GuildCalendarEvent.cUseServerDateTimeDescription = "启动此功能将会以伺服器的日期与时间来显示活动资讯，若关闭此功能则会以您的电脑日期及时间来显示。"
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

end -- zhCN
