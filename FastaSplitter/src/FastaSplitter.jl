module FastaSplitter
using FASTX, ArgParse, TerminalMenus, Random

export FastaSplitter

function getSequencesFromFastaFile(
    filePath::String
)::Array{FASTX.FASTA.Record}
    sequences::Array{FASTX.FASTA.Record} = []
    for record in open(FASTAReader, filePath)
        push!(sequences, record)
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

function splitDataset(
    dirPath::String
)

    try
        rm("$dirPath/train", recursive=true)
        rm("$dirPath/test", recursive=true)
    catch
        @error "Non directory to remove"
    end
    ratio = 0.7
    variantDirs::Vector{String} = readdir(dirPath)


    dataset = Dict{String,Int}()

    @inbounds for i in eachindex(variantDirs)
        variant::String = variantDirs[i]
        @info "Collecting $variant"
        for record in open(FASTAReader, "$dirPath/$variant/$variant.fasta")
            if haskey(dataset, variant)
                dataset[variant] += 1
            else
                dataset[variant] = 1
            end
        end
    end

    minAmount = argmin(dataset)
    @info "Min Sequence Amount $minAmount - $(dataset[minAmount])"

    train_size::Int = ceil(dataset[minAmount] * ratio)
    test_size::Int = dataset[minAmount] - train_size

    mkpath("$dirPath/train")
    mkpath("$dirPath/test")
    for (key, _) in dataset
        @info "Exporting file: $key"
        sequences = getSequencesFromFastaFile("$dirPath/$key/$key.fasta")

        shuffle!(sequences)

        FASTAWriter(
            open("$dirPath/train/$(key).fasta", "w")
        ) do writer
            for record in sequences[1:train_size]
                write(writer, record)
            end
        end

        FASTAWriter(
            open("$dirPath/test/$(key).fasta", "w")
        ) do writer
            for record in sequences[train_size+1:end]
                write(writer, record)
            end
        end
    end



end


function julia_main()::Cint
    setting = ArgParseSettings()
    @add_arg_table! setting begin
        "balance-dataset"
        action = :command
        help = "Create balanced dataset"
        "split-file"
        action = :command
        help = "Split FASTA file"
        "-d", "--directory"
        help = "Dataset directory"
        required = false
        "-f", "--file"
        help = "FASTA file to read"
        required = false
        "-o", "--output"
        help = "Output filename"
        required = false
    end


    parsed_args = parse_args(ARGS, setting)
    dirPath::Union{Nothing,AbstractString} = parsed_args["directory"]

    if parsed_args["%COMMAND%"] == "balance-dataset"
        splitDataset(dirPath)
        return 0
    end

    filePath::AbstractString = parsed_args["file"]
    output::String = "output.fasta"
    if (!isnothing(parsed_args["output"]))
        output = parsed_args["output"]
    end


    # sequences = getSequencesFromFastaFile(filePath)

    # options::Vector{String} = map(
    #     x::FASTX.FASTA.Record -> identifier(x),
    #     sequences)

    variants::Vector{String} = ["Alpha", "Beta", "Delta", "Epsilon", "Eta", "Gamma", "Iota", "Kappa", "Lambda", "Omicron"]

    for var in variants
        FASTAWriter(open("$var.fasta", "w")) do writer
            for record in open(FASTAReader, filePath)
                if (contains(identifier(record), var))
                    write(writer, record)
                end
            end
        end
    end

    # menu = MultiSelectMenu(options, pagesize=10)

    # # `request` returns a `Set` of selected indices
    # # if the menu us canceled (ctrl-c or q), return an empty set
    # choices = request("Select the sequences to extract:", menu)

    # if length(choices) > 0
    #     println("Selected Sequeces:")
    #     selectedOptions = sort!(collect(choices))
    #     for i in selectedOptions
    #         println("  - ", options[i])
    #     end
    #     selected = sequences[selectedOptions]
    #     size::Int = length(selected)

    #     @info "Exporting file: $output"

    #     progressBar!(0, size)
    #     FASTAWriter(open(output, "w")) do writer
    #         for (ii, record) in enumerate(selected)
    #             write(writer, record)
    #             progressBar!(ii, size)
    #         end
    #     end
    # else
    #     println("Menu canceled.")
    # end
    return 0
end

end # module FastaSplitter

FastaSplitter.julia_main()

