module FastaSplitter
using FASTX, ArgParse, TerminalMenus

export FastaSplitter

function getSequencesFromFastaFile(
    filePath::String
)::Array{FASTX.FASTA.Record}
    sequences::Array{FASTX.FASTA.Record} = []
    for record in open(FASTAReader, filePath)
        push!(sequences, record)
        # push!(sequences, codeunits(sequence(record)))
        # println(identifier(record))
        # println(sequence(record))
        # println(description(record))
    end
    return sequences
end

function progressBar!(current::Int, total::Int; width::Int=50)
    progress = current / total
    complete_width = Int(round(progress * width))
    incomplete_width = width - complete_width
    bar = "[" * "="^complete_width * "-"^incomplete_width * "]"

    percentage = Int(round(progress * 100))

    print("\r", bar, " ", percentage, "%")

    flush(stdout)
end


function julia_main()::Cint
    setting = ArgParseSettings()
    @add_arg_table! setting begin
        "-f", "--file"
        help = "FASTA file to read"
    end


    parsedArgs = parse_args(ARGS, setting)

    filePath::AbstractString = parsedArgs["file"]

    sequences = getSequencesFromFastaFile(filePath)

    options::Vector{String} = map(
        x::FASTX.FASTA.Record -> identifier(x),
        sequences)

    menu = MultiSelectMenu(options, pagesize=10)

    # `request` returns a `Set` of selected indices
    # if the menu us canceled (ctrl-c or q), return an empty set
    choices = request("Select the sequences to extract:", menu)

    if length(choices) > 0
        println("Selected Sequeces:")
        for i in choices
            println("  - ", options[i])
        end
        selected = sequences[sort!(collect(choices))]

        @show selected
        file = "output.fasta"
        println("\nExporting file: $file")
        FASTAWriter(open(file, "w")) do writer
            for record in selected
                write(writer, record)
            end
        end
    else
        println("Menu canceled.")
    end
    return 0
end

end # module FastaSplitter

