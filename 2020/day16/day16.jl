const rule_regex = r"(.+): (\d+)-(\d+) or (\d+)-(\d+)"

function parse_rules!(rules, rule_lines)
    for rl in rule_lines
        m = match(rule_regex, rl)
        if m !== nothing
            l = (parse(Int64, m.captures[2]):parse(Int64, m.captures[3]))
            h = (parse(Int64, m.captures[4]):parse(Int64, m.captures[5]))
            rules[m.captures[1]] = (l=l, h=h)
        else
            error("Oopsie")
        end
    end
end

function part1(rules, tickets)
    invalid_tickets = Int64[]
    n_of_rules = length(rules)
    for ticket in tickets
        c = 0
        for (key, val) in rules
            if !(ticket in val.l) && !(ticket in val.h)
                c += 1
            end
        end
        if c == n_of_rules
            push!(invalid_tickets, ticket)
        end
    end

    sum(invalid_tickets)
end


function main(filename::String)
    lines =  readlines(filename, keep=true) |> join |> x->split(x, "\n\n")

    rule_lines = split(lines[1], '\n')
    rules = Dict{String, NamedTuple{(:l, :h)}}()
    parse_rules!(rules, rule_lines)

    tickets = replace(lines[3], '\n'=>',') |>
        x->split(x, ',')[2:end-1] |>
        x->parse.(Int64, x)


    println("Part1: ", part1(rules, tickets))
end
