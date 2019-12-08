#! /bin/sh

samtools sort -n -@64 --check=quiet -T sortbyread  /work/gad/shared/analyse/STR/Data/dijen017/lobSTR/2019-11-26  -o /work/gad/shared/analyse/STR/Data/dijen017/lobSTR/2019-11-26/dijen017.sorted.bam /work/gad/shared/analyse/STR/Data/dijen017/lobSTR/dijen017.bam
