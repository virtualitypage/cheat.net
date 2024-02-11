#!/bin/bash

progress_bar() {
  current=$1
  total=$2

  progress=$(("$current" * 100 / "$total"))

  bar="$(yes '#' | head -n ${progress} | tr -d '\n')"
  if [ -z "$bar" ]; then
    bar='_'
  fi

  printf "\r[%-100s] (%d/%d)" "$bar" "$current" "$total"
}

total=100
for i in $(seq 1 $total); do
  progress_bar "$i" "$total"
  sleep 0.05
done

echo ""