mutable struct Bag
    name::String
    visited::Bool
    contains::Vector{Tuple{Bag, Int64}}
    contained::Vector{Bag}

    Bag() = new("", false, Vector{Tuple{Bag, Int64}}(), Vector{Bag}())
    Bag(name::String) = new(name, false, Vector{Tuple{Bag, Int64}}(),
                         Vector{Bag}())
end

function parse_rules(lines::Vector{String})
    bags = Dict{String, Bag}()
    for line in lines
        bag_pos = findall("bag", line)

        digit_counter = 0
        for c in line
            if isdigit(c)
                digit_counter += 1
            end
        end

        bag_name = strip(line[1:bag_pos[1][1]-1])
        line = line[bag_pos[1][1]:end]
        remove_contain_pos = findfirst("contain", line)[end] + 1
        line = strip(line[remove_contain_pos:end])

        bags[bag_name] = get_Bag!(String(bag_name), bags)

        inner_bags = Vector{Tuple{Bag, Int64}}()
        line = replace(line, "bags"=>"") |>
            x->replace(x, "bag"=>"") |>
            strip |> x->split(x, ',') |> x->map(strip,x)

        # println(line)
        for l in line
            m = match(r"^(?<cap>\d+)\s{1}(?<name>\w+\s{1}\w+)", l)
            if m === nothing
                continue
            end
            inner_bag = get_Bag!(String(m[:name]), bags)

            push!(inner_bag.contained, bags[bag_name])
            push!(inner_bags, (inner_bag, parse(Int64, m[:cap])))
        end

        bags[bag_name].contains = inner_bags

    end

    bags
end

function get_Bag!(name::String, bags)
    if haskey(bags, name)
        return bags[name]
    else
        bag = Bag(name)
        bags[name] = bag

        return bag
    end

end

function part1(bags, bag)
    counter = 0

    for b in bag.contained
        if !b.visited
            counter += 1
        end
        counter += part1(bags, b)
        b.visited = true

    end

    return counter
end

function part2(bags, bag)
    counter = 0

    for b in bag.contains
        counter += b[2]
        counter += b[2] * part2(bags, b[1])
    end

    return counter
end

# dot graph.dot -Tpng -o graph.png
function graph_printer(bags)
    open("graph.dot", "w") do file
        print(file, "digraph{\n")
        for (key, val) in bags
            for (b, _) in get_Bag!(key, bags).contains
                n2 = b.name
                print(file, "\"$key\" -> \"$n2\";\n")
            end
        end
        print(file, "}\n")
    end
end

function main(filename::String)
    file = readlines(filename)
    bags = parse_rules(file)

    graph_printer(bags)
    println("Part1: ", part1(bags, get_Bag!("shiny gold",bags)))
    println("Part2: ", part2(bags, get_Bag!("shiny gold",bags)))
end
