#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="upload_link.txt"
sub_file="[LINE] 血祭りにあげてやるグループLINEのトーク.txt"

function generate_upload_link () {
  youtube=$(grep https://youtube.com/ "$current_dir/$sub_file" | cut -f3)
  tiktok=$(grep https://vt.tiktok.com/ "$current_dir/$sub_file" | cut -f3)
  x=$(grep https://x.com/ "$current_dir/$sub_file" | cut -f3)
  nicovideo=$(grep https://www.nicovideo.jp/ "$current_dir/$sub_file" | cut -f3)

message=$(cat << EOF
$youtube

$tiktok

$x

$nicovideo
EOF
)
echo "$message" >> "$current_dir"/$main_file
echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [ -e "$current_dir/$sub_file" ]; then
  generate_upload_link
elif [ ! -e "$current_dir/$sub_file" ]; then
  echo -e "\033[1;31mERROR: $sub_file が存在しません。$sub_file を配置して再度実行してください。\033[0m"
fi
