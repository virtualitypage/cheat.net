#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
input_name="$current_dir/input.csv" # 「開始時刻 - Insert」列の内容をペーストしたファイル
output_name="$current_dir/output.csv" # 「総接続時間」算出のためのSUM関数を出力するファイル
year_month=YYYY/MM # 対象シートの年月を設定

# 表 (MacTableEntry) を参照するための配列
table_name_array=(

)

for i in "${!table_name_array[@]}"; do # 配列の「値」ではなく「インデックス番号」をループに回す
  table_name="${table_name_array[$i]}"
  read -p "タスク: $table_name を実行しますか？[ Y:実行 | N:スキップ | Q:中断 ]: " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo > "$output_name"
    for d in {1..31}; do
      day=$(printf "%02d" "$d")
      start=$(grep -n "$year_month/$day" "$input_name" | sed 's/:.*//g' | awk 'NR == 1')
      end=$(grep -n "$year_month/$day" "$input_name" | sed 's/:.*//g' | awk 'END { print $0 }')
      echo "=SUM('$table_name'::E$start:E$end)" >> "$output_name"
    done
    sed -i '' 's/.*E:E)/0秒/g' "$output_name"
  elif [[ "$response" =~ ^[Nn]$ ]] || [ "$response" = "" ]; then
    echo -e "\033[1;33m処理をスキップします\033[0m"
  elif [[ "$response" =~ ^[Qq]$ ]]; then
    echo -e "\033[1;31m処理を中断しました\033[0m"
    exit 0
  fi
done


# applescriptのコード。実行前に Numbers の「総接続時間」列のセルB2を選択した状態にすること

# -- 読み込むファイルを指定
# set filePath to POSIX file "/Users/yuki/Desktop/output.csv"

# -- ファイルの内容を取得（テキストとして）
# set fileContents to read filePath as «class utf8»

# -- 改行ごとに分割してリスト化
# set lineList to paragraphs of fileContents

# -- 各行を順番にクリップボードへ設定
# repeat with oneLine in lineList
# 	if oneLine is not "" then
# 		set the clipboard to (contents of oneLine)
# 		tell application "Numbers"
# 			activate
# 			tell application "System Events"
# 				--keystroke "a" using {command down}
# 				delay 0.5
# 				keystroke "v" using {command down}
# 				keystroke return
# 			end tell
# 		end tell
# 	end if
# end repeat
