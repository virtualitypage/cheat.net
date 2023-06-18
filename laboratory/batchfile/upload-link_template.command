#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

youtube_csv="youtube.csv"
tiktok_csv="tiktok.csv"
twitter_csv="twitter.csv"
nicovideo_csv="nicovideo.csv"

youtube_txt="youtube.txt"
tiktok_txt="tiktok.txt"
twitter_txt="twitter.txt"
nicovideo_txt="nicovideo.txt"

function create_code_youtube () {
count=0
while IFS=, read -r col1 col2 || [[ -n "$col2" ]]
do
count=$(echo "$count + 1" | bc)
cat << EOF >> "${current_dir}/${youtube_txt}"
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${youtube_csv}"
}

function create_code_tiktok () {
count=0
while IFS=, read -r col1 col2 || [[ -n "$col2" ]]
do
count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${tiktok_txt}
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${tiktok_csv}"
}

function create_code_twitter () {
count=0
while IFS=, read -r col1 col2 || [[ -n "$col2" ]]
do
count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${twitter_txt}
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${twitter_csv}"
}

function create_code_nicovideo () {
count=0
while IFS=, read -r col1 col2 || [[ -n "$col2" ]]
do
count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${nicovideo_txt}
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${nicovideo_csv}"
}

function echo_tmp () {
  echo "読込用csvファイルがありません。$(cd $(dirname $0) && pwd)にcsvファイルを配置して下さい。"
  echo "以下の入力方法に従って、必要なものを記入したものが対象です。"
  echo "一度に変換できるのは一つのcsvのみであり、複数のファイルを読み込むとカウントがバグります。"
  echo "※csvの一列目には動画等のURL、二列目にはタイトルを入力します。"
  echo ""
  echo "| https:// | タイトル1 |"
  echo "| https:// | タイトル2 |"
  echo "| https:// | タイトル3 |"
  echo ""
  exit 1
}

function echo_tmp_youtube () {
  echo "HTMLコード生成が完了しました。"
  echo "${youtube_txt}は${current_dir}に保存されています。"
  echo ""
}

function echo_tmp_tiktok () {
  echo "HTMLコード生成が完了しました。"
  echo "${tiktok_txt}は${current_dir}に保存されています。"
  echo ""
}

function echo_tmp_twitter () {
  echo "HTMLコード生成が完了しました。"
  echo "${twitter_txt}は${current_dir}に保存されています。"
  echo ""
}

function echo_tmp_nicovideo () {
  echo "HTMLコード生成が完了しました。"
  echo "${nicovideo_txt}は${current_dir}に保存されています。"
  echo ""
}

if [ -f "${current_dir}/${youtube_csv}" ]; then
  create_code_youtube
  echo_tmp_youtube
fi

if [ -f "${current_dir}/${tiktok_csv}" ]; then
  create_code_tiktok
  echo_tmp_tiktok
fi

if [ -f "${current_dir}/${twitter_csv}" ]; then
  create_code_twitter
  echo_tmp_twitter
fi

if [ -f "${current_dir}/${nicovideo_csv}" ]; then
  create_code_nicovideo
  echo_tmp_nicovideo
fi