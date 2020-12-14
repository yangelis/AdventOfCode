const mask_r = r"mask = (.+)"
const mem_r = r"mem\[(\d+)\] = (\d+)"

function parse_mask!(mask_str, mask_dict)
    for (i, c) in enumerate(reverse(mask_str))
        # if haskey(mask_dict, i)
        #     delete!(mask_dict, i)
        # end

        if c == '1'
            mask_dict[i] = 1
        elseif c == '0'
            mask_dict[i] = 0
        else
            mask_dict[i] = -1
        end
    end
end

function part1(lines)
    mask = Dict{Int8, Int8}()
    mem = Dict{Int64, Int128}()
    for line in lines
        if (m = match(mask_r, line); m !== nothing)
            parse_mask!(m.captures[1], mask)
        elseif (m = match(mem_r, line); m !== nothing)
            index = parse(Int64, m.captures[1])
            num = parse(Int64, m.captures[2])
            mem[index] = num

            for (i, b) in mask
                if b == 1
                    mem[index] |= 1 << (i - 1)
                elseif b == 0
                    mem[index] &= ~(1 << (i - 1))
                end
            end
        end
    end
    sum(values(mem))
end

function part2(lines)
    mask = Dict{Int8, Int8}()
    mem = Dict{Int64, Int64}()
    float_add = Vector{Int64}()
    for line in lines
        if (m = match(mask_r, line); m !== nothing)
            parse_mask!(m.captures[1], mask)
        elseif (m = match(mem_r, line); m !== nothing)
            index = parse(Int64, m.captures[1])
            num = parse(Int64, m.captures[2])

            float_add = Vector{Int64}()
            for i in 1:length(mask)
                if mask[i] == 1
                    index |= 1 << (i - 1)
                elseif mask[i] == -1
                    index &= ~(1 << (i - 1))
                    push!(float_add, i)
                end
            end
            mem[index] = num

            # using Combinatorics
            # for i in combinations(float_add)
            #     mem[index + sum(1 << (k - 1) for k in i)] = num
            # end
            for comb in collect(Iterators.product(Iterators.repeated([0,1], length(float_add))...))
                if (i = [float_add[ii] for (ii, j) in enumerate(comb) if j == 1]; !isempty(i))
                    mem[index + sum(1 << (k - 1) for k in i)] = num
                end
            end
        end
    end
    sum(values(mem))
end



function main(filename::String)
    lines = readlines(filename)
    println("Part1: ", part1(lines))
    println("Part2: ", part2(lines))
end
