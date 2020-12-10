





function part1(adapters::Vector{Int64})
    sort!(adapters)

    last_adapter = adapters[end] + 3
    push!(adapters, last_adapter)

    ones=0
    threes=0
    i = 1

    init_jolt = 0

    while i <= length(adapters)

        if (adapters[i] - init_jolt) == 3
            init_jolt = adapters[i]
            threes += 1
        elseif (adapters[i] - init_jolt) == 1
            init_jolt = adapters[i]
            ones += 1
        end
        i += 1

    end
    println(ones, ", ", threes)
    return ones * threes
end









function main(filename::String)
    lines = readlines(filename) |> x->map(f->parse(Int64, f), x)

    println("Part1: ", part1(lines))

end
