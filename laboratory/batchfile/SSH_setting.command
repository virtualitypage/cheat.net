#!/bin/bash

destination="$HOME/Library/CloudStorage/GoogleDrive-ganbanlife@gmail.com/.shortcut-targets-by-id/1mZyi1kb7Iepj2zVvRgVo_BGJAmlC8GKY/共有フォルダ/リモートログイン"
config_file="$destination/config"
sshd_config="/etc/ssh/sshd_config"

URL="https://google.com"
failure=$(curl -I $URL 2>&1 | grep -o "Could not resolve host")

if [ "$failure" == "Could not resolve host" ]; then
  echo
  echo -e "\033[1;31mNETWORK ERROR: インターネットにアクセスできませんでした。端末が Wi-Fi に接続されているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

if [ -n "$destination" ]; then
  sleep 0.1
else
  echo -e "\033[1;31mERROR: データの転送先が見つかりませんでした。Google Drive がマウントされているか確認して再度実行してください。\033[0m"
  echo
  exit 1
fi

# initial settings (client)
init_client () {
  id_rsa=id_rsa
  RNG="$HOME/random"
  cd ~/.ssh || exit
  if [ -e "id_rsa" ] || [ -e "id_rsa.pub" ]; then
    read -p "公開鍵か秘密鍵、またはその両方が既に存在しています。上書きしますか？(y/n)?: " yesno
    if [ "$yesno" == "y" ]; then
      rm id_rsa 2>/dev/null ; rm id_rsa.pub 2>/dev/null
      openssl rand -base64 32 > "$RNG" ; chmod 400 "$RNG"
      read -r passphrase < "$RNG"
      echo "$passphrase" | ssh-keygen -t rsa -N "$passphrase" -f "$id_rsa"
      rm -f "$RNG"
      rsync id_rsa.pub "$destination"
      echo
    else
      echo
      exit 0
    fi
  else
    openssl rand -base64 32 > "$RNG" ; chmod 400 "$RNG"
    read -r passphrase < "$RNG"
    echo "$passphrase" | ssh-keygen -t rsa -N "$passphrase" -f "$id_rsa"
    rm -f "$RNG"
    rsync id_rsa.pub "$destination"
    echo
  fi
}

# initial settings (server)
init_server () {
  port=$(grep -o "#Port 22" "$sshd_config")
  if [ "$port" == "#Port 22" ]; then
    echo -e "\033[1;38m$sshd_config\033[0m"
    echo -e "\033[1;38m$port ← ポートを開放してください\033[0m"
    echo
  fi
  cd ~/.ssh || exit
  if [ -e "id_rsa.pub" ] && [ -e "$destination"/id_rsa.pub ]; then
    read -p "公開鍵が既に存在しています。上書きしますか？(y/n)?: " yesno
    if [ "$yesno" == "y" ]; then
      mv -f "$destination"/id_rsa.pub ~/.ssh
      cat id_rsa.pub > authorized_keys
      chmod -v 600 authorized_keys
      echo
    else
      echo
      exit 0
    fi
  elif [ ! -e "$destination"/id_rsa.pub ]; then
    echo -e "\033[1;31mERROR: 共有フォルダ \"リモートログイン\" にて公開鍵が見つかりませんでした。\033[0m"
    echo -e "\033[1;31m       クライアント側で init_client を実行した上で再度実行してください。\033[0m"
    echo
  else
    mv -f "$destination"/id_rsa.pub ~/.ssh
    cat id_rsa.pub > authorized_keys
    echo
    chmod -v 600 authorized_keys
    echo
  fi
}

# server only
connect_server () {
  gip=$(curl -s inet-ip.info)
  echo -e "\033[1;38mGlobal IP: $gip\033[0m"
  echo

  config=$(
    cat << EOF
Host iMac_Kochi
  HostName $gip # サーバのIPアドレス
  User  # サーバのユーザ名
  IdentityFile ~/.ssh/id_rsa
EOF
)
  config=$(perl -pe 'chomp if eof' <<< "$config")
  echo "$config" | perl -pe 'chomp if eof' > "$config_file"
}

# client only
connect_client () {
  if [ -e "$config_file" ]; then
    read -p "実行者はクライアント側(接続元)の人間ですか: " authentication
    if [ "$authentication" == "yes" ] || [ "$authentication" == "y" ] || [ "$authentication" == "はい" ]; then
      mv -fv "$config_file" ~/.ssh
      echo -e "\033[1;38mconfig ファイルの更新完了\033[0m"
      echo -e "\033[1;38mターミナル上で \"ssh iMac_Kochi\" を入力することで接続可能\033[0m"
      echo
    else
      echo -e "\033[1;38m認証に失敗しました\033[0m"
      echo
    fi
  elif [ ! -e "$config_file" ]; then
    echo -e "\033[1;31mERROR: config ファイルが見つかりませんでした。\033[0m"
    echo -e "\033[1;31m       サーバ側で connect_server を実行した上で再度実行してください。\033[0m"
    echo
    exit 1
  fi
}

string="これはSSH接続を行うためのプログラムです。オプションを指定してEnterキーを押してください"
for ((i = 0; i < ${#string}; i++)); do
  echo -n -e "\033[1;36m${string:i:1}\033[0m"
  sleep 0.06
done
sleep 0.2
echo
echo "SSH_setting.command --help"
echo

message=$(
  cat << EOF
OPTION

    init_client -> クライアント側の初期設定

    init_server -> サーバ側の初期設定(クライアント側の設定完了後)

    connect_server -> サーバ側の GIP 更新

    connect_client -> クライアント側の ~/.ssh/config 更新

MEMO

    初期状態では クライアント側(接続元)で公開鍵・秘密鍵を生成
                 サーバ側(接続先)でクライアント側の公開鍵を取得
                 フルディスクアクセスを有効化

    設定完了後は サーバ側で connect_server 実行後
                 クライアント側で connect_client を実行

      +--------+                              +--------+
      │ client │ <----- encrypted data -----> │ server │
      +--------+                              +--------+
EOF
)
echo -e "\033[1;38m$message\033[0m"
echo

while true; do
  read -p "OPTION を指定してください: " option
  case "$option" in
    init_client)
      echo
      init_client
      break
    ;;
    init_server)
      echo
      init_server
      break
    ;;
    connect_server)
      echo
      connect_server
      break
    ;;
    connect_client)
      echo
      connect_client
      break
    ;;
    *)
      echo -e "\033[1;31mERROR: $option というオプションは設定されていません\033[0m"
      echo
      continue
    ;;
  esac
done
