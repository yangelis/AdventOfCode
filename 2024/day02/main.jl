function parse_input(f)
    a = readlines(f)
    b = map.(x -> parse.(Int64, x), split.(a))
    return b
end


function issafe(x)
    for (a, b) in zip(x, x[2:end])
        if !(1 <= (b - a) <= 3)
            return false
        end
    end
    return true
end

function part1(reports)
    count = 0
    for report in reports
        if issafe(report) || issafe(reverse(report))
            count += 1
        end
    end
    return count
end


function part2(x)

end


function main()
    x = parse_input("input.txt")
    println("Part1: ", part1(x))
    println("Part2: ", part2(x))
end
