#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y/%m/%d' | sed 's/\/0/\//g')
main_file="$current_dir/menu.html"
dir="$current_dir/Hell Valley - menu list"

array=()
while IFS= read -r -d '' csv; do
  array+=("$csv")
done < <(find "$dir" -type f -name "*.csv" -print0)

for csv_file in "${array[@]}"; do # 配列の要素を一つずつ処理
  sed -e 's/,TRUE//g' -e 's/,,TRUE//g' "$csv_file" > "$current_dir/array.csv"
  # sed -i '' 's/,,//g' "$csv_file"
  csv_name=$(basename "$csv_file")
  mv "$current_dir/array.csv" "$csv_name"
  csv_name=$(echo "$csv_name" | sed 's/^[^-]*-//') # csvファイル名の行頭からハイフンまでの文字列を削除
  echo "$csv_name"
  echo "$csv_name" >> "$main_file"
  first_string=true
  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    col3=$(echo "$col3" | tr -d '\r')
    if [ "$col3" = "FALSE" ]; then # FALSEの場合、指定の行を削除する
      sed -i '' '/FALSE/ d' "$csv_file"
      continue
    fi
    if [ "$col1" ] && [ -z "$col2" ]; then
      if $first_string; then
        col1=$(echo "$col1" | tr -d '\r')
        code=$(
          cat << EOF
                <div class="bundle">
                  <dt>更新日</dt>
                  <dd>
                    <span class="modified">$today</span>
                  </dd>
                </div>
              </dl>
            </div>
          </div>
        </div>
        <div class="info-block block">
          <div class="information">
            <div class="menu-title">
              <p class="en">Menu list</p>
              <p class="ja">メニュー情報</p>
            </div>
            <div class="information-data">
              <div class="column">$col1</div>
              <dl class="data-list">
EOF
        )
        first_string=false
        echo "$code" >> "$main_file"
      else
        col1=$(echo "$col1" | tr -d '\r')
        code=$(
          cat << EOF
              </dl>
              <br>
              <br>
              <div class="column">$col1</div>
              <dl class="data-list">
EOF
        )
        echo "$code" >> "$main_file"
      fi
    else
      col2=$(echo "$col2" | tr -d '\r' | sed 's/-//g')
      code=$(
        cat << EOF
                <div class="bundle2">
                  <dt>$col2</dt>
                  <dd>$col1</dd>
                </div>
EOF
      )
      echo "$code" >> "$main_file"
    fi
  done < "$csv_file"
  echo "--------------------" >> "$main_file"
  # sed -e 's/<\/dt>//g' -e 's/円/円<\/dt>/g' -e 's/円<\/dt>〜/円〜<\/dt>/g' "$main_file" > "$main_file".tmp
  # mv "$main_file".tmp "$main_file"
done
