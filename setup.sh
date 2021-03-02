#!/usr/bin/env bash

# William Stark (william.stark.5000@gmail.com)


# Exit immediately if a pipeline (which may consist of a single  simple  command),
# a list, or a compound command, exits with a non-zero status.
set -e


yes_no_question() {
    while true; do
        read -e -p "$1 (y/n): " YES_NO_ANSWER
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

    echo $YES_NO_ANSWER
}


# append the suffix .backup and current datetime to a directory or file name
backup_datetime() {
    TARGET="$1"
    DATE_TIME=$(date +%Y-%m-%d_%H:%M:%S%:z)

    if [[ -L "$TARGET" ]]; then
        echo "skipping symbolic link \"$TARGET\""
    elif [[ -d "$TARGET" ]] || [[ -f "$TARGET" ]]; then
        mv --interactive --verbose "$TARGET" "$TARGET.backup_$DATE_TIME"
    fi
}


setup_firewall() {
    # https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server

    echo "Setting up the ufw firewall..."
    # deny all incoming connections except for ssh
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh

    # turn on the firewall
    sudo ufw enable

    # enable incoming connections for a web server
    sudo ufw allow http
    sudo ufw allow https

    # check the status of the firewall
    sudo ufw status
}


STANDARD_PACKAGES=(
    dos2unix
    hashdeep
    git
    p7zip-rar
    python-argcomplete
    ssh
    tmux
    tree
    unrar
    unzip
    xclip
    zip
)
install_standard_packages() {
    sudo apt install -y $STANDARD_PACKAGES

    # setup unattended security upgrades
    sudo apt install unattended-upgrades
    sudo dpkg-reconfigure unattended-upgrades
}


install_google_chrome() {
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

    sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

    sudo apt install -y google-chrome-stable adobe-flashplugin
}


install_desktop_packages() {
    # CopyQ
    # https://github.com/hluk/CopyQ
    sudo add-apt-repository ppa:hluk/copyq

    # Gimp
    sudo add-apt-repository ppa:otto-kesselgulasch/gimp

    # Grub Customizer
    sudo add-apt-repository ppa:danielrichter2007/grub-customizer

    DESKTOP_PACKAGES=(
        copyq
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
        thunderbird
    )

    sudo apt install -y $DESKTOP_PACKAGES

    install_google_chrome
}


setup_neovim() {
    # https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu

    backup_datetime .vim
    backup_datetime .vimrc

    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt install -y neovim

    ln -s -f -v /usr/bin/nvim $HOME/bin/vim

    cp -r -i -v dotfiles/.vim .vim
    ln -s -f -v $HOME/dotfiles/.vimrc .

    mkdir -p -v $HOME/.config/nvim/
    cp -p -i -v dotfiles/data/init.vim $HOME/.config/nvim/

    # setup a Python virtual environment for Neovim
    # https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
    pyenv virtualenv neovim
    pyenv activate neovim
    pip install neovim
    pyenv deactivate

    # setup vim-plug
    # https://github.com/junegunn/vim-plug
    #curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # install configured bundles
    #vim +PlugInstall +qa
}


setup_nodejs() {
    # https://github.com/nvm-sh/nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        source "$HOME/.nvm/nvm.sh"
    fi

    nvm install --lts
}


setup_ripgrep() {
    # https://github.com/BurntSushi/ripgrep
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
    sudo dpkg -i ripgrep_11.0.2_amd64.deb
    rm -v ripgrep_11.0.2_amd64.deb
}


create_data_directory() {
    sudo mkdir -p -v /data

    sudo chown -v $SCRIPT_USER:$SCRIPT_USER /data

    # create the symbolic link /d
    sudo ln -s -f -v /data /d
}


setup_python() {
    # install pyenv
    PYENV_ROOT="$HOME/.pyenv"
    backup_datetime $PYENV_ROOT
    export $PYENV_ROOT
    curl https://pyenv.run | bash

    # enable pyenv
    #export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # install xxenv-latest
    # https://github.com/momo-lab/xxenv-latest
    git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest

    # install requirements for building Python
    # https://github.com/pyenv/pyenv/wiki/Common-build-problems
    sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

    PYTHON_LATEST_VERSION=$(pyenv install-latest --print)

    pyenv install $PYTHON_LATEST_VERSION
    pyenv global $PYTHON_LATEST_VERSION

    pip install --upgrade pip

    # install Poetry
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
}


setup_python_programs() {
    # install pipx
    # https://github.com/pipxproject/pipx
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath

    PIPX_BIN_DIR="$HOME/.local/bin"
    export PATH="$PIPX_BIN_DIR:$PATH"

    pipx install youtube-dl
}


main() {
    # check whether the computer is running a Debian derivative
    if ! command -v dpkg &> /dev/null; then
        echo "this script is meant to be run on an Kubuntu or Ubuntu system"
        exit 1
    fi


    cd $HOME


    # global variables
    SCRIPT_USER=$USER
    echo "you are logged in as user $SCRIPT_USER"


    YES_NO_ANSWER=$(yes_no_question "Do you have superuser rights on this system?")
    if [[ $YES_NO_ANSWER = "y" ]]; then
        SUPERUSER_RIGHTS="y"
    else
        echo "Skipping commands that require superuser rights."
    fi


    if [[ "$SUPERUSER_RIGHTS" == "y" ]]; then
        YES_NO_ANSWER=$(yes_no_question "Update and upgrade the system?")
        if [[ $YES_NO_ANSWER = "y" ]]; then
            sudo apt update && sudo apt -y upgrade && sudo apt dist-upgrade
        fi
    fi


    # configuration
    ################################################################################

    # create $HOME directories
    mkdir -p -v bin
    mkdir -p -v ".config"

    backup_datetime dotfiles
    git clone https://github.com/williamstark01/dotfiles.git


    DOTFILES=(
        .bash_profile
        .bashrc
        .inputrc
        .profile
        .pylintrc
        .tmux.conf
    )

    for DOTFILE in "${DOTFILES[@]}"; do
        backup_datetime "$DOTFILE"
    done

    for DOTFILE in "${DOTFILES[@]}"; do
        ln -s -f -v $HOME/dotfiles/"$DOTFILE" .
    done

    # link .config/flake8
    ln -s -f -v $HOME/dotfiles/.config/flake8 .config/


    backup_datetime .bashrc_local
    cp -i -v dotfiles/.bashrc_local .bashrc_local

    backup_datetime .gitconfig
    cp -i -v dotfiles/.gitconfig .gitconfig

    setup_diff_so_fancy() {
        # https://github.com/so-fancy/diff-so-fancy
        cd "$HOME/bin"
        wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
        chmod +x diff-so-fancy
        # go to the previous directory
        cd -
    }
    setup_diff_so_fancy

    # Konsole Tomorrow theme
    # https://github.com/dram/konsole-tomorrow-theme
    if [[ -d "$HOME/.local/share/konsole/" ]]; then
        cp -i -v -f dotfiles/data/Tomorrow.colorscheme $HOME/.local/share/konsole/
    fi
    ################################################################################


    if [[ "$SUPERUSER_RIGHTS" == "y" ]]; then
        install_standard_packages

        create_data_directory

        setup_python
        setup_python_programs
        setup_neovim
        # setup_nodejs
        setup_ripgrep

        # z
        # https://github.com/rupa/z
        # NOTE
        # use my own fork that supports smart case sensitivity by merging ericbn's
        # pull request https://github.com/rupa/z/pull/221
        # https://github.com/williamstark01/z
        mkdir -p -v $HOME/programs

        Z_ROOT_DIRECTORY="$HOME/programs/z"
        [[ -d "$Z_ROOT_DIRECTORY" ]] && backup_datetime "$Z_ROOT_DIRECTORY"
        git clone https://github.com/williamstark01/z.git "$Z_ROOT_DIRECTORY"

        YES_NO_ANSWER=$(yes_no_question "Is this a desktop system?")
        if [[ $YES_NO_ANSWER = "y" ]]; then
            install_desktop_packages
        fi

        YES_NO_ANSWER=$(yes_no_question "Is this a server system?")
        if [[ $YES_NO_ANSWER = "y" ]]; then
            sudo apt install -y fail2ban ufw

            setup_firewall
        fi
    fi


    # install the linux-headers and build-essential packages
    if [[ "$SUPERUSER_RIGHTS" == "y" ]]; then
        YES_NO_ANSWER=$(yes_no_question "Install linux-headers and build-essential packages?")
        if [[ $YES_NO_ANSWER = "y" ]]; then
            sudo apt install -y linux-headers-generic build-essential
        fi
    fi


    # root customizations
    root_customizations() {
        echo "not implemented yet"
    }
    if [[ "$SUPERUSER_RIGHTS" == "y" ]]; then
        YES_NO_ANSWER=$(yes_no_question "Install customizations for the root account?")
        if [[ $YES_NO_ANSWER = "y" ]]; then
            root_customizations
        fi
    fi
}


main


echo ""
echo "System setup successful!"
