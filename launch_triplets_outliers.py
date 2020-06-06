#! /bin/sh

SCRIPT="$(dirname "$(readlink -f "$0")")/triplets_outliers.py"

cd '/work/gad/shared/analyse/STR/results' || exit 1
for locus_tsv in $(ls *.tsv | grep -v outliers); do
    locus="$(basename "$locus_tsv" ".tsv")"
    echo "Processing $locus" >&2
    "$SCRIPT" "$locus" > "$locus.outliers.tsv"
done

