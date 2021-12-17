function parse_to_matrix(lines::Vector{String})
    rows = length(lines)
    cols = length(lines[1])
    m = Matrix{Int}(undef, rows, cols)
    for i in 1:rows
        for j in 1:cols
            m[i, j] = parse(Int, lines[i][j])
        end
    end
    return m
end

function dijkstra(m)
    h, w = size(m)
    source = (1, 1)
    destination = (h, w)

    queue = Vector{Tuple{Int, Tuple{Int, Int}}}()
    push!(queue, (0, source))

    distances = Dict{Tuple{Int, Int}, Int}()
    distances[source] = 0
    visited = Set{Tuple{Int, Int}}()

    while !isempty(queue)
        distance, vertex = popat!(queue, argmin(queue))

        if vertex == destination
            return distance
        end

        if vertex in visited
            continue
        end

        push!(visited, vertex)

        row, col = vertex
        @inbounds for (pi, pj) in [[1,0], [0,1], [0,-1], [-1,0]]
            ii, jj = (row + pi, col + pj)
            if 1 <= ii <= h && 1 <= jj <= w && !((ii, jj) in visited)
                new_distance = distance + m[ii, jj]
                temp_distance = 0

                if haskey(distances, (ii, jj))
                    if new_distance < distances[(ii, jj)]
                        distances[(ii, jj)] = new_distance
                        push!(queue, (new_distance, (ii, jj)))
                    end
                else
                    distances[(ii, jj)] = new_distance
                    push!(queue, (new_distance, (ii, jj)))
                end
            end
        end
    end

    return -1
end

function main(filename::String)
    lines = readlines(filename)
    m = parse_to_matrix(lines)
    println("Part1: ", dijkstra(m))

    h, w = size(m)
    m2 = zeros(Int, 5*h, 5*w)

    m2[1:h, 1:w] = m
    for i=1:4
        m2[1:h, i*w+1:(i+1)*w] = mod.(m2[1:h, (i-1)*w+1:i*w], 9) .+ 1
    end
    for i=1:4
        m2[i*h+1:(i+1)*h, 1:w] = mod.(m2[(i-1)*h+1:i*h, 1:w], 9) .+ 1
    end

    for i=1:4
        for j=1:4
            m2[i*h+1:(i+1)*h, j*w+1:(j+1)*w] = mod.(m2[i*h+1:(i+1)*h, (j-1)*w+1:j*w], 9) .+ 1
        end
    end

    println("Part2: ", dijkstra(m2))
end
