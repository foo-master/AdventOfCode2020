cd(dirname(@__FILE__))
lines = open("seven.txt", "r") do f
    readlines(f)
end

parse_bag(c::String) =
    c[findfirst(isequal(' '), c) + 1:findlast(isequal(' '), c) - 1]

parse_line(l::String) =
    let (k,v) = split(l, "contain")
        bags = filter(!isempty, [c == " no other bags." ? "" : parse_bag(string(strip(c))) for c in split(v, ",")])
        (string(strip(k)[1:end-5]), Set(bags))
    end

d = Dict(map(parse_line, lines))

function recurse_bags(d, s::Set{String})
    if s == Set(["shiny gold"]) || isempty(s)
        s
    else
        recurse_bags(d, union((e == "shiny gold" ? Set([e]) : d[e] for e in s if !isempty(e))...))
    end
end

n = count(x -> x == Set(["shiny gold"]), map(x -> recurse_bags(d, x), values(d)))

println(n)
