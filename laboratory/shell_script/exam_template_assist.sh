#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

function usage {
  echo "exam_template.shのためのcsv作成スクリプト(MacOS／WSL環境対応)"
  echo "入力方法: $this [テキストファイルパス] [出力ファイル名]"
  echo -e "\033[1;31m注意:\033[0m" "テキストファイルの書式は以下のようにすること(6行書くごとに1行の空行を作る)"
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
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

file_path=$1
main_file=$2.csv

if [[ ! -f "$1" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m" # エラー文を赤色で表示
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

function exam_template_assist () {
while IFS= read -r line || [[ -n $line ]]; # テキストファイルを1行ずつ読み込んで処理する
do
  # 先頭と末尾の空白をトリムする
  trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # 空行の場合もCSVの空行として出力する
  if [ -z "$trimmed_line" ]; then
    echo >> "$main_file"
  else
    # カンマで区切ってCSV形式の1行に書き出す
    echo -n "$trimmed_line," >> "$main_file"
  fi
done < "$file_path"

echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [[ -f $file_path ]] && [ "$main_file" ]; then
  exam_template_assist
fi