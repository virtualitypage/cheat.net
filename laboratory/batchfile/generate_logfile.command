#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
sub_file=$(find "$current_dir" -type f -name "*$year*status.txt" 2> /dev/null)
date=$(basename "$sub_file" | sed 's/ status.txt//g')
main_file="$current_dir/securityCamera_Rec($date).txt"
securityCamera_Rec=$(basename "$main_file")

rm "$current_dir"/._*

function generate_logfile () {
  while IFS= read -r line; do
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
    echo "" >> "$main_file"
  done < "$sub_file"

  sed -i '' 's/DSCF.*-> //g' "$main_file"
  sed -i '' 's/01月/1月/g' "$main_file" ; sed -i '' 's/02月/2月/g' "$main_file" ; sed -i '' 's/03月/3月/g' "$main_file" ; sed -i '' 's/04月/4月/g' "$main_file"
  sed -i '' 's/05月/5月/g' "$main_file" ; sed -i '' 's/06月/6月/g' "$main_file" ; sed -i '' 's/07月/7月/g' "$main_file" ; sed -i '' 's/08月/8月/g' "$main_file"
  sed -i '' 's/09月/9月/g' "$main_file"

  sed -i '' 's/01日/1日/g' "$main_file" ; sed -i '' 's/02日/2日/g' "$main_file" ; sed -i '' 's/03日/3日/g' "$main_file" ; sed -i '' 's/04日/4日/g' "$main_file"
  sed -i '' 's/05日/5日/g' "$main_file" ; sed -i '' 's/06日/6日/g' "$main_file" ; sed -i '' 's/07日/7日/g' "$main_file" ; sed -i '' 's/08日/8日/g' "$main_file"
  sed -i '' 's/09日/9日/g' "$main_file"

  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$securityCamera_Rec は $current_dir に格納されています。\033[0m"
  echo
}

if [ -f "$sub_file" ]; then
  generate_logfile
else
  echo -e "\033[1;31mERROR: status.txt が存在しない、または複数の status.txt が配置されています。単一のファイルのみ配置して下さい。\033[0m"
  echo
fi
