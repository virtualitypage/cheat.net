@echo off

python --version
pip install pyinstaller
python.exe -m pip install --upgrade pip
pip install pdfminer.six

echo pyinstaller pdfminer.six installed!
pause