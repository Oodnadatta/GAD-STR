#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: a wrapper for qsubing bam transfer for STR pipeline
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,TRANSFER_OUTPUTDIR=<output directory>,[LOGFILE=<path to the log file>] wrapper_transfer.sh


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=transfer.$(date +"%F_%H-%M-%S").log
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

# Check if output directory is specified
if [ -z "$TRANSFER_OUTPUTDIR" ]
then
    echo "Output directory is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Transfer and check exit code
echo "command : rsync -aX \
    $INPUTFILE $(echo "$INPUTFILE" | sed 's/\.bam$/.bai/') \
    $TRANSFER_OUTPUTDIR"
rsync -aX \
    "$INPUTFILE" "$(echo "$INPUTFILE" | sed 's/\.bam$/.bai/')" \
    "$TRANSFER_OUTPUTDIR"

transfer_exitcode=$? 

echo "transfer exit code : $transfer_exitcode"
if [ $transfer_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
