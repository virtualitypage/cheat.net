#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y%m%d')
main_file=$current_dir/血祭りにあげてやるグループLINEのトーク履歴_$today.csv
sub_file=$current_dir/"[LINE] 血祭りにあげてやるグループLINEのトーク.txt"

function generate_talkHistory () {
  sed -i '' 's/	/,/g' "$sub_file"
  sed -i '' 's/		/,/g' "$sub_file"
  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    message=$(
      cat << EOF
$col1,$col2,$col3
EOF
    )
    echo "$message" >> "$main_file"
    echo >> "$main_file"
  done < "$sub_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [ -f "$sub_file" ]; then
  generate_talkHistory
fi
