function parse_input(f)
    a = readlines(f)
    b = map.(x -> parse.(Int64, x), split.(a, "   "))
    b = transpose(reduce(hcat, b))
    return b
end


function part1(x)
    npairs = size(x)[1]

    sorted_left = sort(x[:, 1])
    sorted_right = sort(x[:, 2])

    total = 0

    for i in 1:npairs
        total += abs(sorted_right[i] - sorted_left[i])
    end

    return total
end


function part2(x)
    npairs = size(x)[1]

    sorted_left = sort(x[:, 1])
    sorted_right = sort(x[:, 2])
    total = 0

    for i in 1:npairs
        zero_counts = 0
        for j in 1:npairs
            if abs(sorted_right[j] - sorted_left[i]) == 0
                zero_counts += 1
            end
        end
        total += sorted_left[i] * zero_counts
    end
    return total
end


function main()
    x = parse_input("input.txt")
    println("Part1: ", part1(x))
    println("Part2: ", part2(x))
end
