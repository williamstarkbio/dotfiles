### .profile
# vim: set filetype=sh :

# William Stark (william.stark.5000@gmail.com)


# ~/.profile: executed by the command interpreter for login shells.

# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.

# The default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


### add ~/bin/ to the PATH environment variable
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"

### add ~/.local/bin/ to the PATH environment variable
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"


### NVIDIA CUDA
#CUDA_ROOT="/usr/local/cuda"
#[[ -s "$CUDA_ROOT/bin" ]] && export PATH="$CUDA_ROOT/bin:$PATH"
#[[ -s "$CUDA_ROOT/lib64" ]] && export LD_LIBRARY_PATH="$CUDA_ROOT/lib64:$LD_LIBRARY_PATH"
#[[ -s "$CUDA_ROOT" ]] && export CUDA_HOME="$CUDA_ROOT"
