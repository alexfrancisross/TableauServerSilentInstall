@echo off
REM This batch file performs a silent installation of Tableau Server. Tableau Server 10.1 or later is required.
 
REM check for the correct number of arguments  
set argC=0  
for %%x in (%*) do Set /A argC+=1  
if not %argC%==4 goto :error  
  
REM set variables  
REM set EXE= C:\install\TableauServer-64bit-10-1-1.exe
REM set MYPATH= "C:\Program Files\Tableau\Tableau Server\10.1\bin"  
REM set LICENSE= <LICENSE KEY>
REM set REGISTRATION= C:\install\registration.json

set EXE= %1
set MYPATH= %2
set LICENSE= %3
set REGISTRATION= %4
  
REM Run Exe ====  
echo "Installing Tableau Server..."
start /wait /min %EXE% /VERYSILENT /ACCEPTEULA
echo %errorlevel%  

REM Activate Tableau Server ====  
echo "Activating Tableau Server License Key..."
cd %MYPATH%    
start /wait /min tabadmin.exe activate --activate --key %LICENSE%
echo %errorlevel% 

REM Register User Details ====
echo "Registering User Details..."
start /wait /min tabadmin.exe register --file %REGISTRATION% 
echo %errorlevel% 

REM Start Tableau Server ====
echo "Starting Tableau Server..."
start /wait /min tabadmin.exe start
echo %errorlevel% 

REM Create Initial User ====
echo "Creating Initial User..."
start /wait /min tabcmd.exe initialuser --username "admin" --password "admin" --server http://localhost
echo %errorlevel% 

goto :eof  
  
:error  
echo Incorrect number of arguments  
echo "Usage: silentInstall.bat <path to exe> <path to Tableau Server bin> <license key> <path to registration.json file>
echo "Example:" silentInstall.bat C:\install\TableauServer-64bit-10-1-1.exe "C:\Program Files\Tableau\Tableau Server\10.1\bin" XXXX-XXXX-XXXX-XXXX-XXXX C:\install\registration.json
