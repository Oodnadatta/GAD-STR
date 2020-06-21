#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLV3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to launch the pipeline for getting STR detection results. Receive multiple samples: one sample per line

# $1 : first argument in the command line : a list containing one sample per line, for exemple samples.list
SAMPLES="$1"

# Check if sample is specified
if [ -z "$SAMPLES" ]
then
    echo "List of samples is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Source configuration file
. "$(dirname "$0")/config.sh"

# Create the results output directory
mkdir -p "$RESULTS_OUTPUTDIR"

# Launch getResults.py
"$(dirname "$0")/getResults.py" "$SAMPLES"

# Launch launch_str_outliers.sh
"$(dirname "$0")/launch_str_outliers.sh" "$SAMPLES"

