#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dir_name="$current_dir/HTML_TEMPLATE"

function success_msg () {
  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32mHTML ファイルは $dir_name に格納されています。\033[0m"
  echo
}

function html_template_blog () {
  main_file="$current_dir/source_blog.csv"
  if [ "$template" = "blog-sample" ]; then
    cat << EOF > "$main_file"
プレビュー画像への遷移先のリンク(ファイルパス等) ※一行目の場合は「ページのタイトル名」,画像ファイルのリンク(ファイルパス等)※一行目の場合はプレビュー画像への遷移先のリンク(ファイルパス等),遷移先のリンク(ファイルパス等) ※一行目の場合は画像ファイルのリンク(ファイルパス等),コンテンツのタイトル名,日付(追加日等),コメント等の文章
blog-sample,,,Lorem ipsum,January 1 2024,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
,,,Lorem ipsum,January 1 2024,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
,,,Lorem ipsum,January 1 2024,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
,,,Lorem ipsum,January 1 2024,Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
EOF
  elif [ ! -e "$main_file" ] || [ ! -f "$main_file" ]; then
    echo -e "\033[1;31mERROR: ソースファイルが存在しない、またはパスの指定に誤りがあります。対象のファイルを $current_dir に生成します。\033[0m"
    cat << EOF > "$main_file"
プレビュー画像への遷移先のリンク(ファイルパス等) ※一行目の場合は「ページのタイトル名」,画像ファイルのリンク(ファイルパス等)※一行目の場合はプレビュー画像への遷移先のリンク(ファイルパス等),遷移先のリンク(ファイルパス等) ※一行目の場合は画像ファイルのリンク(ファイルパス等),コンテンツのタイトル名,日付(追加日等),コメント等の文章
,,,,,
,,,,,
,,,,,
,,,,,
,,,,,
EOF
    exit 1
  else
    echo -e "\033[1;32mSUCCESS: ソースファイル $main_file は有効です。\033[0m"
  fi

  mkdir "$dir_name"
  sed -i '' '1d' "$main_file"
  first_string=true
  while IFS=, read -r col1 col2 col3 col4 col5 col6 || [[ -n $col6 ]]; do
    if $first_string; then
      templates+="<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"UTF-8\">
    <title>$col1</title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"./blog.css\" />
  </head>
  <body>
    <div class=\"outerMargin outerMargin-bgColor\">
      <section class=\"middleMargin-bgColor middleMargin-textColor\">
        <div class=\"container innerMargin sm:contentBetween contentBetween sm:gridContainer-12col\">
          <div class=\"sm:imgWidth-100 group hover:no-underline focus:no-underline lg:grid lg:gridContainer-12col outerMargin-bgColor\">
            <a href=\"$col2\" class=\"replaceElement lg:gridItem-7col img-bgColor\">
              <img src=\"$col3\" alt=\"\" class=\"replaceElement imgWidth-100 imgHeight-16rem sm:imgHeight-24rem lg:gridItem-7col img-bgColor\">
            </a>
            <div class=\"innerMargin releaseDate-while lg:gridItem-5col\">
              <h3 class=\"titleSize titleSemibold sm:titleSize group-hover:underline group-focus:underline\">
                $col4
              </h3>
              <span class=\"releaseDate releaseDate-textColor\">$col5</span>
              <p>
                $col6
              </p>
            </div>
          </div>
          <div class=\"grid division-1 gridGap sm:division-2 lg:division-3\">"
      first_string=false
    else
      templates+="
            <div class=\"group hover:no-underline focus:no-underline outerMargin-bgColor\">
              <a href=\"$col1\">
                <img class=\"replaceElement imgWidth-100 imgHeight-11rem img-bgColor\" src=\"$col2\">
              </a>
              <div class=\"innerMargin releaseDate-while\">
                <a href=\"$col3\">
                  <h3 class=\"titleSize titleSemibold group-hover:underline group-focus:underline\">
                    $col4
                  </h3>
                  <span class=\"releaseDate releaseDate-textColor\">$col5</span>
                  <p>
                    $col6
                  </p>
                </a>
              </div>
            </div>"
    fi
  done < "$main_file"
  cd "$dir_name" || exit
  cat << EOF >> "blog.html"
$templates
EOF

  sed -i '' '/^$/d' "blog.html"

  templates+="
          </div>
        </div>
      </section>
    </div>
  </body>
</html>

<style>
  body,html {
    height: 100%;
    background-color: rgb(31 41 55);
  }
</style>"
  templates=$(perl -pe 'chomp if eof' <<< "$templates")
  echo "$templates" | perl -pe 'chomp if eof' > "blog.html"

  css_code=$(
    cat << EOF
*,:before,:after {
  box-sizing: border-box;
  border-width: 0;
  border-style: solid;
  border-color: rgb(229 231 235);
}

html {
  line-height: 1.5;
  -webkit-text-size-adjust: 100%;
  -moz-tab-size: 4;
  tab-size: 4;
  font-family: ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,"Apple Color Emoji","Segoe UI Emoji",Segoe UI Symbol,"Noto Color Emoji";
  font-feature-settings: normal;
  font-variation-settings: normal;
}

body {
  margin: 0;
  line-height: inherit;
}

h3 {
  font-size: inherit;
  font-weight: inherit;
}

a {
  color: inherit;
  text-decoration: inherit;
}

h3,p {
  margin: 0;
}

img {
  display: block;
  vertical-align: middle;
  max-width: 100%;
  height: auto;
}

.outerMargin {
  padding: 1.5rem 1.5rem;
}

.outerMargin-bgColor {
  background-color: rgb(17 24 39);
}

.middleMargin-bgColor {
  background-color: rgb(31 41 55);
}

.middleMargin-textColor {
  color: rgb(243 244 246);
}

.container {
  margin: auto;
  max-width: 100%;
}

.innerMargin {
  padding: 1.5rem;
}

.contentBetween>:not([hidden])~:not([hidden]) {
  margin-top: 1.5rem;
}

.group:hover .group-hover\:underline {
  text-decoration-line: underline;
}

.group:focus .group-focus\:underline {
  text-decoration-line: underline;
}

.replaceElement {
  object-fit: cover;
}

.img-bgColor {
  background-color: rgb(107 114 128);
}

.imgWidth-100 {
  width: 100%;
}

.imgHeight-16rem {
  height: 16rem;
}

.releaseDate-while>:not([hidden])~:not([hidden]) {
  margin-top: .5rem;
  margin-bottom: .5rem;
}

.titleSize {
  font-size: 1.2rem;
  line-height: 2rem;
}

.titleSemibold {
  font-weight: 600;
}

.releaseDate {
  font-size: .75rem;
  line-height: 1rem;
}

.releaseDate-textColor {
  color: rgb(156 163 175);
}

.grid {
  display: grid;
}

.division-1 {
  grid-template-columns: repeat(1, minmax(0, 1fr));
}

.gridGap {
  gap: 1.5rem;
  padding-top: 3rem;
}

.imgHeight-11rem {
  height: 11rem;
}

.underline {
  text-decoration-line: underline;
}

@media (min-width: 640px) {
  .container {
    max-width: 42rem;
  }

  .sm\:contentBetween>:not([hidden])~:not([hidden]) {
    margin-top: 3rem;
  }

  .sm\:gridContainer-12col {
    grid-template-rows: repeat(12, minmax(0, 1fr));
  }

  .sm\:imgWidth-100 {
    max-width: 100%;
  }

  .sm\:imgHeight-24rem {
    height: 24rem;
  }

  .sm\:titleSize {
    font-size: 2.25rem;
    line-height: 2.5rem;
  }

  .sm\:division-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 48rem;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 64rem;
  }

  .lg\:grid {
    display: grid;
  }

  .lg\:gridContainer-12col {
    grid-template-columns: repeat(12, minmax(0, 1fr));
  }

  .lg\:gridItem-7col {
    grid-column: span 7 / span 7;
  }

  .lg\:gridItem-5col {
    grid-column: span 5 / span 5;
  }

  .lg\:division-3 {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 72rem;
  }
}

@media (min-width: 1536px) {
  .container {
    max-width: 72rem;
  }
}
EOF
  )
  css_code=$(perl -pe 'chomp if eof' <<< "$css_code")
  echo "$css_code" | perl -pe 'chomp if eof' >> "blog.css"
}

function html_template_hero () {
  main_file="$current_dir/source_hero.csv"
    if [ "$template" = "hero-sample" ]; then
    cat << EOF > "$main_file"
ページのタイトル名,見出し,コメント等の文章,ボタンクリック後の遷移先のリンク(ファイルパス等),ボタン名1,ボタンクリック後の遷移先のリンク(ファイルパス等),ボタン名2,画像ファイルのリンク(ファイルパス等)
hero-sample,Lorem ipsum,Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.,,Starts,,Others,
EOF
  elif [ ! -e "$main_file" ] || [ ! -f "$main_file" ]; then
    echo -e "\033[1;31mERROR: ソースファイルが存在しない、またはパスの指定に誤りがあります。対象のファイルを $current_dir に生成します。\033[0m"
    cat << EOF > "$main_file"
ページのタイトル名,見出し,コメント等の文章,ボタンクリック後の遷移先のリンク(ファイルパス等),ボタン名1,ボタンクリック後の遷移先のリンク(ファイルパス等),ボタン名2,画像ファイルのリンク(ファイルパス等)
,,,,,,,
EOF
    exit 1
  else
    echo -e "\033[1;32mSUCCESS: ソースファイル $main_file は有効です。\033[0m"
  fi

  mkdir "$dir_name"
  sed -i '' '1d' "$main_file"
  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 || [[ -n $col8 ]]; do
    templates+="<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"UTF-8\">
    <title>$col1</title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"./hero.css\">
  </head>
  <body>
    <div class=\"fixed margin-0 outerMargin-top sm:outerMargin md:outerMargin outerMargin-bgColor\"> <!-- outerMargin-top の後ろに overflow-y-auto ※追加するとスクロール可能になる -->
      <div class=\"margin-bgColor\">
        <div class=\"container flex flex-col buttonCenter contentPosition contentCenter outerMargin-top imgPosition textCenter md:imgPosition lg:imgPosition md:contentPosition lg:contentPosition textColor\">
          <h1 class=\"titleSize sm:titleSize titleSemibold textColor\">
            $col2
          </h1>
          <p class=\"comment-while sm:comment-while textSize xl:textWidth textColor\">
            $col3
          </p>
          <div class=\"flex\">
            <button type=\"button\" onclick=\"location.href='$col4'\" class=\"buttonMargin textSize fontSemibold roundedCorner botton-bgColor textColor-inversion\">
              $col5
            </button>
            <button type=\"button\" onclick=\"location.href='$col6'\" class=\"buttonMargin textSize border roundedCorner textColor\">
              $col7
            </button>
          </div>
        </div>
      </div>
      <img src=\"$col8\" alt=\"\" class=\"imgWidth contentCenter imgPosition-top lg:imgPosition-top imgRoundedCorner\">
    </div>
  </body>
</html>

<style>
  body,html {
    height: 100%;
    background-color: rgb(31 41 55);
  }
</style>"
  done < "$main_file"
  cd "$dir_name" || exit
  templates=$(perl -pe 'chomp if eof' <<< "$templates")
  echo "$templates" | perl -pe 'chomp if eof' >> "hero.html"

  css_code=$(
    cat << EOF
*,:before,:after {
  box-sizing: border-box;
  border-width: 0;
  border-style: solid;
  border-color: rgb(229 231 235);
}

html {
  line-height: 1.5;
  -webkit-text-size-adjust: 100%;
  -moz-tab-size: 4;
  tab-size: 4;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", Segoe UI Symbol, "Noto Color Emoji";
  font-feature-settings: normal;
  font-variation-settings: normal;
}

body {
  margin: 0;
  line-height: inherit;
}

h1 {
  font-size: inherit;
  font-weight: inherit;
}

a {
  color: inherit;
  text-decoration: inherit;
}

.fixed {
  position: fixed;
}

.margin-0 {
  inset: 0;
}

.outerMargin-top {
  padding-top: 1.5rem;
  padding-bottom: 4rem;
}

.outerMargin {
  padding-left: 1.5rem;
  padding-right: 1.5rem;
}

.outerMargin-bgColor {
  background-color: rgb(17 24 39);
}

.margin-bgColor {
  background-color: rgb(167 139 250);
}

.container {
  width: 100%;
  margin-right: auto;
  margin-left: auto;
}

.flex {
  display: flex;
}

.flex-col {
  flex-direction: column; /* 積み重なるように配置 */
}

.buttonCenter {
  align-items: center;
}

.contentPosition {
  padding-left: 1rem;
  padding-right: 1rem;
}

.contentCenter {
  margin-left: auto;
  margin-right: auto;
}

.imgPosition {
  padding-bottom: 8rem;
}

.textCenter {
  text-align: center;
}

.textColor {
  color: rgb(17 24 39);
}

.textColor-inversion {
  color: rgb(249 250 251);
}

h1 {
  margin: 0;
}

.titleSize {
  font-size: 3rem;
  line-height: 1;
}

.titleSemibold {
  font-weight: 700;
}

.comment-while {
  margin-top: 1.5rem;
  margin-bottom: 2rem;
}

.textSize {
  font-size: 1.125rem;
  line-height: 1.75rem;
}

button {
  font-family: inherit;
  font-size: 100%;
  font-weight: inherit;
  line-height: inherit;
  color: inherit;
  margin: 0;
  padding: 0;
  text-transform: none;
}

button,[type=button] {
  -webkit-appearance: button;
  background-color: transparent;
  background-image: none;
}

.buttonMargin {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 2rem;
  padding-right: 2rem;
  margin: 0.5rem;
}

.fontSemibold {
  font-weight: 600;
}

.roundedCorner {
  border-radius: 0.25rem;
}

.botton-bgColor {
  background-color: rgb(31 41 55);
}

.border {
  border-width: 1px;
}

img {
  display: block;
  vertical-align: middle;
  max-width: 100%;
  height: auto;
}

.imgWidth {
  width: 85%;
}

.imgPosition-top {
  margin-top: -5rem;
}

.imgRoundedCorner {
  border-radius: .5rem;
}

[hidden] {
  display: none;
}

@media (max-width: 640px) { /* レスポンシブ対応コード(スマホサイズ) */
  .sm\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }
}

@media (min-width: 640px) {
  .container {
    max-width: 640px;
  }

  .sm\:titleSize {
    font-size: 3.75rem;
    line-height: 1;
  }

  .sm\:comment-while {
    margin-top: 2rem;
    margin-bottom: 2rem;
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 768px;
  }

  .md\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .md\:imgPosition {
    padding-top: 8rem;
    padding-bottom: 8rem;
  }

  .md\:contentPosition {
    padding-left: 2.5rem;
    padding-right: 2.5rem;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 1024px;
  }

  .lg\:imgPosition {
    padding-bottom: 14rem;
  }

  .lg\:contentPosition {
    padding-left: 8rem;
    padding-right: 8rem;
  }

  .lg\:imgPosition-top {
    margin-top: -10rem;
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 1280px;
  }

  .xl\:textWidth {
    max-width: 50rem;
  }
}

@media (min-width: 1536px) {
  .container {
    max-width: 1536px;
  }
}
EOF
  )
  css_code=$(perl -pe 'chomp if eof' <<< "$css_code")
  echo "$css_code" | perl -pe 'chomp if eof' >> "hero.css"
}

function html_template_table () {
  main_file="$current_dir/source_table.csv"
  if [ "$template" = "table-sample" ]; then
    cat << EOF > "$main_file"
番号 ※一行目の場合は「ページのタイトル名」,名前 ※一行目の場合は「番号が入ることを示す記号(#)等」(推奨),日付 ※一行目の場合は「名称等」(推奨),曜日 ※一行目の場合は「開始日等」(推奨),日付 ※一行目の場合は「期限日等」(推奨),曜日 ※一行目の場合は「数値が入ることを示す名称」(推奨),金額等の数値 ※一行目の場合は「ステータス」(推奨),ステータス名
table-sample,sample,#,column,start date,End date,value,status
1,Lorem ipsum,January 1 2024,Monday,January 31 2024,Sunday,0,Enable
2,Lorem ipsum,January 1 2024,Monday,January 31 2024,Sunday,0,Enable
3,Lorem ipsum,January 1 2024,Monday,January 31 2024,Sunday,0,Enable
4,Lorem ipsum,January 1 2024,Monday,January 31 2024,Sunday,0,Enable
5,Lorem ipsum,January 1 2024,Monday,January 31 2024,Sunday,0,Enable
EOF
  elif [ ! -e "$main_file" ] || [ ! -f "$main_file" ]; then
    echo -e "\033[1;31mERROR: ソースファイルが存在しない、またはパスの指定に誤りがあります。対象のファイルを $current_dir に生成します。\033[0m"
    cat << EOF > "$main_file"
番号 ※一行目の場合は「ページのタイトル名」,名前 ※一行目の場合は「番号が入ることを示す記号(#)等」(推奨),日付 ※一行目の場合は「名称等」(推奨),曜日 ※一行目の場合は「開始日等」(推奨),日付 ※一行目の場合は「期限日等」(推奨),曜日 ※一行目の場合は「数値が入ることを示す名称」(推奨),金額等の数値 ※一行目の場合は「ステータス」(推奨),ステータス名
,,,,,,,
,,,,,,,
,,,,,,,
,,,,,,,
,,,,,,,
EOF
    exit 1
  else
    echo -e "\033[1;32mSUCCESS: ソースファイル $main_file は有効です。\033[0m"
  fi

  mkdir "$dir_name"
  sed -i '' '1d' "$main_file"
  first_string=true
  while IFS=, read -r col1 col2 col3 col4 col5 col6 col7 col8 || [[ -n $col8 ]]; do
    if $first_string; then
      templates=$(
        cat << EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>$col1</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./table.css">
  </head>
  <body>
    <div class="fixed margin-0 outerMargin-top makeScrollable outerMargin md:outerMargin overscroll-contain bgColor bgColor-opacity">
      <div class="mx-auto">
        <div class="container mx-auto sm:tableMargin textColor">
          <h2 class="title-while titleSize fontSemibold">$col2</h2>
          <div class="makeScrollable">
            <table class="table-minWidth100 table-textSize">
              <colgroup>
                <col>
                <col>
                <col>
                <col>
                <col>
                <col class="last-colWidth">
              </colgroup>
              <thead class="thead-bgColor">
                <tr class="tr-textLeft">
                  <th class="cellSize">$col3</th>
                  <th class="cellSize">$col4</th>
                  <th class="cellSize">$col5</th>
                  <th class="cellSize">$col6</th>
                  <th class="cellSize th-textRight">$col7</th>
                  <th class="cellSize">$col8</th>
                </tr>
              </thead>
              <tbody>
EOF
      )
      templates=$(perl -pe 'chomp if eof' <<< "$templates")
      echo "$templates" | perl -pe 'chomp if eof' >> "table.html"
      first_string=false
    else
      templates+="
                <tr class=\"borderLine borderColor bgColor\">
                  <td class=\"cellSize\">
                    <p>$col1</p>
                  </td>
                  <td class=\"cellSize\">
					          <p>$col2</p>
                  </td>
                  <td class=\"cellSize\">
                    <p>$col3</p>
                    <p class=\"dayOfWeek\">$col4</p>
                  </td>
                  <td class=\"cellSize\">
                    <p>$col5</p>
                    <p class=\"dayOfWeek\">$col6</p>
                  </td>
                  <td class=\"cellSize th-textRight\">
                    <p>$col7</p>
                  </td>
                  <td class=\"cellSize th-textRight\">
                    <span class=\"fontSemibold roundedCorner statusBatch statusBatch-bgColor statusBatch-textColor\">
                      <span>$col8</span>
                    </span>
                  </td>
                </tr>"
    fi
      cat << EOF >> "table.html"
$templates
EOF
  done < "$main_file"
  cd "$dir_name" || exit

  sed -i '' '/^$/d' "table.html"

  templates+="
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>

<style>
  body,html {
    height: 100%;
    background-color: rgb(31 41 55);
  }
</style>"
  templates=$(perl -pe 'chomp if eof' <<< "$templates")
  echo "$templates" | perl -pe 'chomp if eof' >> "table.html"

  css_code=$(
    cat << EOF
*,:before,:after {
  box-sizing: border-box;
  border-width: 0;
  border-style: solid;
  border-color: rgb(229 231 235);
}

html {
  line-height: 1.5;
  -webkit-text-size-adjust: 100%;
  -moz-tab-size: 4;
  tab-size: 4;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", Segoe UI Symbol, "Noto Color Emoji";
  font-feature-settings: normal;
  font-variation-settings: normal;
}

body {
  margin: 0;
  line-height: inherit;
}

.fixed {
  position: fixed;
}

.margin-0 {
  inset: 0;
}

.outerMargin-top {
  padding-top: 4rem;
}

.makeScrollable {
  overflow-x: auto;
  overflow-y: auto;
}

.outerMargin {
  padding-left: 0.5rem;
  padding-right: 0.5rem;
}

.overscroll-contain { /* スクロール領域の境界に達した時にブラウザーが何をするかの設定 */
  overscroll-behavior: contain;
}

.bgColor {
  --tw-bg-opacity: 1;
  background-color: rgb(17 24 39 / var(--tw-bg-opacity));
}

.bgColor-opacity {
  --tw-bg-opacity: 0.5;
}

.textColor {
  --tw-text-opacity: 1;
  color: rgb(243 244 246 / var(--tw-text-opacity));
}

h2 {
  font-size: inherit;
  font-weight: inherit;
}

h2,p {
  margin: 0;
}

.title-while {
  margin-bottom: 1rem;
}

.titleSize {
  font-size: 1.5rem;
  line-height: 2rem;
}

.fontSemibold {
  font-weight: 600;
}

table {
  text-indent: 0;
  border-color: inherit;
  border-collapse: collapse;
}

.table-minWidth100 {
  min-width: 100%;
}

.table-textSize {
  font-size: 0.75rem;
  line-height: 1rem;
}

.last-colWidth {
  width: 6rem;
}

.thead-bgColor {
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity));
}

.tr-textLeft {
  text-align: left;
}

.cellSize {
  padding: 0.75rem;
}

.dayOfWeek {
  color: rgb(156 163 175);
}

.th-textRight {
  text-align: right;
}

.borderLine {
  border-bottom-width: 1px;
}

.borderColor {
  border-color: rgb(55 65 81);
}

.roundedCorner {
  border-radius: 0.375rem;
}

.statusBatch {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  padding-left: 0.75rem;
  padding-right: 0.75rem;
}

.statusBatch-bgColor {
  background-color: rgb(167 139 250);
}

.statusBatch-textColor {
  color: rgb(17 24 39);
}

@media (min-width: 640px) {
  .sm\:tableMargin {
    padding: 1rem;
  }
}

@media (min-width: 768px) {
  .md\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }
}

@media (min-width: 1024px) {
}

@media (min-width: 1280px) {
}

@media (min-width: 1536px) {
}
EOF
  )
  css_code=$(perl -pe 'chomp if eof' <<< "$css_code")
  echo "$css_code" | perl -pe 'chomp if eof' >> "table.css"
}

function html_template_404 () {
  mkdir "$dir_name"
  templates+="<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"UTF-8\">
    <title>404 Not Found</title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"./404.css\">
  </head>
  <body>
    <div class=\"fixed margin-0 outerMargin-top makeScrollable sm:outerMargin md:outerMargin overscroll-contain bgColor bgColor-opacity\">
      <section class=\"flex buttonCenter innerMargin bgColor sryMsg\">
        <div class=\"container flex flex-col buttonCenter comment-while\">
          <div class=\"text-maxWidth28 textCenter\">
            <h2 class=\"title-while fontExtrabold titleSize titleColor\">
              <span class=\"sry-only\">Error</span>404
            </h2>
            <p class=\"sryMsgSize fontSemibold md:sryMsgSize\">
              Sorry, we couldn't find this page.
            </p>
            <p class=\"msg-top title-while textColor\">
              But dont worry, you can find plenty of other things on our homepage.
            </p>
            <a href=\"\" class=\"buttonMargin fontSemibold roundedCorner button-bgColor textColor-inversion\">
              Back to homepage
            </a>
          </div>
        </div>
      </section>
    </div>
  </body>
</html>

<style>
  body,html {
    height: 100%;
    background-color: rgb(31 41 55);
  }
</style>"
  cd "$dir_name" || exit
  cat << EOF > "404.html"
$templates
EOF

  css_code=$(
    cat << EOF
*,:before,:after {
  box-sizing: border-box;
  border-width: 0;
  border-style: solid;
  border-color: rgb(229 231 235);
}

html {
  line-height: 1.5;
  -webkit-text-size-adjust: 100%;
  -moz-tab-size: 4;
  tab-size: 4;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", Segoe UI Symbol, "Noto Color Emoji";
  font-feature-settings: normal;
  font-variation-settings: normal;
}

body {
  margin: 0;
  line-height: inherit;
}

a {
  color: inherit;
  text-decoration: inherit;
}

button {
  font-family: inherit;
  font-size: 100%;
  font-weight: inherit;
  line-height: inherit;
  color: inherit;
  margin: 0;
  padding: 0;
  text-transform: none;
}

button,[type=button] {
  -webkit-appearance: button;
  background-color: transparent;
  background-image: none;
}

.fixed {
  position: fixed;
}

.margin-0 {
  inset: 0;
}

.outerMargin-top {
  padding-top: 4rem;
}

.makeScrollable {
  overflow-y: auto;
}

.overscroll-contain { /* スクロール領域の境界に達した時にブラウザーが何をするかの設定 */
  overscroll-behavior: contain;
}

.bgColor {
  --tw-bg-opacity: 1;
  background-color: rgb(17 24 39 / var(--tw-bg-opacity));
}

.bgColor-opacity {
  --tw-bg-opacity: 0.5;
}

.flex {
  display: flex;
}

.buttonCenter {
  align-items: center;
}

.innerMargin {
  padding: 4rem;
}

.sryMsg {
  --tw-text-opacity: 1;
  color: rgb(243 244 246 / var(--tw-text-opacity));
}

.container {
  margin: auto;
  max-width: 100%;
}

.flex-col {
  flex-direction: column;  /* 積み重なるように配置 */
}

.text-maxWidth28 {
  max-width: 28rem;
}

.textCenter {
  text-align: center;
}

h2 {
  font-size: inherit;
  font-weight: inherit;
}

h2,p {
  margin: 0;
}

.title-while {
  margin-bottom: 2rem;
}

.fontExtrabold {
  font-weight: 800;
}

.titleSize {
  font-size: 8rem;
  line-height: 1;
}

.titleColor {
  --tw-text-opacity: 1;
  color: rgb(75 85 99 / var(--tw-text-opacity));
}

.sry-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.sryMsgSize {
  font-size: 1.5rem;
  line-height: 2rem;
}

.fontSemibold {
  font-weight: 600;
}

.msg-top {
  margin-top: 1rem;
}

.textColor {
  --tw-text-opacity: 1;
  color: rgb(156 163 175 / var(--tw-text-opacity));
}

.buttonMargin {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 2rem;
  padding-right: 2rem;
}

.roundedCorner {
  border-radius: 0.25rem;
}

.button-bgColor {
  --tw-bg-opacity: 1;
  background-color: rgb(167 139 250 / var(--tw-bg-opacity));
}

.textColor-inversion {
  --tw-text-opacity: 1;
  color: rgb(17 24 39 / var(--tw-text-opacity));
}

@media (min-width: 640px) {
  .container {
    max-width: 42rem;
  }

  .sm\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 48rem;
  }

  .md\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .md\:sryMsgSize {
    font-size: 1.875rem;
    line-height: 2.25rem;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 64rem;
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 72rem;
  }
}

@media (min-width: 1536px) {
  .container {
    max-width: 72rem;
  }
}
EOF
  )
  css_code=$(perl -pe 'chomp if eof' <<< "$css_code")
  echo "$css_code" | perl -pe 'chomp if eof' > "404.css"
}

function html_template_timeline () {
  main_file="$current_dir/source_timeline.csv"
  if [ "$template" = "timeline-sample" ]; then
    cat << EOF > "$main_file"
タイトル名 ※一行目の場合は「ページのタイトル名」,日付 ※一行目の場合は「メインタイトル名」,コメント等の文章 ※一行目の場合は「サブタイトル名等」
timeline-sample,Lorem ipsum,Lorem ipsum
Lorem ipsum,January 4 2024,Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Lorem ipsum,January 3 2024,Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Lorem ipsum,January 2 2024,Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Lorem ipsum,January 1 2024,Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
EOF
  elif [ ! -e "$main_file" ] || [ ! -f "$main_file" ]; then
    echo -e "\033[1;31mERROR: ソースファイルが存在しない、またはパスの指定に誤りがあります。対象のファイルを $current_dir に生成します。\033[0m"
    cat << EOF > "$main_file"
タイトル名 ※一行目の場合は「ページのタイトル名」,日付 ※一行目の場合は「メインタイトル名」,コメント等の文章 ※一行目の場合は「サブタイトル名等」
,,
,,
,,
,,
,,
EOF
    exit 1
  else
    echo -e "\033[1;32mSUCCESS: ソースファイル $main_file は有効です。\033[0m"
  fi

  mkdir "$dir_name"
  sed -i '' '1d' "$main_file"
  first_string=true
  while IFS=, read -r col1 col2 col3 || [[ -n $col3 ]]; do
    if $first_string; then
      templates=$(
        cat << EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>$col1</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./timeline.css">
  </head>
  <body>
    <div class="fixed margin-0 outerMargin µ:outerMargin md:outerMargin outerMargin-top µ:outerMargin-top sm:outerMargin-top makeScrollable overscroll-contain outerMargin-bgColor bgColor-opacity">
      <div class="mx-auto">
        <section class="innerMargin-bgColor innerMargin-textColor">
          <div class="container innerMargin mx-auto">
            <div class="grid gridGap contentCenter µ:gridContainer-12col">
              <div class="gridItem-12col md:gridItem-3col">
                <div class="µ:textCenter sm:textCenter md:textLeft subTitle-while before:block before:stick before:stick-while before:roundedCorner µ:before:mx-auto sm:before:mx-auto md:before:mx-auto md:before:mx-0 before:circle-color">
                  <h3 class="main-titleSize fontSemibold">$col2</h3>
                  <span class="sub-titleSize fontBold textSpace uppercase releaseDate-textColor">
                    $col3
                  </span>
                </div>
              </div>
              <div class="ObjectFixation µ:ObjectFixation sm:ObjectFixation gridItem-12col sm:gridItem-12col contentPosition md:gridItem-9">
                <div class="gridItem-12col content-while µ:ObjectFixation sm:ObjectFixation contentPosition µ:before:horizontal-line sm:before:horizontal-line µ:before:circleTop sm:before:circleTop  before:horizontal-line-color">
EOF
      )
      templates=$(perl -pe 'chomp if eof' <<< "$templates")
      echo "$templates" | perl -pe 'chomp if eof' >> "timeline.html"
      first_string=false
    else
      templates+="
                  <div class=\"flex flex-col ObjectFixation sm:ObjectFixation µ:ObjectFixation µ:before:horizontal-line sm:before:horizontal-line µ:before:circleTop sm:before:circleTop µ:before:circle sm:before:circle µ:before:circleLeft-[-35px] sm:before:circleLeft-[-35px] before:circleTop before:circle-color\">
                    <h3 class=\"titleSize fontSemibold textSpace\">
                      $col1
                    </h3>
                    <time class=\"releaseDate textSpace uppercase releaseDate-textColor\">
                      $col2
                    </time>
                    <p class=\"comment-while\">
                      $col3
                    </p>
                  </div>"
    fi
      cat << EOF >> "timeline.html"
$templates
EOF
  done < "$main_file"
  cd "$dir_name" || exit

  sed -i '' '/^$/d' "timeline.html"

  templates+="
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </body>
</html>

<style>
  body,html {
    height: 100%;
    background-color: rgb(31 41 55);
  }
</style>"
  templates=$(perl -pe 'chomp if eof' <<< "$templates")
  echo "$templates" | perl -pe 'chomp if eof' >> "timeline.html"

  css_code=$(
    cat << EOF
*,:before,:after {
  box-sizing: border-box;
  border-width: 0;
  border-style: solid;
  border-color: rgb(229 231 235);
}

:before,:after {
  --tw-content: "";
}

html {
  line-height: 1.5;
  -webkit-text-size-adjust: 100%;
  -moz-tab-size: 4;
  tab-size: 4;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", Segoe UI Symbol, "Noto Color Emoji";
  font-feature-settings: normal;
  font-variation-settings: normal;
}

body {
  margin: 0;
  line-height: inherit;
}

h3 {
  font-size: inherit;
  font-weight: inherit;
}

h3,p {
  margin: 0;
}

.fixed {
  position: fixed;
}

.margin-0 {
  inset: 0;
}

.outerMargin {
  padding-left: 1.5rem;
  padding-right: 1.5rem;
}

.outerMargin-top {
  padding-top: 4rem;
  padding-bottom: 4rem;
}

.makeScrollable {
  overflow-y: auto;
}

.overscroll-contain { /* スクロール領域の境界に達した時にブラウザーが何をするかの設定 */
  overscroll-behavior: contain;
}

.outerMargin-bgColor {
  background-color: rgb(17 24 39);
}

.bgColor-opacity {
  --tw-bg-opacity: 0.5;
}

.mx-auto {
  margin-left: auto;
  margin-right: auto;
}

.innerMargin-bgColor {
  background-color: rgb(31 41 55);
}

.innerMargin-textColor {
  --tw-text-opacity: 1;
  color: rgb(243 244 246 / var(--tw-text-opacity));
}

.container {
  margin: auto;
  max-width: 100%;
}

.innerMargin {
  padding-top: 3rem;
  padding-bottom: 3rem;
  padding-left: 1rem;
  padding-right: 1rem;
}

.grid {
  display: grid;
}

.gridGap {
  gap: 1rem;
}

.contentCenter {
  margin-left: 1rem;
  margin-right: 1rem;
}

.gridItem-12col {
  grid-column: span 12 / span 12; /* グリッドアイテム(左記の値がHTMLで適用された要素)が12列分の幅を占める */
}

.subTitle-while {
  margin-bottom: 1.5rem;
}

.before\:block:before {
  display: block;
}

.before\:stick:before {
  width: 6rem;
  height: 0.75rem;
}

.before\:stick-while:before {
  content: var(--tw-content);
  margin-bottom: 1.25rem;
  align-items: center;
}

.before\:roundedCorner:before {
  content: var(--tw-content);
  border-radius: 0.375rem;
}

.before\:mx-auto:before {
  content: var(--tw-content);
  margin-left: auto;
  margin-right: auto;
}

.before\:circle-color:before {
  content: var(--tw-content);
  --tw-bg-opacity: 1;
  background-color: rgb(167 139 250 / var(--tw-bg-opacity));
}

.main-titleSize {
  font-size: 1.875rem;
  line-height: 2.25rem;
}

.titleSize {
  font-size: 1.25rem;
  line-height: 1.75rem;
}

.fontSemibold {
  font-weight: 600;
}

.sub-titleSize {
  font-size: 0.875rem;
  line-height: 1.25rem;
}

.fontBold {
  font-weight: 700;
}

.textSpace {
  letter-spacing: 0.025em;
}

.uppercase {
  text-transform: uppercase;
}

.releaseDate-textColor {
  color: rgb(156 163 175);
}

.contentPosition {
  padding-left: 1rem;
}

.comment-while {
  margin-top: 0.75rem;
}

.before\:horizontal-line-color:before {
  content: var(--tw-content);
  --tw-bg-opacity: 1;
  background-color: rgb(55 65 81 / var(--tw-bg-opacity));
}

.flex {
  display: flex;
}

.flex-col {
  flex-direction: column;
}

.releaseDate {
  font-size: 0.75rem;
  line-height: 1rem;
}

.content-while>:not([hidden])~:not([hidden]) {
  --tw-space-y-reverse: 0;
  margin-top: calc(3rem * calc(1 - var(--tw-space-y-reverse)));
  margin-bottom: calc(3rem * var(--tw-space-y-reverse));
}

@media (min-width: 0px) {
  .µ\:gridContainer-12col {
    grid-template-columns: repeat(12, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .µ\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .µ\:outerMargin-top {
    padding-top: 2rem;
    padding-bottom: 2rem;
  }

  .µ\:gridContainer-12col {
    grid-template-columns: repeat(12, minmax(0, 1fr));
  }

  .µ\:textCenter {
    text-align: center;
  }

  .µ\:ObjectFixation {
    position: relative;
  }

  .µ\:before\:mx-auto:before {
    content: var(--tw-content);
    margin-left: auto;
    margin-right: auto;
  }

  .µ\:before\:horizontal-line:before {
    position: absolute;
    left: -0.75rem;
    bottom: 0;
    width: 0.125rem;
  }

  .µ\:before\:circleTop:before {
    top: 0.4rem;
  }

  .µ\:before\:circle:before {
    border-radius: 9999px;
    height: 1rem;
    width: 1rem;
  }

  .µ\:before\:circleLeft-\[-35px\]:before {
    left: -35px;
  }
}

@media (min-width: 640px) {
  .container {
    max-width: 42rem;
  }

  .sm\:outerMargin-top {
    padding-top: 2rem;
    padding-bottom: 2rem;
  }

  .sm\:textCenter {
    text-align: center;
  }

  .sm\:ObjectFixation {
    position: relative;
  }

  .sm\:before\:mx-auto:before {
    content: var(--tw-content);
    margin-left: auto;
    margin-right: auto;
  }

  .sm\:gridItem-12col {
    grid-column: span 12 / span 12; /* グリッドアイテム(左記の値がHTMLで適用された要素)が12列分の幅を占める */
  }

  .sm\:before\:horizontal-line:before {
    position: absolute;
    left: -0.75rem;
    bottom: 0;
    width: 0.125rem;
  }

  .sm\:before\:circleTop:before {
    top: 0.35rem;
  }

  .sm\:before\:circle:before {
    border-radius: 9999px;
    height: 1rem;
    width: 1rem;
  }

  .sm\:before\:circleLeft-\[-35px\]:before {
    left: -35px;
  }
}

@media (min-width: 768px) {
  .container {
    max-width: 48rem;
  }

  .md\:outerMargin {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }

  .md\:gridItem-3col {
    grid-column: span 3 / span 3;
  }

  .md\:textLeft {
    text-align: left;
  }

  .md\:before\:mx-auto:before {
    content: var(--tw-content);
    margin-right: auto;
  }

  .md\:before\:mx-0:before {
    margin-left: 0;
    margin-right: 0;
  }

  .md\:gridItem-9 {
    grid-column: span 9 / span 9;
  }
}

@media (min-width: 1024px) {
  .container {
    max-width: 64rem;
  }
}

@media (min-width: 1280px) {
  .container {
    max-width: 72rem;
  }
}

@media (min-width: 1536px) {
  .container {
    max-width: 72rem;
  }
}
EOF
  )
  css_code=$(perl -pe 'chomp if eof' <<< "$css_code")
  echo "$css_code" | perl -pe 'chomp if eof' >> "timeline.css"
}

templateList=$(
  cat << EOF
> blog
> hero
> table
> 404
> timeline
EOF
)
echo -e "\033[1;36m$templateList\033[0m"
echo
while true; do
  read -p "上記から HTML テンプレートを選択して下さい(末尾に\"-sample\"追加でサンプルHTML生成): " template
  case $template in
    blog*)
      html_template_blog
      success_msg
      break
    ;;
    hero*)
      html_template_hero
      success_msg
      break
    ;;
    table*)
      html_template_table
      success_msg
      break
    ;;
    404*)
      html_template_404
      success_msg
      break
    ;;
    timeline*)
      html_template_timeline
      success_msg
      break
    ;;
    exit)
      break
    ;;
    *)
      echo -e "\033[1;31mERROR: そのような HTML テンプレートは存在しません(終了する場合は「exit」を入力)\033[0m"
      echo
      continue
    ;;
  esac
done
