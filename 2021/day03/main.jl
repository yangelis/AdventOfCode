function tobitstring(x)::String
    n = length(x)
    chars = Vector{Char}(undef, n)

    for i in 1:n
        chars[i] = string(Int(x[i]))[1]
    end

    return String(chars)
end

function part1(grid::Matrix{Int})::Int
    g = grid'
    ones_per_col = count(==(1), g, dims=1)
    zeros_per_col = count(==(0), g, dims=1)

    gr = ones_per_col .> zeros_per_col
    er = map(!, gr)

    gamma_rate = parse(Int, tobitstring(gr); base=2)
    epsilon_rate = parse(Int, tobitstring(er); base=2)

    return gamma_rate * epsilon_rate
end

function part2(grid::Matrix{Int})
    g = grid'
    g1 = deepcopy(g)

    m, n = size(g)

    indices = Dict(i => i for i=1:m)

    cmp = -1
    for i in 1:n
        ones_per_col = count(==(1), g1, dims=1)
        zeros_per_col = count(==(0), g1, dims=1)
        if ones_per_col[i] >= zeros_per_col[i]
            cmp = 1
        elseif ones_per_col[i] < zeros_per_col[i]
            cmp = 0
        end

        for j in keys(indices)
            if cmp != g1[j, i]
                g1[j, :] .= -1
                if length(indices) == 1
                    break
                end
                delete!(indices, j)
            end
        end
    end
    o2_id = collect(values(indices))

    o2_rate = parse(Int64, tobitstring(g[o2_id,:]); base=2)
    # println("o2_rate: ", o2_rate)

    g2 = deepcopy(g)
    indices = Dict(i => i for i=1:m)

    cmp = -1
    for i in 1:n
        ones_per_col = count(==(1), g2, dims=1)
        zeros_per_col = count(==(0), g2, dims=1)
        if ones_per_col[i] < zeros_per_col[i]
            cmp = 1
        elseif ones_per_col[i] >= zeros_per_col[i]
            cmp = 0
        end

        for j in keys(indices)
            if cmp != g2[j, i]
                g2[j, :] .= -1
                if length(indices) == 1
                    break
                end
                delete!(indices, j)
            end
        end
    end
    co2_id = collect(values(indices))
    co2_rate = parse(Int64, tobitstring(g[co2_id,:]); base=2)
    # println("co2_rate: ", co2_rate)

    return o2_rate * co2_rate
end

function main(filename::String)
    number_grid = reduce(hcat, map(x->map(y->parse(Int, y),
                                          collect(x)), readlines(filename)))
    println("Part1: ", part1(number_grid))
    println("Part2: ", part2(number_grid))
end
