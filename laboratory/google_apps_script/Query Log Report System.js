var date = new Date();
date.setDate(date.getDate() - 1);
var date = Utilities.formatDate(date, 'Asia/Tokyo', 'yyyy-MM-dd');

function init() { // 初回実行時のみ実行。既存・未知のドメインの比較表を作成する
  importCSV();
  unknownDomainSearch();
}

function importCSV() {
  const csvFileName = '-----FILE_NAME-----' + date + '.csv';
  Logger.log(csvFileName + " をインポート");

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


function unknownDomainSearch() { // 注意：既知のドメイン列(E列)はプログラムが編集するため手入力厳禁
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  var knownDomains = sheet.getSheetByName("レポート対象ドメイン").getRange("E1:E").getValues();
  var unknownDomains = sheet.getSheetByName("クエリログ・レポート").getRange("D2:D").getValues();
  var reportMessage = "・通過した未知のドメイン\n";
  detectionFlag = false;

  for (var i = 0; i < unknownDomains.length; i++) {
    unknownFlag = false;
    var unknownDomain = unknownDomains[i][0];
    for (var j = 0; j < knownDomains.length; j++) {
      var knownDomain = knownDomains[j][0];
      if (unknownDomain === knownDomain && knownDomain) { // 既知のドメインとマッチした場合
        unknownFlag = true;
        break; // 次の未知のドメインに移行
      }
    }
    if (unknownFlag == false && unknownDomain) { // 未知のドメインとして判定された場合
      reportMessage += unknownDomain;
      if (j !== unknownDomain.length - 1) {
        reportMessage += '\n'; // 最終行でない場合に改行を追加
      }
      detectionFlag = true;
    }
  }

  const knownDomainsSheet = sheet.getSheetByName("レポート対象ドメイン");
  const unknownDomainsSheet = sheet.getSheetByName("クエリログ・レポート");
  const knownDomainsColumn = knownDomainsSheet.getRange(1, 5, knownDomainsSheet.getLastRow()).getValues().flat().filter(String);
  const unknownDomainsColumn = unknownDomainsSheet.getRange(2, 4, unknownDomainsSheet.getLastRow()).getValues().flat().filter(String);

  const mergedDomains = Array.from(new Set([...knownDomainsColumn, ...unknownDomainsColumn])).sort();
  // knownDomainsColumn と unknownDomainsColumn をスプレッド構文で結合し（[... , ...]）
  // Set によって重複を自動で排除し（new Set(...)）
  // Array.from(...) で Set を普通の配列に戻し sort() で昇順に並び替えた
  // 最終的な1次元配列 mergedDomains を作成

  knownDomainsSheet.insertColumnAfter(6); // E列の後ろに列を追加して削除される列を補う
  knownDomainsSheet.deleteColumn(5); // 既存の列(E列)を削除
  knownDomainsSheet.getRange(1, 5, mergedDomains.length, 1).setValues(mergedDomains.map(v => [v])); // mergedDomains の内容(1次元配列)を縦向きの2次元配列に変換（mergedDomains.map(v => [v])）してE列の1行目に書き込む

  if (detectionFlag == true) {
    return reportMessage;
  }
}

function LineDeveloperMessage() {
  var channelAccessToken = "----CHANNEL_ACCESS_TOKEN-----";
  var groupId = "-----GROUP_ID-----";

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var regect = regectSearch(); // regect()関数を呼び出してテキストを取得
  var blockedService = blockedServiceSearch();
  var safeBrowsing = safeBrowsingSearch();
  var processed = processedSearch();
  var unknownDomain = unknownDomainSearch();

  var messageText = date + "【Query Log Report System】\n\n";

  if (regect || blockedService || safeBrowsing || processed) { // 少なくとも1つの情報がある場合
    messageText += "報告：危険と認定されたドメインを検知しました\n\n";
    if (regect) messageText += regect + '\n';
    if (blockedService) messageText += blockedService + '\n';
    if (safeBrowsing) messageText += safeBrowsing + '\n';
    if (processed) messageText += processed + '\n\n';
    if (unknownDomain) messageText += unknownDomain + '\n\n';
    messageText += "注意：上記ドメインへのアクセス禁止\n";
  } else { // 全て空の場合
    messageText += "報告：危険と認定されたドメインは検知されませんでした";
  }

  if (messageText.length >= 5000) { // 文字数が5000以上の場合
    Logger.log(messageText); // 生成されたメッセージのバックアップを取得
    var messageTextLength = messageText.length;
    var messageText = "";
    var messageText = date + "【Query Log Report System】\n\n";
    messageText += "失敗：400 Bad Request" + '\n\n' + "リクエスト本文の文字数が制限範囲(0-5000)を超過した為、サーバーの応答が切り捨てられました" + '\n' + "リクエスト本文の文字数：" + messageTextLength;
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

// LineDeveloperMessage(): 2025/07/16 6:00:02 "Exception: Too many simultaneous invocations: Spreadsheets" の発生を受けての対応策
// https://issuetracker.google.com/issues/373461929?pli=1#comment33
function tryLoop() {
  var c = 4; // 関数のエラー発生時に再試行する回数(3回)
  for (var i = 1; i < c; i++) {
    try {
      LineDeveloperMessage(); // 実行対象の関数
      break;
    } catch (e) {
      if (i !== c - 1) { // i * 1秒後に再度実行
        Utilities.sleep(i * 1000);
      }
      if (i >= c - 1) { // 試行回数が上限に達した場合
        Logger.log('Error: ' + e.error);
      }
    };
  }
}

const triggerDate = new Date();
triggerDate.setDate(triggerDate.getDate() + 1);

function initializeTrigger() { // 通知用のトリガーを定期的に作成する
  const triggers = ScriptApp.getProjectTriggers(); // 対象のプロジェクトに登録されているトリガーを取得
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'createTrigger') { // createTriggerトリガーが重複しないように古いトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('createTrigger').timeBased().atHour(23).everyDays(1).create(); // 毎晩23時頃にcreateTriggerを実行するトリガーを作成
  Logger.log("initializeTrigger(): 初期化トリガーを作成しました");
}

function createTrigger() { // 指定した日時にLineDeveloperMessageを実行する
  const triggers = ScriptApp.getProjectTriggers();
  triggers.forEach(function (t) {
    if (t.getHandlerFunction() === 'importCSV') { // 使用済み・不要なimportCSVトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
    if (t.getHandlerFunction() === 'LineDeveloperMessage') { // 使用済み・不要なLineDeveloperMessageトリガーを削除
      ScriptApp.deleteTrigger(t);
    }
  });
  triggerDate.setHours(5, 0, 0, 0);
  ScriptApp.newTrigger('importCSV').timeBased().at(triggerDate).create();
  Logger.log("createTrigger(): importCSV実行トリガーを作成しました");

  triggerDate.setHours(6, 0, 0, 0); // 時間、分、秒、およびミリ秒全てを0に設定
  ScriptApp.newTrigger('LineDeveloperMessage').timeBased().at(triggerDate).create(); // 当日の対象時刻にLineDeveloperMessageを実行するトリガーを作成
  Logger.log("createTrigger(): LineDeveloperMessage実行トリガーを作成しました");
}