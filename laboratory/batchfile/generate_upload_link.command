#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/upload_link.txt"
sub_file="$current_dir/[LINE] 血祭りにあげてやるグループLINEのトーク.txt"

function generate_upload_link () {
  youtube=$(grep https://youtube.com/ "$sub_file" | cut -f3 -d $'\t')
  tiktok=$(grep https://vt.tiktok.com/ "$sub_file" | cut -f3 -d $'\t')
  x=$(grep https://x.com/ "$sub_file" | cut -f3 -d $'\t')
  nicovideo=$(grep https://www.nicovideo.jp/ "$sub_file" | cut -f3 -d $'\t')

  message=$(
    cat << EOF
$youtube

$tiktok

$x

$nicovideo
EOF
  )
  echo "$message" >> "$main_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
}

if [ -e "$sub_file" ]; then
  generate_upload_link
elif [ ! -e "$sub_file" ]; then
  echo -e "\033[1;31mERROR: $sub_file が存在しません。$sub_file を配置して再度実行してください。\033[0m"
fi
grep https://youtube.com/ 