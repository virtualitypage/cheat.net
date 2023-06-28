#!/bin/bash

this=`basename $0`
current_dir=$(cd "$(dirname "$0")" && pwd)

html_file="${current_dir}/$1"
txt_file="$2.txt"

usage () {
  echo "Googleのブックマークファイル(.html)から名前とURLを抽出してテキストファイルに出力するスクリプト"
  echo "入力方法: $this [htmlファイル] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [ $# -lt 2 ]; then
  echo "出力ファイル名を指定して下さい"
  exit 1
fi

url_pattern='A HREF="([^"]+)"[^>]*>([^<]+)</A>'
folder_pattern='<H3[^>]*>([^<]+)</H3>'

while IFS= read -r line; do
  if [[ $line =~ $folder_pattern ]]; then
    folder="${BASH_REMATCH[1]}"
    if [[ -n $folder ]]; then
      echo "[$folder]" >> "$txt_file"
      echo "" >> "$txt_file"
    fi
  elif [[ $line =~ $url_pattern ]]; then
    url="${BASH_REMATCH[1]}"
    string="${BASH_REMATCH[2]}"
    if [[ -n $string ]]; then
      echo "・$string" >> "$txt_file"
    fi
    if [[ -n $url ]]; then
      echo "　$url" >> "$txt_file"
      echo "" >> "$txt_file"
    fi
  fi
done < "$html_file"

echo "ブックマークのデータ抽出が完了しました。"