#!/bin/bash
# ash 環境に合わせて開発

main_file="/www/js/admin.js"
internal="/tmp/mountd/disk1_part1/Internal/dev/!urandom"
dir="/www"

passwd_management () {
  passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1 | sort | uniq)
  touch "$internal/passwd($passphase)"
  file=$(grep "var validPassword =" "$main_file" | sed -e 's/  var validPassword = "//g' -e 's/"//g')
  mv "$internal/passwd($file)" "$internal/passwd($passphase)" 2>/dev/null
  mv "$dir/$file.html" "$dir/$passphase.html" 2>/dev/null
  sed -i.bak "s/var validPassword = \".*/var validPassword = \"$passphase\"/g" "$main_file"
  rm "$main_file.bak"
}

log_management () {
  passphase=$(cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1 | sort | uniq)
  touch "$internal/log($passphase)"
  file=$(grep "var validPasswordForLog =" "$main_file" | sed -e 's/  var validPasswordForLog = "//g' -e 's/"//g')
  mv "$internal/log($file)" "$internal/log($passphase)" 2>/dev/null
  mv "$dir/$file.html" "$dir/$passphase.html" 2>/dev/null
  sed -i.bak "s/var validPasswordForLog = \".*/var validPasswordForLog = \"$passphase\"/g" "$main_file"
  rm "$main_file.bak"
}

passwd_management
log_management
