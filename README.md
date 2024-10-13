# Fasta-splitter
 Julia script to separe FASTA files sequences in new FASTAs.

> [!NOTE]
> Compiling in linux will generate bin files to run on linux;
> Compiling on windows will generate .exe file.

## Compiling 
Using `julia` terminal run the following code

```julia
using PackageCompiler

## Firstime running
create_app("FastaSplitter/","/path/of/compile/folder")

## In case of some erros you could try (force make to overwritten previous compiled files):
# create_app("FastaSplitter/","/path/of/compile/folder"; cpu_target="generic", force=true)
```
