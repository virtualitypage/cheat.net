@echo off
rem robocopyコマンドでファイルの移動を実行するバッチファイル

rem 移動元ディレクトリの中にあるファイルが対象
set src_dir=D:\Untitled\DCIM\100MEDIA
set dst_dir=E:\HDCL-UT
set log_file=E:\robocopy_log.txt

robocopy "%src_dir%" "%dst_dir%" /mov /s /xd /log:"%log_file%"