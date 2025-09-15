#!/bin/bash

today=$(date '+%Y-%m-%d')
yesterday=$(date -v-1d '+%Y-%m-%d')
year_month=$(date -v-1d '+%Y_%m')
SetFile_today=$(date '+%m/%d/%Y')
current_dir=$(cd "$(dirname "$0")" && pwd)
date_dir="/Volumes/dev/$yesterday"
GoogleDrivePath=$(find "$HOME/Library/CloudStorage" -type d -name "GoogleDrive-*@gmail.com" 2>/dev/null)
GoogleDrivePath=$(find "$GoogleDrivePath" -type d -name "添付ファイル" 2>/dev/null | awk 'NR == 1')
github_path=$(find /Volumes/dev -type d -name "GitHub" 2>/dev/null | awk 'NR == 1')
github="$github_path/GL-MT3000_Internal/var/log/data/gl-mt3000"
ScriptEditorPath="$HOME/Library/Mobile Documents/com~apple~ScriptEditor2/Documents"
year="${yesterday//-*}"

mkdir -p "$date_dir" 2>/dev/null
cd "$current_dir" || exit

function automated_routine_task () {
  echo -e "\033[1;36mINFO: Google Drive から tar アーカイブを $current_dir に展開中...\033[0m"
  tar -zxf "$GoogleDrivePath/archive_$yesterday.tar.gz" -C "$current_dir"
  tar -zxf "$GoogleDrivePath/querylog_$yesterday.json.tar.gz" -C "$current_dir"

  echo -e "\033[1;32mSUCCESS: tar アーカイブを $current_dir に展開完了\033[0m"; echo

  echo -e "\033[1;36mINFO: archive 配下のファイルを整理・転送中...\033[0m"
  mv "archive/$yesterday/23_59_59/system_23_59_59.log" "archive/$yesterday/system.log"
  mv "archive/$yesterday/23_59_59/authpriv.csv" \
     "archive/$yesterday/23_59_59/MacTableEntry.csv" \
     "archive/$yesterday/23_59_59/system.csv" "archive/$yesterday" 2>/dev/null
  sleep 10
  rm -rf "archive/$yesterday/23_59_59" \
         "archive_$yesterday.tar.gz" \
         "querylog_$yesterday.json.tar.gz"

  for ((i = 1; i <= 23; i++)); do
    j=$(printf "%02d\n" $i)
    rm -rf "archive/$yesterday/${j}_00_00" 2>/dev/null
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
  rm -rf "$tmpfile" "archive/.DS_Store" "archive/$yesterday/.DS_Store" 2>/dev/null

  # archive を圧縮・転送
  command_dir=$(find "$current_dir" -type f -name "attachment_compression.command" 2>/dev/null | awk 'NR == 1' | sed 's/\/attachment_compression.command//g')
  yesterday_slash="${yesterday//-//}" # sed 's|-|/|g' と同義
  echo -e "$yesterday_slash" | "$command_dir/attachment_compression.command"
  "$command_dir/internal_data_sync.command"

  # MacTableEntry.csv をベースに Connection Statistics.numbers 用のファイルを作成
  sed -e 's/^.*(): //g' -e 's/"//g' "archive_$yesterday/$yesterday/MacTableEntry.csv" | sort -u > "MacTableEntry"
  while IFS= read -r line; do
    echo "$line" >> "archive_$yesterday/Connection Statistics.csv"
    grep "MacTableInsertEntry(): $line" "archive_$yesterday/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "InsertEntry"
    grep "MacTableDeleteEntry(): $line" "archive_$yesterday/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "DeleteEntry"
    paste -d , "InsertEntry" "DeleteEntry" >> "archive_$yesterday/Connection Statistics.csv"
  done < "MacTableEntry"

  before_date=$(head -n 1 "archive_$yesterday/$yesterday/MacTableEntry.csv" | sed -e 's/ .*$//g' -e 's|/|-|g')
  after_date=$(date -jf '%Y-%m-%d' "$before_date" '+%Y/%m/%d')
  before_date="${before_date//-//}" # sed 's|-|/|g' と同義
  sed -i '' -e 's/,/,〜,/g' -e "s|$before_date|$after_date|g" "archive_$yesterday/Connection Statistics.csv"
  rm "InsertEntry" "DeleteEntry" "MacTableEntry"
  mv "$current_dir/archive_$yesterday" "$date_dir"

  echo -e "\033[1;32mSUCCESS: archive 配下のファイル整理・転送完了\033[0m"; echo

  echo -e "\033[1;36mINFO: querylog.json をベースに成形済 json ファイルと csv ファイルを作成中...\033[0m"
  sed -i '' -e "/$today/q" -e "/$today/d" "querylog.json"
  SetFile -m "$SetFile_today 02:00" querylog.json
  SetFile -d "$SetFile_today 02:00" querylog.json

  # querylog.json を圧縮・転送
  tar -zcf "querylog_$yesterday.json.tar.gz" querylog.json
  SetFile -m "$SetFile_today 02:00" "querylog_$yesterday.json.tar.gz"
  SetFile -d "$SetFile_today 02:00" "querylog_$yesterday.json.tar.gz"
  mv "querylog_$yesterday.json.tar.gz" "$GoogleDrivePath/$year/querylog"
  sed -e 's|{.*"QH":"||g' -e 's|","QT".*$||g' "querylog.json" | awk '{ print length(), $0 }' | sort -nr | grep "^[5-9][0-9]" | awk '{ print $2 }' | sort -u > "$current_dir/cover_up.txt"
  sed -e 's|{.*"QH":"||g' -e 's|","QT".*$||g' "querylog.json" | awk '{ print length(), $0 }' | sort -nr | grep "^[1-9][0-9][0-9]" | awk '{ print $2 }' | sort -u >> "$current_dir/cover_up.txt"
  sed -i '' 's|\\.*||g' "cover_up.txt"

  while IFS= read -r line; do
    num=$(grep -c "\"QH\":\"$line\"" "querylog.json")
    length=$(echo "$line" | awk '{ print length() $2 }')
    echo "(length: $length / count: $num): $line"
    sed -i '' "/$line/d" "querylog.json"
  done < "cover_up.txt"

  if mv "querylog.json" "$command_dir"; then
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
  mv "$current_dir/querylog_$yesterday.json" "$github/query_log/$year_month"
  open "$command_dir/querylog_$yesterday.csv"

  echo -e "\033[1;32mSUCCESS: json ファイルと csv ファイルの作成完了\033[0m"; echo

  # 一日のクエリ統計ファイルを作成
  echo -e "\033[1;36mINFO: querylog_statistics.command を実行中...\033[0m"
  echo -e "querylog_$yesterday.csv" | "$command_dir/querylog_statistics.command" # 複数行の入力をパイプやファイルを使って実行
  echo -e "\033[1;32mSUCCESS: querylog_statistics.command の実行完了\033[0m"; echo
  mv "$current_dir/Querylog Statistics - $yesterday.csv" "$date_dir"

  # クエリログ分析のためのファイルを作成
  target_ip="192.168.8.117"
  echo -e "\033[1;36mINFO: querylog_analyzer.command を実行中...\033[0m"
  echo -e "querylog_$yesterday.csv\n$target_ip" | "$command_dir/querylog_analyzer.command" # 複数行の入力をパイプやファイルを使って実行
  read -rp "Querylog_Analysis_Target_Domain.scpt を実行しますか？ { yes | y | no }: " yesno
  if [ "$yesno" = "yes" ] || [ "$yesno" = "y" ] || [ "$yesno" = "Y" ]; then
    open "$command_dir/Querylog Analysis - $target_ip.csv"
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
  mv "$current_dir/Querylog Analysis - $target_ip.csv" \
     "$current_dir/Querylog_Analysis_Target_Domain_15inch.scpt" \
     "$current_dir/Querylog_Analysis_Target_Domain_27inch.scpt" "$date_dir"

  # クエリログレポートファイルを作成
  # echo -e "\033[1;36mINFO: querylog_reporting.command を実行中...\033[0m"
  # echo -e "querylog_$yesterday.csv" | "$command_dir/querylog_reporting.command" # 複数行の入力をパイプやファイルを使って実行
  # echo -e "\033[1;32mSUCCESS: querylog_reporting.command の実行完了\033[0m"; echo

  # クライアント毎のクエリログ詳細ファイルを作成
  echo -e "\033[1;36mINFO: querylog_client_details.command を実行中...\033[0m"
  rename 's/querylog_//' "querylog_$yesterday.csv"
  echo -e "$yesterday.csv" | "$command_dir/querylog_client_details.command"
  mv "$current_dir/Querylog Client Details $yesterday - "*.csv \
     "$current_dir/Querylog_Client_Details_$yesterday"*.scpt \
     "$current_dir/Querylog Reason Statistics $yesterday - "*.csv "$date_dir"
  echo -e "\033[1;32mSUCCESS: querylog_client_details.command の実行完了\033[0m"; echo
}

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep --only-matching "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
  if [ ! -e "$GoogleDrivePath/archive_$yesterday.tar.gz" ] || [ ! -e "$GoogleDrivePath/querylog_$yesterday.json.tar.gz" ]; then
    echo -e "\033[1;31mFILE ERROR: Google Drive に tar アーカイブが存在しません。ファイルを再配置して再度実行してください。\033[0m"
    echo
    exit 1
  else
    automated_routine_task
  fi
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
