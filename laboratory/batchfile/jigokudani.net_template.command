#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/jigokudani.net_code.txt"
sub_file="$current_dir/create_jigokudani.net_about.csv"

function create_csv () {
  for ((i = 1; i <= 10; i++)); do
    echo "," >> "$sub_file"
  done
  echo -e "\n" >> "$sub_file" # 最終行に改行文字を追加
}

function create_code () {
  while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
    cat << EOF >> "$main_file"
                <div class="bundle2">
                  <dt>$col2</dt>
                  <dd>$col1</dd>
                </div>
EOF
  done < "$sub_file"
}

if [ -f "$sub_file" ]; then
  create_code
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
elif [ ! -f "$sub_file" ]; then
  create_csv
  echo -e "\033[1;31mERROR: 読込用csvがありません。対象のファイルを $current_dir に生成します。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "※csvの一列目にはメニューの品名、二列目には値段(単位:円)を入力します。"
  echo
  echo "| 品名1 | 100円 |"
  echo "| 品名2 | 200円 |"
  echo "| 品名2 | 300円 |"
  echo
  exit 1
else
  echo
fi
