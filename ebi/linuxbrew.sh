export HOMEBREW_ENSEMBL_MOONSHINE_ARCHIVE=/nfs/software/ensembl/ENSEMBL_MOONSHINE_ARCHIVE
export ENSEMBL_MOONSHINE_ARCHIVE=/nfs/software/ensembl/ENSEMBL_MOONSHINE_ARCHIVE

export LINUXBREW_HOME=/nfs/software/ensembl/RHEL7-JUL2017-core2/linuxbrew
# ws
# reduce priority of linuxbrew executables
#export PATH="$LINUXBREW_HOME/bin:$LINUXBREW_HOME/sbin:$PATH"
export PATH="$PATH:$LINUXBREW_HOME/bin:$LINUXBREW_HOME/sbin"
export MANPATH="$LINUXBREW_HOME/share/man:$MANPATH"
export INFOPATH="$LINUXBREW_HOME/share/info:$INFOPATH"
export HOMEBREW_FORCE_BREWED_CURL=1
