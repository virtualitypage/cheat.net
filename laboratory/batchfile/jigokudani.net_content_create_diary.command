#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y-%-m-%-d')

year=$(date +%Y)
target_string=$year

MM=$(date +%-m)
dd=$(date +%-d)

file_path=$(find "$current_dir" -maxdepth 1 -type f -name "*${target_string}*" -print -quit)
sub_file=$(basename "$file_path")

first_line=$(head -n 1 "$file_path" 2>/dev/null) # テキストファイルの1行目を読み込む
first_line=${first_line#■}                       # 先頭の「■」を除く処理

year=${first_line:0:4} # 年(YYYY)と日付を抽出してフォーマットを変換
date_with_time=${first_line:5}
date=${date_with_time%% *} # 時刻以降の部分を削除
date=${date//\//-}

first_line2="${year}-${date}"

main_file=$first_line2

function create_text () {
  cat << EOF > "$current_dir"/"$today".txt
■$target_string/$MM/$dd 00:00 タイトル名
本文(改行のみで空行を作らないこと)
EOF
}

if [ -e "$file_path" ]; then
  echo -e "\033[1;32mSUCCESS: $sub_file は有効です。\033[0m"
elif [ ! -e "$file_path" ]; then
  echo -e "\033[1;31mERROR: $target_string を含むファイルが存在しません。対象のファイルを $current_dir に生成します。\033[0m"
  create_text
  echo
  exit 1
fi

if [[ $first_line =~ ^([0-9]{4}/[0-9]{1,2}/[0-9]{1,2})\ ([0-9]{1,2}:[0-9]{1,2})\ (.+)$ ]]; then
  date_parts="${BASH_REMATCH[1]}"
  time_parts="${BASH_REMATCH[2]}"
  title_parts="${BASH_REMATCH[3]}"
  echo -e "\033[1;32mSUCCESS: $sub_file の１行目のフォーマットは正しいです。これを基に出力ファイル名を指定します。\033[0m"
else
  echo -e "\033[1;31mERROR: $sub_file の１行目のフォーマットに誤りがあります。正しいフォーマットに直して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: ■YYYY/MM/DD 00:00 タイトル名\033[0m"
  exit 1
fi

function diary () {

  dir_name="(diary)"

  cd "$current_dir" || exit
  mkdir "$main_file"$dir_name
  cd "$main_file"$dir_name || exit

  cat << EOF >> "$main_file".html
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>$main_file</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/diary.css">
    <link rel="stylesheet" type="text/css" href="../css/reset.css">
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-F00MC1WG8L"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-F00MC1WG8L');
    </script>
  </head>
  <header class="site-header">
    <div class="site-header__wrapper">
      <div class="site-header__start">
        <a href=""><img class="logo" src="../img/jigokudani.jpg" alt="地獄谷"></a>
      </div>
      <div class="site-header__middle">
        <nav class="nav">
          <button class="nav__toggle" aria-expanded="false" type="button" aria-haspopup="true" aria-label="menu">
            menu
          </button>
          <ul class="nav__wrapper">
            <li class="nav__item">
              <a href="../index">
                <span>Home</span>
              </a>
            </li>
            <li class="nav__item">
              <a href="../about">
                <span>About</span>
              </a>
            </li>
            <li class="nav__item">
              <a href="../site-map">
                <span>Site map</span>
              </a>
            </li>
            <li class="nav__item">
              <a href="../news">
                <span>News</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </header>
  <body>
    <main class="main-contents">
      <div class="infoArea">
        <ul class="unordered_list">
          <li class="list_item" style="font-weight: bold;">■$date_parts $time_parts $title_parts</li>
        </ul>
        <br>
        <br>
EOF

  export LANG="en_US.UTF-8" # LANG 環境変数を設定して日本語ファイル名をサポート

  tail -n +2 "$file_path" | while IFS= read -r line || [[ -n $line ]]; do
    if [[ $line == "$first_line" ]]; then
      line="\"$line\""
    fi
    cat << EOF >> "$main_file".html
        <p>
          $line
        </p>
        <br>
EOF
  done

  cat << EOF >> "$main_file".html
        <br>
        <br>
        <p>
          END
        </p>
        <br>
      </div>
    </main>
    <footer>
      <div class="copy">💀 2024 Hell Valley</div>
    </footer>
    <script src="../js/main.js"></script>
  </body>
</html>
EOF

  cat << EOF > site-map_diary.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="./diary/$main_file">$main_file</a></td>
          </tr>
EOF

  cat << EOF > site-map_diary_smile.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="../diary/$main_file">$main_file</a></td>
          </tr>
EOF

  cat << EOF > diary_add.txt
      <div class="infoArea">
        <a href="./diary/$main_file">
          <div class="box_title">
            <p1 class="p">$date_parts</p1>
          </div>
        </a>
        <a href="./diary/$main_file">
          <div class="box">
            $title_parts
          </div>
        </a>
      </div>
EOF
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir/$main_file$dir_name に格納されています。\033[0m"
  echo
}

if [ "$main_file" ] && [ "$sub_file" ]; then
  diary
fi
