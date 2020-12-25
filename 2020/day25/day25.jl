input = [8458505, 16050997]

# baby-step-giant-step algorithm
function bsgs(base, n, p)
    m = Int(ceil(sqrt(p)))
    table = Dict(powermod(base, i, p)=>i for i in 1:m)
    inv = powermod(base, (p-2)*m, p)
    res = nothing

    for i in 1:m
        y = mod(n * powermod(inv, i, p), p)
        if haskey(table, y)
            res = i * m + table[y]
            break
        end
    end

    return res
end

function main()
    k1, k2 = input
    a = bsgs(7, k1, 20201227)
    key = powermod(k2, a, 20201227)
    println("Merry Chistmass Ya Filthy Animals: ", key)

end

