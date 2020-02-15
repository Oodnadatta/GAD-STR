# STR detection pipeline

ASDP PIPELINE
Author: anne-sophie.denomme-pichon@u-bourgogne.fr
Version: 0.0.1
Licence: FIXME
Description: How to launch scripts to get STR genotype from genomes on all the locus tested

1. Create genomes.list
2. Specify output file in launch_pipeline.sh
   Warning, don't overwrite existing files
3. Launch launch_pipeline.sh
   ```bash
   nohup ./launch_pipeline.sh &
   ```
   Dependencies :
   - genomes.list
   - pipeline.sh
   - launch_ehdn.sh
   - launch_expansionhunter.sh
   - launch_gangstr.sh
   - launch_transfer.sh
   - launch_tredparse.sh
   - wrapper_delete.sh
   - wrapper_ehdn.sh
   - wrapper_expansionhunter.sh
   - wrapper_gangstre.sh
   - wrapper_transfer.sh
   - wrapper_tredparse.sh
4. Launch getResults.py