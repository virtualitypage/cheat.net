#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
internal="$HOME/Library/CloudStorage/GoogleDrive-youguigujing42@gmail.com/マイドライブ/共有フォルダ/Internal"

function setfiling () {
  footage_2023="usr/local/footage/2023"
  footage_2024="usr/local/footage/2024"
  securityLog_2023="var/log/securityLog/2023"
  securityLog_2024="var/log/securityLog/2023"

  dates_2023=("1/31" "2/28" "3/31" "4/30" "5/31" "6/30" "7/31" "8/31" "9/30" "10/31" "11/30" "12/31")
  for i in {1..12}; do
    date="${dates_2023[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    footage="$current_dir/2023年度 防犯カメラ記録動画 ${i}月 タイムスタンプ.pdf"
    securityLog="$current_dir/2023年度 防犯カメラ記録 ${i}月分.pdf"
    if [ -e "$securityLog" ]; then
      setfile -m "${date}/2023 0:00" "$securityLog"
      echo "setfile -m \"${date}/2023 0:00\" \"$securityLog\""
    else
      continue
    fi
    if [ -e "$footage" ]; then
      setfile -m "${date}/2023 0:00" "$footage"
      echo "setfile -m \"${date}/2023 0:00\" \"$footage\""
    else
      continue
    fi
    rsync "$current_dir/2023年度 防犯カメラ記録動画 ${i}月 タイムスタンプ.pdf" "$internal/$footage_2023" 2>/dev/null
    rsync "$current_dir/2023年度 防犯カメラ記録 ${i}月分.pdf" "$internal/$securityLog_2023" 2>/dev/null
  done

  dates_2024=("1/31" "2/29" "3/31" "4/30" "5/31" "6/30" "7/31" "8/31" "9/30" "10/31" "11/30" "12/31")
  for i in {1..12}; do
    date="${dates_2024[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    footage="$current_dir/2024年度 防犯カメラ記録動画 ${i}月 タイムスタンプ.pdf"
    securityLog="$current_dir/2024年度 防犯カメラ記録 ${i}月分.pdf"
    if [ -e "$securityLog" ]; then
      setfile -m "${date}/2024 0:00" "$securityLog"
      echo "setfile -m \"${date}/2024 0:00\" \"$securityLog\""
    else
      continue
    fi
    if [ -e "$footage" ]; then
      setfile -m "${date}/2024 0:00" "$footage"
      echo "setfile -m \"${date}/2024 0:00\" \"$footage\""
    else
      continue
    fi
    rsync "$current_dir/2024年度 防犯カメラ記録動画 ${i}月 タイムスタンプ.pdf" "$internal/$footage_2024" 2>/dev/null
    rsync "$current_dir/2024年度 防犯カメラ記録 ${i}月分.pdf" "$internal/$securityLog_2024" 2>/dev/null
  done
}
setfiling
