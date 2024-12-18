#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
guard="/Volumes/virtual_env/GitHub/expansion_NW/guard"
domain_txt="$current_dir/domains.txt"

sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/@||//g' $guard/A*.txt > "$domain_txt"
sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/@||//g' $guard/R*.txt > "$domain_txt"
sed -e '/#/d' -e 's/0.0.0.0 //g' -e 's/@||//g' $guard/S*.txt > "$domain_txt"

sed -i '' '/^$/d' "$domain_txt"

while IFS= read -r domain || [[ -n $domain ]]; do
  result=$(grep --line-number "$domain" $guard/*)
  result_count=$(echo "$result" | wc --lines | awk '{ print $1 }')
  if [ "$result_count" -ne 1 ]; then
    echo "$result"
    echo -e "\033[1;31mduplicate count: $result_count\033[0m"
    echo
  fi
done < "$domain_txt"
rm "$domain_txt"
