#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
main_file="$current_dir/system.csv"
sub_file="$current_dir/logread/system.log"
MacTableEntry="$current_dir/MacTableEntry.csv"
authpriv="$current_dir/authpriv.csv"

function systemlog_convert () {
  days=("Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat")
  for i in {1..7}; do
    day="${days[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    sed -i '' "s/${day} //g" "$sub_file"
  done
  months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
  for i in {1..12}; do
    month="${months[$i - 1]}"
    sed -i '' "s/${month}  /$i\//g" "$sub_file"
    sed -i '' "s/${month} /$i\//g" "$sub_file"
  done
  # sed -i '' 's/^\([^ ]* [^ ]*\) /\1,"/' "$sub_file" # 各行の二つ目の半角スペースの前にコンマを挿入
  sed -i '' '/.*tx_free_v3_notify_handler().*$/d' "$sub_file"
  sed -i '' 's/"/""/g' "$sub_file"
  sed -i '' "s/ ${year} /,\"/g" "$sub_file"
  sed -i '' "s/^/${year}\//g" "$sub_file"
  sed -i '' 's/$/"/g' "$sub_file"
  mv "$sub_file" "$main_file"
  rm -rf "$current_dir/logread"
}

function mac_table_entry () {
  mac_table=("04:d3:b5:f3:f6:a7" "fc:87:43:48:63:7a" "b8:9a:2a:7d:79:7c" "34:e8:94:8b:e1:96" "54:f2:94:48:44:39" "ca:23:49:d1:5c:33" "58:40:4e:e4:d8:b2" "8c:85:90:b9:18:32" "86:a9:22:a4:9d:f2" "82:dd:fa:5c:21:cc")
  host_table=("alisa_HUAWEI P30 lite" "ayako_HUAWEI P30 lite" "DESKTOP-CL4OL20" "DESKTOP-TCDB3LJ" "hideki_HUAWEI P30 lite" "hideki_OPPO-A79-5G" "iMac-Kochi" "MacBook-Pro" "tetsuo_iPhone SE" "yuki_iPhone 11 Pro Max")
  while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
    if [[ $col2 =~ MacTableInsertEntry() ]]; then
      echo "$col1,$col2" >> "$MacTableEntry"
    elif [[ $col2 =~ MacTableDeleteEntry() ]]; then
      echo "$col1,$col2" >> "$MacTableEntry"
    fi
  done < "$main_file"
  for i in {1..10}; do
    mac="${mac_table[$i - 1]}"
    host="${host_table[$i - 1]}"
    sed -i '' 's/kern.*New Sta:/MacTableInsertEntry(): /g' "$MacTableEntry" 2>/dev/null
    sed -i '' 's/kern.*Del Sta:/MacTableDeleteEntry(): /g' "$MacTableEntry" 2>/dev/null
    sed -i '' "s/$mac/$host/g" "$MacTableEntry" 2>/dev/null
  done
  if [ -e "$MacTableEntry" ]; then
    echo -e "\033[1;32mSUCCESS: MacTableEntryファイルの出力処理が正常に終了しました。\033[0m"
  fi
}

function private_authentication_message () {
  while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
    if [[ $col2 =~ authpriv. ]]; then
      echo "$col1,$col2" >> "$authpriv"
    fi
  done < "$main_file"
  if [ -e "$authpriv" ]; then
    echo -e "\033[1;32mSUCCESS: authprivファイルの出力処理が正常に終了しました。\033[0m"
  fi
}

if [ -e "$sub_file" ]; then
  systemlog_convert
  mac_table_entry
  private_authentication_message
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mファイルは $current_dir に格納されています。\033[0m"
  echo
elif [ -n "$sub_file" ] && [ -e "$main_file" ]; then
  mac_table_entry
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: MacTableEntryファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mMacTableEntry.csv は $current_dir に格納されています。\033[0m"
  echo
else
  echo -e "\033[1;31mERROR: \"system.log\"が格納されたlogreadディレクトリが存在しません。gl.iNetの管理画面から\"ログをエクスポート\"して下さい。\033[0m"
  echo
  exit 1
fi
