function part1(numbers::Vector{Int64})
  s = 0
  for i = 2:length(numbers)
    if numbers[i] > numbers[i-1]
      s += 1
    end
  end

  return s
end

function part2(numbers::Vector{Int64})
  v2 = Vector{Int64}()
  n = length(numbers)-2
  for i = 1:n
    push!(v2, numbers[i] + numbers[i+1] + numbers[i+2])
  end

  return part1(v2)
end

function main(filename::String)
  numbers = parse.(Int64, readlines(filename))

  println("Part1: ", part1(numbers))
  println("Part2: ", part2(numbers))

end
