#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#InstallKeybdHook
#InstallMouseHook
#Persistent

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen

Menu, Tray, Tip, dnCita
If A_IsCompiled
{
  Menu, Tray, NoStandard
  Menu, Tray, Add , Pause, Pau_se
  Menu, Tray, Add , open dnCita.ini, OpenIni
  Menu, Tray, Add , Exit, Exi
  Menu, Tray, Default, Exit
  Menu, Tray, Icon , %A_ScriptName%, 1, 1
}


Global iniFile
Global showAreasToggle
Global bgColor

bgColor=000000
iniFile=dnCita.ini


LButton::checkareas()
!RButton::Gosub,DeleteArea
!LButton::Gosub,RecordArea
!mButton::GoSub,ShowAreas
+LButton::click

#If !A_IsCompiled
F8::exitapp


DeleteArea:
  MouseGetPos, ax, ay
  res=1
  IniRead, res, %iniFile%
  StringSplit, SecArray, res, `n,
  Loop, %secArray0%
  {
      sec := SecArray%a_index%
      IniRead, x1, %iniFile%, %sec%, x1
      IniRead, x2, %iniFile%, %sec%, x2
      IniRead, y1, %iniFile%, %sec%, y1
      IniRead, y2, %iniFile%, %sec%, y2
      If (ax > x1 and ax < x2 and ay > y1 and ay < y2)
      {
        res=0
        IniDelete, %iniFile%, %sec%
        Gui, dnCita%sec%:Destroy
        Break
      }
  }

Return

ShowAreas:
  If !showAreasToggle
  {
    IniRead, res, %iniFile%
    StringSplit, SecArray, res, `n,
    Loop, %secArray0%
    {
      sec := SecArray%a_index%
      IniRead, x1, %iniFile%, %sec%, x1
      IniRead, x2, %iniFile%, %sec%, x2
      IniRead, y1, %iniFile%, %sec%, y1
      IniRead, y2, %iniFile%, %sec%, y2
      a1:=x2-x1
      a2:=y2-y1
      Gui, dnCita%sec%:-Caption -Border -Disabled +AlwaysOnTop
      Gui, dnCita%sec%:Margin, 0, 0
      Gui, dnCita%sec%:Add, Picture, x0 y0, %sec%.jpg
      Gui, dnCita%sec%:Color, %bgColor%
      Gui, dnCita%sec%:Show, x%x1% y%y1% w%a1% h%a2% NoActivate
    }
  }
  If showAreasToggle
  {
    IniRead, res, %iniFile%
    StringSplit, SecArray, res, `n,
    Loop, %secArray0%
    {
      sec := SecArray%a_index%
      Gui, dnCita%sec%:Destroy
    }
  }
  showAreasToggle:=!showAreasToggle
Return

RecordArea:
  MouseGetPos, x1, y1
  Loop
  {
    GetKeyState, s, LButton, P
    If s = U
      break
  }
  MouseGetPos, x2, y2

  If (x2 < x1)
  {
    xt:=x2
    x2:=x1
    x1:=xt
  }
  If (y2 < y1)
  {
    yt:=y2
    y2:=y1
    y1:=yt
  }
  If (x1 <> x2) and (y1 <> y2)
  {
    FormatTime, sec,,yyyyMMddHHmmss
    IniWrite, %x1%, %iniFile%, %sec%, x1
    IniWrite, %x2%, %iniFile%, %sec%, x2
    IniWrite, %y1%, %iniFile%, %sec%, y1
    IniWrite, %y2%, %iniFile%, %sec%, y2
    a1:=x2-x1
    a2:=y2-y1
    Gui, dnCita%sec%:-Caption -Border -Disabled +AlwaysOnTop
    Gui, dnCita%sec%:Margin, 0, 0
    Gui, dnCita%sec%:Color, %bgColor%
    Gui, dnCita%sec%:Show, x%x1% y%y1% w%a1% h%a2% NoActivate
    If !showAreasToggle
    {
      Sleep, 1000
      Gui, dnCita%sec%:Destroy
    }
  }
Return

Exi:
  ExitApp
Return

OpenIni:
  Run, %iniFile%
Return

Pau_se:
  Suspend,Permit
  Pause, Toggle, 1
  Suspend, Toggle
  Menu, Tray, ToggleCheck, Pause
Return

checkareas()
{
  MouseGetPos, ax, ay
  res=1
  IniRead, res, %iniFile%
  StringSplit, SecArray, res, `n,
  Loop, %secArray0%
  {
      sec := SecArray%a_index%
      IniRead, x1, %iniFile%, %sec%, x1
      IniRead, x2, %iniFile%, %sec%, x2
      IniRead, y1, %iniFile%, %sec%, y1
      IniRead, y2, %iniFile%, %sec%, y2
      If (ax > x1 and ax < x2 and ay > y1 and ay < y2)
      {
        res=0
        Break
      }
  }

  If res
  {
    MouseClick,,,,,,D
    Loop
    {
      GetKeyState, s, LButton, P
      If s = U
        break
    }
    MouseClick,,,,,,U
  }
  Else
  {
    SoundBeep,666,64

    m1:=x2-x1 ;box breite
    m2:=y2-y1 ;box höhe
    mc1:=ax-x1 ;x click in der box
    mc2:=ay-y1 ;y click in der box

    If (m1 > m2)
    {
      v:=m1/m2
      p1:=((100*v)/m1)*mc1
      p2:=(100/m2)*mc2
    }
    If (m1 < m2)
    {
      v:=m2/m1
      p1:=(100/m1)*mc1
      p2:=((100*v)/m2)*mc2
    }


    If (p1 <= 50)
    {
      nx:=x1-1
      cx:=mc1
    }
    If (p1 > 50)
    {
      nx:=x2+1
      cx:=m1-mc1
    }
    If (p2 <= 50)
    {
      ny:=y1-1
      cy:=mc2
    }
    If (p2 > 50)
    {
      ny:=y2+1
      cy:=m2-mc2
    }

    If (cx > cy)
      nx:=ax
    If (cx <= cy)
      ny:=ay

    Click %nx% %ny%
    MouseMove,nx,ny
  }
}