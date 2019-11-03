#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_tredparse.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing Tredparse script for STR detection
## Usage : FIXME
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191103
## last revision date : 20191103
## Known bugs : None

INPUTFILE=/archive/gad/shared/bam_new_genome_temp/dijen017.bam
OUTPUTDIR=/user1/gad/an1770de/Tools/Tredparse/"$(date +"%F_%H-%M-%S")"
LOGFILE="$OUTPUTDIR/log.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTDIR="$OUTPUTDIR" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_tredparse.sh"
else 
    qsub -pe smp 1 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTDIR="$OUTPUTDIR",LOGFILE="$LOGFILE" wrapper_tredparse.sh
fi
