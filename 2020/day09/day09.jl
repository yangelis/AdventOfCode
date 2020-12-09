function part1(lines::Vector{Int64}; n::Int64=5)
    numbers = copy(lines)
    preamble = splice!(numbers, 1:n)

    for (i, num) in enumerate(numbers)
        ii = 0
        for j in 1:length(preamble), k in length(preamble):-1:1
            if preamble[j] + preamble[k] == num
                ii = 1
            end
        end

        if ii != 0
            splice!(preamble, 1)
            push!(preamble, num)
        else
            return (i+n, num)
        end
    end
end


function part2(lines::Vector{Int64}, looking)
    numbers = copy(lines)
    index, num = looking
    preamble = splice!(numbers, 1:index)

    for i in 1:index-1
        for j in i+1:index
            if sum(preamble[i:j]) == num
                return sum(extrema(preamble[i:j]))
            end
        end
    end
end

function main(filename::String)
    lines = readlines(filename) |> x->map(f->parse(Int64, f), x)

    n = 25
    if filename == "example.txt"
        n = 5
    end


    solution = NamedTuple{(:index, :number)}(part1(lines,n=n))
    println("Part1: ", solution.number)
    println("Part2: ", part2(lines, solution))


end
