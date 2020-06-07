#! /bin/sh

SCRIPT="$(dirname "$(readlink -f "$0")")/str_plotly.py"

cd '/work/gad/shared/analyse/STR/results' || exit 1
for locus_tsv in *.tsv; do
    locus="$(basename "$locus_tsv" ".tsv")"
    echo "Processing $locus" >&2
    "$SCRIPT" "$locus" > "$locus.html"
done

