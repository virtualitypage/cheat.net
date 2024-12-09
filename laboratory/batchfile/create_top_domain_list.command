#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
all_queries="$current_dir/all_queries.csv"
top_queried="$current_dir/top_queried_domains.csv"
top_blocked="$current_dir/top_blocked_domains.csv"
accept_domain="$current_dir/accept_domains.txt"
reject_domain="$current_dir/reject_domains.txt"

read -p "クエリログが格納されたディレクトリを指定して下さい: " dir

rm "$current_dir/$dir/ダッシュボード-表1-1-1.csv" \
   "$current_dir/$dir/ダッシュボード-表1.csv" \
   "$current_dir/$dir/ダッシュボード-表2.csv"

while IFS= read -r -d '' csv; do
  sed -i '' -e '/,,,,,/q' -e '/,,,,,/d' "$csv"
  tr -d '\n' < "$csv" >> "$all_queries.tmp"
done < <(find "$current_dir/$dir" -type f -name "*.csv*" -print0)

# sed -i '' '/Top queried domains,,,,Top blocked domains,,/q' "$all_queries.tmp"

awk '{
  if ($0 ~ /^[0-9][0-9][0-9][0-9]/) {
    gsub("^.*[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\,\"", "", $0)
    gsub("種類.*ステータス\: ", ",", $0);
    gsub("許可.*$", "許可", $0);
    gsub("ブロック済.*$", "ブロック済 " $0);
    gsub("処理済み.*$", "処理済み", $0);
    print $0;
  }
}' "$all_queries.tmp" > "$all_queries"

sort --unique "$all_queries" > "$current_dir/domains.txt"

grep "許可" "$current_dir/domains.txt" | sed 's/,許可//g' >> "$accept_domain.tmp"
grep "処理済み" "$current_dir/domains.txt" | sed 's/,処理済み//g' >> "$accept_domain.tmp"
grep "ブロック済" "$current_dir/domains.txt" | sed 's/,ブロック済//g' >> "$reject_domain.tmp"

sort --unique "$accept_domain.tmp" > "$accept_domain"
sort --unique "$reject_domain.tmp" > "$reject_domain"

echo "Domain,Requests Count" > "$top_queried"
echo "Domain,Requests Count" > "$top_blocked"

while IFS= read accept_domains || [[ -n $accept_domains ]]; do
  query_count=$(grep --count --extended-regexp "^${accept_domains}," "$all_queries")
  echo "\"$accept_domains\",$query_count" >> "$top_queried"
  echo "$accept_domains"
done < "$accept_domain"

while IFS= read reject_domains || [[ -n $reject_domains ]]; do
  query_count=$(grep --count --extended-regexp "^${reject_domains}," "$all_queries")
  echo "\"$reject_domains\",$query_count" >> "$top_blocked"
  echo "$reject_domains"
done < "$reject_domain"

rm "$all_queries" "$current_dir/domains.txt" "$accept_domain" "$reject_domain" "$accept_domain.tmp" "$reject_domain.tmp"
