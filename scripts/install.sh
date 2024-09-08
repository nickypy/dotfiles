#!/bin/bash

function install() {
	DEST=$1

	rsync --recursive --verbose --exclude '.git' --exclude '*.md' --exclude 'scripts' . "$DEST"
}

install "$HOME"

if [[ $(uname -r) =~ 'WSL2' ]]; then
	WIN_HOME=$(./scripts/windows_home.sh)
	echo "WSL detected. Copying to $WIN_HOME"
	# FIXME: windows install from WSL
	# install "$WIN_HOME"
fi
