function part1(lines)
    mask_r = r"mask = (.+)"
    mem_r = r"mem\[(\d+)\] = (\d+)"

    mask = Dict{Int8, Int8}()
    mem = Dict{Int64, Int128}()
    for line in lines
        if (m = match(mask_r, line); m !== nothing)
            for (i, c) in enumerate(reverse(m.captures[1]))
                if haskey(mask, i)
                    delete!(mask, i)
                end

                if c == '1'
                    mask[i] = 1
                elseif c == '0'
                    mask[i] = 0
                end
            end
        elseif (m = match(mem_r, line); m !== nothing)
            index = parse(Int64, m.captures[1])
            num = parse(Int64, m.captures[2])
            mem[index] = num

            for (i, b) in mask
                if b == true
                    mem[index] |= 1 << (i - 1)
                else
                    mem[index] &= ~(1 << (i - 1))
                end
            end
        end
    end
    sum(values(mem))
end


function main(filename::String)
    lines = readlines(filename)
    println("Part1: ", part1(lines))


end
