function parse_file(filename::String)
    lines = readlines(filename)
    polymer_template = lines[1]
    last_char = polymer_template[end]

    poly_pairs = Dict(pl=>0 for pl in collect(zip(polymer_template, polymer_template[2:end])))
    for i in 1:length(polymer_template)-1
        poly_pairs[(polymer_template[i], polymer_template[i+1])] += 1
    end

    rules = split.(lines[3:end], " -> ")
    rules_dict = Dict{Tuple{Char, Char}, Tuple{Tuple{Char, Char}, Tuple{Char, Char}}}()
    for r in rules
        rules_dict[(r[1][1][1], r[1][2][1])] = ((r[1][1][1], r[2][1]),
                                                (r[2][1], r[1][2][1]))
    end
    return (poly_pairs, rules_dict, last_char)
end

function evolve(polymer, rules, last_c, n)
    new_polymer = deepcopy(polymer)

    for i = 1:n
        temp_polymer = Dict{Tuple{Char, Char}, Int}()

        for (ps, n) in new_polymer
            if haskey(rules, ps)
                p = rules[ps]
                if haskey(temp_polymer, p[1])
                    temp_polymer[p[1]] += n
                else
                    temp_polymer[p[1]] = 0
                    temp_polymer[p[1]] += n
                end

                if haskey(temp_polymer, p[2])
                    temp_polymer[p[2]] += n
                else
                    temp_polymer[p[2]] = 0
                    temp_polymer[p[2]] += n
                end
            else
                temp_polymer[ps] = new_polymer[ps]
            end
        end
        new_polymer = deepcopy(temp_polymer)
    end

    # display(new_polymer)
    unique_chars = unique([p1 for (p1, p2) in keys(new_polymer)])
    counts = Dict(c=>0 for c in unique_chars)
    counts[last_c] = 1

    for ((p1, p2), n) in new_polymer
        counts[p1] += n
    end
    # display(counts)

    maximum(values(counts)) - minimum(values(counts))
end

function main(filename::String)
    poly_templ, rules, last_c = parse_file(filename)
    println("Part1: ", evolve(poly_templ, rules, last_c, 10))
    println("Part2: ", evolve(poly_templ, rules, last_c, 40))
end
