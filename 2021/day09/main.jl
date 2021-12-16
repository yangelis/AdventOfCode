# using Plots
# gr()

using GLMakie

function ismin_neighbor(v, grid::Matrix{Int}, r, c, nr, nc)
    @inbounds for (pi, pj) in [[1,0], [0,1], [0,-1], [-1,0]]
        ii, jj = (r + pi, c + pj)
        if 1 <= ii && ii <= nr && 1 <= jj && jj <= nc
            if grid[ii, jj] <= v
                return false
            end
        end
    end
    return true
end

function part1(grid::Matrix{Int})
    h, w = size(grid)
    result = 0
    @inbounds for (c, col) in enumerate(eachcol(grid))
        @inbounds for (r, row) in enumerate(col)
            min_found = ismin_neighbor(row, grid, r, c, h, w)

            if min_found
                result += row + 1
            end
        end
    end
    result
end

function part1_matrix(grid::Matrix{Int})
    h, w = size(grid)
    result = 0
    win = Matrix{Int}(undef, 3, 3)
    win[:,1] = [10, 1, 10]
    win[:,2] = [1, 10, 1]
    win[:,3] = [10, 1, 10]
    c = Matrix{Int}(undef, 3, 3)
    c[:,1] = [10, 0, 10]
    c[:,2] = [0, 10, 0]
    c[:,3] = [10, 0, 10]

    result = 0
    @inbounds for j = 2:w - 1
        @inbounds for i = 2:h - 1
            a = win .* grid[i - 1:i + 1, j - 1:j + 1] .+ c
            if minimum(a) > grid[i,j]
                result += grid[i,j] + 1
            end
        end
    end
    result
end

function bfs(grid::Matrix{Int}, i, j, h, w)
    queue = Vector{Tuple{Int,Int}}()
    push!(queue, (i, j))
    visited = Set{Tuple{Int,Int}}()

    while !isempty(queue)
        ij1 = popfirst!(queue)
        if ij1 in visited
            continue
        end

        push!(visited, ij1)
        @inbounds for (pi, pj) in [[1,0], [0,1], [0,-1], [-1,0]]
            ii, jj = (ij1[1] + pi, ij1[2] + pj)
            if 1 <= ii && ii <= h && 1 <= jj && jj <= w
                if grid[ii, jj] != 9 && !((ii, jj) in visited)
                    push!(queue, (ii, jj))
                end
            end
        end
    end
    return visited
end

function part2(grid::Matrix{Int})
    h, w = size(grid)
    visited = Set{Tuple{Int,Int}}()
    r = Vector{Int}()

    @inbounds for j = 1:w
        @inbounds for i = 1:h
            if grid[i,j] != 9 && !((i, j) in visited)
                c = bfs(grid, i, j, h, w)
                visited = union(visited, c)
                push!(r, length(c))
            end
        end
    end
    return prod(sort(r)[end - 2:end])
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

    println("Part1: ", part1(grid))
    println("Part2: ", part2(grid))

    # gui(heatmap(grid, yflip=true, background_color = RGB(0.2, 0.2, 0.2),
    #             c=cgrad(:matter, 10, categorical=true), size=(1366, 768)))
    # fontsize = 15
    # ann = [(j,i, text(grid[i,j], fontsize, :white, :center))
    #        for i in 1:nrows for j in 1:ncols]
    # gui(annotate!(ann))
    # display(grid)
    # savefig("test.png")
    xs = [x for x = 1:ncols for y = 1:nrows]
    ys = [y for x = 1:ncols for y = 1:nrows]
    # gui(plot(xs, ys, grid, st=:surface))
    zs = Vector{Int}(undef, nrows*ncols)
    for i in ys
        for j in xs
            zs[i + (j-1)*nrows] = grid[i, j]
        end
    end
    zmin, zmax = minimum(zs), maximum(zs)
    cmap = :viridis
    fig = Figure(resolution=(1366, 768))
    ax = Axis3(fig, aspect = :data, perspectiveness = 0.5,
               xzpanelcolor= (:black, 0.75), yzpanelcolor= (:black,0.75),
               zgridcolor = :grey, ygridcolor = :grey,xgridcolor = :grey)
    surface!(ax, xs, ys, zs)
    xm, ym, zm = minimum(ax.finallimits[])
    # contour!(ax, xs, ys, zs, levels = 20, colormap = cmap, linewidth = 2,
    #          colorrange=(zmin, zmax), transformation = (:xy, zm))
    hm=heatmap!(ax, xs, ys, zs)
    Colorbar(fig[1, 2], hm, width=15, ticksize=15, tickalign=1, height=Relative(0.35))
    # wireframe!(ax, xs, ys, zs, overdraw = true, transparency = true,
    #            color = (:black, 0.1))
    fig[1,1] = ax


    ncols += 2
    nrows += 2

    grid_pad = zeros(Int, nrows, ncols)
    fill!(grid_pad, 10)
    @inbounds for i = 1:nrows - 2
        @inbounds for j = 1:ncols - 2
            grid_pad[i + 1,j + 1] = grid[i,j]
        end
    end
    println("Part1 again: ", part1_matrix(grid_pad))

    fig
    save("fig.png", fig)
end
