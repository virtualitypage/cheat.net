#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)
today=$(TZ=UTC-9 date '+%Y-%m-%d')

function usage {
  echo "文章を入力(適度に改行)したテキストファイルからhtmlファイルを作るwebサイト'jigokudani.net'用スクリプト"
  echo "入力方法: $this { --diary | --news }(必須オプション) [テキストファイルパス](絶対パス) [YYYY-MM-DD](出力ファイル名)"
  echo -e "\033[1;31m注意:\033[0m" "テキストファイルの一行目は以下のようにすること"
  echo "■YYYY/MM/DD 00:00 タイトル名"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

file_path=$2
main_file=$3

if [[ "$1" == "--diary" ]]; then
  echo -e "\033[1;32mSUCCESE: 指定されたオプション $1 は有効です。\033[0m"
elif [[ "$1" == "--news" ]]; then
  echo -e "\033[1;32mSUCCESE: 指定されたオプション $1 は有効です。\033[0m"
else
  echo -e "\033[1;31mERROR: 指定されたオプション $1 は無効です。\033[0m"
  echo -e "\033[1;31m指定可能なオプションは { --diary | --news } です。\033[0m"
  exit 1
fi

if [[ -z "$2" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスが指定されていません。ファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.txt\033[0m"
  exit 1
elif [[ ! -f "$2" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.txt\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: ファイルパス $file_path は有効です。\033[0m"
fi

first_line=$(head -n 1 "$file_path") # テキストファイルの1行目を読み込む

first_line=${first_line#■} # 先頭の「■」を除く処理

if [[ $first_line =~ ^([0-9]{4}/[0-9]{1,2}/[0-9]{1,2})\ ([0-9]{2}:[0-9]{2})\ (.+)$ ]]; then
  date_parts="${BASH_REMATCH[1]}"
  time_parts="${BASH_REMATCH[2]}"
  title_parts="${BASH_REMATCH[3]}"
  echo -e "\033[1;32mSUCCESE: １行目のフォーマットは正しいです。\033[0m"
else
  echo -e "\033[1;31mERROR: １行目のフォーマットに誤りがあります。正しいフォーマットに直して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: ■YYYY/MM/DD 00:00 タイトル名\033[0m"
  exit 1
fi

if [ -z "$3" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $today\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $main_file です。\033[0m"
fi

function diary () {

dir_name="(diary)"

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
      <li class="list_item" style="font-weight: bold;">$date_parts $time_parts $title_parts</li>
        </ul>
        <br>
        <br>
EOF

tail -n +2 "$file_path" | while IFS= read -r line || [[ -n $line ]];
do
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
      <div class="copy">☆ 2023 jigokudani.net</div>
    </footer>
    <script src="../js/main.js"></script>
  </body>
</html>
EOF

cat << EOF > site-map_diary.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="./diary/${main_file}">${main_file}</a></td>
          </tr>
EOF

cat << EOF > site-map_diary_smile.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="../diary/${main_file}">${main_file}</a></td>
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
echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m${main_file} は ${current_dir}/${main_file}$dir_name に格納されています。\033[0m"
}

function news () {

dir_name="(news)"

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
              <a href="../diary">
                <span>Diary</span>
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

tail -n +2 "$file_path" | while IFS= read -r line || [[ -n $line ]];
do
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
          以上
        </p>
        <br>
      </div>
    </main>
    <footer>
      <div class="copy">☆ 2023 jigokudani.net</div>
    </footer>
    <script src="../js/main.js"></script>
  </body>
</html>
EOF

cat << EOF > site-map_news.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="./news/$main_file">$main_file</a></td>
          </tr>
EOF

cat << EOF > site-map_news_smile.txt
          <tr>
            <td>　　　┃　　┗　<a class="link" draggable="true" href="../news/$main_file">$main_file</a></td>
          </tr>
EOF

cat << EOF >> news_add.txt
      <div class="infoArea">
        <a href="./news/$main_file">
          <div class="box_title">
            <p1 class="p">$date_parts</p1>
          </div>
        </a>
        <a href="./news/$main_file">
          <div class="box">
            $title_parts
          </div>
        </a>
      </div>
EOF
echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir/$main_file$dir_name に格納されています。\033[0m"
}

if [[ "$1" == "--diary" ]]; then
  diary
  shift 1
elif [[ "$1" == "--news" ]]; then
  news
  shift 1
else
  echo -e "\033[1;31mERROR: 指定されたオプション $1 は無効です。\033[0m"
  echo -e "\033[1;31m指定可能なオプションは { --diary | --news } です。\033[0m"
  exit 1
fi