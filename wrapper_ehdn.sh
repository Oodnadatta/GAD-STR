#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: a wrapper for qsubing ExpansionHunter denovo script for STR detection
## Usage: qsub -pe smp 1 -v INPUTFILE=<path to the bam file>,OUTPUTPREFIX=<output prefix>,[LOGFILE=<path to the log file>] wrapper_ehdn.sh


# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=ehdn.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"


# Check if input file exists
if [ ! -f "$INPUTFILE" ]
then
    echo "Input file '$INPUTFILE' does not exist"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if output prefix is specified
if [ -z "$OUTPUTPREFIX" ]
then
    echo "Output prefix is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Create .bam and .bai symbolic links
TMPDIR="$(mktemp -d)"
ln -s "$INPUTFILE" "$TMPDIR/$(basename "$INPUTFILE")"
ln -s "$(echo "$INPUTFILE" | sed 's/\.bam$/.bai/')" "$TMPDIR/$(basename "$INPUTFILE").bai"

# Launch script command and check exit code
echo "command : /work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/bin/ExpansionHunterDenovo-v0.8.0 profile \
    --reads "$TMPDIR/$(basename "$INPUTFILE")" \
    --reference /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --output-prefix $OUTPUTPREFIX \
    --min-anchor-mapq 50 \
    --max-irr-mapq 40"
/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/bin/ExpansionHunterDenovo-v0.8.0 profile \
    --reads "$TMPDIR/$(basename "$INPUTFILE")" \
    --reference /work/gad/shared/pipeline/hg19/index/hg19_essential.fa \
    --output-prefix "$OUTPUTPREFIX" \
    --min-anchor-mapq 50 \
    --max-irr-mapq 40

ehdn_exitcode=$?

# Remove .bam and .bai symbolic links
rm "$TMPDIR/$(basename "$INPUTFILE")"
rm "$TMPDIR/$(basename "$INPUTFILE").bai"
rmdir "$TMPDIR"

echo "ehdn exit code : $ehdn_exitcode"
if [ $ehdn_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"
