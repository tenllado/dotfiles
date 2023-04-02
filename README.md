# Dotfiles

I am currently using the technique described in these two posts:
- [workstation-backup-via-git](https://wiki.tinfoil-hat.net/books/workstation-backup-via-git/page/workstation-backup-via-git)
- [dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

To install the dotfiles you have to execute the following lines:

```bash
    alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    git --no-replace-objects clone --bare git@github.com:tenllado/dotfiles.git $HOME/.cfg
    cfg config --local status.showUntrackedFiles no
    cfg checkout -f
```

Now you can config the $HOME/.cfg git report to not checkout REAMDE.md, so that
this README.md file does not pollute your home. We do that using sparse-checkout:

```bash
  cfg config core.sparseCheckout true
  echo -e "/*\n!README.md" >> ~$HOME/.cfg/info/sparse-checkout
  rm $HOME/README.md
```

To complete the setup, we have to add the minpac plugin for vim:

```bash
    mkdir -p ~/.config/vim/pack/minpack/opt
    cd ~/.config/vim/pack/minpack/opt
    git clone git@github.com:k-takata/minpac.git
    cd -
	vim +PackUpdateAndQuit
```
