#!/bin/bash

this=`basename $0`
current_dir=$(cd "$(dirname "$0")" && pwd)

html_file="bookmarks.html"
txt_file="bookmarks.txt"

export_to_text () {
url_pattern='A HREF="([^"]+)"[^>]*>([^<]+)</A>'
folder_pattern='<H3[^>]*>([^<]+)</H3>'

while IFS= read -r line; do
  if [[ $line =~ $folder_pattern ]]; then
    folder="${BASH_REMATCH[1]}"
    if [[ -n $folder ]]; then
      echo "[$folder]" >> "${current_dir}/$txt_file"
      echo "" >> "${current_dir}/$txt_file"
    fi
  elif [[ $line =~ $url_pattern ]]; then
    url="${BASH_REMATCH[1]}"
    string="${BASH_REMATCH[2]}"
    if [[ -n $string ]]; then
      echo "・$string" >> "${current_dir}/$txt_file"
    fi
    if [[ -n $url ]]; then
      echo "　$url" >> "${current_dir}/$txt_file"
      echo "" >> "${current_dir}/$txt_file"
    fi
  fi
done < "${current_dir}/$html_file"
}

if [ -f "${current_dir}/${html_file}" ]; then
  export_to_text
  echo "ブックマークのデータ抽出が完了しました。ファイルは${current_dir}/${txt_file}に保存されています。"
  echo ""
else
  if [ ! -f "${current_dir}/${html_file}" ]; then
    echo "ブックマークファイルがありません。$(cd $(dirname $0) && pwd)に${html_file}を配置して下さい。"
    echo "また、名前はbookmarks.htmlである必要があります。"
    exit 1
  else
    echo ""
  fi
fi