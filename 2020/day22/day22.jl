mutable struct Player
    id::Int64
    deck::Vector{Int64}
end

function in(p::Vector{Player}, xs::Vector{Vector{Player}})
    for x in xs
        if x[1].deck == p[1].deck && x[2].deck == p[2].deck
            return true
        end
    end

    return false
end


function calc_points(winner::Player)
    points = [i for i in length(winner.deck):-1:1]
    mapreduce(*, +, winner.deck, points)
end


function recursive_combat!(players::Vector{Player})
    previous_rounds = Vector{Vector{Player}}()
    while !isempty(players[1].deck) && !isempty(players[2].deck)
        # println(players)
        if players in previous_rounds
            return players[1]
        end

        push!(previous_rounds, deepcopy(players))
        c1 = popfirst!(players[1].deck)
        c2 = popfirst!(players[2].deck)

        if c1 <= length(players[1].deck) && c2 <= length(players[2].deck)
            temp = deepcopy(players)
            resize!(temp[1].deck, c1)
            resize!(temp[2].deck, c2)
            # println("NEW Game")
            winner = recursive_combat!(temp)
            if winner.id == 1
                push!(players[1].deck, c1, c2)
            else
                push!(players[2].deck, c2, c1)
            end
            # continue
        elseif c1 > c2
            push!(players[1].deck, c1, c2)
        elseif c2 > c1
            push!(players[2].deck, c2, c1)
        end
    end
    winner = filter(x->!isempty(x.deck), players)[1]
    winner
end

function combat!(players::Vector{Player})
    while !isempty(players[1].deck) && !isempty(players[2].deck)
        c1 = popfirst!(players[1].deck)
        c2 = popfirst!(players[2].deck)

        if c1 > c2
            push!(players[1].deck, c1, c2)
        elseif c2 > c1
            push!(players[2].deck, c2, c1)
        end
    end

    winner = filter(x->!isempty(x.deck), players)[1]
    return calc_points(winner)
end



function main(filename::String)
    lines = readlines(filename, keep=true) |> join |>
        x->split(x, "\n\n")
    players = Vector{Player}()
    for line in lines
        pos = findfirst(':', line)
        id = parse(Int64, line[pos-1])
        deck = line[pos+1:end] |> x->split(x, '\n') |>
            x->filter(y->!isempty(y),x) |> x->parse.(Int64,x)

        push!(players, Player(id, deck))
    end

    t = deepcopy(players)
    println("Part1: ", combat!(t))
    winner = recursive_combat!(players)
    calc_points(winner)

end
