#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="$current_dir/XXXXX_code.txt"
sub_file="$current_dir/create_about-page.csv"

function create_csv () {
  echo "title,img" >> "$sub_file"
  echo "info" >> "$sub_file"
  echo "food" >> "$sub_file"
  echo "drink" >> "$sub_file"
  echo "site_name" >> "$sub_file"
  for ((i = 1; i <= 20; i++)); do
    for ((j = 1; j <= 4; j++)); do
      echo -n "," >> "$sub_file"
    done
    echo -e "\n" >> "$sub_file"
  done
}

function handle_error () {
  echo -e "\033[1;31mERROR: csvの一列目または二列目にオプションが指定されていません。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "※csvの一列目にはオプション(title/img/info/food/drink/site_name)を入力します。"
  echo
  echo "title,img,タイトル,画像のファイルパス,画像の名前"
  echo "info,住所,電話番号,営業時間,定休日,予約可否"
  echo "food,品名,100円"
  echo "food,品名,200円"
  echo "drink,品名,100円"
  echo "drink,品名,200円"
  echo "site_name,サイト名"
  echo
  echo "処理を終了します。"
  echo
}

function create_about_page () {

  title="title"
  img="img"

  while IFS=, read -r col1 col2 col3 col4 col5 || [[ -n $col5 ]]; do
    if [ "$col1" = "$title" ] && [ "$col2" = "$img" ]; then
      cat << EOF >> "$main_file"
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>$col3</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/about.css">
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
        <a href=""><img class="logo" src="$col4" alt="$col5"></a>
      </div>
      <div class="site-header__middle">
        <nav class="nav">
          <button class="nav__toggle" aria-expanded="false" type="button" aria-haspopup="true" aria-label="menu">
            menu
          </button>
          <ul class="nav__wrapper">
            <li class="nav__item">
              <a href="../index">
                <span2>Home</span2>
              </a>
            </li>
            <li class="nav__item">
              <a href="../about">
                <span2>About</span2>
              </a>
            </li>
            <li class="nav__item">
              <a href="../site-map">
                <span2>Site map</span2>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </header>
  <body>
    <main>
      <script src="../js/main.js"></script>
      <div class="img">
        <img src="$col4" alt="$col5">
      </div>
      <div class="info">
        <p style="text-decoration: underline;">$col3</p>
        <div class="info-block block" id="information">
          <div class="information">
            <div class="info-title">
              <p class="en">Information</p>
              <p class="ja">施設情報</p>
            </div>
EOF
    # else
    #   handle_error
    fi
  done < "$sub_file"

  info="info"

  while IFS=, read -r col1 col2 col3 col4 col5 col6 || [[ -n $col6 ]]; do
    if [ "$col1" = "$info" ]; then
      cat << EOF >> "$main_file"
            <div class="information-data">
              <div class="head"></div>
              <dl class="data-list">
                <div class="bundle">
                  <dt>住所</dt>
                  <dd>
                    <span class="txt">$col2</span>
                  </dd>
                </div>
                <div class="bundle">
                  <dt>電話番号</dt>
                  <dd>
                    <span class="txt">$col3</span>
                  </dd>
                </div>
                <div class="bundle">
                  <dt>営業時間</dt>
                  <dd>
                    <span class="txt">$col4</span>
                  </dd>
                </div>
                <div class="bundle">
                  <dt>定休日</dt>
                  <dd>
                    <span class="txt">$col5</span>
                  </dd>
                </div>
                <div class="bundle">
                  <dt>予約可否</dt>
                  <dd>
                    <span class="txt">$col6</span>
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
              <div class="head">フード</div>
              <dl class="data-list">
EOF
    # else
    #   handle_error
    fi
  done < "$sub_file"

  menu="food"

  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    if [ "$col1" = "$menu" ]; then
      cat << EOF >> "$main_file"
                <div class="bundle2">
                  <dt>$col3</dt>
                  <dd>$col2</dd>
                </div>
EOF
    fi
  done < "$sub_file"

  cat << EOF >> "$main_file"
              </dl>
              <br>
              <br>
              <div class="head">ドリンク</div>
              <dl class="data-list">
EOF

  drink="drink"

  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    if [ "$col1" = "$drink" ]; then
      cat << EOF >> "$main_file"
                <div class="bundle2">
                  <dt>$col3</dt>
                  <dd>$col2</dd>
                </div>
EOF
    # else
    #   handle_error
    fi
  done < "$sub_file"

  site_name="site_name"

  while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
    if [ "$col1" = "$site_name" ]; then
      cat << EOF >> "$main_file"
              </dl>
              <br>
              <br>
            </div>
          </div>
          <footer>
            <div class="copy">☆ 2024 $col2</div>
          </footer>
        </div>
      </div>
    </main>
  </body>
</html>
EOF
    # else
    #   handle_error
    fi
  done < "$sub_file"
}

if [ -f "$sub_file" ]; then
  create_about_page
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
elif [ ! -f "$sub_file" ]; then
  create_csv
  echo -e "\033[1;31mERROR: 読込用csvがありません。対象のファイルを $current_dir に生成します。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "※csvの一列目にはオプション(title/img/info/food/drink/site_name)を入力します。"
  echo
  echo "title,img,タイトル,画像のファイルパス,画像の名前"
  echo "info,住所,電話番号,営業時間,定休日,予約可否"
  echo "food,品名,100円"
  echo "food,品名,200円"
  echo "drink,品名,100円"
  echo "drink,品名,200円"
  echo "site_name,サイト名"
  echo
  exit 1
else
  echo
fi
