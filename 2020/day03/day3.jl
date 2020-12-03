const Tree = '#'

function part1(m::Matrix{Char})
    i, j = 1, 0
    h, w = size(m)
    tree_counter::Int64 = 0


    while i <= h
        position = m[i, j%w + 1]
        if position == Tree
            tree_counter += 1
        end
        i += 1
        j += 3
    end

    return tree_counter
end


function part2(m::Matrix{Char}, directions)
    i, j = 1, 0
    jstep, istep = directions
    h, w = size(m)
    tree_counter::Int64 = 0


    while i <= h
        position = m[i, j%w + 1]
        if position == Tree
            tree_counter += 1
        end
        i += istep
        j += jstep
    end

    return tree_counter
end
function print_map(m)
    w, h = size(m)
    for i in 1:h
        for j in 1:w
            print(m[i,j])
        end
        println()
    end
end




function main(filename::String)
    lines = readlines(filename)
    h = length(lines)
    w = length(lines[1])
    map = Matrix{Char}(undef, h, w)
    for i in 1:h, j in 1:w
        map[i,j] = lines[i][j]
    end

    # print_map(map)
    println("Part1: ", part1(map))

    directions = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    mult::Int64 = 1
    for direction in directions
        trees = part2(map, direction)
        mult *= trees
        println("Directions: ", direction, " with trees: ", trees)
    end
    println("Part2: ", mult)

end
