export ENSEMBL_SOFTWARE_HOME=/nfs/software/ensembl/RHEL7-JUL2017-core2

# ws
# setting included in genebuild.sh
# if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/bash-fixes.sh ]; then
#   . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/bash-fixes.sh
# fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/linuxbrew.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/linuxbrew.sh
fi
# ws
# disable
# if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/plenv.sh ]; then
#   . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/plenv.sh
# fi
# ws
# disable
# if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/pyenv.sh ]; then
#   . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/pyenv.sh
# fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/rbenv.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/rbenv.sh
fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/jenv.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/jenv.sh
fi
# ws
# disable
#if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/nodenv.sh ]; then
#  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/nodenv.sh
#fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/goenv.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/goenv.sh
fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/oracle.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/oracle.sh
fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/mysql-cmds.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/mysql-cmds.sh
fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/maker.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/maker.sh
fi
if [ -f /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/boost.sh ]; then
  . /nfs/software/ensembl/RHEL7-JUL2017-core2/envs/boost.sh
fi
