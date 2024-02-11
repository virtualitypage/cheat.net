#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="${month} 収支記録.csv"
sub_file="収支記録_読込用.txt"

function create_txt () {
  echo -n > "$current_dir/$sub_file"
  chmod 755 "$current_dir/$sub_file"
}

month=$(date +%m月)
total=0

# テキストファイルを読み込み、CSVファイルに変換する関数
function convert_to_csv () {
  while IFS= read -r string_column; do
    read -r numeric_column
    # 文字列列と数値列をCSV行に変換してCSVファイルに追加
    csv_line="$string_column,$numeric_column"
    echo "$csv_line" >> "$current_dir/$main_file"

    # 数値を合計に加算
    total=$((total + numeric_column))
  done < "$current_dir/$sub_file"

  # 合計値を最終行の1列目に追加
  echo "合計額,$total" >> "$main_file"

  # 予算額を最終行の2列目に追加
  echo "予算(50000円),$((50000 - total))" >> "$current_dir/$main_file"
}

if [ -f "$current_dir/$sub_file" ]; then
  convert_to_csv
  echo -e "\033[1;32mALL SUCCESSFUL: 計算およびファイル作成が完了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
elif [ ! -f "$current_dir/$sub_file" ]; then
  create_config
  echo -e "\033[1;31mERROR: 読込用ファイルがありません。対象のファイルを $current_dir に生成します。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo
  echo "文字列"
  echo "数値"
  echo "文字列"
  echo "数値"
  echo
  echo "---と空行を挟むことでcsvの行を区切ることが可能"
  echo
  exit 1
else
  echo
fi