#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the wrapper for qsubing outlier analysis by ExpansionHunter denovo script for STR detection

# Source configuration file
. "$(dirname "$0")/config.sh"

CASE="$1"

qsub -pe smp 1 -q "$COMPUTE_QUEUE" -N "ehdn_outlier_$CASE" -sync y -v CASE="$CASE" "$(dirname "$0")/wrapper_ehdn_outlier.sh"

