function parseboards(lines::Vector{String})::Vector{Matrix{Int}}
  boards = Vector{Matrix{Int}}()

  board = zeros(Int, 5, 5)
  for i = 3:6:length(lines)
    for k=0:4
      nums = parse.(Int, split(lines[i+k]))
      board[k+1, :] .= nums
    end

    push!(boards, board)
    board = zeros(Int, 5, 5)
  end
  return boards
end


function part1(drawer::Vector{Int}, boards::Vector{Matrix{Int}})
  selected = similar(boards)
  n = length(boards)
  for i=1:n
    selected[i] = zeros(5, 5)
  end

  for i = 1:length(drawer)
    for j = 1:n
      ij = findfirst(==(drawer[i]), boards[j])
      if !isnothing(ij)
        selected[j][ij] = 1

        if sum(selected[j][ij[1], :]) == 5 || sum(selected[j][:, ij[2]]) == 5
          s = 0
          for jj in findall(==(0), selected[j])
            s += boards[j][jj]
          end
          return s * drawer[i]
        end
      end
    end
  end
end

function part2(drawer::Vector{Int}, boards::Vector{Matrix{Int}})
  selected = similar(boards)
  states = similar(boards)
  n = length(boards)
  for i=1:n
    selected[i] = zeros(5, 5)
  end
  won_already = Vector{Int}()
  won = Vector{Int}()

  for i = 1:length(drawer)
    for j = 1:n
      ij = findfirst(==(drawer[i]), boards[j])
      if !isnothing(ij)
        selected[j][ij] = 1

        if (sum(selected[j][ij[1], :]) == 5 || sum(selected[j][:, ij[2]]) == 5) &&
          !(j in won_already)

          push!(won, drawer[i])
          push!(won_already, j)
          states[j] = copy(selected[j])
        end
      end
    end
  end

  states[won_already[end]]
  s = 0
  for jj in findall(==(0), states[won_already[end]])
    s += boards[won_already[end]][jj]
  end
  return s * won[end]
end


function main(filename::String)
  drawer = parse.(Int, split(readline(filename), ','))
  lines = readlines(filename)
  boards = parseboards(lines)

  println("Part1: ", part1(drawer, boards))
  println("Part2: ", part2(drawer, boards))
end
