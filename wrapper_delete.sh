#! /bin/sh

### ASDP PIPELINE ###
## wrapper_delete.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing bam deletion for STR pipeline
## Usage : qsub -pe smp 1 -v SAMPLE=<sample>,[LOGFILE=<path to the log file>] wrapper_delete.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191208
## last revision date : 20191208
## Known bugs : None


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=delete.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"

# Check if sample is specified
if [ -z "$SAMPLE" ]
then
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch delete.failed
    exit 1
fi

# Delete and check exit code
echo "command : rm \
    $SAMPLE"
rm \
    "/work/gad/shared/analyse/STR/pipeline/$SAMPLE/$SAMPLE.bam" \
    "/work/gad/shared/analyse/STR/pipeline/$SAMPLE/$SAMPLE.bai"

delete_exitcode=$?

echo "delete exit code : $delete_exitcode"
if [ $delete_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch delete.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
