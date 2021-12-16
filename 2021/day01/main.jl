using Plots
gr()
Plots.GRBackend()

function part1(numbers::Vector{Int64})
    s = 0
    for i = 2:length(numbers)
        if numbers[i] > numbers[i-1]
            s += 1
        end
    end
    return s
end

function summation(numbers::Vector{Int64})
    v2 = Vector{Int64}()
    n = length(numbers)-2
    for i = 1:n
        push!(v2, numbers[i] + numbers[i+1] + numbers[i+2])
    end
    return v2
end

function part2(numbers::Vector{Int64})
    v = summation(numbers)
    return (v, part1(v))
end

function main(filename::String)
    numbers = parse.(Int64, readlines(filename))

    println("Part1: ", part1(numbers))
    numbers2, result2 = part2(numbers)
    println("Part2: ", result2)

    p1 = plot(numbers, background_color = RGB(0.2, 0.2, 0.2), leg=false,
              title="Part1")
    p2 = histogram(numbers, bins=100, background_color = RGB(0.2, 0.2, 0.2),
                   leg=false, title="Part1 Histogram")
    p3 = plot(numbers2, background_color = RGB(0.2, 0.2, 0.2), leg=false,
              title="Part2")
    p4 = histogram(numbers2, bins=100, background_color = RGB(0.2, 0.2, 0.2),
                   leg=false, title="Part2 Histogram")

    gui(plot(p1, p2, p3, p4, size=(1366, 768)))
    # savefig("figs/day01_plots.png")
end
