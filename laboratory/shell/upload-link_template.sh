#!/bin/bash

this=`basename $0`

function usage {
  echo "csvファイルからデータを抽出してタグに代入する、プライベートwebサイト'upload-link'編集用スクリプト"
  echo "入力方法: $this [csvファイルパス] [ youtube | tiktok | twitter ](出力ファイル名)"
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
  echo "example: youtube | tiktok | twitter"
  exit 1
fi

CSV_FILE="$1"

while IFS=, read -r col1 col2
do
# col1, col2 は CSV ファイルの列のヘッダーまたはデータ
cat <<EOF >> $2.txt
          <tr>
            <th class="number" scope="row"></th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "$CSV_FILE"

echo "operation completed."
