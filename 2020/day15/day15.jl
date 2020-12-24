function solve(line::Vector{Int}, iterations::Int)
    N = length(line)
    spoken_time = Dict(line[i] => i for i in 1:N-1 )
    last_number = line[end]

    for i in N:iterations-1
        temp_num = if last_number in keys(spoken_time)
            i - spoken_time[last_number]
        else
            0
        end
        spoken_time[last_number] = i
        last_number = temp_num
    end

    return last_number
end

function main(filename::String)
    lines = readlines(filename) |>
        x->split.(x, ',') |> x->map.(f->parse(Int64,f), x)

    for line in lines
        println("Part1: ", solve(line, 2020))
        println("Part2: ", solve(line, 30000000))
    end


end
