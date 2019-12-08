#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_gangstr.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing GangSTR script for STR detection
## Usage : FIXME
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191104
## last revision date : 20191126
## Known bugs : None

INPUTFILE=/work/gad/shared/analyse/STR/Data/dijen017/offtargetdijen017/dijen017.offtarget.bam
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/GangSTR/$DATE"
OUTPUTPREFIX="$OUTPUTDIR/$(basename "$INPUTFILE")_$DATE"
LOGFILE="$OUTPUTDIR/$(basename "$INPUTFILE")_$DATE.log"
INSERTMEAN="359.4"
INSERTDEV="80.1204"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTPREFIX="$OUTPUTPREFIX" LOGFILE="$LOGFILE" INSERTMEAN="$INSERTMEAN" INSERTDEV="$INSERTDEV" "$(dirname "$0")/wrapper_gangstr.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 4 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTPREFIX",LOGFILE="$LOGFILE",INSERTMEAN="$INSERTMEAN",INSERTDEV="$INSERTDEV" wrapper_gangstr.sh
fi
