function part1(lines)
    sum([length(unique(filter(x -> x!='\n' , l))) for l in lines])
end

function part2(lines)
    result = 0
    for line in lines
        g1 = split(line, '\n')
        chars = Set(g1[1])
        for i in 1:length(g1)
            temp = Set(g1[i])
            intersect!(chars,temp)
        end
        result += length(chars)
    end
    return result
end

function pipePart1(filename)
    readlines(filename, keep=true) |> join |> x->split(x, "\n\n") |>
        f->map(x->filter(y->y!='\n', x), f) |>
        f->map(x->unique(x), f) |>
        f->map(x->length(x), f) |>
        sum |> f->println("Part1: ",f)
end

function main(filename::String)
    lines = ""
    file = readlines(filename, keep=true) |> join
    lines = split(file, "\n\n")
    lines[end] = chomp(lines[end])

    pipePart1(filename)
    println("Part1: ", part1(lines))

    println("Part2: ", part2(lines))
end
