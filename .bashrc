### .bashrc
# vim: set filetype=sh :


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

# shopt [-pqsu] [-o] [optname ...]
# Toggle the values of settings controlling optional shell behavior. [...]
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# extglob
# If the extglob shell option is enabled using the shopt builtin, several extended pattern matching operators are recognized. [...]
# !(pattern-list)
# Matches anything except one of the given patterns
shopt -s extglob

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


### prompt command
[[ -f "$HOME/dotfiles/git-prompt.sh" ]] && source "$HOME/dotfiles/git-prompt.sh"
update_prompt() {
    # define colors with ANSI escape codes
    # https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences/33206814#33206814
    # https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
    GREEN="\033[32;1m"
    MAGENTA="\033[35;1m"
    BLUE="\033[34;1m"
    COLOR_OFF="\033[0m"

    # add the current time to the prompt string
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
    # missing colors issue fixed in git-prompt.sh
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


# enable Bash programmable completion features
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi


# dotglob
# If set, bash includes filenames beginning with a `.' in the results of pathname expansion. The filenames `.' and `..' must always be matched explicitly, even if dotglob is set.
shopt -s dotglob
# nocaseglob
# If set, bash matches filenames in a case-insensitive fashion when performing pathname expansion [...]
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


### set the $TERM to resolve rendering issues with tmux and Neovim
# https://github.com/neovim/neovim/wiki/FAQ#nvim-shows-weird-symbols-2-q-when-changing-modes
# https://github.com/tmux/tmux/wiki/FAQ#what-is-term-and-what-does-it-do
# Neovim
# :help $TEMP
export TERM=konsole-256color


## safety
set -o noclobber


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8


### make aliases work with sudo commands
alias sudo='sudo '


### improve utilities defaults
################################################################################

### black
# The uncompromising code formatter.
# https://github.com/psf/black
#alias black='black --line-length 90'


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
# --command=FILE
# Specify command to run instead of the default `mv' or `cp'.
# (required by Exodus bundled icp)
### icp
# Rename or copy a file by editing the destination name using GNU readline.
alias cp='icp --command=cp --pass-through --interactive --preserve --recursive --verbose'

### mv
# move (rename) files
# -i, --interactive
# prompt before overwrite
# -v, --verbose
# explain what is being done
# --command=FILE
# Specify command to run instead of the default `mv' or `cp'.
# (required by Exodus bundled imv)
### imv
# Rename or copy a file by editing the destination name using GNU readline.
alias mv='imv --command=mv --pass-through --interactive --verbose'


### df
# report file system disk space usage
# -h, --human-readable
# print sizes in powers of 1024 (e.g., 1023M)
# -x, --exclude-type=TYPE
# limit listing to file systems not of type TYPE
# hide SquashFS filesystems used by Snap
alias df='df --human-readable --exclude-type=squashfs'


### diff
# compare files line by line
# -q, --brief
# report only when files differ
# -r, --recursive
# recursively compare any subdirectories found
# --no-dereference
# don't follow symbolic links
alias diff='diff --brief --recursive --no-dereference'


### du
# estimate file space usage
# -c, --total
# produce a grand total
# -h, --human-readable
# print sizes in human readable format (e.g., 1K 234M 2G)
# -s, --summarize
# display only a total for each argument
alias du='du -c -h -s'


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
alias le='less --quit-if-one-screen --RAW-CONTROL-CHARS --no-init'


### exa
# a modern replacement for ls
# https://github.com/ogham/exa
# specify timestamps color
# https://the.exa.website/docs/colour-themes
# black
#export EXA_COLORS="da=1;90"
# cyan
export EXA_COLORS="da=1;36"
la() {
    clear -x
    if [[ -x "$(command -v exa)" ]]; then
        if [[ -z "$1" ]]; then
            exa --oneline --long --binary --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git
        else
            for arg in "$@"; do
                exa --oneline --long --binary --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git "$arg"
            done
        fi
    else
        if [[ -z "$1" ]]; then
            ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso
        else
            for arg in "$@"; do
                ls -Ahl -N --color=always --group-directories-first --sort=extension --time-style=long-iso "$arg"
            done
        fi
    fi
}

lla() {
    # paged la
    clear -x
    if [[ -z "$1" ]]; then
        exa --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always | less -FRX
    else
        (
        for arg in "$@"; do
            exa --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always "$arg"
        done
        ) | less -FRX
    fi
}

lat() {
    # exa tree
    clear -x
    if [[ -z "$1" ]]; then
        exa --tree --level=2 --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always | less -FRX
    else
        exa --tree --level=2 --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always "$1" | less -FRX
    fi
}

latt() {
    # exa tree level 3
    clear -x
    if [[ -z "$1" ]]; then
        exa --tree --level=3 --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always | less -FRX
    else
        exa --tree --level=3 --oneline --long --group --header --time-style=long-iso --all --sort=extension --group-directories-first --git --color=always "$1" | less -FRX
    fi
}


### mkdir
# make directories
# -p, --parents
# no error if existing, make parent directories as needed
# -v, --verbose
# print a message for each created directory
alias md='mkdir --parents --verbose'


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
#alias rg='rg --smart-case --no-ignore-vcs --hidden --glob "!.git" --glob "!.ipynb_checkpoints" --glob "!.venv" --glob "!*.ipynb"'
# default functionality considering .gitignore is most probably optimal
alias rg='rg --smart-case --hidden --glob "!.git" --glob "!.ipynb_checkpoints" --glob "!.venv" --glob "!*.ipynb"'


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


### Neovim (nvim)
# -p[N]
# Open N tab pages. If [N] is not given, one tab page is opened for every file
# given as argument.
alias vim='vim -p'
#alias vimdiff='nvim -d'
alias vimdiff='nvim -d -c "set foldlevel=9999"'


### watch
# execute a program periodically, showing output fullscreen
# -c, --color
# Interpret ANSI color and style sequences.
# -x, --exec
# Pass command to exec(2) instead of sh -c which reduces the need to use extra quoting to get
# the desired effect.
# enable alias expansion
alias watch='watch --color --exec bash -ic '
################################################################################


### custom commands and shortcuts
################################################################################
alias ..='cd ..'

alias clip='xclip -sel clip'
alias py='python'
alias wiki='z wiki'
################################################################################


### git
# the standard version control system
################################################################################

### initialize a git repo, add and commit my default .gitignore
gi() {
    # git init
    # -b <branch-name>, --initial-branch=<branch-name>
    # Use the specified name for the initial branch in the newly created repository. [...]
    git init --initial-branch main
    cp $HOME/dotfiles/.gitignore .
    git add .gitignore
    git commit -m "add .gitignore"
}


### initialize a repo, add and commit all existing files
gii() {
    # git init
    # -b <branch-name>, --initial-branch=<branch-name>
    # Use the specified name for the initial branch in the newly created repository. [...]
    git init --initial-branch main
    cp $HOME/dotfiles/.gitignore .
    git add .gitignore
    git commit -m "add .gitignore"
    git add .
    git commit -m "import files"
}


### git add
# add file contents to the index
alias ga='git add'


### git add -p
# -p, --patch
# Interactively choose hunks of patch between the index and the work tree
# and add them to the index.
gap() {
    clear -x
    if [[ -z "$1" ]]; then
        git add -p
    else
        for arg in "$@"; do
            git add -p "$arg"
        done
    fi
}


### git status
# show the working tree status
gst() {
    clear -x
    git status
}


### git diff
# show changes between commits, commit and working tree, etc
gd() {
    clear -x
    if [[ -z "$1" ]]; then
        git diff
    else
        for arg in "$@"; do
            git diff "$arg"
        done
    fi
}
### git diff --cached
# --cached
# view the changes you staged for the next commit
# --staged is a synonym of --cached
gds() {
    clear -x
    git diff --cached
}
### git difftool
# show changes using common diff tools
gdt() {
    clear -x
    if [[ -z "$1" ]]; then
        git difftool
    else
        for arg in "$@"; do
            git difftool "$arg"
        done
    fi
}
### git difftool --cached
# git difftool is a frontend to git diff and accepts the same options and arguments
gdst() {
    clear -x
    git difftool --cached
}


### git commit
# record changes to the repository
alias gc='git commit'


### git commit --all
# -a, --all
# Tell the command to automatically stage files that have been modified
# and deleted, but new files you have not told git about are not affected.
alias gca='git commit --all'


### commit changes in the staging area
alias gcu='git commit --message "update"'


### commit all changes
alias gcau='git commit --all --message "update"'


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
gl() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject>
    if [[ -z "$1" ]]; then
        git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s'
    else
        if [[ "$1" == "." ]]; then
            # show log for current branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s' --first-parent $(git rev-parse --abbrev-ref HEAD)
        else
            # show log for specified branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s' --first-parent "$1"
        fi
    fi
}


### git concise log
# --pretty[=<format>], --format=<format>
# pretty-print the contents of the commit logs in a given format
gll() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject> (committer date, relative)
    if [[ -z "$1" ]]; then
        git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset'
    else
        if [[ "$1" == "." ]]; then
            # show log for current branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset' --first-parent $(git rev-parse --abbrev-ref HEAD)
        else
            # show log for specified branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset' --first-parent "$1"
        fi
    fi
}

glll() {
    clear -x
    # <abbreviated commit hash> (<ref names>) <subject> (committer date, relative) <<author name>>
    if [[ -z "$1" ]]; then
        git log --decorate --all --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset'
    else
        if [[ "$1" == "." ]]; then
            # show log for current branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --first-parent $(git rev-parse --abbrev-ref HEAD)
        else
            # show log for specified branch only
            git log --decorate --graph --pretty=format:'%C(yellow bold)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --first-parent "$1"
        fi
    fi
}

gllll() {
    clear -x
    if [[ -z "$1" ]]; then
        git log --decorate --all --graph --date=iso
    else
        if [[ "$1" == "." ]]; then
            # show log for current branch only
            git log --decorate --graph --date=iso --first-parent $(git rev-parse --abbrev-ref HEAD)
        else
            # show log for specified branch only
            git log --decorate --graph --date=iso --first-parent "$1"
        fi
    fi
}


### git pull
# Fetch from and integrate with another repository or a local branch
alias gpl='git pull'


### git push
# Update remote refs along with associated objects
alias gps='git push'


### git show
# Show various types of objects
gsh() {
    clear -x
    if [[ -z "$1" ]]; then
        git show
    else
        git show "$1"
    fi
}
################################################################################


### yt-dlp
# download videos from YouTube and other video platforms
# https://github.com/yt-dlp/yt-dlp
################################################################################
# https://github.com/yt-dlp/yt-dlp#format-selection
# https://github.com/yt-dlp/yt-dlp#format-selection-examples
# download and merge the best, but no better than 1080p, video-only format and
# the best audio-only format, or download the best, but no better than 1080p, combined
# format if video-only format is not available
YT_DLP_FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"

#YT_RATE_LIMIT="10M"
YT_RATE_LIMIT="5M"
#YT_RATE_LIMIT="2M"
#YT_RATE_LIMIT="1M"

# -r, --limit-rate RATE
# Maximum download rate in bytes per second, e.g. 50K or 4.2M
# --no-mtime
# Do not use the Last-modified header to set the file modification time
# -f, --format FORMAT
# Video format code, see "FORMAT SELECTION" for more details
# --embed-chapters
# Add chapter markers to the video file (Alias: --add-chapters)
# --merge-output-format FORMAT
# Containers that may be used when merging formats, separated by "/", e.g. "mp4/mkv".
# Ignored if no merge is required. (currently supported: avi, flv, mkv, mov, mp4, webm)
# --sub-langs LANGS
# Languages of the subtitles to download (can be regex) or "all" separated by commas,
# e.g. --sub-langs "en.*,ja". You can prefix the language code with a "-" to exclude it
# from the requested languages, e.g. --sub-langs all,-live_chat. Use --list-subs for
# a list of available language tags
YT_COMMON_ARGUMENTS=(
    --limit-rate "$YT_RATE_LIMIT"
    --no-mtime
    --format "$YT_DLP_FORMAT"
    --embed-chapters
    --merge-output-format mkv
    --sub-langs "en"
)

yt() {
    # YouTube playlist
    ############################################################################
    # using "%(title).200B" instead of "%(title)s" to truncate the title to 200 bytes
    # https://github.com/yt-dlp/yt-dlp/issues/1837#issuecomment-1100889801
    # https://github.com/yt-dlp/yt-dlp/issues/1136#issuecomment-932077195

    # TODO
    # remove or replace redundant option with its equivalent
    # --playlist-start NUMBER  ==  -I NUMBER:
    # -I, --playlist-items ITEM_SPEC
    # Comma separated playlist_index of the items to download. You can specify a range
    # using "[START]:[STOP][:STEP]". For backward compatibility, START-STOP is also
    # supported. Use negative indices to count from the right and negative STEP
    # to download in reverse order. E.g. "-I 1:3,7,-5::2" used on a playlist of size 15
    # will download the items at index 1,2,3,7,11,13,15

    # -i, --ignore-errors
    # Ignore download and postprocessing errors. The download will be considered
    # successful even if the postprocessing fails
    # --embed-subs
    # Embed subtitles in the video (only for mp4, webm and mkv videos)
    # -o, --output [TYPES:]TEMPLATE
    # Output filename template; see "OUTPUT TEMPLATE" for details
    if [[ "$1" == "https://www.youtube.com/playlist?list="* ]]; then
        yt-dlp ${YT_COMMON_ARGUMENTS[@]} --playlist-start 1 --ignore-errors --embed-subs --output "%(playlist_id)s/%(playlist_index)s. %(title).200B [%(id)s].%(ext)s" "$1"

    # text file with list of video links
    ############################################################################
    # -a, --batch-file FILE
    # File containing URLs to download ("-" for stdin), one URL per line. Lines starting
    # with "#", ";" or "]" are considered as comments and ignored
    elif [[ "$1" == *".txt" ]]; then
        yt-dlp ${YT_COMMON_ARGUMENTS[@]} --embed-subs --batch-file "$1"

    # individual YouTube or other platform video
    ############################################################################
    else
        yt-dlp ${YT_COMMON_ARGUMENTS[@]} --embed-subs "$1"
    fi
}

yt-auto-subs() {
    # retrieve automatically generated subtitles and save them to a file
    # --write-subs
    # Write subtitle file
    # --write-auto-subs
    # Write automatically generated subtitle file (Alias: --write-automatic-subs)
    yt-dlp ${YT_COMMON_ARGUMENTS[@]} --write-subs --write-auto-subs "$1"
}
################################################################################


### custom functions
################################################################################


### load GitHub SSH key
github-ssh() {
    #pkill ssh-agent
    #eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa_github
}


### load GitLab SSH key
gitlab-ssh() {
    #pkill ssh-agent
    #eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_rsa_gitlab
}


### calculations with Python
calc() {
    python -c 'from math import *; import sys; print(eval(" ".join(sys.argv[1:])))' "$@"
}


# open one or multiple files with the registered application
# open a file browser on the current directory if run without arguments
### xdg-open
# opens a file or URL in the user's preferred application
d-open() {
    if [[ -z "$1" ]]; then
        xdg-open .
    else
        for arg in "$@"; do
            xdg-open "$arg"
        done
    fi
}


### md5 hash function
m5() {
    if [[ -z "$1" ]]; then
        md5sum *
    else
        for arg in "$@"; do
            md5sum "$arg"
        done
    fi
}


### hashdeep
# Compute, compare, or audit multiple message digests
# -jnn
# Controls multi-threading. By default the program will create one producer thread to scan the file system and one hashing thread per CPU core. Multi-threading causes output filenames to be in non-deterministic order, as files that take longer to hash will be delayed while they are hashed. If a deterministic order is required, specify -j0 to disable multi-threading.
# -r
# Enables recursive mode. All subdirectories are traversed. [...]
# -e
# Displays a progress indicator and estimate of time remaining for each file being processed. [...]
# -l
# Enables relative file paths. Instead of printing the absolute path for each file, displays the relative file path as indicated on the command line. This flag may not be used  in  conjunction with the -b flag.
d-hash_generate() {
    # generate and save file hashes
    if [[ -z "$1" ]]; then
        # see "extglob" above for "!(pattern)" description
        hashdeep -j0 -r -e -l !(file_hashes.txt) > file_hashes.txt
    else
        hashdeep -j0 -r -e -l "$@" > file_hashes.txt
    fi
}
# -a
# Audit mode. Each input file is compared against the set of knowns. An audit is said to pass if each input file is matched against exactly one file in set of knowns. Any collisions, new files, or missing files will make the audit fail. Using this flag alone produces a message, either "Audit passed" or "Audit Failed". Use the verbose modes, -v, for more details. Using -v prints the number of files in each category. Using -v a second time prints any discrepancies. Using -v a third time prints the results for every file examined and every known file. Due to limitations in the program, any filenames with Unicode characters will appear to have moved during an audit. See the section "UNICODE SUPPORT" below.
# -v
# Enables verbose mode. Use again to make the program more verbose. This mostly changes the behavior of the audit mode, -a.
# -k
# Load a file of known hashes. [...]
d-hash_verify() {
    # verify file hashes
    if [[ -z "$1" ]]; then
        hashdeep -j4 -a -vvv -r -e -l -k file_hashes.txt !(file_hashes.txt)
    else
        hashdeep -j4 -a -vvv -r -e -l -k file_hashes.txt "$@"
    fi
}


### zip
# package and compress (archive) files
# -r, --recurse-paths
# Travel the directory structure recursively
# -y, --symlinks
# store symbolic links as such in the zip archive, instead of compressing and
# storing the file referred to by the link.
### compress to zip
d-compress-zip() {
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


### compress to tgz
d-compress-tgz() {
    if [[ -z "$1" ]]; then
        echo "compress to a tgz archive with the same filename"
        echo "usage: d-compress-tgz <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        # remove trailing slash
        arg=${arg%/}

        tar --create --gzip --file "$arg".tgz "$arg"
    done
}


### compress to 7z
d-compress-7z() {
    if [[ -z "$1" ]]; then
        echo "compress to a 7z archive with the same filename"
        echo "usage: d-compress-7z <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        # remove trailing slash
        arg=${arg%/}

        # run on a single core
        7z a -t7z -mmt=1 -m0=lzma "$arg".7z "$arg"

        #7z a "$arg".7z "$arg"
    done
}


### extract an archive
d-extract() {
    if [[ -z "$1" ]]; then
        echo "extract any of several types of archive files (zip, 7z, tgz, tar.gz, tar, gz, bz2, xz, zst, rar)"
        echo "usage: d-extract <FILE> [<FILE> ...]"
        return 0
    fi

    for arg in "$@"; do
        echo "$arg"

        case "$arg" in
            *.zip)
                unzip "$arg"
            ;;
            *.7z)
                FILENAME=$(basename "$arg")
                FILENAME_STEM="${FILENAME%.*}"

                # count objects in the root directory
                num_objects=$(7z l "$arg" -slt "$arg" | grep -c 'Path = [^/]*$')

                # if num_objects > 2 add -o switch (the archive itself is included in the count)
                if [[ $num_objects -gt 2 ]]; then
                    options="-o${FILENAME_STEM}"
                fi

                7z x "${options}" "$arg"
            ;;
            *.tgz|*.tar.gz|*.tar)
                tar --extract --verbose --file "$arg"
            ;;
            *.gz)
                gzip --decompress --keep --verbose "$arg"
            ;;
            *.bz2)
                tar --extract --bzip2 --verbose --file "$arg"
            ;;
            *.xz)
                xz --decompress --keep --verbose "$arg"
            ;;
            *.zst)
                zstd --decompress --keep --verbose "$arg"
            ;;
            *.rar)
                unrar x "$arg"
            ;;
        esac
    done
}


### create a backup copy of a directory or file
d-backup() {
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


### format / beautify JSON files
d-json_format() {
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


### compile a C program
d-c-compile() {
    arg="$1"
    if [[ -z "$arg" ]]; then
        echo "d-c-compile requires a C source file as an argument"
    else
        gcc -Wall -g "$arg" -o "${arg%.c}"
    fi
}


### find
# search for files in a directory hierarchy
# -name <pattern>
# Base of file name (the path with the leading directories removed) matches shell pattern
# <pattern>. [...]
# -iname pattern
# Like -name, but the match is case insensitive. [...]
f() {
    clear -x
    if [[ -z "$1" ]]; then
        echo "nothing to search for"
    else
        find . -iname "*$1*"
    fi
}


### delete / remove unnecessary files
d-cleanup() {
    UNNECESSARY_FILES=(
        "*.aux"
        "*.fdb_latexmk"
        "*.fls"
        "*.pyc"
        ".DS_Store"
        "Thumbs.db"
        "__MACOSX"
        "__pycache__"
        ".pytest_cache"
    )
    for FILE_PATTERN in "${UNNECESSARY_FILES[@]}"; do
        find . -type d \( -path "./.venv/*" \) -prune -o -type f -name "$FILE_PATTERN" -print -exec rm -r "{}" \;
    done
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
wcc() {
    if [[ -z "$1" ]]; then
        echo "print the number of lines, words, and characters of a text file"
        echo "usage: wcc <FILE> [<FILE> ...]"
    else
        for arg in "$@"; do
            wc --lines --words --chars "$arg"
        done
    fi
}


### d-d775_f664
# recursively set directory permissions to 775 and file permissions to 664
d-d775_f664() {
    if [[ -z "$1" ]]; then
        echo "recursively set directory permissions to 775 and file permissions to 664"
        echo "usage: d-d775_f664 <PATH> [<PATH> ...]"
    else
        for arg in "$@"; do
            if [[ -d "$arg" ]]; then
                find "$arg" -type d -exec chmod 775 {} \;
                find "$arg" -type f -exec chmod 664 {} \;
            elif [[ -f "$arg" ]]; then
                chmod 664 "$arg"
            fi
        done
    fi
}
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

### pipx
# enable autocomplete
# (requires argcomplete)
#eval "$(register-python-argcomplete pipx)"
# run install and upgrade with the --verbose flag
pipx() {
    if [[ $# -gt 0 ]] && [[ "$1" == "install" ]] ; then
        shift
        command pipx install --verbose "$@"
    elif [[ $# -gt 0 ]] && [[ "$1" == "upgrade" ]] ; then
        shift
        command pipx upgrade --verbose "$@"
    else
        command pipx "$@"
    fi
}

### environment variables
# use pudb for debugging globally
export PYTHONBREAKPOINT="pudb.set_trace"
## set pycache directory path
export PYTHONPYCACHEPREFIX="$HOME/.cache/pycache"


## Deno
if [[ -d "$HOME/.deno" ]]; then
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
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


## start authentication agent and load SSH keys
eval $(ssh-agent -s) &> /dev/null
# kill the agent on session exit
trap "ssh-agent -k" exit
[[ -f "$HOME/.ssh/id_rsa_github" ]] && ssh-add "$HOME/.ssh/id_rsa_github" &> /dev/null
[[ -f "$HOME/.ssh/id_rsa_gitlab" ]] && ssh-add "$HOME/.ssh/id_rsa_gitlab" &> /dev/null


## add GPG key
export GPG_TTY=$(tty)
################################################################################


### local settings
if [[ -f $HOME/.bashrc_local ]]; then
    source $HOME/.bashrc_local
fi


### temp settings
if [[ -f $HOME/.bashrc_temp ]]; then
    source $HOME/.bashrc_temp
fi


### z
# jump around
# https://github.com/rupa/z
Z_ROOT_DIRECTORY="$SOFTWARE_DIRECTORY/z"
if [[ -f "$Z_ROOT_DIRECTORY/z.sh" ]]; then
    source "$Z_ROOT_DIRECTORY/z.sh"

    _Z_NO_RESOLVE_SYMLINKS=1
fi


# tmux Bash completion
# https://github.com/imomaliev/tmux-bash-completion
TMUX_BASH_COMPLETION_DIRECTORY="$SOFTWARE_DIRECTORY/tmux-bash-completion"
if [[ -d "$TMUX_BASH_COMPLETION_DIRECTORY" ]]; then
    source "$TMUX_BASH_COMPLETION_DIRECTORY/completions/tmux"
fi


### Java jenv
# https://www.jenv.be/
# https://github.com/jenv/jenv
if [[ -d "$JENV_ROOT" ]]; then
    export PATH="$JENV_ROOT/bin:$PATH"
    eval "$(jenv init -)"
fi


# ### plenv
# if [[ -d "$PLENV_ROOT" ]]; then
#     export PLENV_ROOT
#     export PATH="$PLENV_ROOT/bin:$PATH"
#     eval "$(plenv init -)"
# fi


## Node.js
# https://github.com/nvm-sh/nvm
if [[ -d "$NVM_DIR" ]]; then
    # load nvm
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    # load nvm bash_completion
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi


## Go
# export if environment variables are set
if [[ -n "$GOROOT" && -n "$GOPATH" ]]; then
    PATH="$GOPATH/bin:$PATH"
    PATH="$GOROOT/bin:$PATH"
    export PATH
fi


### pyenv
if [[ -d "$PYENV_ROOT" ]]; then
    export PYENV_ROOT
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


### rye
# https://github.com/mitsuhiko/rye
# https://rye-up.com/
# package management solution for Python
source "$HOME/.rye/env"


### direnv
# https://github.com/direnv/direnv
# hook direnv to bash
# NOTE: this should appear after any shell extension that manipulates the prompt
if [[ -x "$(command -v direnv)" ]]; then
    eval "$(direnv hook bash)"
fi
