#!/bin/bash
# ash 環境に合わせて開発

date=$(TZ=UTC-9 date '+%Y-%m-%d')

send_mailer () {
  cd /etc/
  tar -zcf "archive_$date.tar.gz" archive
  mutt -s "Test mail" -a archive_$date.tar.gz -- youguigujing42@gmail.com < test.mail
  sleep 3
  rm "archive_$date.tar.gz"
}

send_mailer
