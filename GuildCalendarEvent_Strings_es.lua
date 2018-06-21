----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "esES" then

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

GuildCalendarEvent.cForeignRealmFormat = "%s de %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s y %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} y %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "General"
GuildCalendarEvent.cPersonalEventGroup = "Personal (no se comparte)"
GuildCalendarEvent.cRaidEventGroup = "Bandas (Azeroth)"
GuildCalendarEvent.cTBCRaidEventGroup = "Bandas (Terrallende)"
GuildCalendarEvent.cWotLKRaidEventGroup = "Bandas (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "Mazmorras (Azeroth)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "Mazmorras (Terrallende)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "Mazmorras (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "Heroicas (Terrallende)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "Heroicas (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "JcJ"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Encuentros de Banda"

GuildCalendarEvent.cMeetingEventName = "Cita"
GuildCalendarEvent.cBirthdayEventName = "Cumpleaños"
GuildCalendarEvent.cRoleplayEventName = "Roleo"
GuildCalendarEvent.cHolidayEventName = "Día de fiesta"
GuildCalendarEvent.cDentistEventName = "Dentista"
GuildCalendarEvent.cDoctorEventName = "Médico"
GuildCalendarEvent.cVacationEventName = "Vacaciones"
GuildCalendarEvent.cOtherEventName = "Otros"

GuildCalendarEvent.cCooldownEventName = "%s disponible"

GuildCalendarEvent.cPersonalEventOwner = "Privado"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "Ninguno"

GuildCalendarEvent.cAvailableMinutesFormat = "%s en %d minutos"
GuildCalendarEvent.cAvailableMinuteFormat = "%s en %d minuto"
GuildCalendarEvent.cStartsMinutesFormat = "%s comienza en %d minutos"
GuildCalendarEvent.cStartsMinuteFormat = "%s comienza en %d minuto"
GuildCalendarEvent.cStartingNowFormat = "%s esta comenzando ahora"
GuildCalendarEvent.cAlreadyStartedFormat = "%s ya ha comenzado"
GuildCalendarEvent.cHappyBirthdayFormat = "¡Feliz cumpleaños %s!"

GuildCalendarEvent.cLocalTimeNote = "(%s local)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "Curandero"
GuildCalendarEvent.cTRole = "Tanque"
GuildCalendarEvent.cRRole = "Distancia"
GuildCalendarEvent.cMRole = "C. a cuerpo"

GuildCalendarEvent.cHPluralRole = "Curanderos"
GuildCalendarEvent.cTPluralRole = "Tanques"
GuildCalendarEvent.cRPluralRole = "Distancia"
GuildCalendarEvent.cMPluralRole = "C a cuerpo"

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

GuildCalendarEvent.cLevelRangeFormat = "Niveles %i a %i"
GuildCalendarEvent.cMinLevelFormat = "Niveles %i y más"
GuildCalendarEvent.cMaxLevelFormat = "Hasta el nivel %i" --Q Revisar "Up to level" Posible mala traduccion
GuildCalendarEvent.cAllLevels = "Todos los niveles"
GuildCalendarEvent.cSingleLevel = "Solo nivel %i"

GuildCalendarEvent.cYes = "¡Si! Asistiré a este evento"
GuildCalendarEvent.cNo = "No asistiré a este evento"
GuildCalendarEvent.cMaybe = "Quizás. Ponme en la lista de espera"

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
GuildCalendarEvent.cTimeLabel = "Hora:"
GuildCalendarEvent.cDurationLabel = "Duración:"
GuildCalendarEvent.cEventLabel = "Evento:"
GuildCalendarEvent.cTitleLabel = "Título:"
GuildCalendarEvent.cLevelsLabel = "Niveles:"
GuildCalendarEvent.cLevelRangeSeparator = "a"
GuildCalendarEvent.cDescriptionLabel = "Descripción:"
GuildCalendarEvent.cCommentLabel = "Comentario:"
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

GuildCalendarEvent.cPluralMinutesFormat = "%d minutos"
GuildCalendarEvent.cSingularHourFormat = "%d hora"
GuildCalendarEvent.cPluralHourFormat = "%d horas"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d hora %d minutos"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d horas %d minutos"

GuildCalendarEvent.cNewerVersionMessage = "Hay una nueva versión disponible (%s)"

GuildCalendarEvent.cDelete = "Eliminar"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Grupo por"
GuildCalendarEvent.cViewByStatus = "Estado"
GuildCalendarEvent.cViewByClass = "Clase"
GuildCalendarEvent.cViewByRole = "Papel"
GuildCalendarEvent.cViewSortBy = "Ordenar por"
GuildCalendarEvent.cViewByDate = "Fecha"
GuildCalendarEvent.cViewByRank = "Rango"
GuildCalendarEvent.cViewByName = "Nombre"

GuildCalendarEvent.cInviteButtonTitle = "Invitar Seleccionado"
GuildCalendarEvent.cAutoSelectButtonTitle = "Seleccionar Jugadores..."
GuildCalendarEvent.cAutoSelectWindowTitle = "Seleccionar Jugadores"

GuildCalendarEvent.cNoSelection = "No hay jugadores seleccionados"
GuildCalendarEvent.cSingleSelection = "1 jugador seleccionado"
GuildCalendarEvent.cMultiSelection = "%d jugadores seleccionados"

GuildCalendarEvent.cInviteNeedSelectionStatus = "Selecciona jugadores a invitar"
GuildCalendarEvent.cInviteReadyStatus = "Listo para invitar"
GuildCalendarEvent.cInviteInitialInvitesStatus = "Enviando invitaciones iniciales"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "Esperando aceptación inicial"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "Conviritendo a banda"
GuildCalendarEvent.cInviteInvitingStatus = "Enviando invitaciones"
GuildCalendarEvent.cInviteCompleteStatus = "Invitaciones completas"
GuildCalendarEvent.cInviteReadyToRefillStatus = "Listo para llenar los huecos vacantes"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "No hay más personajes disponibles para completar el grupo"
GuildCalendarEvent.cRaidFull = "Banda completa"

GuildCalendarEvent.cWhisperPrefix = "[Guild Event Calendar]"
GuildCalendarEvent.cInviteWhisperFormat = "%s Estas siendo invitado al evento '%s'.  Por favor acepta la invitación si deseas unirte a este evento."
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s Ya estas en un grupo.  Porfavor vuelve a susurrarme(/su) cuando dejes tu grupo."

GuildCalendarEvent.cJoinedGroupStatus = "Unido"
GuildCalendarEvent.cInvitedGroupStatus = "Invitado"
GuildCalendarEvent.cReadyGroupStatus = "Preparado"
GuildCalendarEvent.cGroupedGroupStatus = "En otro grupo"
GuildCalendarEvent.cStandbyGroupStatus = "Reserva"
GuildCalendarEvent.cMaybeGroupStatus = "Quizás"
GuildCalendarEvent.cDeclinedGroupStatus = "Invitación Rechazada"
GuildCalendarEvent.cOfflineGroupStatus = "Desconectado"
GuildCalendarEvent.cLeftGroupStatus = "Abandono Grupo"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "Autoconfirmar clase"
GuildCalendarEvent.cRoleConfirmationTitle = "Autoconfirmar papel"
GuildCalendarEvent.cManualConfirmationTitle = "Confirmaciones manuales"
GuildCalendarEvent.cClosedEventTitle = "Evento Cerrado"
GuildCalendarEvent.cMinLabel = "mín"
GuildCalendarEvent.cMaxLabel = "máx"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "Máx tamaño grupo:"
GuildCalendarEvent.cMinPartySizeLabel = "Mín tamaño grupo:"
GuildCalendarEvent.cNoMinimum = "Sin mín"
GuildCalendarEvent.cNoMaximum = "Sin máx"
GuildCalendarEvent.cPartySizeFormat = "%d jugadores"

GuildCalendarEvent.cAddPlayerTitle = "Agregar..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "Configuración..."

GuildCalendarEvent.cClassLimitDescription = "Usa los campos de abajo para definir el mínimo y el máximo número de cada clase.  Las clases que aun no hayan alcanzado el minimo se rellenaraán primero, el resto de huecos se irán completando en orden de respuesta hasta que el máximo se alcance."
GuildCalendarEvent.cRoleLimitDescription = "Usa los campos de abajo para definir el mínimo y el máximo número de cada papel.  Los papeles (tanque, curandero, etc) que aun no hayan alcanzado el minimo se rellenaraán primero, el resto de huecos se irán completando en orden de respuesta hasta que el máximo se alcance.  Opcionalmente puedes definir el número de cada clase dentro de cada papel (requerido un dps a distancia que sea sacerdote de sombras, por ejemplo)"

GuildCalendarEvent.cPriorityLabel = "Prioridad:"
GuildCalendarEvent.cPriorityDate = "Fecha"
GuildCalendarEvent.cPriorityRank = "Rango"

GuildCalendarEvent.cCachedEventStatus = "This event is a cached copy from $Name's calendar\rLast refreshed on $Date at $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "Druidas"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "Cazadores"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "Magos"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "Paladines"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "Sacerdotes"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "Pícaros"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "Chamanes"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "Brujos"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "Guerreros"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "Death Knights"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Current party or raid"

GuildCalendarEvent.cViewByFormat = "View by %s / %s"

GuildCalendarEvent.cConfirm = "Confirm"

GuildCalendarEvent.cSingleTimeDateFormat = "%s\r%s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s\rfrom %s a %s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00unido",
	CONFIRMED = "|cff88ff00preparado",
	STANDBY = "|cffffff00reserva",
	INVITED = "|cff00ff00invitado",
	DECLINED = "|cffff0000invitación rechazada",
	BUSY = "|cffff0000en otro grupo",
	OFFLINE = "|cff888888desconectado",
	LEFT = "|cff0000ffabandono grupo",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "Acerca de Guild Event Calendar %s"
GuildCalendarEvent.cAboutAuthor = "Diseñado y escrito por John Stephen"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "Agregar jugador..."
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

GuildCalendarEvent.cUnknown = "Desconocido"

-- Main window

GuildCalendarEvent.cCalendar = "Calendario"
GuildCalendarEvent.cSettings = "Configuración"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "Acerca de"

GuildCalendarEvent.cUseServerDateTime = "Usar fecha y hora del servidor"
GuildCalendarEvent.cUseServerDateTimeDescription = "Activa para mostrar los eventos usando la fecha y hora del servidor, desactiva para usar tu fecha y hora local"
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

end -- esES
