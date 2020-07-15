#! /bin/sh

### ASDP pipeline###
## Version: 0.0.1
## License; AGPLv3
## Author: Anne-Sophie Denommé-Pichon
## Description: script to launch the script to get automatically graphics from expansion pipeline results from getResults.py with Plotly

# Source configuration file
. "$(dirname "$0")/config.sh"

SCRIPT="$(dirname "$(readlink -f "$0")")/str_plotly.py"

cd "$RESULTS_OUTPUTDIR" || exit 1
for locus_tsv in *.tsv; do
    locus="$(basename "$locus_tsv" ".tsv")"
    echo "Processing $locus" >&2
    "$SCRIPT" "$locus" > "$locus.html"
done

