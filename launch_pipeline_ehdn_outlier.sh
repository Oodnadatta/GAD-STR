#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Description : script to launch the pipeline for STR detection with EHDN outlier

# Source configuration file
. "$(dirname "$0")/config.sh"

cd "$OUTPUTDIR"
printf "%s\n" * |
    "$PARALLEL" \
	--jobs "$PARALLEL_JOB_COUNT" \
        --line-buffer \
	"$(dirname "$(readlink -f "$0"))/pipeline_ehdn_outlier.sh"
