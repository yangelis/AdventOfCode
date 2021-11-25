function area(w, h, l)
  return 2*(l*w + w*h + h*l)
end


function part1(sides)
  sum(map(x->area(x[1], x[2], x[3]) + x[1]*x[2], sort.(sides)))
end

function part2(sides)
  sum(map(x->2*(x[1] + x[2]) + reduce(*, x), sort.(sides)))
end

function main()
  sides = map(x -> parse.(Int64, split(x, "x")), readlines("input.txt"))
  println("Part1: ", part1(sides))
  println("Part2: ", part2(sides))

end
