@echo off

rem Set the version number of Python to install
set PYTHON_VERSION=3.11.3
set "folder=%cd:~9%"

rem Set the download URL for the Python installer
set DOWNLOAD_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe

rem Download the Python installer
echo Downloading Python %PYTHON_VERSION% installer...
curl -o python-%PYTHON_VERSION%-amd64.exe %DOWNLOAD_URL%

echo install python by clicking python-3.11.3-amd64.exe. check "Add python.exe to PATH" & select "Install Now".
pause