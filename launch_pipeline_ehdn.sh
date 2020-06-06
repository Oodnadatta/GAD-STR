#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Description : script to launch the pipeline for STR detection with EHDN outlier


LAUNCHER="$(readlink -f "$(dirname "$0")/launch_ehdn_outlier.sh")"

cd "/work/gad/shared/analyse/STR/pipeline"
printf "%s\n" dijen* |
    /work/gad/shared/bin/parallel/parallel-20150522-1.el7.cern/bin/parallel \
	--jobs 30 \
        --line-buffer \
        "$LAUNCHER"
