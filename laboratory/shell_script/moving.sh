#!/bin/bash

this=$(basename "$0")

function usage {
  echo "フォルダ内の全ファイルを指定したフォルダに移動するスクリプト"
  echo "$this [移動元のディレクトリパス] [移動先のディレクトリパス]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

# 移動元のディレクトリパス
source_directory=$1

# 移動先のディレクトリパス
destination_directory=$2

# 移動元ディレクトリ内の全てのファイルを移動する
cp -i "$source_directory"/* "$destination_directory"
ls -l "$destination_directory"
rm "$source_directory"/*
