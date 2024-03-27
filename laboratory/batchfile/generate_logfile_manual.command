#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)

main_file="$current_dir/securityCamera_manual.txt"
sub_file="$current_dir/securityCamera_manual.csv"
sub_copy="$current_dir/securityCamera_manual_copy.csv"
mid_file="$current_dir/securityCamera_Log.txt"
mid_copy="$current_dir/securityCamera_Log_before.txt"
diff_file="$current_dir/securityCamera_diff.txt"

function diff_check () {
  if [ -e "$sub_file" ] && [ -e "$mid_copy" ]; then
    sed -e 's/・［//g' -e 's/］//g' -e '/→/d' -e '/^[<space><tab>]*$/d' -e '/記録文章/d' "$mid_copy" > "$mid_copy.tmp"
  elif [ -e "$sub_file" ] && [ -n "$mid_copy" ]; then
    echo "cut -d ',' -f2 securityCamera_manual.csv > securityCamera_Log_before.txt"
    cut -d ',' -f2 "$sub_file" > "$mid_copy"
    sed -e 's/・［//g' -e 's/］//g' -e '/→/d' -e '/^[<space><tab>]*$/d' -e '/記録文章/d' "$mid_copy" > "$mid_copy.tmp"
    echo
    echo -e "\033[1;36mINFO: securityCamera_manual.csv を読み込んで securityCamera_Log_before.txt を作成しました\033[0m"
  elif [ -n "$sub_file" ] && [ -n "$mid_copy" ] || [ -n "$sub_file" ] || [ -n "$mid_copy" ]; then
    echo -e "\033[1;31mERROR: securityCamera_manual.csv か securityCamera_Log_before.txt 又はその両方が存在しません\033[0m"
    exit 1
  fi
  if [ -e "$mid_file" ] && [ -e "$mid_copy" ]; then
    echo
    echo -e "\033[1;36mINFO: securityCamera_Log_before.txt と securityCamera_Log.txt で差分を出力します\033[0m"
    sort "$mid_file" > "$mid_file.tmp"
    sort "$mid_copy.tmp" > "$mid_copy"
    diff "$mid_copy" "$mid_file.tmp" \
      | sed '1d' \
      | sed 's/> //g' \
      | sed '/\\ No newline at end of file/d' \
      | sed 's/---//g' \
      | sed '/< /d' \
      | sed '/.*a/d' \
      | sed '/.*b/d' \
      | sed '/.*c/d' \
      | sed '/.*d/d' \
      | sed '/^[<space><tab>]*$/d' > "$diff_file"

    sed -e 's/(/\\(/g' -e 's/)/\\)/g' -e '/^[<space><tab>]*$/d' "$diff_file" > "$diff_file.tmp"
    sed -e 's/(/\\(/g' -e 's/)/\\)/g' -e '/^[<space><tab>]*$/d' "$mid_copy" > "$mid_copy.tmp"
    echo -n > "$diff_file"

    while IFS= read -r line; do
      grep=$(grep -o "$line" "$mid_copy.tmp")
      if [ -z "$grep" ]; then
        line=$(echo "$line" | sed -e 's/^/・［/' -e 's/$/］/' -e 's/\\(/(/g' -e 's/\\)/)/g')
        cat << EOF >> "$diff_file"
①動体検知②音声記録③無断駐車④敷地内への侵入⑤不審な人影や動き
$line
→
EOF
        echo >> "$diff_file"
      fi
    done < "$diff_file.tmp"
    rm "$diff_file.tmp" "$mid_file.tmp" "$mid_copy.tmp"
    diff_file=$(basename "$diff_file")
    echo
    echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
    echo -e "\033[1;32m$diff_file は $current_dir に格納されています。\033[0m"
    echo
  else
    echo -e "\033[1;31mERROR: securityCamera_Log.txt または securityCamera_Log_before.txt が存在しません。\033[0m"
    exit 1
  fi
}

function generate_logfile_csv () { # securityCamera_diff.txt >> securityCamera_manual.csv
  if [ ! -e "$sub_file" ]; then
    echo "項目名,記録文章,防犯カメラの内容" >> "$sub_file"
  fi
  if [ -e "$sub_file" ] && [ -e "$diff_file" ]; then
    while IFS= read -r line || [[ -n $line ]]; do
      if [ -n "$line" ]; then
        echo -n "$line," >> "$sub_file"
      elif [ -z "$line" ]; then
        echo >> "$sub_file"
      fi
    done < "$diff_file"
    echo >> "$sub_file"
    sub_file=$(basename "$sub_file")
    echo
    echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
    echo -e "\033[1;32m$sub_file は $current_dir に格納されています。\033[0m"
  else
    echo -e "\033[1;31mERROR: securityCamera_manual.csv または securityCamera_diff.txt が存在しません。\033[0m"
    exit 1
  fi
}

function generate_logfile_manual () { # securityCamera_manual_copy.csv >> securityCamera_manual.txt
  motion=true
  audio=true
  parking=true
  intrusion=true
  person=true
  other=true
  if [ -e "$sub_file" ]; then
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
    echo
    echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
    echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
  else
    echo -e "\033[1;31mERROR: securityCamera_manual.csv が存在しません。\033[0m"
    exit 1
  fi
}

templateList=$(
  cat << EOF
> diff_check
  → Log ファイルと csv ファイルの複製が存在する => securityCamera_Log.txt & securityCamera_Log_before.txt
   ※ generate_logfile_edit.command で Log ファイルに追記された内容(昇順で並び替える)と csv ファイルの複製(.txt)にある差分を確認します

> generate_logfile_csv
  → diff ファイルと csv ファイルが存在する => securityCamera_diff.txt >> securityCamera_manual.csv
   ※ diff_check 実行後に生成された diff ファイルの内容を csv ファイルへ追記します

> generate_logfile_manual
  → csv ファイルと manual ファイルが存在する => securityCamera_manual.csv >> securityCamera_manual.txt
   generate_logfile_csv 実行後に生成された csv ファイルを開いて1列目を昇順で並び替えた後 .numbers として保存
   .numbers → .csv 書き出し後、この関数を実行して生成されたものを「FL-Product 防犯カメラ記録マニュアル.numbers」にペースト
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
    generate_logfile_manual)
      generate_logfile_manual
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
