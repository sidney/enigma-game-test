  !insertmacro MUI_LANGUAGE "English"
;  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
;  !insertmacro MUI_LANGUAGE "Spanish"
;  !insertmacro MUI_LANGUAGE "Italian"
;  !insertmacro MUI_LANGUAGE "Dutch"
;  !insertmacro MUI_LANGUAGE "Swedish"
;  !insertmacro MUI_LANGUAGE "Finnish"
;  !insertmacro MUI_LANGUAGE "Russian"       
;  !insertmacro MUI_LANGUAGE "Portuguese"
;  !insertmacro MUI_LANGUAGE "Hungarian"
  ;Include language definitions
  !include /NONFATAL "enigma-inst-eng.nsh"
  !include /NONFATAL "enigma-inst-fre.nsh"
  !include /NONFATAL "enigma-inst-ger.nsh"
  !include /NONFATAL "enigma-inst-spa.nsh"
  !include /NONFATAL "enigma-inst-ita.nsh"
  !include /NONFATAL "enigma-inst-dut.nsh"
  !include /NONFATAL "enigma-inst-swe.nsh"
  !include /NONFATAL "enigma-inst-fin.nsh"
  !include /NONFATAL "enigma-inst-rus.nsh"
  !include /NONFATAL "enigma-inst-por.nsh"
  !include /NONFATAL "enigma-inst-hun.nsh"

LangString ProgramDesc ${LANG_ENGLISH} "Enigma is a puzzle game inspired by Oxyd on the Atari ST and Rock'n'Roll on the Amiga. The object of the game is to find uncover pairs of identically colored Oxyd stones.\r\n\r\nSimple? Yes. Easy? Certainly not! Hidden traps, vast mazes, laser beams, and, most of all, countless hairy puzzles usually block your direct way to the Oxyd stones...\r\n\r\nThis wizard guides you through the installation of Enigma."
LangString OldInstallSure ${LANG_ENGLISH} "There's already a Enigma installation in the chosen directory."
LangString OldInstallMaybe ${LANG_ENGLISH} "The directory you chose is not empty."
LangString OldInstallDesc ${LANG_ENGLISH} "Do you want all of its contents to be deleted?"
LangString OldInstallDesc2 ${LANG_ENGLISH} "Your configuration and scores are not affected."
LangString DesktopIcon ${LANG_ENGLISH} "Create desktop symbol"
LangString Documentation ${LANG_ENGLISH} "Documentation"
LangString DeleteUserdata ${LANG_ENGLISH} "Delete the Enigma user data with all your personal configuration and scores, too. Do not select this option while upgrading Enigma. Select it only if you want to get rid of all remanents of Enigma forever!"

LangString ProgramDesc ${LANG_GERMAN} "Enigma ist ein R�tselspiel inspiriert von Oxyd auf dem Atari ST und Rock'n'Roll auf dem Amiga. Das Ziel des Spieles ist es, Paare gleichfarbiger Oxydsteine aufzudecken.\r\n\r\nEinfach? Ja. Leicht? Sicherlich nicht! Versteckte Fallen, riesige Irrg�rten, Laserstrahlen und nicht zuletzt zahllose haarige R�tsel versperren Ihren Weg zu den Oxydsteinen ...\r\n\r\nDieser Assistent f�hrt sie durch die Installation von Enigma."
LangString OldInstallSure ${LANG_GERMAN} "In dem von Ihnen gew�hlten Ordner ist schon eine Enigma Installation."
LangString OldInstallMaybe ${LANG_GERMAN} "Das von Ihnen gew�hlte Verzeichnis ist nicht leer."
LangString OldInstallDesc ${LANG_GERMAN} "Soll der Inhalt des Verzeichnisses gel�scht werden?"
LangString OldInstallDesc2 ${LANG_GERMAN} "Ihre Einstellungen und Scores bleiben dabei erhalten."
LangString DesktopIcon ${LANG_GERMAN} "Erstelle Programmverkn�pfung auf dem Desktop"
LangString Documentation ${LANG_GERMAN} "Dokumentation" ; so k�nnte man die Verkn�pfung im Startmen� nennen
LangString DeleteUserdata ${LANG_GERMAN} "L�sche auch die Enigma Benutzerdaten mit allen pers�nlichen Einstellungen und Scores. Selektieren sie nicht diese Option wenn Sie planen eine neue Enigma Version zu installieren. Nur wenn sie endg�ltig Enigma mit allen Daten deinstallieren wollen, sollten Sie diese Option selektieren."                                    