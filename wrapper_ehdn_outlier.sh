#! /bin/sh

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author: Anne-Sophie Denommé-Pichon
## Description: script to generate automatically a manifest and multisampleprofile in a tsv format, then do outlier analyses for a single patient

# Source the configuration file
. ./config.sh

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
    echo "Sample is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Check if samples list file is specified
if [ -z "$SAMPLES" ]
then
    echo "Sample list file is not specified"
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Generate manifest for one patient with all samples (to write lines in the file)
while read sample
do
    # Check if str_profile.json exists
    if [ -f "$OUTPUTDIR/$sample/str/ehdn/$sample.str_profile.json" ]
    then
        if [ "x$sample" = "x$CASE" ]
        then
            echo -e "$sample\tcase\t$OUTPUTDIR/$sample/str/ehdn/$sample.str_profile.json"
        else
            echo -e "$sample\tcontrol\t$OUTPUTDIR/$sample/str/ehdn/$sample.str_profile.json"
        fi
    fi
done < "$SAMPLES" > "$OUTPUTDIR/$CASE/str/ehdn/$CASE.manifest.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Generate multisampleprofile for one patient with all samples
"$EHDN" merge \
    --reference "$REFERENCE" \
    --manifest "$OUTPUTDIR/$CASE/str/ehdn/$CASE.manifest.tsv" \
    --output-prefix "$CASE/str/ehdn/$CASE"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

# Run locus-based comparison analysis
"$EHDN_OUTLIER" locus \
    --manifest "$OUTPUTDIR/$CASE/str/ehdn/$CASE.manifest.tsv" \
    --multisample-profile "$OUTPUTDIR/$CASE/str/ehdn/$CASE.multisample_profile.json" \
    --output "$OUTPUTDIR/$CASE/str/ehdn/$CASE.outlier_locus.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi


# Run motif_based comparison analysis
"$EHDN_OUTLIER" motif \
    --manifest "$OUTPUTDIR/$CASE/str/ehdn/$CASE.manifest.tsv" \
    --multisample-profile "$OUTPUTDIR/$CASE/str/ehdn/$CASE.multisample_profile.json" \
    --output "$OUTPUTDIR/$CASE/str/ehdn/$CASE.outlier_motif.tsv"

ehdn_outlier_exitcode=$?

echo "ehdn_outlier exit code : $ehdn_outlier_exitcode"
if [ $ehdn_outlier_exitcode != 0 ]
then
    echo "$(date +"%F_%H-%M-%S"): END"
    exit 1
fi

echo "$(date +"%F_%H-%M-%S"): END"



