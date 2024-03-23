#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

function setting_Internal-server () {
  mkdir "$current_dir"/dev

  mkdir "$current_dir"/usr
  mkdir "$current_dir"/usr/local
  mkdir "$current_dir"/usr/local/footage
  mkdir "$current_dir"/usr/local/footage/2023 "$current_dir"/usr/local/footage/2024
  mkdir "$current_dir"/usr/share
  mkdir "$current_dir"/usr/share/arch "$current_dir"/usr/share/config "$current_dir"/usr/share/pdf
  mkdir "$current_dir"/usr/src
  mkdir "$current_dir"/usr/src/apple "$current_dir"/usr/src/google "$current_dir"/usr/src/shell

  mkdir "$current_dir"/var/
  mkdir "$current_dir"/var/cache/
  mkdir "$current_dir"/var/log/
  mkdir "$current_dir"/var/log/securityLog
  mkdir "$current_dir"/var/log/securityLog/2023 "$current_dir"/var/log/securityLog/2024
  mkdir "$current_dir"/var/log/stat_text
  mkdir "$current_dir"/var/log/stat_text/2023 "$current_dir"/var/log/stat_text/2024
  mkdir "$current_dir"/var/log/stdout
  mkdir "$current_dir"/var/log/talk
  mkdir "$current_dir"/var/mail/

  setfile -m "3/1/2024 0:00" "$current_dir"/dev
  setfile -m "3/1/2024 0:00" "$current_dir"/usr
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/local
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/local/footage
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/local/footage/2023 "$current_dir"/usr/local/footage/2024
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/share
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/share/arch "$current_dir"/usr/share/config "$current_dir"/usr/share/pdf
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/src
  setfile -m "3/1/2024 0:00" "$current_dir"/usr/src/apple "$current_dir"/usr/src/google "$current_dir"/usr/src/shell
  setfile -m "3/1/2024 0:00" "$current_dir"/var/
  setfile -m "3/1/2024 0:00" "$current_dir"/var/cache/
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/securityLog
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/securityLog/2023 "$current_dir"/var/log/securityLog/2024
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/stat_text
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/stat_text/2023 "$current_dir"/var/log/stat_text/2024
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/stdout
  setfile -m "3/1/2024 0:00" "$current_dir"/var/log/talk
  setfile -m "3/1/2024 0:00" "$current_dir"/var/mail/
  echo -e "\033[1;32mALL SUCCESSFUL: フォルダの作成処理が正常に終了しました。\033[0m"
  echo
}

setting_Internal-server