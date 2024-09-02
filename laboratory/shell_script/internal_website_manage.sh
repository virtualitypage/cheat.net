#!/bin/bash
# ash 環境に合わせて開発

main_file="/www/js/admin.js"
# internal="/tmp/mountd/disk1_part1/Internal/dev/!urandom"
dir="/www"

passwd_management () {
  for i in $(seq 1 3); do
    passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z4-9' | fold -w 10 | head -n 1 | uniq)
    file_name=$(grep "var validPage_$i =" "$main_file" | sed -e "s/  var validPage_$i = \"//g" -e 's/"//g')
    if mv "$dir/${file_name}$i.html" "$dir/${passphase}$i.html" 2>/dev/null; then
      sed -i.bak "s/var validPage_$i = \".*/var validPage_$i = \"$passphase\"/g" "$main_file"
      rm "$main_file.bak"
    else
      find_file=$(find $dir -type f -name "*$i.html" | sed "s/$i.html//g")
      find_file=$(basename "$find_file")
      mv "$dir/${find_file}$i.html" "$dir/${file_name}$i.html" 2>/dev/null
    fi
  done
}

log_archive () {
  passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z4-9' | fold -w 10 | head -n 1 | sort | uniq)
  file_name=$(grep "var validLogPage =" "$main_file" | sed -e 's/  var validLogPage = "//g' -e 's/"//g')
  if mv "$dir/${file_name}log.html" "$dir/${passphase}log.html" 2>/dev/null; then
    sed -i.bak "s/var validLogPage = \".*/var validLogPage = \"$passphase\"/g" "$main_file"
    rm "$main_file.bak"
  else
    find_file=$(find $dir -type f -name '*log.html' | sed 's/log.html//g')
    find_file=$(basename "$find_file")
    mv "$dir/${find_file}log.html" "$dir/${file_name}log.html" 2>/dev/null
  fi
}

passwd_management
log_archive
