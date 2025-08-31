#!/bin/bash

pgrep -f Tailscale.app | xargs kill "$1"
open -a Tailscale

# 再起動時はログアウトしているためエラーになる。
# これを伝える処理を追加せよ

