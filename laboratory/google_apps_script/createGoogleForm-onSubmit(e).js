// LINE Notify のアクセストークン
var LINE_NOTIFY_ACCESS_TOKEN = "----ACCESS_TOKEN-----";

// フォーム送信時に実行される関数
function onFormSubmit(e) {
  var response = e.response; // フォームの回答データ
  var itemResponses = response.getItemResponses(); // 回答項目の情報

  // LINE に送信するメッセージの作成
  var message = "-----MESSAGE-----\n\n";
  for (var i = 0; i < itemResponses.length; i++) {
    var question = itemResponses[i].getItem().getTitle();
    var answer = itemResponses[i].getResponse();
    message += question + ": " + answer;

    if (i < itemResponses.length - 1) { // 最終行でなければ改行を追加
      message += "\n\n";
    }
  }

  // LINE Notify にメッセージを送信する
  sendLineNotify(message);
}

// LINE Notify にメッセージを送信する関数
function sendLineNotify(message) {
  var url = "https://notify-api.line.me/api/notify";
  var headers = {
    "Authorization": "Bearer " + LINE_NOTIFY_ACCESS_TOKEN,
  };
  var payload = {
    "method": "post",
    "headers": headers,
    "muteHttpExceptions": true,
    "payload": {
      "message": message,
    },
  };

  // HTTP リクエストを送信
  var response = UrlFetchApp.fetch(url, payload);
}