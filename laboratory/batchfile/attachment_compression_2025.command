#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
archive="$current_dir/archive"
GoogleDrivePath=$(find "$HOME/Library/CloudStorage" -type d -name "GoogleDrive-*@gmail.com" 2>/dev/null)
GoogleDrivePath=$(find "$GoogleDrivePath" -type d -name "添付ファイル" 2>/dev/null | awk 'NR == 1')

read -rp "archive ファイルの作成日時を入力してください [ YYYY/MM/DD ]: " date

file_date_YMD="${date////-}" # sed 's|/|-|g' と同義
file_date_YM="${file_date_YMD%-*}" # %で末尾から一致する箇所を検索、-DDの部分を削除
year="${file_date_YM%-*}"

SetFile_today=$(date -j -f "%Y/%m/%d" "$date" +"%m/%d/%Y")
SetFile_tomorrow=$(date -v+1d -j -f "%Y/%m/%d" "$date" +"%m/%d/%Y")

cp -r "$archive/" "${archive}_$file_date_YMD/"

while IFS= read -r catalog_file; do
  rm "$catalog_file"
done < <(find "$archive" -name '._*')

SetFile -m "$SetFile_tomorrow 00:00" "$archive" "$archive/disk_logger"
SetFile -d "$SetFile_tomorrow 00:00" "$archive" "$archive/disk_logger"

SetFile -m "$SetFile_today 23:59" "$archive/$file_date_YMD"/*
SetFile -d "$SetFile_today 23:59" "$archive/$file_date_YMD"/*

SetFile -m "$SetFile_today 23:59" "$archive/$file_date_YMD" "$archive/interface_logger"
SetFile -d "$SetFile_today 23:59" "$archive/$file_date_YMD" "$archive/interface_logger"

SetFile -m "$SetFile_tomorrow 00:15" "$archive/luci_stat_$file_date_YMD" "$archive/luci_stat_archive_$file_date_YMD"
SetFile -d "$SetFile_tomorrow 00:15" "$archive/luci_stat_$file_date_YMD" "$archive/luci_stat_archive_$file_date_YMD"

SetFile -m "$SetFile_today 00:15" "$archive/luci_stat_archive_$file_date_YMD/br-lan" "$archive/luci_stat_archive_$file_date_YMD/cpu-"* "$archive/luci_stat_archive_$file_date_YMD/eth0" "$archive/luci_stat_archive_$file_date_YMD/tailscale0" "$archive/luci_stat_archive_$file_date_YMD/thermal"
SetFile -d "$SetFile_today 00:15" "$archive/luci_stat_archive_$file_date_YMD/br-lan" "$archive/luci_stat_archive_$file_date_YMD/cpu-"* "$archive/luci_stat_archive_$file_date_YMD/eth0" "$archive/luci_stat_archive_$file_date_YMD/tailscale0" "$archive/luci_stat_archive_$file_date_YMD/thermal"

SetFile -m "$SetFile_today 00:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_00-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_00-00-00/"*
SetFile -d "$SetFile_today 00:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_00-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_00-00-00/"*

SetFile -m "$SetFile_today 03:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_03-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_03-00-00/"*
SetFile -d "$SetFile_today 03:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_03-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_03-00-00/"*

SetFile -m "$SetFile_today 06:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_06-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_06-00-00/"*
SetFile -d "$SetFile_today 06:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_06-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_06-00-00/"*

SetFile -m "$SetFile_today 09:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_09-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_09-00-00/"*
SetFile -d "$SetFile_today 09:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_09-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_09-00-00/"*

SetFile -m "$SetFile_today 12:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_12-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_12-00-00/"*
SetFile -d "$SetFile_today 12:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_12-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_12-00-00/"*

SetFile -m "$SetFile_today 15:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_15-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_15-00-00/"*
SetFile -d "$SetFile_today 15:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_15-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_15-00-00/"*

SetFile -m "$SetFile_today 18:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_18-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_18-00-00/"*
SetFile -d "$SetFile_today 18:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_18-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_18-00-00/"*

SetFile -m "$SetFile_today 21:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_21-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_21-00-00/"*
SetFile -d "$SetFile_today 21:10" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_21-00-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_21-00-00/"*

SetFile -m "$SetFile_today 23:50" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_23-50-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_23-50-00/"*
SetFile -d "$SetFile_today 23:50" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_23-50-00" "$archive/luci_stat_archive_$file_date_YMD/${file_date_YMD}_23-50-00/"*

SetFile -m "$SetFile_today 02:00" "$archive/msmtp_$file_date_YM.json"
SetFile -d "$SetFile_today 02:00" "$archive/msmtp_$file_date_YM.json"

SetFile -m "$SetFile_today 23:50" "$archive/$file_date_YMD"/CPU_*.log "$archive/$file_date_YMD"/process_*.log
SetFile -d "$SetFile_today 23:50" "$archive/$file_date_YMD"/CPU_*.log "$archive/$file_date_YMD"/process_*.log

SetFile -m "$SetFile_today 23:59" "$archive/interface_logger/br-lan_$file_date_YM.log" "$archive/interface_logger/eth0_$file_date_YM.log" "$archive/interface_logger/lo_$file_date_YM.log" "$archive/interface_logger/rax0_$file_date_YM.log" "$archive/interface_logger/tailscale0_$file_date_YM.log"
SetFile -d "$SetFile_today 23:59" "$archive/interface_logger/br-lan_$file_date_YM.log" "$archive/interface_logger/eth0_$file_date_YM.log" "$archive/interface_logger/lo_$file_date_YM.log" "$archive/interface_logger/rax0_$file_date_YM.log" "$archive/interface_logger/tailscale0_$file_date_YM.log"

cd "$current_dir" || exit
tar -zcf "archive_$file_date_YMD.tar.gz" archive
SetFile -m "$SetFile_tomorrow 00:00" "archive_$file_date_YMD.tar.gz"
SetFile -d "$SetFile_tomorrow 00:00" "archive_$file_date_YMD.tar.gz"

mv "archive_$file_date_YMD.tar.gz" "$GoogleDrivePath/$year/archive"
