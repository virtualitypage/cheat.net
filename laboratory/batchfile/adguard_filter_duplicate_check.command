#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
repos=$(find "$current_dir" -type d -name "expansion_NW" 2>/dev/null)
guard=$(find "$repos" -type d -name "guard" 2>/dev/null)
domain_txt="$current_dir/domains.txt"

sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/||//g' -e 's/\///g' $guard/A*.txt >> "$domain_txt"
sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/||//g' -e 's/\///g' $guard/R*.txt >> "$domain_txt"
sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/||//g' -e 's/\///g' $guard/S*.txt >> "$domain_txt"

sed -i '' -e '/^$/d' -e 's/@//g' "$domain_txt"

while IFS= read -r domain || [[ -n $domain ]]; do
  result=$(grep --line-regexp --line-number "$domain" $guard/*)
  result_count=$(echo "$result" | wc -l | awk '{ print $1 }')
  if [ "$result_count" -ne 1 ]; then
    echo "$result"
    echo -e "\033[1;31mduplicate count: $result_count\033[0m"
    echo
  fi
done < "$domain_txt"
rm "$domain_txt"
