const FLOOR = '.'
const EMPTY = 'L'
const SEAT  = '#'
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

@inline function model!(new_layout::Matrix{Char}, old_layout::Matrix{Char})
    h, w = size(old_layout)
    for i in 2:h - 1
        for j in 2:w - 1
            if old_layout[i,j] == EMPTY
                counter = 0
                for index in adjacent_indices
                    if old_layout[i + index[1], j + index[2]] != SEAT
                        counter += 1
                    end
                end

                if counter == 8
                    new_layout[i,j] = SEAT
                end
            elseif old_layout[i,j] == SEAT
                counter = 0
                for index in adjacent_indices
                    if old_layout[i + index[1], j + index[2]] == SEAT
                        counter += 1
                    end
                end

                if counter >= 4
                    new_layout[i,j] = EMPTY
                end
            elseif old_layout[i,j] == FLOOR
                continue
            end
        end
    end
end

function part1(old_layout::Matrix{Char})
    new_layout = copy(old_layout)
    model!(new_layout, old_layout)
    while new_layout != old_layout
        old_layout = copy(new_layout)
        model!(new_layout, old_layout)
    end
    return filter(x -> x == '#', new_layout) |> length
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

    println("Part1: ", part1(layout))

end
