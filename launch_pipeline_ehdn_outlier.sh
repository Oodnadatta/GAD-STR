#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : Anne-Sophie Denommé-Pichon
## Description : script to launch the pipeline for STR detection with EHDN outlier

# $1 : first argument in the command line : a list containing one sample per line, for example samples.list
SAMPLES="$1"

# Check if samples list file is specified
if [ -z "$SAMPLES" ]
then
    echo "List of samples is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Source configuration file
. "$(dirname "$0")/config.sh"

# Parallel allow to parallelize the processing of multiple samples ({}: one line in samples.list ; $SAMPLES: the file name: samples.list)
"$PARALLEL" \
    --jobs "$PARALLEL_JOB_COUNT" \
    --line-buffer \
    "$(dirname "$0")/pipeline_ehdn_outlier.sh" {} "$SAMPLES" \
    < "$SAMPLES"
