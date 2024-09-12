@echo off
title Employee Salary Management
color BE
:: "B" sets background color to Light Aqua, "E" sets text color to Light Yellow

:: Define file paths
set "workersFile=%~dp0workers.txt"
set "appSourceFile=%~dp0App_Source.txt"
set "logFile=%~dp0error.log"
set "qrCodeLink=https://github.com/Arthur398-star-of-coding/Money-management-system"

:: Check if workers.txt exists, if not, create it
if not exist "%workersFile%" (
    echo Worker data will be saved to workers.txt
) >nul

:: Check if App Source file exists, if not, create it
if not exist "%appSourceFile%" (
    echo App Source file created.
    echo Code and link will be saved here. > "%appSourceFile%"
) >nul

:menu
cls
echo ========================================
echo        Employee Salary Management
echo ========================================
echo 1. Convert RON to Euro
echo 2. View Workers and Salaries
echo 3. Add Worker
echo 4. Modify Worker Salary
echo 5. Delete Worker
echo 6. Print Project Link and QR Code
echo 7. Erase Data
echo 8. Refresh QR Code
echo 9. Rewrite QR Code Link
echo 10. Exit
echo ========================================
set /p option=Choose an option (1, 2, 3, 4, 5, 6, 7, 8, 9, 10): 

if "%option%"=="1" goto convert
if "%option%"=="2" goto view_workers
if "%option%"=="3" goto add_worker
if "%option%"=="4" goto modify_worker
if "%option%"=="5" goto delete_worker
if "%option%"=="6" goto print_link_qr
if "%option%"=="7" goto erase_data
if "%option%"=="8" goto refresh_qr_code
if "%option%"=="9" goto rewrite_qr_code_link
if "%option%"=="10" goto exit

:convert
cls
set /p name=Enter the worker's name: 
set /p salaryRON=Enter salary in RON: 
set /a salaryEuro=%salaryRON% / 5
echo %name%'s salary is %salaryRON% RON, which equals %salaryEuro% Euros (using conversion rate 1 EUR = 5 RON)
echo.
pause
goto menu

:view_workers
cls
if exist "%workersFile%" (
    type "%workersFile%"
) else (
    echo No workers found.
)
echo.
pause
goto menu

:add_worker
cls
set /p name=Enter the worker's name: 
set /p salary=Enter salary in Euros: 
echo %name%'s salary is %salary% Euros >> "%workersFile%"
echo Worker added successfully and saved to workers.txt.
echo.
pause
goto menu

:modify_worker
cls
set /p worker_name=Enter the name of the worker to modify: 
if not exist "%workersFile%" (
    echo No workers found.
    pause
    goto menu
)

set found=0
(for /f "tokens=1,* delims=:" %%i in ('findstr /n "%worker_name%" "%workersFile%"') do (
    set found=1
    set line_num=%%i
)) >nul

if "%found%"=="0" (
    echo Worker not found.
    pause
    goto menu
)

set /p new_salary=Enter new salary in Euros for %worker_name%: 
(for /f "tokens=1,* delims=:" %%i in ('findstr /n "^" "%workersFile%"') do (
    if %%i equ %line_num% (
        echo %worker_name%'s salary is %new_salary% Euros
    ) else (
        echo %%j
    )
)) > workers.tmp
move workers.tmp "%workersFile%" >nul
echo Worker salary updated successfully.
pause
goto menu

:delete_worker
cls
set /p worker_name=Enter the name of the worker to delete: 
if not exist "%workersFile%" (
    echo No workers found.
    pause
    goto menu
)

set found=0
(for /f "tokens=1,* delims=:" %%i in ('findstr /n "%worker_name%" "%workersFile%"') do (
    set found=1
    set line_num=%%i
)) >nul

if "%found%"=="0" (
    echo Worker not found.
    pause
    goto menu
)

(for /f "tokens=1,* delims=:" %%i in ('findstr /n "^" "%workersFile%"') do (
    if not %%i equ %line_num% echo %%j
)) > workers.tmp
move workers.tmp "%workersFile%" >nul
echo Worker deleted successfully.
pause
goto menu

:print_link_qr
cls
echo ========================================
echo Project Link: %qrCodeLink%
echo ========================================
echo.
echo Generating QR code...
:: Download the QR code using a free API
powershell -Command "Invoke-WebRequest 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=%qrCodeLink%' -OutFile qr_code.png"
start qr_code.png
echo QR Code generated and displayed.

:: Save current code and link to App Source file
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo App Source file updated.
pause
goto menu

:erase_data
cls
echo Erasing all data...
if exist "%workersFile%" (
    del "%workersFile%"
    echo workers.txt deleted.
) else (
    echo No workers.txt found to delete.
)
echo All data erased.
pause
goto menu

:refresh_qr_code
cls
echo Refreshing QR Code link...
:: Save current code and link to App Source file
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo QR Code will be regenerated.
pause
goto print_link_qr

:rewrite_qr_code_link
cls
set /p new_link=Enter the new link for QR Code: 
set "qrCodeLink=%new_link%"
:: Save new link and regenerate QR Code
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo Link updated and QR Code will be regenerated.
pause
goto print_link_qr

:exit
:: Save modifications before exit
cls
echo Exiting and saving modifications...
:: Save current code and link to App Source file
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
:: Copy files if the batch script is moved
:: This needs to be done manually or with additional scripting
echo All modifications saved. Exiting...
exit /b

:: Error logging
:error
echo Error occurred at %date% %time% >> "%logFile%"
echo %errorlevel% >> "%logFile%"
echo Error details: %1 >> "%logFile%"
exit /b
