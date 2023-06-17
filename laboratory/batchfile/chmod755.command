#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dir_name="権限付与フォルダ"

function create_dir () {
  mkdir -p "${current_dir}/${dir_name}"
  chmod 755 "${current_dir}/${dir_name}"
}

function run_chmod () {
  find "${current_dir}/${dir_name}" -type f -exec chmod 755 {} \;
}

if [ -d "${current_dir}/${dir_name}" ]; then
  file_count=$(find "${current_dir}/${dir_name}" -maxdepth 1 -type f | wc -l)
  if [ "$file_count" -gt 0 ]; then
    run_chmod
    cd ${current_dir}/${dir_name}
    ls -la
    echo "${current_dir}/${dir_name}内の全ファイルに権限を付与しました。"
    echo ""
  else
    echo "${current_dir}/${dir_name}内にファイルが存在しません。"
    echo ""
  fi
elif [ ! -d "${current_dir}/${dir_name}" ]; then
  create_dir
  echo "${current_dir}に権限付与フォルダを作成しました。"
  echo "このフォルダに実行したいプログラムファイル(XXX.shやXXX.commandなど)をドラッグ&ドロップ。"
  echo "再度chmod_755.commandをダブルクリックするとフォルダ内の全ファイルに権限(読込・書込・実行)が付与されます。"
  echo ""
  exit 1
else
  echo ""
fi
