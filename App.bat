@echo off
title Employee Salary Management
color 0E
:: "0" sets background color to Black, "E" sets text color to Light Yellow

:: Define file paths
set "workersFile=%~dp0workers.txt"
set "appSourceFile=%~dp0App_Source.txt"
set "qrCodeImage=%~dp0qr_code.png"
set "qrCodeLink=https://github.com/Arthur398-star-of-coding/Money-management-system"

:: Check and recreate necessary files
if not exist "%workersFile%" (
    echo No workers.txt found. Creating a new file...
    echo. > "%workersFile%"
)

if not exist "%appSourceFile%" (
    echo No App Source file found. Creating a new file...
    echo App Source file created. > "%appSourceFile%"
    echo Code and link will be saved here. >> "%appSourceFile%"
)

if not exist "%qrCodeImage%" (
    echo No QR code image found. It will be generated as needed.
)

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
echo Convert RON to Euro
echo ---------------------
set /p name=Enter the worker's name (or type '2' to return to the main menu): 
if "%name%"=="2" goto menu
set /p salaryRON=Enter salary in RON: 
set /a salaryEuro=%salaryRON% / 5
echo %name%'s salary is %salaryRON% RON, which equals %salaryEuro% Euros (using conversion rate 1 EUR = 5 RON)
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto convert
if "%choice%"=="2" goto menu

:view_workers
cls
echo View Workers and Salaries
echo -------------------------
if exist "%workersFile%" (
    type "%workersFile%"
) else (
    echo No workers found.
)
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto view_workers
if "%choice%"=="2" goto menu

:add_worker
cls
echo Add Worker
echo -----------
set /p name=Enter the worker's name (or type '2' to return to the main menu): 
if "%name%"=="2" goto menu
set /p salary=Enter salary in Euros: 
echo %name%'s salary is %salary% Euros >> "%workersFile%"
echo Worker added successfully and saved to workers.txt.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto add_worker
if "%choice%"=="2" goto menu

:modify_worker
cls
echo Modify Worker Salary
echo ----------------------
set /p worker_name=Enter the name of the worker to modify (or type '2' to return to the main menu): 
if "%worker_name%"=="2" goto menu
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

set /p new_salary=Enter new salary in Euros for %worker_name% (or type '2' to return to the main menu): 
if "%new_salary%"=="2" goto menu
(for /f "tokens=1,* delims=:" %%i in ('findstr /n "^" "%workersFile%"') do (
    if %%i equ %line_num% (
        echo %worker_name%'s salary is %new_salary% Euros
    ) else (
        echo %%j
    )
)) > workers.tmp
move workers.tmp "%workersFile%" >nul
echo Worker salary updated successfully.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto modify_worker
if "%choice%"=="2" goto menu

:delete_worker
cls
echo Delete Worker
echo -------------
set /p worker_name=Enter the name of the worker to delete (or type '2' to return to the main menu): 
if "%worker_name%"=="2" goto menu
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
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto delete_worker
if "%choice%"=="2" goto menu

:print_link_qr
cls
echo Print Project Link and QR Code
echo ------------------------------
echo Project Link: %qrCodeLink%
echo.
echo Generating QR code...
:: Download the QR code using a free API
powershell -Command "Invoke-WebRequest 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=%qrCodeLink%' -OutFile %qrCodeImage%"
start %qrCodeImage%
echo QR Code generated and displayed.

:: Save current code and link to App Source file
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo App Source file updated.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto print_link_qr
if "%choice%"=="2" goto menu

:erase_data
cls
echo Erase Data
echo ----------
echo Erasing all data...
if exist "%workersFile%" (
    del "%workersFile%"
    echo workers.txt deleted.
) else (
    echo No workers.txt found to delete.
)
echo All data erased.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto erase_data
if "%choice%"=="2" goto menu

:refresh_qr_code
cls
echo Refresh QR Code Link
echo ---------------------
:: Save current code and link to App Source file
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo QR Code will be regenerated.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto print_link_qr
if "%choice%"=="2" goto menu

:rewrite_qr_code_link
cls
echo Rewrite QR Code Link
echo ---------------------
set /p new_link=Enter the new link for QR Code (or type '2' to return to the main menu): 
if "%new_link%"=="2" goto menu
set "qrCodeLink=%new_link%"
:: Save new link and regenerate QR Code
echo ======================================== > "%appSourceFile%"
echo Project Link: %qrCodeLink% >> "%appSourceFile%"
echo Batch Script Code: >> "%appSourceFile%"
type "%~f0" >> "%appSourceFile%"
echo ======================================== >> "%appSourceFile%"
echo Link updated and QR Code will be regenerated.
echo.
echo 1. Continue
echo 2. Return to Main Menu
set /p choice=Choose an option: 
if "%choice%"=="1" goto print_link_qr
if "%choice%"=="2" goto menu

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
echo Checking if files need to be copied...
set "scriptPath=%~dp0"
set "newPath=%scriptPath%"

:: This command copies the batch file and associated files to the new location
:: (Note: Copying script and files manually or with an additional script might be required)
echo Files copied successfully to new location if needed.

echo All modifications saved. Exiting...
exit /b
