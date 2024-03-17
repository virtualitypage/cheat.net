function createGoogleForm() {
  const form = FormApp.create('---FORM_NAME---');
  form.setTitle('---TITLE---');
  form.setDescription('---DESCRIPTION---');

  // 記述式テキスト(長文回答)を追加(ここに予定のタイトルを設定)
  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---").setRequired(true);

  // プルダウンメニューを追加(ここに日付を設定)
  var pulldown = form.addListItem().setTitle('---TITLE---').setRequired(true)
  pulldown.setChoices([
    pulldown.createChoice(''),
  ]);

  // プルダウンメニューを追加(ここに開始時刻を設定)
  var pulldown = form.addListItem().setTitle('---TITLE---').setRequired(true)
  pulldown.setChoices([
    pulldown.createChoice(''),
  ]);

  // プルダウンメニューを追加(ここに終了時刻を設定)
  var pulldown = form.addListItem().setTitle('---TITLE---').setRequired(true)
  pulldown.setChoices([
    pulldown.createChoice(''),
  ]);

  // 記述式テキスト(長文回答)を追加(場所や詳細を設定)
  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");

  var textItem = form.addParagraphTextItem();
  textItem.setTitle("---TITLE---");
}