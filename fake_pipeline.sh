#! /bin/sh

### ASDP PIPELINE ###
## launch_pipeline.sh
## Version : 0.0.1
## Licence : aGPLv3
## Description: used to test if pipeline is parallelized on n machines
## Usage: Launched in place of pipeline.sh. To use it, replace pipeline.sh by fake_pipeline.sh in launch_pipeline.sh
## Output: FIXME
## Requirements: FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191208
## last revision date : 20200215
## Known bugs : None

SAMPLE="$1"

# Check if sample is specified
if [ -z "$SAMPLE" ]
then
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

DURATION=$((RANDOM%15+5))

echo "Starting $SAMPLE"

sleep $DURATION

echo "    Finished $SAMPLE ($DURATION sec)"
