#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
main_file="$current_dir/セッション統計.csv"
sub_file="$current_dir/securityCamera_Log.txt"

function sessionStatistics () {
  for i in {1..12}; do
    mid_file=$(find "$current_dir" -type f -iname "防犯カメラ 記録 ${i}月分.txt" 2>/dev/null)
    if [ -n "$mid_file" ]; then
      stream_editor "$mid_file"
      middle=$(basename "$mid_file")
      echo "$middle" >> "$main_file"
      while IFS= read -r line; do
        count=$(grep --line-regexp "$line" "$mid_file.tmp" | wc -l)
        log=$(
          cat << EOF
$line,$count
EOF
        )
        echo "$log" >> "$main_file"
      done < "$sub_file"
      sed -i '' 's/ //g' "$main_file"
      sed -i '' '/0$/d' "$main_file"
      # awk '!/0$/ && !lastline {print} {lastline = /0$/}' "$main_file" > "$main_file.tmp" # 行末に0を含む行とその一つ上の行を削除
      # mv "$main_file.tmp" "$main_file"
      rm "$mid_file.tmp"
    fi
  done
}

function stream_editor () {
  local "$mid_file"="$1" 2>/dev/null
  cp "$mid_file" "$mid_file.tmp"

  sed -i '' 's/動体検知　　　　：あり  //g' "$mid_file.tmp"
  sed -i '' 's/動体検知　　　　：不鮮明  //g' "$mid_file.tmp"

  sed -i '' 's/音声記録　　　　：あり  //g' "$mid_file.tmp"
  sed -i '' 's/音声記録　　　　：あり//g' "$mid_file.tmp"
  sed -i '' 's/音声記録　　　　：なし//g' "$mid_file.tmp"
  sed -i '' 's/音声記録　　　　：不鮮明//g' "$mid_file.tmp"
  sed -i '' 's/音声記録　　　　：不鮮明  //g' "$mid_file.tmp"

  sed -i '' 's/無断駐車　　　　：あり  //g' "$mid_file.tmp"
  sed -i '' 's/無断駐車　　　　：なし//g' "$mid_file.tmp"
  sed -i '' 's/無断駐車　　　　：不鮮明  //g' "$mid_file.tmp"

  sed -i '' 's/敷地内への侵入　：あり  //g' "$mid_file.tmp"
  sed -i '' 's/敷地内への侵入　：なし//g' "$mid_file.tmp"
  sed -i '' 's/敷地内への侵入　：不鮮明  //g' "$mid_file.tmp"

  sed -i '' 's/不審な人影や動き：あり  //g' "$mid_file.tmp"
  sed -i '' 's/不審な人影や動き：なし//g' "$mid_file.tmp"
  sed -i '' 's/不審な人影や動き：不鮮明  //g' "$mid_file.tmp"

  sed -i '' '/2023年/d' "$mid_file.tmp"
  sed -i '' "/${year}年\$/d" "$mid_file.tmp"

  sed -i '' '/^$/d' "$mid_file.tmp"
}

if [ -f "$sub_file" ]; then
  sessionStatistics
fi
