#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y_%m_%d')
main_file="$current_dir/bookmarks_$today.txt"
sub_file=$(find "$current_dir" -type f -name "bookmarks_*.html")

function bookmark_export_to_text () {
  url_pattern='A HREF="([^"]+)"[^>]*>([^<]+)</A>'
  folder_pattern='<H3[^>]*>([^<]+)</H3>'
  while IFS= read -r line; do
    if [[ $line =~ $folder_pattern ]]; then
      folder="${BASH_REMATCH[1]}"
      if [ -n "$folder" ]; then
        echo "[$folder]" >> "$main_file"
        echo >> "$main_file"
      fi
    elif [[ $line =~ $url_pattern ]]; then
      url="${BASH_REMATCH[1]}"
      string="${BASH_REMATCH[2]}"
      if [ -n "$string" ]; then
        echo "・$string" >> "$main_file"
      fi
      if [ -n "$url" ]; then
        echo "　$url" >> "$main_file"
        echo >> "$main_file"
      fi
    fi
  done < "$sub_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
}

if [ -e "$sub_file" ]; then
  echo -e "\033[1;32mSUCCESS: $sub_file は有効です。\033[0m"
elif [ ! -e "$sub_file" ]; then
  echo -e "\033[1;31mERROR: $sub_file が存在しません。$sub_file を $current_dir に置いてから再度実行してください。\033[0m"
  exit 1
fi

if [ -f "$sub_file" ]; then
  bookmark_export_to_text
fi
