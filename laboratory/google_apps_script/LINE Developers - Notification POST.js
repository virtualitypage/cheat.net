// トップ部分に前回のメニューを保持する変数を追加
var lastSuggestedMenu = "";

function doPost(e) {
  //LINE Messaging APIのチャネルアクセストークンを設定
  var token = "-----CHANNEL_ACCESS_TOKEN-----";

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
    case "どこにいるんだァ？一旦集まロットォ！！！":
      responseMessage = "集合しましょう。集合場所の候補としては「川上神社の鳥居付近(南方面)」「土俵がある建物」などです。";
      break;
    case "よく頑張ったがとうとう「帰る」時がきたようだなァ...!":
      responseMessage = "帰る時がきたようです(笑)このグループLINEで連絡を取り合ってください";
      break;
    default:
      responseMessage = "";
  }

  // APIリクエスト時にセットするペイロード値を設定する
  var payload = {
    'replyToken': replyToken,
    'messages': [{
      'type': 'text',
      'text': responseMessage
    }]
  };

  //　HTTPSのPOST時のオプションパラメータを設定する
  var options = {
    'method': 'POST',
    'headers': { "Authorization": "Bearer " + token },
    'contentType': 'application/json',
    'payload': JSON.stringify(payload)
  };
  //　LINE Messaging APIにリクエストし、ユーザーからの投稿に返答する
  UrlFetchApp.fetch(url, options);
}

// スプレッドシートからmessageTextの値を取得する関数
function getMenuTextFromSpreadsheet() {
  // スプレッドシートにアクセスして値を書き込む
  var spreadsheetId = "-----SPREAD_SHEET_ID-----"; // スプレッドシートのID　※シートを変更したら必ず更新すること
  var sheetName = "-----SHEET_NAME-----"; // 書き込むシートの名前に置き換える
  var cellAddress = "A2"; // 書き込むセルのアドレスに置き換える
  var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  return sheet.getRange(cellAddress).getValue();
  // console.log(sheet.getRange(cellAddress).getValue())
}

function menuNotification() {

  const targetSpreadsheetId = '-----SPREAD_SHEET_ID-----'; // スプレッドシートのID　※シートを変更したら必ず更新すること

  const today = new Date(); // 現在の日時を取得
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, '0');
  const sheetName = year + month;

  const targetSpreadsheet = SpreadsheetApp.openById(targetSpreadsheetId);
  const sheet = targetSpreadsheet.getSheetByName(sheetName);

  // const date = Utilities.formatDate(new Date(), 'Asia/Tokyo', 'MM/dd');
  const dates = sheet.getRange('A2:A').getValues(); // 日時データの範囲を指定
  const targetDate = new Date(today.getFullYear(), today.getMonth(), today.getDate()); // 今日の日時を取得

  let message = '';

  for (let i = 0; i < dates.length; i++) { // A2から下行に向かって確認していく

    const day = dates[i][0];

    if (day instanceof Date && day.getTime() === targetDate.getTime()) {

      const row = i + 2; // 行番号を取得（A2から始まるため、+2する）
      const range = sheet.getRange('C' + row + ':AG' + row); // C 列から AG 列までの範囲を取得
      const rowData = range.getValues()[0]; // C 列から AG 列までのデータを取得（1行分のデータを取得）

      const enabledColumn = []; // キーワードを含まない含まない空行の列を保持する配列
      const disabledColumn = []; // 除外する列の列を保持する配列
      const selectedColumn = sheet.getRange('C1:AG1').getValues()[0]; // 列のヘッダー行を取得

      wordDetection = false; // キーワードが見つかったかどうかのフラグ

      const disabledIndex = disabledColumn.map(invalidColumn => selectedColumn.indexOf(invalidColumn));

      for (let i = 0; i < rowData.length; i++) { // 行ごとにキーワードの有無を確認していく(C列〜AG列まで)
        const cellValue = rowData[i];
        if (typeof cellValue === 'string' && (cellValue.includes('休') || cellValue.includes('済'))) {
          wordDetection = true;
          continue;
        }
        if (!disabledIndex.includes(i)) { // 現在ループ処理している列が disabledIndex(除外する列のインデックスを格納する)配列に含まれていない場合
          enabledColumn.push(i); // enabledColumn 配列に有効な列のインデックスを追加
        }
      }

      if (enabledColumn.length >= 1) { // enabledColumn 配列に格納された、使用可能な列数が1つ以上ある場合
        const randomLottery = []; // ランダムに選出された1つの列を格納する
        while (randomLottery.length < 1) { //　ランダム抽選(列数が1になるまで繰り返し処理)
          const randomIndex = Math.floor(Math.random() * enabledColumn.length);
          if (!randomLottery.includes(randomIndex)) {
            randomLottery.push(randomIndex);
          }
        }

        // 献立を選出

        const election = [];
        for (const randomIndex of randomLottery) {
          const electionIndex = enabledColumn[randomIndex]; // 選択された列のインデックス
          election.push(selectedColumn[electionIndex]);
        }

        const targets = [];
        for (const electedMenu of election) {
          const menu = electedMenu;
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
  // menuNotification()関数を呼び出す
  var messageValue = menuNotification();

  // messageの値を出力して確認
  Logger.log('message:', messageValue);

  // getMenuDetails()関数を呼び出す
  var detailsMessage = getMenuDetails(messageValue);
  Logger.log('detailsMessage:', detailsMessage); // デバッグログでdetailsMessageの値を確認

  if (detailsMessage) {
    // APIリクエスト時にセットするペイロード値を設定する
    var detailsPayload = {
      'replyToken': replyToken,
      'messages': [{
        'type': 'text',
        'text': detailsMessage // 取得した詳細情報を送信
      }]
    };
    // HTTPSのPOST時のオプションパラメータを設定する
    var detailsOptions = {
      'method': 'POST',
      'headers': { "Authorization": "Bearer " + token },
      'contentType': 'application/json',
      'payload': JSON.stringify(detailsPayload)
    };

    // LINE Messaging APIにリクエストし、詳細情報を送信
    var response = UrlFetchApp.fetch(url, detailsOptions);
    console.log('APIリクエストの結果:', response.getContentText());
  } else {
    // 詳細情報が見つからない場合の処理（任意に追加）
    console.log('詳細情報が見つかりませんでした。');
  }
  return detailsMessage; // detailsMessageを返す
}

function getMenuDetails(messageText) {

  const targetSpreadsheetId = '-----SPREAD_SHEET_ID-----'; // スプレッドシートのID　※シートを変更したら必ず更新すること
  const targetSheetName = '-----SHEET_NAME-----';

  const targetSpreadsheet = SpreadsheetApp.openById(targetSpreadsheetId);
  const targetSheet = targetSpreadsheet.getSheetByName(targetSheetName);

  const menuColumn = 3; // メニューが格納されている列のインデックス（C列なら3）
  const detailsColumn = 4; // メニューの詳細が格納されている列のインデックス（D列なら4）

  const menuValues = targetSheet.getRange(1, menuColumn, targetSheet.getLastRow(), 1).getValues();
  const detailsValues = targetSheet.getRange(1, detailsColumn, targetSheet.getLastRow(), 1).getValues();

  if (messageText === null) {
    return;
  }

  // messageをトリムして正規化（不要な空白を取り除いて統一する）
  const normalizedMessage = messageText;

  for (let i = 0; i < menuValues.length; i++) {
    // menuValuesの要素をトリムして正規化してから比較
    if (menuValues[i][0].toString().trim() === normalizedMessage) {
      return detailsValues[i][0];
    }
  }
  return; // 該当するメニューが見つからない場合
}

function LineDeveloperMessage() {
  var channelAccessToken = "-----CHANNEL_ACCESS_TOKEN-----";
  var myUserId = "-----USER_ID-----";
  // var myUserId = "C97fda4cd18f1d0bd01e7765567540c75"; // グループLINEのグループID

  // 以下、メッセージの内容を設定
  var headers = {
    "Authorization": "Bearer " + channelAccessToken,
    "Content-Type": "application/json"
  };

  var messageText = menuNotification(); // menuNotification()関数を呼び出してテキストを取得

  if (!messageText) {
    return; // メッセージがない場合は終了
  }

  // `messageText`の値をデバッグログで出力
  console.log('messageText:', messageText);

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