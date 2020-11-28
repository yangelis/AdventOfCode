function parse_file(filename, ::Type{T}) where T
    lines = Vector{T}()
    open(filename) do file
        for line in eachline(file)
            push!(lines, parse(T, line))
        end
    end
    return lines
end

function fuel_calc(mass::Int)
    return floor(mass / 3) - 2
end

function main(filename)
    total_fuel::Int64 = 0.0
    lines = parse_file(filename, Int64)
    foreach(x-> total_fuel += fuel_calc(x), lines)
    println(total_fuel)
end
