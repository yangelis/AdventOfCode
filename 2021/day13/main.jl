function create_paper(pos)
    # find the dimensions
    max_i = 0
    max_j = 0
    for p in pos
        if p[1] > max_j
            max_j = p[1]
        end
        if p[2] > max_i
            max_i = p[2]
        end
    end

    # positions start from one so:
    max_i += 1
    max_j += 1

    paper = Matrix{Char}(undef, max_i, max_j)
    fill!(paper, '.')

    for p in pos
        paper[p[2]+1, p[1]+1] = '#'
    end

    return paper
end

function part1(paper, folds)
    fold_axes = map(x->(x[1][end], parse(Int, x[2])), split.(folds, "="))
    new_paper = deepcopy(paper)

    for fold in fold_axes
        if fold[1] == 'y'
            new_paper = reverse(paper[fold[2]+2:end, :], dims=1)
        elseif fold[1] == 'x'
            new_paper = reverse(paper[:, fold[2]+2:end], dims=2)
        end
        for (j, col) in enumerate(eachcol(new_paper))
            for (i, row) in enumerate(col)
                if new_paper[i, j] == '#' && paper[i, j] == '#'
                    new_paper[i, j] = '#'
                elseif new_paper[i, j] != paper[i, j]
                    new_paper[i, j] = '#'
                end
            end
        end

        return count(==('#'), new_paper)
    end
end

function main(filename::String)
    lines = split(join(readlines(filename, keep=true)), "\n\n")
    pos = map.(x->parse.(Int, x), split.(split(lines[1]), ","))

    paper = create_paper(pos)
    folds = split(lines[2], "\n", keepempty=false)

    println("Part1: ", part1(paper, folds))
end
