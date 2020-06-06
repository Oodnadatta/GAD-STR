#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: a wrapper for qsubing Tredparse script for STR detection
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTDIR=<output directory>,[LOGFILE=<path to the log file>] wrapper_tredparse.sh


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=tredparse.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch tredparse.failed
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTDIR" ]
then
    echo "Output directory is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch tredparse.failed
    exit 1
fi

# Enable the virtualenv
TREDPARSE="/work/gad/shared/bin/tredparse/Tredparse-20190901"
. "$TREDPARSE/bin/activate"

# Launch script command and check exit code
echo "command : "$TREDPARSE/bin/tred.py" "$INPUTFILE" --workdir "$OUTPUTDIR" --ref hg19"
"$TREDPARSE/bin/tred.py" "$INPUTFILE" --workdir "$OUTPUTDIR" --ref hg19

tredparse_exitcode=$?

echo "tredparse exit code : $tredparse_exitcode"
if [ $tredparse_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch tredparse.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
