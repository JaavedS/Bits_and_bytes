:: Winget Update All Apps
:: A script that updates all apps on a windows device where the app can be found on winget
:: Jaaved Singh
:: 2024-12-04
:: v 1.0

@echo off  
:: BatchGotAdmin 
:: Requests admin privileges to ensure winget is able to update apps
:: admin elevation code from https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file/10052222#10052222 
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

setlocal
echo Checking what apps need to be updated 
winget update  

:: asks user if they want to update the apps listed, anything that isn't a Y will close the program
echo :
:prompt
SET /P AREYOUSURE=Are you sure you want to update all these apps(Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

echo :
echo Now updating all listed apps
winget upgrade --all --accept-source-agreements --accept-package-agreements 

echo :
echo Finished updating apps

:END 
:: closes the program in 3 seconds or when user hits any key
echo :
echo Closing program
timeout /t 3
endlocal
