#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
uniq_file="$current_dir/Querylog_Analysis_uniq.csv"
stat_file="$current_dir/Querylog_Analysis_stat.csv"

read -p "クエリログファイルを指定して下さい: " sub_file
read -p "分析対象のIPアドレスを入力して下さい: " ip_addr

query_file="$current_dir/Querylog Analysis - $ip_addr.csv"
echo "時刻,クエリ数,ドメイン" > "$query_file"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" $h)
    grep -B2 "$ip_addr" "$current_dir/$sub_file" | grep "$hour:${m}[0-9]:[0-5][0-9]" | sed 's/\"//g' | awk -F ',' '{ print $2 }' > "$stat_file"
    sort -u "$stat_file" | sed 's/$/, /g' > "$uniq_file"
    count=$(wc -l "$stat_file" | awk '{ print $1 }')
    uniq_query=$(cat "$uniq_file" | tr -d '\n' | sed -e 's/, $//g' -e 's/^/"/g' -e 's/$/"/g')
    echo "$hour:${m}0,$count,$uniq_query" >> "$query_file"
  done
done

rm "$stat_file" "$uniq_file"
