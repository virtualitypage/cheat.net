#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

csv_file=$1
txt_file=$2

count=0

function usage {
  echo "csvファイルからデータを抽出してタグに代入する、プライベートwebサイト'cheat.net/upload-link/app/*.html'編集用スクリプト"
  echo "入力方法: $this [csvファイルパス] [ youtube | tiktok | twitter ](出力ファイル名)"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ -z "$1" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスが指定されていません。ファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
elif [[ ! -f "$1" ]]; then
  echo -e "\033[1;31mERROR: csvファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: ファイルパス $csv_file は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: youtube | tiktok | twitter\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $txt_file です。\033[0m"
fi

function upload-link_template () {
while IFS=, read -r col1 col2 || [[ -n $col2 ]];
do

count=$(echo "$count+1" | bc)

# col1, col2 は CSV ファイルの列のヘッダーまたはデータ
cat << EOF >> "$txt_file".txt
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "$csv_file"

echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$txt_file は $current_dir に格納されています。\033[0m"
}

if [[ -f $csv_file ]] && [ "$txt_file" ]; then
  upload-link_template
fi
