#!/bin/bash

function progress_bar () {
  echo
  for i in {1..50}; do
    arrow="\e[1;34m==>\e[0m"
    sleep 0.005
    progress_bar="$(yes "#" | head -n "${i}" | tr -d '\n')"
    printf "\r$arrow \e[1;32mrm [%3d/100] %s" $((i * 2)) "${progress_bar}"
  done
  printf "\n"
  echo
}

function selective_delete () {
  read -prompt "以下のオプションから一つ選択してください
  { 全削除 | 選択削除 | 終了 }
> " section
  if [ "$section" = "全削除" ]; then
    echo -e "\033[1;33mCONFIRM: $volume のゴミ箱を空にします。よろしいですか？\033[0m"
    read -prompt "\"yes\" を入力して削除: " yesno
    if [ "$yesno" = "yes" ]; then
      echo "rm -rf /Volumes/$volume/.Trashes/*"
      rm -rf "/Volumes/$volume/.Trashes/*"
      progress_bar
      echo -e "\033[1;32mSUCCESS: $volume のゴミ箱を空にしました\033[0m"
      echo
    else
      echo -e "\033[1;32mEXIT: 処理を終了します\033[0m"
      echo
      exit
    fi
  elif [ "$section" = "選択削除" ]; then
    echo
    while true; do
      read -prompt "削除したいファイル・ディレクトリを入力してください(終了する場合は Enter キー): " deleteFile
      if [ -e "$deleteFile" ]; then
        echo
        echo -e "\033[1;33mCONFIRM: $volume のゴミ箱にある $deleteFile を削除します。よろしいですか？\033[0m"
        read -prompt "\"yes\" を入力して削除: " yesno
        if [ "$yesno" = "yes" ]; then
          echo "rm -rf /Volumes/$volume/.Trashes/$deleteFile"
          rm -rf "/Volumes/$volume/.Trashes/$deleteFile"
          progress_bar
          echo -e "\033[1;32mSUCCESS: $volume のゴミ箱にある $deleteFile を削除しました\033[0m"
          echo
          continue
        fi
      elif [ ! -e "$deleteFile" ] && [ -n "$deleteFile" ]; then
        echo -e "\033[1;31mERROR: そのようなファイルは存在しません\033[0m"
        echo
        continue
      elif [ -z "$deleteFile" ]; then
        echo -e "\033[1;32mEXIT: 処理を終了します\033[0m"
        echo
        exit
      fi
    done
  elif [ "$section" = "終了" ]; then
    echo -e "\033[1;32mEXIT: 処理を終了します\033[0m"
    echo
    exit
  else
    echo -e "\033[1;32mEXIT: 処理を終了します\033[0m"
    echo
    exit
  fi
}

while true; do
  read -prompt "ディスク名を指定してください: " volume
  IFS=$'\n' # スペースをファイル名に含めるためにIFS(Internal Field Separator)を設定
  if [ -e "/Volumes/$volume" ]; then
    if [ -n "$volume" ]; then
      cd "/Volumes/$volume/.Trashes" || exit
      disk_use=$(du -sh "/Volumes/$volume/.Trashes" | cut -f1)
      echo -e "\033[1;36mINFO: $volume のゴミ箱にて以下のファイルが検出されました。容量:${disk_use}B\033[0m"
      for file in ls $(ls -a); do
        files=$(basename "$file")
        if [ -d "$files" ]; then
          echo -e "\033[1;34m> $files\033[0m"
        elif [ -f "$files" ]; then
          echo -e "\033[1;37m> $files\033[0m"
        fi
      done
      echo
      selective_delete
      break
    else
      echo -e "\033[1;31mERROR: $(basename "$volume") が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
      continue
    fi
  elif [ ! -e "/Volumes/$volume" ]; then
    echo -e "\033[1;31mERROR: $(basename "$volume") が存在しません。ドライブがマウントされているか確認して再度実行してください。\033[0m"
    continue
  fi
done
