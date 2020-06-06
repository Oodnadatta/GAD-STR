#! /bin/sh

### ASDP PIPELINE ###
## wrapper_lobstr.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing LobSTR script for STR detection
## Usage : qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_lobstr.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191104
## last revision date : 20191104
## Known bugs : None


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=lobstr.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTPREFIX" ]
then
    echo "Output prefix is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Launch script command and check exit code
echo "command : FIXME"
#FIXME
echo "command : FIXME /work/gad/shared/bin/lobstr/lobSTR-4.0.6/bin/lobSTR \
    --bampair -f /archive/gad/shared/bam_new_genome_temp/dijen017.bam \
    --rg-lib /archive/gad/shared/bam_new_genome_temp/dijen017.bam \
    --rg-sample /archive/gad/shared/bam_new_genome_temp/dijen017.bam \
    --index-prefix /work/gad/shared/bin/lobstr/ref/hg19_v3.0.2/lobstr_v3.0.2_hg19_ref/lobSTR_ \
    -o ~/test \
    -v"

/work/gad/shared/bin/lobstr/lobSTR-4.0.6/bin/lobSTR \
    --bampair -f "$INPUTFILE" \
    --rg-lib "$INPUTFILE" \
    --rg-sample "$INPUTFILE" \
    --index-prefix /work/gad/shared/bin/lobstr/ref/hg19_v3.0.2/lobstr_v3.0.2_hg19_ref/lobSTR_ \
    -o "$OUTPUTPREFIX" \
    -v 


lobstr_exitcode=$?

echo "lobstr exit code : $lobstr_exitcode"
if [ $lobstr_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
