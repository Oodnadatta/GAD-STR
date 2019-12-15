#! /bin/sh

### ASDP PIPELINE ###
## pipeline.sh
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

SAMPLE="$1"

# Check if sample is specified
if [ -z "$SAMPLE" ]
then
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

INPUTFILE="/archive/gad/shared/bam_new_genome_temp/$SAMPLE.bam"
DATE="$(date +"%F_%H-%M-%S")"
OUTPUTDIR="/work/gad/shared/analyse/STR/pipeline/$SAMPLE"

# Transfer bam and bai from archive to work
mkdir -p "$OUTPUTDIR"
qsub -pe smp 1 -q transfer -N "transfer_$SAMPLE" -v INPUTFILE="$INPUTFILE",OUTPUTDIR="$OUTPUTDIR",LOGFILE="$OUTPUTDIR/transfer_$DATE.log" wrapper_transfer.sh

INPUTFILE="$OUTPUTDIR/$SAMPLE.bam"

# Launch ExpansionHunter
mkdir -p "$OUTPUTDIR/eh"
qsub -pe smp 4 -q batch  -N "eh_$SAMPLE" -hold_jid "transfer_$SAMPLE" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/eh/$SAMPLE",LOGFILE="$OUTPUTDIR/eh/$DATE.log" wrapper_expansionhunter.sh

# Launch Tredparse
mkdir -p "$OUTPUTDIR/tredparse"
qsub -pe smp 4 -q batch -N "tredparse_$SAMPLE" -hold_jid "transfer_$SAMPLE" -v INPUTFILE="$INPUTFILE",OUTPUTDIR="$OUTPUTDIR/tredparse",LOGFILE="$OUTPUTDIR/tredparse/$DATE.log" wrapper_tredparse.sh

# Launch GangSTR
mkdir -p "$OUTPUTDIR/gangstr"
qsub -pe smp 4 -q batch -N "gangstr_$SAMPLE" -hold_jid "transfer_$SAMPLE" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/gangstr/$SAMPLE",LOGFILE="$OUTPUTDIR/gangstr/$DATE.log" wrapper_gangstr.sh

# Launch ehdn profile
mkdir -p "$OUTPUTDIR/ehdn"
qsub -pe smp 4 -q batch -N "ehdn_$SAMPLE" -hold_jid "transfer_$SAMPLE" -v INPUTFILE="$INPUTFILE",OUTPUTPREFIX="$OUTPUTDIR/ehdn/$SAMPLE",LOGFILE="$OUTPUTDIR/ehdn/$DATE.log" wrapper_ehdn.sh

# Delete transfered bam and bai
qsub -pe smp 1 -q batch -hold_jid "eh_$SAMPLE,tredparse_$SAMPLE,gangstr_$SAMPLE,ehdn_$SAMPLE" -sync y -v SAMPLE="$SAMPLE",LOGFILE="$OUTPUTDIR/delete_$DATE.log" wrapper_delete.sh