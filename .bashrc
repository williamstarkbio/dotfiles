### .bashrc
# vim: set filetype=sh :

# William Stark (william.stark.5000@gmail.com)


# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ws
# a copy of the default .bashrc resides in /etc/skel/.bashrc


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# don't save lines starting with space and duplicate lines in the history
HISTCONTROL=ignorespace:ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


### prompt command
[[ -f "$HOME/dotfiles/git-prompt.sh" ]] && source "$HOME/dotfiles/git-prompt.sh"
update_prompt() {
    GREEN="\[\033[1;32m\]"
    MAGENTA="\[\033[1;35m\]"
    BLUE="\[\033[1;34m\]"
    COLOR_OFF="\[\033[0m\]"

    # initialize an empty prompt string
    #PROMPT=""

    # add the datetime in the prompt string
    #PROMPT="$MAGENTA\D{%F_%T }$COLOR_OFF"
    # add just the time in the prompt string
    PROMPT="$MAGENTA\D{%T }$COLOR_OFF"

    # if in a virtual environment, prefix the prompt with its name or a symbol
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        # prefix with the virtual environment directory name
        #VIRTUAL_ENV_BASENAME=`basename $VIRTUAL_ENV`
        #PROMPT="$GREEN${VIRTUAL_ENV_BASENAME::-9}$COLOR_OFF "

        # prefix with a symbol
        # http://shapecatcher.com/unicode/info/9679
        BLACK_CIRCLE=$'\u25cf'
        SYMBOL=$BLACK_CIRCLE
        PROMPT="$GREEN$SYMBOL$COLOR_OFF $PROMPT"
    fi

    # append the user, host, and current directory
    PROMPT="$PROMPT\u@\h $BLUE\W$COLOR_OFF"

    # append git repository status
    # git prompt
    # https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    # Fix the issue of missing colors by removing the check "[ $pcmode = yes ]"
    # in git-prompt.sh
    if [[ -f "$HOME/dotfiles/git-prompt.sh" ]]; then
        source "$HOME/dotfiles/git-prompt.sh"
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWCOLORHINTS=1
        GIT_PS1_SHOWUPSTREAM="auto"

        PROMPT="$PROMPT$(__git_ps1 " (%s)")"
    fi

    PS1="$PROMPT\n$ "
}
PROMPT_COMMAND="update_prompt"


# set better colors for ls in the LS_COLORS environment variable
if [[ -x /usr/bin/dircolors ]]; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi
fi
set completion-ignore-case on


### The Shopt Builtin
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# If set, Bash includes filenames beginning with a ‘.’ in the results of filename expansion. The filenames ‘.’ and ‘..’ must always be matched explicitly, even if dotglob is set.
shopt -s dotglob
# If set, Bash matches filenames in a case-insensitive fashion when performing filename expansion.
shopt -s nocaseglob


### require pressing Ctrl-D twice to exit
# NOTE
# Regarding the inclusion of the "export" command before a shell/environment variable:
# https://askubuntu.com/a/58828
IGNOREEOF=1


### Vim
# Use a vi-style line editing interface in the terminal.
#set -o vi
# Set Vim as the default text editor.
EDITOR=vim
VISUAL=vim


### set the $TERM to resolve a terminal rendering error with tmux and Neovim
# https://github.com/neovim/neovim/issues/6403
# https://github.com/neovim/neovim/wiki/FAQ#nvim-shows-weird-symbols-2-q-when-changing-modes
export TERM=konsole-256color


## safety
set -o noclobber


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8


### z
# jump around
# https://github.com/rupa/z
if [[ -f $HOME/data/programs/z/z.sh ]]; then
    source $HOME/data/programs/z/z.sh

    _Z_NO_RESOLVE_SYMLINKS=1
fi


### make aliases work with sudo commands
alias sudo='sudo '


### improve utilities defaults
################################################################################

### black
# The uncompromising code formatter.
aliased_black() {
    if [[ -z "$1" ]]; then
        find ./ -type f -name "*.py" -exec black --line-length 90 "{}" \;
    else
        black --line-length 90 "$@"
    fi
}
alias black='aliased_black'


### cp
# copy files and directories
# -i, --interactive
# prompt before overwrite (overrides a previous -n option)
# --preserve[=ATTR_LIST]
# preserve the specified attributes (default: mode,ownership,timestamps), if possible
# additional attributes: context, links, xattr, all
# -R, -r, --recursive
# copy directories recursively
# -v, --verbose
# explain what is being done
alias cp='cp --interactive --preserve --recursive --verbose'


### df
# report file system disk space usage
# -h, --human-readable
# print sizes in powers of 1024 (e.g., 1023M)
# -x, --exclude-type=TYPE
# limit listing to file systems not of type TYPE
# hide SquashFS filesystems used by Snap
alias df='df --human-readable --exclude-type=squashfs'


### du
# estimate file space usage
# -h, --human-readable
# print sizes in human readable format (e.g., 1K 234M 2G)
# -s, --summarize
# display only a total for each argument
alias du='du -h -s'


### googler
# Google from the terminal
# https://github.com/jarun/googler
alias googler='googler --noua'


### info
# read Info documents
# --vi-keys
# use vi-like and less-like key bindings
alias info='info --vi-keys'


### ip
# show / manipulate routing, network devices, interfaces and tunnels
# -c, -color
# Use color output.
# address
# - protocol (IP or IPv6) address on a device.
alias ipa='ip -color address'


### less
# terminal pager
# -F or --quit-if-one-screen
# automatically exit if the entire file can be displayed on the first screen
# -R or --RAW-CONTROL-CHARS
# handle ANSI "color" escape sequences
# -X or --no-init
# don't clear the screen on exit
#alias less='less -FRX'
aliased_le() {
    clear -x
    if [[ -z "$1" ]]; then
        less -FRX
    else
        for arg in "$@"; do
            less -FRX "$arg"
        done
    fi
}
alias le='aliased_le'


### ls
# list directory contents
# -A, --almost-all
# list entries starting with . (dot), except implied . and ..
# -h, --human-readable
# with -l, print sizes in human readable format (e.g., 1K 234M 2G)
# -l
# use a long listing format
# -N, --literal
# print entry names without quoting
aliased_la() {
    clear -x
    if [[ -z "$1" ]]; then
        ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso
    else
        for arg in "$@"; do
            ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso "$arg"
        done
    fi
}
#alias la='aliased_la'

aliased_lla() {
    clear -x
    if [[ -z "$1" ]]; then
        ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso | less -FRX
    else
        DIR_COLOR=$(__get_directories_color)
        DIR_COLOR="\033[""$DIR_COLOR"m
        #echo $DIR_COLOR
        # \033[01;34m
        COLOR_OFF="\033[0m"
        (
        for arg in "$@"; do
            if [[ -d "$arg" ]]; then
                if [[ -L "$arg" ]]; then
                    ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso "$arg"
                else
                    echo -e "$DIR_COLOR$arg$COLOR_OFF"
                    ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso "$arg"
                fi

                echo
            fi
        done
        for arg in "$@"; do
            if [[ ! -d "$arg" ]]; then
                ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso "$arg"
            fi
        done
        ) | less -FRX
    fi
}
#alias lla='aliased_lla'


### exa
# a modern replacement for ls
# https://github.com/ogham/exa

# make timestamps black
# https://the.exa.website/docs/colour-themes
export EXA_COLORS="da=1;30"
aliased_exa() {
    clear -x
    if [[ -z "$1" ]]; then
        exa --oneline --long --group --header --time-style=long-iso --all --sort=type
    else
        for arg in "$@"; do
            exa --oneline --long --group --header --time-style=long-iso --all --sort=type "$arg"
        done
    fi
}
alias la='aliased_exa'

aliased_exa_paged() {
    clear -x
    exa --oneline --long --group --header --time-style=long-iso --all --sort=type --color=always | less -FRX
}
alias lla='aliased_exa_paged'


### mkdir
# make directories
# -p, --parents
# no error if existing, make parent directories as needed
# -v, --verbose
# print a message for each created directory
alias md='mkdir --parents --verbose'


### mv
# Rename or move a file with mv without typing its name or path twice.
# Pass its name or path to mv just once and enter will allow you to edit
# this argument while a second enter will complete the operation.
# NOTE:
# Maybe incorporating the command imv from the package renameutils would make
# this function even more robust.
# -i, --interactive
# prompt before overwrite
# -v, --verbose
# explain what is being done
aliased_mv() {
    if [[ -z "$1" ]] || [[ "$#" -ne 1 ]]; then
        mv --interactive --verbose "$@"
    else
        read -ei "$1" NEW_FILENAME
        mv --interactive --verbose -- "$1" "$NEW_FILENAME"
    fi
}
alias mv='aliased_mv'


### pgrep, pkill
# look up or signal processes based on name and other attributes
# -l, --list-name
# List the process name as well as the process ID. (pgrep only.)
alias pgrep='pgrep -l'


### rclone
# command line program to sync files and directories to several cloud services
alias rclone='rclone --verbose --retries 17 --retries-sleep=17s'


### rg
# recursively search current directory for lines matching a pattern
# -S, --smart-case
# Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise.
# --no-ignore-vcs
# Don't respect version control ignore files (.gitignore, etc.).
# --hidden
# Search hidden files and directories.
# -g, --glob GLOB ...
# Include or exclude files and directories for searching that match the given glob.
alias rg='rg --smart-case --no-ignore-vcs --hidden --glob "!.git" --glob "!.ipynb_checkpoints" --glob "!.venv"'


### rm
# remove files or directories
# -I
# prompt once before removing more than three files, or when removing recursively.
# -v, --verbose
# explain what is being done
alias rm='rm -I --verbose'


### rsync
# rsync [OPTION...] SRC... [DEST]
# -v, --verbose : increase verbosity
# -r, --recursive : recurse into directories
# -l, --links : copy symlinks as symlinks
# -H, --hard-links : preserve hard links
# -p, --perms : preserve permissions
# -o, --owner : preserve owner (super-user only)
# -g, --group : preserve group
# -t, --times : preserve modification times
# -s, --protect-args : no space-splitting; wildcard chars only
# -h, --human-readable : output numbers in a human-readable format
# --progress : show progress during transfer
# -i, --itemize-changes : output a change-summary for all updates
# -z, --compress : compress file data during the transfer
# --stats : give some file-transfer stats
alias d-rsync='rsync --verbose --recursive --links --hard-links --perms --owner --group --times --protect-args -hh --progress --itemize-changes --compress --stats'


### scp
# secure copy (remote file copy program)
# -p
# Preserves modification times, access times, and modes from the original file.
# -r
# Recursively copy entire directories.  Note that scp follows symbolic links encountered in the tree traversal.
alias scp='scp -p -r'


### tmux
# terminal multiplexer
# -2
# Force tmux to assume the terminal supports 256 colours.
alias tmux='tmux -2'

aliased_tmux() {
    if [[ -z "$1" ]]; then
        echo "Pass the name of the session to open in tmux."
    else
        tmux a -t "$1"
    fi
}
alias t='aliased_tmux'


### tree
# list contents of directories in a tree-like format
# -a : print all files
# -C : always colorize output
# -L <level> : limit depth of directory tree to <level>
alias tree='tree -aC -L 2'


### vim
# Vi IMproved, a programmers text editor
# -p[N]
# Open N tab pages. When N is omitted, open one tab page for each file.
alias vim='vim -p'


### vimdiff
# edit two, three or four versions of a file with Vim and show differences
# -R
# Read-only mode.
alias vimdiff='vimdiff -R'

### youtube-dl
# download best format available but not better that 1080p
alias youtube-dl="youtube-dl --no-mtime --format 'bestvideo[ext=mp4][height<=1080][vcodec!*=av01]+bestaudio[ext=m4a]/best[height<=1080]'"
#alias subs-youtube-dl="youtube-dl --no-mtime --format 'bestvideo[ext=mp4][height<=1080][vcodec!*=av01]+bestaudio[ext=m4a]/best[height<=1080]' --write-sub --sub-lang en"
alias subs-youtube-dl="youtube-dl --no-mtime --format 'bestvideo[ext=mp4][height<=1080][vcodec!*=av01]+bestaudio[ext=m4a]/best[height<=1080]' --write-sub"
################################################################################


### custom commands and shortcuts
################################################################################
alias ..='cd ..'

alias clip='xclip -sel clip'
alias py='python'
alias spyder='spyder3 --workdir=. &'
################################################################################


### git
# the standard version control system
################################################################################

### initialize a git repo, add and commit my default .gitignore
aliased_gi() {
    git init
    cp $HOME/dotfiles/data/.gitignore .
    git add .gitignore
    git commit -m "add .gitignore"
}
alias gi='aliased_gi'


### initialize a repo, add and commit all existing files
aliased_gii() {
    git init
    cp $HOME/dotfiles/data/.gitignore .
    git add .gitignore
    git commit -m "add .gitignore"
    git add .
    git commit -m "import files"
}
alias gii='aliased_gii'


### git add
# add file contents to the index
alias ga='git add'


### git add -p
# -p, --patch
# Interactively choose hunks of patch between the index and the work tree
# and add them to the index.
aliased_gap() {
    clear -x
    if [[ -z "$1" ]]; then
        git add -p
    else
        for arg in "$@"; do
            git add -p "$arg"
        done
    fi
}
alias gap='aliased_gap'


### git status
# show the working tree status
aliased_gst() {
    clear -x
    git status
}
alias gst='aliased_gst'


### git diff
# show changes between commits, commit and working tree, etc
aliased_gd() {
    clear -x
    if [[ -z "$1" ]]; then
        git diff
    else
        for arg in "$@"; do
            git diff "$arg"
        done
    fi
}
alias gd='aliased_gd'


### git diff --cached
# --cached
# view the changes you staged for the next commit
# --staged is a synonym of --cached
aliased_gds() {
    clear -x
    if [[ -z "$1" ]]; then
        git diff --cached
    else
        for arg in "$@"; do
            git diff --cached "$arg"
        done
    fi
}
alias gds='aliased_gds'


### git difftool
# show changes using common diff tools
aliased_gdt() {
    clear -x
    if [[ -z "$1" ]]; then
        git difftool
    else
        for arg in "$@"; do
            git difftool "$arg"
        done
    fi
}
alias gdt=aliased_gdt


### git difftool --cached
# git difftool is a frontend to git diff and accepts the same options and
# arguments.
aliased_gdst() {
    clear -x
    if [[ -z "$1" ]]; then
        git difftool --cached
    else
        for arg in "$@"; do
            git difftool --cached "$arg"
        done
    fi
}
alias gdst='aliased_gdst'


### git commit
# record changes to the repository
alias gc='git commit'


### git commit -a
# -a, --all
# Tell the command to automatically stage files that have been modified
# and deleted, but new files you have not told git about are not affected.
alias gca='git commit -a'


### commit changes in the staging area
alias gcu='git commit -m "update"'


### commit all changes
alias gcau='git commit -a -m "update"'


### git log
# show commit logs
# --decorate
# print out the ref names of any commits that are shown
# --all
# Pretend as if all the refs in refs/ are listed on the command line as
# <commit>.
# --graph
# Draw a text-based graphical representation of the commit history on the
# left hand side of the output.
# --date=iso (or --date=iso8601)
# shows timestamps in ISO 8601 format.
aliased_gl() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject>
    git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s'
}
alias gl='aliased_gl'


### git concise log
# --pretty[=<format>], --format=<format>
# pretty-print the contents of the commit logs in a given format
gll() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject> (committer date, relative)
    git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset'
}

glll() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject> (committer date, relative) <<author name>>
    git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset'
}

gllll() {
    clear -x
    git log --decorate --all --graph --date=iso
}


### git pull
# Fetch from and integrate with another repository or a local branch
alias gpl='git pull'


### git push
# Update remote refs along with associated objects
alias gps='git push'


### git show
# Show various types of objects
aliased_gsh() {
    clear -x
    if [[ -z "$1" ]]; then
        git show
    else
        git show "$1"
    fi
}
alias gsh='aliased_gsh'
################################################################################


### custom functions
################################################################################

### load GitHub SSH key
d-github-ssh() {
    pkill ssh-agent
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa_github
}


### calculations with Python
calc() {
    python -c 'from math import *; import sys; print(eval(" ".join(sys.argv[1:])))' "$@"
}


# open one or multiple files with the registered application
# open a file browser on the current directory if run without arguments
### xdg-open
# opens a file or URL in the user's preferred application
aliased_d_open() {
    if [[ -z "$1" ]]; then
        xdg-open .
    else
        for arg in "$@"; do
            xdg-open "$arg"
        done
    fi
}
alias d-open='aliased_d_open'


### md5 hash function
aliased_md5sum() {
    if [[ -z "$1" ]]; then
        md5sum *
    else
        for arg in "$@"; do
            md5sum "$arg"
        done
    fi
}
alias m5='aliased_md5sum'


### sha1 hash function
aliased_sha1sum() {
    if [[ -z "$1" ]]; then
        sha1sum *
    else
        for arg in "$@"; do
            sha1sum "$arg"
        done
    fi
}
alias s1='aliased_sha1sum'


### generate and save hashes of files
aliased_d_hash_generate() {
    if [[ -z "$1" ]]; then
        shopt -s extglob
        # NOTE
        # use ">|" instead of ">" to temporarily override the noclobber option enabled in Bash
        hashdeep -j0 -r -e -l !(file_hashes.txt) > file_hashes.txt
        shopt -u extglob
    else
        hashdeep -j0 -r -e -l "$@" > file_hashes.txt
    fi
}
alias d-hash_generate='aliased_d_hash_generate'


### read and verify hashes of files
aliased_d_hash_verify() {
    if [[ -z "$1" ]]; then
        shopt -s extglob
        hashdeep -j0 -r -e -l -a -v -k file_hashes.txt !(file_hashes.txt)
        shopt -u extglob
    else
        hashdeep -j0 -r -e -l -a -v -k file_hashes.txt "$@"
    fi
}
alias d-hash_verify='aliased_d_hash_verify'


### zip
# package and compress (archive) files
# -r, --recurse-paths
# Travel the directory structure recursively
# -y, --symlinks
# store symbolic links as such in the zip archive, instead of compressing and
# storing the file referred to by the link.
### compress to zip
aliased_d_compress_zip() {
    if [[ -z "$1" ]]; then
        echo "compress to a zip archive with the same filename"
        echo "usage: d-compress-zip <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        # remove trailing slash
        arg=${arg%/}

        zip --recurse-paths --symlinks "$arg".zip "$arg"
    done
}
alias d-compress-zip='aliased_d_compress_zip'


### compress to tgz
aliased_d_compress_tgz() {
    if [[ -z "$1" ]]; then
        echo "compress to a tgz archive with the same filename"
        echo "usage: d-compress-tgz <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        # remove trailing slash
        arg=${arg%/}

        tar -c -z -f "$arg".tgz "$arg"
    done
}
alias d-compress-tgz='aliased_d_compress_tgz'


### compress to 7z
aliased_d_compress_7z() {
    if [[ -z "$1" ]]; then
        echo "compress to a 7z archive with the same filename"
        echo "usage: d-compress-7z <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        # remove trailing slash
        arg=${arg%/}

        7z a "$arg".7z "$arg"
    done
}
alias d-compress-7z='aliased_d_compress_7z'


### extract an archive
aliased_d_extract() {
    if [[ -z "$1" ]]; then
        echo "extract a zip, tgz, 7z, rar, gz, bz2, xz, or tar archive"
        echo "usage: d-extract <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        echo "$arg"

        case "$arg" in
            *.zip)
                unzip "$arg"
            ;;
            *.tar|*.tar.gz|*.tgz|*.bz2|*.xz)
                tar -x -v -f "$arg"
            ;;
            *.gz)
                #gunzip -k "$arg"
                # use shell redirections that work in versions lower than 1.6
                gunzip < "$arg" > "${arg%.*}"
            ;;
            *.rar)
                unrar x "$arg"
            ;;
            *.7z)
                FILENAME=$(basename "$arg")
                FILENAME_STEM="${FILENAME%.*}"

                # count objects in the root directory
                num_objects=$(7z l "$arg" -slt "$arg" | grep -c 'Path = [^/]*$')

                # if num_objects > 2 add -o switch (the archive itself is included in the count)
                if [[ $num_objects -gt 2 ]]; then
                    opt="-o${FILENAME_STEM}"
                fi

                7z x "${opt}" "$arg"
            ;;
        esac
    done
}
alias d-extract='aliased_d_extract'


### create a backup copy of a directory or file
aliased_d_backup() {
    if [[ -z "$1" ]]; then
        echo "create a backup copy of a directory or file"
        echo "usage: d-backup <FILE> [<FILE> ...]"
        return 0
    fi

    DATE_TIME=$(date +%Y-%m-%d_%H:%M:%S%:z)

    for arg in "$@"; do
        # remove trailing slash
        TARGET=${arg%/}

        if [[ -L "$TARGET" ]]; then
            echo "skipping symbolic link \"$TARGET\""
        elif [[ -d "$TARGET" ]]; then
            cp --interactive --preserve --recursive "$TARGET" "$TARGET.backup_$DATE_TIME"
        elif [[ -f "$TARGET" ]]; then
            DIRECTORY_PATH=$(dirname "$arg")
            FILENAME=$(basename "$TARGET")
            FILENAME_STEM="${FILENAME%.*}"
            FILE_EXTENSION=$([[ "$FILENAME" = *.* ]] && echo ".${FILENAME##*.}" || echo '')
            cp --interactive --preserve --recursive "$TARGET" "$DIRECTORY_PATH/$FILENAME_STEM.backup_$DATE_TIME$FILE_EXTENSION"
        fi
    done
}
alias d-backup='aliased_d_backup'


### format / beautify JSON files
aliased_d_json_format() {
    if [[ -z "$1" ]]; then
        echo "format / beautify JSON files"
        echo "usage: d-format_json <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        DIRECTORY_PATH=$(dirname "$arg")
        FILENAME=$(basename "$arg")
        FILENAME_STEM="${FILENAME%.*}"
        cat "$arg" | python -m json.tool > "$DIRECTORY_PATH/$FILENAME_STEM.formatted.json"
    done
}
alias d-json_format='aliased_d_json_format'


### compile a C program
aliased_d_c_compile() {
    arg="$1"
    if [[ -z "$arg" ]]; then
        echo "d-c-compile requires a C source file as an argument"
    else
        gcc -Wall -g "$arg" -o "${arg%.c}"
    fi
}
alias d-c-compile='aliased_d_c_compile'


### find
# search for files in a directory hierarchy
# -name <pattern>
# Base of file name (the path with the leading directories removed) matches shell pattern
# <pattern>. [...]
# -iname pattern
# Like -name, but the match is case insensitive. [...]
aliased_f() {
    clear -x
    if [[ -z "$1" ]]; then
        echo "nothing to search for"
    else
        find . -iname "*$1*"
    fi
}
alias f='aliased_f'


### remove unnecessary files
d-cleanup() {
    find . -type d \( -path "./.venv/*" \) -prune -o -type f -name "*.pyc" -print -exec rm -r "{}" \;
    find . -type d \( -path "./.venv/*" \) -prune -o -type f -name ".DS_Store" -print -exec rm -r "{}" \;
    find . -type d \( -path "./.venv/*" \) -prune -o -type f -name "Thumbs.db" -print -exec rm -r "{}" \;
    find . -type d \( -path "./.venv/*" \) -prune -o -type d -name "__MACOSX" -print -prune -exec rm -r "{}" \;
    find . -type d \( -path "./.venv/*" \) -prune -o -type d -name "__pycache__" -print -prune -exec rm -r "{}" \;
    find . -type d \( -path "./.venv/*" \) -prune -o -type d -name ".pytest_cache" -print -prune -exec rm -r "{}" \;
}


### update and upgrade the system
d-update-and-upgrade() {
    printf "sudo apt update\n---\n"
    sudo apt update
    if [[ $? -ne 0 ]]; then
        return -1
    fi

    printf "sudo apt upgrade\n---\n"
    sudo apt upgrade
    if [[ $? -ne 0 ]]; then
        return -1
    fi

    printf "sudo apt dist-upgrade\n---\n"
    sudo apt dist-upgrade
    if [[ $? -ne 0 ]]; then
        return -1
    fi

    return 0
}


### wcc
# print newline, word, and character counts for each file
### wc
# print newline, word, and byte counts for each file
# -m, --chars
# print the character counts
# -l, --lines
# print the newline counts
# -w, --words
# print the word counts
aliased_wcc() {
    if [[ -z "$1" ]]; then
        echo "print the number of lines, words, and characters of a text file"
        echo "usage: wcc <file_path>"
    else
        for arg in "$@"; do
            wc -l -w -m "$arg"
        done
    fi
}
alias wcc='aliased_wcc'


### d755_f644
# set directory permissions to 755 and file permissions to 644
d_d755_f644() {
    if [[ -z "$1" ]]; then
        # chmod 755 to all directories
        find . -type d -exec chmod 755 {} \;
        # chmod 644 to all files
        find . -type f -exec chmod 644 {} \;
    else
        for arg in "$@"; do
            if [[ -d "$arg" ]]; then
                chmod 755 "$arg"
            elif [[ -f "$arg" ]]; then
                chmod 644 "$arg"
            fi
        done
    fi
}
alias d-d755_f644='d_d755_f644'
################################################################################


### internal Bash functions
################################################################################
### get the color used by ls for directories
__get_directories_color() {
    # set the Internal Field Separator
    IFS=':'
    # create an array from LS_COLORS
    LS_COLORS_ARRAY=( $LS_COLORS )
    # search for and store the color from the directories entry
    for ENTRY in "${LS_COLORS_ARRAY[@]}"; do
        if [[ "${ENTRY:0:3}" == "di=" ]]; then
            DIR_COLOR="${ENTRY##di=}"
            # DIR_COLOR is set to "01;34"
            break
        fi
    done

    echo "$DIR_COLOR"
}
################################################################################


## executable settings
################################################################################
## Python

### Poetry
[[ -d "$HOME/.poetry/bin" ]] && export PATH="$HOME/.poetry/bin:$PATH"

### pipx
#eval "$(register-python-argcomplete pipx)"

### environment variables
# use pudb for debugging globally
export PYTHONBREAKPOINT="pudb.set_trace"


## Rust
# https://rustup.rs/
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"


## Deno
if [[ -d "$HOME/.deno" ]]; then
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi


## Go
if command -v go &> /dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$HOME/go/bin:$PATH"
fi


## Ruby
# http://rvm.io/
if [[ -s "$HOME/.rvm/bin" ]]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    # set ~/gems as Ruby Gems installation directory
    export GEM_HOME=$HOME/gems
    export PATH=$HOME/gems/bin:$PATH
fi


## Haskell
[[ -s "$HOME/.cabal/bin" ]] && export PATH="$PATH:$HOME/.cabal/bin"


## AWS
# enable AWS CLI command completion
#complete -C aws_completer aws


## Node.js
# https://github.com/nvm-sh/nvm
[[ -d "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"
# load nvm
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
# load nvm bash_completion
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"


### add GPG key
export GPG_TTY=$(tty)
################################################################################


### local settings
if [[ -f $HOME/.bashrc_local ]]; then
    source $HOME/.bashrc_local
fi


### EMBL-EBI
if [[ -f $HOME/.bashrc_ebi ]]; then
    source $HOME/.bashrc_ebi
fi


### ws computer
if [[ -f $HOME/.bashrc_ws ]]; then
    source $HOME/.bashrc_ws
fi


### direnv
# https://github.com/direnv/direnv
# hook direnv to bash
# NOTE: this should appear after any shell extension that manipulates the prompt
eval "$(direnv hook bash)"
