#! /bin/sh

### ASDP PIPELINE ###
## launch_pipeline.sh
## Version : 0.0.1
## Licence : FIXME
## Description : script to launch the pipeline for STR detection
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191208
## last revision date : 20191208
## Known bugs : None

/work/gad/shared/bin/parallel/parallel-20150522-1.el7.cern/bin/parallel \
    --jobs 10 \
    --line-buffer \
    "$(dirname "$0")/pipeline.sh" \
    < genomes.list
