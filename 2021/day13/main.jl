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

function fold_paper(paper, folds, nfolds)
    fold_axes = map(x->(x[1][end], parse(Int, x[2])), split.(folds, "="))
    new_paper = deepcopy(paper)
    old_paper = deepcopy(new_paper)

    dims = size(paper)

    for i = 1:nfolds
        if fold_axes[i][1] == 'y'
            new_paper = reverse(new_paper[fold_axes[i][2]+2:end, :], dims=1)
            dims = (div(dims[1], 2), dims[2])
        elseif fold_axes[i][1] == 'x'
            new_paper = reverse(new_paper[:, fold_axes[i][2]+2:end], dims=2)
            dims = (dims[1], div(dims[2], 2))
        end
        for (j, col) in enumerate(eachcol(new_paper))
            for (i, row) in enumerate(col)
                if new_paper[i, j] == '#' && old_paper[i, j] == '#'
                    new_paper[i, j] = '#'
                elseif new_paper[i, j] != old_paper[i, j]
                    new_paper[i, j] = '#'
                end
            end
        end
        # display_mat(new_paper)
        # println("-------------")
        old_paper = deepcopy(new_paper)
    end
    return (dims, new_paper)
end

function part1(folded_paper)
    return count(==('#'), folded_paper)
end

function display_mat(m)
    dims = size(m)
    for i in 1:dims[1]
        for j in 1:dims[2]
            print(m[i, j])
        end
        println()
    end
end

function display_mat(m, dims)
    for i in 1:dims[1]
        for j in 1:dims[2]
            print(m[i, j])
        end
        println()
    end
end

function main(filename::String)
    lines = split(join(readlines(filename, keep=true)), "\n\n")
    pos = map.(x->parse.(Int, x), split.(split(lines[1]), ","))

    paper = create_paper(pos)
    folds = split(lines[2], "\n", keepempty=false)
    println("Paper dimensions: ", size(paper))

    d, folded_paper_once = fold_paper(paper, folds, 1)
    println("Part1: ", part1(folded_paper_once))
    d, r = fold_paper(paper, folds, length(folds))
    println("Part2: ")
    display_mat(r)
end
