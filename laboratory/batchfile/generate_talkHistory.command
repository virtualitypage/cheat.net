#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y%m%d')
main_file="$current_dir/血祭りにあげてやるグループLINEのトーク履歴_$today.csv"
sub_file="$current_dir/[LINE] 血祭りにあげてやるグループLINEのトーク.txt"

function generate_talkHistory () {
  sed -e 's/	/,/g' -e 's/		/,/g' "$sub_file" > "$sub_file.tmp"
  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    message=$(
      cat << EOF
$col1,$col2,$col3
EOF
    )
    echo "$message" >> "$main_file"
  done < "$sub_file.tmp"
  rm "$sub_file.tmp"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [ -f "$sub_file" ]; then
  generate_talkHistory
  echo
  echo -e "\033[1;36mINFO: 最後に、以下のコマンドを実行してください(少し時間をおくこと)\033[0m"
  echo -e "\033[1;38msed -i '' '/^,,/d' $main_file\033[0m"
  echo -e "\033[1;38msed -i '' 's/,,$//g' $main_file\033[0m"
  echo -e "\033[1;38msed -i '' 's/^2024/,,\\\\n2024/g' $main_file\033[0m"
fi
