#!/bin/bash

today=$(date '+%Y-%m-%d')
src_volume="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/Internal"
dst_volume="/Volumes/Internal"
SERVER="Internal"
logfile=$src_volume/server_sync_"$today".log

function server_sync () {
  # Google Drive 共有フォルダのパス
  local_dir="$src_volume/usr/local"
  share_dir="$src_volume/usr/share"
  src_dir="$src_volume/usr/src"
  log_dir="$src_volume/var/log"

  src_dev="$src_volume/dev/"
  src_media_photos="$src_volume/media/photos/"
  src_media_red_zone="$src_volume/media/red_zone/*"
  src_footage_2023="$local_dir/footage/2023/"
  src_footage_2024="$local_dir/footage/2024/"
  src_web_archive="$local_dir/web_archive/"
  src_arch="$share_dir/arch/"
  src_config="$share_dir/config/"
  src_pdf="$share_dir/pdf/"
  src_code="$src_dir/"
  src_code_apple="$src_dir/apple/"
  src_code_google="$src_dir/google/"
  src_code_shell="$src_dir/shell/"
  src_securityLog_2023="$log_dir/securityLog/2023/"
  src_securityLog_2024="$log_dir/securityLog/2024/"
  src_stat_text_2023="$log_dir/stat_text/2023/"
  src_stat_text_2024="$log_dir/stat_text/2024/"
  src_stdout="$log_dir/stdout/"
  src_talk="$log_dir/talk/"
  src_mail="$log_dir/mail/"

  # internalサーバ(Samba)の親ディレクトリ
  dev="$dst_volume/dev"                                   # "開発用ファイル" 保管ディレクトリ
  media_photos="$dst_volume/media/photos"                 # "写真" 保管ディレクトリ
  media_red_zone="$dst_volume/media/red_zone"             # "防犯カメラ写真" 保管ディレクトリ
  footage_2023="$dst_volume/usr/local/footage/2023"       # "2023年度 防犯カメラ映像" 保管ディレクトリ
  footage_2024="$dst_volume/usr/local/footage/2024"       # "2024年度 防犯カメラ映像" 保管ディレクトリ
  web_archive="$dst_volume/usr/local/web_archive"         # "webサイトの圧縮ファイル" 保管ディレクトリ
  arch="$dst_volume/usr/share/arch"                       # "アーキテクチャ" 保管ディレクトリ
  config="$dst_volume/usr/share/config"                   # "コンフィグ関連ファイル" 保管ディレクトリ
  pdf="$dst_volume/usr/share/pdf"                         # "PDFファイル" 保管ディレクトリ
  src="$dst_volume/usr/src"                               # "ソースコード" 保管ディレクトリ
  src_apple="$dst_volume/usr/src/apple"                   # "AppleScriptのソースコード" 保管ディレクトリ
  src_google="$dst_volume/usr/src/google"                 # "Google Apps Scriptのソースコード" 保管ディレクトリ
  src_shell="$dst_volume/usr/src/shell"                   # "shell scriptのソースコード" 保管ディレクトリ
  securityLog_2023="$dst_volume/var/log/securityLog/2023" # "2023年度 防犯カメラ記録" 保管ディレクトリ
  securityLog_2024="$dst_volume/var/log/securityLog/2024" # "2024年度 防犯カメラ記録" 保管ディレクトリ
  stat_text_2023="$dst_volume/var/log/stat_text/2023"     # "2023年度 防犯カメラ記録 status" 保管ディレクトリ
  stat_text_2024="$dst_volume/var/log/stat_text/2024"     # "2024年度 防犯カメラ記録 status" 保管ディレクトリ
  stdout="$dst_volume/var/log/stdout"                     # "コマンドログ" 保管ディレクトリ
  talk="$dst_volume/var/log/talk"                         # "グループLINEのトーク履歴" 保管ディレクトリ
  mail="$dst_volume/var/mail"                             # "メールファイル" 保管ディレクトリ

  # internalサーバ(Samba)に転送
  echo "rsync --archive --human-readable --progress \"$src_dev\" $dev"
  rsync --archive --human-readable --progress "$src_dev" $dev
  echo
  echo "rsync --archive --human-readable --progress \"$src_media_photos\" $media_photos"
  rsync --archive --human-readable --progress "$src_media_photos" $media_photos
  echo
  echo "rsync --archive --human-readable --progress \"$src_media_red_zone\" $media_red_zone"
  rsync --archive --human-readable --progress "$src_media_red_zone" $media_red_zone
  echo
  echo "rsync --archive --human-readable --progress \"$src_footage_2023\" $footage_2023"
  rsync --archive --human-readable --progress "$src_footage_2023" $footage_2023
  echo
  echo "rsync --archive --human-readable --progress \"$src_footage_2024\" $footage_2024"
  rsync --archive --human-readable --progress "$src_footage_2024" $footage_2024
  echo
  echo "rsync --archive --human-readable --progress \"$src_web_archive\" $web_archive"
  rsync --archive --human-readable --progress "$src_web_archive" $web_archive
  echo
  echo "rsync --archive --human-readable --progress \"$src_arch\" $arch"
  rsync --archive --human-readable --progress "$src_arch" $arch
  echo
  echo "rsync --archive --human-readable --progress \"$src_config\" $config"
  rsync --archive --human-readable --progress "$src_config" $config
  echo
  echo "rsync --archive --human-readable --progress \"$src_pdf\" $pdf"
  rsync --archive --human-readable --progress "$src_pdf" $pdf
  echo
  echo "rsync --archive --human-readable --progress \"$src_code\" $src"
  rsync --archive --human-readable --progress "$src_code" $src
  echo
  echo "rsync --archive --human-readable --progress \"$src_code_apple\" $src_apple"
  rsync --archive --human-readable --progress "$src_code_apple" $src_apple
  echo
  echo "rsync --archive --human-readable --progress \"$src_code_google\" $src_google"
  rsync --archive --human-readable --progress "$src_code_google" $src_google
  echo
  echo "rsync --archive --human-readable --progress \"$src_code_shell\" $src_shell"
  rsync --archive --human-readable --progress "$src_code_shell" $src_shell
  echo
  echo "rsync --archive --human-readable --progress \"$src_securityLog_2023\" $securityLog_2023"
  rsync --archive --human-readable --progress "$src_securityLog_2023" $securityLog_2023
  echo
  echo "rsync --archive --human-readable --progress \"$src_securityLog_2024\" $securityLog_2024"
  rsync --archive --human-readable --progress "$src_securityLog_2024" $securityLog_2024
  echo
  echo "rsync --archive --human-readable --progress \"$src_stat_text_2023\" $stat_text_2023"
  rsync --archive --human-readable --progress "$src_stat_text_2023" $stat_text_2023
  echo
  echo "rsync --archive --human-readable --progress \"$src_stat_text_2024\" $stat_text_2024"
  rsync --archive --human-readable --progress "$src_stat_text_2024" $stat_text_2024
  echo
  echo "rsync --archive --human-readable --progress \"$src_stdout\" $stdout"
  rsync --archive --human-readable --progress "$src_stdout" $stdout
  echo
  echo "rsync --archive --human-readable --progress \"$src_talk\" $talk"
  rsync --archive --human-readable --progress "$src_talk" $talk
  echo
  echo "rsync --archive --human-readable --progress \"$src_mail\" $mail"
  rsync --archive --human-readable --progress "$src_mail" $mail
  echo
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの同期処理が正常に終了しました。\033[0m"
  echo
}

exec > >(tee -a "$logfile")

URL="https://drive.google.com/drive/my-drive"
success=$(curl -I $URL 2>/dev/null | head -n 1)
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$success" ] && [ -e "$src_volume" ]; then
  echo -e "\033[1;32mSUCCESS: $success\033[0m"
elif [ "$failure" == "Could not resolve host" ]; then
  echo -e "\033[1;31mNETWORK ERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -e "$src_volume" ]; then
  if [ -e $dst_volume ]; then
    echo -e "\033[1;32mSUCCESS: SERVER \"$SERVER\" は有効です。\033[0m"
    echo
    server_sync
  elif [ ! -e $dst_volume ]; then
    echo -e "\033[1;31mERROR: SERVER \"$SERVER\" にアクセス出来ません。サーバーにアクセスされているか確認して再度実行してください。\033[0m"
    echo
    exit 1
  fi
elif [ ! -e "$src_volume" ]; then
  echo -e "\033[1;31mERROR: Google Drive にアクセス出来ませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi
