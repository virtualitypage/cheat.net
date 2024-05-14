#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y/%m/%d' | sed 's/\/0/\//g')
dir="$current_dir/Hell Valley - menu list"
array_csv="$dir/array.csv"

array=()
while IFS= read -r -d '' csv; do
  array+=("$csv")
done < <(find "$dir" -type f -name "*.csv" -print0)

function modified_date () {
  admin_console="$dir/admin_console.html"
  rm "$dir/._*" 2>/dev/null
  first_string=true
  if $first_string; then
    code=$(
      cat << EOF
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>Admin Console</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/admin_console.css">
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-F00MC1WG8L"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-F00MC1WG8L');
    </script>
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8733534635553152" crossorigin="anonymous"></script>
  </head>
  <body>
    <header class="head">
      <div class="head_wrap">
        <a href="">
          <img class="logo" src="../img/jigokudani.webp" alt="地獄谷">
        </a>
        <nav class="global-nav">
          <button class="nav_toggle-menu" type="button">
            menu
          </button>
          <ul class="nav_wrap">
            <li class="nav_menu">
              <a href="../index">
                <span class="nav_text">Home</span>
              </a>
            </li>
            <li class="nav_menu">
              <a href="../about">
                <span class="nav_text">About</span>
              </a>
            </li>
            <li class="nav_menu">
              <a href="../site-map">
                <span class="nav_text">Site map</span>
              </a>
            </li>
            <li class="nav_menu">
              <a href="../release_note">
                <span class="nav_text">Release</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </header>
    <main>
      <script src="../js/main.js"></script>
      <div class="margin-0 outerMargin-top makeScrollable outerMargin md:outerMargin overscroll-contain bgColor-opacity">
        <div class="mx-auto">
          <div class="container mx-auto sm:tableMargin textColor">
            <h2 class="title-while titleSize fontSemibold">Admin Console</h2>
            <div class="makeScrollable">
              <table class="table-minWidth100 table-textSize">
                <colgroup>
                  <col>
                  <col>
                  <col>
                </colgroup>
                <thead class="thead-bgColor">
                  <tr class="tr-textLeft">
                    <th class="cellSize">No.</th>
                    <th class="cellSize">STORE_NAME</th>
                    <th class="cellSize">MODIFIED</th>
                  </tr>
                </thead>
                <tbody>
EOF
    )
    first_string=false
    echo "$code" >> "$admin_console"
  fi
  for csv_file in "${array[@]}"; do # 配列の要素を一つずつ処理
    sed -e '3,$d' -e 's/,,//g' -e 's/,TRUE//g' -e 's/,,TRUE//g' "$csv_file" > "$array_csv.tmp"
    tr '\n' ',' < "$array_csv.tmp" > "$array_csv"
    tr -d '\r\n' < "$array_csv" > "$array_csv.tmp"
    csv_name=$(basename "$csv_file")
    store_file=$(echo "$csv_name" | sed 's/[0-9]*//g' | sed 's/_//g' | sed 's/^[^-]*-//') # csvファイル名の行頭からハイフンまでの文字列を削除
    echo "$store_file"
    while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
      counts=$(echo "$csv_name" | sed 's/^[^-]*-//' | sed 's/[^0-9_]//g' | sed 's/_.*//g')
      store_name=$(echo "$csv_name" | sed 's/.csv//g' | sed 's/[0-9]*//g' | sed 's/_//g' | sed 's/^[^-]*-//')
      if [[ $store_name =~ "キッチン" ]]; then
        store_name="キッチン725"
      fi
      col2=$(echo "$col2" | sed 's/modified: //g')
      code=$(
        cat << EOF
                  <tr class="borderLine borderColor bgColor">
                    <td class="cellSize">
                      <p class="number">$counts</p>
                    </td>
                    <td class="cellSize">
                      <a class="link" href="$col1">
                        <p>$store_name</p>
                      </a>
                    </td>
                    <td class="cellSize">
                      <span class="fontSemibold roundedCorner status statusBatch statusBatch-Enable">
                        <span class="statusBatch-textColor">$col2</span>
                      </span>
                    </td>
                  </tr>
EOF
      )
      echo "$code" >> "$admin_console"
    done < "$array_csv.tmp"
    sed -i '' '1,2d' "$csv_file"
  done
  code=$(
    cat << EOF
                </tbody>
              </table>
              <br>
            </div>
          </div>
        </div>
      </div>
      <footer>
        <div class="foot">💀 2024 Hell Valley</div>
      </footer>
    </main>
  </body>
</html>
EOF
  )
  echo "$code" >> "$admin_console"
  rm "$array_csv" "$array_csv.tmp"
}
modified_date

function modified_menuList () {
  main_file="$current_dir/menu.html"
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
}

if [ "$dir" ]; then
  modified_date
  modified_menuList
fi