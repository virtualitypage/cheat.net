#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

directory=$1
main_file=$2.txt
example=status.txt

mp4_files=()
mov_files=()
avi_files=()
files_found=false

function usage () {
  echo "usage: 動画ファイル(mp4,mov,avi)の作成日を出力するスクリプト"
  echo "入力方法: $this [ディレクトリパス] [出力ファイル名]"
  exit 1
}

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

if [[ ! -d $1 ]]; then
  echo -e "\033[1;31mERROR: ディレクトリパスの指定に誤りがあります。正しいディレクトリパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx\033[0m"
else
  echo -e "\033[1;32mSUCCESE: ディレクトリパス $directory は有効です。\033[0m"
fi

if [ -z $2 ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $example\033[0m"
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

function show_creation_dates () {

echo -e "\033[1;32mgrep -ilE running...\033[0m"

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
    if [ -n "$mp4_search_result" ]; then
      mp4_files+=("$mp4_search_result")
      files_found=true
      echo "files found: $(basename "$mp4_search_result")"
    fi
    mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
    if [ -n "$mov_search_result" ]; then
      mov_files+=("$mov_search_result")
      files_found=true
      echo "files found: $(basename "$mov_search_result")"
    fi
    avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
    if [ -n "$avi_search_result" ]; then
      avi_files+=("$avi_search_result")
      files_found=true
      echo "Found .avi file: $(basename "$avi_search_result")"
    fi
  fi
done

sleep 2
echo -e "\033[1;32mstat -f running...\033[0m"

if [ "$files_found" = true ]; then
  first_file=true
  for mp4_file in "${mp4_files[@]}"; do
    mp4_date=$(stat -f "作成日: %SB 変更日:%Sm" -t "%Y年%m月%d日 %H:%M" "$mp4_file")
    if [ "$first_file" = true ]; then
      echo "$(basename "$mp4_file"): $mp4_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$mp4_file"): $mp4_date" >> "$main_file"
    fi
  done
fi
if [ "$files_found" = true ]; then
  first_file=true
  for mov_file in "${mov_files[@]}"; do
    mov_date=$(stat -f "作成日: %SB 変更日:%Sm" -t "%Y年%m月%d日 %H:%M" "$mov_file")
    if [ "$first_file" = true ]; then
      echo "$(basename "$mov_file"): $mov_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$mov_file"): $mov_date" >> "$main_file"
    fi
  done
fi
if [ "$files_found" = true ]; then
  first_file=true
  for avi_file in "${avi_files[@]}"; do
    avi_date=$(stat -f "作成日: %SB 変更日:%Sm" -t "%Y年%m月%d日 %H:%M" "$avi_file")
    if [ "$first_file" = true ]; then
      echo "$(basename "$avi_file"): $avi_date" >> "$main_file"
      first_file=false
    else
      echo "$(basename "$avi_file"): $avi_date" >> "$main_file"
    fi
  done
fi
if [ "$files_found" = false ]; then
  echo -e "\033[1;31mERROR: 該当するファイルは存在しません。\033[0m"
  exit 1
fi

sleep 1
echo -e "\033[1;32mALL SUCCESEFUL: 動画ファイルの作成日時の出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir/$main_file に格納されています。\033[0m"
}

if [[ -d $directory ]] && [[ -n $main_file ]]; then
  show_creation_dates
fi