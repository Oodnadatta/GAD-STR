#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the wrapper for qsubing ExpansionHunter denovo script for STR detection


INPUTFILE="/archive/gad/shared/bam_new_genome_temp/dijen016.bam"
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/Data"
LOGFILE="$OUTPUTDIR/$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTDIR="$OUTPUTDIR" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_transfer.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 1 -q transfer -v INPUTFILE="$INPUTFILE",OUTPUTDIR="$OUTPUTDIR",LOGFILE="$LOGFILE" wrapper_transfer.sh
fi
