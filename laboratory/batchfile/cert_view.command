#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/issuer_list.txt"
sub_file="$current_dir/certificate_viewer.txt"

URL=$(grep "https://" "$sub_file")

function cert_view () {
  if [ -n "$URL" ]; then
    while IFS= read -r URL || [[ -n $URL ]]; do
      echo "・$URL" >> "$main_file"
      cert_info=$(openssl s_client -connect $(echo "$URL" | sed -n -e 's/https:\/\/\([^\/]*\).*/\1/p'):443 -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text)
      cert_view=$(echo "$cert_info" | sed -n '/Certificate:/,/Subject Public Key Info:/p' | sed '$d')
      echo "$cert_view" >> "$main_file"
      echo >> "$main_file"
    done < "$sub_file"
  fi
}

if [ -f "$sub_file" ]; then
  cert_view
elif [ ! -f "$sub_file" ]; then
  echo -e "\033[1;31mERROR: $sub_file が存在しません。\033[0m"
fi
