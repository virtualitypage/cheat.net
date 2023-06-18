#!/bin/bash

this=`basename $0`

function usage {
  echo "csvファイルからデータを抽出してタグに代入する、webサイト'jigokudani.net'編集用スクリプト"
  echo "入力方法: $this [csvファイルパス] [出力ファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ ! -f "$1" ]]; then
  echo "error! This is not a file path."
  echo "example: /xxx/xxx/xxx.csv"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "error! no output file name specified."
  exit 1
fi

CSV_FILE="$1"

while IFS=, read -r col1 col2 || [[ -n $col1 ]];
do
# col1, col2 は CSV ファイルの列のヘッダーまたはデータ
cat <<EOF >> $2.txt
                <div class="bundle2">
                  <dt>$col2</dt>
                  <dd>$col1</dd>
                </div>
EOF
done < "$CSV_FILE"

echo "operation completed."