#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

file_path=$1
main_file=$2.txt

function usage () {
  echo "csvファイルからデータを抽出してタグに代入する、webサイト'jigokudani.net'編集用スクリプト"
  echo "入力方法: $this [csvファイルパス] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ ! -f "$1" ]]; then
  echo -e "\033[1;31mERROR: csvファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: csvファイルパス $file_path は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

function jigokudani.net_template () {
while IFS=, read -r col1 col2 || [[ -n $col1 ]];
do
# col1, col2 は CSV ファイルの列のヘッダーまたはデータ
cat << EOF >> "$main_file"
                <div class="bundle2">
                  <dt>$col2</dt>
                  <dd>$col1</dd>
                </div>
EOF
done < "$file_path"

echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

if [[ -f $file_path ]] && [ "$main_file" ]; then
  jigokudani.net_template
fi