#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
directory=$current_dir
main_file=$current_dir/status.txt

mp4_files=()
mov_files=()
avi_files=()
files_found_mp4=false
files_found_mov=false
files_found_avi=false

echo -e "\033[1;32mfind running...\033[0m"
echo
for file in "$directory"/*; do
  if [ -f "$file" ]; then
    mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
    if [ -n "$mp4_search_result" ]; then
      mp4_files+=("$mp4_search_result")
      files_found_mp4=true
      echo -e "\033[1;32mfiles found: $(basename "$mp4_search_result")\033[0m"
    fi
    mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
    if [ -n "$mov_search_result" ]; then
      mov_files+=("$mov_search_result")
      files_found_mov=true
      echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
    fi
    avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
    if [ -n "$avi_search_result" ]; then
      avi_files+=("$avi_search_result")
      files_found_avi=true
      echo -e "\033[1;32mfiles found: $(basename "$avi_search_result")\033[0m"
    fi
  fi
done
echo
sleep 1
echo -e "\033[1;32mstat -f running...\033[0m"
echo
if [ "$files_found_mp4" = true ]; then
  first_file=true
  for mp4_file in "${mp4_files[@]}"; do
    mp4_date=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$mp4_file") # modified:%Smでファイルの変更日を取得
    if [ "$first_file" = true ]; then
      echo "$(basename "$mp4_file") -> $mp4_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$mp4_file") -> $mp4_date" >> "$main_file"
    fi
  done
fi

if [ "$files_found_mov" = true ]; then
  first_file=true
  for mov_file in "${mov_files[@]}"; do
    mov_date=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$mov_file")
    if [ "$first_file" = true ]; then
      echo "$(basename "$mov_file") -> $mov_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$mov_file") -> $mov_date" >> "$main_file"
    fi
  done
fi

if [ "$files_found_avi" = true ]; then
  first_file=true
  for avi_file in "${avi_files[@]}"; do
    avi_date=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$avi_file")
    if [ "$first_file" = true ]; then
      echo "$(basename "$avi_file") -> $avi_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$avi_file") -> $avi_date" >> "$main_file"
    fi
  done
fi

if [ "$files_found_mp4" = false ] && [ "$files_found_mov" = false ] && [ "$files_found_avi" = false ]; then
  echo -e "\033[1;31mERROR: 該当するファイルは存在しません。\033[0m"
  exit 1
fi

sleep 1
echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの作成日時の出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
echo
