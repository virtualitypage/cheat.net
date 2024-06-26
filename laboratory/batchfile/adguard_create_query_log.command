#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
date=$(TZ=UTC-9 date '+%Y-%m-%d')
main_file_1="$current_dir/AdGuard Home - query_log(column1).csv"
main_file_2="$current_dir/AdGuard Home - query_log(column2).csv"
main_file_3="$current_dir/AdGuard Home - query_log(column3).csv"
main_file_4="$current_dir/AdGuard Home - query_log(column4).csv"
sub_file="$current_dir/query_log.csv"

function get_time () {
  sed -e '/[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/{n;N;N;d;}' "$sub_file" > "$main_file_1"
  sed -i '' '/許可/{N;d;}' "$main_file_1"
  sed -i '' '/処理済/{N;d;}' "$main_file_1"
  sed -i '' '/ブロック済/{N;d;}' "$main_file_1"
  sed -i '' '/localhost (127.0.0.1)/{N;d;}' "$main_file_1"
  sed -i '' '/192.168.8.*/{N;d;}' "$main_file_1"
  sed -i '' "s/^/\"${date} /g" "$main_file_1"
  sed -i '' 's/-/\//g' "$main_file_1"
  sed -i '' 's/$/"/g' "$main_file_1"
}

function get_request () {
  sed -e '/許可/{N;d;}' -e '$!N;/許可/!P;D' "$sub_file" > "$main_file_2"
  sed -e '/処理済/{N;d;}' -e '$!N;/処理済/!P;D' "$main_file_2" > "$main_file_2.tmp"
  sed -e '/ブロック済/{N;d;}' -e '$!N;/ブロック済/!P;D' "$main_file_2.tmp" > "$main_file_2"
  rm "$main_file_2.tmp"
  sed -i '' '/localhost (127.0.0.1)/{N;d;}' "$main_file_2"
  sed -i '' '/192.168.8.*/{N;d;}' "$main_file_2"
  sed -i '' '/[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/{N;d;}' "$main_file_2"
}

function get_response () {
  sed -e '/許可/{n;N;N;N;N;N;N;d;}' "$sub_file" > "$main_file_3"
  sed -i '' '/処理済/{n;N;N;N;N;N;N;d;}' "$main_file_3"
  sed -i '' '/ブロック済/{n;N;N;N;N;N;N;d;}' "$main_file_3"
  sed -i '' '/[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/{N;N;N;d;}' "$main_file_3"
}

function get_client () {
  sed -e '/192.168.8.*/{n;N;N;N;N;N;N;d;}' "$sub_file" > "$main_file_4"
  sed -i '' '/localhost (127.0.0.1)/{n;N;N;N;N;N;N;d;}' "$main_file_4"
  sed -i '' '/[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/{N;N;N;N;N;d;}' "$main_file_4"
}

if [ "$sub_file" ]; then
  sed -i '' '1,20d' "$sub_file"
  get_time
  get_request
  get_response
  get_client
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: クエリ・ログファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mAdGuard Home - query_log(column[1-4]).csv は $current_dir に格納されています。\033[0m"
  echo
  echo -e "\033[1;36mHINT: AdGuard Home - query_log(column1).csv をベースに1列ずつ column2 〜 column4 の内容を追加して下さい。\033[0m"
  echo
fi
