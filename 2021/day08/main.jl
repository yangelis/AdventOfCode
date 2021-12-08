function part1(filename::String)
    sum(map(y->count(x->length(x) in [2,4,3,7], y),split.(map(x->x[2], split.(readlines(filename), " | ")), ' ')))
end

function part2(filename::String)
    lines = split.(readlines(filename), " | ")

    count = 0

    for line in lines
        signals = map(x-> (Set(x),length(x)), split(line[1], ' '))
        digits = map(x->Set(x), split(line[2], ' '))

        d = Dict{Int, Set{Char}}()
        for s in signals
            if s[2] == 2
                d[1] = s[1]
            elseif s[2] == 4
                d[4] = s[1]
            elseif s[2] == 3
                d[7] = s[1]
            elseif s[2] == 7
                d[8] = s[1]
            end
        end

        d2 = Dict(v=>i for (i,v) in d )

        for s in signals
            if haskey(d2, s[1])
                continue
            end

            if s[2] == 5
                if haskey(d, 1) && length(intersect(s[1], d[1])) == 2
                    d2[s[1]] = 3
                elseif haskey(d, 1) && length(intersect(s[1], d[4])) == 3
                    d2[s[1]] = 5
                else
                    d2[s[1]] = 2
                end
            else
                if haskey(d, 4) && length(intersect(s[1], d[4])) == 4
                    d2[s[1]] = 9
                elseif haskey(d, 7) && length(intersect(s[1], d[7])) == 2
                    d2[s[1]] = 6
                else
                    d2[s[1]] = 0
                end

            end
        end

        count += 1000 * d2[digits[1]]
        count += 100 * d2[digits[2]]
        count += 10 * d2[digits[3]]
        count +=  d2[digits[4]]
    end
    count
end

function main(filename::String)
    println("Part1: ", part1(filename))
    println("Part2: ", part2(filename))
end
