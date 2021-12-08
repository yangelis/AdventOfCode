function part1(filename::String)
    sum(map(y->count(x->length(x) in [2,4,3,7], y),split.(map(x->x[2], split.(readlines(filename), " | ")), ' ')))
end

function main(filename::String)
    println("Part1: ", part1(filename))
end
