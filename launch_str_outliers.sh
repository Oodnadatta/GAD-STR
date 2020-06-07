#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Description : script to launch the script to get automatically outliers from expansion pipeline results from getResults.py

# Source configuration file
. "$(dirname "$0")/config.sh"

SCRIPT="$(dirname "$(readlink -f "$0")")/str_outliers.py"

cd "$OUTPUTDIR" || exit 1
for locus_tsv in $(ls *.tsv | grep -v outliers); do
    locus="$(basename "$locus_tsv" ".tsv")"
    echo "Processing $locus" >&2
    "$SCRIPT" "$locus" > "$locus.outliers.tsv"
done

