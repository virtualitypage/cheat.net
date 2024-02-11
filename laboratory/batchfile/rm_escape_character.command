#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
mv_volumes=$(find "$current_dir" -type f -name "mv_volumes_*.log" 2>/dev/null)
mv_google_drive=$(find "$current_dir" -type f -name "mv_google_drive_*.log" 2>/dev/null)

function rm_ESC_mv_volumes () {
  sed -i '' 's/? ?/\n/g' "$mv_volumes"
  sed -i '' 's/?//g' "$mv_volumes"
  while [ $? -ne 0 ]; do
    echo
    echo -e "\033[1;33mWARNING: sed コマンドが異常終了しました。変換する文字列が存在しない可能性があります\033[0m"
    sleep 1
    sed -i '' 's/? ?/\n/g' "$mv_volumes"
    sed -i '' 's/?//g' "$mv_volumes"
  done
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルに含まれるESCキャラクタ変換処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$mv_volumes は $current_dir に格納されています。\033[0m"
}

function rm_ESC_mv_google_drive () {
  sed -i '' 's/? ?/\n/g' "$mv_google_drive"
  sed -i '' 's/?//g' "$mv_google_drive"
  while [ $? -ne 0 ]; do
    echo
    echo -e "\033[1;33mWARNING: sed コマンドが異常終了しました。変換する文字列が存在しない可能性があります\033[0m"
    sleep 1
    sed -i '' 's/? ?/\n/g' "$mv_google_drive"
    sed -i '' 's/?//g' "$mv_google_drive"
  done
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルに含まれるESCキャラクタ変換処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$mv_google_drive は $current_dir に格納されています。\033[0m"
}

if [ -f "$mv_volumes" ]; then
  rm_ESC_mv_volumes
fi

if [ -f "$mv_google_drive" ]; then
  rm_ESC_mv_google_drive
fi
