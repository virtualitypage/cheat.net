#!/bin/bash

# current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(date '+%Y-%m-%d')
# dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
dir="$HOME/Library/CloudStorage/GoogleDrive-youguigujing42@gmail.com/マイドライブ/共有フォルダ/NVR動画データ保存用"

if [ ! -e "$dir/$today" ]; then
  mkdir "$dir/$today" "$dir/$today/channel1" "$dir/$today/channel2" "$dir/$today/channel3" "$dir/$today/channel4"
  # touch "$dir/$today/channel1/時まで取得済" "$dir/$today/channel2/時まで取得済" "$dir/$today/channel3/時まで取得済" "$dir/$today/channel4/時まで取得済"
fi

for ((i = 0; i <= 3; i++)); do
  if ls "$dir/${i}_"*.mov >/dev/null 2>&1; then
    for file in "$dir/${i}_"*.mov; do
      if [ -f "$file" ]; then
        mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
        if [ -n "$mov_search_result" ]; then
          mov_files+=("$mov_search_result")
          echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
          epoch_time=$(echo -e "$(basename "$mov_search_result")" | sed -e "s/^${i}_//g" -e 's/_.*//g')
          before_name=$(echo -e "$(basename "$mov_search_result")")
          after_name=$(date -r "$epoch_time" -u +"%Y-%m-%d_%H-%M-%S")
          date=$(date -r "$epoch_time" -u +"%Y-%m-%d")
          rename "s/$before_name/$after_name.mov/" "$dir"/*
          # mv "$dir/$after_name.mov" "$dir/$date/channel$num"
          # sleep 1
        fi
      fi
    done
  else
    continue
  fi
  num=$((i + 1))
  mv $dir/$date*.mov "$dir/$date/channel$num" 2>/dev/null
  sleep 3
done

# month=01
# for ((day = 1; day <= 31; day++)); do
#   day2=$(printf "%02d\n" $day)
#   date="2026-$month-$day2"
#   if [ -e "$dir/$date" ]; then
#     rename "s/0_.*_/${date} /" "$dir/$date/channel1/"*
#     rename "s/1_.*_/${date} /" "$dir/$date/channel2/"*
#     rename "s/2_.*_/${date} /" "$dir/$date/channel3/"*
#     rename "s/3_.*_/${date} /" "$dir/$date/channel4/"*
#   fi
# done
