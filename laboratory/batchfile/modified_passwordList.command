#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dir="$current_dir/password_lists"

array=()
while IFS= read -r -d '' csv; do
  array+=("$csv")
done < <(find "$dir" -type f -name "*.csv" -print0)

function modified_passwordList () {
  main_file="$current_dir/passwd.html"
  first_string=true
  if $first_string; then
    code=$(cat << 'EOF'
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>passwd</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <style>
    .btn_passwd {
      color: #000;
      /* border-top: 2px solid #b1921b;
      border-right: 2px solid #cea82c;
      border-bottom: 2px solid #987c1e;
      border-left: 2px solid #ffed8b; */
      border-top: 2px solid #d8dcdc;
      border-right: 2px solid #666;
      border-bottom: 2px solid #333;
      border-left: 2px solid #868888;
      border-radius: 0;
      /* background-image: linear-gradient\(-45deg, #ffd75b 0%, #fff5a0 50%, #fffabe 34%, #ffffdb 100%, #fff5a0 100%\); */
      background-image: linear-gradient\(-45deg, #333 0%, #868888 50%, #d8dcdc 34%, white 100%, #666 100%\);
      text-shadow: 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff, 0 0 5px #fff;
    }

    a.btn-solid-silver:hover {
      text-shadow: 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff, 0 0 7px #fff;
    }

    body {
      background-color: #f7f7f7;
      font-family: "Hiragino Kaku Gothic Pro", "ヒラギノ角ゴ Pro W3", "游ゴシック体", "Yu Gothic", YuGothic, Meiryo, メイリオ, "Noto Sans JP", sans-serif;
    }

    #content1 {
      padding: 20px;
    }

    label {
      margin-right: 10px;
    }
  </style>
  <body>
    <article id="content1">
      <form method="post" action="">
EOF
    )
    first_string=false
    echo "$code" >> "$main_file"
    sed -i '' 's/\\//g' "$main_file"
  fi
  count=0
  for csv_file in "${array[@]}"; do # 配列の要素を一つずつ処理
    sed -i '' '1,2d' "$csv_file"
    echo "$csv_file"
    while IFS=, read -r col1 col2 || [[ -n $col2 ]]; do
      count=$((count + 1))
      col2=$(echo "$col2" | tr -d '\r')
      code=$(
        cat << EOF
        <div class="password-container">
          <label for="input_passwd$count">$col1</label><br>
          <input type="password" id="input_passwd$count" name="input_passwd$count" value="$col2">
          <button class="btn_passwd">表示</button>
        </div>
EOF
      )
      echo "$code" >> "$main_file"
    done < "$csv_file"
  done
  code=$(
    cat << EOF
      </form>
    </article>
  </body>
</html>

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
  )
  code=$(perl -pe 'chomp if eof' <<< "$code")
  echo "$code" | perl -pe 'chomp if eof' >> "$main_file"
}

if [ "$dir" ]; then
  rm "$dir"/._* 2>/dev/null
  modified_passwordList
fi
