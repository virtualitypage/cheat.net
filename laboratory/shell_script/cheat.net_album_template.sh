#!/bin/bash

this=`basename $0`

function usage {
  echo "csvファイルからデータを抽出してタグに代入する、プライベートwebサイト'cheat.net'のアルバム編集用スクリプト"
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

while IFS=, read -r col1 || [[ -n $col1 ]];
do
# col1 は CSV ファイルの列のヘッダーまたはデータ
cat <<EOF >> $2.txt
        <div class="post-card-list-item post-card">
          <div class="post-card-image2">
            <a href="./img/$col1.JPG"><img width="343" height="254" src="./img/$col1.JPG" alt="$col1.JPG" srcset="./img/$col1.JPG 343w, ./img/$col1.JPG 640w, ./img/$col1.JPG 202w" sizes="(max-width: 343px) 100vw, 343px" /></a>
            <p class="st-catgroup itiran-category">
              <a download="./img/$col1.JPG"></a>
            </p>
          </div>
          <div class="post-card-body">
            <div class="post-card-text">
              <h3 class="post-card-title">
                <a href="./dlc/$col1.HEIC" download="$col1.HEIC">$col1.HEIC</a>
              </h3>
            </div>
          </div>
        </div>
EOF
done < "$CSV_FILE"

echo "operation completed."