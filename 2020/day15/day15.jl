function part1(line::Vector{Int})
    # println(line)
    N = length(line)
    spoken_time = Dict(line[i] => i for i in 1:N )
    counters = Dict(i => 1 for i in line)

    last_number = line[end]
    for i in (N+1):2020
        temp_num = if counters[last_number] == 1
            0
        else
            (i - 1) - spoken_time[last_number]
        end

        spoken_time[last_number] = i - 1
        counters[temp_num] = get(counters, temp_num, 0) + 1

        last_number = temp_num
    end

    return last_number
end




function main(filename::String)
    lines = readlines(filename) |>
        x->split.(x, ',') |> x->map.(f->parse(Int64,f), x)

    for line in lines
        println("Part1: ", part1(line))
    end


end
