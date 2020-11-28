function parse_file(filename, ::Type{T}) where T
    lines = Vector{T}()
    open(filename) do file
        for line in eachline(file)
            push!(lines, parse(T, line))
        end
    end
    return lines
end

function totalFuel(mass::Real)
    return floor(mass / 3) - 2
end

function fuel_calc2(lines)
    total_fuel = 0
    for mass in lines
        tempfuel = 0.
        tempfuel += totalFuel(mass)
        total_fuel += tempfuel
        while totalFuel(tempfuel) >=0
            tempfuel = totalFuel(tempfuel)
            total_fuel += tempfuel
        end
    end
    return total_fuel
end

function main(filename)
    total_fuel::Int64 = 0
    lines = parse_file(filename, Int64)
    total_fuel = fuel_calc2(lines)
    println(total_fuel)
end
