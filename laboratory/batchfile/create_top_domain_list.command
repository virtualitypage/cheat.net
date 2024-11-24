#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
top_queried="$current_dir/top_queried_domains.csv"
top_blocked="$current_dir/top_blocked_domains.csv"

read -p "クエリログが格納されたディレクトリを指定して下さい: " dir

rm "$current_dir/$dir/ダッシュボード*"

while IFS= read -r -d '' csv; do
  tr -d '\n' < "$csv" > "$csv.tmp"
  grep -E "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]" "$csv.tmp" >> "$current_dir/query_log_all.csv"
done < <(find "$current_dir/$dir" -type f -name "*.csv*" -print0)

sed -e 's|.*[0-9][0-9]:[0-9][0-9]:[0-9][0-9],"||g' \
    -e 's/種類:.*ステータス: /,/g' \
    -e 's/ .*//g' \
    -e 's/処理済み,.*/処理済み/g' \
    -e 's/",//g' \
    -e 's/許可.*/許可/g' \
    -e 's/ブロック済.*/ブロック済/g' "$current_dir/query_log_all.csv" | sort -u > "$current_dir/domains.txt"

grep "許可" "$current_dir/domains.txt" | sed 's/,許可//g' >> "$current_dir/accept_domains.txt"
grep "処理済み" "$current_dir/domains.txt" | sed 's/,処理済み//g' >> "$current_dir/accept_domains.txt"
grep "ブロック済" "$current_dir/domains.txt" | sed 's/,ブロック済//g' >> "$current_dir/reject_domains.txt"

cd "$current_dir/$dir" || exit

echo "Domain,Requests Count" > "$top_queried"
echo "Domain,Requests Count" > "$top_blocked"

while IFS= read accept_domains || [[ -n $accept_domains ]]; do
  query_count=$(grep -o "$accept_domains" * | wc -l)
  echo "$accept_domains,$query_count" >> "$top_queried"
  echo "$accept_domains"
done < "$current_dir/accept_domains.txt"

while IFS= read reject_domains || [[ -n $reject_domains ]]; do
  query_count=$(grep -o "$reject_domains" * | wc -l)
  echo "$reject_domains,$query_count" >> "$top_blocked"
  echo "$reject_domains"
done < "$current_dir/reject_domains.txt"

rm "$current_dir/query_log_all.csv" "$current_dir/domains.txt" "$current_dir/accept_domains.txt" "$current_dir/reject_domains.txt"
