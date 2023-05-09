#!/bin/Bash

this=`basename $0`

function usage {
  echo "インタープリタ型の高水準汎用プログラミング言語 'Python' の導入・削除を行うスクリプト(MacOS環境用)"
  echo "入力方法: $this [ --install | --uninstall ]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

function python_install() {
  brew install python
  pip3 install PyInstaller
  echo "brew list | grep python"
  brew list | grep python
  echo "python3 --version"
  python3 --version
  echo "python install completed."
}

function python_uninstall() {
  brew uninstall --ignore-dependencies python3
  pip3 uninstall PyInstaller
  echo "python uninstall completed."
}

if [ $1 = --install ]; then
  python_install
elif [ $1 = --uninstall ]; then
  python_uninstall
else
  echo "以下のオプションを指定して下さい"
  echo " --install | --uninstall"
fi
