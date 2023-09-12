#!/usr/bin/env bash


# Exit immediately if a pipeline (see Pipelines), which may consist of a single simple command (see Simple Commands), a list (see Lists of Commands), or a compound command (see Compound Commands) returns a non-zero status. [...]
set -e

# Print shell input lines as they are read.
set -v


yes_no_question() {
    while true; do
        read -e -r -p "$1 (y/n): " YES_NO_ANSWER < /dev/tty
        case $YES_NO_ANSWER in
            y)
                break
                ;;
            n)
                break
                ;;
            *)
                echo "Please enter \"y\" for yes or \"n\" for no." >&2
                ;;
        esac
    done

    echo "$YES_NO_ANSWER"
}


backup_datetime() {
    # append the suffix .backup and current datetime to a directory or file name

    TARGET="$1"
    DATE_TIME=$(date +%Y-%m-%d_%H:%M:%S%:z)

    if [[ -L "$TARGET" ]]; then
        echo "skipping symbolic link \"$TARGET\""
    elif [[ -d "$TARGET" ]] || [[ -f "$TARGET" ]]; then
        mv --interactive --verbose "$TARGET" "$TARGET.backup_$DATE_TIME"
    fi
}


create_directories() {
    # create $HOME directories
    mkdir --parents --verbose "$HOME/data"
    mkdir --parents --verbose "$HOME/bin"
    mkdir --parents --verbose "$HOME/.config"


    # create /data directory
    sudo mkdir --parents --verbose /data
    sudo chown --verbose "$SCRIPT_USER:$SCRIPT_USER" /data
    # create symbolic link /d to /data
    sudo ln --symbolic --force --verbose /data /d
}


setup_dotfiles() {
    # ws dotfiles
    # https://github.com/williamstark01/dotfiles
    backup_datetime dotfiles
    git clone https://github.com/williamstark01/dotfiles.git

    DOTFILES=(
        .bash_profile
        .bashrc
        .bashrc_local
        .inputrc
        .profile
        .tmux.conf
    )
    for DOTFILE in "${DOTFILES[@]}"; do
        backup_datetime "$DOTFILE"
        ln --symbolic --force --verbose "$HOME/dotfiles/$DOTFILE" "$HOME/"
    done

    backup_datetime .bashrc_temp
    cp --interactive --verbose "$HOME/dotfiles/.bashrc_temp" "$HOME/"

    backup_datetime .gitconfig
    cp --interactive --verbose "$HOME/dotfiles/.gitconfig" "$HOME/"

    # Konsole Tomorrow theme
    # https://github.com/dram/konsole-tomorrow-theme
    if [[ -d "$HOME/.local/share/konsole/" ]]; then
        ln --symbolic --force --verbose "$HOME/dotfiles/.local/share/konsole/Tomorrow.colorscheme" "$HOME/.local/share/konsole/"
    fi

    # disable less `s` key log feature
    # (specify custom key bindings for less, described in `$HOME/.lesskey`)
    # man lesskey
    ln --symbolic --force --verbose "$HOME/dotfiles/.lesskey" "$HOME/"
}


remove_unneeded_packages() {
    UNNEEDED_PACKAGES=(
        vim-tiny
        kubuntu-web-shortcuts
    )

    sudo apt -y purge "${UNNEEDED_PACKAGES[@]}"

    sudo apt -y autoremove
}


install_standard_packages() {
    # curl
    # command line tool for transferring data with URL syntax
    # https://packages.ubuntu.com/jammy/curl
    # https://curl.se/

    # dos2unix
    # convert text file line endings between CRLF and LF
    # https://packages.ubuntu.com/jammy/dos2unix
    # https://manpages.ubuntu.com/manpages/jammy/man1/dos2unix.1.html

    # fd
    # simple, fast and user-friendly alternative to find
    # https://packages.ubuntu.com/jammy/fd-find
    # https://github.com/sharkdp/fd

    # git-lfs
    # Git extension for versioning large files
    # https://packages.ubuntu.com/jammy/git-lfs
    # https://git-lfs.github.com/

    # hashdeep
    # recursively compute hashsums or piecewise hashings
    # https://packages.ubuntu.com/jammy/hashdeep
    # https://github.com/jessek/hashdeep

    # Magic Wormhole
    # securely and simply transfer data between computers
    # https://packages.ubuntu.com/jammy/magic-wormhole
    # https://github.com/magic-wormhole/magic-wormhole

    # ncdu
    # disk usage analyzer with an ncurses interface
    # https://packages.ubuntu.com/jammy/ncdu
    # https://dev.yorhel.nl/ncdu

    # renameutils
    # set of programs to make file renaming easier
    # https://packages.ubuntu.com/jammy/renameutils
    # (includes imv and icp)
    # https://www.nongnu.org/renameutils/

    # ripgrep
    # recursively search file contents for a regex pattern
    # https://packages.ubuntu.com/jammy/ripgrep
    # https://github.com/BurntSushi/ripgrep

    # sqlite3
    # command line interface for SQLite 3
    # https://packages.ubuntu.com/jammy/sqlite3
    # SQLite SQL database engine
    # https://www.sqlite.org
    # https://manpages.ubuntu.com/manpages/jammy/man1/sqlite3.1.html

    # ssh
    # secure shell client and server (metapackage)
    # https://packages.ubuntu.com/jammy/ssh
    # OpenSSH remote login client
    # https://manpages.ubuntu.com/manpages/jammy/man1/ssh.1.html

    # unrar
    # unarchiver for .rar files (non-free version)
    # https://packages.ubuntu.com/jammy/unrar

    # xclip
    # command line interface to X selections (clipboard)
    # https://packages.ubuntu.com/jammy/xclip
    # https://manpages.ubuntu.com/manpages/jammy/man1/xclip.1.html
    # https://github.com/astrand/xclip

    # zstd
    # compress or decompress .zst files
    # https://packages.ubuntu.com/jammy/zstd
    # https://manpages.ubuntu.com/manpages/jammy/man1/zstd.1.html

    STANDARD_PACKAGES=(
        curl
        dos2unix
        fd-find
        git-lfs
        hashdeep
        magic-wormhole
        renameutils
        ripgrep
        sqlite3
        ssh
        unrar
        tmux
        xclip
        zstd
    )

    sudo apt install -y "${STANDARD_PACKAGES[@]}"
}


setup_python() {
    # Python
    # https://www.python.org/

    # install pyenv
    # Python version manager
    # https://github.com/pyenv/pyenv
    if [[ -n "$PYENV_ROOT" ]]; then
        backup_datetime "$PYENV_ROOT"
    else
        PYENV_ROOT="$HOME/.pyenv"
        export PYENV_ROOT
    fi
    # https://github.com/pyenv/pyenv-installer
    curl https://pyenv.run | bash

    # enable pyenv
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # install Python build dependencies
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    # install latest bugfix version of preferred Python minor version
    PREFERRED_PYTHON_MINOR_VERSION="3.10"
    LATEST_PREFERRED_PYTHON_VERSION=$(pyenv latest --known "$PREFERRED_PYTHON_MINOR_VERSION")

    pyenv install $LATEST_PREFERRED_PYTHON_VERSION

    # set global Python to latest
    pyenv global $LATEST_PREFERRED_PYTHON_VERSION

    # upgrade global Python pip
    pip install --upgrade pip

    # install pipx
    # Install and Run Python Applications in Isolated Environments
    # https://github.com/pypa/pipx
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath

    PIPX_BIN_DIR="$HOME/.local/bin"
    export PATH="$PIPX_BIN_DIR:$PATH"

    # Poetry
    # Python dependency manager
    # https://github.com/python-poetry/poetry
    pipx install poetry

    # IPython
    # Python interactive shell
    # https://github.com/ipython/ipython
    pipx install ipython

    # Black
    # Python code formatter
    # https://github.com/psf/black
    pipx install black

    # isort
    # Python imports organizer
    # https://github.com/PyCQA/isort
    pipx install isort

    # yt-dlp
    # video downloader
    # https://github.com/yt-dlp/yt-dlp
    pipx install yt-dlp
}


setup_rust() {
    # Rust
    # https://www.rust-lang.org/

    export RUSTUP_HOME="$HOME/.rustup"
    export CARGO_HOME="$HOME/.cargo"
    export PATH="$CARGO_HOME/bin:$PATH"

    # install
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # setup rustup and cargo autocompletion
    # run "rustup completions" for details
    mkdir --parents --verbose "$HOME/.local/share/bash-completion/completions"
    rustup completions bash > "$HOME/.local/share/bash-completion/completions/rustup"
    rustup completions bash cargo > "$HOME/.local/share/bash-completion/completions/cargo"

    # delta
    # a syntax-highlighting pager for git and diff output
    # https://github.com/dandavison/delta
    cargo install git-delta

    # exa
    # modern ls replacement
    # https://github.com/ogham/exa
    # https://the.exa.website/
    cargo install exa
}


setup_go() {
    # Go programming language
    # https://go.dev/

    # or install from official release distribution:
    # https://go.dev/doc/install

    sudo add-apt-repository ppa:longsleep/golang-backports

    # install latest major version
    sudo apt install -y golang-go

    # load Go environment variables
    export GOROOT="/usr/lib/go"
    export GOPATH="$HOME/go"

    # add bin directories to PATH
    PATH="$GOPATH/bin:$PATH"
    PATH="$GOROOT/bin:$PATH"
    export PATH

    # massren
    # rename files using a text editor
    # https://github.com/laurent22/massren
    go install github.com/laurent22/massren@latest
    massren --config editor "vim"
}


setup_neovim() {
    # Neovim
    # https://github.com/neovim/neovim

    backup_datetime "$HOME/.config/nvim/init.vim"

    # https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu

    #sudo add-apt-repository ppa:neovim-ppa/stable
    #sudo apt install -y neovim

    # Python modules prerequisites
    #sudo apt install -y python3-dev python3-pip

    # https://github.com/neovim/neovim/wiki/Building-Neovim

    # install build prerequisites
    sudo apt-get install ninja-build gettext cmake unzip curl

    SOFTWARE_DIRECTORY="$HOME/data/software"
    mkdir --parents --verbose "$HOME/data/software"

    NEOVIM_BUILD_DIRECTORY="${SOFTWARE_DIRECTORY}/Neovim"
    [[ -d "$NEOVIM_BUILD_DIRECTORY" ]] && backup_datetime "$NEOVIM_BUILD_DIRECTORY"
    git clone https://github.com/neovim/neovim "$NEOVIM_BUILD_DIRECTORY"
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo

    # use Neovim for all editor alternatives
    #sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
    sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 60
    sudo update-alternatives --config vi
    #sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
    sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
    sudo update-alternatives --config vim
    #sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
    sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60
    sudo update-alternatives --config editor

    mkdir --parents --verbose "$HOME/.config/nvim"
    ln --symbolic --force --verbose "$HOME/dotfiles/.config/nvim/init.vim" "$HOME/.config/nvim"

    # setup a Python virtual environment for Neovim
    # https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
    pyenv virtualenv neovim
    pyenv activate neovim
    pip install --upgrade pip
    pip install neovim
    pyenv deactivate

    # setup vim-plug
    # https://github.com/junegunn/vim-plug
    # "$HOME/.local/share/nvim/site/autoload/plug.vim"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    # install packages with vim-plug
    vim +PlugInstall +qa
}


setup_nodejs() {
    # Node.js
    # https://nodejs.org/

    # https://github.com/nvm-sh/nvm
    export NVM_DIR="$HOME/.nvm"
    mkdir --parents --verbose "$NVM_DIR"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

    # install latest LTS version
    nvm install --lts
}


setup_additional_software() {
    # nvme-cli
    # nvme - the NVMe storage command line interface utility (nvme-cli)
    # https://packages.ubuntu.com/jammy/nvme-cli
    # https://manpages.ubuntu.com/manpages/jammy/man1/nvme.1.html

    ADDITIONAL_PACKAGES=(
        nvme-cli
    )

    sudo apt install -y "${ADDITIONAL_PACKAGES[@]}"


    SOFTWARE_DIRECTORY="$HOME/data/software"
    mkdir --parents --verbose "$HOME/data/software"

    # zoxide
    # a smarter cd command
    # https://github.com/ajeetdsouza/zoxide
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # tmux Bash completion
    # https://github.com/imomaliev/tmux-bash-completion
    TMUX_BASH_COMPLETION_DIRECTORY="${SOFTWARE_DIRECTORY}/tmux-bash-completion"
    git clone https://github.com/imomaliev/tmux-bash-completion.git "$TMUX_BASH_COMPLETION_DIRECTORY"
}


install_desktop_packages() {
    # CopyQ
    # https://github.com/hluk/CopyQ

    # diffpdf
    # compare two PDF files textually or visually
    # https://packages.ubuntu.com/jammy/diffpdf
    # http://www.qtrac.eu/diffpdf.html

    # Evince
    # https://wiki.gnome.org/Apps/Evince

    # filelight
    # https://apps.kde.org/filelight/

    # Gimp
    # https://www.gimp.org/
    # https://launchpad.net/~ubuntuhandbook1/+archive/ubuntu/gimp
    #sudo add-apt-repository ppa:ubuntuhandbook1/gimp

    # GNOME Disks
    # https://wiki.gnome.org/Apps/Disks
    # https://gitlab.gnome.org/GNOME/gnome-disk-utility

    # GoldenDict
    # http://goldendict.org/

    # GParted
    # https://gparted.org/

    # Grub Customizer
    # https://launchpad.net/grub-customizer
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer

    # KDiff3
    # https://apps.kde.org/kdiff3/

    # KeePassXC
    # https://keepassxc.org/
    # https://github.com/keepassxreboot/keepassxc
    # https://launchpad.net/~phoerious/+archive/ubuntu/keepassxc
    sudo add-apt-repository ppa:phoerious/keepassxc

    # qBittorrent
    # https://www.qbittorrent.org/
    # https://github.com/qbittorrent/qBittorrent
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable

    # SMPlayer
    # https://www.smplayer.info/

    # Thunderbird
    # https://www.thunderbird.net/

    # Xournal++
    # PDF annotation and notetaking
    # https://github.com/xournalpp/xournalpp

    DESKTOP_PACKAGES=(
        copyq
        diffpdf
        evince
        filelight
        gimp
        gnome-disk-utility
        goldendict
        gparted
        grub-customizer
        kdiff3
        keepassxc
        qbittorrent
        smplayer
        thunderbird
        xournalpp
    )

    sudo apt install -y "${DESKTOP_PACKAGES[@]}"
}


install_google_chrome() {
    # Google Chrome
    # https://www.google.com/chrome
    wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google_linux_signing_key.pub
    sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google_linux_signing_key.pub
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list'
    sudo apt update
    sudo apt install -y google-chrome-stable
}


setup_ufw_firewall() {
    echo "Setting up the ufw firewall..."

    # deny all incoming connections, allow outgoing connections
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # allow incoming SSH connections
    sudo ufw allow ssh

    # allow incoming HTTP and HTTPS connections
    sudo ufw allow http
    sudo ufw allow https

    # turn on the firewall
    sudo ufw enable

    # check the status of the firewall
    sudo ufw status
}


main() {
    cd "$HOME"

    # save user
    SCRIPT_USER=$USER
    echo "logged in as user $SCRIPT_USER"

    export PATH="$HOME/.local/bin:$PATH"

    YES_NO_ANSWER=$(yes_no_question "Update and upgrade the system?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        sudo apt update && sudo apt -y upgrade && sudo apt dist-upgrade
    fi

    YES_NO_ANSWER=$(yes_no_question "Create custom directories?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        create_directories
    fi

    YES_NO_ANSWER=$(yes_no_question "Remove unneeded packages?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        remove_unneeded_packages
    fi

    YES_NO_ANSWER=$(yes_no_question "Install standard packages?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        install_standard_packages
    fi

    YES_NO_ANSWER=$(yes_no_question "Install linux-headers and build-essential packages?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        sudo apt install -y linux-headers-generic build-essential
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up dotfiles?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_dotfiles
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up Python?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_python
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up Neovim?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_neovim
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up Rust?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_rust
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up Go?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_go
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up Node.js?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_nodejs
    fi

    YES_NO_ANSWER=$(yes_no_question "Set up additional software?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        setup_additional_software
    fi

    YES_NO_ANSWER=$(yes_no_question "Install desktop software?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        install_desktop_packages

        install_google_chrome
    fi

    YES_NO_ANSWER=$(yes_no_question "Install server software?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        # Fail2ban
        # daemon to ban hosts that cause multiple authentication errors
        # https://github.com/fail2ban/fail2ban

        # ufw
        # "uncomplicated firewall", program for managing a netfilter firewall
        # https://launchpad.net/ufw

        sudo apt install -y fail2ban ufw

        setup_ufw_firewall
    fi
}


main


echo ""
echo "Setup successful!"
