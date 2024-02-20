#!/bin/bash

this=$(basename "$0")

src_volume=$1
dst_volume=$2
src_file="DSCF0001.AVI"

function usage () {
  echo "usage: 外部ディスクのデータを別のディスクに移動するスクリプト"
  echo "入力方法: $this [移動元ディスクパス] [移動先ディスクパス]"
  exit 1
}

if [[ -z "$1" ]]; then
  usage
  exit 1
elif [[ ! -d "$1" ]]; then
  echo -e "\033[1;31mERROR: 移動元ディスクパスの指定に誤りがあります。正しい移動元ディスクパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: /Volumes/xxx/\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 移動元ディスクパス $src_volume は有効です。\033[0m"
fi

if [[ -z "$2" ]]; then
  echo -e "\033[1;31mERROR: 移動先ディスクパスが指定されていません。移動先ディスクパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: /Volumes/xxx/\033[0m"
  exit 1
elif [[ ! -d "$2" ]]; then
  echo -e "\033[1;31mERROR: 移動先ディスクパスの指定に誤りがあります。正しい移動先ディスクパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: /Volumes/xxx/\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 移動先ディスクパス $dst_volume は有効です。\033[0m"
fi

function mv_volumes () {
  date_dir=$(stat -f "%Sm" -t "%Y-%-m-%-d" "$src_volume"$src_file)
  cd "$dst_volume" || exit
  mkdir "$date_dir"
  mv -i -v "$src_volume"* "$dst_volume"/"$date_dir"
  echo -e "\033[1;32mALL SUCCESEFUL: ファイルの移動処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$src_volume 配下のファイルは $dst_volume/$date_dir に格納されています。\033[0m"
}

if [[ -d $src_volume ]] && [[ -d $dst_volume ]]; then
  mv_volumes
fi
