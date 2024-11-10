# ws dotfiles

ML dev setup and dotfiles for Kubuntu 22.04 LTS.

bootstrap a system:
```bash
wget -qO- https://github.com/williamstarkbio/dotfiles/raw/main/setup.sh | bash
```


## third party files

[git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh) : Bash Git prompt support

update:
```bash
curl -LO https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
```

TODO git-prompt.sh: test replacing with system version after upgrading to Kubuntu 24.04 (`/usr/lib/git-core/git-sh-prompt`)
