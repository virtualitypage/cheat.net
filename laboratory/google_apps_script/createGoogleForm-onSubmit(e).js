function onFormSubmit(e) {// フォーム送信時に実行される関数
  var response = e.response; // フォームの回答データ
  var itemResponses = response.getItemResponses(); // 回答項目の情報
  var message = "-----MESSAGE-----\n\n"; // LINEに送信するメッセージの作成

  for (var i = 0; i < itemResponses.length; i++) {
    var question = itemResponses[i].getItem().getTitle();
    var answer = itemResponses[i].getResponse();
    message += question + ": " + answer;
    if (i < itemResponses.length - 1) { // 最終行でなければ改行を追加
      message += "\n\n";
    }
  }
  sendLineNotify(message); // LINE Notifyにメッセージを送信する
}

function sendLineNotify(message) { // LINE Notifyにメッセージを送信する関数
  var LINE_NOTIFY_ACCESS_TOKEN = "----ACCESS_TOKEN-----"; // LINE Notifyのアクセストークン
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
  var response = UrlFetchApp.fetch(url, payload); // HTTPリクエストを送信
}