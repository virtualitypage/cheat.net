#!/bin/bash

open /Applications/Tailscale.app

if [ $1 == "up" ]; then
  /Applications/Tailscale.app/Contents/MacOS/Tailscale up
elif [ $1 == "down" ]; then
  /Applications/Tailscale.app/Contents/MacOS/Tailscale down
fi
