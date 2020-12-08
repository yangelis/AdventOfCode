
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

function part2(ins::Vector{Operation}, change::Int64 = 1)
    counter::Int64 = 0
    i::Int64 = 1
    nops_jmp = Dict{Int64, String}()
    while !ins[i].visited
        if ins[i].name == "acc"
            ins[i].visited = true
            counter += ins[i].arg
            i += 1
        elseif ins[i].name == "jmp"
            ins[i].visited = true
            nops_jmp[i] = "jmp"
            i += ins[i].arg
        elseif ins[i].name == "nop"
            ins[i].visited = true
            nops_jmp[i] = "nop"
            i += 1
        end
    end
    return counter, nops_jmp
end

function loop(ins, choises::Dict{Int64, String})
    ans = Vector{Int64}()
    for (key, val) in choises
        counter = 0
        matters = true
        i::Int64 = 1
        ins_copy = deepcopy(ins)

        if ins_copy[key].name == "nop"
            ins_copy[key].name = "jmp"
        elseif ins_copy[key].name == "jmp"
            ins_copy[key].name = "nop"
        end

        while i <= length(ins_copy)
            if ins_copy[i].visited
                matters = false
                break
            end
            ins_copy[i].visited = true
            if ins_copy[i].name == "acc"
                counter += ins_copy[i].arg
                i += 1
            elseif ins_copy[i].name == "jmp"
                i += ins_copy[i].arg
            elseif ins_copy[i].name == "nop"
                i += 1
            end
        end
        if matters
            push!(ans, counter)
        end
    end
    return ans
end

function main(filename::String)
    file = readlines(filename)
    instructions = parse_instructions(file)

    println("Part1: ", part1(instructions))
    foreach(x->x.visited = false, instructions)
    a = part2(instructions)
    foreach(x->x.visited = false, instructions)
    # println(a)
    # choise = a[2][5]
    # instructions[choise].name == "nop" ? instructions[choise]name = "jmp" : instructions[choise].name = "nop"

    println("Part2: ", loop(instructions, a[2]))
end
