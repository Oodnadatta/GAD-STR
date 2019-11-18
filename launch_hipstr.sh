#! /bin/sh

### ASDP PIPELINE ###
## launch_wrapper_hipstr.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the wrapper for qsubing HipSTR script for STR detection
## Usage : FIXME
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191104
## last revision date : 20191104
## Known bugs : None

INPUTFILE=/archive/gad/shared/bam_new_genome_temp/dijen017.bam
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/HipSTR/$DATE"
OUTPUTPREFIX="$OUTPUTDIR/$(basename -s .bam "$INPUTFILE")_$DATE"
OUTPUTFILE="$OUTPUTPREFIX.vcf.gz"
LOGFILE="$OUTPUTDIR/$DATE.log"

# Launch the script on local host with --local option and on SGE with qsub without the --local option
if [ $# -eq 1 ] && [ "x$1" = x--local ]
then
    mkdir -p "$OUTPUTDIR"
    INPUTFILE="$INPUTFILE" OUTPUTFILE="$OUTPUTFILE" LOGFILE="$LOGFILE" "$(dirname "$0")/wrapper_hipstr.sh"
else 
    mkdir -p "$OUTPUTDIR"
    qsub -pe smp 1 -q transfer -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTPREFIX",LOGFILE="$LOGFILE" wrapper_hipstr.sh
fi