let navToggle = document.querySelector(".nav__toggle");
let navWrapper = document.querySelector(".nav__wrapper");

navToggle.addEventListener("click", function () {
  if (navWrapper.classList.contains("active")) {
    this.setAttribute("aria-expanded", "false");
    this.setAttribute("aria-label", "menu");
    navWrapper.classList.remove("active");
  } else {
    navWrapper.classList.add("active");
    this.setAttribute("aria-label", "close menu");
    this.setAttribute("aria-expanded", "true");
    searchForm.classList.remove("active");
    searchToggle.classList.remove("active");
  }
});

let searchToggle = document.querySelector(".search__toggle");
let searchForm = document.querySelector(".search__form");

searchToggle.addEventListener("click", showSearch);

function showSearch() {
  searchForm.classList.toggle("active");
  searchToggle.classList.toggle("active");

  navToggle.setAttribute("aria-expanded", "false");
  navToggle.setAttribute("aria-label", "menu");
  navWrapper.classList.remove("active");

  if (searchToggle.classList.contains("active")) {
    searchToggle.setAttribute("aria-label", "Close search");
  } else {
    searchToggle.setAttribute("aria-label", "Open search");
  }
}


function notifications() {
  let date = new Date();
  // alert(date.toLocaleDateString() + "現在、最新情報はありません");
  // alert("Upload Linkに「ニコニコ動画」フィールドをリリース予定");
  alert("Archiveに家電製品の取扱説明書(PDF)を追加中");
}

function authentication(){
  var password = '古井';
  function verifyPassword(inputPassword) {
    if (inputPassword === password) {
			alert("認証が完了しました。共有カレンダーへのアクセスを許可します。");
      window.open('https://calendar.google.com/calendar/u/0/r', '_blank');
    } else {
      alert("認証に失敗しました。事前共有鍵が一致しません。");
    }
  }
  if (window.confirm( '共有カレンダーへの登録を行う場合は「OK」\n共有カレンダーにアクセスする場合は「キャンセル」を押してください。' ) ) {
    window.open('https://docs.google.com/forms/d/e/1FAIpQLSeek5GzIWfGcDoXBUD3AZJ5uZtcOOTcndKTUklcflG8otquzw/viewform');
  }
  else {
    var enteredPassword = prompt("共有カレンダーへのアクセスには認証が必要です。\n事前共有鍵を入力してください:");
    verifyPassword(enteredPassword);
  }
}

// index.html のボタン用
function showCustomDialog(message, yesLabel, noLabel) {
  var dialog = document.getElementById('custom-dialog');
  var dialogMessage = document.getElementById('custom-dialog-message');

  dialogMessage.textContent = message;

  var buttons = dialog.getElementsByTagName('button');
  buttons[0].textContent = yesLabel;
  buttons[1].textContent = noLabel;

  dialog.style.display = 'block';
}

function onCustomDialogButtonClick(choice) {
  var dialog = document.getElementById('custom-dialog');
  dialog.style.display = 'none';
  if (choice) {
    window.open('https://docs.google.com/forms/d/e/1FAIpQLSesjjpJZ5r1T7OpVsutOFJOmIG1aIHiIuKdBgrUcpMt0xdYdA/viewform');
  } else {
  }
}

function sslFormAccess() {
  var result = confirm("OKをクリックするとSSL証明書 確認フォームにアクセスします。");
  var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSesjjpJZ5r1T7OpVsutOFJOmIG1aIHiIuKdBgrUcpMt0xdYdA/viewform"
  if (result) {
    window.open(form_url, "_blank");
  } else {
  }
}

function householdFormAccess() {
  var result = confirm("OKをクリックすると家計簿登録フォームにアクセスします。");
  var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSe6z6FCrqLpNmz5W9T66ZE4vlK5hfXJT_rlpRHf9RpbeYAEDA/viewform"
  var doc_url = "https://drive.google.com/drive/folders/1QdNrmlqF6MReiwbG09c2kwo741OmNT1e"
  if (result) {
    window.open(form_url, "_blank");
    setTimeout(function() {
      window.open(doc_url, "_blank");
    }, 1000);
  } else {
  }
}

function safetyFormAccess() {
  var result = confirm("OKをクリックすると安否確認フォームにアクセスします。");
  var form_url = "https://docs.google.com/forms/d/e/1FAIpQLSdyuKNmR8zTkv9v1I7-Lxqfg4vyXHzsj8ZcLcT_fOJ1yqxplg/viewform"
  if (result) {
    window.open(form_url, "_blank");
  } else {
  }
}