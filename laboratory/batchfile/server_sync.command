#!/bin/bash

today=$(date '+%Y-%m-%d')
src_volume="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/Internal"
dst_volume="/Volumes/Internal"
SERVER="Internal"
logfile=$src_volume/server_sync_"$today".log

function server_sync () {
  # Google Drive 共有フォルダ "Internal" の親ディレクトリ
  src_dev="$src_volume/dev/"
  src_media="$src_volume/media/"
  src_usr="$src_volume/usr/"
  src_var="$src_volume/var/"

  # internalサーバ(Samba)の親ディレクトリ
  dst_dev="$dst_volume/dev"
  dst_media="$dst_volume/media"
  dst_usr="$dst_volume/usr"
  dst_var="$dst_volume/var"

  # internalサーバ(Samba)に転送
  echo "rsync --archive --human-readable --progress --recursive \"$src_dev\" $dst_dev"
  rsync --archive --human-readable --progress --recursive "$src_dev" $dst_dev
  echo
  echo "rsync --archive --human-readable --progress --recursive \"$src_media\" $dst_media"
  rsync --archive --human-readable --progress --recursive "$src_media" $dst_media
  echo
  echo "rsync --archive --human-readable --progress --recursive \"$src_usr\" $dst_usr"
  rsync --archive --human-readable --progress --recursive "$src_usr" $dst_usr
  echo
  echo "rsync --archive --human-readable --progress --recursive \"$src_var\" $dst_var"
  rsync --archive --human-readable --progress --recursive "$src_var" $dst_var
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの同期処理が正常に終了しました。\033[0m"
  echo
}

exec > >(tee -a "$logfile")

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ] && [ -e "$src_volume" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -e "$src_volume" ]; then
  if [ -e $dst_volume ]; then
    echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" は有効です。\033[0m"
    echo
    server_sync
  elif [ ! -e $dst_volume ]; then
    echo -e "\033[1;31mERROR: SERVER \"$SERVER\" にアクセス出来ません。サーバーにアクセスされているか確認して再度実行してください。\033[0m"
    echo
    exit 1
  fi
elif [ ! -e "$src_volume" ]; then
  echo -e "\033[1;31mERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
