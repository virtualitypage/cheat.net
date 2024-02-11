#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

tiktok_csv="$current_dir/tiktok.csv"
twitter_csv="$current_dir/twitter.csv"
nicovideo_csv="$current_dir/nicovideo.csv"

function open_url_tiktok () {
  sed -e '/Disable/ d' -e 's/,.*//g' "$tiktok_csv" > "$current_dir"/tiktok_readOnly.csv
  while IFS=, read -r url || [[ -n $url ]]; do
    open "$url"
    sleep 1
  done < "$current_dir/tiktok_readOnly.csv"
  rm "$current_dir/tiktok_readOnly.csv"
  echo -e "\033[1;32mALL SUCCESSFUL: URLへのアクセス処理が正常に終了しました。\033[0m"
}

function open_url_twitter () {
  sed -e '/Disable/ d' -e 's/,.*//g' "$twitter_csv" > "$current_dir/twitter_readOnly.csv"
  while IFS=, read -r url || [[ -n $url ]]; do
    open "$url"
    sleep 0.5
  done < "$current_dir/twitter_readOnly.csv"
  rm "$current_dir/twitter_readOnly.csv"
  echo -e "\033[1;32mALL SUCCESSFUL: URLへのアクセス処理が正常に終了しました。\033[0m"
}

function open_url_nicovideo () {
  sed -e '/Disable/ d' -e 's/,.*//g' "$nicovideo_csv" > "$current_dir/nicovideo_readOnly.csv"
  while IFS=, read -r url || [[ -n $url ]]; do
    open "$url"
    sleep 0
  done < "$current_dir/nicovideo_readOnly.csv"
  rm "$current_dir/nicovideo_readOnly.csv"
  echo -e "\033[1;32mALL SUCCESSFUL: URLへのアクセス処理が正常に終了しました。\033[0m"
}

if [ -f "$tiktok_csv" ]; then
  open_url_tiktok
  if [ -e "$twitter_csv" ] || [ -e "$nicovideo_csv" ]; then
    echo -e "\033[1;36mINFO: その他 csv ファイルの処理を5秒後に実行します。ブラウザにて新規ウィンドウを立ち上げてください\033[0m"
    echo
    sleep 5
  fi
fi

if [ -f "$twitter_csv" ]; then
  echo -e "\033[1;36mINFO:「問題が発生しました。再読み込みしてください。」という表示が出た場合、twitter.com にログインして対象の URL にアクセスしてください\033[0m"
  open_url_twitter
  if [ -e "$tiktok_csv" ] || [ -e "$nicovideo_csv" ]; then
    echo -e "\033[1;36mINFO: その他 csv ファイルの処理を5秒後に実行します。ブラウザにて新規ウィンドウを立ち上げてください\033[0m"
    echo
    sleep 5
  fi
fi

if [ -f "$nicovideo_csv" ]; then
  open_url_nicovideo
  if [ -e "$tiktok_csv" ] || [ -e "$twitter_csv" ]; then
    echo -e "\033[1;36mINFO: その他 csv ファイルの処理を5秒後に実行します。ブラウザにて新規ウィンドウを立ち上げてください\033[0m"
    echo
    sleep 5
  fi
fi

if [ ! -e "$tiktok_csv" ] && [ ! -e "$twitter_csv" ] && [ ! -e "$nicovideo_csv" ]; then
  echo -e "\033[1;31mERROR: URL を開くための csv ファイルが存在しません。\033[0m"
fi
