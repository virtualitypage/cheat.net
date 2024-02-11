#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

file_path=$1
main_file=$2.csv
total=0

function usage () {
  echo "テキストのデータにある数値を計算してcsvに計算結果を書き出すスクリプト(MacOS／WSL環境対応)"
  echo "入力方法: $this [テキストファイルパス] [出力ファイル名]"
  echo -e "\033[1;31m注意:\033[0m" "テキストファイルは以下の形式で書かれたものが対象"
  echo "文字列"
  echo "数値"
  echo "文字列"
  echo "数値"
  echo "---と空行を挟むことでcsvの行を区切ることが可能"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ ! -f "$1" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.txt\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: ファイルパス $file_path は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

# テキストファイルを読み込み、CSVファイルに変換する関数
function expenses_to_csv() {
  while IFS= read -r string_column; do
    read -r numeric_column
    # 文字列列と数値列をCSV行に変換してCSVファイルに追加
    csv_line="$string_column,$numeric_column"
    echo "$csv_line" >> "$main_file"

    # 数値を合計に加算
    total=$((total + numeric_column))
  done < "$file_path"

  # 合計値を最終行の1列目に追加
  echo "合計額,$total" >> "$main_file"

  # 予算額を最終行の2列目に追加
  echo "予算(50000円),$((50000 - total))" >> "$main_file"
  echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

# 変換を実行
expenses_to_csv