function perfectSetting() {
  initializeTrigger();
  createTrigger();
}

function LineDeveloperMessage() {
  var channelAccessToken = "----CHANNEL_ACCESS_TOKEN-----";
  var groupId = "-----GROUP_ID-----";

  var date = new Date();

  var dayOfweek = '';
  switch(date.getDay()){
    case 0: dayOfweek = '日';
    break;
    case 1: dayOfweek = '月';
    break;
    case 2: dayOfweek = '火';
    break;
    case 3: dayOfweek = '水';
    break;
    case 4: dayOfweek = '木';
    break;
    case 5: dayOfweek = '金';
    break;
    case 6: dayOfweek = '土';
    break;
  }
  var today = Utilities.formatDate(date, 'Asia/Tokyo', 'yyyy年MM月dd日({曜日}曜日)');
  var today = today.replace('{曜日}', dayOfweek); // {曜日}を日本語の曜日に置換

  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var message = {
    "type": "template",
    "altText": "【定期配信】告知代行 - 防犯カメラ関連",
    "template": {
      "type": "buttons",
      "title": "告知代行",
      "text": "防犯カメラ関連の対応を選択",
      "actions": [
        {
          "type": "message",
          "label": "動画データを回収した",
          "text": "cmd:動画データ回収済み"
        },
        {
          "type": "message",
          "label": "動画データを削除した",
          "text": "cmd:動画データ削除済み"
        },
        {
          "type": "message",
          "label": "電池交換を行う",
          "text": "早速防犯カメラの電池交換を行う、後に続け！"
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
  Logger.log("initializeTrigger(): 初期化トリガーを作成しました");
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
  Logger.log("createTrigger(): LineDeveloperMessage 実行トリガーを作成しました");
}