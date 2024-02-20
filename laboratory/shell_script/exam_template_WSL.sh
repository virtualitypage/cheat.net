#!/bin/bash

this=$(basename "$0")
current_dir=$(cd "$(dirname "$0")" && pwd)

function usage () {
  echo "csvファイルからデータを抽出してタグに代入する、プライベートwebサイト'exam'編集用スクリプト(WSL環境対応)"
  echo "入力方法: $this [csvファイルパス] [出力ファイル名] [cssファイル名] [jsファイル名] [バックリンク] [dlファイル名]"
  echo -e "\033[1;31m注意:\033[0m" "exam_template_assist.sh で生成したcsvファイルを使うこと"
  echo "実行環境がWSLの場合、csvファイルパスを /home/XXX.csv の形にする"
  echo "bc コマンドが無い場合は、sudo yum install -y bc を実行する"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

if [[ ! -f "$1" ]]; then
  echo -e "\033[1;31mERROR: ファイルパスの指定に誤りがあります。正しいファイルパスを入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: $HOME/xxx.txt\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: ファイルパス $csv_file は有効です。\033[0m"
fi

if [ -z "$2" ]; then
  echo -e "\033[1;31mERROR: 出力ファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: cisco | lpic | aws\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: 出力ファイル名は $dir_name です。\033[0m"
fi

if [ -z "$3" ]; then
  echo -e "\033[1;31mERROR: cssファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: cssファイル名は $css_name です。\033[0m"
fi

if [ -z "$4" ]; then
  echo -e "\033[1;31mERROR: jsファイル名が指定されていません。ファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: jsファイル名は $js_name です。\033[0m"
fi

if [ -z "$5" ]; then
  echo -e "\033[1;31mERROR: バックリンクが指定されていません。トップページのファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: index\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: バックリンクは $back_link です。\033[0m"
fi

if [ -z "$6" ]; then
  echo -e "\033[1;31mERROR: dlファイル名が指定されていません。ダウンロード用のファイル名を入力して再度実行してください。\033[0m"
  echo -e "\033[1;31mEXAMPLE: sample\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESE: dlファイル名は $dlc_name です。\033[0m"
fi

csv_file=$1
dir_name=$2
css_name=$3
js_name=$4
back_link=$5
dlc_name=$6

function exam_template () {

mkdir "$dir_name"
cd "$dir_name" || exit
mkdir css js
touch css/"$css_name".css js/"$js_name".js

cat << EOF >> "$dir_name".txt
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

# カウント変数(while文の外側に配置)
count=0

# col1, col2 は CSV ファイルの列のヘッダーまたはデータ
while IFS=, read -r col1 col2 col3 col4 col5 col6 _ || [[ -n $col1 ]]; do

count=$(echo "$count+1" | bc)

# 変数"$col3"の値が0でない場合
if [ -n "$col3" ]; then
cat << EOF >> "$dir_name".txt
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
# 変数"$col3"の値が0である場合
else
cat << EOF >> "$dir_name".txt
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

# 終了ステータスが0の場合に処理を開始する(csvファイルの最終行に到達)
if [ $? -eq 0 ]; then
  cat << EOF >> "$dir_name".txt
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

cat << EOF >> css/"$css_name".css
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

cat << EOF >> js/"$js_name".js
function changeColor1(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000'; //文字を赤色にする
  Object.style.fontWeight = 'bold' ; //文字を太字にする
}
function changeColor2(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor3(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor4(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor5(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor6(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor7(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor8(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor9(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor10(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor11(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor12(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor13(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor14(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor15(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor16(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor17(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor18(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor19(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor20(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor21(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor22(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor23(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor24(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor25(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor26(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor27(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor28(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor29(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor30(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor31(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor32(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor33(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor34(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor35(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor36(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor37(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor38(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor39(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor40(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor41(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor42(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor43(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor44(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor45(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor46(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor47(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor48(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor49(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor50(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor51(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor52(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor53(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor54(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor55(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor56(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor56(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor57(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor58(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor59(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor60(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor61(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor62(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor63(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor64(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor65(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor66(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor67(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor68(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor69(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor70(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor71(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor72(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor73(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor74(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor75(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor76(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor77(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor78(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor79(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor80(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor81(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor82(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor83(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor84(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor85(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor86(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor87(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor88(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor89(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor90(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor91(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor92(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor93(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor94(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor95(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor96(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor97(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor98(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor99(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor100(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor101(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor102(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor103(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor104(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor105(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor106(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor107(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor108(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor109(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor110(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor111(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor112(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor113(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor114(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor115(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor116(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor117(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor118(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor119(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor120(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor121(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor122(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor123(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor124(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor125(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor126(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor127(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor128(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor129(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor130(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor131(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor132(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor133(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor134(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor135(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor136(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor137(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor138(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor139(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor140(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor141(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor142(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor143(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor144(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor145(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor146(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor147(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor148(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor149(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor150(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor151(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor152(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor153(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor154(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor155(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor156(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor157(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor158(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor159(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor160(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor161(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor162(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor163(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor164(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor165(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor166(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor167(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor168(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor169(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor170(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor171(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor172(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor173(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor174(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor175(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor176(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor177(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor178(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor179(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor180(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor181(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor182(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor183(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor184(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor185(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor186(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor187(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor188(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor189(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor190	(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor191(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor192(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor193(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor194(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor195(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor196(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor197(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor198(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor199(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor200(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor201(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor202(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor203(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor204(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor205(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor206(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor207(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor208(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor209(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor210(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor211(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor212(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor213(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor214(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor215(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor216(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor217(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor218(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor219(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor220(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor221(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor222(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor223(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor224(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor225(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor226(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor227(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor228(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor229(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor230(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor231(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor232(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor233(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor234(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor235(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor236(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor237(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor238(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor239(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor240(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor241(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor242(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor243(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor244(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor245(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor246(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor247(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor248(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor249(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor250(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor251(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor252(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor253(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor254(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor255(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor256(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor257(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor258(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor259(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor260(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor261(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor262(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor263(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor264(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor265(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor266(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor267(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor268(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor269(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor270(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor271(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor272(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor273(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor274(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor275(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor276(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor277(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor278(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor279(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor280(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor281(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor282(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor283(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor284(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor285(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor286(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor287(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor288(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor289(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor290(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor291(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor292(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor293(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor294(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor295(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor296(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor297(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor298(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor299(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor300(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor301(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor302(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor303(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor304(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor305(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor306(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor307(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor308(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor309(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor310(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor311(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor312(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor313(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor314(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor315(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor316(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor317(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor318(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor319(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor320(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor321(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor322(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor323(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor324(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor325(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor326(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor327(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor328(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor329(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor330(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor331(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor332(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor333(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor334(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor335(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor336(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor337(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor338(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor339(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor340(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor341(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor342(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor343(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor344(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor345(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor346(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor347(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor348(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor349(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor350(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor351(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor352(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor353(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor354(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor355(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor356(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor357(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor358(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor359(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor360(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor361(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor362(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor363(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor364(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor365(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor366(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor367(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor368(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor369(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor370(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor371(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor372(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor373(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor374(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor375(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor376(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor377(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor378(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor379(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor380(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor381(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor382(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor383(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor384(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor385(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor386(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor387(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor388(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor389(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor390(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor391(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor392(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor393(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor394(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor395(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor396(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor397(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor398(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor399(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor400(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor401(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor402(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor403(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor404(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor405(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor406(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor407(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor408(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor409(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor410(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor411(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor412(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor413(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor414(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor415(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor416(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor417(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor418(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor419(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor420(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor421(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor422(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor423(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor424(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor425(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor426(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor427(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor428(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor429(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor430(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor431(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor432(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor433(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor434(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor435(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor436(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor437(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor438(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor439(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor440(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor441(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor442(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor443(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor444(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor445(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor446(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor447(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor448(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor449(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor450(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor451(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor452(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor453(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor454(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor455(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor456(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor457(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor458(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor459(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor460(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor461(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor462(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor463(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor464(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor465(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor466(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor467(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor468(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor469(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor470(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor471(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor472(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor473(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor474(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor475(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor476(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor477(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor478(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor479(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor480(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor481(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor482(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor483(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor484(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor485(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor486(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor487(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor488(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor489(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor490(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor491(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor492(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor493(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor494(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor495(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor496(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor497(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor498(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor499(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor500(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor501(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor502(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor503(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor504(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor505(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor506(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor507(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor508(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor509(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor510(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor511(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor512(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor513(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor514(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor515(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor516(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor517(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor518(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor519(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor520(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor521(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor522(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor523(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor524(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor525(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor526(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor527(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor528(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor529(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor530(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor531(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor532(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor533(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor534(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor535(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor536(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor537(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor538(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor539(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor540(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor541(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor542(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor543(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor544(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor545(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor546(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor547(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor548(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor549(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor550(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor551(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor552(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor553(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor554(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor555(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor556(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor557(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor558(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor559(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor560(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor561(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor562(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor563(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor564(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor565(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor566(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor567(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor568(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor569(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor570(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor571(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor572(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor573(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor574(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor575(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor576(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor577(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor578(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor579(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor580(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor581(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor582(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor583(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor584(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor585(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor586(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor587(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor588(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor589(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor590(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor591(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor592(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor593(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor594(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor595(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor596(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor597(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor598(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor599(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}
function changeColor600(idname){
  var Object = document.getElementById(idname);
  Object.style.color = '#ff0000';
  Object.style.fontWeight = 'bold' ;
}

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

if [[ -f $csv_file ]] && [ "$dir_name" ] && [ "$css_name" ] && [ "$js_name" ] && [ "$back_link" ] && [ "$dlc_name" ]; then
  exam_template
fi
