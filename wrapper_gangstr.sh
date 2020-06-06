#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: a wrapper for qsubing GangSTR script for STR detection
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_gangstr.sh

# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=gangstr.$(date +"%F_%H-%M-%S").log
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
echo "command : /work/gad/shared/bin/gangstr/GangSTR-2.4/bin/GangSTR \
    --bam "$INPUTFILE" \
    --ref /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --regions /work/gad/shared/bin/gangstr/STRregions/hg19_ver13_1.bed \
    --out "$OUTPUTPREFIX" \
    --verbose

#    --insertmean "$INSERTMEAN" \
#    --insertsdev "$INSERTDEV""

/work/gad/shared/bin/gangstr/GangSTR-2.4/bin/GangSTR \
    --bam "$INPUTFILE" \
    --ref /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --regions /work/gad/shared/bin/gangstr/STRregions/hg19_ver13_1.bed \
    --out "$OUTPUTPREFIX" \
    --verbose

#    --insertmean "$INSERTMEAN" \
#    --insertsdev "$INSERTDEV"


gangstr_exitcode=$?

echo "gangstr exit code : $gangstr_exitcode"
if [ $gangstr_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
