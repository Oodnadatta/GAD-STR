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
## last revision date : 20191217
## Known bugs : None

import glob
import gzip
import json
import logging
import os
import os.path
import re

variants_catalog = '/work/gad/shared/bin/expansionhunter/ExpansionHunter-v3.1.2-linux_x86_64/variant_catalog/hg19/variant_catalog.json'
input_directory ='/work/gad/shared/analyse/STR/pipeline/'
output_directory ='/work/gad/shared/analyse/STR/results/'

genotype = re.compile(r'<STR([0-9]+)>')

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
        with open(file_path) as file:
            for line in file:
                columns = line.replace('\t', ' ').split()
                if (len(columns) >= 2 and
                    columns[0] == region[0] and # same chrom
                    abs(int(columns[1]) - int(region[1])) <= 10): # same pos (+/- 10)
                    return re.sub(genotype, '\g<1>', columns[4])
        return '.'
    except FileNotFoundError:
        logging.warn(f'File not found "{file_path}"')
        return 'nofile'

def get_tred_results(file_path, region):
    try:
        with gzip.open(file_path, 'rt') as file:
            for line in file:
                columns = line.replace('\t', ' ').split()
                if (len(columns) >= 2 and
                    columns[0] == region[0] and # same chrom
                    abs(int(columns[1]) - int(region[1])) <= 10): # same pos (+/- 10)
                    for value in columns[7].split(';'):
                        if value.startswith('RPA='):
                            return value[4:]
        return '.'
    except FileNotFoundError:
        logging.warn(f'File not found "{file_path}"')
        return 'nofile'

def get_gang_results(file_path, region):
    try:
        with open(file_path) as file:
            for line in file:
                columns = line.replace('\t', ' ').split()
                if (len(columns) >= 10 and
                    columns[0] == region[0] and # same chrom
                    abs(int(columns[1]) - int(region[1])) <= 10): # same pos (+/- 10)
                    format, genotype = columns[8], columns[9]
                    if genotype != '.':
                        return genotype.split(':')[format.split(':').index('REPCN')]
                    else:
                        return '.'
        return '.'
    except FileNotFoundError:
        logging.warn(f'File not found "{file_path}"')
        return 'nofile'

def get_results(locus, region):
    with open(os.path.join(output_directory, locus + '.tsv'), 'w') as result_file:
        result_file.write('dijenxxx\tEH\tTred\tGangSTR\n')
        for file_path in sorted(glob.glob(os.path.join(input_directory, 'dijen*'))):
            file_name = file_path.split(os.sep)[-1]
            eh = get_eh_results(os.path.join(file_path, f'eh/{file_name}.vcf'), region)
            tred = get_tred_results(os.path.join(file_path, f'tredparse/{file_name}.tred.vcf.gz'), region)
            gang = get_gang_results(os.path.join(file_path, f'gangstr/{file_name}.vcf'), region)
            result_file.write(f'{file_name}\t{eh}\t{tred}\t{gang}\n')

if __name__ == '__main__':
    os.makedirs(output_directory, exist_ok=True)
    for locus, region in enumerate_variants(variants_catalog):
        get_results(locus, region)
