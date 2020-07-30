#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : Anne-Sophie Denommé-Pichon
## Description : script to launch the script to get automatically outliers from expansion pipeline results from getResults.py

# Source configuration file
. "$(dirname "$0")/config.sh"

# $1 : first argument in the command line : a list containing one sample per line, for example samples.list
SAMPLES="$1"

# Check if sample is specified
if [ -z "$SAMPLES" ]
then
    echo "List of samples is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

SCRIPT="$(dirname "$(readlink -f "$0")")/str_outliers.py"
SAMPLES="$(dirname "$(readlink -f "$0")")/$SAMPLES"

cd "$RESULTS_OUTPUTDIR" || exit 1

   for locus_tsv in $(ls *.tsv | grep -v outliers); do
    locus="$(basename "$locus_tsv" ".tsv")"
    echo "Processing $locus" >&2
    "$SCRIPT" "$locus" "$SAMPLES" > "$locus.outliers.tsv"
done

