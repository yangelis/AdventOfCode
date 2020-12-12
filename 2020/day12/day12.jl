@inline function turns(unit::Int64)
    return Int64(unit / 90)
end


mutable struct Pos
    x::Int64
    y::Int64
end

@inline function manhattan_dist(pos::Pos)
    return abs(pos.x) + abs(pos.y)
end

const mapping = Dict{Int64, Int64}(1=>1, 3=>-1, 4=>1, 2=>-1)
function part1(instructions)

    pos = Pos(0,0)
    current_direction = 1
    for (dir, unit) in instructions
        if dir == 'L'
            current_direction = mod1(current_direction - turns(unit), 4)
        elseif dir == 'R'
            current_direction = mod1(current_direction + turns(unit), 4)
        elseif dir == 'F'
            if current_direction == 1 || current_direction == 3
                pos.x += mapping[current_direction] * unit
            else
                pos.y += mapping[current_direction] * unit
            end
        elseif dir == 'E'
            pos.x += unit
        elseif dir == 'W'
            pos.x -= unit
        elseif dir == 'N'
            pos.y += unit
        elseif dir == 'S'
            pos.y -= unit
        end
    end

    manhattan_dist(pos)
end


function part2(instructions)
    ship = Pos(0,0)
    waypoint = Pos(10, 1)
    for (dir, unit) in instructions
        if dir == 'L'
            # TODO: fix me
            for i in 1:(unit ÷ 90)
                waypoint = Pos(-waypoint.y, waypoint.x )
            end
        elseif dir == 'R'
            for i in 1:(unit ÷ 90)
                waypoint = Pos(waypoint.y, -waypoint.x )
            end
        elseif dir == 'F'
            ship.x += waypoint.x * unit
            ship.y += waypoint.y * unit
        elseif dir == 'E'
            waypoint.x += unit
        elseif dir == 'W'
            waypoint.x -= unit
        elseif dir == 'N'
            waypoint.y += unit
        elseif dir == 'S'
            waypoint.y -= unit
        end

        println(ship, ",", waypoint)
    end
    manhattan_dist(ship)
end

function main(filename::String)
    lines = readlines(filename)
    instructions = Vector{NamedTuple{(:dir, :unit),
                                     Tuple{Char,Int64}}}(undef, length(lines))

    for (i, line) in enumerate(lines)
        instructions[i] = (dir = line[1], unit = parse(Int64, line[2:end]))
    end
    println("Part1: ", part1(instructions))
    println("Part2: ", part2(instructions))
end
