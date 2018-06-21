----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "ruRU" then

GuildCalendarEvent.cTitle = "Организатор %s"
GuildCalendarEvent.cCantReloadUI = "Вам необходимо перезапустить WoW для обновления Guild Event Calendar"

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

GuildCalendarEvent.cForeignRealmFormat = "%s из %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s и %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} и %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "Общий"
GuildCalendarEvent.cPersonalEventGroup = "Личные (не общий)"
GuildCalendarEvent.cRaidClassicEventGroup = "Рейды (Азерот)"
GuildCalendarEvent.cTBCRaidEventGroup = "Рейды (Запределье)"
GuildCalendarEvent.cWotLKRaidEventGroup = "Рейды (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "Инстансы (Азерот)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "Инстансы (Запределье)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "Инстансы (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "Героики (Запределье)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "Героики (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "ПвП"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Внешние Рейды"

GuildCalendarEvent.cMeetingEventName = "Собрание"
GuildCalendarEvent.cBirthdayEventName = "День рождения"
GuildCalendarEvent.cRoleplayEventName = "Ролевая игра"
GuildCalendarEvent.cHolidayEventName = "Развлечения"
GuildCalendarEvent.cDentistEventName = "Дантист"
GuildCalendarEvent.cDoctorEventName = "Доктор"
GuildCalendarEvent.cVacationEventName = "Дуэли, тренинг ПвП"
GuildCalendarEvent.cOtherEventName = "Другое"

GuildCalendarEvent.cCooldownEventName = "%s Доступна"

GuildCalendarEvent.cPersonalEventOwner = "Личный"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "None"

GuildCalendarEvent.cAvailableMinutesFormat = "%s через %d минуты"
GuildCalendarEvent.cAvailableMinuteFormat = "%s через %d минут"
GuildCalendarEvent.cStartsMinutesFormat = "%s старт через %d минут"
GuildCalendarEvent.cStartsMinuteFormat = "%s старт через %d минуты"
GuildCalendarEvent.cStartingNowFormat = "%s уже начинается"
GuildCalendarEvent.cAlreadyStartedFormat = "%s уже начался"
GuildCalendarEvent.cHappyBirthdayFormat = "С днем рождения %s!"

GuildCalendarEvent.cLocalTimeNote = "(%s local)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "Целитель"
GuildCalendarEvent.cTRole = "Танк"
GuildCalendarEvent.cRRole = "Снайпер"
GuildCalendarEvent.cMRole = "ДД"

GuildCalendarEvent.cHPluralRole = "Целитель"
GuildCalendarEvent.cTPluralRole = "Танк"
GuildCalendarEvent.cRPluralRole = "Снайпер"
GuildCalendarEvent.cMPluralRole = "Паразит"

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

GuildCalendarEvent.cLevelRangeFormat = "С уровня %i до %i"
GuildCalendarEvent.cMinLevelFormat = "С уровня %i и выше"
GuildCalendarEvent.cMaxLevelFormat = "До уровня %i"
GuildCalendarEvent.cAllLevels = "Все уровни"
GuildCalendarEvent.cSingleLevel = "Только %i уровня"

GuildCalendarEvent.cYes = "Да! Я буду на этом событии"
GuildCalendarEvent.cNo = "Нет! Я не буду на этом событии"
GuildCalendarEvent.cMaybe = "Возможно. Запишите в список резерва"

GuildCalendarEvent.cStatusFormat = "Status: %s"
GuildCalendarEvent.cInvitedByFormat = "Invited by %s"

GuildCalendarEvent.cInvitedStatus = "Invited, awaiting your response"
GuildCalendarEvent.cAcceptedStatus = "Accepted, awaiting confirmation"
GuildCalendarEvent.cDeclinedStatus = CALENDAR_STATUS_DECLINED
GuildCalendarEvent.cConfirmedStatus = CALENDAR_STATUS_CONFIRMED
GuildCalendarEvent.cOutStatus = CALENDAR_STATUS_OUT
GuildCalendarEvent.cStandbyStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cSignedUpStatus = CALENDAR_STATUS_SIGNEDUP
GuildCalendarEvent.cNotSignedUpStatus = CALENDAR_STATUS_NOT_SIGNEDUP

GuildCalendarEvent.cAllDay = "All day"

GuildCalendarEvent.cEventModeLabel = "Mode:"
GuildCalendarEvent.cTimeLabel = "Время:"
GuildCalendarEvent.cDurationLabel = "Длина:"
GuildCalendarEvent.cEventLabel = "Событие:"
GuildCalendarEvent.cTitleLabel = "Название:"
GuildCalendarEvent.cLevelsLabel = "Уровни:"
GuildCalendarEvent.cLevelRangeSeparator = "до"
GuildCalendarEvent.cDescriptionLabel = "Описание:"
GuildCalendarEvent.cCommentLabel = "Заметка:"
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

GuildCalendarEvent.cPluralMinutesFormat = "%d минут"
GuildCalendarEvent.cSingularHourFormat = "%d час"
GuildCalendarEvent.cPluralHourFormat = "%d часа"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d час %d минут"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d часа %d минут"

GuildCalendarEvent.cNewerVersionMessage = "Доступна новая версия (%s)"

GuildCalendarEvent.cDelete = "Удалить"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Группы по"
GuildCalendarEvent.cViewByStatus = "Статусу"
GuildCalendarEvent.cViewByClass = "Классу"
GuildCalendarEvent.cViewByRole = "Роли"
GuildCalendarEvent.cViewSortBy = "Сортировать"
GuildCalendarEvent.cViewByDate = "По дате"
GuildCalendarEvent.cViewByRank = "По рангу"
GuildCalendarEvent.cViewByName = "По Имени"

GuildCalendarEvent.cInviteButtonTitle = "Пригласить"
GuildCalendarEvent.cAutoSelectButtonTitle = "Выбрать игроков..."
GuildCalendarEvent.cAutoSelectWindowTitle = "Выбрать игроков"

GuildCalendarEvent.cNoSelection = "Нет выбранных игроков"
GuildCalendarEvent.cSingleSelection = "1 игрок выбран"
GuildCalendarEvent.cMultiSelection = "%d игрока выбраны"

GuildCalendarEvent.cInviteNeedSelectionStatus = "Выбрать для приглашения"
GuildCalendarEvent.cInviteReadyStatus = "Готовы для приглашения"
GuildCalendarEvent.cInviteInitialInvitesStatus = "Отправить приглашение"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "Ожидание приема"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "Конвертировать в рейд"
GuildCalendarEvent.cInviteInvitingStatus = "Рассылка приглашений"
GuildCalendarEvent.cInviteCompleteStatus = "Приглашение закончено"
GuildCalendarEvent.cInviteReadyToRefillStatus = "Заполнения свободных мест готово"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "Нет больше игроков чтобы вступить в группу"
GuildCalendarEvent.cRaidFull = "Рейд полон"

GuildCalendarEvent.cWhisperPrefix = "[Организатор]"
GuildCalendarEvent.cInviteWhisperFormat = "%s Приветствую! Я приглашаю вас для Участия в событии '%s'.  Если вы можете, то прошу принять участие в этом событии."
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s Вы уже в группе :(.  Пожалуйста /w отпишите, когда вы покинете группу."

GuildCalendarEvent.cJoinedGroupStatus = "Присоединен"
GuildCalendarEvent.cInvitedGroupStatus = "Приглашен"
GuildCalendarEvent.cReadyGroupStatus = "Готов"
GuildCalendarEvent.cGroupedGroupStatus = "В другой группе"
GuildCalendarEvent.cStandbyGroupStatus = "Резерв"
GuildCalendarEvent.cMaybeGroupStatus = "Возможно"
GuildCalendarEvent.cDeclinedGroupStatus = "Отклонил приглашение"
GuildCalendarEvent.cOfflineGroupStatus = "Не в сети"
GuildCalendarEvent.cLeftGroupStatus = "Покинул группу"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "Авто подтвердить по классу"
GuildCalendarEvent.cRoleConfirmationTitle = "Авто подтвердить по роли"
GuildCalendarEvent.cManualConfirmationTitle = "Ручное подтверждение"
GuildCalendarEvent.cClosedEventTitle = "Закрытое событие"
GuildCalendarEvent.cMinLabel = "мин"
GuildCalendarEvent.cMaxLabel = "макс"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "Макс размер группы:"
GuildCalendarEvent.cMinPartySizeLabel = "Мин размер группы:"
GuildCalendarEvent.cNoMinimum = "Нет минимума"
GuildCalendarEvent.cNoMaximum = "Не ограничено"
GuildCalendarEvent.cPartySizeFormat = "%d игроков"

GuildCalendarEvent.cAddPlayerTitle = "Добавить..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "Настройки..."

GuildCalendarEvent.cClassLimitDescription = "В области ниже, установите минимальное и максимальное количество каждого класса. Игроки не попавшие в лимит автоматически попадают в резерв. Дополнительные места будут заполнены в порядке ответа до достижения максимума."
GuildCalendarEvent.cRoleLimitDescription = "В области ниже, установите минимальное и максимальное количество каждой роли.  Игроки не попавшие в лимит автоматически попадают в резерв. Дополнительные места будут заполнены в порядке ответа до достижения максимума..  Вы можете по выбору установить число минимума классов по роли (запрашивая одного удаленного дамагера шадов приста для примера)"

GuildCalendarEvent.cPriorityLabel = "Приоритет:"
GuildCalendarEvent.cPriorityDate = "Дата"
GuildCalendarEvent.cPriorityRank = "Ранг"

GuildCalendarEvent.cCachedEventStatus = "This event is a cached copy from $Name's calendar\rLast refreshed on $Date at $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "Друиды"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "Охотники"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "Маги"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "Паладины"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "Жрецы"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "Разбойники"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "Шаманы"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "Чернокнижники"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "Воины"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "Death Knights"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Current party or raid"

GuildCalendarEvent.cViewByFormat = "View by %s / %s"

GuildCalendarEvent.cConfirm = "Confirm"

GuildCalendarEvent.cSingleTimeDateFormat = "%s\r%s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s\rc %s до %s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00Присоединен",
	CONFIRMED = "|cff88ff00Готов",
	STANDBY = "|cffffff00Резерв",
	INVITED = "|cff00ff00Приглашен",
	DECLINED = "|cffff0000Отклонил приглашение",
	BUSY = "|cffff0000В другой группе",
	OFFLINE = "|cff888888Не в сети",
	LEFT = "|cff0000ffПокинул группу",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "Об Организаторе %s"
GuildCalendarEvent.cAboutAuthor = "Разработал и написал аддон John Stephen"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "Добавить игрока..."
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

GuildCalendarEvent.cUnknown = "Неизвестно"

-- Invite tab

GuildCalendarEvent.cModeratorTooltipTitle = "Moderator"
GuildCalendarEvent.cModeratorTooltipDescription = "Turn this on to allow this player or group to co-manage your event"

-- Main window

GuildCalendarEvent.cCalendar = "Календарь"
GuildCalendarEvent.cSettings = "Установки"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "О Аддоне"

GuildCalendarEvent.cUseServerDateTime = "Дата и Время сервера"
GuildCalendarEvent.cUseServerDateTimeDescription = "Включите, для использования серверного время и даты для событий, либо выключите, чтобы использовалось локальное время и дата"
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

end -- ruRU
