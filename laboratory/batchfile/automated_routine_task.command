#!/bin/bash

today=$(date '+%Y-%m-%d')
yesterday=$(date -v -1d +"%Y-%m-%d")
current_dir=$(cd "$(dirname "$0")" && pwd)
GoogleDrivePath="$HOME/Library/CloudStorage/GoogleDrive-youguigujing42@gmail.com/マイドライブ/共有フォルダ/添付ファイル"
ScriptEditorPath="$HOME/Library/Mobile Documents/com~apple~ScriptEditor2/Documents"

function automated_routine_task () {
  echo -e "\033[1;36mINFO: Google Drive から tar アーカイブを転送中...\033[0m"
  cp "$GoogleDrivePath/archive_$yesterday.tar.gz" \
     "$GoogleDrivePath/querylog_$yesterday.json.tar.gz" "$current_dir"

  echo -e "\033[1;32mSUCCESS: Google Drive からの tar アーカイブ転送完了\033[0m"; echo

  echo -e "\033[1;36mINFO: tar アーカイブを $current_dir に展開中...\033[0m"
  cd "$current_dir" || exit
  tar -zxvf "archive_$yesterday.tar.gz" 2>/dev/null
  tar -zxvf "querylog_$yesterday.json.tar.gz" 2>/dev/null

  echo -e "\033[1;32mSUCCESS: tar アーカイブを $current_dir に展開完了\033[0m"; echo

  echo -e "\033[1;36mINFO: archive 配下のファイルを整理中...\033[0m"
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

  echo -e "\033[1;32mSUCCESS: archive 配下のファイル整理完了\033[0m"; echo

  echo -e "\033[1;36mINFO: querylog.json をベースに成形済 json ファイルと csv ファイルを作成中...\033[0m"
  command_dir=$(find "$current_dir" -type f -name "convert_querylog_json.command" 2>/dev/null | awk 'NR == 1' | sed 's/\/convert_querylog_json.command//g')
  sed -i '' -e "/$today/q" -e "/$today/d" "$current_dir/querylog.json"

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
  cd "$command_dir" || exit
  echo -e "querylog_$yesterday.csv\n192.168.8.117" | "$command_dir/querylog_analyzer.command" # 複数行の入力をパイプやファイルを使って実行
  read -p "Querylog_Analysis_Target_Domain.scpt を実行しますか？ { yes | y | no }: " yesno
  if [ "$yesno" = "yes" ] || [ "$yesno" = "y" ]; then
    open "$command_dir/Querylog Analysis - 192.168.8.117.csv"
    sleep 2
    # 作成済クエリログ分析ファイルを編集①
    echo "osascript $ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing).scpt"
    osascript "$ScriptEditorPath/Querylog_Analysis_Target_Domain(initializing).scpt"
    echo
    # 作成済クエリログ分析ファイルを編集②
    echo "osascript $command_dir/Querylog_Analysis_Target_Domain.scpt"
    osascript "$command_dir/Querylog_Analysis_Target_Domain.scpt"
    echo -e "\033[1;32mSUCCESS: querylog_analyzer.command の実行完了\033[0m"; echo
  fi
}

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
  automated_routine_task
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
