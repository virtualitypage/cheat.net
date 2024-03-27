#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')

main_file="$current_dir"/securityCamera_Log.txt
main_copy="$current_dir"/securityCamera_Log_copy.txt
main_file_unique="$current_dir"/securityCamera_manual.csv
sub_file=$(find "$current_dir" -type f -name "securityCamera_R*.txt" 2>/dev/null)
mid_file="$current_dir"/securityCamera_InterimData.txt

function generate_logfile_edit () {
  cp "$main_file" "$current_dir/securityCamera_Log_copy.txt"
  cp "$sub_file" "$current_dir/securityCamera_InterimData.txt"

  sed -i '' 's/動体検知　　　　：あり  //g' "$mid_file"
  sed -i '' 's/動体検知　　　　：不鮮明  //g' "$mid_file"

  sed -i '' 's/音声記録　　　　：あり  //g' "$mid_file"
  sed -i '' 's/音声記録　　　　：あり//g' "$mid_file"
  sed -i '' 's/音声記録　　　　：なし//g' "$mid_file"
  sed -i '' 's/音声記録　　　　：不鮮明//g' "$mid_file"
  sed -i '' 's/音声記録　　　　：不鮮明  //g' "$mid_file"

  sed -i '' 's/無断駐車　　　　：あり  //g' "$mid_file"
  sed -i '' 's/無断駐車　　　　：なし//g' "$mid_file"
  sed -i '' 's/無断駐車　　　　：不鮮明  //g' "$mid_file"

  sed -i '' 's/敷地内への侵入　：あり  //g' "$mid_file"
  sed -i '' 's/敷地内への侵入　：なし//g' "$mid_file"
  sed -i '' 's/敷地内への侵入　：不鮮明  //g' "$mid_file"

  sed -i '' 's/不審な人影や動き：あり  //g' "$mid_file"
  sed -i '' 's/不審な人影や動き：なし//g' "$mid_file"
  sed -i '' 's/不審な人影や動き：不鮮明  //g' "$mid_file"

  sed -i '' "/${year}年/d" "$mid_file"

  sed -i '' '/^$/d' "$mid_file"

  sort "$mid_file" | uniq >> "$main_copy"
  sort "$main_copy" | uniq > "$main_file"
  rm "$main_copy" "$mid_file" "$main_file.tmp" 2>/dev/null
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
}

if [ -e "$main_file" ] && [ -e "$main_file_unique" ]; then
  generate_logfile_edit
elif [ -n "$main_file" ] && [ -e "$main_file_unique" ]; then
  echo "cut -d ',' -f2 securityCamera_manual.csv > securityCamera_Log.txt"
  cut -d ',' -f2 "$main_file_unique" > "$main_file.tmp"
  sed -e 's/・［//g' -e 's/］//g' -e '/→/d' -e '/^[<space><tab>]*$/d' -e '/記録文章/d' "$main_file.tmp" > "$main_file"
  echo
  echo -e "\033[1;36mINFO: securityCamera_manual.csv を読み込んで securityCamera_Log.txt を作成しました\033[0m"
  echo
  generate_logfile_edit
else
  echo
  echo -e "\033[1;31mERROR: securityCamera_manual.csv か \"securityCamera_R\"を含むファイル又はその両方が存在しません\033[0m"
  exit 1
fi
