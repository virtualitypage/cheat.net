#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
var_file="$current_dir/Querylog_Analysis_var.csv"
stat_file="$current_dir/Querylog_Analysis_stat.csv"
uniq_file="$current_dir/Querylog_Analysis_uniq.csv"

read -p "クエリログファイルを指定して下さい: " sub_file
read -p "分析対象のIPアドレスを入力して下さい: " ip_addr

mkdir "$current_dir/analysis"

echo "DNS スタット・クエリ・アナリシス," >> "$stat_file"
echo "DNS ユニーク・クエリ・アナリシス," >> "$uniq_file"

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" $h)
    grep -B2 "$ip_addr" "$current_dir/$sub_file" | grep "$hour:${m}[0-9]:[0-5][0-9]" | sed 's/\"//g' | awk -F ',' '{ print $2 }' > "$current_dir/analysis/$hour:${m}0.csv"
    count=$(wc -l "$current_dir/analysis/$hour:${m}0.csv" | awk '{ print $1 }')
    echo "$hour:${m}0,$count" >> "$var_file"
    echo "$hour:${m}0,$count" >> "$stat_file"
    cat "$current_dir/analysis/$hour:${m}0.csv" >> "$stat_file"
    echo "," >> $stat_file
    echo "$hour:${m}0" >> "$uniq_file"
    sort -u "$current_dir/analysis/$hour:${m}0.csv" >> "$uniq_file"
    echo "," >> $uniq_file
  done
done

rm -rf "$current_dir/analysis"
