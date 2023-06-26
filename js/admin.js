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
  var enteredPassword = prompt("共有カレンダーへのアクセスには認証が必要です。\n事前共有鍵を入力してください:");
  verifyPassword(enteredPassword);
}