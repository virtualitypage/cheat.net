#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

function setting_Internal-server () {
  # dev
  mkdir "$current_dir/dev"
  setfile -m "3/1/2024 0:00" "$current_dir/dev"

  # media
  mkdir -p "$current_dir/media" && cd "$_"
  mkdir movie photos red_zone
  setfile -m "3/1/2024 0:00" "$current_dir/media"
  setfile -m "3/1/2024 0:00" "$current_dir/media/*"

  # usr/local
  mkdir -p "$current_dir/usr/local" && cd $_
  mkdir footage && cd $_
  mkdir 2023 2024 2025
  mkdir "$current_dir/usr/local/web_archive"
  setfile -m "3/1/2024 0:00" "$current_dir/usr"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/local"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/local/footage"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/local/footage/*"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/local/web_archive"

  # usr/share
  mkdir -p "$current_dir/usr/share" && cd $_
  mkdir analysis arch config pdf
  setfile -m "3/1/2024 0:00" "$current_dir/usr/share"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/share/*"

  # usr/src
  mkdir -p "$current_dir/usr/src" && cd $_
  mkdir apple google shell
  setfile -m "3/1/2024 0:00" "$current_dir/usr/src"
  setfile -m "3/1/2024 0:00" "$current_dir/usr/src/*"

  # var/cache
  mkdir -p "$current_dir/var/cache"
  setfile -m "3/1/2024 0:00" "$current_dir/var/"
  setfile -m "3/1/2024 0:00" "$current_dir/var/cache"

  # var/data/gl-mt3000
  mkdir -p "$current_dir/var/data/gl-mt3000" && cd $_
  mkdir cpu_usage disk_usage msmtp_log process query_log traffic_stat
  setfile -m "3/1/2024 0:00" "$current_dir/var/data/*"
  setfile -m "3/1/2024 0:00" "$current_dir/var/data/gl-mt3000/*"

  # var/log/securityLog
  mkdir -p "$current_dir/var/log/securityLog" && cd $_
  mkdir 2023 2024 2025
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/"
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/securityLog"
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/securityLog/*"

  # var/log/stat_text
  mkdir -p "$current_dir/var/log/stat_text" && cd $_
  mkdir 2023 2024 2025
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/stat_text"
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/stat_text/*"

  # var/log/stdout
  mkdir -p "$current_dir/var/log/stdout"
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/stdout"

  # var/log/talk
  mkdir -p "$current_dir/var/log/talk"
  setfile -m "3/1/2024 0:00" "$current_dir/var/log/talk"

  # var/mail
  mkdir -p "$current_dir/var/mail"
  setfile -m "3/1/2024 0:00" "$current_dir/var/mail"
  echo -e "\033[1;32mALL SUCCESSFUL: フォルダの作成処理が正常に終了しました。\033[0m"
  echo
}
setting_Internal-server
