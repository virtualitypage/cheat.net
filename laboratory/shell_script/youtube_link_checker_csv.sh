#!/bin/bash

# 動画リンクを含むCSVファイルのパス
csv_file="youtube.csv"

# 判定結果を保存するCSVファイルのパス
output_file="youtube_results.csv"

# SlackのAPIトークンとチャンネル名
slack_token=""
channel="#youtube-valid"

# CSVファイルの存在チェック
if [[ ! -f "$csv_file" ]]; then
    echo -e "\033[1;31mERROR: $csv_file が存在しません。$csv_file の所在を明らかにして再度実行してください。\033[0m"
    exit 1
fi

# 空の判定結果ファイルを作成
echo "link,result" > "$output_file"

# CSVファイルからリンクを読み込んで判定
while IFS=',' read -r link other_columns || [[ -n "$link" ]]
do
    # リンクがYouTubeの動画リンクかどうかを確認
    if [[ $link == *"youtube.com"* ]]; then
        # YouTube動画リンクの場合、curlコマンドでリンク先のHTTPステータスコードを取得
        status_code=$(curl -sL -w "%{http_code}" "$link" -o /dev/null)

        if [[ $status_code == "200" ]]; then
            # ステータスコードが200の場合はリンクが有効
            # さらにYouTubeのページから再生不可能なメッセージを確認
            if curl -sL "$link" | grep -q "この動画は再生できません"; then
                echo "$link,404" >> "$output_file"
            else
                echo "$link,200" >> "$output_file"
            fi
        elif [[ $status_code == "302" ]]; then
            # ステータスコードが302の場合は非公開
            echo "$link,302" >> "$output_file"
        else
            # その他のステータスコードは不明
            echo "$link,Unknown status" >> "$output_file"
        fi
    else
        # YouTubeの動画リンクではない場合は無効なリンクとして判定
        echo "$link,Invalid link" >> "$output_file"
    fi
done < "$csv_file"

# 判定結果ファイルをSlackに送信する関数
send_to_slack() {
    local file_path=$1
    local file_name=$(basename "$file_path")

    # Slackへのファイルアップロードリクエストを作成
    response=$(curl -F file=@"$file_path" \
                    -F channels="$channel" \
                    -H "Authorization: Bearer $slack_token" \
                    https://slack.com/api/files.upload)

    # レスポンスから成功かどうかを判定
    success=$(echo "$response" | jq -r '.ok')
    if [[ $success == "true" ]]; then
        echo "File '$file_name' uploaded to Slack successfully."
    else
        error=$(echo "$response" | jq -r '.error')
        echo "Failed to upload file to Slack. Error: $error"
    fi
}

# 判定結果ファイルをSlackに送信
send_to_slack "$output_file"