using Plots
gr()

mutable struct Pos
    x :: Int
    y :: Int
end

function visual_part1(nums)
    n = length(nums)
    # positions = Vector{Pos}(undef, n)
    xs = Vector{Int}(undef, n)
    ys = Vector{Int}(undef, n)
    best_step = median(sort(nums))
    for i=1:n
        xs[i] = i
        ys[i] = nums[i]
    end
    gui(plot(xs, ys, seriestype = :scatter, background_color = RGB(0.2, 0.2,
                                                                   0.2), lab="Crabs", show=true))
    hline!([best_step], lab="Median")
end



function median(nums)
    n = length(nums)
    if n % 2 == 0
        return div((nums[div(n,2)-1] + nums[div(n,2)]), 2)
    else
        return nums[n]
    end
end

function mean(nums)
    n = length(nums)
    return div(sum(nums), n)
end

function sumupto(n)
    div(n*(n+1), 2)
end

function part1_meh(nums)
    m = maximum(nums)
    fuels = Vector{Int}(undef, m)
    for i=1:m
        fuels[i] = sum(map(x->abs(x-i), nums))
    end

    return minimum(fuels)
end

function part1(nums)
    sum(map(x->abs(x-median(sort(nums))), nums))
end

function part2(nums)
    m = maximum(nums)
    fuels = Vector{Int}(undef, m)
    for i=1:m
        fuels[i] = sum(map(x->sumupto(abs(x-i)), nums))
    end
    minimum(fuels)
end


function main(filename::String)
    nums = parse.(Int, split(readline(filename), ','))
    println("Part1: ", part1(nums))
    println("Part2: ", part2(nums))
    visual_part1(nums)
end
