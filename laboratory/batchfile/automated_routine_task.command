#!/bin/bash

today=$(date '+%Y-%m-%d')
yesterday=$(date -v -1d +"%Y-%m-%d")
current_dir=$(cd "$(dirname "$0")" && pwd)
GoogleDrivePath=$(find "$HOME/Library/CloudStorage" -type d -name "GoogleDrive-*@gmail.com" 2>/dev/null)
GoogleDrivePath=$(find "$GoogleDrivePath" -type d -name "添付ファイル" 2>/dev/null | awk 'NR == 1')
ScriptEditorPath="$HOME/Library/Mobile Documents/com~apple~ScriptEditor2/Documents"

function automated_routine_task () {
  echo -e "\033[1;36mINFO: Google Drive から tar アーカイブを転送中...\033[0m"
  cp "$GoogleDrivePath/archive_$yesterday.tar.gz" \
     "$GoogleDrivePath/querylog_$yesterday.json.tar.gz" "$current_dir"

  echo -e "\033[1;32mSUCCESS: Google Drive からの tar アーカイブ転送完了\033[0m"; echo

  echo -e "\033[1;36mINFO: tar アーカイブを $current_dir に展開中...\033[0m"
  cd "$current_dir" || exit
  tar -zxf "archive_$yesterday.tar.gz" 2>/dev/null
  tar -zxf "querylog_$yesterday.json.tar.gz" 2>/dev/null

  echo -e "\033[1;32mSUCCESS: tar アーカイブを $current_dir に展開完了\033[0m"; echo

  echo -e "\033[1;36mINFO: archive 配下のファイルを整理・転送中...\033[0m"
  mv "archive/$yesterday/23_59_59/system_23_59_59.log" "archive/$yesterday/system.log"
  mv "archive/$yesterday/23_59_59/authpriv.csv" \
     "archive/$yesterday/23_59_59/MacTableEntry.csv" \
     "archive/$yesterday/23_59_59/system.csv" "archive/$yesterday"

  rm -r "archive/$yesterday/23_59_59" \
                 "archive/$today" \
                 "archive_$yesterday.tar.gz" \
                 "querylog_$yesterday.json.tar.gz"

  for ((i = 1; i <= 23; i++)); do
    j=$(printf "%02d\n" $i)
    rm -r "archive/$yesterday/${j}_00_00" 2>/dev/null
  done

  # ファイルの末尾にある空行を置換により削除
  tmpfile=$(mktemp)
  find "archive/$yesterday" -type f -maxdepth 1 > "$tmpfile"
  while IFS= read -r log_file || [[ -n $log_file ]]; do
    body=$(cat "$log_file")
    body=$(perl -pe 'chomp if eof' <<< "$body")
    echo "$body" | perl -pe 'chomp if eof' >> "$log_file.tmp"
    mv "$log_file.tmp" "$log_file"
  done < "$tmpfile"
  mv archive/interface_logger/log_only.csv archive
  rm "$tmpfile" "archive/.DS_Store" "archive/$yesterday/.DS_Store" 2>/dev/null

  # archive を圧縮・転送
  command_dir=$(find "$current_dir" -type f -name "attachment_compression.command" 2>/dev/null | awk 'NR == 1' | sed 's/\/attachment_compression.command//g')
  cd "$command_dir" || exit
  yesterday_slash="${yesterday//-//}" # sed 's|-|/|g' と同義
  echo -e "$yesterday_slash" | "$command_dir/attachment_compression.command"
  "$command_dir/internal_data_sync.command"

  # MacTableEntry.csv をベースに Connection Statistics.numbers 用のファイルを作成
  sed -e 's/^.*(): //g' -e 's/"//g' "archive/$yesterday/MacTableEntry.csv" | sort -u > "$current_dir/MacTableEntry"
  while IFS= read -r line; do
    echo "$line" >> "archive/Connection Statistics.csv"
    grep "MacTableInsertEntry(): $line" "archive/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "$current_dir/InsertEntry"
    grep "MacTableDeleteEntry(): $line" "archive/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "$current_dir/DeleteEntry"
    paste -d , "$current_dir/InsertEntry" "$current_dir/DeleteEntry" >> "archive/Connection Statistics.csv"
  done < "$current_dir/MacTableEntry"

  before_date=$(head -n 1 "archive/$yesterday/MacTableEntry.csv" | sed -e 's/ .*$//g' -e 's|/|-|g')
  after_date=$(date -jf "%Y-%m-%d" "$before_date" "+%Y/%m/%d")
  before_date="${before_date//-//}" # sed 's|-|/|g' と同義
  sed -i '' -e 's/,/,〜,/g' -e "s|$before_date|$after_date|g" "archive/Connection Statistics.csv"
  rm "$current_dir/InsertEntry" "$current_dir/DeleteEntry" "$current_dir/MacTableEntry"

  echo -e "\033[1;32mSUCCESS: archive 配下のファイル整理・転送完了\033[0m"; echo

  echo -e "\033[1;36mINFO: querylog.json をベースに成形済 json ファイルと csv ファイルを作成中...\033[0m"
  sed -i '' -e "/$today/q" -e "/$today/d" "$current_dir/querylog.json"
  sed -e 's|{.*"QH":"||g' -e 's|","QT".*$||g' "$current_dir/querylog.json" | awk '{ print length(), $0 }' | sort -nr | grep "^[5-9][0-9]" | awk '{ print $2 }' | sort -u > "$current_dir/cover_up.txt"
  sed -e 's|{.*"QH":"||g' -e 's|","QT".*$||g' "$current_dir/querylog.json" | awk '{ print length(), $0 }' | sort -nr | grep "^[1-9][0-9][0-9]" | awk '{ print $2 }' | sort -u >> "$current_dir/cover_up.txt"
  sed -i '' 's|\\.*||g' "$current_dir/cover_up.txt"

  while IFS= read -r line; do
    num=$(grep -c "\"QH\":\"$line\"" "$current_dir/querylog.json")
    length=$(echo "$line" | awk '{ print length() $2 }')
    echo "(length: $length / count: $num): $line"
    sed -i '' "/$line/d" "$current_dir/querylog.json"
  done < "$current_dir/cover_up.txt"

  if mv "$current_dir/querylog.json" "$command_dir"; then
    : # then の中を省略(何もしない)
  else
    echo -e "\033[1;38mquerylog.json の移動処理をスキップします\033[0m"
    echo
  fi

  # querylog.json をベースに成形済 json ファイルと csv ファイルを作成
  "$command_dir/convert_querylog_json.command"
  "$command_dir/convert_querylog_csv.command"
  sed -i '' 's/ ステータス: セーフサーチ/\nステータス: セーフサーチ/g' "$command_dir/querylog_$yesterday.csv"
  rm "$command_dir/querylog.json"

  echo -e "\033[1;32mSUCCESS: json ファイルと csv ファイルの作成完了\033[0m"; echo

  # クエリログ分析のためのファイルを作成
  echo -e "\033[1;36mINFO: querylog_analyzer.command を実行中...\033[0m"
  echo -e "querylog_$yesterday.csv\n192.168.8.117" | "$command_dir/querylog_analyzer.command" # 複数行の入力をパイプやファイルを使って実行
  read -rp "Querylog_Analysis_Target_Domain.scpt を実行しますか？ { yes | y | no }: " yesno
  if [ "$yesno" = "yes" ] || [ "$yesno" = "y" ] || [ "$yesno" = "Y" ]; then
    open "$command_dir/Querylog Analysis - 192.168.8.117.csv"
    sleep 2
    echo -e "\033[1;38m> Querylog_Analysis_Target_Domain_15inch.scpt\033[0m"
    echo -e "\033[1;38m> Querylog_Analysis_Target_Domain_27inch.scpt\033[0m"
    read -rp "{ 15inch | 27inch }: " mode
    if [ "$mode" = "15inch" ]; then
      # 作成済クエリログ分析ファイルを編集(15inch)①
      echo "osascript $ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing)_15inch.scpt"
      osascript "$ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing)_15inch.scpt"
      echo
      # 作成済クエリログ分析ファイルを編集(15inch)②
      echo "osascript $command_dir/Querylog_Analysis_Target_Domain_15inch.scpt"
      osascript "$command_dir/Querylog_Analysis_Target_Domain_15inch.scpt"
      echo -e "\033[1;32mSUCCESS: querylog_analyzer.command の実行完了\033[0m"; echo
    else
      # 作成済クエリログ分析ファイルを編集(27inch)①
      echo "osascript $ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing)_27inch.scpt"
      osascript "$ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing)_27inch.scpt"
      echo
      # 作成済クエリログ分析ファイルを編集(27inch)②
      echo "osascript $command_dir/Querylog_Analysis_Target_Domain_27inch.scpt"
      osascript "$command_dir/Querylog_Analysis_Target_Domain_27inch.scpt"
      echo -e "\033[1;32mSUCCESS: querylog_analyzer.command の実行完了\033[0m"; echo
    fi
  fi

  # 一日のクエリ統計ファイルを作成
  echo -e "\033[1;36mINFO: querylog_statistics.command を実行中...\033[0m"
  echo -e "querylog_$yesterday.csv" | "$command_dir/querylog_statistics.command" # 複数行の入力をパイプやファイルを使って実行
  echo -e "\033[1;32mSUCCESS: querylog_statistics.command の実行完了\033[0m"; echo
}

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep --only-matching "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
  automated_routine_task
  if [ ! -e "$GoogleDrivePath/archive_$yesterday.tar.gz" ] || [ ! -e "$GoogleDrivePath/querylog_$yesterday.json.tar.gz" ]; then
    echo -e "\033[1;31mFILE ERROR: Google Drive に tar アーカイブが存在しません。ファイルを再配置して再度実行してください。\033[0m"
    echo
    exit 1
  fi
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
