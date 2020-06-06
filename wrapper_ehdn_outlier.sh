#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to generate automatically a manifest and multisampleprofile in a tsv format, then do outlier analyses for a single patient


EHDN="/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/bin/ExpansionHunterDenovo-v0.8.0"
EHDN_OUTLIER="/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/scripts/outlier.py"
REFERENCE="/work/gad/shared/pipeline/hg19/index/hg19_essential.fa"
WORKDIR="/work/gad/shared/analyse/STR/pipeline"

# Log file path option
if [ -z "$LOGFILE" ]
then
    LOGFILE=ehdn_outlier.$(date +"%F_%H-%M-%S").log
fi

# Logging
exec 1>> "$LOGFILE" 2>&1
echo "$(date +"%F_%H-%M-%S"): START"

# Check if case is specified
if [ -z "$CASE" ]
then
    echo "Dijen is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    touch ehdn_outlier.failed
    exit 1
fi

# Generate manifest for one patient with all samples (to write lines in the file)
cd "$WORKDIR"
for dijen in dijen*
do
    # Check if str_profile.json exists
    if [ -f "$WORKDIR/$dijen/ehdn/$dijen.str_profile.json" ]
    then
        if [ "x$dijen" = "x$CASE" ]
        then
        echo -e "$dijen\tcase\t$WORKDIR/$dijen/ehdn/$dijen.str_profile.json"
        else
        echo -e "$dijen\tcontrol\t$WORKDIR/$dijen/ehdn/$dijen.str_profile.json"
        fi
    fi
done > "$WORKDIR/$CASE/ehdn/$CASE.manifest.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch ehdn_outlier.failed
    exit 1
fi

# Generate multisampleprofile for one patient with all samples
"$EHDN" merge \
    --reference "$REFERENCE" \
    --manifest "$WORKDIR/$CASE/ehdn/$CASE.manifest.tsv" \
    --output-prefix "$CASE/ehdn/$CASE"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch ehdn_outlier.failed
    exit 1
fi

# Run locus-based comparison analysis
"$EHDN_OUTLIER" locus \
    --manifest "$WORKDIR/$CASE/ehdn/$CASE.manifest.tsv" \
    --multisample-profile "$WORKDIR/$CASE/ehdn/$CASE.multisample_profile.json" \
    --output "$WORKDIR/$CASE/ehdn/$CASE.outlier_locus.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch ehdn_outlier.failed
    exit 1
fi


# Run motif_based comparison analysis
"$EHDN_OUTLIER" motif \
    --manifest "$WORKDIR/$CASE/ehdn/$CASE.manifest.tsv" \
    --multisample-profile "$WORKDIR/$CASE/ehdn/$CASE.multisample_profile.json" \
    --output "$WORKDIR/$CASE/ehdn/$CASE.outlier_motif.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    touch ehdn_outlier.failed
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"



