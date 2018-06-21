----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "zhTW" then

GuildCalendarEvent.cTitle = "團隊行事曆 v%s"
GuildCalendarEvent.cCantReloadUI = "必須完全重新啟動魔獸世界，才能更新Guild Event Calendar版本"

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

GuildCalendarEvent.cForeignRealmFormat = "%s 與 %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s 和 %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} 和 %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "綜合"
GuildCalendarEvent.cPersonalEventGroup = "私人活動 (非共享)"
GuildCalendarEvent.cRaidClassicEventGroup = "團隊 (Classic)"
GuildCalendarEvent.cTBCRaidEventGroup = "團隊 (Burning Crusade)"
GuildCalendarEvent.cWotLKRaidNEventGroup = "團隊 (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "副本/地下城 (Classic)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "副本/地下城 (Burning Crusade)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "副本/地下城 (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "英雄模式副本 (Burning Crusade)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "英雄模式副本 (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "戰場"
GuildCalendarEvent.cOutdoorRaidEventGroup = "戶外團隊野戰"

GuildCalendarEvent.cMeetingEventName = "聚會"
GuildCalendarEvent.cBirthdayEventName = "生日"
GuildCalendarEvent.cRoleplayEventName = "角色扮演"
GuildCalendarEvent.cHolidayEventName = "假期"
GuildCalendarEvent.cDentistEventName = "看牙醫"
GuildCalendarEvent.cDoctorEventName = "看醫生"
GuildCalendarEvent.cVacationEventName = "假期"
GuildCalendarEvent.cOtherEventName = "其它"

GuildCalendarEvent.cCooldownEventName = "%s 冷卻就緒"

GuildCalendarEvent.cPersonalEventOwner = "私人活動"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "無"

GuildCalendarEvent.cAvailableMinutesFormat = "%s 尚餘 %d 分鐘"
GuildCalendarEvent.cAvailableMinuteFormat = "%s 尚餘 %d 分鐘"
GuildCalendarEvent.cStartsMinutesFormat = "%s 將於 %d 分鐘後開始"
GuildCalendarEvent.cStartsMinuteFormat = "%s 將於 %d 分鐘內開始"
GuildCalendarEvent.cStartingNowFormat = "%s 現在開始"
GuildCalendarEvent.cAlreadyStartedFormat = "%s 已經開始"
GuildCalendarEvent.cHappyBirthdayFormat = "%s 祝你生日快樂！"

GuildCalendarEvent.cLocalTimeNote = "(%s 本地)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "主要補職"
GuildCalendarEvent.cTRole = "主要坦職"
GuildCalendarEvent.cDRole = "遠距傷害職"
GuildCalendarEvent.cDRole = "近戰傷害職"

GuildCalendarEvent.cHPluralRole = "主要補職"
GuildCalendarEvent.cTPluralRole = "主要坦克"
GuildCalendarEvent.cDPluralRole = "遠距DPS"
GuildCalendarEvent.cDPluralRole = "近戰DPS"

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

GuildCalendarEvent.cLevelRangeFormat = "等級 %i 至 %i"
GuildCalendarEvent.cMinLevelFormat = "等級 %i 或以上"
GuildCalendarEvent.cMaxLevelFormat = "等級 %i 或以下"
GuildCalendarEvent.cAllLevels = "所有等級"
GuildCalendarEvent.cSingleLevel = "只限等級 %i"

GuildCalendarEvent.cYes = "是的！我會出席此活動！"
GuildCalendarEvent.cNo = "不，我不會出席這個活動！"
GuildCalendarEvent.cMaybe = "可能可以參加，把我放在候補名單！"

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

GuildCalendarEvent.cAllDay = "全天"

GuildCalendarEvent.cEventModeLabel = "Mode:"
GuildCalendarEvent.cTimeLabel = "時間:"
GuildCalendarEvent.cDurationLabel = "需時:"
GuildCalendarEvent.cEventLabel = "活動:"
GuildCalendarEvent.cTitleLabel = "標題:"
GuildCalendarEvent.cLevelsLabel = "等級:"
GuildCalendarEvent.cLevelRangeSeparator = "至"
GuildCalendarEvent.cDescriptionLabel = "內容:"
GuildCalendarEvent.cCommentLabel = "備註:"
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

GuildCalendarEvent.cPluralMinutesFormat = "%d分鐘"
GuildCalendarEvent.cSingularHourFormat = "%d小時"
GuildCalendarEvent.cPluralHourFormat = "%d小時"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d小時%d分鐘"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d小時%d分鐘"

GuildCalendarEvent.cNewerVersionMessage = "一個新的版本已經可以下載 (%s)"

GuildCalendarEvent.cDelete = "刪除"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "分組依照:"
GuildCalendarEvent.cViewByStatus = "狀況"
GuildCalendarEvent.cViewByClass = "職業"
GuildCalendarEvent.cViewByRole = "角色"
GuildCalendarEvent.cViewSortBy = "排序依照:"
GuildCalendarEvent.cViewByDate = "時間"
GuildCalendarEvent.cViewByRank = "公會階級"
GuildCalendarEvent.cViewByName = "名稱"

GuildCalendarEvent.cInviteButtonTitle = "邀請已選玩家"
GuildCalendarEvent.cAutoSelectButtonTitle = "選取玩家..."
GuildCalendarEvent.cAutoSelectWindowTitle = "選取玩家"

GuildCalendarEvent.cNoSelection = "沒有選取玩家"
GuildCalendarEvent.cSingleSelection = "選取了 1 位玩家"
GuildCalendarEvent.cMultiSelection = "選取了 %d 位玩家"

GuildCalendarEvent.cInviteNeedSelectionStatus = "選擇準備邀請的玩家"
GuildCalendarEvent.cInviteReadyStatus = "準備邀請"
GuildCalendarEvent.cInviteInitialInvitesStatus = "傳送首次的邀請"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "等待首次的邀請回應"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "轉換至團隊"
GuildCalendarEvent.cInviteInvitingStatus = "傳送邀請"
GuildCalendarEvent.cInviteCompleteStatus = "邀請完畢"
GuildCalendarEvent.cInviteReadyToRefillStatus = "準備填補空缺"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "已經沒有玩家可以填補隊伍"
GuildCalendarEvent.cRaidFull = "團隊已滿"

GuildCalendarEvent.cWhisperPrefix = "[團隊行事曆]"
GuildCalendarEvent.cInviteWhisperFormat = "%s 您已經被邀請加入 '%s' 活動。若閣下想加入此活動，請接受此邀請。"
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s 您已經加入了一個隊伍。請閣下您在離開您現在的隊伍後，使用 /w 回覆。"

GuildCalendarEvent.cJoinedGroupStatus = "已加入"
GuildCalendarEvent.cInvitedGroupStatus = "已邀請"
GuildCalendarEvent.cReadyGroupStatus = "就緒"
GuildCalendarEvent.cGroupedGroupStatus = "在其他隊伍"
GuildCalendarEvent.cStandbyGroupStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cMaybeGroupStatus = "Maybe"
GuildCalendarEvent.cDeclinedGroupStatus = "拒絕邀請"
GuildCalendarEvent.cOfflineGroupStatus = "下線"
GuildCalendarEvent.cLeftGroupStatus = "離開隊伍"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "自動確認"
GuildCalendarEvent.cRoleConfirmationTitle = "自動照角色確認"
GuildCalendarEvent.cManualConfirmationTitle = "手動確認"
GuildCalendarEvent.cClosedEventTitle = "關閉活動"
GuildCalendarEvent.cMinLabel = "最低"
GuildCalendarEvent.cMaxLabel = "最高"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "隊伍人數上限:"
GuildCalendarEvent.cMinPartySizeLabel = "隊伍人數下限:"
GuildCalendarEvent.cNoMinimum = "沒有下限"
GuildCalendarEvent.cNoMaximum = "沒有上限"
GuildCalendarEvent.cPartySizeFormat = "%d 位玩家"

GuildCalendarEvent.cAddPlayerTitle = "新增..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "設定..."

GuildCalendarEvent.cClassLimitDescription = "設定下列每種職業的最低及最高人數。若該職業的人數尚未符合最低要求，您將被自動填補空缺。當人數到達上限時，將會有額外的提示。"
GuildCalendarEvent.cRoleLimitDescription = "設定下列每種角色的最低及最高人數。若該角色的人數尚未符合最低要求，您將被自動填補空缺。當角色人數到達上限時，將會有額外的提示。您可以手動設定各職業擔任各角色的下限(例如說需要一個暗牧當遠程DPS)"

GuildCalendarEvent.cPriorityLabel = "優先權:"
GuildCalendarEvent.cPriorityDate = "時間"
GuildCalendarEvent.cPriorityRank = "階級"

GuildCalendarEvent.cCachedEventStatus = "This event is a cached copy from $Name's calendar\rLast refreshed on $Date at $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "德魯伊"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "獵人"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "法師"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "聖騎士"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "牧師"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "盜賊"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "薩滿"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "術士"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "戰士"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "死亡騎士"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Current party or raid"

GuildCalendarEvent.cViewByFormat = "View by %s / %s"

GuildCalendarEvent.cConfirm = "Confirm"

GuildCalendarEvent.cSingleTimeDateFormat = "%s  %s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s  %s至%s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00已加入",
	CONFIRMED = "|cff88ff00就緒",
	STANDBY = "|cffffff00等候",
	INVITED = "|cff00ff00已邀請",
	DECLINED = "|cffff0000拒絕邀請",
	BUSY = "|cffff0000在其他隊伍",
	OFFLINE = "|cff888888下線",
	LEFT = "|cff0000ff離開隊伍",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "關於團隊行事曆 %s"
GuildCalendarEvent.cAboutAuthor = "由 John Stephen 設計及編寫"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "加入玩家..."
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

GuildCalendarEvent.cUnknown = "未知"

-- Invite tab

GuildCalendarEvent.cModeratorTooltipTitle = "Moderator"
GuildCalendarEvent.cModeratorTooltipDescription = "Turn this on to allow this player or group to co-manage your event"

-- Main window

GuildCalendarEvent.cCalendar = "Calendar"
GuildCalendarEvent.cSettings = "Settings"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "About"

GuildCalendarEvent.cUseServerDateTime = "使用伺服器的日期與時間(建議)"
GuildCalendarEvent.cUseServerDateTimeDescription = "啟動此功能將會以伺服器的日期與時間來顯示活動資訊，若關閉此功能則會以您的電腦日期及時間來顯示。"
GuildCalendarEvent.cShowCalendarLabel = "Show:"
GuildCalendarEvent.cShowAlts = "Show alts"
GuildCalendarEvent.cShowAltsDescription = "Turn on to show events cached from your other characters"
GuildCalendarEvent.cShowDarkmoonCalendarDescription = "Turn on to show the Darkmoon Faire schedule"
GuildCalendarEvent.cShowWeeklyCalendarDescription = "Turn on to show weekly events such as the Fishing Extravaganza"
GuildCalendarEvent.cShowPvPCalendarDescription = "Turn on to show PvP weekends"
GuildCalendarEvent.cShowLockoutCalendarDescription = "Turn on to show you active dungeon lockouts"

GuildCalendarEvent.cMinimapButtonHint = "Left-click to show Guild Event Calendar."
GuildCalendarEvent.cMinimapButtonHint2 = "Right-click to show the WoW calendar."

GuildCalendarEvent.cNewEvent = "新活動..."
GuildCalendarEvent.cPasteEvent = "貼上活動"

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

end -- zhTW
