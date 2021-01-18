# dotfiles

## Restoring files
```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/nickypy/dotfiles.git dotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
```
