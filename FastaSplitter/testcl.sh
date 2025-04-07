#!/bin/bash

DIR=/tmp2/felipe/sars_cov2

LOC=/home/a61491/Fasta-splitter/FastaSplitter

cd $LOC && julia --project src/FastaSplitter.jl --directory $DIR balance-dataset


