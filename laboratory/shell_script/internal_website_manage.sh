#!/bin/bash
# ash 環境に合わせて開発

main_file="/www/js/admin.js"
internal="/tmp/mountd/disk1_part1/Internal/dev/!urandom"
dir="/www"

passwd_management () {
  for i in {1..3}; do
    passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1 | uniq)
    file_name=$(grep "var validPage_$i =" "$main_file" | sed -e "s/  var validPage_$i = \"//g" -e 's/"//g')
    mv "$dir/$file_name.html" "$dir/$passphase.html" 2>/dev/null
    sed -i.bak "s/var validPage_$i = \".*/var validPage_$i = \"$passphase\"/g" "$main_file"
  done
  rm "$main_file.bak"
}

log_management () {
  passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1 | uniq)
  touch "$internal/log($passphase)"
  file_name=$(grep "var validLogPage =" "$main_file" | sed -e 's/  var validLogPage = "//g' -e 's/"//g')
  mv "$internal/log($file_name)" "$internal/log($passphase)" 2>/dev/null
  mv "$dir/$file_name.html" "$dir/$passphase.html" 2>/dev/null
  sed -i.bak "s/var validLogPage = \".*/var validLogPage = \"$passphase\"/g" "$main_file"
  rm "$main_file.bak"
}

passwd_management
log_management
