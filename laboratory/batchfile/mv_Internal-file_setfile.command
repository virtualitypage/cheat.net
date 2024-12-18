#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
internal="$HOME/Library/CloudStorage/GoogleDrive-youguigujing42@gmail.com/マイドライブ/共有フォルダ/Internal"

function setfiling () {
  footage_2023="usr/local/footage/2023"
  footage_2024="usr/local/footage/2024"
  securityLog_2023="var/log/securityLog/2023"
  securityLog_2024="var/log/securityLog/2024"

  dates_2023=("1/31" "2/28" "3/31" "4/30" "5/31" "6/30" "7/31" "8/31" "9/30" "10/31" "11/30" "12/31")
  for i in {1..12}; do
    date="${dates_2023[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    footage="$current_dir/2023年${i}月 防犯カメラ映像(タイムスタンプ).pdf"
    securityLog="$current_dir/2023年${i}月 防犯カメラ記録.pdf"
    if [ -e "$securityLog" ]; then
      SetFile -m "${date}/2023 0:00" "$securityLog"
      echo "SetFile -m \"${date}/2023 0:00\" \"$securityLog\""
      mv --verbose "$securityLog" "$internal/$securityLog_2023" 2>/dev/null
    fi
    if [ -e "$footage" ]; then
      SetFile -m "${date}/2023 0:00" "$footage"
      echo "SetFile -m \"${date}/2023 0:00\" \"$footage\""
      mv --verbose "$footage" "$internal/$footage_2023" 2>/dev/null
    fi
  done

  dates_2024=("1/31" "2/29" "3/31" "4/30" "5/31" "6/30" "7/31" "8/31" "9/30" "10/31" "11/30" "12/31")
  for i in {1..12}; do
    date="${dates_2024[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    footage="$current_dir/2024年${i}月 防犯カメラ映像(タイムスタンプ).pdf"
    securityLog="$current_dir/2024年${i}月 防犯カメラ記録.pdf"
    if [ -e "$securityLog" ]; then
      SetFile -m "${date}/2024 0:00" "$securityLog"
      echo "SetFile -m \"${date}/2024 0:00\" \"$securityLog\""
      mv --verbose "$securityLog" "$internal/$securityLog_2024" 2>/dev/null
    fi
    if [ -e "$footage" ]; then
      SetFile -m "${date}/2024 0:00" "$footage"
      echo "SetFile -m \"${date}/2024 0:00\" \"$footage\""
      mv --verbose "$footage" "$internal/$footage_2024" 2>/dev/null
    fi
  done
}
setfiling
