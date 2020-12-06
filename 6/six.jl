using IterTools

cd(dirname(@__FILE__))
lines = open("six.txt", "r") do f
    readlines(f)
end

n1 = (groupby(!isempty, lines) 
    |> l -> map(join, l)
    |> l -> filter(!isempty, l)
    |> l -> map(Set, l)
    |> s -> map(length, s)
    |> sum)

println(n1)

n2 = (groupby(!isempty, lines)
    |> l -> collect(l)
    |> l -> filter(!=([""]), l)
    |> l -> map(x -> [Set(s) for s in x], l)
    |> l -> map(s -> intersect(s...), l)
    |> s -> map(length, s)
    |> sum)

println(n2)
