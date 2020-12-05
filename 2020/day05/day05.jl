const ROWS = 128
const COLS = 8

struct Plane
    row::Vector{Int64}
    col::Vector{Int64}
    id::Vector{Int64}
    Plane(passengers::Int64) = new(Vector{Int64}(undef, passengers),
                                   Vector{Int64}(undef, passengers),
                                   Vector{Int64}(undef, passengers))
end

function print_seat(r,c,id)
    println("Row: $r, col: $c, id: $id")
end

function get_id(r::Int64, c::Int64)
    return r * 8 + c
end

function get_row_col(encoding::String)
    row_range = (1, ROWS)
    col_range = (1, COLS)

    for char in encoding[1:7]
        if char == 'F'
            row_range = ( row_range[1], (row_range[1] + row_range[2]) ÷ 2 )
        elseif char == 'B'
            row_range = ( (row_range[1] + row_range[2]) ÷ 2, row_range[2] )
        end
    end

    for char in encoding[8:end]
        if char == 'L'
            col_range = ( col_range[1], (col_range[1] + col_range[2]) ÷ 2 )
        elseif char == 'R'
            col_range = ( (col_range[1] + col_range[2]) ÷ 2, col_range[2] )
        end
    end

    return (row_range[1],col_range[1])
end

function main(filename::String)
    lines = readlines(filename)
    n_lines = length(lines)
    println("Read ", n_lines, "  lines")

    seats = Plane(n_lines)

    for i in 1:n_lines
        r, c = get_row_col(lines[i])
        seats.row[i] = r
        seats.col[i] = c
        seats.id[i] = get_id(r,c)
        # print_seat(seats.row[i], seats.col[i], seats.id[i])
    end
    println("Part1: ", maximum(seats.id))
end
