#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
read -prompt "タイムスタンプを作成する親ファイルを入力してください: " main_file
sed -e 's/^/0:00, -> ,"/g' -e 's/ -> /（/g' -e 's/$/）"/g' -e 's/,（,/, -> ,/g' "$current_dir/$main_file" > "$current_dir/$main_file.csv"
echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
echo -e "\033[1;32m$main_file は $current_dir に格納されています。\033[0m"
