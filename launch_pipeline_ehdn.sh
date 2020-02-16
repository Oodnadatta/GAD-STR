#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: FIXME
## Description : script to launch the pipeline for STR detection with EHDN outlier
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20200215
## last revision date : 20200215
## Known bugs : None

LAUNCHER="$(readlink -f "$(dirname "$0")/launch_ehdn_outlier.sh")"

cd "/work/gad/shared/analyse/STR/pipeline"
printf "%s\n" dijen* |
    /work/gad/shared/bin/parallel/parallel-20150522-1.el7.cern/bin/parallel \
	--jobs 30 \
        --line-buffer \
        "$LAUNCHER"
