#!/bin/bash

this=`basename $0`

function usage {
  echo "テキストのデータにある数値を計算してcsvに計算結果を書き出すスクリプト"
  echo "テキストファイルは以下の形式で書かれたものが対象"
  echo "文字列"
  echo "数値"
  echo "文字列"
  echo "数値"
  echo "---と空行を挟むことでcsvの行を区切ることが可能"
  echo "入力方法: $this [入力ファイル名(.txt)] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

input_file="$1"
output_file="$2.csv"
total=0

# テキストファイルを読み込み、CSVファイルに変換する関数
function convert_to_csv() {
    while IFS= read -r string_column; do
        read -r numeric_column
        # 文字列列と数値列をCSV行に変換してCSVファイルに追加
        csv_line="$string_column,$numeric_column"
        echo "$csv_line" >> "$output_file"

        # 数値を合計に加算
        total=$((total + numeric_column))
    done < "$input_file"

    # 合計値を最終行の1列目に追加
    echo "合計額,$total" >> "$output_file"

    # 予算額を最終行の2列目に追加
    echo "予算(50000円),$((50000 - total))" >> "$output_file"
}

# 変換を実行
convert_to_csv
