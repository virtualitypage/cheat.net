#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
csv_file="$current_dir/Chrome パスワード.csv"
today=$(TZ=UTC-9 date '+%Y年%m月%d日')

function modified_passwordList () {
  main_file="$current_dir/passwd.html"
  first_string=true
  if $first_string; then
    cat << EOF >> "$main_file"
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>passwd</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <article id="content">
      <form method="post" action="">
        <p>クローズドなパスワード管理簿　更新日：$today</p>
EOF
  first_string=false
  fi
  count=0
  sed '1d' "$csv_file" > "$csv_file.tmp"
  echo "$csv_file"
  while IFS=, read -r col1 col2 col3 col4 || [[ -n $col4 ]]; do
    count=$((count + 1))
    cat << EOF >> "$main_file"
        <a href="$col2" target="_blank">
          <label>$col1</label>
        </a>
        <br>
        <div class="password-container">
          <label>　ユーザー名</label>
          <input type="password" id="input_username$count" name="input_username$count" value="$col3">
          <button class="btn_passwd">表示</button>
          <br>
          <label>　パスワード</label>
          <input type="password" id="input_passwd$count" name="input_passwd$count" value="$col4">
          <button class="btn_passwd">表示</button>
        </div>
        <br>
EOF
  done < "$csv_file.tmp"
  cat << EOF >> "$main_file"
      </form>
    </article>
    <footer>
    </footer>
  </body>
</html>

<style>
  .btn_passwd {
    color: #000;
    font-size: 15px;
    padding: 3px;
    padding-left: 10px;
    padding-right: 10px;
    /* border-top: 2px solid #b1921b;
    border-right: 2px solid #cea82c;
    border-bottom: 2px solid #987c1e;
    border-left: 2px solid #ffed8b; */
    border-top: 2px solid #d8dcdc;
    border-right: 2px solid #666;
    border-bottom: 2px solid #333;
    border-left: 2px solid #868888;
    border-radius: 0;
    /* background-image: linear-gradient(-45deg, #ffd75b 0%, #fff5a0 50%, #fffabe 34%, #ffffdb 100%, #fff5a0 100%); */
    background-image: linear-gradient(-45deg, #333 0%, #868888 50%, #d8dcdc 34%, white 100%, #666 100%);
    text-shadow: 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff;
    margin-top: 5px;
  }

  a.btn-solid-silver:hover {
    text-shadow: 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff;
  }
	body {
		background-color: #f7f7f7;
	}
	#content {
    padding-top: 5px;
		padding-left: 20px;
	}
	label {
		margin-right: 10px;
	}
</style>

<script>
  window.addEventListener('DOMContentLoaded', function() {
    let btn_passwd = document.querySelectorAll(".btn_passwd");
    btn_passwd.forEach(btn => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        let input_passwd = btn.previousElementSibling;
        if (input_passwd.type === 'password') {
          input_passwd.type = 'text';
          btn.textContent = '非表示';
        } else {
          input_passwd.type = 'password';
          btn.textContent = '表示';
        }
      });
    });
  });
</script>
EOF
}

if [ "$csv_file" ]; then
  modified_passwordList
  rm "$csv_file.tmp"
fi
