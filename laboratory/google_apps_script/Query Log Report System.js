var date = new Date();
date.setDate(date.getDate() - 1);
var date = Utilities.formatDate(date, 'Asia/Tokyo', 'yyyy-MM-dd');

function importCSV() {
  const csvFileName = 'querylog_report_system_' + date + '.csv';

  const files = DriveApp.getFilesByName(csvFileName);
  if (!files.hasNext()) {
    Logger.log('CSVファイルが見つかりませんでした');
    return;
  }
  const file = files.next();
  const csvData = file.getBlob().getDataAsString(); // UTF-8 assumed

  // 文字列を2次元配列に変換（カンマ区切り、改行ごとに行）
  const csvLines = csvData.trim().split('\n');
  const csvArray = csvLines.map(line => line.split(','));

  const sheet = SpreadsheetApp.getActiveSpreadsheet();
  const sheets = sheet.getSheetByName("クエリログ・レポート");
  sheets.clear(); // 既存データを消去
  sheets.getRange(1, 1, csvArray.length, csvArray[0].length).setValues(csvArray);
}

function regectSearch() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var targetDomain = sheet.getSheetByName("レポート対象ドメイン").getRange("A1:A").getValues();
  var regectColumn = sheet.getSheetByName("クエリログ・レポート").getRange("A2:A").getValues();
  var reportMessage = "・ブロック済\n";
  detectionFlag = false;

  for (var i = 0; i < targetDomain.length; i++) {
    var domain = targetDomain[i][0];
    for (var j = 0; j < regectColumn.length; j++) {
      var oneLog = regectColumn[j][0];
      if (oneLog.includes(domain) && domain) {
        reportMessage += oneLog;
        if (j !== oneLog.length - 1) {
          reportMessage += '\n'; // 最終行でない場合に改行を追加
        }
        detectionFlag = true;
      }
    }
  }
  if (detectionFlag == true) {
    return reportMessage;
  }
}

function blockedServiceSearch() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var targetDomain = sheet.getSheetByName("レポート対象ドメイン").getRange("B1:B").getValues();
  var blockedServiceColumn = sheet.getSheetByName("クエリログ・レポート").getRange("B2:B").getValues();
  var reportMessage = "・ブロック対象のサービス\n";
  detectionFlag = false;

  for (var i = 0; i < targetDomain.length; i++) {
    var domain = targetDomain[i][0];
    for (var j = 0; j < blockedServiceColumn.length; j++) {
      var oneLog = blockedServiceColumn[j][0];
      if (oneLog.includes(domain) && domain) {
        reportMessage += oneLog;
        if (j !== oneLog.length - 1) {
          reportMessage += '\n'; // 最終行でない場合に改行を追加
        }
        detectionFlag = true;
      }
    }
  }
  if (detectionFlag == true) {
    return reportMessage;
  }
}

function safeBrowsingSearch() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var targetDomain = sheet.getSheetByName("レポート対象ドメイン").getRange("C1:C").getValues();
  var safeBrowsingColumn = sheet.getSheetByName("クエリログ・レポート").getRange("C2:C").getValues();
  var reportMessage = "・ブロックされた脅威\n";
  detectionFlag = false;

  for (var i = 0; i < targetDomain.length; i++) {
    var domain = targetDomain[i][0];
    for (var j = 0; j < safeBrowsingColumn.length; j++) {
      var oneLog = safeBrowsingColumn[j][0];
      if (oneLog.includes(domain) && domain) {
        reportMessage += oneLog;
        if (j !== oneLog.length - 1) {
          reportMessage += '\n'; // 最終行でない場合に改行を追加
        }
        detectionFlag = true;
      }
    }
  }
  if (detectionFlag == true) {
    return reportMessage;
  }
}

function processedSearch() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var targetDomain = sheet.getSheetByName("レポート対象ドメイン").getRange("D1:D").getValues();
  var processedColumn = sheet.getSheetByName("クエリログ・レポート").getRange("D2:D").getValues();
  var reportMessage = "・処理済み\n";
  detectionFlag = false;

  for (var i = 0; i < targetDomain.length; i++) {
    var domain = targetDomain[i][0];
    for (var j = 0; j < processedColumn.length; j++) {
      var oneLog = processedColumn[j][0];
      if (oneLog.includes(domain) && domain) {
        reportMessage += oneLog;
        if (j !== oneLog.length - 1) {
          reportMessage += '\n'; // 最終行でない場合に改行を追加
        }
        detectionFlag = true;
      }
    }
  }
  if (detectionFlag == true) {
    return reportMessage;
  }
}

function LineDeveloperMessage() {
  var channelAccessToken = "/4IZ03CoDHwoROKJx4ut+QNKwW6ecn1qheeF64IHoLonXIvlhrLZl5pbFJR25n4EhhklQ28FdXXAWjkr8pEXAk0OawG7/FZbLgiU5YYfVsqX+xh6X+csHmWyGRPls2Va4IdgGmpo30MnzsBjBfW5FgdB04t89/1O/w1cDnyilFU=";
  // var groupId = "C97fda4cd18f1d0bd01e7765567540c75"; // 血祭りにあげてやるグループLINEのグループID
  var groupId = "Cbec17f5a1c815de002db5a635b30b3f4"; // テスト用グループLINEのグループID

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var regect = regectSearch(); // regect()関数を呼び出してテキストを取得
  var blockedService = blockedServiceSearch();
  var safeBrowsing = safeBrowsingSearch();
  var processed = processedSearch();

  var messageText = date + "【Query Log Report System】\n\n";

  if (regect || blockedService || safeBrowsing || processed) { // 少なくとも1つの情報がある場合
    messageText += "報告：危険と認定されたドメインを検知しました\n\n";
    if (regect) messageText += regect + '\n';
    if (blockedService) messageText += blockedService + '\n';
    if (safeBrowsing) messageText += safeBrowsing + '\n';
    if (processed) messageText += processed + '\n\n';
    messageText += "注意：上記ドメインへのアクセス禁止\n\n";
  } else { // 全て空の場合
    messageText += "報告：危険と認定されたドメインは検知されませんでした";
  }

  // `messageText`の値をデバッグログで出力
  Logger.log(messageText);

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify({
      "to": groupId,
      "messages": [{"type": "text", "text": messageText}]
    })
  };

  var response = UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
  Logger.log(response.getContentText());
}

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  const triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(12).everyDays(1).create(); // 毎日12時頃にcreateTriggerを実行するトリガーを作成
  ScriptApp.newTrigger('importCSV').timeBased().atHour(12).everyDays(1).create();
  console.log("initializeTrigger(): 初期化トリガーを作成しました");
}

function createTrigger() { // 指定した日時にLineDeveloperMessageを実行する
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'LineDeveloperMessage') { // 使用済み・不要なLineDeveloperMessageトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  const date = new Date();
  date.setDate(date.getDate() + 1);
  date.setHours(12, 0, 30, 0); // 時間、分、秒、およびミリ秒全てを0に設定
  ScriptApp.newTrigger('LineDeveloperMessage').timeBased().at(date).create(); // 当日の対象時刻にLineDeveloperMessageを実行するトリガーを作成
  console.log("createTrigger(): LineDeveloperMessage実行トリガーを作成しました");
}