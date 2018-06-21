----------------------------------------
-- Guild Event Calendar 5 Copyright 2005 - 2016 John Stephen, wobbleworks.com
-- All rights reserved, unauthorized redistribution is prohibited
----------------------------------------

if GetLocale() == "deDE" then

GuildCalendarEvent.cTitle = "Guild Event Calendar %s"
GuildCalendarEvent.cCantReloadUI = "You must completely restart WoW to upgrade to this version of Guild Event Calendar"

GuildCalendarEvent.cHelpHeader = "Guild Event Calendar Befehle"
GuildCalendarEvent.cHelpHelp = "Zeige diese Liste von Befehlen"
GuildCalendarEvent.cHelpReset = "Alle gespeicherten Daten und Einstellungen zurücksetzen"
GuildCalendarEvent.cHelpDebug = "Debugcode aktivieren/deaktivieren"
GuildCalendarEvent.cHelpClock = "Zeit des lokalen Computers oder des Servers auf der Minimap-Uhr anzeigen"
GuildCalendarEvent.cHelpiCal = "iCal Exportdaten erzeugen (Default ist 'all')"
GuildCalendarEvent.cHelpReminder = "Erinnerungen aktivieren/deaktivieren"
GuildCalendarEvent.cHelpBirth = "Geburtstagsankündigungen aktivieren/deaktivieren"
GuildCalendarEvent.cHelpAttend = "Teilnahmeerinnerungen aktivieren/deaktivieren"
GuildCalendarEvent.cHelpShow = "Guild Event Calendar Fenster anzeigen"

GuildCalendarEvent.cTooltipScheduleItemFormat = "%s (%s)"

GuildCalendarEvent.cForeignRealmFormat = "%s von %s"

GuildCalendarEvent.cSingleItemFormat = "%s"
GuildCalendarEvent.cTwoItemFormat = "%s und %s"
GuildCalendarEvent.cMultiItemFormat = "%s{{, %s}} und %s"

-- Event names

GuildCalendarEvent.cGeneralEventGroup = "Allgemein"
GuildCalendarEvent.cPersonalEventGroup = "Persönlich"
GuildCalendarEvent.cRaidClassicEventGroup = "Raids (Classic)"
GuildCalendarEvent.cTBCRaidEventGroup = "Raids (Scherbenwelt)"
GuildCalendarEvent.cWotLKRaidNEventGroup = "Raids (WotLK)"
GuildCalendarEvent.cDungeonEventGroup = "Instanzen (Classic)"
GuildCalendarEvent.cOutlandsDungeonEventGroup = "Instanzen (Scherbenwelt)"
GuildCalendarEvent.cWotLKDungeonEventGroup = "Instanzen (WotLK)"
GuildCalendarEvent.cOutlandsHeroicDungeonEventGroup = "Heroisch (Scherbenwelt)"
GuildCalendarEvent.cWotLKHeroicDungeonEventGroup = "Heroisch (WotLK)"
GuildCalendarEvent.cBattlegroundEventGroup = "PvP"
GuildCalendarEvent.cOutdoorRaidEventGroup = "Raids im Freien"

GuildCalendarEvent.cMeetingEventName = "Treffen"
GuildCalendarEvent.cBirthdayEventName = "Geburtstag"
GuildCalendarEvent.cRoleplayEventName = "Rollenspiel"
GuildCalendarEvent.cHolidayEventName = "Feiertag"
GuildCalendarEvent.cDentistEventName = "Zahnarzt"
GuildCalendarEvent.cDoctorEventName = "Doktor"
GuildCalendarEvent.cVacationEventName = "Urlaub"
GuildCalendarEvent.cOtherEventName = "Anderes"

GuildCalendarEvent.cCooldownEventName = "%s verfügbar"

GuildCalendarEvent.cPersonalEventOwner = "Privat"
GuildCalendarEvent.cBlizzardOwner = "Blizzard"

GuildCalendarEvent.cNone = "Keines"

GuildCalendarEvent.cAvailableMinutesFormat = "%s in %d Minuten"
GuildCalendarEvent.cAvailableMinuteFormat = "%s in %d Minute"
GuildCalendarEvent.cStartsMinutesFormat = "%s startet in %d Minuten"
GuildCalendarEvent.cStartsMinuteFormat = "%s startet in %d Minute"
GuildCalendarEvent.cStartingNowFormat = "%s startet jetzt"
GuildCalendarEvent.cAlreadyStartedFormat = "%s hat bereits begonnen"
GuildCalendarEvent.cHappyBirthdayFormat = "Herzlichen Glückwunsch zum Geburtstag %s!"

GuildCalendarEvent.cLocalTimeNote = "(%s Lokalzeit)"
GuildCalendarEvent.cServerTimeNote = "(%s server)"

-- Roles

GuildCalendarEvent.cHRole = "Heiler"
GuildCalendarEvent.cTRole = "Tank"
GuildCalendarEvent.cRRole = "Fernkämpfer"
GuildCalendarEvent.cMRole = "Nahkämpfer"

GuildCalendarEvent.cHPluralRole = "Heiler"
GuildCalendarEvent.cTPluralRole = "Tanks"
GuildCalendarEvent.cRPluralRole = "Fernkämpfer"
GuildCalendarEvent.cMPluralRole = "Nahkämpfer"

GuildCalendarEvent.cHPluralLabel = GuildCalendarEvent.cHPluralRole..":"
GuildCalendarEvent.cTPluralLabel = GuildCalendarEvent.cTPluralRole..":"
GuildCalendarEvent.cRPluralLabel = GuildCalendarEvent.cRPluralRole..":"
GuildCalendarEvent.cMPluralLabel = GuildCalendarEvent.cMPluralRole..":"

-- iCalendar export

GuildCalendarEvent.cExportTitle = "Export to iCalendar"
GuildCalendarEvent.cExportSummary = "Addons können leider nicht direkt auf Deinen Computer schreiben, deswegen sind für einen ICalender Datenexport ein paar einfache Schritte notwendig, die Du selbst durchführen musst:"
GuildCalendarEvent.cExportInstructions =
{
	"Step 1: "..HIGHLIGHT_FONT_COLOR_CODE.."Wähle die zu exportierenden Events aus",
	"Step 2: "..HIGHLIGHT_FONT_COLOR_CODE.."Kopiere den Text aus dem Datenfeld",
	"Step 3: "..HIGHLIGHT_FONT_COLOR_CODE.."Erstelle ein neues File mit einem beliebigen Texteditor und kopiere den Text hinein",
	"Step 4: "..HIGHLIGHT_FONT_COLOR_CODE.."Speichere das File mit der Filextension '.ics' (z.B. Calendar.ics)",
	RED_FONT_COLOR_CODE.."WICHTIG: "..HIGHLIGHT_FONT_COLOR_CODE.."Das File muss unbedingt als 'plain Text' gespeichert werden, andernfalls ist es nicht verwendbar",
	"Step 5: "..HIGHLIGHT_FONT_COLOR_CODE.."Importiere das File in Deine Kalenderapplikation",
}

GuildCalendarEvent.cPrivateEvents = "Private Events"
GuildCalendarEvent.cGuildEvents = "Gildenevents"
GuildCalendarEvent.cHolidays = "Urlaub"
GuildCalendarEvent.cTradeskills = "Fertigkeitencooldowns"
GuildCalendarEvent.cPersonalEvents = "Pers. Events"
GuildCalendarEvent.cAlts = "Alts"
GuildCalendarEvent.cOthers = "Sonstige"

GuildCalendarEvent.cExportData = "Daten"

-- View tab

GuildCalendarEvent.cLevelRangeFormat = "Levels %i bis %i"
GuildCalendarEvent.cMinLevelFormat = "Ab Level %i"
GuildCalendarEvent.cMaxLevelFormat = "Bis Level %i"
GuildCalendarEvent.cAllLevels = "Alle Level"
GuildCalendarEvent.cSingleLevel = "Nur Level %i"

GuildCalendarEvent.cYes = "Ja - Ich werde teilnehmen"
GuildCalendarEvent.cNo = "Nein - Ich werde nicht teilnehmen"
GuildCalendarEvent.cMaybe = "Ich nehme vielleicht teil"

GuildCalendarEvent.cStatusFormat = "Status: %s"
GuildCalendarEvent.cInvitedByFormat = "Eingeladen von %s"

GuildCalendarEvent.cInvitedStatus = "Eingeladen, warte auf Deine Antwort"
GuildCalendarEvent.cAcceptedStatus = "Akzeptiert, warte auf Bestätigung"
GuildCalendarEvent.cTentativeStatus = "Vielleicht, warte auf Bestätigung"
GuildCalendarEvent.cDeclinedStatus = "Teilnahme abgelehnt"
GuildCalendarEvent.cConfirmedStatus = "Bestätigt"
GuildCalendarEvent.cOutStatus = CALENDAR_STATUS_OUT
GuildCalendarEvent.cStandbyStatus = "Bestätigt, auf standby"
GuildCalendarEvent.cSignedUpStatus = CALENDAR_STATUS_SIGNEDUP
GuildCalendarEvent.cNotSignedUpStatus = CALENDAR_STATUS_NOT_SIGNEDUP

GuildCalendarEvent.cAllDay = "ganztags"

GuildCalendarEvent.cEventModeLabel = "Art:"
GuildCalendarEvent.cTimeLabel = "Uhrzeit:"
GuildCalendarEvent.cDurationLabel = "Dauer:"
GuildCalendarEvent.cEventLabel = "Event:"
GuildCalendarEvent.cTitleLabel = "Titel:"
GuildCalendarEvent.cLevelsLabel = "Levels:"
GuildCalendarEvent.cLevelRangeSeparator = "bis"
GuildCalendarEvent.cDescriptionLabel = "Beschreibung:"
GuildCalendarEvent.cCommentLabel = "Kommentar:"
GuildCalendarEvent.cRepeatLabel = "Wiederholung:"
GuildCalendarEvent.cAutoConfirmLabel = "Autom. Bestätigung"
GuildCalendarEvent.cLockoutLabel = "Autom.Schliessen"
GuildCalendarEvent.cEventClosedLabel = "Anmeldungen geschlossen"
GuildCalendarEvent.cAutoConfirmRoleLimitsTitle = "Limits autom. bestätigen"
GuildCalendarEvent.cAutoConfirmLimitsLabel = "Limits..."
GuildCalendarEvent.cNormalMode = "Privates Event"
GuildCalendarEvent.cAnnounceMode = "Gildenankündigung"
GuildCalendarEvent.cSignupMode = "Gildenevent"

GuildCalendarEvent.cLockout0 = "zu Beginn"
GuildCalendarEvent.cLockout15 = "15 Minuten zu früh"
GuildCalendarEvent.cLockout30 = "30 Minuten zu früh"
GuildCalendarEvent.cLockout60 = "1 Stunde zu früh"
GuildCalendarEvent.cLockout120 = "2 Stunden zu früh"
GuildCalendarEvent.cLockout180 = "3 Stunden zu früh"
GuildCalendarEvent.cLockout1440 = "1 Tag zu früh"

GuildCalendarEvent.cPluralMinutesFormat = "%d Minuten"
GuildCalendarEvent.cSingularHourFormat = "%d Stunde"
GuildCalendarEvent.cPluralHourFormat = "%d Stunden"
GuildCalendarEvent.cSingularHourPluralMinutes = "%d Stunde %d Minuten"
GuildCalendarEvent.cPluralHourPluralMinutes = "%d Stunden %d Minuten"

GuildCalendarEvent.cNewerVersionMessage = "Eine neue Version ist verfügbar (%s)"

GuildCalendarEvent.cDelete = "Löschen"

-- Event Group tab

GuildCalendarEvent.cViewGroupBy = "Gruppieren nach"
GuildCalendarEvent.cViewByStatus = "Status"
GuildCalendarEvent.cViewByClass = "Klasse"
GuildCalendarEvent.cViewByRole = "Aufgabe"
GuildCalendarEvent.cViewSortBy = "Sortiere nach"
GuildCalendarEvent.cViewByDate = "Datum"
GuildCalendarEvent.cViewByRank = "Rang"
GuildCalendarEvent.cViewByName = "Name"

GuildCalendarEvent.cInviteButtonTitle = "Ausgewählte einladen"
GuildCalendarEvent.cAutoSelectButtonTitle = "Spieler wählen..."
GuildCalendarEvent.cAutoSelectWindowTitle = "Spieler wählen"

GuildCalendarEvent.cNoSelection = "Keine Spieler gewählt"
GuildCalendarEvent.cSingleSelection = "1 Spieler gewählt"
GuildCalendarEvent.cMultiSelection = "%d Spieler gewählt"

GuildCalendarEvent.cInviteNeedSelectionStatus = "Wähle Spieler für Einladung"
GuildCalendarEvent.cInviteReadyStatus = "Bereit zum Einladen"
GuildCalendarEvent.cInviteInitialInvitesStatus = "Sende erste Einladungen"
GuildCalendarEvent.cInviteAwaitingAcceptanceStatus = "Warte auf erste Rückmeldungen"
GuildCalendarEvent.cInviteConvertingToRaidStatus = "Umwandeln in Schlachtzug"
GuildCalendarEvent.cInviteInvitingStatus = "Sende Einladungen"
GuildCalendarEvent.cInviteCompleteStatus = "Einladungen komplett"
GuildCalendarEvent.cInviteReadyToRefillStatus = "Bereit, leere Plätze zu füllen"
GuildCalendarEvent.cInviteNoMoreAvailableStatus = "Keine weiteren Spieler verfügbar"
GuildCalendarEvent.cRaidFull = "Schlachtzug voll"

GuildCalendarEvent.cWhisperPrefix = "[Guild Event Calendar]"
GuildCalendarEvent.cInviteWhisperFormat = "%s Du bist eingeladen zum Event '%s'.  Bitte nimm die Einladung an, wenn du am Event teilnehmen willst."
GuildCalendarEvent.cAlreadyGroupedWhisper = "%s Du bist bereits in einer Gruppe.  Bitte flüstere mich an, wenn du die Gruppe verlassen hast."

GuildCalendarEvent.cJoinedGroupStatus = "Beigetreten"
GuildCalendarEvent.cInvitedGroupStatus = "Eingeladen"
GuildCalendarEvent.cReadyGroupStatus = "Bereit"
GuildCalendarEvent.cGroupedGroupStatus = "In anderer Gruppe"
GuildCalendarEvent.cStandbyGroupStatus = CALENDAR_STATUS_STANDBY
GuildCalendarEvent.cMaybeGroupStatus = "Vielleicht"
GuildCalendarEvent.cDeclinedGroupStatus = "Einladung abgewiesen"
GuildCalendarEvent.cOfflineGroupStatus = "Offline"
GuildCalendarEvent.cLeftGroupStatus = "Gruppe verlassen"

GuildCalendarEvent.cTotalLabel = "Total:"

GuildCalendarEvent.cAutoConfirmationTitle = "Automatische Bestätigung"
GuildCalendarEvent.cRoleConfirmationTitle = "Automatische Bestätigung durch Aufgabe"
GuildCalendarEvent.cManualConfirmationTitle = "Manuelle Bestätigung"
GuildCalendarEvent.cClosedEventTitle = "Event geschlossen"
GuildCalendarEvent.cMinLabel = "min"
GuildCalendarEvent.cMaxLabel = "max"

GuildCalendarEvent.cStandby = "Standby"

-- Limits dialog

GuildCalendarEvent.cMaxPartySizeLabel = "Maximale Gruppengröße:"
GuildCalendarEvent.cMinPartySizeLabel = "Minimale Gruppengröße:"
GuildCalendarEvent.cNoMinimum = "Kein Minimum"
GuildCalendarEvent.cNoMaximum = "Kein Maximum"
GuildCalendarEvent.cPartySizeFormat = "%d Spieler"

GuildCalendarEvent.cAddPlayerTitle = "Hinzu.."
GuildCalendarEvent.cAutoConfirmButtonTitle = "Optionen..."

GuildCalendarEvent.cClassLimitDescription = "Benutze die Felder, um die minimale und maximale Anzahl Spieler pro Klasse festzulegen.  Klassen, die das Minimum nicht erreicht haben, werden zuerst aufgefüllt. Danach werden noch freie Plätze in Anmeldereihenfolge vergeben."
GuildCalendarEvent.cRoleLimitDescription = "Benutze die Felder um die minimale und maximale Anzahl Spieler pro Aufgabe festzulegen.  Aufgaben, die das Minimum nicht erreicht haben, werden zuerst aufgefüllt. Danach werden noch freie Plätze in Anmeldereihenfolge vergeben.  Optional kannst Du die minimale Anzahl jeder Klasse für eine bestimmt Aufgabe festlegen (zum Beispiel: Es wird mindestens ein Schattenpriester als Fernkämpfer benötigt)"

GuildCalendarEvent.cPriorityLabel = "Priorität:"
GuildCalendarEvent.cPriorityDate = "Datum"
GuildCalendarEvent.cPriorityRank = "Rang"

GuildCalendarEvent.cCachedEventStatus = "Dieses Event ist eine gecachte Kopie von $Name's Kalender\rzuletzt upgedatet am $Date um $Time"

-- Class names

GuildCalendarEvent.cClassName =
{
	DRUID = {Male = LOCALIZED_CLASS_NAMES_MALE.DRUID, Female = LOCALIZED_CLASS_NAMES_FEMALE.DRUID, Plural = "Druiden"},
	HUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.HUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.HUNTER, Plural = "Jäger"},
	MAGE = {Male = LOCALIZED_CLASS_NAMES_MALE.MAGE, Female = LOCALIZED_CLASS_NAMES_FEMALE.MAGE, Plural = "Magier"},
	PALADIN = {Male = LOCALIZED_CLASS_NAMES_MALE.PALADIN, Female = LOCALIZED_CLASS_NAMES_FEMALE.PALADIN, Plural = "Paladine"},
	PRIEST = {Male = LOCALIZED_CLASS_NAMES_MALE.PRIEST, Female = LOCALIZED_CLASS_NAMES_FEMALE.PRIEST, Plural = "Priester"},
	ROGUE = {Male = LOCALIZED_CLASS_NAMES_MALE.ROGUE, Female = LOCALIZED_CLASS_NAMES_FEMALE.ROGUE, Plural = "Schurken"},
	SHAMAN = {Male = LOCALIZED_CLASS_NAMES_MALE.SHAMAN, Female = LOCALIZED_CLASS_NAMES_FEMALE.SHAMAN, Plural = "Schamanen"},
	WARLOCK = {Male = LOCALIZED_CLASS_NAMES_MALE.WARLOCK, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARLOCK, Plural = "Hexenmeister"},
	WARRIOR = {Male = LOCALIZED_CLASS_NAMES_MALE.WARRIOR, Female = LOCALIZED_CLASS_NAMES_FEMALE.WARRIOR, Plural = "Krieger"},
	DEATHKNIGHT = {Male = LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEATHKNIGHT, Plural = "Todesritter"},
	MONK = {Male = LOCALIZED_CLASS_NAMES_MALE.MONK, Female = LOCALIZED_CLASS_NAMES_FEMALE.MONK, Plural = "Monks"},
	DEMONHUNTER = {Male = LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, Female = LOCALIZED_CLASS_NAMES_FEMALE.DEMONHUNTER, Plural = "Demon Hunters"},
}

GuildCalendarEvent.cCurrentPartyOrRaid = "Dzt. Gruppe oder Raid"

GuildCalendarEvent.cViewByFormat = "Anzeigen nach %s / %s"

GuildCalendarEvent.cConfirm = "Bestätigen"

GuildCalendarEvent.cSingleTimeDateFormat = "%s\r%s"
GuildCalendarEvent.cTimeDateRangeFormat = "%s\r%s bis %s"

GuildCalendarEvent.cStartEventHelp = "Start drücken, um mit Gruppen- oder Raidbildung zu beginnen"
GuildCalendarEvent.cResumeEventHelp = "Weiter drücken, um mit Gruppen- oder Raidbildung fortzufahren"

GuildCalendarEvent.cShowClassReservations = "Reservierungen >>>"
GuildCalendarEvent.cHideClassReservations = "<<< Reservierungen"

GuildCalendarEvent.cInviteStatusText =
{
	JOINED = "|cff00ff00beigetreten",
	CONFIRMED = "|cff88ff00bestätigt",
	STANDBY = "|cffffff00standby",
	INVITED = "|cff00ff00eingeladen",
	DECLINED = "|cffff0000Einladung abgewiesen",
	BUSY = "|cffff0000in anderer Gruppe",
	OFFLINE = "|cff888888offline",
	LEFT = "|cff0000ffGruppe verlassen",
}

GuildCalendarEvent.cStart = "Start"
GuildCalendarEvent.cPause = "Pause"
GuildCalendarEvent.cResume = "Weiter"
GuildCalendarEvent.cRestart = "Restart"

-- About tab

GuildCalendarEvent.cAboutTitle = "Über Guild Event Calendar %s"
GuildCalendarEvent.cAboutAuthor = "Entworfen und programmiert von John Stephen"
GuildCalendarEvent.cAboutThanks = "Herzlichen Dank an alle Fans und Unterstützer. Ich hoffe meine Addons bereiten Euch ebenso viel Freude im Spiel wie es mir Freude macht, sie zu entwickeln."

-- Partners tab

-- Partners tab

GuildCalendarEvent.cPartnersTitle = "Gildenpartnerschaften"
GuildCalendarEvent.cPartnersHelp =
[[
<html><body>
<h1>Gildenpartnerschaften machen es einfach, gemeinsame Events mehreren Gilden zur Verfügung zu stellen, indem die jeweiligen Mitgliederlisten (Name, Rang, Klasse und Level) zwischen befreundeten Gilden ausgetauscht werden. Die gesharten Mitgliederlisten scheinen dann im "Einladen" Bereich Deines Events auf, wo dann entweder selektive oder Masseneinladungen von Spielern aus der Partnergilde vorgenommen werden können.<br/><br/></h1>
<h2>Um eine Gildenpartnerschaft zu erstellen, gehe bitte wie folgt vor:<br/><br/></h2>
<p>* Du und ein Spieler der Partnergilde müssen die aktuelle Version von Guild Event Calendar 5 installiert und aktiviert haben<br/>
* Beide Spieler müssen den "Partnerschaften" Bereich im Guild Event Calendar geöffnet haben<br/>
* Einer der beiden Spieler beginnt das Erstellen einer Gildenpartnerschaft durch das Hinzufügen des anderen Spielers im Fenster und der Bestätigung durch die Schaltfläche unten.<br/>
* Der andere Spieler erhält danach eine entsprechende Meldung und wird um Bestätigung gebeten. Danach werden die Mitgliederlisten der beiden Gilden ausgetauscht und die Gildenpartnerschaft erstellt.</p>
<h1><br/>Die Mitgliederlisten werden dann automatisch überprüft und bei Bedarf neu synchronisiert. Um Performanceprobleme zu verhindern, findet während Kämpfen keine Synchronisation statt.</h1>
</body></html>
]]

GuildCalendarEvent.cPartnersLabel = NORMAL_FONT_COLOR_CODE.."Partner:"..FONT_COLOR_CODE_CLOSE.." %s"
GuildCalendarEvent.cSync = "Sync"

GuildCalendarEvent.cConfirmDeletePartnerGuild = "Bist Du sicher, die Partnerschaft mit der Gilde <%s> zu löschen ?"
GuildCalendarEvent.cConfirmDeletePartner = "Bist Du sicher, dass Du %s aus der Liste Deiner Partner entfernen willst ?"
GuildCalendarEvent.cConfirmPartnerRequest = "%s würde gerne eine Partnerschaft mit Dir einrichten."

GuildCalendarEvent.cLastPartnerUpdate = "Zuletzt synchronisiert am %s um %s Uhr"
GuildCalendarEvent.cNoPartnerUpdate = "nicht synchronisiert"

GuildCalendarEvent.cPartnerStatus =
{
	PARTNER_SYNC_CONNECTING = "Verbinde mit %s",
	PARTNER_SYNC_CONNECTED = "Synchronisiere mit %s",
}

-- Settings tab

GuildCalendarEvent.cSettingsTitle = "Einstellungen"
GuildCalendarEvent.cThemeLabel = "Thema"
GuildCalendarEvent.cParchmentThemeName = "Pergament"
GuildCalendarEvent.cLightParchmentThemeName = "Light Pergament"
GuildCalendarEvent.cSeasonalThemeName = "Saisonal"
GuildCalendarEvent.cTwentyFourHourTime = "24 Stunden Anzeige"
GuildCalendarEvent.cAnnounceBirthdays = "Geburtstagserinnerungen anzeigen"
GuildCalendarEvent.cAnnounceEvents = "Ereigniserinnungen anzeigen"
GuildCalendarEvent.cAnnounceTradeskills = "Fertigkeitenerinnerungen anzeigen"
GuildCalendarEvent.cRecordTradeskills = "Fertigkeitencooldowns aufzeichnen"
GuildCalendarEvent.cRememberInvites = "Remember event invitations for use in future events"

GuildCalendarEvent.cUnderConstruction = "Dieser Bereich befindet sich noch in Entwicklung"

GuildCalendarEvent.cUnknown = "Unbekannt"

-- Main window

GuildCalendarEvent.cCalendar = "Kalender"
GuildCalendarEvent.cSettings = "Einstellungen"
GuildCalendarEvent.cPartners = "Gildenpartnerschaften"
GuildCalendarEvent.cExport = "Export"
GuildCalendarEvent.cAbout = "Über"

GuildCalendarEvent.cUseServerDateTime = "Benutze Server-Zeitformat"
GuildCalendarEvent.cUseServerDateTimeDescription = "Aktivieren, um Events im Server-Zeitformat anzuzeigen. Deaktivieren, um Events im lokalen Zeitformat anzuzeigen."
GuildCalendarEvent.cShowCalendarLabel = "Zeige:"
GuildCalendarEvent.cShowAlts = "Alts anzeigen"
GuildCalendarEvent.cShowAltsDescription = "Einschalten, um gecachte Events von Ihren anderen Charakteren zu zeigen"
GuildCalendarEvent.cShowDarkmoonCalendarDescription = "Einschalten, um die Termine des Dunkelmondjahrmarkts zu zeigen"
GuildCalendarEvent.cShowWeeklyCalendarDescription = "Einschalten, um wöchentliche Termine (z.B. Anglerwettbewerb) zu zeigen"
GuildCalendarEvent.cShowPvPCalendarDescription = "Einschalten, um die Termine der PvP Wochenende zu zeigen"
GuildCalendarEvent.cShowLockoutCalendarDescription = "Einschalten, um aktive Dungeonresets anzuzeigen"

GuildCalendarEvent.cMinimapButtonHint = "Links klicken, um Guild Event Calendar anzuzeigen."
GuildCalendarEvent.cMinimapButtonHint2 = "Rechts klicken, um WoW Kalender anzuzeigen."

GuildCalendarEvent.cNewEvent = "Neues Event..."
GuildCalendarEvent.cPasteEvent = "Event einfügen"

GuildCalendarEvent.cConfirmDelete = "Sind Sie sicher, dass Sie dieses Event löschen wollen? Diese Aktion wird das Event aus allen Kalendern, auch denen von anderen Spielern, löschen."

GuildCalendarEvent.cGermanLocalization = "Deutsche Übersetzung"
GuildCalendarEvent.cChineseLocalization = "Chinesische Übersetzung"
GuildCalendarEvent.cFrenchLocalization = "Französische Übersetzung"
GuildCalendarEvent.cSpanishLocalization = "Spanische Übersetzung"
GuildCalendarEvent.cRussianLocalization = "Russische Übersetzung"
GuildCalendarEvent.cContributingDeveloper = "Mitwirkender Entwickler"
GuildCalendarEvent.cGuildCreditFormat = "Die Gilde %s"

GuildCalendarEvent.cExpiredEventNote = "Dieses Ereignis ist bereits vorbei und kann nicht mehr geändert werden."

GuildCalendarEvent.cMore = "mehr..."

GuildCalendarEvent.cRespondedDateFormat = "Geantwortet %s"

GuildCalendarEvent.cStartDayLabel = "Start week on:"

end -- deDE
