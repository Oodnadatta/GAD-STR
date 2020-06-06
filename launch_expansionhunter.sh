#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the wrapper for qsubing ExpansionHunter script for STR detection


INPUTFILE=/work/gad/shared/analyse/STR/Data/dijen561.bam
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/ExpansionHunter/$DATE"
OUTPUTPREFIX="$OUTPUTDIR/$(basename "$INPUTFILE")_$DATE"
LOGFILE="$OUTPUTDIR/$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTPREFIX="$OUTPUTPREFIX" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_expansionhunter.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 4 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTPREFIX",LOGFILE="$LOGFILE" wrapper_expansionhunter.sh
fi
