#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the wrapper for qsubing outlier analysis by ExpansionHunter denovo script for STR detection

# Source configuration file
. "$(dirname "$0")/config.sh"

CASE="$1"

qsub -wd "$(dirname "$(readlink -f "$0")")" -pe smp 1 -q "$COMPUTE_QUEUE" -N "ehdn_outlier_$CASE" -sync y -v CASE="$CASE" wrapper_ehdn_outlier.sh

