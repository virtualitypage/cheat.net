#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

html_file=$1
dir_name=$2
css_name=$3
js_name=$4

function usage {
  echo "webサイトのソースコードテンプレートを作成するスクリプト"
  echo "$this [htmlファイル名] [親ディレクトリ名] [cssファイル名] [jsファイル名]"
  exit 1
}

mkdir "$dir_name"
cd "$dir_name" || exit
mkdir css js
touch "css/$css_name".css "js/$js_name.js" "$html_file.html"

# >> でファイルの元の内容は残り，その後に新しい内容が追加される。 > でファイルの元の内容は失われ，新しい内容に書き換えられる

cat << EOF >> "$html_file.html"
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="./css/$css_name.css">
    <title>$html_file</title>
  </head>
  <body>
    <main class="main-contents">
      <script src="./$js_name.js"></script>
      <div class="infoArea">
        <h2></h2>
        <p></p>
      </div>
      <div class="main">

      </div>
    </main>
    <footer>
      <p class="copy"></p>
    </footer>
  </body>
</html>
EOF

cd css || exit

cat << EOF > "$css_name.css"
h2 {
  border-bottom: 3px solid #aaa;
  color: #aaa;
}
main {
  display: block;
}
p {
  line-height: 1.75;
  margin-top: 20px;
  font-size: 13px;
  text-align: center;
}
footer {
  padding: 8px 0 30px;
  text-align: center;
}
footer .copy {
  color: #fff;
  font-family: 'Epilogue', sans-serif;
  font-size: 14px;
}
EOF

echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$html_file.html は $current_dir/$dir_name に格納されています。\033[0m"

if [ -z "$1" ]; then
  usage
fi

if [ $# -lt 1 ]; then
  echo -e "\033[1;31mERROR: html ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: htmlファイル名は $html_file です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 親ディレクトリ名が指定されていません。ディレクトリ名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 親ディレクトリ名は $dir_name です。\033[0m"
fi

if [ -z "$3" ]; then
  echo -e "\033[1;31mERROR: css ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: css ファイル名は $css_name です。\033[0m"
fi

if [ -z "$4" ]; then
  echo -e "\033[1;31mERROR: js ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: js ファイル名は $js_name です。\033[0m"
fi
