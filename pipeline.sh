#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLV3
## Author: Anne-Sophie Denommé-Pichon
## Description: script to launch the pipeline for STR detection. This script handles a single sample.


# $1 : first argument in the command line : the input file
SAMPLE="$1"

# Check if sample is specified
if [ -z "$SAMPLE" ]
then
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Source the configuration file
. "$(dirname "$0")/config.sh"

# Commented to fit the GAD pipeline
#if [ "x$INPUTDIR" = "x$OUTPUTDIR" ]
#then
#    echo "Input directory is the same as output directory. Please change it to prevent the pipeline from deleting or overwriting raw data."
#    exit 1
#fi

INPUTFILE="$INPUTDIR/$SAMPLE.bam"
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="$OUTPUTDIR/$SAMPLE"
TRANSFER_JOB=""
WD="$(dirname "$(readlink -f "$0")")"

LOGDIR="$OUTPUTDIR/logs"
STRDIR="$OUTPUTDIR/str"

mkdir -p "$LOGDIR" "$STRDIR"

# Transfer bam and bai from archive to work
if [ "x$TRANSFER" = "xyes" ]
then
    TRANSFER_JOB="transfer_$SAMPLE"
    qsub -wd "$WD" -pe smp 1 -o "$LOGDIR" -e "$LOGDIR" -q "$TRANSFER_QUEUE" -N "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",TRANSFER_OUTPUTDIR="$STRDIR",LOGFILE="$LOGDIR/transfer_$SAMPLE.$DATE.log" "$WD/wrapper_transfer.sh"
    INPUTFILE="$STRDIR/$SAMPLE.bam"
fi

# Launch ExpansionHunter
mkdir -p "$STRDIR/eh"
qsub -wd "$WD" -pe smp 4 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE"  -N "eh_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$STRDIR/eh/$SAMPLE",LOGFILE="$LOGDIR/eh_$SAMPLE.$DATE.log" "$WD/wrapper_expansionhunter.sh"

# Launch Tredparse
mkdir -p "$STRDIR/tredparse"
qsub -wd "$WD" -pe smp 4 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "tredparse_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",TREDPARSE_OUTPUTDIR="$STRDIR/tredparse",LOGFILE="$LOGDIR/tredparse_$SAMPLE.$DATE.log" "$WD/wrapper_tredparse.sh"

# Launch GangSTR
mkdir -p "$STRDIR/gangstr"
qsub -wd "$WD" -pe smp 4 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "gangstr_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$STRDIR/gangstr/$SAMPLE",LOGFILE="$LOGDIR/gangstr_$SAMPLE.$DATE.log" "$WD/wrapper_gangstr.sh"

# Launch ehdn profile
mkdir -p "$STRDIR/ehdn"
qsub -wd "$WD" -pe smp 4 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "ehdn_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$STRDIR/ehdn/$SAMPLE",LOGFILE="$LOGDIR/ehdn_profile_$SAMPLE.$DATE.log" "$WD/wrapper_ehdn_profile.sh"

# Delete transfered bam and bai
#if [ "x$TRANSFER" = "xyes" ]
#then
#    qsub -wd "$WD" -pe smp 1 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "delete_$SAMPLE" -hold_jid "eh_$SAMPLE,tredparse_$SAMPLE,gangstr_$SAMPLE,ehdn_$SAMPLE" -sync y -v SAMPLE="$SAMPLE",LOGFILE="$LOGDIR/delete_$SAMPLE.$DATE.log" "$WD/wrapper_delete.sh"
#else
    qsub -wd "$WD" -pe smp 1 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "delete_$SAMPLE" -hold_jid "eh_$SAMPLE,tredparse_$SAMPLE,gangstr_$SAMPLE,ehdn_$SAMPLE" -sync y -b y echo "Nothing to delete."
#fi
