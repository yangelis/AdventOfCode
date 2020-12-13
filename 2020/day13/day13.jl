# almost crt
function chineseremainder(ni::Array, ci::Array)
    N = BigInt(prod(ni))
    Ni = map(x->N÷x, ni)
    di = map(x->invmod(x[1], x[2]), zip(Ni, ni))
    mod(sum(ci[i] * di[i] * Ni[i] for i in 1:length(ni)), N)
    mod(reduce(-, ci[i] * di[i] * Ni[i] for i in 1:length(ni)), N)
end

function part2(buses)
    position = findall(x->x!=nothing, tryparse.(Int, split(buses, ","))) .- 1
    ids = buses |>
        x->split(x,',') |>
        l->filter(x->x!="x",l) |>
        x->parse.(Int64, x)

    chineseremainder(ids, position)
end


function part1(timestamp, buses)
    ids = buses |>
        x->split(x,',') |>
        l->filter(x->x!="x",l) |>
        x->parse.(Int64, x)

    initial_timestamp = timestamp

    while true
        index = map(x->timestamp % x, ids) |> f->findfirst(x->x==0, f)

        if index === nothing
            timestamp += 1
        else
            # println((timestamp, ids[index]))
            return ids[index] * (timestamp-initial_timestamp)
        end

    end
end

function main(filename::String)
    lines = readlines(filename)
    timestamp = lines[1] |> x->parse(Int64,x)


    println("Part1: ", part1(timestamp, lines[2]))
    println("Part2: ", part2(lines[2]))
end
