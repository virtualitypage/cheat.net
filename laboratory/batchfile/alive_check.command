#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/block.txt"
sub_file="$current_dir/AdGuard - DNS BlockList.csv"

function open_url () {
  while IFS=, read -r url || [[ -n $url ]]; do
    URL=$(echo "$url" | tr -d '\r')
    active=$(curl -I --max-time 10 "$URL" 2>/dev/null | head -n 1 | tr -d '\r' | sed 's/[[:space:]]*$//')
    inactive=$(curl -I --max-time 10 "$URL" 2>&1 | grep -o "Could not resolve host")
    if [[ "$active" =~ 200 ]] || [[ "$active" =~ 302 ]]; then
      echo -e "\033[1;32mActive: $URL\033[0m"
      echo "$URL" >> "$main_file"
    elif [[ "$active" =~ 403 ]]; then
      echo -e "\033[1;33m$active: $URL\033[0m"
    elif [ "$inactive" == "Could not resolve host" ] || [[ "$active" =~ 404 ]]; then
      echo -e "\033[1;31mInactive: $URL\033[0m"
    elif [ -z "$active" ] || [ -z "$inactive" ]; then
      echo -e "\033[1;31mTimeout: $URL\033[0m"
    fi
  done < "$sub_file"
  sed -i '' 's/http:\/\//0.0.0.0 /g' "$main_file"
  sed -i '' 's/https:\/\//0.0.0.0 /g' "$main_file"
  sed -i '' 's/\/$//' "$main_file"
}
open_url
