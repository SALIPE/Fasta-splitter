#!/bin/bash

DIR=~/Desktop/datasets/denv_eq

julia --project src/FastaSplitter.jl --directory $DIR balance-dataset