# GAD STR expansion detection pipeline

 - Author:  Anne-Sophie Denommé-Pichon
 - Version: 0.0.1
 - Licence: AGPLv3
 - Description: this pipeline allows to get STR genotype from short-read genomes on the locus specified. It uses ExpansionHunter, Tredparse and GangSTR. It computes genotypes called by the tools and identifies STR expansions using 3 outlier detection methods to highlight abnormal repeat counts.

## Setup

 - Fill the configuration file `config.sh`. There is an example in the repository.
 - Create `samples.list` (bam file names without .bam). There is an example in the repository.

## Usage

For now, scripts have to be launched from the clone directory.

### Calling STRs

Launch `launch_pipeline.sh`:

```sh
nohup ./launch_pipeline.sh samples.list &
```

Dependencies:
 - `config.sh`
 - `samples.list`
 - `pipeline.sh`
 - `wrapper_delete.sh`
 - `wrapper_ehdn.sh`
 - `wrapper_expansionhunter.sh`
 - `wrapper_gangstr.sh`
 - `wrapper_transfer.sh`
 - `wrapper_tredparse.sh`

### Identifying outliers 

To highlight abnormal repeat counts, the pipeline identified outliers using 3 methods: repeats counts at a given locus

 1. > normal (in the gray zone or pathological zone)
 2. > 99th percentile or
 3. ≥ 4 standard deviations above the mean (Z-score ≥ 4). 

Launch `launch_results.sh`:

```sh
nohup ./launch_results.sh samples.list &
```

Dependencies:
 - `config.sh`
 - `samples.list`
 - `patho.csv`
 - `getResults.py`
 - `launch_str_outliers.sh`
 - `str_outliers.py`

## Future work

Another tool, ExpansionHunter DeNovo, will be added in the pipeline.
