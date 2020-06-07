#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLV3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the pipeline for STR detection


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

if [ "x$INPUTDIR" = "x$OUTPUTDIR" ]
then
    echo "Input directory is the same as output directory. Please change it to prevent the pipeline from deleting or overwriting raw data."
    exit 1
fi

INPUTFILE="$INPUTDIR/$SAMPLE.bam"
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="$OUTPUTDIR/$SAMPLE"
TRANSFER_JOB=""
WD="$(dirname "$(readlink -f "$0")")"

Transfer bam and bai from archive to work
if [ "x$TRANSFER" = "xyes" ]
then
    mkdir -p "$OUTPUTDIR"
    TRANSFER_JOB="transfer_$SAMPLE"
    qsub -wd "$WD" -pe smp 1 -q "$TRANSFER_QUEUE" -N "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",TRANSFER_OUTPUTDIR="$OUTPUTDIR",LOGFILE="$OUTPUTDIR/transfer_$DATE.log" wrapper_transfer.sh
    INPUTFILE="$OUTPUTDIR/$SAMPLE.bam"
fi

# Launch ExpansionHunter
mkdir -p "$OUTPUTDIR/eh"
qsub -wd "$WD" -pe smp 4 -q "$COMPUTE_QUEUE"  -N "eh_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/eh/$SAMPLE",LOGFILE="$OUTPUTDIR/eh/$DATE.log" wrapper_expansionhunter.sh

# Launch Tredparse
mkdir -p "$OUTPUTDIR/tredparse"
qsub -wd "$WD" -pe smp 4 -q "$COMPUTE_QUEUE" -N "tredparse_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",TREDPARSE_OUTPUTDIR="$OUTPUTDIR/tredparse",LOGFILE="$OUTPUTDIR/tredparse/$DATE.log" wrapper_tredparse.sh

# Launch GangSTR
mkdir -p "$OUTPUTDIR/gangstr"
qsub -wd "$WD" -pe smp 4 -q "$COMPUTE_QUEUE" -N "gangstr_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/gangstr/$SAMPLE",LOGFILE="$OUTPUTDIR/gangstr/$DATE.log" wrapper_gangstr.sh

# Launch ehdn profile
mkdir -p "$OUTPUTDIR/ehdn"
qsub -wd "$WD" -pe smp 4 -q "$COMPUTE_QUEUE" -N "ehdn_$SAMPLE" -hold_jid "$TRANSFER_JOB" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/ehdn/$SAMPLE",LOGFILE="$OUTPUTDIR/ehdn/$DATE.log" wrapper_ehdn_profile.sh

# Delete transfered bam and bai
if [ "x$TRANSFER" = "xyes" ]
then
    qsub -wd "$WD" -pe smp 1 -q "$COMPUTE_QUEUE" -N "delete_$SAMPLE" -hold_jid "eh_$SAMPLE,tredparse_$SAMPLE,gangstr_$SAMPLE,ehdn_$SAMPLE" -sync y -v SAMPLE="$SAMPLE",LOGFILE="$OUTPUTDIR/delete_$DATE.log" wrapper_delete.sh
else
    qsub -wd "$WD" -pe smp 1 -q "$COMPUTE_QUEUE" -N "delete_$SAMPLE" -hold_jid "eh_$SAMPLE,tredparse_$SAMPLE,gangstr_$SAMPLE,ehdn_$SAMPLE" -sync y -b y echo "Nothing to delete."
fi
