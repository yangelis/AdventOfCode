# change the precedence of the operators
×(x,y) = x + y
⨣(x,y) = x * y

function part1(lines)
    p1_sum = 0
    for line in lines
        l1 = replace.(line, "*"=>"⨣")
        p1 = sum(@. eval(Meta.parse(l1)))
        println(line, " = ", p1)
        p1_sum += p1
    end
    p1_sum
end

function part2(lines)
    p2_sum = 0
    for line in lines
        l1 = replace.(line, "*"=>"⨣")
        l2 = replace.(l1, "+"=>"×")
        p2 = sum(@. eval(Meta.parse(l2)))
        println(line, " = ", p2)
        p2_sum += p2
    end
    p2_sum
end



function main(filename::String)
    lines = readlines(filename)
    println("Part1: ", part1(lines))
    println("Part2: ", part2(lines))
end
