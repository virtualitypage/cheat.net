#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
origin="/Volumes/Internal/var/log/tree"
dest="$current_dir/GL-MT3000 (Beryl AX) Detail Configuration"
origin_file="$dest/Origin Directory Tree.csv"
dest_file="$dest/CLI - Directory Tree-表1.csv"

function origin_directory_tree_convert () {
  cp --recursive "$origin" "$dest"
  dir_table=("bin" "dev" "etc" "lib" "overlay" "rom" "sbin" "sys" "tmp" "usr" "www")
  for i in {1..11}; do
    dir="${dir_table[$i - 1]}"
    sed -i '' -e '$d' -e '$d' -e '$d' "$dest/tree/$dir.csv"
    cat "$dest/tree/$dir.csv" >> "$origin_file"
    sed -i '' "s/\"\/$dir\"/\"$dir\"/g" "$origin_file"
  done
  sed -i '' 's/  //g' "$origin_file"
  sed -i '' -e 's/ ├ //g' -e 's/│ //g' -e 's/│//g' -e 's/├ //g' -e 's/└ //g' "$origin_file"
}

function dest_directory_tree_convert () {
  cat "$dest_file" | tr -d '\r' > "$dest_file.tmp"
  LC_ALL=C sed -e 's/^/"/g' -e 's/$/"/g' "$dest_file.tmp" > "$dest_file"
  sed -i '' 's/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//g' "$dest_file"
  sed -i '' 's/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//g' "$dest_file"
  sed -i '' -e 's/,,//g' -e 's/,//g' "$dest_file"
  sed -i '' -e 's/│//g' -e 's/├//g' -e 's/└//g' "$dest_file"
  sed -i '' '/"."/d' "$dest_file"
  rm "$dest_file.tmp"
}

if [ "$origin" ] && [ "$dest" ]; then
  origin_directory_tree_convert
  dest_directory_tree_convert
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mファイルは $dest に格納されています。\033[0m"
  echo
else
  echo -e "\033[1;31mERROR: \"GL-MT3000 (Beryl AX) Detail Configuration\"ディレクトリが存在しません。GL-MT3000 (Beryl AX) Detail Configuration.numbers を csv で書き出して下さい。\033[0m"
  echo
  exit 1
fi
