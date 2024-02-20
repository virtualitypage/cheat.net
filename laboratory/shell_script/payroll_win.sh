#!/bin/bash

this=$(basename "$0")

function usage () {
  echo "アルバイト明細の自動計算処理を実行するスクリプト(Windows環境用)"
  echo "入力方法: $this [計算用時給(例：1000)] [計算用労働時間(例：6h30m => 6.5, 6h0m => 6.0)] [労働時間(例：6h30m)] ※月末限定　{`date '+%Y年%m月'sum用.txt`}　{`date '+%Y年%m月'アルバイト明細.txt`}"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

# date=`date '+%m_%d='`
day=$(date +%m月%d日)
# date=`echo -n ${date} | tr _ 月 | tr = 日`

pay=$1
work=$2
time=$3
sumfile=$4
logfile=$5

var=$(echo "scale=0; $pay * $work" | bc | sed s/\.[0-9,]*$//g)

cat << EOF >> $(date '+%Y年%m月'アルバイト明細.txt)
・${day}　${time}　¥$var
EOF

cat << EOF >> $(date '+%Y年%m月'sum.txt)
$var
EOF

function sum () {
t=0
for i in $(cat "$sumfile")
do
  t=$(echo "$t + $i" | bc)
done
echo "" >> "$logfile"
echo 計 ¥"$t" >> "$logfile"

if [ "$t" -gt 88000 ]; then
  echo "注意！月収が88000円を超えました。社会保険加入対象になります。"
fi
}

today=$(date +%d)

if [ "$today" -eq $(date -d "$(date +%Y-%m-01) +1 month -1 day" +%d) ]; then
  echo "テキストへの書き込みが完了しました。"
  echo "月末を検知、$(date '+%Y年%m月'sum用.txt)からデータを抽出して集計処理を完了しました。"
  sum
else
  echo "テキストへの書き込みが完了しました。"
fi
