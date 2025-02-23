#NoEnv
#NoTrayIcon
#SingleInstance Force

if A_IsAdmin
{
    if A_IsCompiled { 
        path_fx_ti := A_ScriptDir . "\FXConfigurator.exe"
    } else {
        path_fx_ti := A_AhkPath . " " . A_ScriptDir . "\FXConfigurator.ahk"
    }
    RunAsTI(path_fx_ti)
	ExitApp
} else {
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

RunAsTI(program)
{
    hr := DllCall("NSudoAPI.dll\NSudoCreateProcess", "Int", 1, "Int", 1, "Int", 5, "Int", 2, "Int", 1, "Int", 0, "Int", 0, "WStr", program)
    if (hr <> 0) { 
        MsgBox Failed to elevate process (Error: %hr%).
    }
}