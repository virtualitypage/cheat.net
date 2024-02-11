#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

directory=$1
main_file=$2.txt
example=ディレクトリ構成表

function usage () {
  echo "指定されたディレクトリのディレクトリ構成をファイルに出力するスクリプト"
  echo "入力方法: $this [ディレクトリパス] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ ! -d $1 ]]; then
  echo -e "\033[1;31mERROR: ディレクトリパスの指定に誤りがあります。正しいディレクトリパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx\033[0m"
else
  echo -e "\033[1;32mSUCCESE: ディレクトリパス $directory は有効です。\033[0m"
fi

if [ -z $2 ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $example\033[0m"
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

function directory_tree () {
  cd "$directory" || exit
  tree | sed 's/──//g; s/│/｜/g' | grep -vE "directories|files" > "$current_dir"/"$main_file"
  echo -e "\033[1;32mALL SUCCESEFUL: ディレクトリ構成の出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [[ -d $directory ]] && [ "$main_file" ]; then
  if command -v tree &>/dev/null; then
    directory_tree
  else
    echo -e "\033[1;31mERROR: tree コマンドがインストールされていません。コマンドをインストールしてから再度実行してください。\033[0m"
  fi
fi