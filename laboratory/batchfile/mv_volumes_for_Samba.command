#!/bin/bash

today=$(date '+%Y-%m-%d')
today_string=$(date '+%Y年%-m月%-d日')

src_volume="/Volumes/Untitled/DCIM/100MEDIA"
dst_volume="/Volumes/Internal/var/cache"
destination="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/動画用フォルダ"
archive="/Volumes/Internal/var/cache/archive"
logfile="$destination/mv_volumes_$today.log"

src_file="DSCF0001.AVI"
date_dir=$(stat -f "%Sm" -t "%Y-%-m-%-d" $src_volume/$src_file)
queue="$HOME/Desktop/$date_dir"
disk_free="diskFree.log"

DISK="Untitled"
SERVER="Internal"

mp4_files=()
mov_files=()
avi_files=()
files_found_mp4=false
files_found_mov=false
files_found_avi=false

function stream_editor () {
  sed -i '' 's/\[1;31m//g' "$logfile"
  sed -i '' 's/\[1;32m//g' "$logfile"
  sed -i '' 's/\[1;33m//g' "$logfile"
  sed -i '' 's/\[1;36m//g' "$logfile"
  sed -i '' 's/\[0m//g' "$logfile"
  sed -i '' 's/building file list ... /building file list .../g' "$logfile"
}

function end_point () {
  message=$(
    cat << EOF
logout

Saving session...
...copying shared history...
...saving history...truncating history files...
...completed.

[プロセスが完了しました]
EOF
  )
  message=$(perl -pe 'chomp if eof' <<< "$message")
  echo "$message" | perl -pe 'chomp if eof' >> "$logfile"
}

function enqueue () {
  main_file="$date_dir status.txt"
  cd $HOME/Desktop || exit

  if [ ! -e "$date_dir" ]; then
    mkdir "$date_dir"
  elif [ ! -d "$date_dir" ]; then
    echo -e "\033[1;36mINFO: \"$date_dir\" は保存フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir archive
    echo "mv -v $queue $archive"
    mv -v "$queue" $archive
    mkdir "$date_dir"
    echo
  fi
  echo -e "\033[1;36mINFO: DISK \"$DISK\" にて動画ファイルを検索しています…\033[0m"
  for file in "$src_volume"/*; do
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
  echo -e "\033[1;36mINFO: 動画ファイルのエンキュー処理を実行します…\033[0m"
  echo "rsync --archive --human-readable --progress $src_volume/* $queue"
  rsync --archive --human-readable --progress $src_volume/* "$queue"

  while [ $? -ne 0 ]; do
    echo
    echo -e "\033[1;33mWARNING: rsync コマンドが異常終了しました。3秒後に同期処理を再度実行します\033[0m"
    sleep 3
    echo "rsync --archive --human-readable --progress $src_volume/* $queue"
    rsync --archive --human-readable --progress $src_volume/* "$queue"
  done
  echo

  if [ $? -eq 0 ]; then
    echo "rm $src_volume/*"
    rm $src_volume/*
  fi

  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルのエンキュー処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mDISK \"$DISK\" 内のファイルは $queue に格納されています。\033[0m"
  echo
}

function dequeue () {
  cd $dst_volume || exit

  if [ ! -e "$date_dir" ]; then
    mkdir "$date_dir"
  elif [ ! -d "$date_dir" ]; then
    echo -e "\033[1;36mINFO: \"$date_dir\" は保存フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir archive
    echo "mv -v $dst_volume/$date_dir $archive"
    mv -v "$dst_volume/$date_dir" $archive
    mkdir "$date_dir"
    echo
  fi
  echo -e "\033[1;36mINFO: デキュー領域 \"$queue\" にて動画ファイルを検索しています…\033[0m"
  for file in "$queue"/*; do
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
  echo -e "\033[1;36mINFO: 動画ファイルをSERVER \"$SERVER\" に移動しています…\033[0m"
  echo "rsync --archive --human-readable --progress $queue/* $dst_volume/$date_dir"
  rsync --archive --human-readable --progress $queue/* "$dst_volume/$date_dir"

  while [ $? -ne 0 ]; do
    echo
    echo -e "\033[1;33mWARNING: rsync コマンドが異常終了しました。3秒後に同期処理を再度実行します\033[0m"
    sleep 3
    echo "rsync --archive --human-readable --progress $queue/* $dst_volume/$date_dir"
    rsync --archive --human-readable --progress $queue/* "$dst_volume/$date_dir"
  done
  echo

  if [ $? -eq 0 ]; then
    echo "rm -rf $queue"
    rm -rf $queue
  fi

  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの同期処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mデキュー領域 \"$queue\" 内のファイルは $dst_volume/$date_dir に格納されています。\033[0m"
  echo
  stream_editor
  end_point
  echo -e "\033[1;36mINFO: SERVER \"$SERVER\" のディスク容量を記録しています…\033[0m"
  echo "・$today_string" >> "$destination/$disk_free"
  echo "df -H $src_volume >> $destination/$disk_free"
  df -H $src_volume >> "$destination/$disk_free"
  echo >> "$destination/$disk_free"
  echo
  echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" のディスク容量を記録しました\033[0m"
}

exec > >(tee -a "$logfile")

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -e $src_volume ]; then
  if [ -e $dst_volume ]; then
    echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" は有効です。\033[0m"
    echo
    enqueue
    dequeue
  elif [ -e $src_volume ] && [ ! -e $dst_volume ]; then
    echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;31mERROR: SERVER \"$SERVER\" にアクセス出来ません。サーバーにアクセスされているか確認して再度実行してください。\033[0m"
    echo
    exit 1
  fi
elif [ ! -e $src_volume ]; then
  echo -e "\033[1;31mERROR: 転送元であるDISK \"$DISK\" が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
