var lastSuggestedMenu = ""; // 前回のメニューを保持する変数を追加

function doPost(e) {
  var token = "-----CHANNEL_ACCESS_TOKEN-----"; //LINE Messaging APIのチャネルアクセストークンを設定

  // グループLINEのグループIDを取得するコード　※スプレッドシートで実行することで取得できる
  // var json = JSON.parse(e.postData.contents);
  // var UID = json.events[0].source.userId;
  // var GID = json.events[0].source.groupId;
  // var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  // sheet.getRange(1, 1).setValue(GID);

  var eventData = JSON.parse(e.postData.contents).events[0]; // WebHookで取得したJSONデータをオブジェクト化して取得

  var replyToken = eventData.replyToken; //　取得したデータから応答用のトークンを取得

  var userMessage = eventData.message.text; //　取得したデータからユーザーが投稿したメッセージを取得

  // var userMessage = 'それにしましょう'; //　取得したデータからユーザーが投稿したメッセージを取得

  var responseMessage;
  switch (userMessage) {
    case "XX1銀行への振込完了":
      responseMessage = "XX1銀行への振込完了";
      break;
    case "XX1銀行への振込未完了":
      responseMessage = "最短引き落とし日は23日です。期日までに振込を完了させましょう。";
      break;
    case "XX2銀行への振込完了":
      responseMessage = "XX2銀行への振込完了";
      break;
    case "XX2銀行への振込未完了":
      responseMessage = "引き落とし日は月によって異なりますがXX〜YY日です。期日までに振込を完了させましょう。";
      break;
    case "それにしましょう":
      // 前回の提案メニューを保持している場合はそれを返信
      if (lastSuggestedMenu !== "") {
        responseMessage = "前回の提案は「" + lastSuggestedMenu + "」でした。それにしましょうか？";
      } else {
        var messageText = getMenuTextFromSpreadsheet();
        var detailsMessage = getMenuDetails(messageText);
        responseMessage = detailsMessage;
        lastSuggestedMenu = detailsMessage; // 新しいメニューを保持変数に格納
      }
      break;
    case "いやです":
      LineDeveloperMessage();
      break;
    case "予定を変更する":
      responseMessage = 'microSDカード回収日 予定変更フォーム' + '\n' + '-----FORM_URL-----';
      break;
    case "どこにいるんだァ？一旦集まロットォ！！！":
      responseMessage = "集合しましょう。集合場所の候補としては「川上神社の鳥居付近(南方面)」「土俵がある建物」などです。";
      break;
    case "よく頑張ったがとうとう「帰る」時がきたようだなァ...!":
      responseMessage = "帰る時がきたようです(笑)このグループLINEで連絡を取り合ってください";
      break;
    default:
      responseMessage = "";
  }

  var payload = { // APIリクエスト時にセットするペイロード値を設定する
    'replyToken': replyToken,
    'messages': [{
      'type': 'text',
      'text': responseMessage
    }]
  };

  var options = { //　HTTPSのPOST時のオプションパラメータを設定する
    'method': 'POST',
    'headers': { "Authorization": "Bearer " + token },
    'contentType': 'application/json',
    'payload': JSON.stringify(payload)
  };
  UrlFetchApp.fetch(url, options); //　LINE Messaging APIにリクエストし、ユーザーからの投稿に返答する
}

function getMenuTextFromSpreadsheet() { // スプレッドシートからmessageTextの値を取得する関数
  // スプレッドシートにアクセスして値を書き込む
  var spreadsheetId = "-----SPREAD_SHEET_ID-----"; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var sheetName = "-----SHEET_NAME-----"; // 書き込むシートの名前に置き換える
  var cellAddress = "A2"; // 書き込むセルのアドレスに置き換える
  var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  return sheet.getRange(cellAddress).getValue();
  // console.log(sheet.getRange(cellAddress).getValue())
}

function menuNotification() {
  var targetSpreadsheetId = '-----SPREAD_SHEET_ID-----'; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var today = new Date(); // 現在の日時を取得
  var year = today.getFullYear();
  var month = (today.getMonth() + 1).toString().padStart(2, '0');
  var sheetName = year + month;

  var targetSpreadsheet = SpreadsheetApp.openById(targetSpreadsheetId);
  var sheet = targetSpreadsheet.getSheetByName(sheetName);

  // var date = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'MM/dd');
  var dates = sheet.getRange('A2:A').getValues(); // 日時データの範囲を指定
  var targetDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()); // 今日の日時を取得

  let message = '';

  for (let i = 0; i < dates.length; i++) { // A2から下行に向かって確認していく
    var day = dates[i][0];
    if (day instanceof Date && day.getTime() === targetDate.getTime()) {
      var row = i + 2; // 行番号を取得（A2から始まるため、+2する）
      var range = sheet.getRange('C' + row + ':AG' + row); // C 列から AG 列までの範囲を取得
      var rowData = range.getValues()[0]; // C 列から AG 列までのデータを取得（1行分のデータを取得）

      var enabledColumn = []; // キーワードを含まない含まない空行の列を保持する配列
      var disabledColumn = []; // 除外する列の列を保持する配列
      var selectedColumn = sheet.getRange('C1:AG1').getValues()[0]; // 列のヘッダー行を取得

      wordDetection = false; // キーワードが見つかったかどうかのフラグ

      var disabledIndex = disabledColumn.map(invalidColumn => selectedColumn.indexOf(invalidColumn));

      for (let i = 0; i < rowData.length; i++) { // 行ごとにキーワードの有無を確認していく(C列〜AG列まで)
        var cellValue = rowData[i];
        if (typeof cellValue === 'string' && (cellValue.includes('休') || cellValue.includes('済'))) {
          wordDetection = true;
          continue;
        }
        if (!disabledIndex.includes(i)) { // 現在ループ処理している列が disabledIndex(除外する列のインデックスを格納する)配列に含まれていない場合
          enabledColumn.push(i); // enabledColumn 配列に有効な列のインデックスを追加
        }
      }

      if (enabledColumn.length >= 1) { // enabledColumn 配列に格納された、使用可能な列数が1つ以上ある場合
        var randomLottery = []; // ランダムに選出された1つの列を格納する
        while (randomLottery.length < 1) { //　ランダム抽選(列数が1になるまで繰り返し処理)
          var randomIndex = Math.floor(Math.random() * enabledColumn.length);
          if (!randomLottery.includes(randomIndex)) {
            randomLottery.push(randomIndex);
          }
        }

        // 献立を選出
        var election = [];
        for (var randomIndex of randomLottery) {
          var electionIndex = enabledColumn[randomIndex]; // 選択された列のインデックス
          election.push(selectedColumn[electionIndex]);
        }

        var targets = [];
        for (var electedMenu of election) {
          // var menu = electedMenu.replace(/\([^()]*\)|[\r\n]/g, "").trim();
          var menu = electedMenu;
          targets.push(menu);
        }
        message = '本日の夕食は「' + targets + '」にしませんか？';
        console.log(message + '\n' + `<${stringlink}|${stringText}>`);
      }

      if (message === '') {
        console.log('メッセージがありません。');
        return;
      }
      console.log('menuNotification() 関数の実行結果:', message); // messageの値をデバッグログで出力
      return message;
    }
  }
}

var url = 'https://api.line.me/v2/bot/message/reply';

function exampleCallMenuNotification(replyToken, token) { // 第3引数にmessageを追加
  var messageValue = menuNotification(); // menuNotification()関数を呼び出す
  Logger.log('message:', messageValue); // messageの値を出力して確認

  var detailsMessage = getMenuDetails(messageValue); // getMenuDetails()関数を呼び出す
  Logger.log('detailsMessage:', detailsMessage); // デバッグログでdetailsMessageの値を確認

  if (detailsMessage) {
    var detailsPayload = { // APIリクエスト時にセットするペイロード値を設定する
      'replyToken': replyToken,
      'messages': [{
        'type': 'text',
        'text': detailsMessage // 取得した詳細情報を送信
      }]
    };
    var detailsOptions = { // HTTPSのPOST時のオプションパラメータを設定する
      'method': 'POST',
      'headers': { "Authorization": "Bearer " + token },
      'contentType': 'application/json',
      'payload': JSON.stringify(detailsPayload)
    };
    var response = UrlFetchApp.fetch(url, detailsOptions); // LINE Messaging APIにリクエストし、詳細情報を送信
    console.log('APIリクエストの結果:', response.getContentText());
  } else {
    console.log('詳細情報が見つかりませんでした。'); // 詳細情報が見つからない場合の処理（任意に追加）
  }
  return detailsMessage; // detailsMessageを返す
}

function getMenuDetails(messageText) {
  var targetSpreadsheetId = '-----SPREAD_SHEET_ID-----'; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var targetSheetName = '-----SHEET_NAME-----';

  var targetSpreadsheet = SpreadsheetApp.openById(targetSpreadsheetId);
  var targetSheet = targetSpreadsheet.getSheetByName(targetSheetName);

  var menuColumn = 3; // メニューが格納されている列のインデックス（C列なら3）
  var detailsColumn = 4; // メニューの詳細が格納されている列のインデックス（D列なら4）

  var menuValues = targetSheet.getRange(1, menuColumn, targetSheet.getLastRow(), 1).getValues();
  var detailsValues = targetSheet.getRange(1, detailsColumn, targetSheet.getLastRow(), 1).getValues();

  if (messageText === null) {
    console.log('メニューが見つからないため、詳細情報を取得できません。');
    return;
  }

  var normalizedMessage = messageText; // messageをトリムして正規化（不要な空白を取り除いて統一する）
  for (let i = 0; i < menuValues.length; i++) {
    if (menuValues[i][0].toString().trim() === normalizedMessage) { // menuValuesの要素をトリムして正規化してから比較
      console.log('メニュー詳細:' + detailsValues[i][0]);
      return detailsValues[i][0];
    }
  }
  console.log('detailsValues:', detailsValues);
  console.log('message:', messageText);
  return; // 該当するメニューが見つからない場合
}

function LineDeveloperMessage() {
  var channelAccessToken = "-----CHANNEL_ACCESS_TOKEN-----";
  var myUserId = "-----USER_ID-----";
  // var myUserId = "C97fda4cd18f1d0bd01e7765567540c75"; // グループLINEのグループID

  var headers = { // 以下、メッセージの内容を設定
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var messageText = menuNotification(); // menuNotification()関数を呼び出してテキストを取得

  if (!messageText) {
    return; // メッセージがない場合は終了
  }

  console.log('messageText:', messageText); // `messageText`の値をデバッグログで出力

  // スプレッドシートにアクセスして値を書き込む
  var spreadsheetId = "-----SPREAD_SHEET_ID-----"; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var sheetName = "-----SHEET_NAME-----"; // 書き込むシートの名前に置き換える
  var cellAddress = "A2"; // 書き込むセルのアドレスに置き換える
  var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  sheet.getRange(cellAddress).setValue(messageText);

  var message = {
    "type": "template",
    "altText": "夕食の候補メッセージです",
    "template": {
      "type": "confirm",
      "text": messageText + '\n\n' + '"はい" → レシピを表示' + '\n' + '"いいえ" → メニューを再選択', // menuNotification()関数から取得したメッセージを表示
      "actions": [
        {
          "type": "message",
          "label": "はい",
          "text": "それにしましょう"
        },
        {
          "type": "message",
          "label": "いいえ",
          "text": "いやです"
        }
      ]
    }
  };

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify({
      "to": myUserId,
      "messages": [message]
    })
  };

  var response = UrlFetchApp.fetch("https://api.line.me/v2/bot/message/push", options);
  Logger.log(response.getContentText());
}