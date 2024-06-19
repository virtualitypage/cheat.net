#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
main_file="$current_dir/system.csv"
sub_file="$current_dir/logread/system.log"

function systemlog_convert () {
  sed -i '' "s/ ${year}//g" "$sub_file"
  sed -i '' "s/^/${year}\//g" "$sub_file"
  days=("Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat")
  for i in {1..7}; do
    day="${days[$i - 1]}" # 配列のインデックスは0から始まるため-1する
    sed -i '' "s/${day} //g" "$sub_file"
  done
  months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
  for i in {1..12}; do
    month="${months[$i - 1]}"
    sed -i '' "s/${month} /$i\//g" "$sub_file"
  done
  sed -i '' 's/^\([^ ]* [^ ]*\) /&,"/g' "$sub_file" # 各行の二つ目の半角スペースの前にコンマを挿入
  sed -i '' 's/$/"/g' "$sub_file"
  mv "$sub_file" "$main_file"
  rm -rf "$current_dir/logread"
}

if [ -e "$sub_file" ]; then
  systemlog_convert
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
else
  echo -e "\033[1;31mERROR: \"system.log\"が格納されたlogreadディレクトリが存在しません。gl.iNetの管理画面から\"ログをエクスポート\"して下さい。\033[0m"
  echo
  exit 1
fi
