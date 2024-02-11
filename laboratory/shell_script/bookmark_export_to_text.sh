#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

main_file=$2.txt
sub_file=$1

function usage () {
  echo "Googleのブックマークファイル(.html)から名前とURLを抽出してテキストファイルに出力するスクリプト"
  echo "入力方法: $this [htmlファイルパス] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [ ! -f "$1" ]; then
  echo -e "\033[1;31mERROR: htmlファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.html\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: htmlファイルパス $sub_file は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

url_pattern='A HREF="([^"]+)"[^>]*>([^<]+)</A>'
folder_pattern='<H3[^>]*>([^<]+)</H3>'

function bookmark_export_to_text () {
while IFS= read -r line; do
  if [[ $line =~ $folder_pattern ]]; then
    folder="${BASH_REMATCH[1]}"
    if [[ -n $folder ]]; then
      echo "[$folder]" >> "$main_file"
      echo "" >> "$main_file"
    fi
  elif [[ $line =~ $url_pattern ]]; then
    url="${BASH_REMATCH[1]}"
    string="${BASH_REMATCH[2]}"
    if [[ -n $string ]]; then
      echo "・$string" >> "$main_file"
    fi
    if [[ -n $url ]]; then
      echo "　$url" >> "$main_file"
      echo "" >> "$main_file"
    fi
  fi
done < "$sub_file"

echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [[ $main_file ]] && [[ -f $sub_file ]]; then
  bookmark_export_to_text
fi