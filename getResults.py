#! /usr/bin/env python3

### ASDP PIPELINE ###
## getResults.py
## Version: 0.0.1
## Licence: AGPLv3
## Author: anne-sophie.denomme-pichon@u-bourgogne.fr
## Description: script to get automatically results from pipeline.sh script in a tsv format on all the locus

import csv
import gzip
import json
import logging
import os
import os.path
import re
import sys

input_directory = None
output_directory = None
variant_catalog = None

with open(os.path.join(os.path.dirname(sys.argv[0]), 'config.sh')) as config:
    for line in config:
        if '=' in line:
            variable, value = line.split('=', 1)
            if variable == 'OUTPUTDIR':
                input_directory = value.split('#')[0].strip('"\' \n') # strip double quotes, simple quotes and spaces, new line
            elif variable == 'RESULTS_OUTPUTDIR':
                output_directory = value.split('#')[0].strip('"\' \n') # strip double quotes, simple quotes and spaces, new line
            elif variable == 'EH_VARIANT_CATALOG':
                variant_catalog = value.split('#')[0].strip('"\' \n') # strip double quotes, simple quotes and spaces, new line

if input_directory is None or output_directory is None or variant_catalog is None:
    logging.error('OUTPUTDIR, RESULTS_OUTPUTDIR or EH_VARIANT_CATALOG is missing in config.sh')
    sys.exit(1)

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

def get_results(locus, region, samples):
    has_header = False
    previous_results = set()
    try:
        with open(os.path.join(output_directory, locus + '.tsv'), 'r') as result_file:
            tsvreader = csv.reader(result_file, delimiter='\t')
            try:
                next(tsvreader) # not take into account the header
                has_header = True
                for row in tsvreader:
                    previous_results.add(row[0])
            except StopIteration:
                pass
    except:
        pass
    
        
    with open(os.path.join(output_directory, locus + '.tsv'), 'a') as result_file:
        if not has_header: # If the outputfile has not header (file empty), it adds the header (unlikely to happen)
            result_file.write('samplexxx\tEH\tTred\tGangSTR\n')
        for sample in samples:
            if sample not in previous_results:
                file_path = os.path.join(input_directory, sample)
                print(file_path)
                eh = get_eh_results(os.path.join(file_path, f'eh/{sample}.vcf'), region)
                tred = get_tred_results(os.path.join(file_path, f'tredparse/{sample}.tred.vcf.gz'), region)
                gang = get_gang_results(os.path.join(file_path, f'gangstr/{sample}.vcf'), region)
                result_file.write(f'{sample}\t{eh}\t{tred}\t{gang}\n')

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0].split(os.sep)[-1]} <SAMPLESLIST>', file=sys.stderr)
        sys.exit(1)
    with open(sys.argv[1]) as samples_list:
        samples = []
        for line in sorted(samples_list.readlines()):
            sample = line.rstrip()
            if sample:
                samples.append(sample)
    os.makedirs(output_directory, exist_ok=True)
    for locus, region in enumerate_variants(variant_catalog):
        print(locus, region)
        get_results(locus, region, samples)
