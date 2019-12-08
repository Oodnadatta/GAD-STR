#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_stretch.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing STRetch script for STR detection
## Usage : FIXME
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191118
## last revision date : 20191127
## Known bugs : None

# INPUTFILE=/work/gad/shared/analyse/STR/Data/dijen017/dijen017/dijen017.bam

INPUTFILE=/work/gad/shared/analyse/STR/Data/dijen017/shortdijen017/dijen017.short.bam
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/STRetch/$DATE"
LOGFILE="$OUTPUTDIR/$(basename "$INPUTFILE")_$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTPREFIX="$OUTPUTDIR" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_stretch.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 16 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR",LOGFILE="$LOGFILE" wrapper_stretch.sh
fi
