const SIZE = 30

function part!(data, n)
    layout = transpose(data)
    h, w = size(layout)

    grid = zeros(Int64, ntuple(s->SIZE, n))

    @inbounds for yi = 1:h, xi = 1:w
        grid[Tuple(SIZE÷2 for _ in 1:n-2)..., yi + SIZE÷2, xi + SIZE÷2] = layout[yi, xi]
    end

    indices = CartesianIndices(ntuple(d->2:SIZE-1, n))
    step_indices = CartesianIndices(ntuple(d->-1:1,n))

    @inbounds for cycle in 1:6
        adjacent = zeros(Int64, ntuple(s->SIZE, n))
        @inbounds for di in step_indices
            if count(x->x==0, di.I) == n
                continue
            end

            @inbounds @simd for i in indices
                adjacent[i] += grid[i+di]
            end
        end

        @inbounds @simd for i in indices
            grid[i] = (adjacent[i] == 2 &&
                       grid[i] == 1) ||
                       (adjacent[i] == 3 )
        end
    end

    res = 0

    @inbounds @simd for i in CartesianIndices(ntuple(d->2:SIZE-1, n))
        res += grid[i]
    end

    res
end

function main(filename::String)
    lines = readlines(filename)
    h = length(lines)
    w = length(lines[1])
    layout = Matrix{Int64}(undef, h, w)
    for i in 1:h, j in 1:w
        layout[i, j] = (lines[i][j] == '#' ? 1 : 0)
    end

    println("Part1: ", part!(layout, 3))
    println("Part2: ", part!(layout, 4))
end
