#! /usr/bin/env python3

### ASDP PIPELINE ###
## Version: 0.0.1
## Licence: AGPLv3
## Author : Anne-Sophie Denommé-Pichon
## Description: script to get automatically graphics from expansion pipeline results from getResults.py with Plotly

import collections
import csv
import logging
import os
import os.path
import sys

output_directory = None

with open(os.path.join(os.path.dirname(sys.argv[0]), 'config.sh'))) as config:
    for line in config:
        if '=' in line:
            variable, value = line.split('=', 1)
            elif variable == 'RESULTS_OUTPUTDIR':
                output_directory = value.split('#')[0].strip('"\' ') # strip double quotes, simple quotes and spaces

if output_directory is None
    logging.error('RESULTS_OUTPUTDIR is missing in config.sh')
    sys.exit(1)

def display_console_graph(title, tools, data):
    print(title)
    for tool, tool_data in zip(tools, data):
        print(tool)
        for x, y in tool_data:
            print(f'{x}\t{"*" * y}')

def display_html_graph(title, tools, data):
    import plotly.graph_objects as go
    import plotly.subplots as sp

    figure = sp.make_subplots(
        rows=len(tools),
        cols=1,
        subplot_titles=tools
    )

    for tool_id in range(len(tools)):
        figure.add_trace(
            go.Bar(
                x=[x for (x, y) in data[tool_id]],
                y=[y for (x, y) in data[tool_id]]
            ),
            row=tool_id + 1,
            col=1
        )

    figure.update_layout(title_text=title, showlegend=False)

    print(figure.to_html())

def graph_locus(locus):
    title = f'Effectif pour chaque nombre de répétitions au locus {locus}'
    data = []
    with open(f'{output_directory}{os.sep}{locus}.tsv') as result_file:
        tsvreader = csv.reader(result_file, delimiter='\t')
        try:
            tools = next(tsvreader)[1:]
            counters = [collections.Counter({0: 0}) for tool in tools]
            for row in tsvreader:
                for tool_id in range(len(tools)):
                    if row[tool_id + 1] not in ['.', 'nofile']:
                        for count in row[tool_id + 1].split(','):
                            counters[tool_id][int(count)] += 1
        except StopIteration:
            print('Input file is empty', file=sys.stderr)
            sys.exit(1)
        for tool_id in range(len(tools)):
            data.append(sorted(counters[tool_id].items()))
        #display_console_graph(title, tools, data)
        display_html_graph(title, tools, data)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f'Usage: {sys.argv[0].split(os.sep)[-1]} <LOCUS>', file=sys.stderr)
        sys.exit(1)
    graph_locus(sys.argv[1])
