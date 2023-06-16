#!/bin/bash

this=$(basename "$0")

function usage {
  echo "exam_template.shのためのcsv作成スクリプト"
  echo "注意: テキストファイルの書式は以下のようにすること(6行書くごとに1行の空行を作る)"
  echo ""
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo ""
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo "文字列"
  echo ""
  echo "入力方法: $this [テキストファイル名(XXX.txt)] [出力csvファイル名(XXX.csv)]"
  echo "実行環境がWSLの場合、csvファイルパスを/home/XXX.txtの形にする"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

input_file="$1"
output_file="$2"

# テキストファイルを1行ずつ読み込んで処理する
while IFS= read -r line || [[ -n $line ]];
do
  # 先頭と末尾の空白をトリムする
  trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  
  # 空行の場合もCSVの空行として出力する
  if [ -z "$trimmed_line" ]; then
    echo >> "$output_file"
  else
    # カンマで区切ってCSV形式の1行に書き出す
    echo -n "$trimmed_line," >> "$output_file"
  fi
done < "$input_file"

echo "変換が完了しました。"