# STR detection pipeline

- ASDP PIPELINE
- Author: anne-sophie.denomme-pichon@u-bourgogne.fr
- Version: 0.0.1
- Licence: AGPLv3
- Description: How to launch scripts to get STR genotype from genomes on all the locus tested

1. Fill the configuration file `config.sh`.
2. Create `samples.list` (bam file names without .bam).

For now, scripts have to be launched from the clone directory.
3. Launch `launch_pipeline.sh`: `nohup ./launch_pipeline.sh samples.list &`. Dependencies:
   - `config.sh`
   - `samples.list`
   - `pipeline.sh`
   - `wrapper_delete.sh`
   - `wrapper_ehdn.sh`
   - `wrapper_expansionhunter.sh`
   - `wrapper_gangstr.sh`
   - `wrapper_transfer.sh`
   - `wrapper_tredparse.sh`
4. Optional: launch `launch_pipeline_ehdn_outlier.sh`: `nohup ./launch_pipeline_ehdn_outlier.sh &`. Dependencies:
   - `config.sh`
   - `pipeline_ehdn_outlier.sh`
   - `wrapper_ehdn_outlier.sh`
5. Launch `launch_results.sh`: `nohup ./launch_results.sh &`. Dependencies:
   - `config.sh`
   - `sample.list`
   - `patho.csv`
   - `getResults.py`
   - `launch_str_outliers.sh`
   - `str_outliers.py`
6. Optional: launch `launch_str_plotly.sh`.
7. Get files (i.e.: `scp 'an1770de@ssh-ccub.u-bourgogne.fr:/work/gad/shared/analyse/STR/results/*' .`)

