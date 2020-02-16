# STR detection pipeline

- ASDP PIPELINE
- Author: anne-sophie.denomme-pichon@u-bourgogne.fr
- Version: 0.0.1
- Licence: FIXME
- Description: How to launch scripts to get STR genotype from genomes on all the locus tested

1. Create `genomes.list`
2. Specify output file in `launch_pipeline.sh`. Warning, don't overwrite existing files
3. Launch `launch_pipeline.sh` : `nohup ./launch_pipeline.sh &`. Dependencies :
   - `genomes.list`
   - `pipeline.sh`
   - `wrapper_delete.sh`
   - `wrapper_ehdn.sh`
   - `wrapper_expansionhunter.sh`
   - `wrapper_gangstre.sh`
   - `wrapper_transfer.sh`
   - `wrapper_tredparse.sh`
4. Launch `getResults.py`. Warning, don't overwrite existing files.
5. Specify input directory in `triplets_plotly.py` and in `launch_triplets_plotly.sh`.
6. Launch `launch_triplets_plotly.sh`.
7. Specify input directory in `triplets_outliers.py` and in `launch_triplets_outliers.sh`.
8. Change z-score threshold if necessary in `triplets_outliers.py`.
9. Launch `launch_triplets_outliers.sh`.