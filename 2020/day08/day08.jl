
mutable struct Operation
    name::String
    arg::Int64
    visited::Bool

    Operation(n::String, i::Int64) = new(n,i,false)
end

function parse_instructions(file)
    instructions = Vector{Operation}(undef, length(file))

    op::String = ""
    arg::Int64 = 999
    for i in 1:length(file)
        parts = split(file[i],' ')
        op = parts[1]
        arg = parse(Int64, parts[2])
        instructions[i] = Operation(op, arg)
    end

    return instructions
end

function part1(ins::Vector{Operation})
    counter::Int64 = 0
    i::Int64 = 1
    while !ins[i].visited
        if ins[i].name == "acc"
            ins[i].visited = true
            counter += ins[i].arg
            i += 1
        elseif ins[i].name == "jmp"
            ins[i].visited = true
            i += ins[i].arg
        elseif ins[i].name == "nop"
            ins[i].visited = true
            i += 1
        end
    end
    return counter
end

function main(filename::String)
    file = readlines(filename)
    instructions = parse_instructions(file)

    println("Part1: ", part1(instructions))

end
