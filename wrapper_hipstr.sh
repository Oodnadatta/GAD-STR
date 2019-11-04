#! /bin/sh

### ASDP PIPELINE ###
## wrapper_hipstr.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing HipSTR script for STR detection
## Usage : qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_hipstr.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191104
## last revision date : 20191104
## Known bugs : None


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=hipstr.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch hipstr.failed
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTFILE" ]
then
    echo "Output file is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch hipstr.failed
    exit 1
fi

# Launch script command and check exit code
echo "command : FIXME"

/work/gad/shared/bin/hipstr/HipSTR-2019-11-04/HipSTR \
    --bams "$INPUTFILE" \
    --fasta /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --regions /work/gad/shared/bin/hipstr/STRregions/hg19.hipstr_reference.bed \
    --str-vcf "$OUTPUTFILE"

hipstr_exitcode=$?

echo "hipstr exit code : $hipstr_exitcode"
if [ $hipstr_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch hipstr.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
