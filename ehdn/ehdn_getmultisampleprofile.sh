#! /bin/sh

### ASDP PIPELINE ###
## ehdn_getmanifest.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to generate automatically a manifest and multisampleprofile by patient in a tsv format
## Usage :
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20200215
## last revision date : 20200215
## Known bugs : None

EHDN="/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/bin/ExpansionHunterDenovo-v0.8.0"
REFERENCE="/work/gad/shared/pipeline/hg19/index/hg19_essential.fa"
WORKDIR="/work/gad/shared/analyse/STR/pipeline"

cd "$WORKDIR"

# Generate manifest and multisampleprofile by patient for all patients (to write file)
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
    # Generate multisampleprofile for one patient with all samples
    "$EHDN" merge \
	--reference "$REFERENCE" \
	--manifest "$WORKDIR/$case/ehdn/$case.manifest.tsv" \
	--output-prefix "$case/ehdn/$case"
done


