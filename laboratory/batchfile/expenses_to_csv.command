#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
txt_file="収支記録_読込用.txt"

function create_txt () {
  echo -n > "${current_dir}/${txt_file}"
  chmod 755 "${current_dir}/${txt_file}"
}

month=`date +%m月`
csv="${month} 収支記録.csv"

total=0

# テキストファイルを読み込み、CSVファイルに変換する関数
function convert_to_csv() {
  while IFS= read -r string_column;
  do
  read -r numeric_column
  # 文字列列と数値列をCSV行に変換してCSVファイルに追加
  csv_line="$string_column,$numeric_column"
  echo "$csv_line" >> "${current_dir}/${csv}"

  # 数値を合計に加算
  total=$((total + numeric_column))
  done < "${current_dir}/${txt_file}"

  # 合計値を最終行の1列目に追加
  echo "合計額,$total" >> "$csv"

  # 予算額を最終行の2列目に追加
  echo "予算(50000円),$((50000 - total))" >> "${current_dir}/${csv}"
}

if [ -f "${current_dir}/${txt_file}" ]; then
  convert_to_csv
  echo "計算およびファイル作成が完了しました。ファイルは${current_dir}/${csv}に保存されました。"
  echo ""
elif [ ! -f "${current_dir}/${txt_file}" ]; then
  create_config
  echo "読込用ファイルがありません。$(cd $(dirname $0) && pwd)に${txt_file}を作成しました。"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo ""
  echo "文字列"
  echo "数値"
  echo "文字列"
  echo "数値"
  echo ""
  echo "---と空行を挟むことでcsvの行を区切ることが可能"
  echo ""
  exit 1
else
  echo ""
fi