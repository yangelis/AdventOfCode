function parse_graph(lines)
    graph = Dict{String, Vector{String}}()
    for line in lines
        if line[2] != "start"
            if !haskey(graph, line[1])
                graph[line[1]] = Vector{String}()
            end
            push!(graph[line[1]], line[2])
        end
        if line[1] != "start"
            if !haskey(graph, line[2])
                graph[line[2]] = Vector{String}()
            end
            push!(graph[line[2]], line[1])
        end
    end
    graph
end

function part1(graph::Dict{String, Vector{String}}, src, dst)
    s = 0

    stack = Vector{Tuple{String, Vector{String}}}()
    push!(stack, (src, [src]))

    while !isempty(stack)
        nd, vs = pop!(stack)

        if nd == dst
            s += 1
            continue
        end

        for g in graph[nd]
            if g in vs && islowercase(g[1])
                continue
            end
            push!(stack, (g, union(vs, [g])))
        end
    end
    return s
end

function dump_graph(filename, graph)
    open(filename, "w") do file
        println(file, "digraph {")
        for (k, vals) in graph
            for v in vals
                println(file, " ", k,"->", v)
            end
        end
        println(file, "}")
    end
end

function main(filename::String)
    lines = split.(readlines(filename), '-')
    graph = parse_graph(lines)
    display(graph)
    part1(graph, "start", "end")
    dump_graph("graph.dot", graph)
end
