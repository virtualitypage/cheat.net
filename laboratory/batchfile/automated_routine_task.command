#!/bin/bash

today=$(date '+%Y-%m-%d')
yesterday=$(date -v-1d '+%Y-%m-%d')
SetFile_today=$(date '+%m/%d/%Y')
current_dir=$(cd "$(dirname "$0")" && pwd)
date_dir="/Volumes/DevOps/$yesterday"
GoogleDrivePath=$(find "$HOME/Library/CloudStorage" -type d -name "GoogleDrive-*@gmail.com" 2>/dev/null)
GoogleDrivePath=$(find "$GoogleDrivePath" -type d -name "添付ファイル" 2>/dev/null | awk 'NR == 1')
github_path=$(find /Volumes/DevOps -type d -name "GitHub" 2>/dev/null | awk 'NR == 1')
github="$github_path/GL-MT3000_Internal/var/log/data/gl-mt3000"
year="${yesterday//-*}"
month=$(date -v-1d '+%m')
day=$(date -v-1d '+%d')

GL_MT3000_zip="$GoogleDrivePath/archive_${yesterday}_GL-MT3000.tar.gz"
FortiGate50E_zip="$GoogleDrivePath/archive_${yesterday}_FortiGate50E.tar.gz"
querylog_zip="$GoogleDrivePath/querylog_$yesterday.json.tar.gz"

mkdir -p "$date_dir" 2>/dev/null
cd "$current_dir" || exit

function automated_routine_task () {
  echo -e "\033[1;36mINFO: Google Drive から tar アーカイブを $current_dir に展開中...\033[0m"
  tar -zxf "$GL_MT3000_zip" -C "$current_dir"
  tar -zxf "$FortiGate50E_zip" -C "$current_dir"
  tar -zxf "$querylog_zip" -C "$current_dir"

  echo -e "\033[1;32mSUCCESS: tar アーカイブを $current_dir に展開完了\033[0m"; echo

  # 起動ログがあるかを事前にルータでフラグ建てしておくこと。それの有無で指定ログファイルの内容を結合という形で取得する

  echo -e "\033[1;36mINFO: archive 配下のファイルを整理・転送中...\033[0m"
  rm -rf "archive_${yesterday}_GL-MT3000.tar.gz" \
         "archive_${yesterday}_FortiGate50E.tar.gz" \
         "querylog_$yesterday.json.tar.gz"

  # ファイルの末尾にある空行を置換により削除
  tmpfile=$(mktemp)
  find archive_GL-MT3000/* -type f -maxdepth 1 > "$tmpfile"
  while IFS= read -r log_file || [[ -n $log_file ]]; do
    body=$(cat "$log_file")
    body=$(perl -pe 'chomp if eof' <<< "$body")
    echo "$body" | perl -pe 'chomp if eof' >> "$log_file.tmp"
    mv "$log_file.tmp" "$log_file"
  done < "$tmpfile"

  tmpfile=$(mktemp)
  find archive_FortiGate50E/* -type f -maxdepth 1 > "$tmpfile"
  while IFS= read -r log_file || [[ -n $log_file ]]; do
    body=$(cat "$log_file")
    body=$(perl -pe 'chomp if eof' <<< "$body")
    echo "$body" | perl -pe 'chomp if eof' >> "$log_file.tmp"
    mv "$log_file.tmp" "$log_file"
  done < "$tmpfile"

  # system log の Severity 統計を取るためのファイルを作成
  cp "archive_GL-MT3000/$yesterday/system.csv" "archive_GL-MT3000/GL-MT3000_system_$yesterday.csv"
  cp "archive_FortiGate50E/$yesterday/system.csv" "archive_FortiGate50E/FortiGate50E_system_$yesterday.csv"
  sed -i '' -e 's|crit.*"|crit"|g' \
            -e 's|err.*"|err"|g' \
            -e 's|warn.*"|warn"|g' \
            -e 's|notice.*"|notice"|g' \
            -e 's|info.*"|info"|g' \
            -e 's|debug.*"|debug"|g' \
            -e 's/$/,/g' "archive_GL-MT3000/GL-MT3000_system_$yesterday.csv" "archive_FortiGate50E/FortiGate50E_system_$yesterday.csv"

  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      code=$(
        cat << EOF
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*crit*"")",\
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*err*"")",\
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*warn*"")",\
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*notice*"")",\
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*info*"")",\
"=COUNTIFS(\$A, "">=$year/$month/$day $hour:${m}0:00"", \$A, ""<=$year/$month/$day $hour:${m}9:59"", \$B, ""*debug*"")"
EOF
      )
      echo "$code" >> "archive_GL-MT3000/COUNTIFS_$yesterday.csv" "archive_GL-MT3000/COUNTIFS_$yesterday.csv"
    done
  done

  # archive を圧縮・転送
  command_dir=$(find "$current_dir" -type f -name "attachment_compression.command" 2>/dev/null | awk 'NR == 1' | sed 's/\/attachment_compression.command//g')
  yesterday_slash="${yesterday//-//}" # sed 's|-|/|g' と同義
  echo -e "$yesterday_slash" | "$command_dir/attachment_compression.command"
  "$command_dir/internal_data_sync.command"

  # MacTableEntry.csv をベースに Connection Statistics.numbers 用のファイルを作成
  sed -e 's/^.*(): //g' -e 's/"//g' "archive_GL-MT3000/$yesterday/MacTableEntry.csv" | sort -u > "MacTableEntry"
  while IFS= read -r line; do
    echo "$line" >> "archive_GL-MT3000/Connection Statistics.csv"
    grep "MacTableInsertEntry(): $line" "archive_GL-MT3000/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "InsertEntry"
    grep "MacTableDeleteEntry(): $line" "archive_GL-MT3000/$yesterday/MacTableEntry.csv" | sed 's/,\".*//g' > "DeleteEntry"
    paste -d , "InsertEntry" "DeleteEntry" >> "archive_GL-MT3000/Connection Statistics.csv"
  done < "MacTableEntry"

  before_date=$(head -n 1 "archive_GL-MT3000/$yesterday/MacTableEntry.csv" | sed -e 's/ .*$//g' -e 's|/|-|g')
  after_date=$(date -jf '%Y-%m-%d' "$before_date" '+%Y/%m/%d')
  before_date="${before_date//-//}" # sed 's|-|/|g' と同義
  sed -i '' -e 's/,/,〜,/g' -e "s|$before_date|$after_date|g" "archive_GL-MT3000/Connection Statistics.csv"
  rm "InsertEntry" "DeleteEntry" "MacTableEntry"
  mv "archive_GL-MT3000" "archive_FortiGate50E" "$date_dir"

  echo -e "\033[1;32mSUCCESS: archive 配下のファイル整理・転送完了\033[0m"; echo

  echo -e "\033[1;36mINFO: querylog.json をベースに成形済 json ファイルと csv ファイルを作成中...\033[0m"
  mv "querylog_$yesterday.json" querylog.json
  sed -i '' -e "/$today/q" -e "/$today/d" querylog.json
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

  # unknownDomain.command を移動
  chmod +x "$GoogleDrivePath/unknownDomain_$yesterday.command"
  mv "$GoogleDrivePath/unknownDomain_$yesterday.command" /Volumes/DevOps/ops/unknownDomainSearch 2>/dev/null

  # querylog.json をベースに成形済 json ファイルと csv ファイルを作成
  "$command_dir/convert_querylog_json.command"
  "$command_dir/convert_querylog_csv.command"
  sed -i '' 's/ ステータス: セーフサーチ/\nステータス: セーフサーチ/g' "$command_dir/querylog_$yesterday.csv"
  rm "$command_dir/querylog.json"
  mv "querylog_$yesterday.json" "$github/query_log/$year/$month"
  open "$command_dir/querylog_$yesterday.csv"

  echo -e "\033[1;32mSUCCESS: json ファイルと csv ファイルの作成完了\033[0m"; echo

  # ブロックされた脅威 - 月間レポート用の csv ファイルを作成
  echo -e "\033[1;36mINFO: ブロックされた脅威 - 月間レポート用の csv ファイルを作成中...\033[0m"
  grep -B2 "ブロックされた脅威" "$command_dir/querylog_$yesterday.csv" | sed '/--/d' > "$command_dir/querylog_threat_$yesterday.csv"
  open "$command_dir/querylog_threat_$yesterday.csv"

  # 一日のクエリ統計ファイルを作成
  echo -e "\033[1;36mINFO: querylog_statistics.command を実行中...\033[0m"
  echo -e "querylog_$yesterday.csv" | "$command_dir/querylog_statistics.command" # 複数行の入力をパイプやファイルを使って実行
  echo -e "\033[1;32mSUCCESS: querylog_statistics.command の実行完了\033[0m"; echo
  mv "Querylog Statistics - $yesterday.csv" "$date_dir/archive_GL-MT3000"

  # クライアント毎のクエリログ詳細ファイルを作成
  echo -e "\033[1;36mINFO: querylog_client_details.command を実行中...\033[0m"
  rename 's/querylog_//' "querylog_$yesterday.csv"
  echo -e "$yesterday.csv" | "$command_dir/querylog_client_details.command"
  mv "Querylog Reason Statistics $yesterday - "* "$date_dir/archive_GL-MT3000"
  echo -e "\033[1;32mSUCCESS: querylog_client_details.command の実行完了\033[0m"; echo
  mv "$date_dir" /Volumes/DevOps/ops
}

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep --only-matching "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
  if [ ! -e "$GL_MT3000_zip" ] || [ ! -e "$FortiGate50E_zip" ] || [ ! -e "$querylog_zip" ]; then
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
