mutable struct V2
  x::Int
  y::Int
end
Base.copy(v::V2) = V2(v.x, v.y)

function solver(instructions::String)
  positions = Vector{V2}()
  counters = Vector{Int}()

  pos = V2(0, 0)
  push!(positions, pos)
  push!(counters, 1)

  for ins in instructions
    new_pos = copy(pos)
    if ins == '>'
      new_pos.x += 1
    elseif ins == '<'
      new_pos.x -= 1
    elseif ins == '^'
      new_pos.y += 1
    elseif ins == 'v'
      new_pos.y -= 1
    end

    id = findfirst(x->(x.x == new_pos.x && x.y == new_pos.y), positions)

    if isnothing(id)
      push!(positions, new_pos)
      push!(counters, 1)
    else
      positions[id] = new_pos
      counters[id] += 1
    end

    pos = copy(new_pos)
  end
  # println(positions)
  # println(counters)

  return positions, counters
end

function part1(instructions::String)
  positions, counters = solver(instructions)
  return count(>=(1), counters)
end


function part2(instructions::String)
  ins1 = ""
  ins2 = ""
  for (id, ins) in enumerate(instructions)
    if iseven(id)
      ins2 *= ins
    else
      ins1 *= ins
    end
  end
  santa = solver(ins1)
  robo_santa = solver(ins2)

  n = length(robo_santa[1])
  for i = 1:n
    id =
    findfirst(x->(x.x == robo_santa[1][i].x && x.y == robo_santa[1][i].y), santa[1])

    if isnothing(id)
      push!(santa[1], robo_santa[1][i])
      push!(santa[2], 1)
    else
      santa[2][id] += 1
    end
  end

  return count(>=(1), santa[2])
end

function main()
  # test1 = "^"
  # test2 = "^>v<"
  # test3 = "^v^v^v^v^v"

  # println("test1: ", part1(test1), " ", part2(test1))
  # println("test2: ", part1(test2), " ", part2(test2))
  # println("test3: ", part1(test3), " ", part2(test3))


  println("Part1: ", part1(readline("input.txt")))
  println("Part2: ", part2(readline("input.txt")))

end
