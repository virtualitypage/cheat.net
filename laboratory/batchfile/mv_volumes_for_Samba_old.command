#!/bin/bash

today=$(date '+%Y-%m-%d')
time=$(date '+%H:%m:%d')

src_dir="/Volumes/Untitled/DCIM/100MEDIA"
src_dir2="/Volumes/Untitled/DCIM/101MEDIA"
dst_dir="/Volumes/Internal/var/cache"
destination="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/動画用フォルダ"
archive="/Volumes/Internal/var/cache/archive"
logfile="$destination/mv_volumes_$today.log"
stdout="/Volumes/Internal/var/log/stdout"

src_file="DSCF0001.AVI"
date_dir=$(stat -f "%Sm" -t "%Y-%-m-%-d" $src_dir/$src_file 2>/dev/null)
date_dir2=$(stat -f "%Sm" -t "%Y-%-m-%-d" $src_dir2/$src_file 2>/dev/null)
queue="$HOME/Desktop/$date_dir"
queue2="$HOME/Desktop/$date_dir2"
disk_free="$destination/diskFree.json"

DISK="Untitled"
SERVER="Internal"

mp4_files=()
mov_files=()
avi_files=()
files_found_mp4=false
files_found_mov=false
files_found_avi=false

command_name=$(basename "$0")
echo "$command_name" | pbcopy

function success_trigger () {
  cat << EOF > "Trigger page - Success.scpt"
tell application "Safari"
  activate
end tell

tell application "Safari"
  activate
  set bounds of window 1 to {0, 0, 1000, 975} -- ウィンドウの位置とサイズ(左上隅の座標と幅、高さ)を指定
  tell application "Safari"
    quit
    delay 0.5
    activate
    set bounds of window 1 to {0, 0, 1100, 1100} -- ウィンドウの位置とサイズ(左上隅の座標と幅、高さ)を指定
    tell window 1
      make new tab with properties {URL:"https://virtualitypage.github.io/cheat.net/share-server/trigger"}
    end tell
    close tab 1 of window 1 -- スタートページを閉じる(window 1 は一つ目のタブを指す)
    delay 2
    tell application "System Events"
      do shell script "/usr/local/bin/cliclick c:655,300" -- select text box
      delay 0.5
      keystroke "v" using {command down} -- paste
      delay 0.5
      do shell script "/usr/local/bin/cliclick c:635,380" -- select "正常終了"
      delay 0.5
      do shell script "/usr/local/bin/cliclick c:550,500" -- select "トリガーオン"
    end tell
  end tell
end tell
EOF
}

function failure_trigger () {
  cat << EOF > "Trigger page - Failure.scpt"
tell application "Safari"
  activate
end tell

tell application "Safari"
  activate
  set bounds of window 1 to {0, 0, 1000, 975} -- ウィンドウの位置とサイズ(左上隅の座標と幅、高さ)を指定
  tell application "Safari"
    quit
    delay 0.5
    activate
    set bounds of window 1 to {0, 0, 1100, 1100} -- ウィンドウの位置とサイズ(左上隅の座標と幅、高さ)を指定
    tell window 1
      make new tab with properties {URL:"https://virtualitypage.github.io/cheat.net/share-server/trigger"}
    end tell
    close tab 1 of window 1 -- スタートページを閉じる(window 1 は一つ目のタブを指す)
    delay 2
    tell application "System Events"
      do shell script "/usr/local/bin/cliclick c:655,300" -- select text box
      delay 0.5
      keystroke "v" using {command down} -- paste
      delay 0.5
      do shell script "/usr/local/bin/cliclick c:635,430" -- select "エラー終了"
      delay 0.5
      do shell script "/usr/local/bin/cliclick c:550,500" -- select "トリガーオン"
    end tell
  end tell
end tell
EOF
}

function motd () {
  ttys=$(who | awk 'NR==2 { print $2 }')
  LC_ALL=C last | awk -v ttys="$ttys" -v time="$time" 'NR>1 { print "Current login:", $3, $4, time, "on", ttys}' >> "$logfile"
  cat << 'EOF' >> "$logfile"

                        ___  ____
  _ __ ___   __ _  ___ / _ \/ ___|
 | '_ ` _ \ / _` |/ __| | | \___ \
 | | | | | | (_| | (__| |_| |___) |
 |_| |_| |_|\__,_|\___|\___/|____/

 ---------------------------------------------------
 uname
 ---------------------------------------------------
EOF
  echo "$users@$hostname ~ % $0 ; exit;" >> "$logfile"
}

function stream_editor () {
  uname=$(uname -v | awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10}' | sed 's/;//g')
  sed -i '' 's/\[1;31m//g' "$logfile"
  sed -i '' 's/\[1;32m//g' "$logfile"
  sed -i '' 's/\[1;33m//g' "$logfile"
  sed -i '' 's/\[1;36m//g' "$logfile"
  sed -i '' 's/\[0m//g' "$logfile"
  sed -i '' 's/building file list ... /building file list .../g' "$logfile"
  sed -i '' "s/uname/$uname/g" "$logfile"
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

function ps_check () {
  local pid_array
  pid_array=$(pgrep -f "$0" | awk 'NR>1 { print $1 }') # pgrep で出力された PID の2行目以降を取得
  while IFS= read -r pid; do
  if [ -n "$pid_array" ]; then
    echo -e "\033[1;33mWARNING: kill $pid\033[0m"
    kill "$pid" 2>/dev/null
  fi
  done <<< "$pid_array" # pid_array の内容を while ループに渡す
}

function enqueue_info () {
  num_files=$(ls -F $src_dir | grep -v / | wc -l)
  total_time=$(echo "4 * $num_files" | bc) # 転送時間(秒)／個 * データ個数 = 総転送時間
  current_time=$(date +%s) # 現在の時刻を取得
  end_time=$(echo "$current_time + $total_time" | bc) # 転送時間を加算
  end_time=$(date -j -f "%s" "$end_time" "+%Y/%m/%d %H時%M分%S秒") # human-readable
  echo
  echo -e "\033[1;36mINFO: 動画ファイルのエンキュー処理を実行します…\033[0m"
  echo
  echo -e "\033[1;36mINFO: エンキュー処理は \"$end_time\" に完了する見込みです\033[0m"
}

function enqueue_info2 () {
  num_files=$(ls -F $src_dir2 | grep -v / | wc -l)
  total_time=$(echo "4 * $num_files" | bc) # 転送時間(秒)／個 * データ個数 = 総転送時間
  current_time=$(date +%s) # 現在の時刻を取得
  end_time=$(echo "$current_time + $total_time" | bc) # 転送時間を加算
  end_time=$(date -j -f "%s" "$end_time" "+%Y/%m/%d %H時%M分%S秒") # human-readable
  echo
  echo -e "\033[1;36mINFO: 動画ファイルのエンキュー処理を実行します…\033[0m"
  echo
  echo -e "\033[1;36mINFO: エンキュー処理は \"$end_time\" に完了する見込みです\033[0m"
}

function dequeue_info () {
  num_files=$(ls -F "$queue" | grep -v / | wc -l)
  total_time=$(echo "6 * $num_files" | bc) # 転送時間(秒)／個 * データ個数 = 総転送時間
  current_time=$(date +%s) # 現在の時刻を取得
  end_time=$(echo "$current_time + $total_time" | bc) # 転送時間を加算
  end_time=$(date -j -f "%s" "$end_time" "+%Y/%m/%d %H時%M分%S秒") # human-readable
  echo
  echo -e "\033[1;36mINFO: 動画ファイルを SERVER \"$SERVER\" に転送しています…\033[0m"
  echo
  echo -e "\033[1;36mINFO: 転送処理は \"$end_time\" に完了する見込みです\033[0m"
}

function dequeue_info2 () {
  num_files=$(ls -F "$queue2" | grep -v / | wc -l)
  total_time=$(echo "6 * $num_files" | bc) # 転送時間(秒)／個 * データ個数 = 総転送時間
  current_time=$(date +%s) # 現在の時刻を取得
  end_time=$(echo "$current_time + $total_time" | bc) # 転送時間を加算
  end_time=$(date -j -f "%s" "$end_time" "+%Y/%m/%d %H時%M分%S秒") # human-readable
  echo
  echo -e "\033[1;36mINFO: 動画ファイルを SERVER \"$SERVER\" に転送しています…\033[0m"
  echo
  echo -e "\033[1;36mINFO: 転送処理は \"$end_time\" に完了する見込みです\033[0m"
}

function enqueue () {
  main_file="$date_dir status.txt"
  cd "$HOME/Desktop" || exit

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

  # Untitled にて動画ファイルを検索、statusファイルを作成
  echo -e "\033[1;36mINFO: DISK \"$DISK\" にて動画ファイルを検索しています…\033[0m"
  for file in "$src_dir"/*; do
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

  # Untitled にて発見された動画ファイルのステータスを記録
  if [ "$files_found_mp4" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mp4)のステータスを記録しています…\033[0m"
    for mp4_file in "${mp4_files[@]}"; do
      mp4_file=$(basename "$mp4_file")
      mp4_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir/$mp4_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi
  if [ "$files_found_mov" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを記録しています…\033[0m"
    for mov_file in "${mov_files[@]}"; do
      mov_file=$(basename "$mov_file")
      mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir/$mov_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mov_file") -> $mov_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$mov_file") -> $mov_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi
  if [ "$files_found_avi" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(avi)のステータスを記録しています…\033[0m"
    for avi_file in "${avi_files[@]}"; do
      avi_file=$(basename "$avi_file")
      avi_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir/$avi_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$avi_file") -> $avi_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$avi_file") -> $avi_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi

  # 動画ファイルのエンキュー処理。コマンド実行に3回失敗した場合、強制終了する
  enqueue_info
  RETRY_COUNT=0
  while [ $RETRY_COUNT -lt 3 ]; do
    echo "rsync --archive --human-readable --progress $src_dir/* $queue"
    if rsync --archive --human-readable --progress $src_dir/* "$queue"; then
      echo
      echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルのエンキュー処理が正常に終了しました。\033[0m"
      echo -e "\033[1;32mDISK \"$DISK\" 内のファイルはデキュー領域 \"$queue\" に格納されています。\033[0m"
      echo
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      echo
      echo -e "\033[1;33mWARNING: rsync コマンド実行中に問題が発生しました。3秒後に転送処理を再度実行します ($RETRY_COUNT/3)\033[0m"
      sleep 3
      enqueue_info
    fi
  done
  if [ $RETRY_COUNT -ge 3 ]; then
    echo
    echo -e "\033[1;31mERROR: 試行回数制限に到達しました。以下の事項を確認して再度実行してください。\033[0m"
    echo -e "\033[1;31m       ・転送元である DISK \"$DISK\" が挿入されている\033[0m"
    echo -e "\033[1;31m       ・プログラムと実行環境のディレクトリパス \"$src_dir\" \"$queue\" に齟齬が無い\033[0m"
    echo -e "\033[1;31m       ・DISK \"$DISK\" 内に動画ファイルが存在している\033[0m"
    echo -e "\033[1;31m       ・デキュー領域 \"$queue\" が存在している\033[0m"
    failure_trigger
    echo "osascript Trigger page - Failure.scpt"
    osascript "Trigger page - Failure.scpt"
    exit 1
  fi

  # if rm $src_dir/* 2>/dev/null; then
  #   echo
  #   echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" 内のファイルを削除しました\033[0m"
  # else
  #   echo
  #   echo -e "\033[1;31mERROR: $src_dir 配下のファイルが削除できませんでした。対象のファイルを含むディレクトリを検索して再度実行します\033[0m"
  #   echo
  #   target_dir=$(find "$src_file" -type f -iname '*.avi' 2>/dev/null)
  #   target_dir=$(dirname "$target_dir")
  #   echo "rm $target_dir/*"
  #   if rm "$target_dir/*" 2>/dev/null; then
  #     echo
  #     echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" 内のファイルを削除しました\033[0m"
  #   else
  #     echo
  #     echo -e "\033[1;32mERROR: $src_file を格納するディレクトリが見つかりませんでした。完全なデータ削除のために DISK の初期化を推奨します\033[0m"
  #   fi
  # fi
}

function dequeue () {
  cd $dst_dir || exit

  if [ ! -e "$date_dir" ]; then
    mkdir "$date_dir"
  elif [ ! -d "$date_dir" ]; then
    echo -e "\033[1;36mINFO: \"$date_dir\" は保存フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir archive
    echo "mv -v $dst_dir/$date_dir $archive"
    mv -v "$dst_dir/$date_dir" $archive
    mkdir "$date_dir"
    echo
  fi

  # 確認の為、デキュー領域にてファイル検索を行う
  echo -e "\033[1;36mINFO: デキュー領域 \"$queue\" にて動画ファイルを検索しています…\033[0m"
  for file in "$queue"/*; do
    if [ -f "$file" ]; then
      mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mp4_search_result" ]; then
        mp4_files+=("$mp4_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$mp4_search_result")\033[0m"
      fi
      mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mov_search_result" ]; then
        mov_files+=("$mov_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
      fi
      avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
      if [ -n "$avi_search_result" ]; then
        avi_files+=("$avi_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$avi_search_result")\033[0m"
      fi
    fi
  done

  # 動画ファイルをデキュー領域から Internal に転送させる。コマンド実行に3回失敗した場合、強制終了する
  dequeue_info
  RETRY_COUNT=0
  while [ $RETRY_COUNT -lt 3 ]; do
    echo "rsync --archive --human-readable --progress $queue/* $dst_dir/$date_dir"
    if rsync --archive --human-readable --progress "$queue"/* "$dst_dir/$date_dir"; then
      echo
      echo -e "\033[1;36mINFO: デキュー領域 \"$queue\" を削除しています…\033[0m"
      echo "rm -rf $queue"
      rm -rf "$queue" 2>/dev/null
      echo
      echo -e "\033[1;32mSUCCESS: デキュー領域 \"$queue\" を削除しました\033[0m"
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      echo
      echo -e "\033[1;33mWARNING: rsync コマンド実行中に問題が発生しました。3秒後に転送処理を再度実行します ($RETRY_COUNT/3)\033[0m"
      sleep 3
      dequeue_info
    fi
  done
  if [ $RETRY_COUNT -ge 3 ]; then
    echo -e "\033[1;31mERROR: 試行回数制限に到達しました。以下の事項を確認して再度実行してください。\033[0m"
    echo -e "\033[1;31m       ・転送先である SERVER \"$SERVER\" に接続されている\033[0m"
    echo -e "\033[1;31m       ・プログラムと実行環境のディレクトリパス \"$queue\" \"$dst_dir/$date_dir\" に齟齬が無い\033[0m"
    echo -e "\033[1;31m       ・デキュー領域 \"$queue\" 内に動画ファイルが存在する\033[0m"
    echo -e "\033[1;31m       ・SERVER \"$SERVER\" 内に転送先 \"$dst_dir/$date_dir\" が存在する\033[0m"
    failure_trigger
    echo "osascript Trigger page - Failure.scpt"
    osascript "Trigger page - Failure.scpt"
    exit 1
  fi

  # Internal のディスク容量を記録
  timestamp=$(date '+%Y/%m/%d %H:%m:%d')
  echo
  echo -e "\033[1;36mINFO: SERVER \"$SERVER\" のディスク容量を記録しています…\033[0m"
  echo "df -H $dst_dir >> $disk_free"
  df -H $dst_dir | awk -v timestamp="$timestamp" 'NR==2 {
    printf "  {\n"
    printf "    \"タイムスタンプ\": \"%s\",\n", timestamp
    printf "    \"ファイルシステム\": \"%s\",\n", $1
    printf "    \"サイズ\": {\n"
    printf "      \"容量\": \"%sB\",\n", $2
    printf "      \"使用量\": \"%sB\",\n", $3
    printf "      \"空き容量\": \"%sB\",\n", $4
    printf "      \"使用率\": \"%s\"\n", $5
    printf "    },\n"
    printf "    \"マウント先\": \"%s\"\n", $9
    printf "  },\n"
    print "]"
  }' >> "$disk_free"
  closing_brace=$(grep -nB1 -nA1 ']' "$disk_free" | awk 'NR == 1 {gsub(/-/, ""); print $1 }')
  square_brackets=$(grep -nA1 ']' "$disk_free" | awk 'NR <= 2 { gsub(/:\]|-\[/, ""); print $1 }' | sed '1s/$/,/' | tr -d '\n')
  sed -i '' "${closing_brace}s/.*/  },/" "$disk_free" # 指定行を別の文字列に置換
  sed -i '' "${square_brackets}d" "$disk_free" # 指定行を削除
  echo
  echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" のディスク容量を記録しました\033[0m"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの転送処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mデキュー領域 \"$queue\" 内のファイルは $dst_dir/$date_dir に格納されています。\033[0m"
  stream_editor
  end_point
  rsync "$logfile" $stdout
}

function enqueue2 () {
  main_file="$date_dir2 status.txt"
  cd "$HOME/Desktop" || exit

  if [ ! -e "$date_dir2" ]; then
    mkdir "$date_dir2"
  elif [ ! -d "$date_dir2" ]; then
    echo -e "\033[1;36mINFO: \"$date_dir2\" は保存フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir archive
    echo "mv -v $queue2 $archive"
    mv -v "$queue2" $archive
    mkdir "$date_dir2"
    echo
  fi

  # Untitled にて動画ファイルを検索、statusファイルを作成
  echo -e "\033[1;36mINFO: DISK \"$DISK\" にて動画ファイルを検索しています…\033[0m"
  for file in "$src_dir2"/*; do
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

  # Untitled にて発見された動画ファイルのステータスを記録
  if [ "$files_found_mp4" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mp4)のステータスを記録しています…\033[0m"
    for mp4_file in "${mp4_files[@]}"; do
      mp4_file=$(basename "$mp4_file")
      mp4_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir2/$mp4_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$mp4_file") -> $mp4_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mp4_file -> $mp4_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi
  if [ "$files_found_mov" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(mov)のステータスを記録しています…\033[0m"
    for mov_file in "${mov_files[@]}"; do
      mov_file=$(basename "$mov_file")
      mov_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir2/$mov_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$mov_file") -> $mov_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$mov_file") -> $mov_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$mov_file -> $mov_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi
  if [ "$files_found_avi" = true ]; then
    first_file=true
    echo -e "\033[1;36mINFO: 動画ファイル(avi)のステータスを記録しています…\033[0m"
    for avi_file in "${avi_files[@]}"; do
      avi_file=$(basename "$avi_file")
      avi_stat=$(stat -f "%Sm" -t "%Y年%m月%d日 %H:%M" "$src_dir2/$avi_file")
      if [ "$first_file" = true ]; then
        echo "$(basename "$avi_file") -> $avi_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$main_file\033[0m"
        first_file=false
      else
        echo "$(basename "$avi_file") -> $avi_stat" >> "$destination/$main_file"
        echo -e "\033[1;32mACQUIRE: \"$avi_file -> $avi_stat\" >> .../$main_file\033[0m"
      fi
    done
  fi

  # 動画ファイルのエンキュー処理。コマンド実行に3回失敗した場合、強制終了する
  enqueue_info2
  RETRY_COUNT=0
  while [ $RETRY_COUNT -lt 3 ]; do
    echo "rsync --archive --human-readable --progress $src_dir2/* $queue2"
    if rsync --archive --human-readable --progress $src_dir2/* "$queue2"; then
      echo
      echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルのエンキュー処理が正常に終了しました。\033[0m"
      echo -e "\033[1;32mDISK \"$DISK\" 内のファイルはデキュー領域 \"$queue2\" に格納されています。\033[0m"
      echo
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      echo
      echo -e "\033[1;33mWARNING: rsync コマンド実行中に問題が発生しました。3秒後に転送処理を再度実行します ($RETRY_COUNT/3)\033[0m"
      sleep 3
      enqueue_info2
    fi
  done
  if [ $RETRY_COUNT -ge 3 ]; then
    echo
    echo -e "\033[1;31mERROR: 試行回数制限に到達しました。以下の事項を確認して再度実行してください。\033[0m"
    echo -e "\033[1;31m       ・転送元である DISK \"$DISK\" が挿入されている\033[0m"
    echo -e "\033[1;31m       ・プログラムと実行環境のディレクトリパス \"$src_dir2\" \"$queue2\" に齟齬が無い\033[0m"
    echo -e "\033[1;31m       ・DISK \"$DISK\" 内に動画ファイルが存在している\033[0m"
    echo -e "\033[1;31m       ・デキュー領域 \"$queue2\" が存在している\033[0m"
    failure_trigger
    echo "osascript Trigger page - Failure.scpt"
    osascript "Trigger page - Failure.scpt"
    exit 1
  fi

  # if rm $src_dir/* 2>/dev/null; then
  #   echo
  #   echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" 内のファイルを削除しました\033[0m"
  # else
  #   echo
  #   echo -e "\033[1;31mERROR: $src_dir 配下のファイルが削除できませんでした。対象のファイルを含むディレクトリを検索して再度実行します\033[0m"
  #   echo
  #   target_dir=$(find "$src_file" -type f -iname '*.avi' 2>/dev/null)
  #   target_dir=$(dirname "$target_dir")
  #   echo "rm $target_dir/*"
  #   if rm "$target_dir/*" 2>/dev/null; then
  #     echo
  #     echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" 内のファイルを削除しました\033[0m"
  #   else
  #     echo
  #     echo -e "\033[1;32mERROR: $src_file を格納するディレクトリが見つかりませんでした。完全なデータ削除のために DISK の初期化を推奨します\033[0m"
  #   fi
  # fi
}

function dequeue2 () {
  cd $dst_dir || exit

  if [ ! -e "$date_dir2" ]; then
    mkdir "$date_dir2"
  elif [ ! -d "$date_dir2" ]; then
    echo -e "\033[1;36mINFO: \"$date_dir2\" は保存フォルダ名として指定される必要があります。不正なファイルを $archive に移送します\033[0m"
    mkdir archive
    echo "mv -v $dst_dir/$date_dir2 $archive"
    mv -v "$dst_dir/$date_dir2" $archive
    mkdir "$date_dir2"
    echo
  fi

  # 確認の為、デキュー領域にてファイル検索を行う
  echo -e "\033[1;36mINFO: デキュー領域 \"$queue2\" にて動画ファイルを検索しています…\033[0m"
  for file in "$queue2"/*; do
    if [ -f "$file" ]; then
      mp4_search_result=$(find "$file" -type f -iname '*.mp4' 2>/dev/null) # .mp4 ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mp4_search_result" ]; then
        mp4_files+=("$mp4_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$mp4_search_result")\033[0m"
      fi
      mov_search_result=$(find "$file" -type f -iname '*.mov' 2>/dev/null) # .mov ファイルを検索(大文字小文字を区別しない)
      if [ -n "$mov_search_result" ]; then
        mov_files+=("$mov_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$mov_search_result")\033[0m"
      fi
      avi_search_result=$(find "$file" -type f -iname '*.avi' 2>/dev/null) # .avi ファイルを検索(大文字小文字を区別しない)
      if [ -n "$avi_search_result" ]; then
        avi_files+=("$avi_search_result")
        echo -e "\033[1;32mfiles found: $(basename "$avi_search_result")\033[0m"
      fi
    fi
  done

  # 動画ファイルをデキュー領域から Internal に転送させる。コマンド実行に3回失敗した場合、強制終了する
  dequeue_info2
  RETRY_COUNT=0
  while [ $RETRY_COUNT -lt 3 ]; do
    echo "rsync --archive --human-readable --progress $queue2/* $dst_dir/$date_dir2"
    if rsync --archive --human-readable --progress "$queue2"/* "$dst_dir/$date_dir2"; then
      echo
      echo -e "\033[1;36mINFO: デキュー領域 \"$queue2\" を削除しています…\033[0m"
      echo "rm -rf $queue2"
      rm -rf "$queue2" 2>/dev/null
      echo
      echo -e "\033[1;32mSUCCESS: デキュー領域 \"$queue2\" を削除しました\033[0m"
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      echo
      echo -e "\033[1;33mWARNING: rsync コマンド実行中に問題が発生しました。3秒後に転送処理を再度実行します ($RETRY_COUNT/3)\033[0m"
      sleep 3
      dequeue_info2
    fi
  done
  if [ $RETRY_COUNT -ge 3 ]; then
    echo -e "\033[1;31mERROR: 試行回数制限に到達しました。以下の事項を確認して再度実行してください。\033[0m"
    echo -e "\033[1;31m       ・転送先である SERVER \"$SERVER\" に接続されている\033[0m"
    echo -e "\033[1;31m       ・プログラムと実行環境のディレクトリパス \"$queue2\" \"$dst_dir/$date_dir2\" に齟齬が無い\033[0m"
    echo -e "\033[1;31m       ・デキュー領域 \"$queue2\" 内に動画ファイルが存在する\033[0m"
    echo -e "\033[1;31m       ・SERVER \"$SERVER\" 内に転送先 \"$dst_dir/$date_dir2\" が存在する\033[0m"
    failure_trigger
    echo "osascript Trigger page - Failure.scpt"
    osascript "Trigger page - Failure.scpt"
    exit 1
  fi

  # Internal のディスク容量を記録
  timestamp=$(date '+%Y/%m/%d %H:%m:%d')
  echo
  echo -e "\033[1;36mINFO: SERVER \"$SERVER\" のディスク容量を記録しています…\033[0m"
  echo "df -H $dst_dir >> $disk_free"
  df -H $dst_dir | awk -v timestamp="$timestamp" 'NR==2 {
    printf "  {\n"
    printf "    \"タイムスタンプ\": \"%s\",\n", timestamp
    printf "    \"ファイルシステム\": \"%s\",\n", $1
    printf "    \"サイズ\": {\n"
    printf "      \"容量\": \"%sB\",\n", $2
    printf "      \"使用量\": \"%sB\",\n", $3
    printf "      \"空き容量\": \"%sB\",\n", $4
    printf "      \"使用率\": \"%s\"\n", $5
    printf "    },\n"
    printf "    \"マウント先\": \"%s\"\n", $9
    printf "  },\n"
    print "]"
  }' >> "$disk_free"
  closing_brace=$(grep -nB1 -nA1 ']' "$disk_free" | awk 'NR == 1 {gsub(/-/, ""); print $1 }')
  square_brackets=$(grep -nA1 ']' "$disk_free" | awk 'NR <= 2 { gsub(/:\]|-\[/, ""); print $1 }' | sed '1s/$/,/' | tr -d '\n')
  sed -i '' "${closing_brace}s/.*/  },/" "$disk_free" # 指定行を別の文字列に置換
  sed -i '' "${square_brackets}d" "$disk_free" # 指定行を削除
  echo
  echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" のディスク容量を記録しました\033[0m"
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: 動画ファイルの転送処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mデキュー領域 \"$queue2\" 内のファイルは $dst_dir/$date_dir2 に格納されています。\033[0m"
  stream_editor
  end_point
  rsync "$logfile" $stdout
  mv "/Volumes/Untitled/robocopy_log_*" "$destination"
}

exec > >(tee -a "$logfile")

URL="https://drive.google.com/drive/my-drive"
code=$(curl -I $URL 2>/dev/null | head -n 1)

hostname=$(hostname | sed 's/.local//g')
users=$(users)

motd

if [[ "$code" =~ "HTTP/2 302" ]] || [[ "$code" =~ "HTTP/2 304" ]]; then
  echo -e "\033[1;32mSUCCESS: $code\033[0m"
elif [[ "$code" =~ "HTTP/2 404" ]]; then
  echo -e "\033[1;31mCLIENT ERROR: Google Drive の URL が無効です。URL を確認して再度実行してください。\033[0m"
  echo
  stream_editor
  end_point
  exit 1
else
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  stream_editor
  end_point
  exit 1
fi

if [ -e $src_dir ]; then
  if [ -e $dst_dir ]; then
    echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" は有効です。\033[0m"
    timestamp=$(date '+%Y/%m/%d %H:%m:%d')
    df -H $src_dir | awk -v timestamp="$timestamp" 'NR==2 {
      printf "[\n"
      printf "  {\n"
      printf "    \"タイムスタンプ\": \"%s\",\n", timestamp
      printf "    \"ファイルシステム\": \"%s\",\n", $1
      printf "    \"サイズ\": {\n"
      printf "      \"容量\": \"%sB\",\n", $2
      printf "      \"使用量\": \"%sB\",\n", $3
      printf "      \"空き容量\": \"%sB\",\n", $4
      printf "      \"使用率\": \"%s\"\n", $5
      printf "    },\n"
      printf "    \"マウント先\": \"%s\"\n", $9
      printf "  },\n"
    }' >> "$disk_free"
    echo
    sleep 0.5
    ps_check
    enqueue
    dequeue
    if [ -e $src_dir2 ]; then
      enqueue2
      dequeue2
    fi
    success_trigger
    echo "osascript Trigger page - Success.scpt"
    osascript "Trigger page - Success.scpt"
  elif [ -e $src_dir ] && [ ! -e $dst_dir ]; then
    echo -e "\033[1;32mSUCCESS: DISK \"$DISK\" は有効です。\033[0m"
    echo -e "\033[1;31mERROR: SERVER \"$SERVER\" にアクセス出来ません。サーバーにアクセスされているか確認して再度実行してください。\033[0m"
    echo -e "\033[1;36mHINT: ショートカット \"Internal Injection\" をクリックしてサーバーにアクセス。\033[0m"
    echo
    sleep 0.5
    ps_check
    stream_editor
    end_point
    exit 1
  fi
elif [ ! -e $src_dir ]; then
  echo -e "\033[1;31mERROR: 転送元である DISK \"$DISK\" が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
  echo
  sleep 0.5
  ps_check
  stream_editor
  end_point
  exit 1
fi
