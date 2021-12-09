function ismin_neighbor(v, heatmap::Matrix{Int}, r, c, nr, nc)
  @inbounds for (pi, pj) in [[1,0], [0,1], [-1,0], [0,-1]]
    ii, jj = (r + pi, c + pj)
    if 1 <= ii && ii <= nr && 1 <= jj && jj <= nc
      if heatmap[ii, jj] <= v
        return false
      end
    end
  end
  return true
end

function part1(heatmap::Matrix{Int})
  h, w = size(heatmap)
  result = 0
  @inbounds for (c, col) in enumerate(eachcol(heatmap)) 
    @inbounds for (r, row) in enumerate(col)
      min_found = ismin_neighbor(row, heatmap, r, c, h, w)

      if min_found
        result += row + 1
      end
    end
  end
  result
end

function part1_matrix(heatmap::Matrix{Int})
  h, w = size(heatmap)
  result = 0
  win = Matrix{Int}(undef, 3, 3)
  win[1,:] = [10, 1, 10]
  win[2,:] = [1, 10, 1]
  win[3,:] = [10, 1, 10]
  c = Matrix{Int}(undef, 3, 3)
  c[1,:] = [10, 0, 10]
  c[2,:] = [0, 10, 0]
  c[3,:] = [10, 0, 10]

  result = 0
  @inbounds for j=2:w-1
   @inbounds for i=2:h-1
      a = win .* heatmap[i-1:i+1, j-1:j+1] .+ c
      if minimum(a) > heatmap[i,j]
        result += heatmap[i,j] + 1
      end
    end
  end
  result
end

function main(filename::String)
  lines = readlines(filename)

  ncols = length(lines[1])
  nrows = length(lines)

  heatmap = zeros(Int, nrows, ncols)

 @inbounds for i=1:nrows
  @inbounds for j=1:ncols
      heatmap[i,j] = parse(Int, lines[i][j])
    end
  end

  println("Part1: ", part1(heatmap))


  ncols += 2
  nrows += 2

  heatmap_pad = zeros(Int, nrows, ncols)
  fill!(heatmap_pad, 10)
  @inbounds for i=1:nrows-2
    @inbounds for j=1:ncols-2
      heatmap_pad[i+1,j+1] = heatmap[i,j]
    end
  end
  println("Part1 again: ", part1_matrix(heatmap_pad))
  
end
