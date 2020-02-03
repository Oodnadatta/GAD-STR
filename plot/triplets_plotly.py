#! /usr/bin/env python3

### ASDP PIPELINE ###
## triplets_plotly.py
## Version : 0.0.1
## Licence : FIXME
## Description : script to get automatically graphics from expansion pipeline results from getResults.py with Plotly
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
import sys

path = '/work/gad/shared/analyse/STR/results2020-01-09'

def display_console_graph(title, data):
    print(title)
    for x, y in data:
        print(f'{x}\t{"*" * y}')

def display_html_graph(title, data):
    import plotly.graph_objects as go

    fig = go.Figure(
        data=[go.Bar(
            x=[x for (x, y) in data],
            y=[y for (x, y) in data]
        )],
        layout_title_text=title
    )

    print(fig.to_html())

def graph_locus(locus):
    title = f'Effectif pour chaque nombre de répétitions au locus {locus}'
    with open(f'{path}{os.sep}{locus}.tsv') as result_file:
        tsvreader = csv.reader(result_file, delimiter='\t')
        try:
            next(tsvreader)
            counter = collections.Counter()
            counter[0] = 0
            for row in tsvreader:
                if row[1] not in ['.', 'nofile']:
                    for count in row[1].split(','):
                        counter[int(count)] += 1
        except StopIteration:
            print('Input file is empty', file=sys.stderr)
            sys.exit(1)
        data = sorted(counter.items())
        #display_console_graph(title, data)
        display_html_graph(title, data)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0].split(os.sep)[-1]} <LOCUS>', file=sys.stderr)
        sys.exit(1)
    graph_locus(sys.argv[1])
