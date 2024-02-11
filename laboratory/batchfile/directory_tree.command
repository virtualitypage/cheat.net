#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dir_name=$(basename "$current_dir")
main_file="$dir_name.txt"

function directory_tree () {
  cd "$current_dir" || exit
  tree | sed 's/──//g; s/│/｜/g;' | grep -vE "directories|files" > "$current_dir/$main_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ディレクトリ構成の出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [ "$current_dir" ]; then
  if command -v tree &>/dev/null; then
    directory_tree
  else
    echo -e "\033[1;31mERROR: tree コマンドがインストールされていません。コマンドをインストールしてから再度実行してください。\033[0m"
  fi
fi