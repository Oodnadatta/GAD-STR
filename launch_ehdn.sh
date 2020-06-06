#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_ehdn.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing ExpansionHunter denovo script for STR detection
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191102
## last revision date : 20191126
## Known bugs : None

INPUTFILE=/work/gad/shared/analyse/STR/pipeline/dijen073/dijen073.bam
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/ExpansionHunterDeNovo/$DATE"
OUTPUTPREFIX="$OUTPUTDIR/$(basename "$INPUTFILE")_$DATE"
LOGFILE="$OUTPUTDIR/$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTPREFIX="$OUTPUTPREFIX" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_ehdn.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 4 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTPREFIX",LOGFILE="$LOGFILE" wrapper_ehdn.sh
fi
