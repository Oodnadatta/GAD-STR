#! /bin/sh

### ASDP PIPELINE ###
## ehdn_getmanifest.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to generate automatically a manifest by patient in a tsv format
## Usage :
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20200215
## last revision date : 20200215
## Known bugs : None

WORKDIR="/work/gad/shared/analyse/STR/pipeline"

cd "$WORKDIR"

# Generate manifest by patient for all patients (to write file)
for case in dijen*
do
    # Generate manifest for one patient with all samples (to write lines in the file)
    for dijen in dijen*
    do
        if [ "x$dijen" = "x$case" ]
        then
	    echo -e "$dijen\tcase\t$WORKDIR/$dijen/ehdn/$dijen.str_profile.json"
        else
	    echo -e "$dijen\tcontrol\t$WORKDIR/$dijen/ehdn/$dijen.str_profile.json"
        fi
    done > "$WORKDIR/$case/ehdn/$case.manifest.tsv"
done


