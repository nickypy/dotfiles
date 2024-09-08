#!/usr/bin/env bash

# shellcheck disable=SC2016
WIN_HOME="$(wslpath "$(powershell.exe '$env:USERPROFILE')")"

echo -n "$WIN_HOME"

