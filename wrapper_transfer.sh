#! /bin/sh

### ASDP PIPELINE ###
## wrapper_transfer.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing bam transfer for STR pipeline
## Usage : qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTDIR=<output directory>,[LOGFILE=<path to the log file>] wrapper_transfer.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191208
## last revision date : 20191208
## Known bugs : None


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
    touch transfer.failed
    exit 1
fi

# Check if output directory is specified
if [ -z "$OUTPUTDIR" ]
then
    echo "Output directory is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch transfer.failed
    exit 1
fi

# Transfer and check exit code
echo "command : rsync -aAX \
    $INPUTFILE $(echo "$INPUTFILE" | sed 's/\.bam$/.bai/') \
    $OUTPUTDIR"
rsync -aAX \
    "$INPUTFILE" "$(echo "$INPUTFILE" | sed 's/\.bam$/.bai/')" \
    "$OUTPUTDIR"

transfer_exitcode=$? 

echo "transfer exit code : $transfer_exitcode"
if [ $transfer_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch transfer.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
