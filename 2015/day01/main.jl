function part1(filename)
  sum(map(x-> x == '(' ? 1 : -1, collect(readline(filename))))
end

function part2(filename)
  chars = collect(readline(filename))
  # chars = ['(',')','(',')',')']
  instructions = map(x-> x == '(' ? 1 : -1, chars)

  n = length(instructions)

  a = zeros(Int64, n)
  a[1] = instructions[1]

  for i = 2:n
    a[i] += a[i-1] + instructions[i]
  end

  for i = 1:n
    if a[i] == -1
      return i
    end
  end
end

function main()
  println("part1 solution: ", part1("input.txt"))
  println("part2 solution: ", part2("input.txt"))
end
