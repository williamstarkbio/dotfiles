# docs
# https://www.ebi.ac.uk/seqdb/confluence/display/ENSGBD/Genebuild+virtual+user%2C+shared+environment+and+shared+data

export GB_HOME=/nfs/production/panda/ensembl/genebuild

# ws
# use my version of basic.sh
# if [ -z "$ENSEMBL_SOFTWARE_HOME" ] && [ -e "/nfs/software/ensembl/latest/envs/basic.sh" ]; then
#   . /nfs/software/ensembl/latest/envs/basic.sh
# fi
[[ -f "$HOME/dotfiles/ebi/basic.sh" ]] && source "$HOME/dotfiles/ebi/basic.sh"

export GB_SCRATCH=/hps/nobackup2/production/ensembl/genebuild
export REPEATMASKER_CACHE=$GB_SCRATCH
export BLASTDB_DIR=$GB_SCRATCH/blastdb
export REPEATMODELER_DIR=$GB_SCRATCH/custom_repeat_libraries/repeatmodeler
export LSB_DEFAULTQUEUE="production-rh74"

if [ -n "$LINUXBREW_HOME" ];then
  if [ -z "$WISECONFIGDIR" ]; then
    export PATH="$PATH":"$($LINUXBREW_HOME/bin/brew --prefix ensembl/external/exonerate09)/bin":"$($LINUXBREW_HOME/bin/brew --prefix ensembl/external/bwa-051mt)/bin"
  fi
  export BIOPERL_LIB="$($LINUXBREW_HOME/bin/brew --prefix ensembl/ensembl/bioperl-169)/libexec"
  export WISECONFIGDIR="$($LINUXBREW_HOME/bin/brew --prefix ensembl/external/genewise)/share/genewise"
  export GBLAST_PATH="$($LINUXBREW_HOME/bin/brew --prefix)/bin"
fi

if [ -d "/nfs/production/panda/ensembl/production/ensemblftp/data_files" ];then
  export FTP_DIR="/nfs/production/panda/ensembl/production/ensemblftp/data_files"
fi

export HIVE_EMAIL="$USER@ebi.ac.uk"
# ws
#export ENSCODE="$HOME/enscode"
export GENEBUILDER_ID=50

# Tokens for different services
# webhooks for Slack to send notification to any channel
#export SLACK_GENEBUILD='T0F48FDPE/B9B6N48LR/0zjnSpXiK4OlLKB39NutLGCP'
#export GSHEETS_CREDENTIALS="/nfs/panda/ensembl/genebuild/production/assembly_registry/credentials.json"

shopt -s direxpand

#alias dbhc="~genebuild/enscode/ensembl-common/scripts/dbhc.sh"
#alias dbcopy="~genebuild/enscode/ensembl-common/scripts/dbcopy.sh"
#alias run_testsuite="~genebuild/enscode/ensembl-common/scripts/run_testsuite.sh"

#alias mkgbdir="mkdir -m 2775"

reload_ensembl_release() {
  EVERSION=`mysql-ens-meta-prod-1 ensembl_metadata -NB -e "SELECT ensembL_version FROM data_release WHERE is_current = 1"`
  if [ $EVERSION -gt ${ENSEMBL_RELEASE:-0} ]; then
    export ENSEMBL_RELEASE=$EVERSION
  elif [ $EVERSION -lt $ENSEMBL_RELEASE ];then
    echo "Something is wrong: ENSEMBL_RELEASE=$ENSEMBL_RELEASE and ensembl_production_$EVERSION"
    return 1
  fi
}

reload_ensembl_release
