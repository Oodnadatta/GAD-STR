#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: Anne-Sophie Denommé-Pichon
## Description: script to launch the wrapper for qsubing outlier analysis by ExpansionHunter denovo script for STR detection

# Source configuration file
. "$(dirname "$0")/config.sh"

CASE="$1"
SAMPLES="$2"
DATE="$(date +"%F_%H-%M-%S")"
WD="$(dirname "$(readlink -f "$0")")"

LOGDIR="$OUTPUTDIR/logs"
STRDIR="$OUTPUTDIR/str"

mkdir -p "$LOGDIR" "$STRDIR"


qsub -wd "$WD" -pe smp 1 -o "$LOGDIR" -e "$LOGDIR" -q "$COMPUTE_QUEUE" -N "ehdn_outlier_$CASE" -sync y -v CASE="$CASE",SAMPLES="$SAMPLES",LOGFILE="$LOGDIR/ehdn_outlier_$CASE.$DATE.log" "$WD/wrapper_ehdn_outlier.sh"

