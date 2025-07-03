@echo off
setlocal enabledelayedexpansion

color 07

:main
cls
echo === Bounded Divisor Generator ===
echo.

set /p inputNumber="Total: "
set /p n="Count: "
set /p minVal="Min: "
set /p maxVal="Max: "

REM Check if values make sense
set /a minTotal=%minVal% * %n%
set /a maxTotal=%maxVal% * %n%

if %minTotal% gtr %inputNumber% (
    color 4F
    echo [ERROR] Total is too small for given min and count!
    pause
    color 07
    goto main
)
if %maxTotal% lss %inputNumber% (
    color 4F
    echo [ERROR] Total is too large for given max and count!
    pause
    color 07
    goto main
)

:retry
cls
echo Generating numbers
set /a remainingNumber=%inputNumber%
set divisors=
set sum=0
set min=999999
set max=0

REM Loading dots (fake processing)
(for /L %%x in (1,1,15) do (
    <nul set /p=.
    ping -n 1 127.0.0.1 > nul
)) > nul
echo.

for /l %%i in (1,1,%n%) do (
    set "div[%%i]="
)

for /l %%i in (1,1,%n%) do (
    set /a maxAllowed=%maxVal%
    if !remainingNumber! lss %maxVal% set /a maxAllowed=!remainingNumber!
    set /a randRange=maxAllowed - %minVal% + 1
    if !randRange! lss 1 goto retry

    set /a randNum=!random! %% !randRange! + %minVal%
    set "div[%%i]=!randNum!"
    set /a remainingNumber-=!randNum!
)

if !remainingNumber! neq 0 goto retry

for /l %%i in (1,1,%n%) do (
    set "val=!div[%%i]!"
    set /a sum+=val
    if !val! lss !min! set /a min=val
    if !val! gtr !max! set /a max=val
    set "divisors=!divisors!!val!"
    if %%i lss %n% set "divisors=!divisors!,"
)

REM Output results
cls
echo ================================
echo Numbers: !divisors!
echo ----------------
echo Sum: !sum!
echo Min: !min!
echo Max: !max!

if !sum! equ %inputNumber% (
    color 2F
    echo [OK] ✅ Values calculated successfully!
) else (
    color 4F
    echo [ERROR] ❌ Sum mismatch!
)
color 07
echo ================================

:menu
echo.
echo [1] Recalculate with same values
echo [2] Enter new values
echo [3] Exit
set /p choice="Select: "
if "%choice%"=="1" goto retry
if "%choice%"=="2" goto main
if "%choice%"=="3" exit
goto menu
