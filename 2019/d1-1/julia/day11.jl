function parse_file(filename, ::Type{T}) where T
    lines = Vector{T}()
    open(filename) do file
        for line in eachline(file)
            push!(lines, parse(T, line))
        end
    end
    return lines
end

function fuel_calc(mass::UInt)
    return floor(mass / 3) - 2
end

function main()
    total_fuel::Int64 = 0.0
    lines = parse_file("../input.txt", UInt64)
    foreach(x-> total_fuel += fuel_calc(x), lines)
    println(total_fuel)
end


main()
