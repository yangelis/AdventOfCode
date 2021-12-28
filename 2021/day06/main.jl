using Plots
using Printf

function evolve1(days::Int, fish::Vector{Int})
    fishes = deepcopy(fish)
    for i = 1:days
        more_fish = Vector{Int}()
        for f in fishes
            f -= 1
            if f < 0
                push!(more_fish, 6)
                push!(more_fish, 8)
            else
                push!(more_fish, f)
            end
        end
        fishes = more_fish
    end
    return length(fishes)
end

function evolve2(days::Int, fish::Vector{Int})
    the_day = 9
    counters = zeros(Int, the_day)
    a = Vector{Vector{Int}}()
    for d in 0:days-1
        push!(a, zeros(Int, the_day))
    end

    for f in fish
        counters[f + 1] += 1
    end

    for d in 0:days-1
        counters[((7+d)%the_day) + 1] += counters[(d%the_day) + 1]
        a[d + 1] += counters
    end

    # for d in 0:days-1
    #     p = histogram(a[d + 1], size=(640, 480), show=false);
    #     name = @sprintf "days%d/out%03d.png" days d+1
    #     savefig(p, name);
    # end
    sum(counters)
end


function main(filename::String)
    fish = parse.(Int, split(readline(filename), ','))
    println("Part1: ", evolve2(80, fish))
    println("Part2: ", evolve2(256, fish))
end
