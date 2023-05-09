#!/bin/bash

change=false

this=`basename $0`

function usage {
  echo "csvファイルからデータを抽出する、テキストで問題を作るwebサイト'https://quizgenerator.net'用スクリプト"
  echo "入力方法: $this {-t}(-tで出題順のランダム化) [csvファイルパス] [ cisco | lpic | aws ](出力ファイル名)"
  echo "csvファイル1列目に[ 択一問題 | fill-in: | ma: ]のいずれか一つを入力する"
  echo "csvファイル2列目に問題文、3列目以降に選択肢を入力"
  echo "択一問題の場合、「択一問題」を1列目、正解の答えを3列目に入力する"
  echo "記述問題の場合、「fill-in:」を1列目、答えを3列目に入力する"
  echo "選択問題の場合、「ma:」を1列目、3列目以降に選択肢を入力する"
  echo "また、テキストファイル生成後、正解の選択肢はo、不正解の選択肢はxに書き換える"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

function shuffle_questions_true() {
  change=true
}

if [[ “${1:0:1}” == “-” ]]; then
  shuffle_questions_true
  shift 1
fi

CSV_FILE=$1

cat <<EOF > $2.txt
#title:$2
#movable:true
#shuffle_questions:$change
EOF

count=0

while IFS=, read -r col1 col2 col3 col4 col5 col6 col7
do

count=`echo "$count+1" | bc`

if [ 択一問題 = $col1 ]; then
cat <<EOF >> $2.txt
問題 $count $col2
択一問題
a. $col3
b. $col4
c. $col5
d. $col6
e. $col7

EOF
elif [ fill-in: = $col1 ]; then
cat <<EOF >> $2.txt
問題 $count $col2
fill-in:
$col3

EOF
elif [ ma: = $col1 ]; then
cat <<EOF >> $2.txt
問題 $count $col2
ma:
o:a. $col3
o:b. $col4
x:c. $col5
o:d. $col6
o:e. $col7

EOF
echo "一連の処理が完了しました"
fi
done < "$CSV_FILE"
