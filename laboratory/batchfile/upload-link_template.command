#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

youtube_csv="youtube.csv"
tiktok_csv="tiktok.csv"
twitter_csv="twitter.csv"
niko2_csv="nikoniko.csv"

youtube_txt="youtube.txt"
tiktok_txt="tiktok.txt"
twitter_txt="twitter.txt"
niko2_txt="nikoniko.txt"

count=0

function create_code_youtube () {
while IFS=, read -r col1 col2
do

count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${youtube_txt}
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
while IFS=, read -r col1 col2
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
while IFS=, read -r col1 col2
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

function create_code_niko2 () {
while IFS=, read -r col1 col2
do

count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${niko2_txt}
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${niko2_csv}"
}

function create_code_all () {
while IFS=, read -r col1 col2
do

count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${youtube_txt}
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

while IFS=, read -r col1 col2
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

while IFS=, read -r col1 col2
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

while IFS=, read -r col1 col2
do

count=`echo "$count+1" | bc`

cat << EOF >> ${current_dir}/${niko2_txt}
          <tr>
            <th class="number" scope="row">$count</th>
            <td>
              <a href="$col1">
                $col2
              </a>
            </td>
          </tr>
EOF
done < "${current_dir}/${niko2_csv}"
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

function echo_tmp2 () {
  echo "HTMLコード生成が完了しました。"
  echo "ファイルは${current_dir}に保存されています。"
  echo "注意: 他のファイルも処理する場合は今生成したファイルを別の場所に移動して下さい。"
  echo ""
  exit 0
}

if [ -f "${current_dir}/${youtube_csv}" ]; then
  if [ ! -f "${current_dir}/${tiktok_csv}" ] && [ ! -f "${current_dir}/${twitter_csv}" ] && [ ! -f "${current_dir}/${niko2_csv}" ]; then
    create_code_youtube
    echo_tmp2
  fi
fi
if [ -f "${current_dir}/${tiktok_csv}" ]; then
  if [ ! -f "${current_dir}/${youtube_csv}" ] && [ ! -f "${current_dir}/${twitter_csv}" ] && [ ! -f "${current_dir}/${niko2_csv}" ]; then
    create_code_tiktok
    echo_tmp2
  fi
fi
if [ -f "${current_dir}/${twitter_csv}" ]; then
  if [ ! -f "${current_dir}/${youtube_csv}" ] && [ ! -f "${current_dir}/${tiktok_csv}" ] && [ ! -f "${current_dir}/${niko2_csv}" ]; then
    create_code_twitter
    echo_tmp2
  fi
fi
if [ -f "${current_dir}/${niko2_csv}" ]; then
  if [ ! -f "${current_dir}/${youtube_csv}" ] && [ ! -f "${current_dir}/${tiktok_csv}" ] && [ ! -f "${current_dir}/${twitter_csv}" ]; then
    create_code_niko2
    echo_tmp2
  fi
fi
if [ -f "${current_dir}/${youtube_csv}" ] && [ -f "${current_dir}/${tiktok_csv}" ] && [ -f "${current_dir}/${twitter_csv}" ] && [ -f "${current_dir}/${niko2_csv}" ]; then
  create_code_all
  echo_tmp2
else
  echo_tmp
fi