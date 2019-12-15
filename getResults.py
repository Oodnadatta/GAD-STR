#! /usr/bin/env python3

### ASDP PIPELINE ###
## getResults.py
## Version : 0.0.1
## Licence : FIXME
## Description : script to get automatically results from pipeline.sh script in a tsv format on all the locus
## Usage : 
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20191215
## last revision date : 20191215
## Known bugs : None

import glob
import json
import logging
import os
import os.path
import re

variants_catalog = '/work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/variant_catalog/hg19/variant_catalog.json'
input_directory ='/work/gad/shared/analyse/STR/pipeline/'
output_directory ='/work/gad/shared/analyse/STR/results/'

def enumerate_variants(catalog_path):
    with open(catalog_path) as catalog_file:
        variants = json.load(catalog_file)

        for variant in variants:
            region = variant['ReferenceRegion']
            # TODO handle other regions?
            if isinstance(region, list):
                region = region[0]
            chrom, pos = region.split(':')
            pos = pos.split('-')[0]
            yield variant['LocusId'], (chrom, pos)

def get_eh_results(file_path, region):
    try:
        with open(file_path) as eh_file:
            for line in eh_file:
                columns = re.split(r'[ \t]+', line)
                # TODO FIXME allow for some difference in position
                if len(columns) >= 2 and columns[0] == region[0] and columns[1] == region[1]:
                    return re.sub('<STR([0-9]+)>', '\g<1>', columns[4])
        return '.'
    except FileNotFoundError:
        logging.warn(f'File not found "{file_path}"')
        return 'nofile'

def get_tred_results(file_path, region):
#             gunzip -c $dijen/tredparse/$dijen.tred.vcf.gz |
#                 awk '$1 == "chrX" && $2 == "146993569" && $3 == "FXS" {print $8}' |
#                 tr ';' '\n' |
#                 awk -F '=' '$1 == "RPA" {print $2}'
    return 'FIXME'

def get_gang_results(file_path, region):
#             awk '$1 == "chrX" && $2 == "146993569" {print $9 " " $10}' $dijen/gangstr/$dijen.vcf |
#                 python3 -c 'import sys; format, genotype = sys.stdin.read().split(); print(genotype.split(":")[format.split(":").index("REPCN")]) if genotype != "." else print(".")'
    return 'FIXME'

def get_results(locus, region):
    with open(os.path.join(output_directory, locus + '.tsv'), 'w') as result_file:
        result_file.write('dijenxxx\tEH\tTred\tGangSTR\n')
        for file_path in sorted(glob.glob(os.path.join(input_directory, 'dijen*'))):
            file_name = file_path.split(os.sep)[-1]
            eh = get_eh_results(os.path.join(file_path, f'eh/{file_name}.vcf'), region)
            tred = get_tred_results(os.path.join(file_path, f'tredparse/{file_name}.vcf.gz'), region)
            gang = get_gang_results(os.path.join(file_path, f'gangstr/{file_name}.vcf'), region)
            result_file.write(f'{file_name}\t{eh}\t{tred}\t{gang}\n')

if __name__ == '__main__':
    os.makedirs(output_directory, exist_ok=True)
    for locus, region in enumerate_variants(variants_catalog):
        get_results(locus, region)
        break # TODO remove

