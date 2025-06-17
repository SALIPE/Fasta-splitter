#!/bin/bash


LOC=~/Desktop/Fasta-splitter/FastaSplitter

cd $LOC && julia --project src/FastaSplitter.jl --directory $1 balance-dataset


