#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

main_file="$current_dir/securityCamera_manual.txt"
sub_file="$current_dir/securityCamera_manual.csv"
sub_copy="$current_dir/securityCamera_manual_copy.csv"
mid_file="$current_dir/securityCamera_Log.txt"
diff_file="$current_dir/securityCamera_diff.txt"

function diff_check () {
  if [ -s "$main_file" ]; then
    sed -e 's/・［//g' -e 's/］//g' -e '/→/d' -e '/^[<space><tab>]*$/d' "$main_file" > "$main_file.tmp"
  else
    touch "$main_file.tmp"
  fi
  diff "$main_file.tmp" "$mid_file" \
    | sed '1d' \
    | sed 's/> //g' \
    | sed '/\\ No newline at end of file/d' \
    | sed 's/---//g' \
    | sed '/< /d' \
    | sed '/^[<space><tab>]*$/d' > "$diff_file.tmp"
  while IFS= read -r line || [[ -n $line ]]; do
    line=$(echo "$line" | sed -e 's/^/・［/' -e 's/$/］/')
    cat << EOF >> "$diff_file"
$line
  →
EOF
    echo >> "$diff_file"
  done < "$diff_file.tmp"
  rm "$diff_file.tmp" "$main_file.tmp"
  diff_file=$(basename "$diff_file")
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$diff_file は $current_dir に格納されています。\033[0m"
}

function modified () {
  echo >> "$main_file"
  cat "$diff_file" >> "$main_file"
  sed -i '' '$d' "$main_file" # 最終行を削除
  sed -i '' 's/  ・［/・［/g' "$main_file"
  sed -i '' 's/  ・［/・［/g' "$diff_file"
  main_file=$(basename "$main_file")
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
}

function generate_logfile_manual () {
  motion=true
  audio=true
  parking=true
  intrusion=true
  person=true
  other=true
  sed -e '/記録文章/d' "$sub_file" > "$sub_copy"
  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    if $motion && [ "$col1" = ①動体検知 ]; then
      echo "##### 動体検知 #####" >> "$main_file"
      echo >> "$main_file"
      motion=false
    elif $audio && [ "$col1" = ②音声記録 ]; then
      echo "##### 音声記録 #####" >> "$main_file"
      echo >> "$main_file"
      audio=false
    elif $parking && [ "$col1" = ③無断駐車 ]; then
      echo "##### 無断駐車 #####" >> "$main_file"
      echo >> "$main_file"
      parking=false
    elif $intrusion && [ "$col1" = ④敷地内への侵入 ]; then
      echo "##### 敷地内への侵入 #####" >> "$main_file"
      echo >> "$main_file"
      intrusion=false
    elif $person && [ "$col1" = ⑤不審な人影や動き ]; then
      echo "##### 不審な人影や動き #####" >> "$main_file"
      echo >> "$main_file"
      person=false
    elif $other && [ "$col1" = 無断駐車／敷地内への侵入／不審な人影や動き ]; then
      echo "##### $col1 #####" >> "$main_file"
      echo >> "$main_file"
      other=false
    fi
    if [[ $col2 =~ "・［" ]]; then
      echo "$col2" >> "$main_file"
    fi
    if [[ $col3 =~ "→" ]]; then
      echo "  $col3" >> "$main_file"
    else
      continue
    fi
    echo >> "$main_file"
  done < "$sub_copy"
  echo >> "$main_file"
  rm "$sub_copy"
  head -n $(($(wc -l < "$main_file") - 2)) "$main_file" > "$main_file.tmp" # 最終行から2行上を削除
  mv "$main_file.tmp" "$main_file"
}

function generate_logfile_csv () {
  if [ ! -e "$sub_file" ]; then
    echo "項目名,記録文章,防犯カメラの内容" >> "$sub_file"
  fi
  if [ ! -e "$diff_file" ]; then
    generate_logfile_manual
  elif [ -e "$diff_file" ]; then
    modified
    while IFS= read -r line || [[ -n $line ]]; do
      if [ -n "$line" ]; then
        echo -n "$line," >> "$sub_file"
      elif [ -z "$line" ]; then
        echo >> "$sub_file"
      fi
    done < "$main_file"
    echo >> "$sub_file"
    sub_file=$(basename "$sub_file")
  fi
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$sub_file は $current_dir に格納されています。\033[0m"
}

templateList=$(
  cat << EOF
> diff_check
  → Log ファイルと manual ファイルにある差分を確認します

> generate_logfile_csv
  → diffファイルの内容を manual ファイルに追記、csvへの変換処理を実行します(diff_check 実行後)
   ※生成された .csv を開いて1列目を昇順で並び替えて .numbers として保存
   .numbers → .csv 書き出し後、この関数を実行して「防犯カメラ 記録マニュアル.pdf」を作成する

> modified
  → diff ファイルの内容を manual ファイルに追記します(通常は generate_logfile_csv を使用)

EOF
)
echo -e "\033[1;36m$templateList\033[0m"
echo
while true; do
  read -p "上記から関数を選択して下さい: " template
  case $template in
    diff_check)
      diff_check
      break
    ;;
    generate_logfile_csv)
      generate_logfile_csv
      break
    ;;
    modified)
      modified
      break
    ;;
    exit)
      break
    ;;
    *)
      echo -e "\033[1;31mERROR: そのような関数は存在しません(終了する場合は「exit」を入力)\033[0m"
      echo
      continue
    ;;
  esac
done
