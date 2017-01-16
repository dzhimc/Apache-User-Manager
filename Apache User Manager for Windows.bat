REM *** Set the correct paths for the following 3 variables *** :

REM Path for "htpasswd.exe" (include htpasswd.exe in path):
set HTPASSWD_FILE=""
REM Path for user authentication file (AuthUserFile) (include file name in path):
set AUTH_USER_FILE=""
REM Path for group authorization file (AuthGroupFile) (if module used) (include file name in path):
set AUTH_GROUP_FILE=""





@echo off
title Apache User Manager for Windows - dzhimc



:MENU
cls
color 1F
set MENUOPTION=
echo.
echo -------------------------------
echo Apache User Manager for Windows
echo -------------------------------
echo.
echo.
echo 1: Create/update username using MD5 encryption for passwords (default)
echo.
echo 2: Create/update username using BCrypt encryption for passwords
echo    (slower but more secure) (12 rounds)
echo.
echo 3: Delete username
echo.
echo 4: Verify username
echo.
echo 5: List existing users
echo.
echo 6: Modify groups
echo.
echo 7: List existing groups
echo.
echo 0: Exit
echo.
echo.
set /p MENUOPTION=Choose an option (enter number): 
if not defined MENUOPTION (goto MENU)
if "%MENUOPTION%"=="1" (goto CREATEUSER)
if "%MENUOPTION%"=="2" (goto CREATEUSER)
if "%MENUOPTION%"=="3" (goto DELETEUSER)
if "%MENUOPTION%"=="4" (goto VERIFYUSER)
if "%MENUOPTION%"=="5" (goto LISTUSERS)
if "%MENUOPTION%"=="6" (goto MODIFYGROUPS)
if "%MENUOPTION%"=="7" (goto LISTGROUPS)
if "%MENUOPTION%"=="0" (exit)
goto MENU



:CREATEUSER
cls
set A_USERNAME=
echo.
echo Existing users list:
echo.
for /f "tokens=1 delims=:" %%J in ('type %AUTH_USER_FILE%') do echo %%J
echo.
echo.
echo Enter the username to create/update (case sensitive)
set /p A_USERNAME=or press enter to return to menu: 
if not defined A_USERNAME (goto MENU)
for /f "tokens=2 delims= " %%J in ("%A_USERNAME%") do goto USERSPACEERROR
findstr /c:%A_USERNAME% %AUTH_USER_FILE%>nul
echo.
if %ERRORLEVEL%==0 (echo Username already exists, enter new password.)
if %ERRORLEVEL% neq 0 (echo Creating new username.)
echo.
if "%MENUOPTION%"=="1" (%HTPASSWD_FILE% %AUTH_USER_FILE% %A_USERNAME%)
if "%MENUOPTION%"=="2" (%HTPASSWD_FILE% -B -C 12 %AUTH_USER_FILE% %A_USERNAME%)
echo.
echo.
echo *** Update the group authorization file (AuthGroupFile) if required! ***
echo.
echo.
echo Press any key to continue...
pause>nul
goto CREATEUSER



:DELETEUSER
cls
set A_USERNAME=
echo.
echo Existing users list:
echo.
for /f "tokens=1 delims=:" %%J in ('type %AUTH_USER_FILE%') do echo %%J
echo.
echo.
echo Enter the username to delete (case sensitive)
set /p A_USERNAME=or press enter to return to menu: 
if not defined A_USERNAME (goto MENU)
for /f "tokens=2 delims= " %%J in ("%A_USERNAME%") do goto USERSPACEERROR
%HTPASSWD_FILE% -D %AUTH_USER_FILE% %A_USERNAME%
echo.
echo.
echo *** Update the group authorization file (AuthGroupFile) if required! ***
echo.
echo.
echo Press any key to continue...
pause>nul
goto DELETEUSER



:VERIFYUSER
cls
set A_USERNAME=
echo.
echo Existing users list:
echo.
for /f "tokens=1 delims=:" %%J in ('type %AUTH_USER_FILE%') do echo %%J
echo.
echo.
echo Enter the username to verify (case sensitive)
set /p A_USERNAME=or press enter to return to menu: 
if not defined A_USERNAME (goto MENU)
for /f "tokens=2 delims= " %%J in ("%A_USERNAME%") do goto USERSPACEERROR
%HTPASSWD_FILE% -v %AUTH_USER_FILE% %A_USERNAME%
echo.
echo.
echo Press any key to continue...
pause>nul
goto VERIFYUSER



:LISTUSERS
cls
echo.
echo Existing users list:
echo.
for /f "tokens=1 delims=:" %%J in ('type %AUTH_USER_FILE%') do echo %%J
echo.
echo.
echo Press any key to return to menu...
pause>nul
goto MENU



:MODIFYGROUPS
start notepad %AUTH_GROUP_FILE%
goto MENU



:LISTGROUPS
cls
echo.
echo Existing groups list:
echo.
type %AUTH_GROUP_FILE%
echo.
echo.
echo Press any key to return to menu...
pause>nul
goto MENU



:USERSPACEERROR
cls
color 1C
echo.
echo Error!
echo.
echo Username cannot contain spaces.
echo.
echo.
echo Press any key to return...
pause>nul
cls
color 1F
if "%MENUOPTION%"=="1" (goto CREATEUSER)
if "%MENUOPTION%"=="2" (goto CREATEUSER)
if "%MENUOPTION%"=="3" (goto DELETEUSER)
if "%MENUOPTION%"=="4" (goto VERIFYUSER)



REM dzhimc