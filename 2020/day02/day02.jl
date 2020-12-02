struct Data
    low::Int64
    high::Int64
    character::Char
    passw::String
end

function n_valid(db::Vector{Data})
    valid_passw::Int64 = 0
    for i in 1:length(db)
        occurance::Int64 = 0
        for c in db[i].passw
            if c == db[i].character
                occurance += 1
            end
        end

        if occurance >= db[i].low && occurance <= db[i].high
            valid_passw += 1
        end

    end
    return valid_passw
end

function n_valid2(db::Vector{Data})
    valid_passw::Int64 = 0
    for i in 1:length(db)
        char = db[i].character
        occurance::Int64 = 0
        for c in db[i].passw
            if c == char
                occurance += 1
            end
        end

        if (db[i].passw[db[i].low] == char &&
            db[i].passw[db[i].high] == char)
            continue
        end

        if (db[i].passw[db[i].low] == char ||
             db[i].passw[db[i].high] == char)

            valid_passw += 1
        end
    end

    return valid_passw
end

function process(line::String)
    m = match(r"(?<low>.*)-(?<high>.*) (?<letter>.*): (?<pass>.*)", line)
    low = parse(Int64, m["low"],)
    high = parse(Int64, m["high"],)
    return Data(low, high, m["letter"][1], m["pass"])
end

function main(filename::String)
    input = readlines(filename)
    database = Vector{Data}(undef, length(input))
    for i in 1:length(input)
        database[i] = process(input[i])
    end

    # println(database)
    println("21: ", n_valid(database))
    println("22: ", n_valid2(database))


end
