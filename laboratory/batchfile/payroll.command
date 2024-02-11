#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
csv="アルバイト明細_読込用.csv"

function create_csv () {
  for ((i=1; i<=20; i++))
  do
    for ((j=1; j<=3; j++))
    do
      echo -n "," >> "$current_dir/$csv"
    done
    echo -e "\n" >> "$current_dir/$csv"
  done
}

month=$(date +%m月)
month=${month#0}
txt_file="アルバイト明細.txt"

function computeMonthSum () {
  total_result=0
  while IFS= read -r line; do
    line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')  # 行の先頭と末尾の空白を削除
    if [[ $line == "¥"* ]]; then
      value=${line#"¥"}
      total_result=$((total_result + value))
    fi
  done < "$current_dir/$month $txt_file"
  echo "合計額 ¥$total_result" >> "$current_dir/$month $txt_file"
}

day29="29日"
day30="30日"
day31="31日"

function payroll () {
  local month_end_detected=false  # 月末を検知したかどうかのフラグ
  while IFS=, read -r col1 col2 col3 col4 || [[ -n $col4 ]];
  do
    if ! [[ $col2 =~ ^[0-9]+$ ]] || ! [[ $col3 =~ ^[0-9]+\.?[0-9]*$ ]]; then
      echo -e "\033[1;31mERROR: 時給または労働時間が正しくありません。\033[0m"
      exit 1
    fi
    result=$(echo "scale=0; $col2 * $col3" | bc)
    printf "・%s\n  時給: %s円\n  時間: %s\n  ¥%s\n\n" "$col1" "$col2" "$col4" "$result" >> "$current_dir/$month $txt_file"
    if [[ $col1 =~ $day29 || $col1 =~ $day30 || $col1 =~ $day31 ]]; then
      if ! $month_end_detected; then
        echo -e "\033[1;32m月末を検知、集計処理を開始します。\033[0m"
        computeMonthSum
        month_end_detected=true
        continue
      fi
    fi
  done < "$current_dir/$csv"
}

if [ -f "$current_dir/$csv" ]; then
  payroll
  echo -e "\033[1;32mALL SUCCESSFUL: 計算が完了しました。ファイルは $current_dir に格納されています。\033[0m"
elif [ ! -f "$current_dir/$csv" ]; then
  create_csv
  echo -e "\033[1;31mERROR: 読込用ファイルがありません。対象のファイルを $current_dir に生成します。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo ""
  echo "1列目 -> 出勤当日の日時(例: mm月dd日)"
  echo "2列目 -> 時給(例: 1000円)"
  echo "3列目 -> 労働時間(例: 6時間の場合6、6時間半の場合は6.5)"
  echo "4列目 -> 労働時間に単位を追加(例: 6h 又は 6h5m)"
  echo ""
  exit 1
fi