#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

csv_file=$1
dir_name=$2
css_name=$3
js_name=$4
back_link=$5
dlc_name=$6

function usage () {
  echo "csvファイルからデータを抽出してタグに代入する、プライベートwebサイト'exam'編集用スクリプト(MacOS環境対応)"
  echo "入力方法: $this [csvファイルパス] [出力ファイル名] [cssファイル名] [jsファイル名] [バックリンク] [dlファイル名]"
  echo -e "\033[1;31m注意:\033[0m" "exam_template_assist.sh で生成したcsvファイルを使うこと"
  echo "実行環境が WSL の場合、csv ファイルパスを /home/XXX.csv の形にする"
  exit 1
}

function exam_templates () {
  mkdir "$dir_name"
  cd "$dir_name" || exit
  mkdir css js
  touch css/"$css_name.css" "js/$js_name.js"

  cat << EOF >> "$dir_name.txt"
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>$dir_name</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/$css_name.css">
  </head>
  <body class="body">
    <header>
      <script src="/js/$js_name.js"></script>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
      <h3 class="heading"><a href="./$back_link"></a></h3>
      <nav>
        <ul>
          <li><a href="/pdf/$dlc_name.pdf" download="$dlc_name.pdf" class="pdf-alert">PDF</a></li>
          <li><a href="/zip/$dlc_name.zip" download="$dlc_name.zip" class="test-alert">問題集</a></li>
        </ul>
      </nav>
    </header>
EOF

  # カウント変数(while 文の外側に配置)
  count=0

  # col1, col2 は csv ファイルの列のヘッダーまたはデータ
  while IFS=, read -r col1 col2 col3 col4 col5 col6 _ || [[ -n $col1 ]]; do
    count=$(echo "$count+1" | bc)
    if [ -n "$col3" ]; then # 変数 $col3 の値が 0 でない場合
      cat << EOF >> "$dir_name.txt"
      <p><b>問題 $count $col1:</b></p>
      <page>
        <a>a. $col2</a>
        <a>b. $col3</a>
        <a>c. $col4</a>
        <a>d. $col5</a>
        <a>e. $col6</a>
      </page>
      <div class="button">
        <input type="button" class="btn btn-info btn-sm" value=" 正解を表示 " onclick="changeColor('target');" />
      </div>
EOF
    else # 変数 $col3 の値が 0 である場合
      cat << EOF >> "$dir_name.txt"
    <p><b>問題 $count $col1</b></p>
    <clear>
      <a id="target">$col2</a>
    </clear>
    <div class="button">
      <input type="button" class="btn btn-info btn-sm" value=" 正解を表示 " onclick="changeColor('target');" />
    </div>
EOF
    fi
  done < "$csv_file"

  # 終了ステータスが 0 の場合に処理を開始する(csv ファイルの最終行に到達)
  if [ $? -eq 0 ]; then
    cat << EOF >> "$dir_name.txt"
  <br>
  <footer>
    <p><b>$dir_name finished</b></p>
  </footer>
  </body>
</html>

<style>
p {
  margin-left: 23px;
  margin-top: 15px;
  margin-bottom: 1px;
}
</style>
EOF
  fi

  cat << EOF >> "css/$css_name.css"
/* ブラウザがそれぞれ持っているCSSをリセットするための記述 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  color: #000000;
}

.body {
  height: 100%;
  margin: 0;
  padding: 0;
  color: #1a1a1a;
  font-family: 'Noto Sans JP', sans-serif;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: baseline; /* bootstrapアンチ */
  width: auto;
  height: 55px;
  padding: 0.5rem 2rem;
  background: #0fc9f7;
  /* background: linear-gradient(45deg, #272d34 0%, #606678 50%, #8c959d 100%); */
}

a {
  text-decoration: none;
}

/* header {
  width: 90%; /* 横幅90% */
} */

header .heading { /* headerタグ内のheadingクラスにのみ反映される */
  font-size: 32px;
}

h3 a {
  color: #00ff00;
  font-weight: bold;
  font-size: 20px;
  text-decoration: none;
}

ul {
  display: flex;
  list-style: none;
}

ul li a {
  margin-top: 10px;
  margin-bottom: 5px;
  padding: 10px 15px;
  color: #1a1a1a;
  text-decoration: none;
  font-size: 20px;
  font-weight: bold;
}

ul li a:hover {
  text-decoration: underline;
}

page {
  margin-top: 15px;
  margin-bottom: 1px;
  margin-left: 15px;
  text-align: center;
  white-space: break-spaces; /*レスポンシブ対応*/
  content: "\A" ;
}

.button {
  margin-left: 23px;
  padding-bottom: 1px;
}

footer {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  position: relative;
  bottom: 0;
  width: 100%;
  height: 50px;
  padding: 0.5rem 2rem;
  background: #0fc9f7;
  /* background: linear-gradient(45deg, #272d34 0%, #606678 50%, #8c959d 100%); */
}
EOF

  for i in {1..600}; do
    js_code+="
function changeColor$i(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold';
}"
  done

  cat << EOF >> "js/$js_name.js"
$js_code

//PDFダウンロード時のアラート
function pdf_alert() {
	var a_pdf = document.getElementsByClassName( 'pdf-alert' );
	for ( var i = 0; i < a_pdf.length; i++ ) {
		a_pdf[i].onclick = function() {
			if ( window.confirm( 'PDFファイルをダウンロードします。\n問題集と併せてご利用下さい。\nよろしいですか？' ) ) {
				return true;
			} else {
				return false;
			}
		}
	}
}
function addEventSet( element, listener, fn ) {
	try {
		element.addEventListener( listener, fn, false );
	} catch( e ) {
		element.attachEvent( 'on' + listener, fn );
	}
}
addEventSet( window, 'load', function() {
	pdf_alert();
});

//問題集ダウンロード時のアラート
function test_alert() {
	var a_pdf = document.getElementsByClassName( 'test-alert' );
	for ( var i = 0; i < a_pdf.length; i++ ) {
		a_pdf[i].onclick = function() {
			if ( window.confirm( '問題集をダウンロードします。\nこの問題集を網羅した暁には、資格試験合格という輝かしい未来が待っています。よろしいですか？\n\n使い方は以下の通り\nフォルダ内の"index.html"を開き、攻略開始をクリック。' ) ) {
				return true;
			} else {
				return false;
			}
		}
	}
}
function addEventSet( element, listener, fn ) {
	try {
		element.addEventListener( listener, fn, false );
	} catch( e ) {
		element.attachEvent( 'on' + listener, fn );
	}
}
addEventSet( window, 'load', function() {
	test_alert();
});
EOF
  echo -e "\033[1;32mALL SUCCESEFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$dir_name は $current_dir/$dir_name に格納されています。\033[0m"
}

if [ -z "$1" ]; then
  usage
fi

if [ ! -f "$1" ]; then
  echo -e "\033[1;31mERROR: csv ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.csv\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: csv ファイルパス $csv_file は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: { cisco | lpic | aws }\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $dir_name です。\033[0m"
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

if [ -z "$5" ]; then
  echo -e "\033[1;31mERROR: バックリンクが指定されていません。トップページのファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: index\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: バックリンクは $back_link です。\033[0m"
fi

if [ -z "$6" ]; then
  echo -e "\033[1;31mERROR: dl ファイル名が指定されていません。ダウンロード用のファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: dl ファイル名は $dlc_name です。\033[0m"
fi

if [ -f "$csv_file" ] && [ "$dir_name" ] && [ "$css_name" ] && [ "$js_name" ] && [ "$back_link" ] && [ "$dlc_name" ]; then
  exam_template
fi
