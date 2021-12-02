struct Direction
  s::String 
  step::Int
end

mutable struct Pos
  x::Int
  y::Int
end

mutable struct NewPos
  pos::Pos
  aim::Int
end


function part1(dirs::Vector{Direction})
  start_pos = Pos(0,0)
  for dir in dirs
    if dir.s == "forward"
      start_pos.x += dir.step
    elseif dir.s == "up"
      start_pos.y -= dir.step
    elseif dir.s == "down"
      start_pos.y += dir.step
    end
  end

  return start_pos.x * start_pos.y
end

function part2(dirs::Vector{Direction})
  start_pos = NewPos(Pos(0,0), 0)
  for dir in dirs
    if dir.s == "forward"
      start_pos.pos.x += dir.step
      start_pos.pos.y += start_pos.aim * dir.step
    elseif dir.s == "up"
      start_pos.aim -= dir.step
    elseif dir.s == "down"
      start_pos.aim += dir.step
    end
  end

  return start_pos.pos.x * start_pos.pos.y
end

function parse_directions(filename::String)
  lines = split.(readlines(filename))

  n = length(lines)
  dirs = Vector{Direction}(undef, n)

  for i = 1:n
    dirs[i] = Direction(lines[i][1], parse(Int, lines[i][2]))
  end

  return dirs
end

function main(filename::String)
  dirs = parse_directions(filename)
  println("Part1: ", part1(dirs))
  println("Part2: ", part2(dirs))
end
