#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/hw_rec setfileコマンド表.csv"
sub_file="/Volumes/Internal/var/hw_rec"

mkv_files=()

cd "$sub_file" || exit

ls -ldR */*/* | awk '{ print $9 }'
read -rp "ディレクトリパスを入力: $sub_file/" directory

cd "$directory" || exit

read -rp "リネームしますか？ { y | yes | no }: " yesno

if [ "$yesno" = y ] || [ "$yesno" = yes ]; then
  rename -s "_2a (video-converter.com)" "" *
  rename -s "_2a" "" *
fi

for file in *; do
  if [ -f "$file" ]; then
    mkv_search_result=$(find "$file" -type f -iname '*.mkv' 2>/dev/null) # .mkv ファイルを検索(大文字小文字を区別しない)
    if [ -n "$mkv_search_result" ]; then
      mkv_files+=("$mkv_search_result")
      echo -e "\033[1;32mfiles found: $mkv_search_result\033[0m"
    fi
  fi
done

echo "$directory" | sed 's/\//-/g' >> "$main_file"
for mkv_file in "${mkv_files[@]}"; do
  mov_file=$(basename "$mkv_file" | sed 's/.mkv/.mov/g')
  mkv_setfile=$(stat -f "%Sm" -t "%m/%d/%Y %H:%M:%S" "$mkv_file")
  echo "\"SetFile -m \"\"$mkv_setfile\"\" $sub_file/$directory/$mov_file\"" >> "$main_file"
  echo -e "\033[1;38mSetFile -m \"$mkv_setfile\" $sub_file/$directory/$mov_file\033[0m"
done
echo "," >> "$main_file"
