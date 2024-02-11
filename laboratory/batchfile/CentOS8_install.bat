@echo off
rem C:\Users\XXXXXのXXX部分(ホームディレクトリのパス)を代入。~9%で9文字目以降の文字列を取得するが、場合によっては正しく取得されないことがある
set "folder=%cd:~9%"
rem 以下のコマンドを実行してWindows Subsystem for Linux(CentOS8)をインストールする
wsl --import CentOS8 C:\Users\%folder%\AppData\Local\Packages\CentOS8 C:\Users\%folder%\rootfs.tar --version 2
wsl -s CentOS8