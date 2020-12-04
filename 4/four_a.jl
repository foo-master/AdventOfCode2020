using IterTools

cd(dirname(@__FILE__))
const lines = open("four.txt", "r") do f
    readlines(f)
end

parse_line(l::String)::Array{String} =
    [split(s,":")[1] for s in split(l)]

join_by_space(l) = join(l, " ")

valid_set = Set(["hcl", "iyr", "eyr", "ecl", "pid", "byr", "hgt"])
is_valid(s) = issubset(valid_set, s)

n = (groupby(!isempty, lines) 
    |> l -> map(join_by_space, l)
    |> l -> filter(!isempty, l)
    |> l -> map(parse_line, l)
    |> s -> map(is_valid, s)
    |> sum)

println(n)
