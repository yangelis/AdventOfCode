# using Plots
# using Printf

mutable struct Pos
    x :: Int
    y :: Int
end

struct Line
    start :: Pos
    stop :: Pos
end

function find_grid_size(segments::Vector{Line})
    max_x = 0
    max_y = 0

    for s in segments
        if s.start.x > max_x
            max_x = s.start.x
        end
        if s.stop.x > max_x
            max_x = s.stop.x
        end

        if s.start.y > max_y
            max_y = s.start.y
        end
        if s.stop.y > max_y
            max_y = s.stop.y
        end
    end

    return (max_x + 1, max_y + 1)
end

function parsepositions(lines::Vector{String})

    segments = Vector{Line}(undef, length(lines))
    for (i, line) in enumerate(lines)
        spaces = findall(isequal(' '), line)
        commas = findall(isequal(','), line)
        x1, y1 = parse(Int, line[1:commas[1]-1]), parse(Int, line[commas[1]+1:spaces[1]-1])
        x2, y2 = parse(Int, line[spaces[2]+1:commas[2]-1]), parse(Int, line[commas[2]+1:end])
        segments[i] = Line(Pos(x1, y1), Pos(x2, y2))
    end
    return segments
end

function part1(grid_size, segments::Vector{Line})
    grid = zeros(Int, grid_size)
    i = 1
    for s in segments
        changed = false
        if s.start.x == s.stop.x
            y1, y2 = minmax(s.start.y, s.stop.y) .+ 1
            @. grid[y1:y2,s.start.x + 1] += 1
            changed = true
        elseif s.start.y == s.stop.y
            x1, x2 = minmax(s.start.x, s.stop.x) .+ 1
            @. grid[s.start.y + 1, x1:x2] += 1
            changed = true
        end

        # if changed
        #     heatmap(grid, yflip=true, background_color = RGB(0.2, 0.2, 0.2), size=(640, 480), show=false);
        #     name = @sprintf "figs/part1/output%03d.png" i
        #     savefig(name);
        #     i += 1
        # end
    end

    count(>(1), grid)
end

function part2(grid_size, segments::Vector{Line})
    grid = zeros(Int, grid_size)
    i = 1
    for s in segments
        if s.start.x == s.stop.x
            y1, y2 = minmax(s.start.y, s.stop.y) .+ 1
            @. grid[y1:y2,s.start.x + 1] += 1
        elseif s.start.y == s.stop.y
            x1, x2 = minmax(s.start.x, s.stop.x) .+ 1
            @. grid[s.start.y + 1, x1:x2] += 1
        elseif abs(s.stop.y - s.start.y) == abs(s.stop.x - s.start.x)
            diff = max(abs(s.stop.y-s.start.y), abs(s.stop.x-s.start.x))
            stepx, stepy = (1, 1)
            if s.start.y > s.stop.y
                stepy = -1
            end
            if s.start.x > s.stop.x
                stepx = -1
            end

            p1 = s.start
            for j = 0:diff
                grid[p1.y + 1, p1.x + 1] += 1
                p1.x += stepx
                p1.y += stepy
            end

            # heatmap(grid, yflip=true, background_color = RGB(0.2, 0.2, 0.2), size=(640, 480), show=false);
            # name = @sprintf "figs/part2/output%03d.png" i
            # savefig(name);
            # i += 1
        end
    end
    # display(grid)
    count(>=(2), grid)
end


function main(filename::String)
    lines = readlines(filename)
    segments = parsepositions(lines)
    grid_size = find_grid_size(segments)

    println("Part1: ", part1(grid_size, segments))
    println("Part2: ", part2(grid_size, segments))

end
