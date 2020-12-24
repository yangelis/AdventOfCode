struct Rule
    name::String
    l::UnitRange{Int64}
    h::UnitRange{Int64}
end

isvalid_ticket(rule::Rule, x::Int64) = (x in rule.l || x in rule.h)


const rule_regex = r"(.+): (\d+)-(\d+) or (\d+)-(\d+)"

function parse_rules!(rules, rule_lines)
    for rl in rule_lines
        m = match(rule_regex, rl)
        if m !== nothing
            l = (parse(Int64, m.captures[2]):parse(Int64, m.captures[3]))
            h = (parse(Int64, m.captures[4]):parse(Int64, m.captures[5]))
            push!(rules, Rule(m.captures[1], l, h))
        else
            error("Oopsie")
        end
    end
end

issmaller(a::Vector{Any}, b::Vector{Any}) = cmp(length(a), length(b)) < 0
issmaller(a, b) = cmp(length(a[2]), length(b[2])) < 0

function part2_(rules, tickets, my_ticket)
    tickets = transpose(hcat(tickets...))
    h, w = size(tickets)
    found_cols = Int64[]
    col_matches = Dict{Int64, Int64}()
    nCols = length(rules)

    while length(col_matches) < nCols
        for ci in 1:nCols
            if haskey(col_matches, ci)
                continue
            end

            all_pass = [ true for j in 1:w ]

            for ti in 1:w
                if count(x->isvalid_ticket(rules[ci], x),
                         tickets[:,ti]) != h
                    all_pass[ti] = false
                end
            end

            map = 0
            found = false

            for j in 1:w
                if j in found_cols
                    continue
                end


                if all_pass[j]
                    if found
                        found = false
                        break
                    else
                        found = true
                        map = j
                    end
                end
            end

            if !found
                continue
            end

            push!(found_cols, map)
            col_matches[ci] = map
        end
    end

    result = 1
    for i in 1:nCols
        if findfirst("departure", rules[i].name) != nothing
            result *= my_ticket[col_matches[i]]
        end
    end
    result
end

function part1!(rules, tickets, valid_tickets)
    invalid_tickets = Int64[]
    n_of_rules = length(rules)
    for i = 1:length(tickets)
        valid_row = true
        for ticket in tickets[i]
            if count(x->!isvalid_ticket(x, ticket), rules) == n_of_rules
                valid_row = false
                push!(invalid_tickets, ticket)
            end
        end
        if valid_row
            push!(valid_tickets, tickets[i])
        end
    end

    return sum(invalid_tickets)
end


function main(filename::String)
    lines =  readlines(filename, keep=true) |> join |> x->split(x, "\n\n")

    rule_lines = split(lines[1], '\n')
    rules = Vector{Rule}()
    parse_rules!(rules, rule_lines)

    my_ticket = split(lines[2], '\n')[2] |>
        x->split(x, ',') |> x->parse.(Int64, x)

    tickets = split(lines[3], '\n')[2:end-1] |>
        x->split.(x, ',') |> x->map(f->parse.(Int64, f), x)


    valid_tickets = Vector{Vector{Int}}()
    println("Part1: ", part1!(rules, tickets, valid_tickets))
    println("Part2: ", part2_(rules, valid_tickets, my_ticket))
end
