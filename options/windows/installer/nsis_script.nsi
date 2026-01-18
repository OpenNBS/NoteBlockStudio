; RunnerInstaller.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects,

;--------------------------------
!include MUI2.nsh 

!ifndef FULL_VERSION
!define FULL_VERSION      "1.0.0.0"
!endif
!ifndef SOURCE_DIR
!define SOURCE_DIR        "C:\source\temp\InstallerTest\runner"
!endif
!ifndef INSTALLER_FILENAME
!define INSTALLER_FILENAME    "C:\source\temp\InstallerTest\RunnerInstaller.exe"
!endif

!ifndef MAKENSIS
!define MAKENSIS          "%appdata%\GameMaker-Studio\makensis"
!endif

!ifndef COMPANY_NAME
!define COMPANY_NAME      ""
!endif

!ifndef COPYRIGHT_TXT
!define COPYRIGHT_TXT     "(c)Copyright 2013"
!endif

!ifndef FILE_DESC
!define FILE_DESC         "Created with GameMaker:Studio"
!endif

!ifndef LICENSE_NAME
!define LICENSE_NAME      "License.txt"
!endif

!ifndef ICON_FILE
!define ICON_FILE       "icon.ico"
!endif

!ifndef IMAGE_FINISHED
!define IMAGE_FINISHED      "Runner_finish.bmp"
!endif

!ifndef IMAGE_HEADER
!define IMAGE_HEADER      "Runner_header.bmp"
!endif

!ifndef PRODUCT_NAME
!define PRODUCT_NAME      "Runner"
!endif

!define APP_NAME        "${PRODUCT_NAME}"
!define SHORT_NAME        "${PRODUCT_NAME}"

;;USAGE:
!define MIN_FRA_MAJOR "2"
!define MIN_FRA_MINOR "0"
!define MIN_FRA_BUILD "*"

!addplugindir   "."

;--------------------------------

; The name of the installer
Name "${APP_NAME}"
Caption "${APP_NAME}"
BrandingText "${APP_NAME}"

; The file to write
OutFile "${INSTALLER_FILENAME}"

; The default installation directory
InstallDir "$PROFILE\${APP_NAME}"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKCU "Software\Runner" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin


VIProductVersion "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "FileVersion" "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "ProductVersion" "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=1033 "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "${COPYRIGHT_TXT}"
VIAddVersionKey /LANG=1033 "FileDescription" "${FILE_DESC}"



!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_ICON            "${ICON_FILE}"
!define MUI_WELCOMEFINISHPAGE_BITMAP  "${IMAGE_FINISHED}"
!define MUI_HEADERIMAGE_BITMAP      "${IMAGE_HEADER}"
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH


;--------------------------------

; Pages
!insertmacro MUI_PAGE_LICENSE "${LICENSE_NAME}"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
    # These indented statements modify settings for MUI_PAGE_FINISH
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN_TEXT "Start ${PRODUCT_NAME}"
    !define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_NAME}.exe"
!insertmacro MUI_PAGE_FINISH

Var DirectXSetupError

UninstPage uninstConfirm
UninstPage instfiles

!insertmacro MUI_LANGUAGE "English"
;--------------------------------

; The stuff to install
Section `${APP_NAME}`
  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "${LICENSE_NAME}"
  File /r "${SOURCE_DIR}\*.*"
  
  ; Write the uninstall keys for Windows
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORT_NAME}" "DisplayName" "${APP_NAME}"
  WriteRegStr SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORT_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORT_NAME}" "NoModify" 1
  WriteRegDWORD SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORT_NAME}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\${APP_NAME}"
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\${PRODUCT_NAME}.exe" 
  CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME} License.lnk" "notepad.exe" "$INSTDIR\License.txt"
  
SectionEnd


; Optional section (can be enabled by the user)
Section /o "Desktop shortcut"

  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" ""
  
SectionEnd


;--------------------------------

; Uninstaller

Section "Uninstall"
  ; Remove registry keys
  DeleteRegKey SHCTX "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORT_NAME}"

  ; Remove files and uninstaller (everything)
  RMDir /r "$INSTDIR"

  ; Remove desktop icon
  Delete "$DESKTOP\${APP_NAME}.lnk" 

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\${APP_NAME}\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\${APP_NAME}"
  RMDir "$INSTDIR"

SectionEnd


;--------------------------------
;
; This should be the LAST section available....
;
Section "DirectX Install" SEC_DIRECTX
 
 SectionIn RO
 
 SetOutPath "$TEMP"
 File "${MAKENSIS}\dxwebsetup.exe"
 DetailPrint "Running DirectX Setup..."
 ExecWait '"$TEMP\dxwebsetup.exe" /Q' $DirectXSetupError
 DetailPrint "Finished DirectX Setup"
 
 Delete "$TEMP\dxwebsetup.exe"
 
 SetOutPath "$INSTDIR"
 
SectionEnd