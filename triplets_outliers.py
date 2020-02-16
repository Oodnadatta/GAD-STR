#! /usr/bin/env python3

### ASDP PIPELINE ###
## triplets_outliers.py
## Version : 0.0.1
## Licence : FIXME
## Description : script to get automatically outliers from expansion pipeline results from getResults.py
## Usage :
## Output : FIXME
## Requirements : FIXME

## Author : anne-sophie.denomme-pichon@u-bourgogne.fr
## Creation Date : 20200202
## last revision date : 20200202
## Known bugs : None

import collections
import csv
import os
import scipy.stats
import sys

path = '/work/gad/shared/analyse/STR/results2020-01-09'

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

def display_outliers(locus, limits):
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
    with open(f'{path}{os.sep}{locus}.tsv') as result_file:
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
                    results[dijen][tool]['5 %'] = tool_value
                    results[dijen][tool]['Z score'] = tool_value
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

    # 5 % limit
    for tool, tool_values in tools_values.items():
        if tool_values:
            tool_5p_limit = sorted(tool_values)[-len(tool_values)//20:][0]
            for dijen, dijen_outliers in results.items():
                tool_5p_outliers = dijen_outliers[tool]['5 %']
                actual_outlier = False
                # count: number of repeats from the input file
                for count in tool_5p_outliers.split(','):
                    if count != '.':
                        if int(count) >= tool_5p_limit:
                            actual_outlier = True
                            break
                if not actual_outlier:
                    dijen_outliers[tool]['5 %'] = '.'

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
                for count in dijen_outliers[tool]['Z score'].split(','):
                    if count != '.':
                        zscore = next(zscores)
                        if zscore == '.':
                            zscore_outliers.append('.')
                        else:
                            zscore_outliers.append(f'{zscore:.3f}')
                            if zscore >= 2.0:
                                actual_outlier = True
                if actual_outlier:
                    dijen_outliers[tool]['Z score'] = ','.join(zscore_outliers)
                else:
                    dijen_outliers[tool]['Z score'] = '.'

    # Output
    print('dijen\tEH\tEH\tEH\tEH\tTred\tTred\tTred\tTred\tGangSTR\tGangSTR\tGangSTR\tGangSTR')
    print('\tLimit\t5 %\tZ score\t< 3' * 3)
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
        if dijen_has_outliers:
            print('\t'.join(all_outliers))

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0].split(os.sep)[-1]} <LOCUS>', file=sys.stderr)
        sys.exit(1)
    limits = load_limits()
    display_outliers(sys.argv[1], limits)
