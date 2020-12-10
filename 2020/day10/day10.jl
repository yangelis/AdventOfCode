function part1(adapters::Vector{Int64})
    ones = 0
    threes = 0
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

function part2(adapters::Vector{Int64})
    N = length(adapters)
    c = zeros(Int64, N)
    c[1] = 1

    for i = 1:N, j = i+1:N
        if (adapters[j] - adapters[i]) <= 3
            c[j] += c[i]
        end
    end
    return c[end]
end

function main(filename::String)
    lines = readlines(filename) |> x->map(f->parse(Int64, f), x) |>
        x->sort!(x) |> x->pushfirst!(x, 0) |> x->push!(x, x[end]+3)

    println("Part1: ", part1(lines))
    println("Part2: ", part2(lines))
end
