; 
;   FX Configurator 2.0.5.1 (28-06-2020)
;   Author: alanfox2000
;
#NoEnv
#NoTrayIcon
#Include Class_ScrollGUI.ahk
#Include DockA.ahk
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
ver = 2.0.5.5
ICON = %A_WorkingDir%\FXConfigurator.ico
Menu, Tray, Icon, %ICON%

LFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,1
GFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,2
UIRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,3
SFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,5
MFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,6
EFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,7
KDSFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,8
KDMFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,9
KDEFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,10
OSFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,11
OMFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,12
CompositeSFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,13
CompositeMFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,14
CompositeEFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,15
CompositeKDSFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,16
CompositeKDMFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,17
CompositeKDEFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,18
CompositeOSFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,19
CompositeOMFXRegKey = {d04e05a6-594b-4fb6-a80d-01af5eed7d1d}`,20
ProcessingLFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,1
ProcessingGFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,2
ProcessingSFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,5
ProcessingMFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,6
ProcessingEFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,7
ProcessingKDSFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,8
ProcessingKDMFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,9
ProcessingKDEFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,10
ProcessingOSFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,11
ProcessingOMFXRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,12
;ProcessingSWFallbackRegKey = {d3993a3f-99c2-4402-b5ec-a92a0367664b}`,13
DISABLESYSFXRegKey = {1da5d803-d492-4edd-8c23-e0c0ffee7f0e}`,5

Reg = %A_WinDir%\system32\reg.exe
Regedit = %A_WinDir%\regedit.exe

BackupPath = %A_WorkingDir%\Devices
ProductsPath = %A_WorkingDir%\Products
_Base = %ProductsPath%\Base
_RTKHDA = %ProductsPath%\Realtek-HDA
_RTKUAD = %ProductsPath%\Realtek-UAD
systemprofile = %A_WinDir%\system32\config\systemprofile\Desktop

RenderPath = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render
CapturePath = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture
ConnectorRegKey = {a45c254e-df1c-4efd-8020-67d146a850e0},2
DeviceRegKey = {b3f8fa53-0004-438e-9003-51a46e139bfc},6 
LoadPath = %RenderPath%
DataFlow = Render

if !InStr(FileExist(systemprofile), "D")
{
    FileCreateDir, %systemprofile%
}

Gui, Device: New, +LastFound
Gui, Device:Color, White
Gui Device:Font, s8, Arial
Gui Device:Add, GroupBox, x8 y8 w145 h49, Data Flow
Gui Device:Add, Button, x16 y24 w59 h23 gSetRenderPath, Render
Gui Device:Add, Button, x80 y24 w66 h23 gSetCapturePath, Capture
Gui Device:Add, GroupBox, x160 y8 w743 h49, Endpoints
Gui Device:Add, DropDownList, x168 y24 w567 vDEVTEXT gDropDownListLabel Choose1
Gui Device:Add, Button, x744 y24 w60 h23 gRefresh, Refresh
Gui Device:Add, Button, x816 y24 w80 h23 gCopy, Copy GUID
Gui Device:Font
hForm1 :=WinExist()

Gui, APOGUI:New, +hwndAPOGUI
Gui, APOGUI:Color, White
Gui APOGUI:Font, s8, Arial
Gui APOGUI:Add, CheckBox, x8 y+0 w270 h36 vIsDISABLESYSFX gDisable_SysFx, Disable all Enhacments (Current Selected Endpoint)
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vLFX_text, Local FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vLFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vGFX_text, Global FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h22 vGFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vUI_text, Property Page
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vUI
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vSFX_text, Stream FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vSFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vMFX_text, Mode FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vMFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vEFX_text, Endpoint FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vEFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vKDSFX_text, Keyword Detector Stream FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vKDSFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vKDMFX_text, Keyword Detector Mode FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vKDMFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vKDEFX_text, Keyword Detector Endpoint FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vKDEFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vOSFX_text, Offload Stream FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vOSFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vOMFX_text, Offload Mode FX APO 
Gui APOGUI:Add, Edit, x8 y+0 w270 h21 vOMFX
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeSFX_text, Composite Stream FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeSFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeMFX_text, Composite Mode FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeMFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeEFX_text, Composite Endpoint FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeEFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeSFXKD_text, Composite Keyword Detector Stream FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeKDSFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeMFXKD_text, Composite Keyword Detector Mode FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeKDMFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeEFXKD_text, Composite Keyword Detector Endpoint FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeKDEFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeOSFX_text, Composite Offload Stream FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeOSFX +Multi
Gui APOGUI:Add, Text, x8 y+0 w270 h23 +0x200 vCompositeOMFX_text, Composite Offload Mode FX APO
Gui APOGUI:Add, Edit, x8 y+0 w270 h63 vCompositeOMFX +Multi
Gui APOGUI:Font
Global SG1 := New ScrollGUI(APOGUI, 300, 400, "+LabelAPOGUI -SysMenu +OwnerDevice +LastFound", 3, 4)
hForm2 :=WinExist()

Gui, PROCESSGUI: New, +hwndPROCESSGUI
Gui, PROCESSGUI:Color, White
Gui PROCESSGUI:Font, s8, Arial
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingLFX_text, Local FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingLFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingGFX_text, Global FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingGFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingSFX_text, Stream FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingSFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingMFX_text, Mode FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingMFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingEFX_text, Endpoint FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingEFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w270 h23 +0x200 vProcessingSFXKD_text, Keyword Detector Stream FX Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingKDSFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w270 h23 +0x200 vProcessingMFXKD_text, Keyword Detector Mode FX Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingKDMFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w270 h23 +0x200 vProcessingEFXKD_text, Keyword Detector Endpoint FX Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingKDEFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingOSFX_text, Offload Stream FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingOSFX +Multi
Gui PROCESSGUI:Add, Text, x8 y+0 w200 h23 +0x200 vProcessingOMFX_text, Offload Mode FX APO Processing Modes
Gui PROCESSGUI:Add, Edit, x8 y+0 w270 h63 vProcessingOMFX +Multi
Gui PROCESSGUI:Font
Global SG2 := New ScrollGUI(PROCESSGUI, 300, 400, "+LabelPROCESSGUI -SysMenu +OwnerDevice +LastFound", 3, 4)
hForm3 :=WinExist()

Gui, ACTIONGUI: New, +hwndACTIONGUI
Gui, ACTIONGUI:Color, White
Gui ACTIONGUI:Font, s8, Arial
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h23 +0x200, Endpoint Registry
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h2 0x10
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gJumpToProperties, Jump to Properties Key
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gJumpToFxProperties, Jump to FxProperties Key
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gImport, Import Registry File
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gBackup, Backup
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gRestore, Restore
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gRebuild, Rebuild All Audio Endpoints
Gui ACTIONGUI:Add, DropDownList, x8 y+0 w255 Choose1 vDealProgram gGetDealingProgram, Use Reg Dealing with Registry File|Use Regedit Dealing with Registry File
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h23 +0x200, Effect and Processing Modes Configuraions
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h2 0x10
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gLoad, Load External Config
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gNotesGui, Save Current Config
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gApply_APOConfig, Apply Effect and Processing Modes Configuraions
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h23 +0x200, Tool
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h2 0x10
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gPRODUCTGUI, Product Config Tool
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h23 +0x200, Misc
Gui ACTIONGUI:Add, Text, x8 y+0 w270 h2 0x10
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gServices, >> Restart Windows Audio Service <<
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gRAPOs, Registered APOs
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gSoundCPL, Sound Control Panel
Gui ACTIONGUI:Add, Button, x8 y+0 w255 h23 gSoundMS, ms-settings:sound
Gui ACTIONGUI:Add, Button, x184 y+0 w80 h23 gAboutGui, About
Gui ACTIONGUI:Font
Global SG3 := New ScrollGUI(ACTIONGUI, 300, 400, "+LabelACTIONGUI -SysMenu +OwnerDevice +LastFound", 3, 4)
hForm4 :=WinExist()

Gui, PRODUCTGUI: New, -MinimizeBox -MaximizeBox +OwnerDevice +LastFound
Gui, PRODUCTGUI:Color, White
Gui PRODUCTGUI:Font, s8, Verdana
Gui PRODUCTGUI:Add, DropDownList, x8 y8 w546 gChange_ProductList vProductList, 3rd Effects Only||3rd Effects with Realtek Effects for Realtek UAD|3rd Effects with Realtek Effects for Realtek HDA Driver (Legacy)
Gui PRODUCTGUI:Add, Text, x8 y40 w68 h23 +0x200, Products
Gui PRODUCTGUI:Add, DropDownList, x80 y40 w474 vProductText gRead_Description
Gui PRODUCTGUI:Add, Text, x8 y72 w70 h23 +0x200, Prerequisites
Gui PRODUCTGUI:Add, Text, x88 y72 w305 h23 +0x200 vPrerequisitesText
Gui PRODUCTGUI:Add, Edit, x8 y104 w545 h97 vDescriptionText Multi +ReadOnly
Gui PRODUCTGUI:Add, Button, x8 y208 w545 h23 gApply_ProductSetting, Apply Product Settings to Selected Endpoints
Gui PRODUCTGUI:Font

Gui, NotesGui: New, -SysMenu +OwnerDevice
Gui, NotesGui:Color, White
Gui NotesGui:Font, s9, Arial
Gui NotesGui:Add, Edit, x16 y40 w300 h250 vNotes Multi
Gui NotesGui:Add, Button, x136 y304 w80 h23 gNotesGuiSave, Save
Gui NotesGui:Add, Button, x232 y304 w80 h23 gNotesGuiCancel, Cancel
Gui NotesGui:Font, cGray
Gui NotesGui:Add, Text, x16 y8 w300 h23 +0x200 Center, `;----------- Do Not Allow Including Any Empty Lines -----------;
Gui NotesGui:Font
Gui NotesGui:Font

Gui, AboutGui: New, -SysMenu +OwnerDevice +AlwaysOnTop
Gui, AboutGui:Color, White
Gui AboutGui:Font, s8, Arial
Gui AboutGui:Add, Picture, x8 y16 w64 h64, %ICON%
Gui AboutGui:Add, Text, x88 y16 w150 h23 +0x200, FX Configurator %ver%
Gui AboutGui:Add, Text, x7 y93 w290 h2 0x10
Gui AboutGui:Add, Button, x218 y102 w80 h23 gAboutGuiClose, OK
Gui AboutGui:Add, Link, x88 y44 w200 h23 +0x200, <a href="changelog.txt">Changelog</a>
Gui AboutGui:Add, Link, x88 y64 w200 h23 +0x200, <a href="https://github.com/alanfox2000software/FXConfigurator">Github Page</a>
Gui AboutGui:Font

Gui, Device:Show, w920 h70 x250 y50, FX Configurator
SG1.Show("Effect Configuration")
SG2.Show("Processing Modes Configuration")
SG3.Show("Action")

DockA(hForm1,hForm2,"x() y(1) h()")
DockA(hForm1,hForm3,"x(.5,-.5) y(1) h()")
DockA(hForm1,hForm4,"x(1,-1) y(1) h()")
DockA(hForm1,hForm5,"x() y(1) h()")
DockA(hForm1)
bDockOn :=1
ShowForms(true)
gosub Refresh
gosub Change_ProductList
gosub GetDealingProgram
Return

DeviceGuiEscape:
DeviceGuiClose:
    ExitApp

PRODUCTGUIGuiEscape:
PRODUCTGUIGuiClose:
gosub EnableMainGUI
Gui, PRODUCTGUI:Hide
Return

PRODUCTGUI:
Gui, APOGUI:+Disabled
Gui, PROCESSGUI:+Disabled
Gui, ACTIONGUI:+Disabled
Gui, PRODUCTGUI:Show, w562 h240, Product Config Tool
Return

Change_ProductList:
GuiControl, PRODUCTGUI: +AltSubmit, ProductList
GuiControlGet, ProductListIndex, PRODUCTGUI:, ProductList
If ProductListIndex = 1
{
ProductListPath = %_Base%
} 
else if ProductListIndex = 2
{
ProductListPath = %_RTKUAD%
}
else if ProductListIndex = 3
{
ProductListPath = %_RTKHDA%
}
gosub Read_ProductList
Return

Read_ProductList:
ProductText := ""
GuiControl, PRODUCTGUI:, ProductText, |%ProductText%
Loop, Files, %ProductListPath%\*.ini, F
{
ProductFile%A_Index% = %A_LoopFileName%
IniRead, ProductName%A_Index%, %A_LoopFileFullPath%, ProductName
ProductText .= (( ProductText <> "" ) ? "|" : "" ) ProductName%A_Index%
}
GuiControl, PRODUCTGUI:, ProductText, %ProductText%
GuiControl, PRODUCTGUI:Choose, ProductText, 1
gosub Read_Description
Return

Read_Description:
GuiControl, PRODUCTGUI: +AltSubmit, ProductText
GuiControlGet, ProductTextIndex, PRODUCTGUI:, ProductText
SelectedProduct := ProductFile%ProductTextIndex%
IniRead, DescriptionText, %ProductListPath%\%SelectedProduct%, Description
IniRead, MinOS, %ProductListPath%\%SelectedProduct%, Prerequisites, OS
IniRead, Arch, %ProductListPath%\%SelectedProduct%, Prerequisites, Arch

SearchMain := "[0-9]+.[0-9]+"
SearchMinor := "[0-9]+"
VMain := RegExMatch(MinOS, SearchMain, OSMainVersion)
VMinor := RegExMatch(MinOS, SearchMinor, OSMinorVersion, 5)
If Arch = Both
{
Arch = x86/x64
}
If OSMainVersion = 10.0
{
OSMainText = 10
}
else if ((OSMainVersion = "6.3") AND (OSMinorVersion = "9600"))
{
OSMainText = 8.1
}
else if ((OSMainVersion = "6.2") AND (OSMinorVersion = "9200"))
{
OSMainText = 8
}
else if ((OSMainVersion = "6.1") AND ((OSMinorVersion = "7600") OR (OSMinorVersion = "7601")))
{
OSMainText = 7
}
else if ((OSMainVersion = "6.0") AND ((OSMinorVersion = "6000") OR (OSMinorVersion = "6001") OR (OSMinorVersion = "6002")))
{
OSMainText = Vista
}
else
{
OSMainText = %MinOS%
}
PrerequisitesText = Windows %OSMainText% Build %OSMinorVersion% %Arch%
GuiControl, PRODUCTGUI:, DescriptionText, %DescriptionText%
GuiControl, PRODUCTGUI:, PrerequisitesText, %PrerequisitesText%
Return

Apply_ProductSetting:
PSReg_Render := ""
PSReg_Capture := ""
SplashTextOn, , , Please Wait...
Gui, Device:+Disabled
Gui, PRODUCTGUI:+Disabled

If DataFlow = Render
{
IniRead, PSAPO_Render, %ProductListPath%\%SelectedProduct%, APOConfig, Render
IniRead, PSReg_Render, %ProductListPath%\%SelectedProduct%, Registry, Render

If (PSAPO_Render = "") {
 SplashTextOff
 msgbox, Product Config not for Render Data Flow
 Gui, Device:-Disabled
 Gui, PRODUCTGUI:-Disabled
 Return
}

SelectedFile = %ProductListPath%\APOConfig\%PSAPO_Render%

If !(PSReg_Render = "") {
SelectedRegFile = %ProductListPath%\Registry\%PSReg_Render%
gosub Import_ProductSettings
}

}

If DataFlow = Capture
{

IniRead, PSAPO_Capture, %ProductListPath%\%SelectedProduct%, APOConfig, Capture
IniRead, PSReg_Capture, %ProductListPath%\%SelectedProduct%, Registry, Capture

If (PSAPO_Capture = "") {
 SplashTextOff
 msgbox, Product Config not for Capture Data Flow
 Gui, Device:-Disabled
 Gui, PRODUCTGUI:-Disabled
 Return
}

SelectedFile = %ProductListPath%\APOConfig\%PSAPO_Capture%

If !(PSReg_Capture = "") {
SelectedRegFile = %ProductListPath%\Registry\%PSReg_Capture%
gosub Import_ProductSettings
}

}

gosub INI_Read_APOConfig
gosub GuiWrite
gosub GuiGet
gosub WriteReg
gosub Services
SplashTextOff
gosub Popup_Finish
Gui, Device:-Disabled
Gui, PRODUCTGUI:-Disabled
Return

Apply_APOConfig:
SplashTextOn, , , Please Wait...
gosub DisableMainGUI
gosub GuiGet
gosub WriteReg
SplashTextOff
gosub Popup_Finish
gosub EnableMainGUI
Return

Rebuild:
SplashTextOn, , , Please Wait...
gosub DisableMainGUI
RegDelete, %RenderPath%
RegDelete, %CapturePath%
Runwait, %ComSpec% /c "net stop AudioEndpointBuilder /yes",, Hide
Runwait, %ComSpec% /c "net start AudioEndpointBuilder",, Hide
Runwait, %ComSpec% /c "net start Audiosrv",, Hide
gosub Refresh
SplashTextOff
gosub Popup_Finish
gosub EnableMainGUI
Return

SoundCPL:
Run, %ComSpec% /c "control mmsys.cpl sounds",, Hide
Return

SoundMS:
Run, ms-settings:sound
Return

Services:
Runwait, %ComSpec% /c "net stop Audiosrv /yes",, Hide
Runwait, %ComSpec% /c "net start Audiosrv",, Hide
Return

RAPOS:
RegJump("HKEY_CLASSES_ROOT\AudioEngine\AudioProcessingObjects")
Return

NotesGui:
gosub DisableMainGUI
Gui, NotesGui:Show, w331 h338, Notes
Return

NotesGuiSave:
Gui, Submit, NoHide
gosub GuiGet
FileSelectFile, SelectedFile, S16, %A_Desktop%\ , Save current effect and proessing modes configuration, INI file (*.ini)
SplitPath, SelectedFile, name, dir, ext, name_no_ext, drive
if (ext != "ini") ;if you did not type the extension in the save dialog box it will be added.
{
   SavedFileName=%dir%\%name%.ini
}
else
{
   SavedFileName=%SelectedFile%
}
if ErrorLevel
{
    Return
}
if FileExist(SavedFileName)
{
    FileDelete, %SavedFileName%
}
IniWrite, %LFX%, %SavedFileName%, LFX
IniWrite, %GFX%, %SavedFileName%, GFX
IniWrite, %UI%, %SavedFileName%, UI
IniWrite, %SFX%, %SavedFileName%, SFX
IniWrite, %MFX%, %SavedFileName%, MFX
IniWrite, %EFX%, %SavedFileName%, EFX
IniWrite, %KDSFX%, %SavedFileName%, KDSFX
IniWrite, %KDMFX%, %SavedFileName%, KDMFX
IniWrite, %KDEFX%, %SavedFileName%, KDEFX
IniWrite, %OSFX%, %SavedFileName%, OSFX
IniWrite, %OMFX%, %SavedFileName%, OMFX
IniWrite, %CompositeSFX%, %SavedFileName%, CompositeSFX
IniWrite, %CompositeMFX%, %SavedFileName%, CompositeMFX
IniWrite, %CompositeEFX%, %SavedFileName%, CompositeEFX
IniWrite, %CompositeKDSFX%, %SavedFileName%, CompositeKDSFX
IniWrite, %CompositeKDMFX%, %SavedFileName%, CompositeKDMFX
IniWrite, %CompositeKDEFX%, %SavedFileName%, CompositeKDEFX
IniWrite, %CompositeOSFX%, %SavedFileName%, CompositeOSFX
IniWrite, %CompositeOMFX%, %SavedFileName%, CompositeOMFX
IniWrite, %ProcessingLFX%, %SavedFileName%, ProcessingLFX
IniWrite, %ProcessingGFX%, %SavedFileName%, ProcessingGFX
IniWrite, %ProcessingSFX%, %SavedFileName%, ProcessingSFx
IniWrite, %ProcessingMFX%, %SavedFileName%, ProcessingMFX
IniWrite, %ProcessingEFX%, %SavedFileName%, ProcessingEFX
IniWrite, %ProcessingKDSFX%, %SavedFileName%, ProcessingKDSFx
IniWrite, %ProcessingKDMFX%, %SavedFileName%, ProcessingKDMFX
IniWrite, %ProcessingKDEFX%, %SavedFileName%, ProcessingKDEFX
IniWrite, %ProcessingOSFX%, %SavedFileName%, ProcessingOSFX
IniWrite, %ProcessingOMFX%, %SavedFileName%, ProcessingOMFX
IniWrite, %Notes%, %SavedFileName%, Notes
gosub NotesGuiCancel
Return

NotesGuiCancel:
gosub EnableMainGUI
Gui, NotesGui:Hide
Return

AboutGui:
Gui, Device:+Disabled
Gui, APOGUI:+Disabled
Gui, PROCESSGUI:+Disabled
Gui, ACTIONGUI:+Disabled
Gui, AboutGui:Show, w308 h131, About
return

AboutGuiClose:
Gui, Device:-Disabled
Gui, APOGUI:-Disabled
Gui, PROCESSGUI:-Disabled
Gui, ACTIONGUI:-Disabled
Gui, AboutGui:Hide
Return

DisableMainGUI:
Gui, Device:+Disabled
Gui, APOGUI:+Disabled
Gui, PROCESSGUI:+Disabled
Gui, ACTIONGUI:+Disabled
Return

EnableMainGUI:
Gui, Device:-Disabled
Gui, APOGUI:-Disabled
Gui, PROCESSGUI:-Disabled
Gui, ACTIONGUI:-Disabled
Return

Backup:
gosub DisableMainGUI
FileSelectFile, SelectedRegBackupFile, S16, %BackupPath%\%SelectedGUID%.reg, Backup Current Selected Endpoint Registry Key, Registry file (*.reg)
if ErrorLevel
{
    gosub EnableMainGUI
    Return
}
SplitPath, SelectedRegBackupFile, name, dir, ext, name_no_ext, drive
if (ext != "reg") ;if you did not type the extension in the save dialog box it will be added.
{
   SavedRegBackupFileName=%dir%\%name%.reg
}
else
{
   SavedRegBackupFileName=%SelectedRegBackupFile%
}
if ErrorLevel
{
    gosub EnableMainGUI
    Return
}
gosub GetDealingProgram
If DealProgramIndex = 1
{
Runwait, %ComSpec% /c "%reg% export %LoadPath%\%SelectedGUID% "%SavedRegBackupFileName%" /y",, Hide
}
If DealProgramIndex = 2
{
Runwait, %ComSpec% /c "%regedit% /E "%SavedRegBackupFileName%" %LoadPath%\%SelectedGUID%",, Hide
}
gosub Popup_Finish
gosub EnableMainGUI
Return


Restore:
gosub DisableMainGUI
FileSelectFile, SelectedRegBackupFile,, %BackupPath%, Restore Endpoint Registry, Registry file (*.reg)
if ErrorLevel
{
    gosub EnableMainGUI
    Return
}
FileRead, RegFileContent, %SelectedRegBackupFile%
SearchGUID := "{[a-zA-Z0-9-]+\}"
SearchType := "Audio\\Render"
SearchType2 := "Audio\\Capture"
FoundPos := RegExMatch(RegFileContent, SearchGUID, GUIDStr)
FoundPos2 := RegExMatch(RegFileContent, SearchType)
FoundPos3 := RegExMatch(RegFileContent, SearchType2)

If (FoundPos = "0") or ((FoundPos2 = "0") and (FoundPos3 = "0"))
{
    gosub EnableMainGUI
    Return
}
If FoundPos2 > 0
{
    BackupType = %RenderPath%
}
else if FoundPos3 > 0
{
    BackupType = %CapturePath%
}

Runwait, "%SetACL%" -on "%BackupType%" -ot reg -actn setowner -ownr "n:Administrators",, Hide
Runwait, "%SetACL%" -on "%BackupType%" -ot reg -actn ace -ace "n:Administrators;p:full",, Hide
Runwait, "%SetACL%" -on "%BackupType%" -ot reg -actn ace -ace "n:Users;p:full",, Hide
Runwait, "%SetACL%" -on "%BackupType%\%GUIDStr%" -ot reg -actn setowner -ownr "n:Administrators",, Hide
Runwait, "%SetACL%" -on "%BackupType%\%GUIDStr%" -ot reg -actn ace -ace "n:Administrators;p:full",, Hide
Runwait, "%SetACL%" -on "%BackupType%\%GUIDStr%" -ot reg -actn ace -ace "n:Users;p:full",, Hide
RegDelete, %BackupType%\%GUIDStr%
gosub GetDealingProgram
If DealProgramIndex = 1
{
Runwait, %ComSpec% /c "%reg% import "%SelectedRegBackupFile%"",, Hide
}
If DealProgramIndex = 2
{
Runwait, %ComSpec% /c "%regedit% /S "%SelectedRegBackupFile%"",, Hide
}
gosub Refresh
gosub Popup_Finish
gosub EnableMainGUI
Return

Disable_SysFx:
GuiControlGet, IsDISABLESYSFX, APOGUI:
If IsDISABLESYSFX = 0
{
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %DISABLESYSFXRegKey%
}
If IsDISABLESYSFX = 1
{
RegWrite, REG_DWORD, %LoadPath%\%SelectedGUID%\FxProperties, %DISABLESYSFXRegKey%, 1
}
Return

Refresh:
DEVTEXT := ""
DDLIndex := 0
GuiControl, Device:, DEVTEXT, |%DEVTEXT%
Loop, Reg, %LoadPath%, K
{
    RegRead, DeviceState, %LoadPath%\%A_LoopRegName%, DeviceState
    
    If !(DeviceState = "4" or DeviceState = "268435460" or DeviceState = "536870916" or DeviceState =‭ "805306372"‬)
    {
        DDLIndex :=  % DDLIndex  + 1
        GUID%DDLIndex% = %A_LoopRegName%
        RegRead, Connector, %LoadPath%\%A_LoopRegName%\Properties, %ConnectorRegKey%
        RegRead, Device, %LoadPath%\%A_LoopRegName%\Properties, %DeviceRegKey%
        RegRead, DeviceState, %LoadPath%\%A_LoopRegName%, DeviceState
        gosub DeviceStateToText
        FullTEXT = %DeviceStateText% %Connector% (%Device%) %A_LoopRegName%
        DEVTEXT .= (( DEVTEXT <> "" ) ? "|" : "" ) FullTEXT
    }
}
GuiControl, Device:, DEVTEXT, %DEVTEXT%
GuiControl, Device:Choose, DEVTEXT, 1
Gui, Submit, NoHide
gosub DropDownListLabel
Return

SetRenderPath:
LoadPath = %RenderPath%
DataFlow = Render
gosub Refresh
Return

SetCapturePath:
LoadPath = %CapturePath%
DataFlow = Capture
gosub Refresh
Return

DeviceStateToText:
If (DeviceState = "1" or DeviceState = "268435457" or DeviceState = "536870913" or DeviceState = "805306369")
{
    DeviceStateText = [Active]
    Return
}
If (DeviceState = "2" or DeviceState = "268435458" or DeviceState = "536870914" or DeviceState = "805306370")
{
DeviceStateText = [Disabled]
    Return
}
If (DeviceState = "8" or DeviceState = "268435464" or DeviceState = "536870920" or ‭DeviceState = "805306376")
{
DeviceStateText = [Unplugged]
    Return
}
If (DeviceState = "15" or DeviceState = "268435471" or DeviceState = "536870933" or  DeviceState = "805306380")
{
    DeviceStateText = [All]
    Return
}
Return

DropDownListLabel:
GuiControl, Device: +AltSubmit, DEVTEXT
GuiControlGet, DEVTEXTIndex, Device:, DEVTEXT
SelectedGUID := GUID%DEVTEXTIndex%
gosub GuiClear
gosub Read
Return

GetDealingProgram:
GuiControl, ACTIONGUI: +AltSubmit, DealProgram
GuiControlGet, DealProgramIndex, ACTIONGUI:, DealProgram
Return

JumpToFxProperties:
RegJump("%LoadPath%\%SelectedGUID%\FxProperties")
Return

JumpToProperties:
RegJump("%LoadPath%\%SelectedGUID%\Properties")
Return

GuiClear:
Empty := ""
GuiControl, APOGUI:, LFX, %Empty%
GuiControl, APOGUI:, GFX, %Empty%
GuiControl, APOGUI:, UI, %Empty%
GuiControl, APOGUI:, SFX, %Empty%
GuiControl, APOGUI:, MFX, %Empty%
GuiControl, APOGUI:, EFX, %Empty%
GuiControl, APOGUI:, KDSFX, %Empty%
GuiControl, APOGUI:, KDMFX, %Empty%
GuiControl, APOGUI:, KDEFX, %Empty%
GuiControl, APOGUI:, OSFX, %Empty%
GuiControl, APOGUI:, OMFX, %Empty%
GuiControl, APOGUI:, CompositeSFX, %Empty%
GuiControl, APOGUI:, CompositeMFX, %Empty%
GuiControl, APOGUI:, CompositeEFX, %Empty%
GuiControl, APOGUI:, CompositeKDSFX, %Empty%
GuiControl, APOGUI:, CompositeKDMFX, %Empty%
GuiControl, APOGUI:, CompositeKDEFX, %Empty%
GuiControl, APOGUI:, CompositeOSFX, %Empty%
GuiControl, APOGUI:, CompositeOMFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingLFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingGFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingSFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingMFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingEFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingKDSFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingKDMFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingKDEFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingOSFX, %Empty%
GuiControl, PROCESSGUI:, ProcessingOMFX, %Empty%
GuiControl, NotesGui:, Notes, %Empty%
Return

Read:
RegRead, IsDISABLESYSFX, %LoadPath%\%SelectedGUID%\FxProperties,%DISABLESYSFXRegKey%
If ErrorLevel = 1
{
IsDISABLESYSFX := 0
}
RegRead, LFX, %LoadPath%\%SelectedGUID%\FxProperties, %LFXRegKey%
RegRead, GFX, %LoadPath%\%SelectedGUID%\FxProperties, %GFXRegKey%
RegRead, UI, %LoadPath%\%SelectedGUID%\FxProperties, %UIRegKey%
RegRead, SFX, %LoadPath%\%SelectedGUID%\FxProperties, %SFXRegKey%
RegRead, MFX, %LoadPath%\%SelectedGUID%\FxProperties, %MFXRegKey%
RegRead, EFX, %LoadPath%\%SelectedGUID%\FxProperties, %EFXRegKey%
RegRead, KDSFX, %LoadPath%\%SelectedGUID%\FxProperties, %KDSFXRegKey%
RegRead, KDMFX, %LoadPath%\%SelectedGUID%\FxProperties, %KDMFXRegKey%
RegRead, KDEFX, %LoadPath%\%SelectedGUID%\FxProperties, %KDEFXRegKey%
RegRead, OSFX, %LoadPath%\%SelectedGUID%\FxProperties, %OSFXRegKey%
RegRead, OMFX, %LoadPath%\%SelectedGUID%\FxProperties, %OMFXRegKey%
RegRead, CompositeLFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeLFXRegKey%
RegRead, CompositeGFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeGFXRegKey%
RegRead, CompositeSFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeSFXRegKey%
RegRead, CompositeMFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeMFXRegKey%
RegRead, CompositeEFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeEFXRegKey%
RegRead, CompositeKDSFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDSFXRegKey%
RegRead, CompositeKDMFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDMFXRegKey%
RegRead, CompositeKDEFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDEFXRegKey%
RegRead, CompositeOSFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOSFXRegKey%
RegRead, CompositeOMFX, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOMFXRegKey%
RegRead, ProcessingLFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingLFXRegKey%
RegRead, ProcessingGFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingGFXRegKey%
RegRead, ProcessingSFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingSFXRegKey%
RegRead, ProcessingMFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingMFXRegKey%
RegRead, ProcessingEFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingEFXRegKey%
RegRead, ProcessingKDSFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDSFXRegKey%
RegRead, ProcessingKDMFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDMFXRegKey%
RegRead, ProcessingKDEFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDEFXRegKey%
RegRead, ProcessingOSFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOSFXRegKey%
RegRead, ProcessingOMFX, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOMFXRegKey%
gosub GuiWrite
Return

Load:
gosub DisableMainGUI
FileSelectFile, SelectedFile,, %_Base%\APOConfig , Load Effect Configuration, INI file (*.ini)
if ErrorLevel
{
    gosub EnableMainGUI
    Return
}
IniRead, PreviewNotes, %SelectedFile%, Notes
MsgBox, 0x2024, Notes, Would you like to load this config?`r`r%PreviewNotes%
IfMsgBox, No
{
    gosub EnableMainGUI
    Return
}
IniRead, Notes, %SelectedFile%, Notes
gosub INI_READ_APOConfig
gosub GuiWrite
gosub EnableMainGUI
Return

INI_READ_APOConfig:
IniRead, LFX, %SelectedFile%, LFX
IniRead, GFX, %SelectedFile%, GFX
IniRead, UI, %SelectedFile%, UI
IniRead, SFX, %SelectedFile%, SFX
IniRead, MFX, %SelectedFile%, MFX
IniRead, EFX, %SelectedFile%, EFX
IniRead, KDSFX, %SelectedFile%, KDSFX
IniRead, KDMFX, %SelectedFile%, KDMFX
IniRead, KDEFX, %SelectedFile%, KDEFX
IniRead, OSFX, %SelectedFile%, OSFX
IniRead, OMFX, %SelectedFile%, OMFX
IniRead, CompositeSFX, %SelectedFile%, CompositeSFX
IniRead, CompositeMFX, %SelectedFile%, CompositeMFX
IniRead, CompositeEFX, %SelectedFile%, CompositeEFX
IniRead, CompositeKDSFX, %SelectedFile%, CompositeKDSFX
IniRead, CompositeKDMFX, %SelectedFile%, CompositeKDMFX
IniRead, CompositeKDEFX, %SelectedFile%, CompositeKDEFX
IniRead, CompositeOSFX, %SelectedFile%, CompositeOSFX
IniRead, CompositeOMFX, %SelectedFile%, CompositeOMFX
IniRead, ProcessingLFX, %SelectedFile%, ProcessingLFX
IniRead, ProcessingGFX, %SelectedFile%, ProcessingGFX
IniRead, ProcessingSFX, %SelectedFile%, ProcessingSFX
IniRead, ProcessingMFX, %SelectedFile%, ProcessingMFX
IniRead, ProcessingEFX, %SelectedFile%, ProcessingEFX
IniRead, ProcessingKDSFX, %SelectedFile%, ProcessingKDSFX
IniRead, ProcessingKDMFX, %SelectedFile%, ProcessingKDMFX
IniRead, ProcessingKDEFX, %SelectedFile%, ProcessingKDEFX
IniRead, ProcessingOSFX, %SelectedFile%, ProcessingOSFX
IniRead, ProcessingOMFX, %SelectedFile%, ProcessingOMFX
Return

GuiWrite:
gosub GuiClear
GuiControl, APOGUI:, IsDISABLESYSFX, %IsDISABLESYSFX%
GuiControl, APOGUI:, LFX, %LFX%
GuiControl, APOGUI:, GFX, %GFX%
GuiControl, APOGUI:, UI, %UI%
GuiControl, APOGUI:, SFX, %SFX%
GuiControl, APOGUI:, MFX, %MFX%
GuiControl, APOGUI:, EFX, %EFX%
GuiControl, APOGUI:, KDSFX, %KDSFX%
GuiControl, APOGUI:, KDMFX, %KDMFX%
GuiControl, APOGUI:, KDEFX, %KDEFX%
GuiControl, APOGUI:, OSFX, %OSFX%
GuiControl, APOGUI:, OMFX, %OMFX%
GuiControl, APOGUI:, CompositeSFX, %CompositeSFX%
GuiControl, APOGUI:, CompositeMFX, %CompositeMFX%
GuiControl, APOGUI:, CompositeEFX, %CompositeEFX%
GuiControl, APOGUI:, CompositeKDSFX, %CompositeKDSFX%
GuiControl, APOGUI:, CompositeKDMFX, %CompositeKDMFX%
GuiControl, APOGUI:, CompositeKDEFX, %CompositeKDEFX%
GuiControl, APOGUI:, CompositeOSFX, %CompositeOSFX%
GuiControl, APOGUI:, CompositeOMFX, %CompositeOMFX%
GuiControl, PROCESSGUI:, ProcessingLFX, %ProcessingLFX%
GuiControl, PROCESSGUI:, ProcessingGFX, %ProcessingGFX%
GuiControl, PROCESSGUI:, ProcessingSFX, %ProcessingSFX%
GuiControl, PROCESSGUI:, ProcessingMFX, %ProcessingMFX%
GuiControl, PROCESSGUI:, ProcessingEFX, %ProcessingEFX%
GuiControl, PROCESSGUI:, ProcessingKDSFX, %ProcessingKDSFX%
GuiControl, PROCESSGUI:, ProcessingKDMFX, %ProcessingKDMFX%
GuiControl, PROCESSGUI:, ProcessingKDEFX, %ProcessingKDEFX%
GuiControl, PROCESSGUI:, ProcessingOSFX, %ProcessingOSFX%
GuiControl, PROCESSGUI:, ProcessingOMFX, %ProcessingOMFX%
Return

GuiGet:
GuiControlGet, LFX, APOGUI:
GuiControlGet, GFX, APOGUI:
GuiControlGet, UI, APOGUI:
GuiControlGet, SFX, APOGUI:
GuiControlGet, MFX, APOGUI:
GuiControlGet, EFX, APOGUI:
GuiControlGet, KDSFX, APOGUI:
GuiControlGet, KDMFX, APOGUI:
GuiControlGet, KDEFX, APOGUI:
GuiControlGet, OSFX,, APOGUI:
GuiControlGet, OMFX, APOGUI:
GuiControlGet, CompositeSFX, APOGUI:
GuiControlGet, CompositeMFX, APOGUI:
GuiControlGet, CompositeEFX, APOGUI:
GuiControlGet, CompositeKDSFX, APOGUI:
GuiControlGet, CompositeKDMFX, APOGUI:
GuiControlGet, CompositeKDEFX, APOGUI:
GuiControlGet, CompositeOSFX, APOGUI:
GuiControlGet, CompositeOMFX, APOGUI:
GuiControlGet, ProcessingLFX, PROCESSGUI:
GuiControlGet, ProcessingGFX, PROCESSGUI:
GuiControlGet, ProcessingSFX, PROCESSGUI:
GuiControlGet, ProcessingMFX, PROCESSGUI:
GuiControlGet, ProcessingEFX, PROCESSGUI:
GuiControlGet, ProcessingKDSFX, PROCESSGUI:
GuiControlGet, ProcessingKDMFX, PROCESSGUI:
GuiControlGet, ProcessingKDEFX, PROCESSGUI:
GuiControlGet, ProcessingOSFX, PROCESSGUI:
GuiControlGet, ProcessingOMFX, PROCESSGUI:
Return

WriteReg:
If (LFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %LFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %LFXRegKey%, %LFX%
}
If (GFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %GFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %GFXRegKey%, %GFX%
}
If (UI = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %UIRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %UIRegKey%, %UI%
}
If (SFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %SFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %SFXRegKey%, %SFX%
}
If (MFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %MFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %MFXRegKey%, %MFX%
}
If (EFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %EFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %EFXRegKey%, %EFX%
}
If (KDSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %KDSFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %KDSFXRegKey%, %KDSFX%
}
If (KDMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %KDMFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %KDMFXRegKey%, %KDMFX%
}
If (KDEFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %KDEFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %KDEFXRegKey%, %KDEFX%
}
If (OSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %OSFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %OSFXRegKey%, %OSFX%
}
If (OMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %OMFXRegKey%
}
ELSE {
RegWrite, REG_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %OMFXRegKey%, %OMFX%
}
If (CompositeSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeSFXRegKey%, %CompositeSFX%
}
If (CompositeMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeMFXRegKey%, %CompositeMFX%
}
If (CompositeEFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeEFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeEFXRegKey%, %CompositeEFX%
}

If (CompositeKDSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDSFXRegKey%, %CompositeKDSFX%
}
If (CompositeKDMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDMFXRegKey%, %CompositeKDMFX%
}
If (CompositeKDEFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDEFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeKDEFXRegKey%, %CompositeKDEFX%
}
If (CompositeOSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOSFXRegKey%, %CompositeOSFX%
}
If (CompositeOMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %CompositeOMFXRegKey%, %CompositeOMFX%
}
If (ProcessingLFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingLFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingLFXRegKey%, %ProcessingLFX%
}
If (ProcessingGFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingGFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingGFXRegKey%, %ProcessingGFX%
}
If (ProcessingSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingSFXRegKey%, %ProcessingSFX%
}
If (ProcessingMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingMFXRegKey%, %ProcessingMFX%
}
If (ProcessingEFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingEFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingEFXRegKey%, %ProcessingEFX%
}
If (ProcessingKDSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDSFXRegKey%, %ProcessingKDSFX%
}
If (ProcessingKDMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDMFXRegKey%, %ProcessingKDMFX%
}
If (ProcessingKDEFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDEFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingKDEFXRegKey%, %ProcessingKDEFX%
}
If (ProcessingOSFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOSFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOSFXRegKey%, %ProcessingOSFX%
}
If (ProcessingOMFX = "") {
RegDelete, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOMFXRegKey%
}
ELSE {
RegWrite, REG_MULTI_SZ, %LoadPath%\%SelectedGUID%\FxProperties, %ProcessingOMFXRegKey%, %ProcessingOMFX%
}
Return

Popup_Finish:
MsgBox, 0x2040, FX Configurator, Operation finished. 
Return

Import:
FileSelectFile, SelectedRegFile,, %_Base%\Registry, Import Registry Key, Registry file (*.reg)
if ErrorLevel
{
    Return
}
FileRead, RegFileContent, %SelectedRegFile%
SearchStr := "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\MMDevices\\Audio\\Render\\{[a-zA-Z0-9-]+\}"
SearchStr2 := "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\MMDevices\\Audio\\Capture\\{[a-zA-Z0-9-]+\}"
ReplaceStr = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\%DataFlow%\%SelectedGUID%
NewStr := RegExReplace(RegFileContent, SearchStr, ReplaceStr)
NewStr2 := RegExReplace(NewStr, SearchStr2, ReplaceStr)
FileDelete, %SelectedRegFile%
FileAppend, %NewStr2%, %SelectedRegFile%, UTF-16
gosub GetDealingProgram
If DealProgramIndex = 1
{
Runwait, %ComSpec% /c "%reg% import "%SelectedRegFile%"",, Hide
}
If DealProgramIndex = 2
{
Runwait, %ComSpec% /c "%regedit% /S "%SelectedRegFile%"",, Hide
}
Return

Import_ProductSettings:
FileRead, RegFileContent, %SelectedRegFile%
SearchStr := "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\MMDevices\\Audio\\Render\\{[a-zA-Z0-9-]+\}"
SearchStr2 := "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\MMDevices\\Audio\\Capture\\{[a-zA-Z0-9-]+\}"
ReplaceStr = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\%DataFlow%\%SelectedGUID%
NewStr := RegExReplace(RegFileContent, SearchStr, ReplaceStr)
NewStr2 := RegExReplace(NewStr, SearchStr2, ReplaceStr)
FileDelete, %SelectedRegFile%
FileAppend, %NewStr2%, %SelectedRegFile%, UTF-16
gosub GetDealingProgram
If DealProgramIndex = 1
{
Runwait, %ComSpec% /c "%reg% import "%SelectedRegFile%"",, Hide
}
If DealProgramIndex = 2
{
Runwait, %ComSpec% /c "%regedit% /S "%SelectedRegFile%"",, Hide
}
Return

Copy:
clipboard = %SelectedGUID%
Return

ShowForms(BShow)
    {
    global

    if BShow 
    {
        DockA(hForm1)
    }
    Loop 2
        if BShow
            gui %A_Index%:Show
         else
            gui %A_Index%:Hide
    }

RegJump(RegPath)
{
	;Must close Regedit so that next time it opens the target key is selected
	WinClose, Registry Editor ahk_class RegEdit_RegEdit

	If (SubStr(RegPath, 0) = "\") ;remove trailing "\" if present
		RegPath := SubStr(RegPath, 1, -1)

	;Extract RootKey part of supplied registry path
	Loop, Parse, RegPath, \
	{
		RootKey := A_LoopField
		Break
	}

	;Now convert RootKey to standard long format
	If !InStr(RootKey, "HKEY_") ;If short form, convert to long form
	{
		If RootKey = HKCR
			StringReplace, RegPath, RegPath, %RootKey%, HKEY_CLASSES_ROOT
		Else If RootKey = HKCU
			StringReplace, RegPath, RegPath, %RootKey%, HKEY_CURRENT_USER
		Else If RootKey = HKLM
			StringReplace, RegPath, RegPath, %RootKey%, HKEY_LOCAL_MACHINE
		Else If RootKey = HKU
			StringReplace, RegPath, RegPath, %RootKey%, HKEY_USERS
		Else If RootKey = HKCC
			StringReplace, RegPath, RegPath, %RootKey%, HKEY_CURRENT_CONFIG
	}

	;Make target key the last selected key, which is the selected key next time Regedit runs
	RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
	Run, %A_WinDir%\regedit.exe
}

