#!/bin/bash

today=$(date '+%Y-%m-%d')
src_volume="/Volumes/Untitled/DCIM/100MEDIA"
dst_volume="/Volumes/XXXXX" # ディスク名が判明次第変更する
src_file="DSCF0001.AVI"
DISK="Untitled"
DISK2="XXXXX" # ディスク名が判明次第変更する
archive="/Volumes/XXXXX/archive"
logfile="$dst_volume/mv_volumes_$today.log"

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

function mv_volumes () {
  date_dir=$(stat -f "%Sm" -t "%Y-%-m-%-d" $src_volume/$src_file)
  main_file="$dst_volume/$date_dir status.txt"
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
  echo -e "\033[1;36mINFO: 動画ファイルを転送先DISK \"$DISK2\" に移動しています…\033[0m"

  RETRY_COUNT=0
  while [ $RETRY_COUNT -lt 3 ]; do
    echo "rsync --archive --human-readable --progress $src_volume/* $dst_volume/$date_dir"
    if rsync --archive --human-readable --progress $src_volume/* "$dst_volume/$date_dir"; then
      echo
      read -rp "DISK \"$DISK\" 内のファイルを削除しますか？ { yes | y | no }: " yesno
      if [ "$yesno" = "yes" ] || [ "$yesno" = "y" ] || [ "$yesno" = "Y" ]; then
        echo
        echo "rm -i $src_volume/*"
        rm -i $src_volume/*
        echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" 内のファイルを削除しました\033[0m"
        echo
      else
        echo
        echo -e "\033[1;33mWARNING: DISK \"$DISK\" 内のファイル削除が中止されました。完全なデータ削除のために DISK の初期化を推奨します\033[0m"
        echo
      fi
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      echo
      echo -e "\033[1;33mWARNING: rsync コマンド実行中に問題が発生しました。3秒後に転送処理を再度実行します ($RETRY_COUNT/3)\033[0m"
      sleep 3
      echo
    fi
  done
  if [ $RETRY_COUNT -ge 3 ]; then
    echo
    echo -e "\033[1;31mERROR: 試行回数制限に到達しました。以下の事項を確認して再度実行してください。\033[0m"
    echo -e "\033[1;31m       ・転送元である DISK \"$DISK\" が挿入されている\033[0m"
    echo -e "\033[1;31m       ・転送先である DISK \"$DISK2\" が挿入されている\033[0m"
    echo -e "\033[1;31m       ・プログラムと実行環境のディレクトリパス \"$src_volume\" \"$dst_volume\" に齟齬が無い\033[0m"
    echo -e "\033[1;31m       ・DISK \"$DISK\" 内に動画ファイルが存在している\033[0m"
    exit 1
  fi

  if [ "$files_found_mp4" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mp4)のステータスを変更しています…\033[0m"
    for mp4_file in "${mp4_files[@]}"; do
      mp4_file=$(basename "$mp4_file")
      mp4_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$dst_volume/$date_dir/$mp4_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$date_dir status.txt\033[0m"
        first_file=false
      else
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$date_dir status.txt\033[0m"
      fi
    done
  fi

  if [ "$files_found_mov" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを変更しています…\033[0m"
    for mov_file in "${mov_files[@]}"; do
      mov_file=$(basename "$mov_file")
      mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$dst_volume/$date_dir/$mov_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mov_file") -> $mov_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$date_dir status.txt\033[0m"
        first_file=false
      else
        echo "$(basename "$mov_file") -> $mov_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$date_dir status.txt\033[0m"
      fi
    done
  fi

  if [ "$files_found_avi" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(avi)のステータスを変更しています…\033[0m"
    for avi_file in "${avi_files[@]}"; do
      avi_file=$(basename "$avi_file")
      avi_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$dst_volume/$date_dir/$avi_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$avi_file") -> $avi_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$date_dir status.txt\033[0m"
        first_file=false
      else
        echo "$(basename "$avi_file") -> $avi_stat" >> "$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$date_dir status.txt\033[0m"
      fi
    done
  fi
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの同期処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mDISK \"$DISK\" 内のファイルは $dst_volume/$date_dir に格納されています。\033[0m"
  echo
  stream_editor
  end_point
}

exec > >(tee -a "$logfile")

if [ -e $src_volume ]; then
  if [ -e $dst_volume ]; then
    echo
    echo -e "\033[1;32mSUCCESS: 転送元DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;32mSUCCESS: 転送先DISK \"$DISK2\" は有効です。\033[0m"
    echo
    mv_volumes
  elif [ -e $src_volume ] && [ ! -e $dst_volume ]; then
    echo
    echo -e "\033[1;32mSUCCESS: 転送元DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;31mERROR: 転送先DISK \"$DISK2\" が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
    exit 1
  fi
elif [ ! -e $src_volume ]; then
  echo
  echo -e "\033[1;31mERROR: 転送元であるDISK \"$DISK\" が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
  exit 1
fi
