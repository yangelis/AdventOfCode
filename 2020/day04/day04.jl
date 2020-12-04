
function parse_passports(lines::Vector{String})
    dict = Vector{Dict{String, String}}()
    for line in lines
        temp_dict = Dict{String, String}()
        matches = collect(eachmatch(r"(\w{3}):(#?\w{1,9})", line))
        for c in matches
            temp_dict[String(c.captures[1])] = String(c.captures[2])
        end
        push!(dict, temp_dict)
    end
    dict
end

function count_valid_passports(passports::Vector{Dict{String, String}})
    counter::Int64 = 0

    for passport in passports
        if passport.count == 8
            counter += 1
        elseif !haskey(passport, "cid") && passport.count == 7
            counter += 1
        end
    end

    return counter
end

function main(filename::String)
    lines = readlines(filename)

    clean_lines = Vector{Vector{String}}()
    temp = Vector{String}()
    for i in 1:length(lines)
        if !isempty(lines[i])
            push!(temp, lines[i])
        elseif isempty(lines[i])
            push!(clean_lines, temp)
            temp = Vector{String}()
        end

        if i == length(lines)
            push!(clean_lines, temp)
            temp = Vector{String}()
        end
    end

    pass = Vector{String}(undef, length(clean_lines))
    fill!(pass, "")
    for i in 1:length(clean_lines)
        for element in clean_lines[i]
            pass[i] *= element * " "
       end
    end


    dict = parse_passports(pass)

    valid = count_valid_passports(dict)
    println("Part1: ", valid)


end
