#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
archive_GL_MT3000="$current_dir/archive_GL-MT3000"
archive_FortiGate50E="$current_dir/archive_FortiGate50E"
GoogleDrivePath=$(find "$HOME/Library/CloudStorage" -type d -name "GoogleDrive-*@gmail.com" 2>/dev/null)
GoogleDrivePath=$(find "$GoogleDrivePath" -type d -name "添付ファイル" 2>/dev/null | awk 'NR == 1')

read -rp "archive ファイルの作成日時を入力してください [ YYYY/MM/DD ]: " date

file_date_YMD="${date////-}" # sed 's|/|-|g' と同義
file_date_YM="${file_date_YMD%-*}" # %で末尾から一致する箇所を検索、-DDの部分を削除
year="${file_date_YM%-*}"

SetFile_today=$(date -j -f "%Y/%m/%d" "$date" +"%m/%d/%Y")
SetFile_tomorrow=$(date -v+1d -j -f "%Y/%m/%d" "$date" +"%m/%d/%Y")

# cp -r "$archive_GL_MT3000" "${archive_GL_MT3000}_$file_date_YMD"
# cp -r "$archive_FortiGate50E" "${archive_FortiGate50E}_$file_date_YMD"

SetFile -m "$SetFile_tomorrow 00:00" "$archive_GL_MT3000" "$archive_FortiGate50E" "$archive_GL_MT3000/disk_metrics_$file_date_YM.csv" "$archive_FortiGate50E/disk_metrics_$file_date_YM.csv"
SetFile -d "$SetFile_tomorrow 00:00" "$archive_GL_MT3000" "$archive_FortiGate50E" "$archive_GL_MT3000/disk_metrics_$file_date_YM.csv" "$archive_FortiGate50E/disk_metrics_$file_date_YM.csv"

SetFile -m "$SetFile_today 23:59" "$archive_GL_MT3000/$file_date_YMD"/* "$archive_FortiGate50E/$file_date_YMD"/*
SetFile -d "$SetFile_today 23:59" "$archive_GL_MT3000/$file_date_YMD"/* "$archive_FortiGate50E/$file_date_YMD"/*

SetFile -m "$SetFile_today 23:50" "$archive_GL_MT3000/luci_stat_$file_date_YMD" "$archive_GL_MT3000/luci_stat_$file_date_YMD"/* "$archive_FortiGate50E/luci_stat_$file_date_YMD" "$archive_FortiGate50E/luci_stat_$file_date_YMD"/*
SetFile -d "$SetFile_today 23:50" "$archive_GL_MT3000/luci_stat_$file_date_YMD" "$archive_GL_MT3000/luci_stat_$file_date_YMD"/* "$archive_FortiGate50E/luci_stat_$file_date_YMD" "$archive_FortiGate50E/luci_stat_$file_date_YMD"/*

SetFile -m "$SetFile_today 02:00" "$archive_GL_MT3000/msmtp_$file_date_YM.json" "$archive_FortiGate50E/msmtp_$file_date_YM.json"
SetFile -d "$SetFile_today 02:00" "$archive_GL_MT3000/msmtp_$file_date_YM.json" "$archive_FortiGate50E/msmtp_$file_date_YM.json"

rm -f $archive_GL_MT3000/._* $archive_GL_MT3000/*/._*
rm -f $archive_FortiGate50E/._* $archive_FortiGate50E/*/._*

cd "$current_dir" || exit
tar -zcf "archive_${file_date_YMD}_GL-MT3000.tar.gz" archive_GL-MT3000
tar -zcf "archive_${file_date_YMD}_FortiGate50E.tar.gz" archive_FortiGate50E
SetFile -m "$SetFile_tomorrow 00:00" "archive_${file_date_YMD}_GL-MT3000.tar.gz" "archive_${file_date_YMD}_FortiGate50E.tar.gz"
SetFile -d "$SetFile_tomorrow 00:00" "archive_${file_date_YMD}_GL-MT3000.tar.gz" "archive_${file_date_YMD}_FortiGate50E.tar.gz"

mv "archive_${file_date_YMD}_GL-MT3000.tar.gz" "archive_${file_date_YMD}_FortiGate50E.tar.gz" "$GoogleDrivePath/$year/archive"
