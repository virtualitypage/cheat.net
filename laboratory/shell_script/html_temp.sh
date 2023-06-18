#!/bin/bash

this=`basename $0`

function usage {
  echo "webサイトのソースコードテンプレートを作成するスクリプト"
  echo "$this [htmlファイル名] [親ディレクトリ名] [cssファイル名] [jsファイル名]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

mkdir $2
cd $2
mkdir css js
touch css/$3.css js/$4.js $1.html

# >> でファイルの元の内容は残り，その後に新しい内容が追加される。 > でファイルの元の内容は失われ，新しい内容に書き換えられる

cat <<EOF >> $1.html
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="./css/$3.css">
    <title>$1</title>
  </head>
  <body>
    <main class="main-contents">
      <script src="./$4.js"></script>
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

cd css

cat <<EOF > $3.css
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
