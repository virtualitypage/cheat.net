#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
repos=$(find "$current_dir" -type d -name "AdGuardHome_Filters" 2>/dev/null)
domain_txt="$current_dir/domains.txt"

sed -e '/#/d' $repos/accept/A*.txt >> "$domain_txt"
sed -i '' -e '/^$/d' "$domain_txt"

while IFS= read -r domain || [[ -n $domain ]]; do
  result=$(grep --fixed-strings --line-regexp --line-number "$domain" $repos/accept/A*.txt)
  result_count=$(echo "$result" | wc -l | awk '{ print $1 }')
  if [ "$result_count" -ne 1 ]; then
    echo "$result"
    echo -e "\033[1;31mduplicate count: $result_count\033[0m"
    echo
  fi
done < "$domain_txt"
rm "$domain_txt"

sed -e '/#/d' "$repos/reject/Reject_domain.txt" >> "$domain_txt"
sed -i '' -e '/^$/d' "$domain_txt"

while IFS= read -r domain || [[ -n $domain ]]; do
  result=$(grep --fixed-strings --line-regexp --line-number "$domain" $repos/reject/Reject_domain.txt)
  result_count=$(echo "$result" | wc -l | awk '{ print $1 }')
  if [ "$result_count" -ne 1 ]; then
    echo "$result"
    echo -e "\033[1;31mduplicate count: $result_count\033[0m"
    echo
  fi
done < "$domain_txt"
rm "$domain_txt"
