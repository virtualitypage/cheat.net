#!/bin/bash

this=$(basename $0)

function usage () {
  echo "インタープリタ型の高水準汎用プログラミング言語 'Python' の導入・削除を行うスクリプト(MacOS環境用)"
  echo "入力方法: $this [ --install | --uninstall ]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

function python_install () {
  brew install python
  pip3 install PyInstaller
  echo "brew list | grep python"
  brew list | grep python
  echo "python3 --version"
  python3 --version
  echo -e "\033[1;32mALL SUCCESEFUL: pythonのインストールが正常に終了しました。\033[0m"
}

function python_uninstall () {
  brew uninstall --ignore-dependencies python3
  pip3 uninstall PyInstaller
  echo -e "\033[1;32mALL SUCCESEFUL: pythonのアンインストールが正常に終了しました。\033[0m"
}

if [ "$1" = --install ]; then
  python_install
elif [ "$1" = --uninstall ]; then
  python_uninstall
else
  echo -e "\033[1;31mERROR: 指定されたオプション $1 は無効です。\033[0m"
  echo -e "\033[1;31m指定可能なオプションは { --install | --uninstall } です。\033[0m"
  exit 1
fi