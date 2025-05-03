@echo off
rem robocopyコマンドでファイルの移動を実行するバッチファイル

rem 移動元ディレクトリの中にあるファイルが対象
set date=%date:~0,4%-%date:~5,2%-%date:~8,2%
set hms=%time: =0%
set time=%hms:~0,2%.%hms:~3,2%.%hms:~6,2%
set dates=%date%_%time%

mkdir F:\DCIM\100MEDIA

set src_dir=E:\DCIM\100MEDIA
set dst_dir=F:\DCIM\100MEDIA
set log_file=F:\robocopy_log_%dates%.log

robocopy "%src_dir%" "%dst_dir%" /mov /s /xd /log:"%log_file%"

PAUSE