using IterTools

cd(dirname(@__FILE__))
lines = open("three.txt", "r") do f
    lines::Array{Array{Int64,1},1} = []
    for l in eachline(f)
        line = [(c == '#' ?  1 : 0) for c in l]
        push!(lines, line)
    end
    lines
end

function make_slide(right::Int64, down::Int64, m::Int64)
    function slide((x, y)::Tuple{Int64, Int64})::Tuple{Int64, Int64}
        x̂ = (x + right - 1) % m + 1 # OK, here it is really annoying that indices in Julia start at 1 ...
        ŷ = y + down
        x̂, ŷ
    end
end

route(x::Int64, y::Int64, r::Int64, d::Int64, m::Int64, l::Int64) =
    takewhile((_,y)::Tuple{Int64, Int64} -> y <= l, iterated(make_slide(r, d, m), (x, y)))

function make_tree(lines::Array{Array{Int64,1},1})
    tree((x, y)::Tuple{Int64, Int64})::Bool = lines[y][x]
end

trees(x::Int64, y::Int64, right::Int64, down::Int64, lines::Array{Array{Int64,1},1}) =
    sum(map(make_tree(lines), route(x, y, right, down, length(lines[1]), length(lines))))

t1 = trees(1, 1, 1, 1, lines)
t2 = trees(1, 1, 3, 1, lines)
t3 = trees(1, 1, 5, 1, lines)
t4 = trees(1, 1, 7, 1, lines)
t5 = trees(1, 1, 1, 2, lines)

println(t2)
println(t1*t2*t3*t4*t5)
