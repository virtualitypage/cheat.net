#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
sub_file=$(find "$current_dir" -type f -name "*$year*status.txt" 2>/dev/null)
date=$(basename "$sub_file" | sed 's/ status.txt//g')
main_file="$current_dir/securityCamera_Rec($date).txt"
securityCamera_Rec=$(basename "$main_file")

function generate_logfile () {
  while IFS= read -r line || [[ -n $line ]]; do
    message=$(
      cat << EOF
日時：$line
動体検知　　　　：あり  
音声記録　　　　：不鮮明
無断駐車　　　　：なし
敷地内への侵入　：なし
不審な人影や動き：なし
EOF
    )
    echo "$message" >> "$main_file"
    echo >> "$main_file"
  done < "$sub_file"

  sed -i '' 's/DSCF.*-> //g' "$main_file"
  for i in {0..9}; do
    j=$(printf "%02d" "$i")
    sed -i '' "s/${j}月/${i}月/g" "$main_file"
    sed -i '' "s/${j}日/${i}日/g" "$main_file"
  done

  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$securityCamera_Rec は $current_dir に格納されています。\033[0m"
  echo
}

if [ -f "$sub_file" ]; then
  rm "$current_dir"/._*
  generate_logfile
else
  echo -e "\033[1;31mERROR: status.txt が存在しない、または複数の status.txt が配置されています。単一のファイルのみ配置して下さい。\033[0m"
  echo
fi
