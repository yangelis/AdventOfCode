using Mmap
function computah!(codes)
    for i in 1:4:length(codes)
        if codes[i] == 99
            break
        end

        pos1, pos2, pos3 = codes[i+2], codes[i+3], codes[i+4]
        arg1, arg2 = codes[pos1+1], codes[pos2+1]

        if codes[i] == 1
            codes[pos3] = arg1 + arg2
        elseif codes[i] == 2
            codes[pos3] = arg1 * arg2
        end
    end
end



function main(filename)
    codes = readline(filename) |> (x->split(x ,','))
    computah!(codes)
end
