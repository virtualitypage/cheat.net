function perfectSetting() {
  initializeTrigger();
  createTrigger();
}

function LineDeveloperMessage() {
  var channelAccessToken = "----CHANNEL_ACCESS_TOKEN-----";
  var groupId = "-----GROUP_ID-----";

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var message = {
    "type": "template",
    "altText": "【定期配信】告知代行 - 防犯カメラ関連",
    "template": {
      "type": "confirm",
      "text": "告知代行 - 防犯カメラ関連",
      "actions": [
        {
          "type": "message",
          "label": "データ回収",
          "text": "str.integer[0]"
        },
        {
          "type": "message",
          "label": "電池交換",
          "text": "str.integer[1]"
        }
      ]
    }
  };

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify({
      "to": groupId,
      "messages": [message]
    })
  };

  var response = UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
  Logger.log(response.getContentText());
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  ScriptApp.newTrigger('initializeTrigger').timeBased().onWeekDay(ScriptApp.WeekDay.SUNDAY).atHour(0).create();
  console.log("initializeTrigger(): 初期化トリガーを作成しました");
}

function createTrigger() {
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'LineDeveloperMessage') { // 使用済み・不要なLineDeveloperMessageトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger("LineDeveloperMessage").timeBased().onWeekDay(ScriptApp.WeekDay.MONDAY).atHour(0).create();
  ScriptApp.newTrigger("LineDeveloperMessage").timeBased().onWeekDay(ScriptApp.WeekDay.WEDNESDAY).atHour(0).create();
  ScriptApp.newTrigger("LineDeveloperMessage").timeBased().onWeekDay(ScriptApp.WeekDay.FRIDAY).atHour(0).create();
  console.log("createTrigger(): LineDeveloperMessage実行トリガーを作成しました");
}