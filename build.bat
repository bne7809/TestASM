@echo off

if "%~1"=="" (
    echo Error: missing parameter.
    exit /b 1
)

set MSRCS=src\main.cpp src\remcrt.cpp
set ASRCS=src\%1.asm

set CFlags=/O2 /DUNICODE /D_UNICODE /Iinclude /W3 /WX /Gy /GR- /EHs- /EHc- /D_HAS_EXCEPTIONS=0 /GS- /Gs9999999
set LFlags=/NODEFAULTLIB /STACK:0x100000,0x100000 /SUBSYSTEM:CONSOLE /OPT:REF /OPT:ICF /INCREMENTAL:NO

set LLibs=kernel32.lib
set AOBJS=obj\%1.obj

ml64 /c /Iinc\ /Foobj\ src\%1.asm
cl %MSRCS% %AOBJS% %CFlags% /Zi /DEBUG /Foobj\ /link %LFlags% %LLibs%

@echo on
