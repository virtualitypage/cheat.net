#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
FILE="アルバイト明細_読込用.txt"

function create_config () {
cat << EOF > ${current_dir}/${FILE}
date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=


date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=

date=
pay=
time=
time_hm=
EOF
}

source "${current_dir}/${FILE}"

month=`date +%m月`
OUT_FILE="アルバイト明細.txt"

function processPayroll () {
result=$(echo "scale=0; $pay * $time" | bc)
cat << EOF >> "${current_dir}/${month} ${OUT_FILE}.txt"
・$date
  時給: $pay
  時間: $time_hm
  ¥$result

EOF
}

while IFS= read -r line; do
  if [[ $line == "date="* ]]; then
    date=${line#date=}
  elif [[ $line == "pay="* ]]; then
    pay=${line#pay=}
  elif [[ $line == "time="* ]]; then
    time=${line#time=}
  elif [[ $line == "time_hm="* ]]; then
    time_hm=${line#time_hm=}
  elif [[ $line == "" ]]; then
    # 空行の場合、処理を実行して次のセットの変数をリセットする
    processPayroll
    date=
    pay=
    time=
    time_hm=
  fi
done < "${current_dir}/${FILE}"

if [ -f "${current_dir}/${FILE}" ]; then
  if [[ -z $date || -z $pay || -z $time || -z $time_hm ]]; then
    echo "変数の代入が必要な項目が存在しません。設定ファイルを修正してください。"
    echo "不適切な行を除いて処理を終了しました。"
    echo ""
    echo "これ以上記入する必要がない場合は適切に行を削除してください。"
    echo "行を削除して再度実行した時、以下のエラーが出た場合はファイルを再度作成することをおすすめします。"
    echo ""
    echo "  (standard_in) 1: illegal character:"
    echo ""
    exit 1
  fi
elif [ -f "${current_dir}/${FILE}" ]; then
  processPayroll
  echo "計算が完了しました。ファイルは$(cd $(dirname $0) && pwd)に保存されています。"
elif [ ! -f "${current_dir}/${FILE}" ]; then
  create_config
  echo "読込用ファイルがありません。$(cd $(dirname $0) && pwd)に${FILE}を作成しました。"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "注意: =との間に空白を空けず、=に続けて文字や数値を入れること"
  echo ""
  echo "date=     出勤当日の日時(例: mm月dd日)"
  echo "pay=      時給(例: 1000円)"
  echo "time=     労働時間(例: 6時間の場合6、6時間半の場合は6.5)"
  echo "time_hm=  労働時間に単位を追加(例: 6h 又は 6h5m)"
  echo ""
  exit 1
fi

function computeMonthSum () {
  total_result=0
  while IFS= read -r line; do
    line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')  # 行の先頭と末尾の空白を削除
    if [[ $line == "¥"* ]]; then
      value=${line#"¥"}
      total_result=$((total_result + value))
    fi
  done < "${current_dir}/${month} ${OUT_FILE}.txt"
  echo "合計額 ¥$total_result" >> "${current_dir}/${month} ${OUT_FILE}.txt"
}

day29="29日"
day30="30日"
day31="31日"

if [[ $date =~ $day29 || $date =~ $day30 || $date =~ $day31 ]]; then
  echo ""
  echo "月末を検知、集計処理を完了しました。"
  computeMonthSum
else
  echo ""
fi