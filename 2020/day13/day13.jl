function part1(timestamp, ids)
    initial_timestamp = timestamp

    while true
        index = map(x->timestamp % x, ids) |> f->findfirst(x->x==0, f)

        if index === nothing
            timestamp += 1
        else
            println((timestamp, ids[index]))
            return ids[index] * (timestamp-initial_timestamp)
        end

    end
end

function main(filename::String)
    lines = readlines(filename)
    timestamp = lines[1] |> x->parse(Int64,x)
    ids = lines[2] |>
        x->split(x,',') |>
        l->filter(x->x!="x",l) |>
        x->parse.(Int64, x)


    println("Part1: ", part1(timestamp, ids))
end
