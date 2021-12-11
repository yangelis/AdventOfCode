function part1(lines::Vector{String})
    score = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    table = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')

    s = 0

    for line in lines
        stack = Vector{Char}()
        for c in line
            if c in "{[(<"
                push!(stack, table[c])
            elseif pop!(stack) != c
                println("Line:", line, ", illegal char:", c)
                s += score[c]
                break
            end
        end
    end
    s
end

function part2(lines::Vector{String})
    table = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    corrupted_ids = Vector{Int}()

    for (i, line) in enumerate(lines)
        stack = Vector{Char}()
        for c in line
            if c in "{[(<"
                push!(stack, table[c])
            elseif pop!(stack) != c
                push!(corrupted_ids, i)
                break
            end
        end
    end

    incomplete_lines = Vector{String}()
    for (i, line) in enumerate(lines)
        if i in corrupted_ids
            continue
        end
        push!(incomplete_lines, line)
    end

    score = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    scores = Vector{Int}(undef, length(incomplete_lines))
    for (i, line) in enumerate(incomplete_lines)
        stack = Vector{Char}()
        for c in line
            if c in "{[(<"
                push!(stack, table[c])
            elseif pop!(stack) != c
                break
            end
        end

        s = 0
        missing_chars = Vector{Char}()
        while !isempty(stack)
            s *= 5
            push!(missing_chars, pop!(stack))
            s += score[missing_chars[end]]
        end
        println("Line:", line, ", missing chars:", String(missing_chars))

        scores[i] = s
    end
    println(sort(scores)[div(length(scores), 2) + 1])
end

function main(filename::String)
    lines = readlines(filename)
    println("Part1:", part1(lines))
    println("Part2:", part2(lines))
end
