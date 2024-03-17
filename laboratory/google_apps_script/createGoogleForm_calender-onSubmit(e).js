function onSubmit(e) {
  FormApp.getActiveForm(); // 「FormApp.getActiveForm を呼び出す権限がありません」というエラーが出たので明示的にFormAppを呼び出す
  var calendar_id = '-----CALENDER_ID-----'; // 予定を反映させるカレンダーのID（通常はメールアドレス）をセット
  var form_responses = e.response.getItemResponses(); // フォームの項目や回答を取得
  var event_date, event_start, event_end, event_title, event_desc, event_location; // 回答を格納する変数を宣言

  for (var i = 0; i < form_responses.length; i++) { // フォームの項目数だけループ
    var question = form_responses[i].getItem().getTitle(); // フォームの質問を取得
    var answer = form_responses[i].getResponse(); // 質問に対する回答を取得

    // 項目名から、それぞれの値を該当の変数に格納していく
    if (question == '---TITLE---') {
      event_title = answer;
    } else if (question == '---TITLE---') {
      event_date = answer;
    } else if (question == '---TITLE---') {
      event_start = answer;
    } else if (question == '---TITLE---') {
      event_end = answer;
    } else if (question == '---TITLE---') {
      event_desc = answer;
    } else if (question == '---TITLE---') {
      event_location = answer;
    }
  }

  // 日付と日時を連結してDateオブジェクトを作成する
  event_start = new Date(event_date + ' ' + event_start);
  event_end = new Date(event_date + ' ' + event_end);

  let options = { // 説明と場所はoptionでセット
    description: event_desc,
    location: event_location
  }
  var calendar = CalendarApp.getCalendarById(calendar_id); // カレンダーを取得
  calendar.createEvent(event_title, event_start, event_end, options); // 予定を作成
}

function initializeTrigger() { // 初回作成時に実行する
  ScriptApp.newTrigger('onSubmit').forForm(FormApp.getActiveForm()).onFormSubmit().create(); // onSubmit 関数を実行するトリガーを作成
  ScriptApp.newTrigger('createTrigger').timeBased().onMonthDay(1).atHour(0).create(); // 月初に実行するトリガーを作成
}

function createTrigger() {
  createList();
  setTimeChoices();
}

function createList() { // 初回作成時に実行する
  var form = FormApp.getActiveForm(); // 対象となるフォームを取得
  var item = form.getItems(); // フォームにある質問を取得
  var day = new Date(); // 現在日付を取得
  var endMonth = new Date(day.getFullYear(), day.getMonth() + 1, 0); // 当月の末日を取得

  let choices = []; // 配列に当月日付を順に追加
  for (let i = 0; i < endMonth.getDate(); i++) {
    let dayString = Utilities.formatString("%04d/%02d/%02d", day.getFullYear(), day.getMonth() + 1, i + 1);
    choices.push(dayString); // 配列に選択肢を追加
  }
  item[1].asListItem().setChoiceValues(choices); // プルダウンに配列の内容をセット
}

function setTimeChoices() { // 初回作成時に実行する
  var form = FormApp.getActiveForm();
  var item = form.getItems();

  let choices = [];
  for (let h = 0; h < 24; h++) {
    choices.push(`${h}:00`, `${h}:30`);
  }
  item[2].asListItem().setChoiceValues(choices);
  item[3].asListItem().setChoiceValues(choices);
}