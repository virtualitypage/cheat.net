#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
sub_file="$current_dir/sort.csv"
mid_file="$current_dir/count.csv"

echo "注意: 防犯カメラのstatusファイルから指定の月を含む行を抜き出し、一つのstatusファイルにしたものを読み込みます"
read -rp "ファイル名の形式 [YYYY-MM.txt] > " stat_file

year=$(echo "$stat_file" | sed 's/-/ /g' | awk '{ print $1 }')
month=$(echo "$stat_file" | sed 's/-/ /g' | awk '{ printf "%02d", $2 }')

case $month in # 各月の日数を考慮
  01|03|05|07|08|10|12)
    days_in_month=31
  ;;
  04|06|09|11)
    days_in_month=30
  ;;
  02)
    # 閏年の計算
    if [ $(("$year" % 4)) -eq 0 ] && [ $(("$year" % 100)) -ne 0 ] || [ $(("$year" % 400)) -eq 0 ]; then
      days_in_month=29
    else
      days_in_month=28
    fi
  ;;
esac

main_file="$current_dir/status_count - ${year}_${month}.csv"
target_date=$(printf "%04d-%02d\n" "$year" "$month")

for h in {0..23}; do
  for m in {0..5}; do
    hour=$(printf "%02d" "$h")
    for ((d = 1; d <= days_in_month; d++)); do
      day=$(printf "%02d" "$d")
      grep "${year}年${month}月${day}日 $hour:${m}[0-9]" "$current_dir/$stat_file" | sed 's/^.* //g' >> "$mid_file"
    done
    sort "$mid_file" > "$sub_file"
    count=$(grep --count --extended-regexp "$hour:${m}[0-9]" "$sub_file")
    echo "$target_date,$hour:${m}0,$count" >> "$main_file"
  done
done

rm "$sub_file" "$mid_file"
