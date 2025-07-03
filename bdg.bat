@echo off
setlocal enabledelayedexpansion

REM Input the total number
set /p inputNumber="Enter a number: "

REM Input the value of n
set /p n="Enter the value of n: "

REM Input min and max values
set /p minVal="Enter minimum value for each number: "
set /p maxVal="Enter maximum value for each number: "

:retry
set /a remainingNumber=%inputNumber%
set divisors=

REM Initialize array
for /l %%i in (1,1,%n%) do (
    set "div[%%i]="
)

REM Fill each number with a random value within min and max
for /l %%i in (1,1,%n%) do (
    set /a maxAllowed=%maxVal%
    if !remainingNumber! lss %maxVal% set /a maxAllowed=!remainingNumber!
    set /a randRange=maxAllowed - %minVal% + 1
    if !randRange! lss 1 goto retry

    set /a randNum=!random! %% !randRange! + %minVal%
    set "div[%%i]=!randNum!"
    set /a remainingNumber-=!randNum!
)

REM If leftover is not 0, retry
if !remainingNumber! neq 0 goto retry

REM Output result
for /l %%i in (1,1,%n%) do (
    set "divisors=!divisors!!div[%%i]!"
    if %%i lss %n% set "divisors=!divisors!,"
)

echo Divisors: !divisors!

echo.
echo Press any key to close...
pause > nul
endlocal
