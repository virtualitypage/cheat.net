function onSubmit(e) {

  // 予定を反映させるカレンダーのID（通常はメールアドレス）をセットしてください
  const calendar_id = '-----CALENDER_ID-----';
  // 「FormApp.getActiveForm を呼び出す権限がありません」というエラーが出たので明示的にFormAppを呼び出す。
  FormApp.getActiveForm();

  // フォームの項目や回答を取得する
  const form_responses = e.response.getItemResponses();

  // 回答を格納する変数を宣言
  let event_date, event_start, event_end, event_title, event_desc, event_location;

  // フォームの項目数だけループする
  for (var i = 0; i < form_responses.length; i++) {

    // フォームの質問を取得
    let question = form_responses[i].getItem().getTitle();

    // 質問に対する回答を取得する
    let answer = form_responses[i].getResponse();

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

  // 日付と日時を連結して、Dateオブジェクトを作成する
  event_start = new Date(event_date + ' ' + event_start);
  event_end = new Date(event_date + ' ' + event_end);

  // 説明と場所はoptionでセットする
  let options = {
    description: event_desc,
    location: event_location
  }

  // カレンダーを取得
  const calendar = CalendarApp.getCalendarById(calendar_id);

  // 予定を作成する
  calendar.createEvent(event_title, event_start, event_end, options);

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

  // 対象となるフォームを取得
  const form = FormApp.getActiveForm();
  // フォームにある質問を取得
  const item = form.getItems();

  // 現在日付を取得
  var day = new Date();

  // 当月の末日を取得
  var endMonth = new Date(day.getFullYear(), day.getMonth() + 1, 0);

  // 配列に当月日付を順に追加
  let choices = [];
  for (let i = 0; i < endMonth.getDate(); i++) {
    let dayString = Utilities.formatString("%04d/%02d/%02d", day.getFullYear(), day.getMonth() + 1, i + 1);

    // 配列に選択肢を追加
    choices.push(dayString);
  }

  // プルダウンに配列の内容をセット
  item[1].asListItem().setChoiceValues(choices);
}

function setTimeChoices() { // 初回作成時に実行する
  let form = FormApp.getActiveForm();
  let item = form.getItems();

  let choices = [];
  for (let h = 0; h < 24; h++) {
    choices.push(`${h}:00`, `${h}:30`);
  }

  item[2].asListItem().setChoiceValues(choices);
  item[3].asListItem().setChoiceValues(choices);
}