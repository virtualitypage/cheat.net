#!/bin/bash

today=$(date '+%Y-%m-%d')
today_string=$(date '+%Y年%-m月%-d日')

dirs="/Volumes/HDCL-UT/*"
src_volume="/Volumes/HDCL-UT"
src_volume_path="/Volumes/HDCL-UT/$today"

HDD="HDCL-UT"
dst_volume="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/動画用フォルダ"
disk_free="diskFree.log"
archive="/Volumes/HDCL-UT/archive"
logfile="$dst_volume/mv_google_drive_$today.log"

mp4_files=()
mov_files=()
avi_files=()
files_found_mp4=false
files_found_mov=false
files_found_avi=false

ascii=$(
  cat << EOF
    ####     #      #  ######  #      #  ######  #  ##     #    #####
   #    ##   #      #  #       #      #  #       #  ###    #   ##    #
  #      #   #      #  #       #      #  #       #  # #    #  ##      
  #      ##  #      #  #       #      #  #       #  #  #   #  #       
  #      ##  #      #  ######  #      #  ######  #  #  ##  #  #    ####
  #      ##  #      #  #       #      #  #       #  #   #  #  #       #
  ##  #  #   #      #  #       #      #  #       #  #    # #  ##      #
   ##  ###    #    #   #        #    #   #       #  #    # #   ##   ##
    ######     ####    ######    ####    ######  #  #     ##    #####
EOF
)

function progress_bar () {
  echo
  for i in {1..50}; do
    arrow="\e[1;34m==>\e[0m"
    sleep 0.005
    progress_bar="$(yes "#" | head -n "${i}" | tr -d '\n')"
    printf "\r$arrow \e[1;32mrm [%3d/100] %s" $((i * 2)) "${progress_bar}"
  done
  printf "\n"
  echo
}

function file_exists () {
  echo
  echo -e "\033[1;33mWARNING: 重複するフォルダ名は指定できません \"mkdir\"\033[0m"
  rsync_clone_folder
}

function stream_editor () {
  sed -i '' 's/\[1;31m//g' "$logfile"
  sed -i '' 's/\[1;32m//g' "$logfile"
  sed -i '' 's/\[1;33m//g' "$logfile"
  sed -i '' 's/\[1;34m//g' "$logfile"
  sed -i '' 's/\[1;35m//g' "$logfile"
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

function rsync_clone_folder () {
  if [ ! -d "$src_volume_path" ] && [ -e "$src_volume_path" ]; then
    echo
    echo -e "\033[1;36mINFO: \"$today\" は転送用フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir $src_volume/archive
    echo "mv -v $src_volume_path $archive"
    mv -v "$src_volume_path" $archive
    echo
    echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" を作成中...\033[0m"
    echo "mkdir -v $src_volume_path"
    mkdir -v "$src_volume_path"
    ls -ld "$src_volume_path" # ディレクトリのみ表示
  elif [ ! -e "$src_volume_path" ]; then
    echo
    echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" を作成中...\033[0m"
    echo "mkdir -v $src_volume_path"
    mkdir -v "$src_volume_path"
    ls -ld "$src_volume_path" # ディレクトリのみ表示
  elif [ -d "$src_volume_path" ]; then
    echo
    echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" を確認中...\033[0m"
    echo "ls -ld $src_volume_path"
    ls -ld "$src_volume_path" # ディレクトリのみ表示
  fi

  echo
  echo -e "\033[1;32mHDD \"$HDD\" から以下のフォルダが検出されました\033[0m"
  for d in $dirs; do
    dirname=$(basename "$d")
    echo -e "\033[1;36m> $dirname\033[0m"
    sleep 0.05
  done
  echo

  file_limit=48 # ファイル数の制限
  file_count=0  # ファイル数のカウント

  rm_file_limit=48
  rm_file_count=0

  while true; do
    read -p "複製したいフォルダの名前を入力して下さい: " directory
    echo "複製したいフォルダの名前を入力して下さい: $directory" >> "$logfile"
    if [ "$directory" == "$today" ]; then
      echo -e "\033[1;33mWARNING: 転送用フォルダ \"$today\" は複製できません。他のフォルダ名を入力してください\033[0m"
      echo
      continue
    elif [ ! -d $src_volume/"$directory" ]; then
      echo -e "\033[1;33mWARNING: \"$directory\" というフォルダは存在しないか複製できません。他のフォルダ名を入力してください\033[0m"
      echo
      continue
    elif [ "$directory" ]; then
      cd $src_volume || exit
      mkdir $src_volume/"$directory"_TF 2>/dev/null || file_exists
      echo
      echo -e "\033[1;36mINFO: 複製された一時フォルダ \"${directory}_TF\" に動画ファイルを転送しています…\033[0m"
      echo "rsync --archive --human-readable --progress $src_volume/$directory/* $src_volume/${directory}_TF"
      rsync --archive --human-readable --progress "$src_volume/$directory/*" "$src_volume/$directory"_TF
      echo
      echo -e "\033[1;36mINFO: 一時フォルダ \"${directory}_TF\" から転送用フォルダ \"$today\" に動画ファイルを転送しています…\033[0m"
      echo "rsync --archive --human-readable --progress $src_volume/${directory}_TF/* $src_volume/$today"
      for file in "$src_volume/$directory"_TF/*; do # 送信対象のファイルをループで処理
        rsync --archive --human-readable --progress "$file" "$src_volume/$today"
        ((file_count++))                         # 送信対象のファイル数をインクリメント
        if [ $file_count -ge $file_limit ]; then # 送信対象のファイル数が制限に達したらループを終了
          break
        fi
      done
      echo
      echo -e "\033[1;36mINFO: 一時フォルダ \"${directory}_TF\" から動画ファイルを削除しています…\033[0m"
      # read -p "一時フォルダ ${directory}_TF から動画ファイルを削除します。よろしいですか？(\"yes\"で削除): " yesno
      # if [ "$yesno" = "yes" ]; then
      echo "rm $src_volume/${directory}_TF/*"
      progress_bar
      for file in "$src_volume/$directory"_TF/*; do # 削除対象のファイルをループで処理
        rm "$file"
        ((rm_file_count++))                            # 削除対象のファイル数をインクリメント
        if [ $rm_file_count -ge $rm_file_limit ]; then # 削除対象のファイル数が制限に達したらループを終了
          break
        fi
      done
      echo -e "\033[1;32mSUCCESS: 一時フォルダ \"${directory}_TF\" から動画ファイルを削除しました\033[0m"
      # fi
      echo
      break
    elif [ -z "$directory" ]; then
      echo -e "\033[1;31mERROR: 指定されたディレクトリは存在しません\033[0m"
      echo
      continue
    fi
  done
  stream_editor
}

function automator_rsync_google_drive () {
  exec > >(tee -a "$logfile")
  file_limit=48 # ファイル数の制限
  file_count=0  # ファイル数のカウント

  rm_file_limit=48
  rm_file_count=0

  directory_TF=$(find $src_volume -type d -iname '*_TF' 2>/dev/null)
  directory_TF=$(basename "$directory_TF")
  echo
  echo
  echo -e "\033[1;36mINFO: 一時フォルダ \"$directory_TF\" から転送用フォルダ \"$today\" に動画ファイルを転送しています…\033[0m"
  echo "rsync --archive --human-readable --progress $src_volume/$directory_TF/* $src_volume/$today"
  for file in "$src_volume/$directory_TF"/*; do # 送信対象のファイルをループで処理
    rsync --archive --human-readable --progress "$file" "$src_volume/$today"
    ((file_count++))                           # 送信対象のファイル数をインクリメント
    if [ $file_count -ge "$file_limit" ]; then # 送信対象のファイル数が制限に達したらループを終了
      break
    fi
  done
  echo
  echo -e "\033[1;36mINFO: 一時フォルダ \"$directory_TF\" から動画ファイルを削除しています…\033[0m"
  # read -p "一時フォルダ ${directory}_TF から動画ファイルを削除します。よろしいですか？(\"yes\"で削除): " yesno
  # if [ "$yesno" = "yes" ]; then
  echo "rm $src_volume/$directory_TF/*"
  progress_bar
  for file in "$src_volume/$directory_TF"/*; do # 削除対象のファイルをループで処理
    rm "$file"
    ((rm_file_count++))                              # 削除対象のファイル数をインクリメント
    if [ $rm_file_count -ge "$rm_file_limit" ]; then # 削除対象のファイル数が制限に達したらループを終了
      break
    fi
  done
  echo -e "\033[1;32mSUCCESS: 一時フォルダ \"$directory_TF\" から動画ファイルを削除しました\033[0m"
  # fi
  echo
  cd $src_volume/"$today" || exit
  echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" にて動画ファイルを検索しています…\033[0m"
  for file in "$src_volume_path"/*; do
    if [ -f "$file" ]; then
      mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mp4_search_result" ]; then
        mp4_files+=("$mp4_search_result")
        files_found_mp4=true
        echo -e "\033[1;32mfiles found: $(basename "$mp4_search_result")\033[0m"
        sleep 0.05
      fi
      mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mov_search_result" ]; then
        mov_files+=("$mov_search_result")
        files_found_mov=true
        echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
        sleep 0.05
      fi
      avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
      if [ -n "$avi_search_result" ]; then
        avi_files+=("$avi_search_result")
        files_found_avi=true
        echo -e "\033[1;32mfiles found: $(basename "$avi_search_result")\033[0m"
        sleep 0.05
      fi
    fi
  done
  echo

  txt_file="$today status.txt"

  if [ "$files_found_mp4" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mp4)のステータスを取得しています…\033[0m"
    for mp4_file in "${mp4_search_result[@]}"; do
      mp4_file=$(basename "$mp4_file")
      if [ ! -e "$src_volume_path/$mp4_file" ]; then
        continue
      fi
      mp4_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_volume_path/$mp4_file")
      echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> $txt_file\033[0m"
      if [ "$first_file" = true ]; then
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  if [ "$files_found_mov" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを取得しています…\033[0m"
    for mov_file in "${mov_files[@]}"; do
      mov_file=$(basename "$mov_file")
      if [ ! -e "$src_volume_path/$mov_file" ]; then
        continue
      fi
      mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_volume_path/$mov_file")
      echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> $txt_file\033[0m"
      if [ "$first_file" = true ]; then
        echo "$(basename "$mov_file") -> $mov_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$mov_file") -> $mov_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  if [ "$files_found_avi" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(avi)のステータスを取得しています…\033[0m"
    for avi_file in "${avi_files[@]}"; do
      avi_file=$(basename "$avi_file")
      if [ ! -e "$src_volume_path/$avi_file" ]; then
        continue
      fi
      avi_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$avi_file")
      echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> $txt_file\033[0m"
      if [ "$first_file" = true ]; then
        echo "$(basename "$avi_file") -> $avi_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$avi_file") -> $avi_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  disk_limit="19532000" #duからすれば10GB
  disk_usage=$(du -s "$src_volume_path" | cut -f1)
  urandom=$(cat /dev/urandom | LC_CTYPE=C tr -dc '0-9' | fold -w 5 | head -n 1 | sort | uniq)

  if [ "$disk_usage" -gt $disk_limit ]; then
    echo -e "\033[1;33m#####################################################\033[0m"
    echo -e "\033[1;33m# WARNING: 転送量がディスク許容量(10GB)を超えました #\033[0m"
    echo -e "\033[1;33m#####################################################\033[0m"
    echo
    echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" を圧縮しています…\033[0m"
    cd $src_volume 2>/dev/null || exit
    echo "zip -r ${today}_$urandom.zip $today/"
    zip -r "$today"_"$urandom".zip "$today/"
    echo
    echo -e "\033[1;36mINFO: \"${today}_$urandom.zip\" を .../動画用フォルダに転送しています…\033[0m"
    echo "rsync --archive --human-readable --progress $src_volume/${today}_$urandom.zip $dst_volume"
    rsync --archive --human-readable --progress "$src_volume"/"$today"_"$urandom".zip "$dst_volume"
    echo
  else
    echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" を圧縮しています…\033[0m"
    cd $src_volume 2>/dev/null || exit
    echo "zip -r ${today}_$urandom.zip $today/"
    zip -r "$today"_"$urandom".zip "$today/"
    echo
    echo -e "\033[1;36mINFO: \"${today}_$urandom.zip\" を .../動画用フォルダに転送しています…\033[0m"
    echo "rsync --archive --human-readable --progress $src_volume/${today}_$urandom.zip $dst_volume"
    rsync --archive --human-readable --progress "$src_volume"/"$today"_"$urandom".zip "$dst_volume"
    echo
  fi

  echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" から動画ファイルを削除しています…\033[0m"
  echo "rm $src_volume_path/*"
  progress_bar
  rm "$src_volume_path"/*
  echo -e "\033[1;32mSUCCESS: 転送用フォルダ \"$today\" から動画ファイルを削除しました\033[0m"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの転送処理とステータス取得処理が正常に終了しました\033[0m"
  echo -e "\033[1;32m$src_volume_path 配下のファイルは .../動画用フォルダに格納されています\033[0m"
  echo
  if [ -e "$src_volume/${today}_$urandom.zip" ]; then
    echo -e "\033[1;36mINFO: HDD \"$HDD\" から \"${today}_$urandom.zip\" を削除しています…\033[0m"
    echo "rm -v $src_volume/${today}_$urandom.zip"
    rm -v $src_volume/"$today"_"$urandom".zip
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" から \"${today}_$urandom.zip\" を削除しました\033[0m"
    echo
  fi

  if [ -z "$(ls "$src_volume_path" 2>/dev/null)" ] && [ -z "$(ls "$src_volume/$directory_TF" 2>/dev/null)" ]; then
    echo -e "\033[1;36mINFO: HDD \"$HDD\" から転送用フォルダ \"$today\" と一時フォルダ \"$directory_TF\" を削除しています…\033[0m"
    echo "rmdir -v $src_volume_path"
    rmdir -v "$src_volume_path"
    echo
    echo "rmdir -v $src_volume/$directory_TF"
    rmdir -v $src_volume/"$directory"_TF
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" から転送用フォルダ \"$today\" と一時フォルダ \"$directory_TF\" を削除しました\033[0m"
    echo
    echo -e "\033[1;36mINFO: HDD \"$HDD\" のディスク容量を記録しています…\033[0m"
    echo "・$today_string" >> "$dst_volume"/$disk_free
    echo "df -H $src_volume >> $dst_volume/$disk_free"
    df -H $src_volume >> "$dst_volume"/$disk_free
    echo >> "$dst_volume"/$disk_free
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" のディスク容量を記録しました\033[0m"
    echo
    stream_editor
    end_point
  elif [ -s "$src_volume/$directory_TF" ]; then
    interval=$(date -j -v+10M "+%H時%M分%S秒")
    echo -e "\033[1;35mQUEUEING: Google ドライブの同期処理が終了するまで10分間待機します…\033[0m"
    echo -e "\033[1;35m          \"$interval\" から処理を再開します\033[0m"
    echo
    echo -e "\033[1;35m$ascii\033[0m"
    stream_editor
    sleep 600
    automator_rsync_google_drive
  fi
}

function mv_google_drive () {
  exec > >(tee -a "$logfile")
  cd "$src_volume_path" || exit
  echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" にて動画ファイルを検索しています…\033[0m"
  for file in "$src_volume_path"/*; do
    if [ -f "$file" ]; then
      mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mp4_search_result" ]; then
        mp4_files+=("$mp4_search_result")
        files_found_mp4=true
        echo -e "\033[1;32mfiles found: $(basename "$mp4_search_result")\033[0m"
        sleep 0.05
      fi
      mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mov_search_result" ]; then
        mov_files+=("$mov_search_result")
        files_found_mov=true
        echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
        sleep 0.05
      fi
      avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
      if [ -n "$avi_search_result" ]; then
        avi_files+=("$avi_search_result")
        files_found_avi=true
        echo -e "\033[1;32mfiles found: $(basename "$avi_search_result")\033[0m"
        sleep 0.05
      fi
    fi
  done
  echo

  txt_file="$today status.txt"

  if [ "$files_found_mp4" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mp4)のステータスを取得しています…\033[0m"
    for mp4_file in "${mp4_files[@]}"; do
      mp4_file=$(basename "$mp4_file")
      if [ ! -e "$src_volume_path/$mp4_file" ]; then
        continue
      fi
      mp4_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_volume/$today/$mp4_file")
      echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> $txt_file\033[0m"
      if [ $first_file = true ]; then
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  if [ "$files_found_mov" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを取得しています…\033[0m"
    for mov_file in "${mov_files[@]}"; do
      mov_file=$(basename "$mov_file")
      if [ ! -e "$src_volume_path/$mov_file" ]; then
        continue
      fi
      mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_volume/$today/$mov_file")
      echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> $txt_file\033[0m"
      if [ $first_file = true ]; then
        echo "$(basename "$mov_file") -> $mov_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$mov_file") -> $mov_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  if [ "$files_found_avi" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(avi)のステータスを取得しています…\033[0m"
    for avi_file in "${avi_files[@]}"; do
      avi_file=$(basename "$avi_file")
      if [ ! -e "$src_volume_path/$avi_file" ]; then
        continue
      fi
      avi_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_volume/$today/$avi_file")
      echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> $txt_file\033[0m"
      if [ $first_file = true ]; then
        echo "$(basename "$avi_file") -> $avi_stat" >> "$dst_volume/$txt_file"
        first_file=false
      else
        echo "$(basename "$avi_file") -> $avi_stat" >> "$dst_volume/$txt_file"
      fi
    done
    echo
  fi

  disk_limit="19532000" # duからすれば10GB
  disk_usage=$(du -s "$src_volume_path" | cut -f1)

  if [ "$disk_usage" -gt $disk_limit ]; then
    echo -e "\033[1;33m#####################################################\033[0m"
    echo -e "\033[1;33m# WARNING: 転送量がディスク許容量(10GB)を超えました #\033[0m"
    echo -e "\033[1;33m#####################################################\033[0m"
    echo
    echo -e "\033[1;36mINFO: 転送用のフォルダ \"$today\" を圧縮しています…\033[0m"
    cd $src_volume 2>/dev/null || exit
    echo "zip -r $today.zip $today/"
    zip -r "$today".zip "$today/"
    echo
    echo -e "\033[1;36mINFO: \"$today.zip\" を .../動画用フォルダに転送しています…\033[0m"
    echo "rsync --archive --human-readable --progress $src_volume/$today.zip $dst_volume"
    rsync --archive --human-readable --progress "$src_volume/$today.zip" "$dst_volume"
    echo
  else
    echo -e "\033[1;36mINFO: 転送用のフォルダ \"$today\" を圧縮しています…\033[0m"
    cd $src_volume 2>/dev/null || exit
    echo "zip -r $today.zip $today/"
    zip -r "$today".zip "$today/"
    echo
    echo -e "\033[1;36mINFO: \"$today.zip\" を .../動画用フォルダに転送しています…\033[0m"
    echo "rsync --archive --human-readable --progress $src_volume/$today.zip $dst_volume"
    rsync --archive --human-readable --progress "$src_volume/$today.zip" "$dst_volume"
    echo
  fi

  echo -e "\033[1;36mINFO: 転送用フォルダ \"$today\" から動画ファイルを削除しています…\033[0m"
  echo "rm $src_volume_path/*"
  progress_bar
  rm "$src_volume_path"/*
  echo -e "\033[1;32mSUCCESS: 転送用フォルダ \"$today\" から動画ファイルを削除しました\033[0m"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの転送処理とステータス取得処理が正常に終了しました\033[0m"
  echo -e "\033[1;32m$src_volume_path 配下のファイルは .../動画用フォルダに格納されています\033[0m"
  echo
  if [ -e "$src_volume/$today.zip" ]; then
    echo -e "\033[1;36mINFO: HDD \"$HDD\" から \"$today.zip\" を削除しています…\033[0m"
    echo "rm -v $src_volume/$today.zip"
    rm -v $src_volume/"$today".zip
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" から \"$today.zip\" を削除しました\033[0m"
    echo
  fi

  directory_TF=$(find $src_volume -type d -iname '*_TF' 2>/dev/null)
  directory_TF=$(basename "$directory_TF")

  if [ -z "$(ls "$src_volume_path" 2>/dev/null)" ] && [ -z "$(ls "$src_volume/$directory_TF" 2>/dev/null)" ]; then
    echo -e "\033[1;36mINFO: HDD \"$HDD\" から転送用フォルダ \"$today\" と一時フォルダ \"$directory_TF\" を削除しています…\033[0m"
    echo "rmdir -v $src_volume_path"
    rmdir -v "$src_volume_path"
    echo
    echo "rmdir -v $src_volume/$directory_TF"
    rmdir -v $src_volume/"$directory"_TF
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" から転送用フォルダ \"$today\" と一時フォルダ \"$directory_TF\" を削除しました\033[0m"
    echo
    echo -e "\033[1;36mINFO: HDD \"$HDD\" のディスク容量を記録しています…\033[0m"
    echo "・$today_string" >> "$dst_volume/$disk_free"
    echo "df -H $src_volume >> $dst_volume/$disk_free"
    df -H $src_volume >> "$dst_volume/$disk_free"
    echo >> "$dst_volume/$disk_free"
    echo
    echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" のディスク容量を記録しました\033[0m"
    echo
    stream_editor
    end_point
  elif [ -s "$src_volume/$directory_TF" ]; then
    interval=$(date -j -v+10M "+%H時%M分%S秒")
    echo -e "\033[1;35mQUEUEING: Google ドライブの同期処理が終了するまで10分間待機します…\033[0m"
    echo -e "\033[1;35m          \"$interval\" から処理を再開します\033[0m"
    echo
    echo -e "\033[1;35m$ascii\033[0m"
    stream_editor
    sleep 600
    automator_rsync_google_drive
  fi
}

exec > >(tee -a "$logfile")

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
elif [ "$failure" == "Could not resolve host" ]; then
  echo
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセスできませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -e $src_volume ]; then
  echo -e "\033[1;32mSUCCESS: HDD \"$HDD\" は有効です。\033[0m"
elif [ ! -e $src_volume ]; then
  echo -e "\033[1;31mERROR: HDD \"$HDD\" が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
  echo
  exit 1
elif [ ! -e $src_volume ] && [ ! -e "$dst_volume" ]; then
  echo -e "\033[1;31mERROR: HDD \"$HDD\" と $dst_volume が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -d "$src_volume_path" ]; then
  echo -e "\033[1;31mERROR: HDD \"$HDD\" に転送用の一時フォルダが存在しません。転送用の一時フォルダを作成・転送プロセスに移行します。\033[0m"
  rsync_clone_folder
  mv_google_drive
elif [ ! -e "$src_volume_path" ]; then
  echo -e "\033[1;31mERROR: HDD \"$HDD\" に転送用フォルダ \"$today\" が存在しません。転送用フォルダを作成・転送プロセスに移行します。\033[0m"
  rsync_clone_folder
  mv_google_drive
else
  echo -e "\033[1;33mWARNING: HDD \"$HDD\" に \"$today\" という拡張子を持たない不正なファイルがあります。\033[0m"
  echo -e "\033[1;33m         アーカイブ処理・転送用フォルダ作成・転送プロセスに移行します。\033[0m"
  rsync_clone_folder
  mv_google_drive
fi
