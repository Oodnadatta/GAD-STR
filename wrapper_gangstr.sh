#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: a wrapper for qsubing GangSTR script for STR detection
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_gangstr.sh

# Source the configuration file
. "$(dirname "$0")/config.sh"

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
echo "command : $GANGSTR \
    --bam $INPUTFILE \
    --ref $REF \
    --regions $GANGSTR_REGIONS \
    --out $OUTPUTPREFIX \
    --verbose"

#    --insertmean "$INSERTMEAN" \
#    --insertsdev "$INSERTDEV""

"$GANGSTR" \
    --bam "$INPUTFILE" \
    --ref "$REF" \
    --regions "$GANGSTR_REGIONS" \
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
