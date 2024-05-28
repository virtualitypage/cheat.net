@echo off
rem robocopyコマンドでファイルの移動を実行するバッチファイル

rem 移動元ディレクトリの中にあるファイルが対象
set src_dir=E:\DCIM\100MEDIA
set dst_dir=\\192.168.8.1\Internal\var\cache
set log_file=\\192.168.8.1\Internal\dev\robocopy_log.txt

robocopy "%src_dir%" "%dst_dir%" /mov /s /xd /log:"%log_file%"