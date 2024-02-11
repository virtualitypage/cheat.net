#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
main_file="exam.html"
sub_file="$current_dir/問題集_読込用.txt"
mid_file="$current_dir/問題集.csv"

dir_name="dir"
css_name="css"
js_name="js"
back_link="back"
dlc_name="dlc"
multiple="multiple"
writing="writing"

function create_txt () {
  echo -n > "$sub_file"
  chmod 755 "$sub_file"
}

function txt_error () {
  echo -e "\033[1;31mERROR: 変換処理に失敗しました。\033[0m"
  echo -e "\033[1;31m$sub_file にデータが無いため、読み込むことができません。\033[0m"
  exit 1
}

# function handle_error () {
#   echo "csvの一列目または二列目にオプションが指定されていません。"
#   echo "以下の入力方法に従って、必要なものを記入してください。"
#   echo "※csvの一列目にはオプションを入力します。"
#   echo
#   echo "dir  -> ディレクトリ・タイトル名"
#   echo "css  -> cssファイル名"
#   echo "js   -> jsファイル名"
#   echo "back -> バックリンク"
#   echo "dlc  -> ダウンロードファイルパス"
#   echo
#   echo "以下の2つは問題の種類ごとに選択する。(複数回使用可)"
#   echo "multiple -> 選択問題(複数問題)"
#   echo "writing  -> 記述問題"
#   echo
#   echo "dir -> ディレクトリ・タイトル名(最終行に必ず入れる)"
#   echo
#   echo "処理を終了します。"
#   echo
#   exit 0
# }

function convert_to_csv () {
  while IFS= read -r line || [[ -n $line ]]; do
    trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if [ -z "$trimmed_line" ]; then
      echo >> "$mid_file"
    else
      echo -n "$trimmed_line," >> "$mid_file"
    fi
  done < "$sub_file"
  echo -e "\033[1;32m$mid_file は $current_dir に格納されています。\033[0m"
}

function create_dir () {
  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 _ || [[ -n $col10 ]]; do
    if [ "$col1" = "$dir_name" ] && [ "$col3" = "$css_name" ] && [ "$col5" = "$js_name" ] && [ "$col7" = "$back_link" ] && [ "$col9" = "$dlc_name" ]; then
      mkdir -p "$current_dir"/"$col2"
      cd "$current_dir"/"$col2" || exit
      mkdir css js
      cat << EOF >> "$main_file"
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>$col2</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/$col4.css">
  </head>
  <body class="body">
    <header>
      <script src="/js/$col6.js"></script>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
      <h3 class="heading"><a href="./$col8">$col2</a></h3>
      <nav>
        <ul>
          <li><a href="/pdf/$col10.pdf" download="$col10.pdf" class="pdf-alert">PDF</a></li>
          <li><a href="/zip/$col10.zip" download="$col10.zip" class="test-alert">問題集</a></li>
        </ul>
      </nav>
    </header>
EOF
      cat << EOF >> css/"$col4".css
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
  content: "\A";
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
        tmp_functions+="function changeColor$i(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold';
}
"
      done
      cat << EOF >> js/"$col6".js
$tmp_functions
//PDFダウンロード時のアラート
function pdf_alert() {
	var a_pdf = document.getElementsByClassName('pdf-alert');
	for (var i = 0; i < a_pdf.length; i++) {
		a_pdf[i].onclick = function() {
			if (window.confirm('PDFファイルをダウンロードします。\n問題集と併せてご利用下さい。\nよろしいですか？')) {
				return true;
			} else {
				return false;
			}
		}
	}
}
function addEventSet(element, listener, fn) {
	try {
		element.addEventListener(listener, fn, false);
	} catch(e) {
		element.attachEvent('on' + listener, fn);
	}
}
addEventSet(window, 'load', function() {
	pdf_alert();
});

//問題集ダウンロード時のアラート
function test_alert() {
	var a_pdf = document.getElementsByClassName('test-alert');
	for (var i = 0; i < a_pdf.length; i++) {
		a_pdf[i].onclick = function() {
			if (window.confirm('問題集をダウンロードします。\nこの問題集を網羅した暁には、資格試験合格という輝かしい未来が待っています。よろしいですか？\n\n使い方は以下の通り\nフォルダ内の"index.html"を開き、攻略開始をクリック。')) {
				return true;
			} else {
				return false;
			}
		}
	}
}
function addEventSet(element, listener, fn) {
	try {
		element.addEventListener(listener, fn, false);
	} catch(e) {
		element.attachEvent('on' + listener, fn);
	}
}
addEventSet(window, 'load', function() {
	test_alert();
});
EOF
    fi
  done < "$mid_file"

  # カウント変数(while文の外側に配置)
  count=0

  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 _ || [[ -n $col7 ]]; do

    if [ "$col1" = $multiple ]; then
      cat << EOF >> "$main_file"
      <p><b>問題 $count $col2:</b></p>
      <page>
        <a>a. $col3</a>
        <a>b. $col4</a>
        <a>c. $col5</a>
        <a>d. $col6</a>
        <a>e. $col7</a>
      </page>
      <div class="button">
        <input type="button" class="btn btn-info btn-sm" value=" 正解を表示 " onclick="changeColor('target');" />
      </div>
EOF
    elif [ "$col1" = $writing ]; then
      cat << EOF >> "$main_file"
    <p><b>問題 $count $col2</b></p>
    <clear>
      <a id="target">$col3</a>
    </clear>
    <div class="button">
      <input type="button" class="btn btn-info btn-sm" value=" 正解を表示 " onclick="changeColor('target');" />
    </div>
EOF
    # else
    #   handle_error
    fi
    # カウント変数をインクリメントする
    count=$((count + 1))
  done < "$mid_file"

  while IFS=, read -r col1 || [[ -n $col1 ]]; do
    if [ "$col1" = "$dir_name" ]; then
      cat << EOF >> "$main_file"
  <br>
  <footer>
    <p><b>$col1 finished</b></p>
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
    # else
    #   handle_error
    fi
  done < "$mid_file"
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  echo
}

if [ -f "$mid_file" ]; then
  create_dir
  exit 0
fi

if [ -f "$sub_file" ]; then
  if [ -s "$sub_file" ]; then
    echo -e "\033[1;31mERROR: 読込用ファイルがありません。対象のファイルを $current_dir に生成します。\033[0m"
    convert_to_csv
    echo
  else
    txt_error
    echo
  fi
elif [ ! -f "$sub_file" ]; then
  create_txt
  echo -e "\033[1;31mERROR: 読込用ファイルがありません。対象のファイルを $current_dir に生成します。\033[0m"
  echo "以下の入力方法に従って、必要なものを記入してください。"
  echo "注意: テキストファイルの書式は以下のようにすること(6行書くごとに1行の空行を作る)"
  echo "　　　また、1行目には以下のオプションを入力すること。"
  echo
  echo "dir  -> ディレクトリ・タイトル名"
  echo "css  -> cssファイル名"
  echo "js   -> jsファイル名"
  echo "back -> バックリンク"
  echo "dlc  -> ダウンロードファイルパス"
  echo
  echo "以下の2つは問題の種類ごとに選択する。(複数回使用可)"
  echo "multiple -> 選択問題(複数問題)"
  echo "writing  -> 記述問題"
  echo
  echo "dir -> ディレクトリ・タイトル名(最終行に必ず入れる)"
  echo
  echo "例: テキストファイルは以下のような形になるようにして下さい。"
  echo
  echo "dir"
  echo "ディレクトリ・タイトル名"
  echo "css"
  echo "cssファイル名"
  echo "js"
  echo "jsファイル名"
  echo "back"
  echo "バックリンク"
  echo "dlc"
  echo "ダウンロードファイルパス"
  echo
  echo "multiple"
  echo "問題文"
  echo "選択肢1"
  echo "選択肢2"
  echo "選択肢3"
  echo "選択肢4"
  echo "選択肢5"
  echo
  echo "writing"
  echo "問題文"
  echo "問題の答え"
  echo
  echo "dir"
  echo "ディレクトリ・タイトル名"
  echo
  exit 1
else
  echo
fi
