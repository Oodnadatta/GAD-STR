#! /bin/sh

### ASDP PIPELINE ###
## wrapper_stretch.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing STRetch script for STR detection
## Usage : qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_stretch.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191118
## last revision date : 20191118
## Known bugs : None


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=stretch.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch stretch.failed
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTPREFIX" ]
then
    echo "Output prefix is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch stretch.failed
    exit 1
fi

# Launch script command and check exit code
echo "cd "$OUTPUTDIR"
/work/gad/shared/bin/stretch/STRetch-20190602/tools/bin/bpipe \
    run -p input_regions=/work/gad/shared/bin/stretch/STRetch-20190602/reference-data/hg19.STR_disease_loci.bed \
    /work/gad/shared/bin/stretch/STRetch-20190602/pipelines/STRetch_wgs_bam_pipeline.groovy \
    "$INPUTFILE""

cd "$OUTPUTDIR"
/work/gad/shared/bin/stretch/STRetch-20190602/tools/bin/bpipe \
    run -p input_regions=/work/gad/shared/bin/stretch/STRetch-20190602/reference-data/hg19.STR_disease_loci.bed \
    /work/gad/shared/bin/stretch/STRetch-20190602/pipelines/STRetch_wgs_bam_pipeline.groovy \
    "$INPUTFILE"

stretch_exitcode=$?

echo "stretch exit code : $stretch_exitcode"
if [ $stretch_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch stretch.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
