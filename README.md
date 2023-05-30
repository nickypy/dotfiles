# dotfiles

## Restoring files
```shell
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:nickypy/dotfiles.git dotfiles

rsync --recursive --verbose --exclude '.git' dotfiles/ $HOME/
```
