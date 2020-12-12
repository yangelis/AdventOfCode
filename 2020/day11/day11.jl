const FLOOR = '.'
const SEAT = 'L'
const OCCUPIED  = '#'
const PAD  = '0'

function print_layout(m)
    h, w = size(m)
    println('-'^50)
    for i in 2:h - 1
        for j in 2:w - 1
            print(m[i,j])
        end
        println()
    end
    println('-'^50)
end

function print_paded_layout(m)
    h, w = size(m)
    println('-'^50)
    for i in 1:h
        for j in 1:w
            print(m[i,j])
        end
        println()
    end
    println('-'^50)
end


adjacent_indices = [(-1, -1), (1, 1),
                    (0, -1), (0, 1),
                    (-1, 0), (1, 0),
                    (-1, 1), (1, -1)]

function neighboors_part1(layout::Matrix{Char},i,j)
    count(x-> x==OCCUPIED, [layout[i + index[1], j + index[2]] for index in adjacent_indices])
end

function model1!(new_layout::Matrix{Char}, old_layout::Matrix{Char})
    h, w = size(old_layout)
    @inbounds for i in 2:h - 1
        @inbounds for j in 2:w - 1
            count_line = neighboors_part1(old_layout, i, j)
            if old_layout[i,j] == SEAT && count_line == 0
                new_layout[i,j] = OCCUPIED
            elseif old_layout[i,j] == OCCUPIED && count_line >= 4
                new_layout[i,j] = SEAT
            end
        end
    end
    return new_layout
end

function neighboors_part2(layout::Matrix{Char},i,j)
    counter = 0
    for index in adjacent_indices
        ii = i + index[1]
        jj = j + index[2]

        while layout[ii, jj] == FLOOR
            ii += index[1]
            jj += index[2]
        end

        if layout[ii, jj] == OCCUPIED
            counter += 1
        end

    end
    return counter
end

@inline function model2!(new_layout::Matrix{Char}, old_layout::Matrix{Char})
    h, w = size(old_layout)
    @inbounds for i in 2:h - 1
        @inbounds for j in 2:w - 1
            count_line = neighboors_part2(old_layout, i, j)
            if old_layout[i,j] == SEAT && count_line == 0
                new_layout[i,j] = OCCUPIED
            elseif old_layout[i,j] == OCCUPIED && count_line >= 5
                new_layout[i,j] = SEAT
            end
        end
    end
    return new_layout
end

function run(new_layout::Matrix{Char},old_layout::Matrix{Char}, model!)
    while true
        model!(new_layout, old_layout)
        if new_layout == old_layout
            break
        end

        old_layout = copy(new_layout)
    end
    return count(x -> x == '#', new_layout)
end

function main(filename::String)
    lines = readlines(filename)
    h = length(lines) + 2
    w = length(lines[1]) + 2
    layout = Matrix{Char}(undef, h, w)
    for i in 2:h - 1, j in 2:w - 1
        layout[i,j] = lines[i - 1][j - 1]
    end

    layout[1,:] .= PAD
    layout[:,1] .= PAD
    layout[end,:] .= PAD
    layout[:,end] .= PAD


    new_layout = copy(layout)
    println("Part1: ", run(new_layout, layout, model1!))
    println("Part2: ", run(new_layout, layout, model2!))
end
