#!/bin/bash

today=$(date '+%Y%m%d')
current_dir=$(cd "$(dirname "$0")" && pwd)

read -prompt "クエリログファイルを指定して下さい: " sub_file

stat_file="$current_dir/Querylog Statistics - $today.csv"
echo "時刻,総クエリ数" > "$stat_file"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" "$h")
    count=$(grep -c " $hour:${m}[0-9]:[0-5][0-9]" "$current_dir/$sub_file")
    echo "$hour:${m}0,$count" >> "$stat_file"
  done
done
