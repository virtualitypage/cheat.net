#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
csv="create_jigokudani.net_about.csv"
code_txt="jigokudani.net_code.txt"

function create_csv () {
  for ((i=1; i<=10; i++))
  do
    echo "," >> "${current_dir}/${csv}"
  done
  echo -e "\n" >> "${current_dir}/${csv}" # 最終行に改行文字を追加
}

function create_code () {

while IFS=, read -r col1 col2 || [[ -n $col2 ]];
do
cat << EOF >> "${current_dir}/${code_txt}"
                <div class="bundle2">
                  <dt>$col2</dt>
                  <dd>$col1</dd>
                </div>
EOF
done < "${current_dir}/${csv}"
}

if [ -f "${current_dir}/${csv}" ]; then
  create_code
  echo "ファイル作成が完了しました。ファイルは${current_dir}/${code_txt}に保存されました。"
  echo ""
elif [ ! -f "${current_dir}/${csv}" ]; then
  create_csv
  echo "読込用csvがありません。$(cd $(dirname $0) && pwd)に${csv}を作成しました。"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "※csvの一列目にはメニューの品名、二列目には値段(単位:円)を入力します。"
  echo ""
  echo "| 品名1 | 100円 |"
  echo "| 品名2 | 200円 |"
  echo "| 品名2 | 300円 |"
  echo ""
  exit 1
else
  echo ""
fi