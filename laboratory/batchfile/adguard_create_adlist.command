#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/Advertisement_disallow.csv"
sub_file="$current_dir/editOnly.csv"
mid_file=$(find "$current_dir" -type f -name "bookmarks_*")

function create_adlist () {
  awk '/\[広告\]/ {p=1} p' "$mid_file" > "$sub_file"
  sed -i '' '/\[広告\]/d' "$sub_file"
  sed -i '' 's/・.*//g' "$sub_file"
  sed -i '' 's/http:\/\//0.0.0.0 /g' "$sub_file"
  sed -i '' 's/https:\/\//0.0.0.0 /g' "$sub_file"
  sed -i '' 's/　//g' "$sub_file"
  sed -i '' 's/\/.*//g' "$sub_file"
  sed -i '' '/^$/d' "$sub_file"
  sort -u "$sub_file" > "$main_file"
  rm "$sub_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mAdvertisement_disallow.csv は $current_dir に格納されています。\033[0m"
}

if [ "$mid_file" ]; then
  create_adlist
fi
