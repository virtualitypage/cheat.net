#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
year=$(TZ=UTC-9 date '+%Y')
cd "$current_dir" || exit

function querylog_reason_statistics () {
  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      for i in {1..7}; do
        reason_array=("accept" "reject" "blockedService" "safeBrowsing" "safeSearch" "rewritten" "processed")
        reason="${reason_array[$i - 1]}"
        grep "$ip_addr" "$sub_file.tmp" | grep "$reason" | grep "$hour:${m}[0-9]:[0-5][0-9]" | wc -l | awk '{ print $1 }' | sed 's/$/,/g' >> "query_reason_stat.txt"
      done
      reason_raw=$(cat "query_reason_stat.txt" | tr -d '\n' | sed 's/,$//g')
      echo "$reason_raw" >> "$stat_file"
      echo > query_reason_stat.txt
    done
  done
  rm query_reason_stat.txt
}

function query_file_tmp () {
  sed -i '' -e '/タイムスタンプ.*/d' \
            -e 's/ \[.*\]//g' \
            -e 's/ (キャッシュからの配信)//g' \
            -e 's/,[0-9].[0-9][0-9] ms,//g' \
            -e 's/,[0-9] ms,//g' \
            -e 's/,[0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9][0-9] ms,//g' \
            -e 's/,[0-9][0-9][0-9][0-9][0-9] ms,//g' \
            -e '/,,,,,/q' "$sub_file" 2>/dev/null

  awk 'BEGIN { ORS=""; } # 出力の区切り文字を空に設定
  {
    gsub("種類: .*ステータス: ", "ステータス: ", $0)
    gsub("種類: .*$", "", $0)
    if ($0 ~ /許可/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロック済/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロックするサービス/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /ブロックされた脅威/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /セーフサーチ/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /書換/) {
      $0 = $0 "\n"
    }
    if ($0 ~ /処理済み/) {
      $0 = $0 "\n"
    }
    if ($0 != "") { # 行が空でなければ出力
      print $0
    }
  }' "$sub_file" > "$sub_file.tmp"

  sed -i '' -e 's/許可/accept/g' \
            -e 's/ブロック済/reject/g' \
            -e 's/ブロックするサービス/blockedService/g' \
            -e 's/ブロックされた脅威/safeBrowsing/g' \
            -e 's/セーフサーチ/safeSearch/g' \
            -e 's/書換/rewritten/g' \
            -e 's/処理済み/processed/g' "$sub_file.tmp"
}

cd "$current_dir" || exit
read -rp "クエリログファイルを指定して下さい: " sub_file
if [[ "$sub_file" =~ -$year.*.csv ]]; then
  rename "s/-$year.*.csv/.csv/g" "$current_dir/"*
  query_file_tmp
elif [[ "$sub_file" =~ ^querylog_$year.*.csv$ ]]; then
  rename -e "s/querylog_//g" "$current_dir/$sub_file"
  query_file_tmp
else
  query_file_tmp
fi

sub_file_name=${sub_file//.csv/}
ip_addr_array=("192.168.8.117" "192.168.8.159" "192.168.8.163" "192.168.8.175" "192.168.8.183" "192.168.8.204" "192.168.8.219" "192.168.8.235")
for i in {1..8}; do
  export ip_addr="${ip_addr_array[$i - 1]}"
  stat_file="$current_dir/Querylog Reason Statistics $sub_file_name - $ip_addr.csv"
  querylog_reason_statistics
done
rm "$sub_file.tmp"
