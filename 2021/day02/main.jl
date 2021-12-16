# using Plots
using GLMakie
# using DelimitedFiles

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
  xs = Vector{Int}()
  ys = Vector{Int}()
  for dir in dirs
    if dir.s == "forward"
      start_pos.x += dir.step
    elseif dir.s == "up"
      start_pos.y -= dir.step
    elseif dir.s == "down"
      start_pos.y += dir.step
    end
    push!(xs, start_pos.x)
    push!(ys, start_pos.y)
  end

  return (xs, ys)
end

function part2(dirs::Vector{Direction})
  start_pos = NewPos(Pos(0,0), 0)
  xs = Vector{Int}()
  ys = Vector{Int}()
  aim = Vector{Int}()
  for dir in dirs
    if dir.s == "forward"
      start_pos.pos.x += dir.step
      start_pos.pos.y += start_pos.aim * dir.step
    elseif dir.s == "up"
      start_pos.aim -= dir.step
    elseif dir.s == "down"
      start_pos.aim += dir.step
    end
    push!(xs, start_pos.pos.x)
    push!(ys, start_pos.pos.y)
    push!(aim, start_pos.aim)
  end

  return (xs, ys, aim)
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

function visual(xsp, ysp, zs)
    zmin, zmax = minimum(zs), maximum(zs)
    cmap = :viridis
    fig = Figure(resolution=(1366, 768))
    # ax = Axis3(fig, aspect = :data, perspectiveness = 0.5,
    ax = Axis3(fig, aspect = :data, perspectiveness = 1,
               xzpanelcolor= (:black, 0.75), yzpanelcolor= (:black,0.75),
               zgridcolor = :grey, ygridcolor = :grey, xgridcolor = :grey)
    scatter!(ax, xsp, ysp, zs; markersize=log.(zs))
    # ax = Axis(fig, aspect = 1)
    # scatter!(ax, xsp, ysp; markersize=log.(zs, 10))
    fig[1,1] = ax
    fig
end

function main(filename::String)
  dirs = parse_directions(filename)
  # println("Part1: ", part1(dirs))
  xs, ys = part1(dirs)
  println("Part1: ", xs[end] * ys[end])
  xsp, ysp, aim = part2(dirs)
  println("Part2: ", xsp[end] * ysp[end])
  # plot(xs, ys)

  # writedlm("coords.txt", [xs ys], " ")
  # writedlm("coords2.txt", [xsp ysp aim], " ")
  visual(xsp, ysp, aim)
end
