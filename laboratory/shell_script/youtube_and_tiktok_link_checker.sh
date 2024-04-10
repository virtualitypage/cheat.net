#!/bin/bash

function youtube_link_checker () {
  csv_file="youtube_copy.csv"
  main_file="youtube_results.csv"
  sed -e '/Disable/d' youtube.csv | cut -d ',' -f 1 > youtube_copy.csv
  echo "link,result" > "$main_file" # 空の判定結果ファイルを作成
  while IFS=',' read -r link || [[ -n "$link" ]]; do
    if [[ $link == *"youtube.com"* ]]; then
      status_code=$(curl -sL -w "%{http_code}" "$link" -o /dev/null) # YouTube動画リンクの場合、curlコマンドでリンク先のHTTPステータスコードを取得
      if [[ $status_code == "200" ]]; then
        if curl -sL "$link" | grep -o "この動画は再生できません"; then # YouTubeのページから再生不可能なメッセージを確認
          echo "$link,404" >> "$main_file"
        else
          echo "$link,200" >> "$main_file"
        fi
      elif [[ $status_code == "302" ]]; then
        echo "$link,302" >> "$main_file" # ステータスコードが302の場合は非公開
      else
        echo "$link,Unknown status" >> "$main_file" # その他のステータスコードは不明
      fi
    else
      echo "$link,Invalid link" >> "$main_file" # YouTubeの動画リンクではない場合は無効なリンクとして判定
    fi
  done < "$csv_file"
  rm $csv_file
}

function tiktok_link_checker () {
  csv_file="tiktok_copy.csv"
  main_file="tiktok_results.csv"
  cut -d ',' -f 1 tiktok.csv > tiktok_copy.csv
  echo "link,result" > "$main_file" # 空の判定結果ファイルを作成
  while IFS=',' read -r link || [[ -n "$link" ]]; do
    if [[ $link == *"tiktok.com"* ]]; then
      title=$(curl -sL "$link" | grep -o '"desc":"[^"]*"' | sed -e 's/"desc":""//g' -e 's/"desc":"//g' -e 's/#.*$//' -e 's/ $//' | head -n 1)
      if [ "$title" ]; then
        echo "$link,$title" >> "$main_file"
      else
        echo "$link,404" >> "$main_file"
      fi
    else
      echo "$link,Invalid link" >> "$main_file" # TikTokの動画リンクではない場合は無効なリンクとして判定
    fi
  done < "$csv_file"
  rm $csv_file
}

if [ "$1" = "youtube_link_checker" ]; then
  if [ -e youtube.csv ]; then
    youtube_link_checker
  else
    echo -e "\033[1;31mERROR: youtube.csv が存在しません\033[0m"
  fi
elif [ "$1" = "tiktok_link_checker" ]; then
  if [ -e tiktok.csv ]; then
    tiktok_link_checker
  else
    echo -e "\033[1;31mERROR: tiktok.csv が存在しません\033[0m"
  fi
else
  script_name=$(basename "$0")
  while true; do
    read -p "引数を入力して下さい: " template
    case $template in
      youtube_link_checker)
        youtube_link_checker
        break
      ;;
      tiktok_link_checker)
        tiktok_link_checker
        break
      ;;
      exit)
        break
      ;;
      *)
        echo -e "\033[1;31mERROR: そのような引数は存在しません(終了する場合は「exit」を入力、または\"control + C\")\033[0m"
        echo -e "\033[1;36mINFO: Usage: $script_name { youtube_link_checker | tiktok_link_checker }\033[0m"
        echo
        continue
      ;;
    esac
  done
fi
