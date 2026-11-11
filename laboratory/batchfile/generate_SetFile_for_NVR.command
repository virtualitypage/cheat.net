#!/bin/bash

year=2026
current_dir=$(cd "$(dirname "$0")" && pwd)
date=$(basename "$current_dir")
MMDDYYYY="$current_dir/A.csv"
HHMMSS="$current_dir/B.csv"
FILE_NAME="$current_dir/C.csv"
STATUS_TEXT="$current_dir/$date status nvr.txt"

if [ ! -e "/Volumes/Untitled2/完了済/@detection_statistic" ]; then
  mkdir -p "/Volumes/Untitled2/完了済/@detection_statistic"
fi

for ((i = 1; i <= 4; i++)); do
  dir="$current_dir/channel$i"
  STATUS_TEXT_CH="/Volumes/Untitled2/完了済/@detection_statistic/$date status nvr(channel$i).txt"
  if [ -d "$dir" ]; then
    # 日時を成形(MM/DD/YYYY)
    ls -l "$dir" | awk '{ print $9 }' | sed -e 's/-/ /g' -e 's/_/ /g' | awk '{ print $2"/"$3"/"$1 }' > "$MMDDYYYY"
    sed -i '' 's/^/\"SetFile -m \"\"/g' "$MMDDYYYY"

    # 時刻を成形(HH:MM:SS)
    ls -l "$dir" | awk '{ print $9 }' | sed -e 's/.*_//g' -e 's/-/:/g' -e 's/.mov/\"\"/g' > "$HHMMSS"

    # 対象ファイル名を成形
    ls -l "$dir" | awk '{ print $9 }' > "$FILE_NAME"
    sed -i '' 's/$/\"/g' "$FILE_NAME"

    # SetFile コマンドとして結合
    paste -d " " "$MMDDYYYY" "$HHMMSS" "$FILE_NAME" > "$current_dir/$date setfileコマンド表 - channel$i.csv"
    rm "$MMDDYYYY" "$HHMMSS" "$FILE_NAME"

    sed -i '' '1d' "$current_dir/$date setfileコマンド表 - channel$i.csv"
    cp "$current_dir/$date setfileコマンド表 - channel$i.csv" "$current_dir/$date - channel$i.sh"
    sed -i '' -e $'1i\\\n#!/bin/bash\n' -e 's|""|"|g' -e 's|^"||g' -e 's|"$||g' -e "s| $year| $dir/$year|g" "$current_dir/$date - channel$i.sh"
    "$current_dir/$date - channel$i.sh" ; sed -i '' 's/-m/-d/g' "$current_dir/$date - channel$i.sh" ; "$current_dir/$date - channel$i.sh"
    rm "$current_dir/$date - channel$i.sh"

    mov_files=()

    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
        if [ -n "$mov_search_result" ]; then
          mov_files+=("$mov_search_result")
          files_found_mov=true
          # echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
        fi
      fi
    done

    if [ "$files_found_mov" = true ]; then
      first_file=true
      echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを記録しています…\033[0m"
      for mov_file in "${mov_files[@]}"; do
        mov_file=$(basename "$mov_file")
        mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$dir/$mov_file")
        size=$(stat -f "%zB" "$dir/$mov_file" | awk '{ size=$1/1024/1024; printf "%.1fMB\n", size }')
        if [ "$first_file" = true ]; then
          echo -e "\n・Channel$i" >> "$STATUS_TEXT"
          echo "$mov_file -> $mov_stat ($size)" >> "$STATUS_TEXT"
          echo "$mov_file -> $mov_stat" >> "$STATUS_TEXT_CH"
          echo -e "\033[1;32mACQUIRE: \"$mov_stat -> $mov_stat\" >> .../$STATUS_TEXT\033[0m"
          first_file=false
        else
          echo "$mov_file -> $mov_stat ($size)" >> "$STATUS_TEXT"
          echo "$mov_file -> $mov_stat" >> "$STATUS_TEXT_CH"
          echo -e "\033[1;32mACQUIRE: \"$mov_stat -> $mov_stat\" >> .../$STATUS_TEXT\033[0m"
        fi
      done
    fi
  else
    continue
  fi
done

sed -i '' -e '1d' "$STATUS_TEXT"
