#!/bin/bash

LOC=~/Desktop/Fasta-splitter/FastaSplitter
DIR=$1

rm -r $DIR/train
rm -r $DIR/test

cd $LOC && julia --project src/FastaSplitter.jl --directory $DIR balance-dataset


