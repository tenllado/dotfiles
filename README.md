# Dotfiles

I am currently using the technique described in these two posts:
- [workstation-backup-via-git](https://wiki.tinfoil-hat.net/books/workstation-backup-via-git/page/workstation-backup-via-git)
- (dotfiles)[https://www.atlassian.com/git/tutorials/dotfiles]

To install the dotfiles you have to execute the following lines:

```bash
    git --no-replace-objects clone --bare git@github.com:tenllado/dotfiles.git $HOME/.cfg
    config config --local status.showUntrackedFiles no
    config checkout -f
    rm ~/README.md
    mkdir -p ~/.config/vim/pack/minpack/opt
    cd ~/.config/vim/pack/minpack/opt
    git clone git@github.com:k-takata/minpac.git
    cd -
```

