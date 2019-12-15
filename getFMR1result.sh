#! /bin/sh

### ASDP PIPELINE ###
## pipeline.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to get automatically results from pipeline.sh script in a tsv format on the FMR1 X fragile locus
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191215
## last revision date : 20191215
## Known bugs : None

cd /work/gad/shared/analyse/STR/pipeline/
(
    echo -e 'dijenxxx\tEH\tTred\tGangSTR'
    ls -d dijen* | while read dijen
    do
        (
            echo "$dijen"
            awk '$1 == "chrX" && $2 == "146993568" {print $5}' $dijen/eh/$dijen.vcf |
                sed 's@<STR\([0-9]\+\)>@\1@g'
            gunzip -c $dijen/tredparse/$dijen.tred.vcf.gz |
                awk '$1 == "chrX" && $2 == "146993569" && $3 == "FXS" {print $8}' |
                tr ';' '\n' |
                awk -F '=' '$1 == "RPA" {print $2}'
            awk '$1 == "chrX" && $2 == "146993569" {print $9 " " $10}' $dijen/gangstr/$dijen.vcf |
                python3 -c 'import sys; format, genotype = sys.stdin.read().split(); print(genotype.split(":")[format.split(":").index("REPCN")]) if genotype != "." else print(".")'
        ) |
            tr '\n' '\t'
        echo
    done
) > results


