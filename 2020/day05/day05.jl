const ROWS = 127
const COLS = 7

struct Plane
    row::Vector{Int64}
    col::Vector{Int64}
    id::Vector{Int64}
    Plane(passengers::Int64) = new(Vector{Int64}(undef, passengers),
                                   Vector{Int64}(undef, passengers),
                                   Vector{Int64}(undef, passengers))
end

Base.getindex(plane::Plane, n) = ( plane.row[n], plane.col[n], plane.id[n] )

function print_seat(r,c,id)
    println("Row: $r, col: $c, id: $id")
end

function get_id(r::Int64, c::Int64)
    return r * 8 + c
end

function get_row_col(encoding::String, debug::Bool = false)
    row_range = (0, ROWS)
    col_range = (0, COLS)

    debug ? println("[DBG]: ", encoding) : nothing
    debug ? println("[DBG]: ", row_range) : nothing
    for char in encoding[1:7]
        if char == 'F'
            row_range = (row_range[1], (row_range[1] + row_range[2]) ÷ 2)
        elseif char == 'B'
            row_range = ((row_range[1] + row_range[2]) ÷ 2 + 1, row_range[2])
        end
        debug ? println("[DBG]: ", row_range) : nothing
    end

    debug ? println("[DBG]: ", col_range) : nothing
    for char in encoding[8:end]
        if char == 'L'
            col_range = (col_range[1], (col_range[1] + col_range[2]) ÷ 2)
        elseif char == 'R'
            col_range = ((col_range[1] + col_range[2]) ÷ 2 + 1, col_range[2])
        end
        debug ? println("[DBG]: ", col_range) : nothing
    end

    debug ? println("[DBG]: ", "range :", (row_range[1], col_range[1])) : nothing
    return (row_range[1], col_range[1])
end

function main(filename::String)
    lines = readlines(filename)
    n_lines = length(lines)
    println("Read ", n_lines, "  lines")

    seats = Plane(n_lines)

    for i in 1:n_lines
        r, c = get_row_col(lines[i], false)
        seats.row[i] = r
        seats.col[i] = c
        seats.id[i] = get_id(r,c)
        # println(seats[i])
    end
    # println(length(seats.id))
    # println(length(unique(seats.id)))
    println("Part1: ", maximum(seats.id))

    rn = minimum(seats.id):maximum(seats.id)
    my_seat = filter(x -> !(x in seats.id), rn)[1]
    println("Part2: ", my_seat)
end
