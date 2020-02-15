#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: FIXME
## Description: script to launch the wrapper for qsubing outlier analysis by ExpansionHunter denovo script for STR detection
## Usage: FIXME
## Output: FIXME
## Requirements: FIXME

## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date: 20200215
## Last revision date: 20200215
## Known bugs: None

CASE=dijen001
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/ExpansionHunterDeNovoOutlier/$DATE"
LOGFILE="$OUTPUTDIR/$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    CASE="$CASE" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_ehdn_outlier.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 1 -q batch -v CASE="$CASE",LOGFILE="$LOGFILE" wrapper_ehdn_outlier.sh
fi
