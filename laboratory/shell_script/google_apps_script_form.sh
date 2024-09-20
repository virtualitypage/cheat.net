#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

csv_file=$1
txt_file=$2.txt

function usage () {
  echo "csvファイルからデータを抽出してGASのコード(google form 作成用)に代入するスクリプト"
  echo "入力方法: $this [csvファイルパス] [出力ファイル名]"
  exit 1
}

function gas_create_form_template () {
  count=0
  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 || [[ -n $col10 ]]; do
    count=$(echo "$count+1" | bc)
    cat << EOF >> "$txt_file" # col1 は csv ファイルの列のヘッダーまたはデータ
  var page$count = form.addPageBreakItem().setTitle('$col1');
  page$count.setGoToPage(page$count);

  var item = form.addCheckboxGridItem();
  item.setTitle('$col1').setRows(['$col2', '$col3', '$col3', '$col4', '$col5', '$col6', '$col7', '$col8', '$col9', '$col10']).setColumns(['ある', 'ない']);

  var item = form.addParagraphTextItem();
  item.setTitle('$col2');

  var item = form.addParagraphTextItem();
  item.setTitle('$col3');

  var item = form.addParagraphTextItem();
  item.setTitle('$col4');

  var item = form.addParagraphTextItem();
  item.setTitle('$col5');

  var item = form.addParagraphTextItem();
  item.setTitle('$col6');

  var item = form.addParagraphTextItem();
  item.setTitle('$col7');

  var item = form.addParagraphTextItem();
  item.setTitle('$col8');

  var item = form.addParagraphTextItem();
  item.setTitle('$col9');

  var item = form.addParagraphTextItem();
  item.setTitle('$col10');

EOF
  done < "$csv_file"
  echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$txt_file は $current_dir に格納されています。\033[0m"
}

if [ -z "$1" ]; then
  usage
fi

if [ -z "$1" ]; then
  echo -e "\033[1;31mERROR: csv ファイルパスが指定されていません。ファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
elif [ ! -f "$1" ]; then
  echo -e "\033[1;31mERROR: csv ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
else
  echo -e "\033[1;32mSUCCESE: csv ファイルパス $csv_file は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $txt_file です。\033[0m"
fi

if [ -f "$csv_file" ] && [ "$txt_file" ]; then
  gas_create_form_template
fi
