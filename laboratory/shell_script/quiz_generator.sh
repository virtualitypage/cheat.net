#!/bin/bash

change=false

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

csv_file=$2
txt_file=$3.txt

function usage () {
  echo "csvファイルからデータを抽出する、テキストで問題を作る web サイト'https://quizgenerator.net'用スクリプト"
  echo "入力方法: $this { -t | -f }(-tで出題順のランダム化) [csvファイルパス] [ cisco | lpic | aws ](出力ファイル名)"
  echo "csvファイル1列目に[ 択一問題 | fill-in: | ma: ]のいずれか一つを入力する"
  echo "csvファイル2列目に問題文、3列目以降に選択肢を入力"
  echo "択一問題の場合、「択一問題」を1列目、正解の答えを3列目に入力する"
  echo "記述問題の場合、「fill-in:」を1列目、答えを3列目に入力する"
  echo "選択問題の場合、「ma:」を1列目、3列目以降に選択肢を入力する"
  echo "また、テキストファイル生成後、正解の選択肢はo、不正解の選択肢はxに書き換える"
  exit 1
}

function shuffle_questions_true () {
  change=true
}

while getopts ":t:f:" opt; do
  case $opt in
    t)
      echo -e "\033[1;32mSUCCESE: 指定されたオプション -t により、出題順のランダム化が適用されます。\033[0m"
      shuffle_questions_true
    ;;
    f)
      echo -e "\033[1;32mSUCCESE: 指定されたオプション -f により、出題順のランダム化が無効になります。\033[0m"
    ;;
    \?)
      echo -e "\033[1;31mERROR: 指定されたオプション $1 は無効です。\033[0m"
      echo -e "\033[1;31m指定可能なオプションは { -t | -f } です。\033[0m"
      exit 1
    ;;
  esac
done

if [ -z "$1" ]; then
  usage
fi

if [ -f "$1" ]; then
  echo -e "\033[1;31mERROR: オプションが指定されていません。\033[0m"
  echo -e "\033[1;31m指定可能なオプションは { -t | -f } です。\033[0m"
  exit 1
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: csv ファイルパスが指定されていません。csvファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
elif [ ! -f "$2" ]; then
  echo -e "\033[1;31mERROR: csv ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: csv ファイルパス $csv_file は有効です。\033[0m"
fi

if [ -z "$3" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $txt_file です。\033[0m"
fi

# if [ "${1:0:1}" == "-" ]; then
#   shuffle_questions_true
#   shift 1
# fi

function quiz_generator () {
  cat << EOF > "$txt_file"
#title:$txt_file
#movable:true
#shuffle_questions:$change
EOF

  count=0
  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7; do
    count=$(echo "$count+1" | bc)
    if [ 択一問題 = "$col1" ]; then
      cat << EOF >> "$txt_file"
問題 $count $col2
択一問題
a. $col3
b. $col4
c. $col5
d. $col6
e. $col7

EOF
    elif [ fill-in: = "$col1" ]; then
      cat << EOF >> "$txt_file"
問題 $count $col2
fill-in:
$col3

EOF
    elif [ ma: = "$col1" ]; then
      cat << EOF >> "$txt_file"
問題 $count $col2
ma:
o:a. $col3
o:b. $col4
x:c. $col5
o:d. $col6
o:e. $col7

EOF
    fi
  done < "$csv_file"
  echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$txt_file は $current_dir に格納されています。\033[0m"
}

if [ -f "$csv_file" ] && [ "$txt_file" ]; then
  quiz_generator
fi
