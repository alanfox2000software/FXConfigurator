/*
    Title: DockA

        Dock AutoHotkey windows.

        Using dock module you can glue windows to an AHK window. Docked windows
        are called Clients and the window that keeps their position relative to
        itself is called the Host. Once Clients are connected to the Host, this
        group of windows will behave like single window - moving, sizing,
        focusing, hiding and other OS events will be handled by the module so
        that the "composite window" behaves like the single window.

        This module is version of Dock module that supports only AHK hosts
        (hence "A" in the name). Unlike Dock module, it doesnt'uses system hook
        to monitor windows changes.

	Function: DockA
 
 	Parameters: 
        hHost	  - Handle of the host GUI. This window must be AHK window.
        hClient	  - Handle of the client GUI.  This window can be any window.
        DockDef   - Dock definition, see below.  To remove dock client pass "-".
        			If you pass empty string, client will be docked to the host
                    according to its current position relative to the host.

	Dock definition:  
        Dock definition is white space separated combination of parameters which
        describe Client's position relative to the Host. Parameters are grouped
        into 4 classes - x, y, w & h parameters. Classes and their parameters
        are optional.

        Syntax: x(hw,cw,dx)  y(hh,ch,dy)  w(hw,dw)  h(hh,dh)

         *  The *x* coordinate of the top, left corner of the client window is
            computed as x(hw,cw,dx) = HostX + hw*HostWidth + cw*ClientWidth + dx

         *  The *Y* coordinate of the top, left corner of the client window is
            computed as y(hh,ch,dy) = HostY + hh*HostHeight + ch*ClientHeight +
            dy

         *  The width *W* of the client window is computed as w(hw,dw) =
            hw*HostWidth + dw

         *  The height *H* of the client window is computed as h(hh,dh) =
            hh*HostHeight + dh

        If you omit any of the class parameters it will default to 0. So, the
        following expressions all have the same effect:
            (start code)
            x(0,0,0) = x(0,0) = x(0,0,) = x(0) = x(0,)= x(0,,) = x() = x(0,,0) = x(,0,0) = x(,,0) = ...
            y(0,1,0) = y(0,1) = y(,1) = y(,1,) = y(,1,0) = ...
            (end)

        Notice that x() is not the same as omitting x entirely. First case is
        equal to x(0,0,0) so it will set Client's X coordinate to be equal as
        Host's. In second case, x coordinate of the client will not be affected
        by the module (client will keep whatever x it has).

    Remarks:
        You can monitor WM_WINDOWPOSCHANGED=0x47 to detect when user move
        clients (if they are movable) in order to update dock properties

    About:
        o Original by majkinetor (no version number)
        o Minor changes to work with all versions of AutoHotkey, including x64
*/
DockA(hHost="",hClient="",DockDef="")
    {
    DockA_(hHost+0,hClient+0,DockDef,"")
    }

DockA_(hHost,hClient,DockDef,hWnd)
    {
    Static
        ;-- Assume static for all variables

    Static Dummy6580

          ;-- Get/SetWindowLong flags
          ,GWL_HWNDPARENT:=-8
                ;-- Note: For the "SetWindowLong" function, this constant name
                ;   is a bit mislabeled.  The function sets or removes the
                ;   owner of a window.  It does not set/remove the parent of the
                ;   window.

          ;-- Messages
          ,WM_MOVE:=0x03

    ;-- Developer call?
    if hClient and (DockDef<>WM_MOVE)
        {
        if not init  ;-- First call
            {
            ;-- Workaround for AutoHotkey Basic
            PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

            ;-- Monitor WM_MOVE message
            ;   Note: This monitor is never turned off.  It stays on until the
            ;   script ends.
            init:=OnMessage(WM_MOVE,A_ThisFunc)
            }

        hHost+=0
        hClient+=0
        if (DockDef="-")  ;-- Undock
            {
            ;-- Relinquish ownership if attached
            if InStr(%hHost%,hClient)
                {
                StringReplace,%hHost%,%hHost%,%A_Space%%hClient%
                DllCall("SetWindowLong" . (A_PtrSize=8 ? "Ptr":"")
                    ,PtrType,hClient
                    ,"Int",GWL_HWNDPARENT
                    ,PtrType,%hClient%_oldparent)
                }

            return
            }

        ;-- Pin to the current relative position
        if (DockDef="")
            {
            WinGetPos hX,hY,,,ahk_id %hHost%
            WinGetPos cX,cY,,,ahk_id %hClient%
            DockDef:="x(0,0," cX - hX ")  y(0,0," cY - hY ")"
            }

        %hClient%_x1:=%hClient%_x2:=%hClient%_y1:=%hClient%_y2:=%hClient%_h1:=%hClient%_w1:=%hClient%_x3:=%hClient%_y3:=%hClient%_h2:=%hClient%_w2:=""
        Loop Parse,DockDef,%A_Space%%A_Tab%
            {
            if A_LoopField is Space
                Continue

            t:=A_LoopField
            c:=SubStr(t,1,1)
            t:=SubStr(t,3,-1)
            StringReplace,t,t,`,,|,UseErrorLevel
            t.=!ErrorLevel ? "||":(ErrorLevel=1 ? "|":"")
            Loop Parse,t,|,%A_Space%%A_Tab%
                %hClient%_%c%%A_Index%:=A_LoopField ? A_LoopField:0
            }

        ;-- Assign ownership
        %hClient%_oldparent:=DllCall("SetWindowLong" . (A_PtrSize=8 ? "Ptr":""),PtrType,hClient,"Int",GWL_HWNDPARENT,PtrType,hHost)
        %hHost% .=(%hHost%="" ? A_Space:"") . hClient . A_Space
        }
   
    if (hHost=0)
        hHost:=hWnd

    if (%hHost%="")
        return

    oldDelay   :=A_WinDelay
    oldCritical:=A_IsCritical
    SetWinDelay -1
    Critical 100

    ;-- Move/Reposition the client with the host window
    WinGetPos hX,hY,hW,hH,ahk_id %hHost%
    Loop Parse,%hHost%,%A_Space%
        {
        if A_LoopField is Space
            Continue

        j:=A_LoopField
        WinGetPos cX,cY,cW,cH,ahk_id %j%
        w:=%j%_w1*hW+%j%_w2
        h:=%j%_h1*hH+%j%_h2
        x:=hX+%j%_x1*hW+%j%_x2*(w ? w:cW)+%j%_x3
        y:=hY+%j%_y1*hH+%j%_y2*(h ? h:cH)+%j%_y3
        WinMove ahk_id %j%,,x,y,w ? w:"",h ? h:""
        }

    SetWinDelay %oldDelay%
    Critical %oldCritical%
    }