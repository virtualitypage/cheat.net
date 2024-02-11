@echo off

set "folder=%cd:~9%"
set "PYTHON_VERSION=311"
set "PYTHON_DIR=C:\Users\%folder%\AppData\Local\Programs\Python"

echo select "uninstall" on python-3.11.3-amd64.exe ?

IF EXIST "%PYTHON_DIR%" (
    rd /s "%PYTHON_DIR%"
    echo "%PYTHON_DIR% is deleted."
) else (
    echo "%PYTHON_DIR% does not exist."
)

echo you have to remove the environment variable.
pause