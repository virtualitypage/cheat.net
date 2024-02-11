#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/menuNotification.txt"
sub_file="$current_dir/menuNotification.csv"
mid_file="$current_dir/middle.txt"
csv_file="$current_dir/modified.csv"

function 56lines () {
  awk '{printf "%s%s", (NR>1 ? (/^[.!?]/ ? "\n" : " "): ""), $0} END {print ""}' "$sub_file" > "$csv_file"
  sed -e 's/ /\\n/g' -e 's/\n//g' -e 's/\\n\"//g' -e 's/,/\n/g' "$csv_file" > "$csv_file.tmp"
  mv "$csv_file.tmp" "$csv_file"
  sed -i '' 's/\\n\\n.*$//' "$csv_file"
  echo "・56行〜のコード" >> "$main_file"
  echo "var title = [" >> "$main_file"

  first_string=true
  while IFS=, read -r line; do
    line=$(echo "$line" | tr -d '\n\r') # 改行の削除
    if $first_string; then
      new_code+="  ['$line', "
      first_string=false
    else
      new_code+="'$line', "
    fi
  done < "$csv_file"

  new_code="${new_code%,}" # 末尾のカンマを削除
  new_code+="],"           # コードの末尾を閉じる

  echo "$new_code" >> "$main_file"
  echo "];" >> "$main_file"
  sed -i '' "s/, '', //g" "$main_file"
  echo -e "\033[1;32mSUCCESSFUL: 56行〜のコード生成処理が正常に終了しました。\033[0m"
}

function 125lines () {
  cat << EOF >> "$main_file"

・125行〜のコード
var messages = [
EOF

  while IFS=, read -r line; do
    line=$(echo "$line" | tr -d '\n\r')
    cat << EOF >> "$main_file"
  ['$line'],
EOF
  done < "$csv_file"

  echo "];" >> "$main_file"
  sed -i '' "/\[''\],/d" "$main_file"
  sed "s/'\\\\n/\'/" "$main_file" > "$main_file.tmp"
  mv "$main_file.tmp" "$main_file"
  echo -e "\033[1;32mSUCCESSFUL: 125行〜のコード生成処理が正常に終了しました。\033[0m"
}

function 168lines () {
  echo >> "$main_file"
  echo "・168行〜のコード" >> "$main_file"
  count=0
  while IFS= read -r line; do
    count=$((count + 1))
    line=$(echo "$line" | tr -d '\n\r')
    cat << EOF >> "$main_file"
var recipeNum$count = [
  ['$line'],
];
recipeSheet.getRange('D$count').setValue(recipeNum$count);
EOF
    echo >> "$main_file"
  done < "$mid_file"

  sed "s/'\\\\n/\'/" "$main_file" > "$main_file.tmp"
  mv "$main_file.tmp" "$main_file"
  rm "$mid_file" "$csv_file"
  echo -e "\033[1;32mSUCCESSFUL: 168行〜のコード生成処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

function menuNotificationCode () {
  while IFS=, read -r col1; do
    message=$(
      cat << EOF
$col1
EOF
    )
    echo "$message" >> "$mid_file"
  done < "$sub_file"
  echo -e "\033[1;32mSUCCESSFUL: ファイルの変換処理が正常に終了しました。\033[0m"

  # awkを使って文末に改行を追加
  converted_string=$(awk '{printf "%s%s", (NR>1 ? (/^[.!?]/ ? "\n" : " "): ""), $0} END {print ""}' "$mid_file")
  echo -e "$converted_string" > "$mid_file"
  sed -e 's/ /\\n/g' -e 's/\n//g' -e 's/\\n\"//g' -e 's/\",/\n/g' "$mid_file" > "$mid_file.tmp"
  mv "$mid_file.tmp" "$mid_file"
  sed -i '' '/^[[:space:]]*$/d' "$mid_file"
  sed -i '' 's/,/\n/g' "$mid_file"
  56lines
  125lines
  168lines
}

if [ -f "$sub_file" ]; then
  menuNotificationCode
fi
