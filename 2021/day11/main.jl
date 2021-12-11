function part1(grid::Matrix{Int}, steps::Int)
    nrows, ncols = size(grid)

    neighbors = [[-1, -1], [-1, 0], [-1, 1],
                 [0, -1],           [0, 1],
                 [1, -1],  [1, 0],  [1, 1]]
    flashed = BitMatrix(undef, nrows, ncols)
    fill!(flashed, 0)

    flashed = BitMatrix(undef, nrows, ncols)
    flashes = 0

    for step =1:steps
        fill!(flashed, 0)

        @. grid += 1
        ijs = findall(>=(10), grid)
        @. flashed[ijs] = 1
        while !isempty(ijs)
            @inbounds for ij in ijs
                @inbounds for (pi, pj) in neighbors
                    ii, jj = (ij[1] + pi, ij[2] + pj)
                    if 1 <= ii <= ncols && 1 <= jj <= ncols
                        if !flashed[ii, jj]
                            grid[ii, jj] += 1
                        end
                        if grid[ii, jj] >= 10
                            flashed[ii, jj] = 1
                        end
                    end
                end
                grid[ij] = mod(grid[ij], 10)
            end
            ijs = findall(>=(10), grid)
        end
        flashes += count(==(1), flashed)
    end
    # display(grid)

    return flashes
end

function part2(grid::Matrix{Int})
    nrows, ncols = size(grid)

    neighbors = [[-1, -1], [-1, 0], [-1, 1],
                 [0, -1],           [0, 1],
                 [1, -1],  [1, 0],  [1, 1]]
    flashed = BitMatrix(undef, nrows, ncols)
    fill!(flashed, 0)

    flashed = BitMatrix(undef, nrows, ncols)
    flashes = 0

    steps = 0
    while true
        fill!(flashed, 0)

        @. grid += 1
        ijs = findall(>=(10), grid)
        @. flashed[ijs] = 1
        while !isempty(ijs)
            @inbounds for ij in ijs
                @inbounds for (pi, pj) in neighbors
                    ii, jj = (ij[1] + pi, ij[2] + pj)
                    if 1 <= ii <= ncols && 1 <= jj <= ncols
                        if !flashed[ii, jj]
                            grid[ii, jj] += 1
                        end
                        if grid[ii, jj] >= 10
                            flashed[ii, jj] = 1
                        end
                    end
                end
                grid[ij] = mod(grid[ij], 10)
            end
            ijs = findall(>=(10), grid)
        end
        steps += 1
        if sum(flashed) == length(flashed)
            break
        end
    end

    return steps
end

function main(filename::String)
    lines = readlines(filename)
    ncols = length(lines[1])
    nrows = length(lines)

    grid = zeros(Int, nrows, ncols)

    @inbounds for i = 1:nrows
        @inbounds for j = 1:ncols
            grid[i,j] = parse(Int, lines[i][j])
        end
    end

    steps = 100
    println("Part1: ", part1(grid, steps))
    println("Part2: ", steps + part2(grid))
end
