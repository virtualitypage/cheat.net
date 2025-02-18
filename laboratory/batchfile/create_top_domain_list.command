#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
all_queries="$current_dir/all_queries.csv"
top_queried="$current_dir/top_queried_domains.csv"
top_blocked="$current_dir/top_blocked_domains.csv"
accept_domain="$current_dir/accept_domains.txt"
reject_domain="$current_dir/reject_domains.txt"

read -rp "クエリログが格納されたディレクトリを指定して下さい: " dir

rm "$current_dir/$dir/ダッシュボード-表1-1-1.csv" \
   "$current_dir/$dir/ダッシュボード-表1.csv" \
   "$current_dir/$dir/ダッシュボード-表2.csv"

while IFS= read -r -d '' csv; do
  sed -i '' -e '/,,,,,/q' -e '/,,,,,/d' "$csv"
  echo "$csv"
  awk 'BEGIN { ORS=""; } # 出力の区切り文字を空に設定
  {
    gsub("^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2},\"", "", $0)
    gsub("種類: .*ステータス: ", "", $0)
    gsub("種類: .*$", "", $0)
    gsub("ステータス: ", "", $0)
    gsub("処理済み.*$", "処理済み", $0)
    gsub("許可.*$", "許可", $0)
    gsub("ブロック済.*$", "ブロック済", $0)
    gsub("ブロックされた脅威.*$", "ブロックされた脅威", $0)
    gsub("セーフサーチ.*$", "セーフサーチ", $0)
    gsub("ブロックするサービス.*$", "ブロックするサービス", $0)
    gsub("書換.*$", "書換", $0)

    if ($0 != "") { # 行が空でなければ出力
      print $0
    }
  }' "$csv" >> "$all_queries"
done < <(find "$current_dir/$dir" -type f -name "*.csv*" -print0)

# sed -i '' '/Top queried domains,,,,Top blocked domains,,/q' "$all_queries.tmp"

sed -i '' -e 's/処理済み/,処理済み\n/g' \
          -e 's/許可/,許可\n/g' \
          -e 's/ブロック済/,ブロック済\n/g' \
          -e 's/ブロックされた脅威/ブロックされた脅威\n/g' \
          -e 's/セーフサーチ/セーフサーチ\n/g' \
          -e 's/ブロックするサービス/ブロックするサービス\n/g' \
          -e 's/書換/書換\n/g' "$all_queries"

sed -i '' -e '/ブロックされた脅威/d' \
          -e '/セーフサーチ/d' \
          -e '/ブロックするサービス/d' \
          -e '/書換/d' "$all_queries"

sort --unique "$all_queries" > "$current_dir/domains.txt"

grep "許可" "$current_dir/domains.txt" | sed 's/,許可.*//g' >> "$accept_domain.tmp"
grep "処理済み" "$current_dir/domains.txt" | sed 's/,処理済み.*//g' >> "$accept_domain.tmp"
grep "ブロック済" "$current_dir/domains.txt" | sed 's/,ブロック済.*//g' >> "$reject_domain.tmp"

sort --unique "$accept_domain.tmp" > "$accept_domain"
sort --unique "$reject_domain.tmp" > "$reject_domain"

echo "Domain,Requests Count" > "$top_queried"
echo "Domain,Requests Count" > "$top_blocked"

while IFS= read -r accept_domains || [[ -n $accept_domains ]]; do
  query_count=$(grep --count --extended-regexp "^${accept_domains}," "$all_queries")
  echo "\"$accept_domains\",$query_count" >> "$top_queried"
  echo "$accept_domains"
done < "$accept_domain"

while IFS= read -r reject_domains || [[ -n $reject_domains ]]; do
  query_count=$(grep --count --extended-regexp "^${reject_domains}," "$all_queries")
  echo "\"$reject_domains\",$query_count" >> "$top_blocked"
  echo "$reject_domains"
done < "$reject_domain"

rm "$all_queries" "$current_dir/domains.txt" "$accept_domain" "$reject_domain" "$accept_domain.tmp" "$reject_domain.tmp"
