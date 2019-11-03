#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_expansionhunter.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing ExpansionHunter script for STR detection
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191102
## last revision date : 20191102
## Known bugs : None

INPUTFILE=/archive/gad/shared/bam_new_genome_temp/dijen017.bam
OUTPUTPREFIX=/user1/gad/an1770de/Tools/ExpansionHunter/20191102/"$(date +"%F_%H-%M-%S")"
LOGFILE=/user1/gad/an1770de/Tools/ExpansionHunter/20191102/log.log

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    INPUTFILE="$INPUTFILE" OUTPUTPREFIX="$OUTPUTPREFIX" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_expansionhunter.sh"
else 
    qsub -pe smp 1 -q batch -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTPREFIX",LOGFILE="$LOGFILE" wrapper_expansionhunter.sh
fi
