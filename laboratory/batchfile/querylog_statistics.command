#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

read -rp "クエリログファイルを指定して下さい: " sub_file

date=$(awk 'NR == 2 { print $1 }' "$current_dir/$sub_file")
stat_file="$current_dir/Querylog Statistics - $date.csv"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" "$h")
    count=$(grep --count " $hour:${m}[0-9]:[0-5][0-9]" "$current_dir/$sub_file")
    echo "$date,$hour:${m}0,$count" >> "$stat_file"
  done
done
