----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "frFR" then

GuildCalendarEvent.cTitle = "Guild Event Calendar %s"
GuildCalendarEvent.cCantReloadUI = "Vous devez complètement redémarrer WoW pour effectuer la mise à niveau vers cette version de Guild Event Calendar."

GuildCalendarEvent.cHelpHeader = "Commandes de Guild Event Calendar"
GuildCalendarEvent.cHelpHelp = "Affiche cette liste de commandes"
GuildCalendarEvent.cHelpReset = "Réinitialise toutes les données et paramètres enregistrés"
GuildCalendarEvent.cHelpDebug = "Active ou désactive le code de débogage"
GuildCalendarEvent.cHelpClock = "Définit l'horloge de la minicarte pour afficher l'heure locale ou l'heure du serveur"
GuildCalendarEvent.cHelpiCal = "Generates iCal data (default is 'all')"
GuildCalendarEvent.cHelpReminder = "Active ou désactive les rappels"
GuildCalendarEvent.cHelpBirth = "Active ou désactive les annonces d'anniversaire"
GuildCalendarEvent.cHelpAttend = "Active ou désactive les rappels de présence"
GuildCalendarEvent.cHelpShow = "Affiche la fenêtre du calendrier"

GuildCalendarEvent.cTooltipScheduleItemFormat = "%s (%s)"

GuildCalendarEvent.cForeignRealmFormat = "%s de %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s et %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} et %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "Général"
GuildCalendarEvent.cPersonalEventGroup = "Personnel (non partagé)"
GuildCalendarEvent.cRaidClassicEventGroup = "Raids (Classic)"
GuildCalendarEvent.cTBCRaidEventGroup = "Raids (Burning Crusade)"
GuildCalendarEvent.cWotLKRaidEventGroup = "Raids (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "Dungeons (Classic)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "Donjons (Burning Crusade)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "Donjons (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "Héroïque (Burning Crusade)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "Héroïque (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "Champs de Bataille"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Raids extérieurs"

GuildCalendarEvent.cMeetingEventName = "Réunion"
GuildCalendarEvent.cBirthdayEventName = "Anniversaire"
GuildCalendarEvent.cRoleplayEventName = "Jeu de rôle"
GuildCalendarEvent.cHolidayEventName = "Vacances"
GuildCalendarEvent.cDentistEventName = "Dentiste"
GuildCalendarEvent.cDoctorEventName = "Docteur"
GuildCalendarEvent.cVacationEventName = "Vacances"
GuildCalendarEvent.cOtherEventName = "Autres"

GuildCalendarEvent.cCooldownEventName = "%s disponible"

GuildCalendarEvent.cPersonalEventOwner = "Privé"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "Aucun"

GuildCalendarEvent.cAvailableMinutesFormat = "%s dans %d minutes"
GuildCalendarEvent.cAvailableMinuteFormat = "%s dans %d minutes"
GuildCalendarEvent.cStartsMinutesFormat = "%s commence dans %d minutes"
GuildCalendarEvent.cStartsMinuteFormat = "%s commence dans %d minutes"
GuildCalendarEvent.cStartingNowFormat = "%s commence maintenant"
GuildCalendarEvent.cAlreadyStartedFormat = "%s a déjà commencé"
GuildCalendarEvent.cHappyBirthdayFormat = "Joyeux anniversaire %s!"

GuildCalendarEvent.cLocalTimeNote = "(%s local)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "Soigneur"
GuildCalendarEvent.cTRole = "Tank"
GuildCalendarEvent.cRRole = "DPS Distant"
GuildCalendarEvent.cMRole = "Mêlée"

GuildCalendarEvent.cHPluralRole = "Soigneurs"
GuildCalendarEvent.cTPluralRole = "Tanks"
GuildCalendarEvent.cRPluralRole = "DPS Distants"
GuildCalendarEvent.cMPluralRole = "Mêlées"

GuildCalendarEvent.cHPluralLabel = GuildCalendarEvent.cHPluralRole..":"
GuildCalendarEvent.cTPluralLabel = GuildCalendarEvent.cTPluralRole..":"
GuildCalendarEvent.cRPluralLabel = GuildCalendarEvent.cRPluralRole..":"
GuildCalendarEvent.cMPluralLabel = GuildCalendarEvent.cMPluralRole..":"

-- iCalendar export

GuildCalendarEvent.cExportTitle = "Exporter vers iCalendar"
GuildCalendarEvent.cExportSummary = "Les addons ne peuvent pas écrire des fichiers directement sur votre ordinateur. L'exportation des données iCalendar nécessite donc quelques étapes faciles."
GuildCalendarEvent.cExportInstructions =
{
	"Step 1: "..HIGHLIGHT_FONT_COLOR_CODE.."Sélectionnez les types d'événements à inclure",
	"Step 2: "..HIGHLIGHT_FONT_COLOR_CODE.."Copiez le texte dans la zone Données",
	"Step 3: "..HIGHLIGHT_FONT_COLOR_CODE.."Créez un nouveau fichier en utilisant n'importe quel éditeur de texte et collez-le dans le texte",
	"Step 4: "..HIGHLIGHT_FONT_COLOR_CODE.."Enregistrez le fichier avec une extension '.ics' (ie, Calendar.ics)",
	RED_FONT_COLOR_CODE.."IMPORTANT: "..HIGHLIGHT_FONT_COLOR_CODE.."Vous devez enregistrer le fichier en texte brut ou il ne sera pas utilisable",
	"Step 5: "..HIGHLIGHT_FONT_COLOR_CODE.."Importez le fichier dans votre application de calendrier",
}

GuildCalendarEvent.cPrivateEvents = "Evènements privés"
GuildCalendarEvent.cGuildEvents = "Les événements de guilde"
GuildCalendarEvent.cHolidays = "Vacances"
GuildCalendarEvent.cTradeskills = "Cooldown events"
GuildCalendarEvent.cPersonalEvents = "Événements personnels"
GuildCalendarEvent.cAlts = "Alts"
GuildCalendarEvent.cOthers = "Autres"

GuildCalendarEvent.cExportData = "Data"

-- Event Edit tab

GuildCalendarEvent.cLevelRangeFormat = "Niveaux %i à %i"
GuildCalendarEvent.cMinLevelFormat = "Niveaux %i et +"
GuildCalendarEvent.cMaxLevelFormat = "Jusqu\'au niveau %i"
GuildCalendarEvent.cAllLevels = "Tous niveaux"
GuildCalendarEvent.cSingleLevel = "Niveau %i uniquement"

GuildCalendarEvent.cYes = "Oui! Je participe à cet événement"
GuildCalendarEvent.cNo = "Non. je ne participe pas à cet événement"
GuildCalendarEvent.cMaybe = "Peut-être. Me mettre sur la liste d'attente"

GuildCalendarEvent.cStatusFormat = "Status: %s"
GuildCalendarEvent.cInvitedByFormat = "Invité par %s"

GuildCalendarEvent.cInvitedStatus = "Invité, en attente de votre réponse"
GuildCalendarEvent.cAcceptedStatus = "Accepté, en attente de confirmation"
GuildCalendarEvent.cTentativeStatus = "Provisoire, en attente de confirmation"
GuildCalendarEvent.cDeclinedStatus = CALENDAR_STATUS_DECLINED
GuildCalendarEvent.cConfirmedStatus = CALENDAR_STATUS_CONFIRMED
GuildCalendarEvent.cOutStatus = CALENDAR_STATUS_OUT
GuildCalendarEvent.cStandbyStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cSignedUpStatus = CALENDAR_STATUS_SIGNEDUP
GuildCalendarEvent.cNotSignedUpStatus = CALENDAR_STATUS_NOT_SIGNEDUP

GuildCalendarEvent.cAllDay = "All day"

GuildCalendarEvent.cEventModeLabel = "Mode:"
GuildCalendarEvent.cTimeLabel = "Temps:"
GuildCalendarEvent.cDurationLabel = "Durée:"
GuildCalendarEvent.cEventLabel = "Evénement:"
GuildCalendarEvent.cTitleLabel = "Titre:"
GuildCalendarEvent.cLevelsLabel = "Niveaux:"
GuildCalendarEvent.cLevelRangeSeparator = "à"
GuildCalendarEvent.cDescriptionLabel = "Description:"
GuildCalendarEvent.cCommentLabel = "Commentaire:"
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
GuildCalendarEvent.cSingularHourFormat = "%d heure"
GuildCalendarEvent.cPluralHourFormat = "%d heures"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d heure %d minutes"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d hueres %d minutes"

GuildCalendarEvent.cNewerVersionMessage = "Une nouvelle version est disponible (%s)"

GuildCalendarEvent.cDelete = "Effacer"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Grouper par"
GuildCalendarEvent.cViewByStatus = "Statut"
GuildCalendarEvent.cViewByClass = "Classe"
GuildCalendarEvent.cViewByRole = "Rôle"
GuildCalendarEvent.cViewSortBy = "Trier par"
GuildCalendarEvent.cViewByDate = "Date"
GuildCalendarEvent.cViewByRank = "Rang"
GuildCalendarEvent.cViewByName = "Nom"

GuildCalendarEvent.cInviteButtonTitle = "Inviter sélection"
GuildCalendarEvent.cAutoSelectButtonTitle = "Joueur sélectionné..."
GuildCalendarEvent.cAutoSelectWindowTitle = "Joueurs sélectionnés"

GuildCalendarEvent.cNoSelection = "Pas de joueur sélectionné"
GuildCalendarEvent.cSingleSelection = "1 joueur sélectionné"
GuildCalendarEvent.cMultiSelection = "%d joueurs sélectionnés"

GuildCalendarEvent.cInviteNeedSelectionStatus = "Sélectionnez les joueurs à inviter"
GuildCalendarEvent.cInviteReadyStatus = "Prêt à inviter"
GuildCalendarEvent.cInviteInitialInvitesStatus = "Envoyer les invitations initiales"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "En attente de l'acceptation initiale"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "Changement en raid"
GuildCalendarEvent.cInviteInvitingStatus = "Envoi des invitations"
GuildCalendarEvent.cInviteCompleteStatus = "Invitations terminées"
GuildCalendarEvent.cInviteReadyToRefillStatus = "Prêt à remplir les places vacantes"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "Plus de joueurs disponibles pour remplir les places vacantes"
GuildCalendarEvent.cRaidFull = "Raid complet"

GuildCalendarEvent.cWhisperPrefix = "[Guild Event Calendar]"
GuildCalendarEvent.cInviteWhisperFormat = "%s Vous êtes invité à l\'événement '%s'. Svp acceptez l\'invitation, si vous souhaitez participer à l'événement."
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s Vous êtes déjà dans un groupe. Svp /w de nouveau quand vous avez quitté votre groupe."

GuildCalendarEvent.cJoinedGroupStatus = "Groupé"
GuildCalendarEvent.cInvitedGroupStatus = "Invité"
GuildCalendarEvent.cReadyGroupStatus = "Prêt"
GuildCalendarEvent.cGroupedGroupStatus = "Dans un autre groupe"
GuildCalendarEvent.cStandbyGroupStatus = "En attente"
GuildCalendarEvent.cMaybeGroupStatus = "Peut-être"
GuildCalendarEvent.cDeclinedGroupStatus = "Refuse l\'invitation"
GuildCalendarEvent.cOfflineGroupStatus = "Hors ligne"
GuildCalendarEvent.cLeftGroupStatus = "Quitte le groupe"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "Confirmations automatiques par classe"
GuildCalendarEvent.cRoleConfirmationTitle = "Confirmations automatiques par rôle"
GuildCalendarEvent.cManualConfirmationTitle = "Confirmations manuelles"
GuildCalendarEvent.cClosedEventTitle = "Evénement clos"
GuildCalendarEvent.cMinLabel = "min"
GuildCalendarEvent.cMaxLabel = "max"

GuildCalendarEvent.cStandby = CALENDAR_STATUS_STANDBY

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "Taille Maximum du groupe:"
GuildCalendarEvent.cMinPartySizeLabel = "Taille Minimum du groupe:"
GuildCalendarEvent.cNoMinimum = "Pas de minimum"
GuildCalendarEvent.cNoMaximum = "Pas de maximum"
GuildCalendarEvent.cPartySizeFormat = "%d joueurs"

GuildCalendarEvent.cAddPlayerTitle = "Ajoute le joueur..."
GuildCalendarEvent.cAutoConfirmButtonTitle = "Paramètre..."

GuildCalendarEvent.cClassLimitDescription = "Utilisez les champs ci dessous pour définir les minimums et maximums pour chaque classe. Les classes n'ayant pas atteint leur minimum seront remplie en premier, les places suivantes seront remplies par ordre de réponse."
GuildCalendarEvent.cRoleLimitDescription = "Set the minimum and maximum numbers of players for each role.  Minimums will be met first, extra spots beyond the minimum will be filled until the maximum is reached or the group is full.  You can also reserve spaces within each role for particular classes (requiring one ranged dps to be a shadow priest for example)"

GuildCalendarEvent.cPriorityLabel = "Priorité:"
GuildCalendarEvent.cPriorityDate = "Date"
GuildCalendarEvent.cPriorityRank = "Rang"

GuildCalendarEvent.cCachedEventStatus = "This event is a cached copy from $Name's calendar\rLast refreshed on $Date at $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "Druides"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "Chasseurs"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "Mages"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "Paladins"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "Prêtres"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "Voleurs"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "Chamans"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "Démonistes"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "Guerriers"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "Death Knights"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Current party or raid"

GuildCalendarEvent.cViewByFormat = "View by %s / %s"

GuildCalendarEvent.cConfirm = "Confirm"

GuildCalendarEvent.cSingleTimeDateFormat = "%s\r%s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s\r%s à %s"

GuildCalendarEvent.cStartEventHelp = "Click Start to begin forming your party or raid"
GuildCalendarEvent.cResumeEventHelp = "Click Resume to continue forming your party or raid"

GuildCalendarEvent.cShowClassReservations = "Reservations >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservations"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00groupé",
	CONFIRMED = "|cff88ff00confirmed",
	STANDBY = "|cffffff00en attente",
	INVITED = "|cff00ff00invité",
	DECLINED = "|cffff0000refuse l\'invitation",
	BUSY = "|cffff0000dans un autre groupe",
	OFFLINE = "|cff888888hors ligne",
	LEFT = "|cff0000ffquitte le groupe",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Resume"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "A propos de Guild Event Calendar %s"
GuildCalendarEvent.cAboutAuthor = "Designed and written by John Stephen"
GuildCalendarEvent.cAboutThanks = "Many thanks to all fans and supporters.  I hope my addons add to your gaming enjoyment as much as building them adds to mine."

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Multi-guild partnerships"
GuildCalendarEvent.cPartnersDescription1 = "Multi-guild partnerships make it easy to coordinate events across guilds by sharing guild rosters (name, rank, class and level only) with your partner guilds"
GuildCalendarEvent.cPartnersDescription2 = "To create a partnership, add a player using the Add Player button at the bottom of this window"
GuildCalendarEvent.cAddPlayer = "Ajoute le joueur..."
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

GuildCalendarEvent.cUnknown = "Inconnu"

-- Main window

GuildCalendarEvent.cCalendar = "Calendrier"
GuildCalendarEvent.cSettings = "Configuration"
GuildCalendarEvent.cPartners = "Partners"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "A propos"

GuildCalendarEvent.cUseServerDateTime = "Utiliser les horaires du serveur"
GuildCalendarEvent.cUseServerDateTimeDescription = "Activer pour que les événements utilisent l'heure et la date du serveur, désactiver pour utiliser votre date et heure"
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

end -- frFR
