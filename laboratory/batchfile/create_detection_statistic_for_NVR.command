#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
sub_file="$current_dir/sort.csv"
mid_file="$current_dir/count.csv"

read -rp "対象ファイルの日付を入力 [YYYY-MM] > " stat_file
tmp_file="$current_dir/${stat_file}_copy.txt"

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
main_file2="$current_dir/status_count - ${year}_${month} dayOfWeek.csv"
target_date=$(printf "%04d-%02d\n" "$year" "$month")
mv /Volumes/Untitled/完了済/$target_date-*/$target_date-*.txt /Volumes/Untitled/完了済

function paste_text () {
  paste -d , "$current_dir/ch_num1.csv" "$current_dir/ch_num2.csv" "$current_dir/ch_num3.csv" "$current_dir/ch_num4.csv" > "$main_file"
  rm "$current_dir/ch_num1.csv" "$current_dir/ch_num2.csv" "$current_dir/ch_num3.csv" "$current_dir/ch_num4.csv"
}

monday=()
tuesday=()
wednesday=()
thursday=()
friday=()
saturday=()
sunday=()

function count () {
  for ((d = 1; d <= days_in_month; d++)); do
    day=$(printf "%02d" "$d")
    dayOfWeek=$(date -j -f "%Y/%m/%d" "$year/$month/$day" +"%a曜日")
    case $dayOfWeek in
      月曜日)
        monday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        monday+=("$monday_count")
      ;;
      火曜日)
        tuesday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        tuesday+=("$tuesday_count")
      ;;
      水曜日)
        wednesday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        wednesday+=("$wednesday_count")
      ;;
      木曜日)
        thursday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        thursday+=("$thursday_count")
      ;;
      金曜日)
        friday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        friday+=("$friday_count")
      ;;
      土曜日)
        saturday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        saturday+=("$saturday_count")
      ;;
      日曜日)
        sunday_count=$(grep --count "${year}年${month}月${day}日" "$tmp_file")
        sunday+=("$sunday_count")
      ;;
    esac
  done

  # 配列の要素を "+" で連結して計算
  monday_total=$((${monday[@]/%/+}0))
  tuesday_total=$((${tuesday[@]/%/+}0))
  wednesday_total=$((${wednesday[@]/%/+}0))
  thursday_total=$((${thursday[@]/%/+}0))
  friday_total=$((${friday[@]/%/+}0))
  saturday_total=$((${saturday[@]/%/+}0))
  sunday_total=$((${sunday[@]/%/+}0))
  echo "$monday_total,$tuesday_total,$wednesday_total,$thursday_total,$friday_total,$saturday_total,$sunday_total" >> "$main_file2"
  rm "$tmp_file"

  monday=(); tuesday=(); wednesday=(); thursday=(); friday=(); saturday=(); sunday=()
}

function create () {
  ch_status="$current_dir/ch_num$ch_num.csv"
  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      for ((d = 1; d <= days_in_month; d++)); do
        day=$(printf "%02d" "$d")
        grep "${year}年${month}月${day}日 $hour:${m}[0-9]" "$tmp_file" | sed 's/^.* //g' >> "$mid_file"
      done
      sort "$mid_file" > "$sub_file"
      count=$(grep --count --extended-regexp "$hour:${m}[0-9]" "$sub_file")
      echo "$target_date,$hour:${m}0,$count" >> "$ch_status"
    done
  done
  rm "$sub_file" "$mid_file"
}

function create1 () {
  ch_status="$current_dir/ch_num$ch_num.csv"
  for h in {0..23}; do
    for m in {0..5}; do
      hour=$(printf "%02d" "$h")
      for ((d = 1; d <= days_in_month; d++)); do
        day=$(printf "%02d" "$d")
        grep "${year}年${month}月${day}日 $hour:${m}[0-9]" "$tmp_file" | sed 's/^.* //g' >> "$mid_file"
      done
      sort "$mid_file" > "$sub_file"
      count=$(grep --count --extended-regexp "$hour:${m}[0-9]" "$sub_file")
      echo "$count" >> "$ch_status"
    done
  done
  rm "$sub_file" "$mid_file"
}

function channel1 () {
  for ((d = 1; d <= days_in_month; d++)); do
    day=$(printf "%02d" "$d")
    TARGET_STATUS_TEXT="$current_dir/$target_date-$day status nvr(ch1).txt"
    cat "$TARGET_STATUS_TEXT" >> "$tmp_file"
  done
  echo "channel1のstatusファイル結合完了"
  export ch_num=1
  create
  count
}

function channel2 () {
  for ((d = 1; d <= days_in_month; d++)); do
    day=$(printf "%02d" "$d")
    TARGET_STATUS_TEXT="$current_dir/$target_date-$day status nvr(ch2).txt"
    cat "$TARGET_STATUS_TEXT" >> "$tmp_file"
  done
  echo "channel2のstatusファイル結合完了"
  export ch_num=2
  create1
  count
}

function channel3 () {
  for ((d = 1; d <= days_in_month; d++)); do
    day=$(printf "%02d" "$d")
    TARGET_STATUS_TEXT="$current_dir/$target_date-$day status nvr(ch3).txt"
    cat "$TARGET_STATUS_TEXT" >> "$tmp_file"
  done
  echo "channel3のstatusファイル結合完了"
  export ch_num=3
  create1
  count
}

function channel4 () {
  for ((d = 1; d <= days_in_month; d++)); do
    day=$(printf "%02d" "$d")
    TARGET_STATUS_TEXT="$current_dir/$target_date-$day status nvr(ch4).txt"
    cat "$TARGET_STATUS_TEXT" >> "$tmp_file"
  done
  echo "channel4のstatusファイル結合完了"
  export ch_num=4
  create1
  count
}

channel1
channel2
channel3
channel4
paste_text
