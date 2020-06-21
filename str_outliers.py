#! /usr/bin/env python3

### ASDP PIPELINE ###
## Version : 0.0.1
## Licence : AGPLv3
## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Description : script to get automatically outliers from expansion pipeline results from getResults.py


import collections
import csv
import logging
import math
import os
import os.path
import scipy.stats
import sys



output_directory = None
zscore_threshold = None
percentile_threshold = None

with open(os.path.join(os.path.dirname(sys.argv[0]), 'config.sh')) as config:
    for line in config:
        if '=' in line:
            variable, value = line.split('=', 1)
            if variable == 'RESULTS_OUTPUTDIR':
                output_directory = value.split('#')[0].strip('"\' ') # strip double quotes, simple quotes and spaces
            elif variable == 'ZSCORE_THRESHOLD':
                zscore_threshold = float(value.split('#')[0].strip('"\' ')) # strip double quotes, simple quotes and spaces
            elif variable == 'PERCENTILE_THRESHOLD':
                percentile_threshold = float(value.split('#')[0].strip('"\' ')) # strip double quotes, simple quotes and spaces

if output_directory is None:
    logging.error('RESULTS_OUTPUTDIR or ZSCORE_THRESHOLD or PERCENTILE_THRESHOLD is missing in config.sh')
    sys.exit(1)

zscore_label = f'Z>={zscore_threshold}'
percentile_label = f'{percentile_threshold}%'

def load_limits():
    limits = {}
    with open(f'{sys.argv[0].rsplit("/", 1)[0]}{os.sep}patho.csv') as limits_file:
        csvreader = csv.reader(limits_file, delimiter=';')
        try:
            next(csvreader)
            for row in csvreader:
                if row[1] != 'NA':
                    limits[row[0]] = int(row[1])
            return limits
        except StopIteration:
            print('Limits file is empty', file=sys.stderr)
            sys.exit(1)

def display_outliers(locus, limits, samples):
    # results = {
    #     'dijen': {
    #         'tool': {
    #             'Limit': 42,
    #             '5 %': 42,
    #             'Z score': 42,
    #             '< 3': 2
    #         }
    #     }
    # }
    results = collections.OrderedDict()
    tools_values = {}
    with open(f'{output_directory}{os.sep}{locus}.tsv') as result_file:
        tsvreader = csv.reader(result_file, delimiter='\t')
        try:
            tools = next(tsvreader)[1:]
            for row in tsvreader:
                dijen = row[0]

                results[dijen] = collections.OrderedDict()
                for tool_id, tool in enumerate(tools):
                    tool_value = row[tool_id + 1].replace('nofile', '.').replace('-1', '.')
                    tools_values.setdefault(tool, [])
                    results[dijen][tool] = collections.OrderedDict()
                    results[dijen][tool]['Limit'] = '.'
                    results[dijen][tool][percentile_label] = tool_value
                    results[dijen][tool][zscore_label] = tool_value
                    results[dijen][tool]['< 3'] = '.'

                    # > upper limit of normality or < 3
                    if tool_value != '.':
                        # count: number of repeats from the input file
                        for count in tool_value.split(','):
                            if count != '.':
                                tools_values[tool].append(int(count))
                                if int(count) < 3:
                                    results[dijen][tool]['< 3'] = tool_value
                                if locus in limits:
                                    if int(count) > limits[locus]:
                                        results[dijen][tool]['Limit'] = tool_value
                                else:
                                    results[dijen][tool]['Limit'] = 'NA'
    
        except StopIteration:
            print('Input file is empty', file=sys.stderr)
            sys.exit(1)

    # outlier threshold (exemple: 5%)
    for tool, tool_values in tools_values.items():
        # Test if there is at least one value given by the tool
        if tool_values:
            tool_percentile_limit = sorted(tool_values)[-math.ceil(len(tool_values) * percentile_threshold / 100):][0]
            for dijen, dijen_outliers in results.items():
                tool_percentile_outliers = dijen_outliers[tool][percentile_label]
                actual_outlier = False
                # count: number of repeats from the input file
                for count in tool_percentile_outliers.split(','):
                    if count != '.':
                        if int(count) >= tool_percentile_limit:
                            actual_outlier = True
                            break
                if not actual_outlier:
                    dijen_outliers[tool][percentile_label] = '.'

    # Z score
    for tool, tool_values in tools_values.items():
        if tool_values:
            if len(tool_values) > 1:
                zscores = iter(scipy.stats.zscore(tool_values))
            else:
                zscores = iter(['.'])
            for dijen_outliers in results.values():
                actual_outlier = False
                zscore_outliers = []
                # count: number of repeats from the input file                
                for count in dijen_outliers[tool][zscore_label].split(','):
                    if count != '.':
                        zscore = next(zscores)
                        if zscore == '.':
                            zscore_outliers.append('.')
                        else:
                            zscore_outliers.append(f'{zscore:.3f}')
                            if zscore >= zscore_threshold:
                                actual_outlier = True
                if actual_outlier:
                    dijen_outliers[tool][zscore_label] = ','.join(zscore_outliers)
                else:
                    dijen_outliers[tool][zscore_label] = '.'

    # Output
    print('sample\tEH\tEH\tEH\tEH\tTred\tTred\tTred\tTred\tGangSTR\tGangSTR\tGangSTR\tGangSTR')
    print(f'\tLimit\t{percentile_label}\t{zscore_label}\t< 3' * 3)
    for dijen, dijen_outliers in results.items():
        all_outliers = [dijen]
        dijen_has_outliers = False
        for tool, tool_outliers in dijen_outliers.items():
            if tool_outliers:
                for tool_outlier_value in tool_outliers.values():
                    if tool_outlier_value != '.':
                        dijen_has_outliers = True
                all_outliers.extend(tool_outliers.values())
            else:
                all_outliers.append('.')
        if dijen_has_outliers and dijen in samples:
            print('\t'.join(all_outliers))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f'Usage: {sys.argv[0].split(os.sep)[-1]} <LOCUS> <SAMPLE.LIST>', file=sys.stderr)
        sys.exit(1)
    with open(sys.argv[2]) as samples_list:
        samples = set()
        for sample in samples_list.readlines():
            samples.add(sample.rstrip())
    limits = load_limits()
    display_outliers(sys.argv[1], limits, samples)
