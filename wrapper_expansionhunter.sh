#! /bin/sh

### ASDP PIPELINE ###
## wrapper_expansionhunter.sh
## Version : 0.0.1
## Licence : FIXME
## Description : a wrapper for qsubing ExpansionHunter script for STR detection
## Usage : qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_expansionhunter.sh
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191102
## last revision date : 20191102
## Known bugs : None


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=expansionhunter.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch expansionhunter.failed
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTPREFIX" ]
then
    echo "Output prefix is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch expansionhunter.failed
    exit 1
fi

# Create .bam and .bai symbolic links
TMPDIR="$(mktemp -d)"
ln -s "$INPUTFILE" "$TMPDIR/$(basename "$INPUTFILE")"
ln -s "$(echo "$INPUTFILE" | sed 's/\.bam$/.bai/')" "$TMPDIR/$(basename "$INPUTFILE").bai"

# Launch script command and check exit code
echo "command : /work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/bin/ExpansionHunter \
    --reads "$TMPDIR/$(basename "$INPUTFILE")" \
    --reference /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --variant-catalog /work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/variant_catalog/hg19/variant_catalog.json \
    --output-prefix $OUTPUTPREFIX"
/work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/bin/ExpansionHunter \
    --reads "$TMPDIR/$(basename "$INPUTFILE")" \
    --reference /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --variant-catalog /work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/variant_catalog/hg19/variant_catalog.json \
    --output-prefix "$OUTPUTPREFIX"

expansionhunter_exitcode=$?

# Remove .bam and .bai symbolic links
rm "$TMPDIR/$(basename "$INPUTFILE")"
rm "$TMPDIR/$(basename "$INPUTFILE").bai"
rmdir "$TMPDIR"

echo "expansionhunter exit code : $expansionhunter_exitcode"
if [ $expansionhunter_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch expansionhunter.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
