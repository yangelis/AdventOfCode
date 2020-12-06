function part1(lines::String)
    answers =  sum([length(unique(l)) for l in split(lines)])
    answers
end

function main(filename::String)
    lines = ""
    for l in eachline(filename, keep=true)
        lines *= l
    end

    lines = replace(replace(replace(lines,"\n\n"=>"+"), "\n"=>""), "+"=>'\n')

    println("Part1: ", part1(lines))
end
