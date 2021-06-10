#! /bin/sh

### ASDP pipeline###
## Version: 0.0.1
## License; AGPLv3
## Author: Anne-Sophie Denommé-Pichon
## Description: configuration file

INPUTDIR="/archive/gad/shared/bam_new_genome_temp"
OUTPUTDIR="/work/gad/shared/analyse/STR/pipeline"
RESULTS_OUTPUTDIR="/work/gad/shared/analyse/STR/results" # For Plotly and outliers tables

# Valid values: "sge"
INFRA=sge

# Variables specific to SGE
TRANSFER_QUEUE=transfer
COMPUTE_QUEUE=batch
TRANSFER=yes

# Tools
PYTHON="/work/gad/shared/bin/python3.6/python3"

PARALLEL="/work/gad/shared/bin/parallel/parallel-20150522-1.el7.cern/bin/parallel"
PARALLEL_JOB_COUNT="16"

EH="/work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/bin/ExpansionHunter"
EH_VARIANT_CATALOG="/work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/variant_catalog/hg19/variant_catalog.json"

TREDPARSE="/work/gad/shared/bin/tredparse/Tredparse-20190901/bin/tred.py"
TREDPARSE_VENV="/work/gad/shared/bin/tredparse/Tredparse-20190901/bin/activate" # To load Tredparse in a virtual environment

GANGSTR="/work/gad/shared/bin/gangstr/GangSTR-2.4/bin/GangSTR"
GANGSTR_REGIONS="/work/gad/shared/bin/gangstr/STRregions/hg19_ver13_1.bed"

EHDN="/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/bin/ExpansionHunterDenovo-v0.8.0"
EHDN_OUTLIER="/work/gad/shared/bin/expansionhunterdenovo/ExpansionHunterDenovo-v0.8.0-linux_x86_64/scripts/outlier.py"

REF="/work/gad/shared/pipeline/hg19/index/hg19_essential.fa"

# Outliers
ZSCORE_THRESHOLD=4.0
PERCENTILE_THRESHOLD=1.0




