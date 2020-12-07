function main(filename::String)
    pos = readlines(filename) |>
            x->map(f->replace(f, 'B'=>'1'), x) |>
            x->map(f->replace(f, 'F'=>'0'), x) |>
            x->map(f->replace(f, 'R'=>'1'), x) |>
            x->map(f->replace(f, 'L'=>'0'), x) |>
            x->map(f->(row=parse(Int64, f[1:end-3], base=2),
                       col=parse(Int64, f[end-2:end], base=2)), x)

    ids = pos |> x->map(f->f.row*8+f.col, x)
    println("Part1: ", maximum(ids))

    my_seat = filter(x -> !(x in ids), minimum(ids):maximum(ids))[1]
    println("Part2: ", my_seat)
end
