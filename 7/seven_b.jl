cd(dirname(@__FILE__))
lines = open("seven.txt", "r") do f
    readlines(f)
end

parse_bag(c::String) =
    let l = split(c)
        (parse(Int64,(l[1])), l[2]*" "*l[3])
    end

parse_line(l::String) =
    let (k,v) = split(l, "contain")
        (string(strip(k)[1:end-5]), [parse_bag(string(strip(c))) for c in split(v, ",") if c != " no other bags."])
    end

d = Dict(map(parse_line, lines))

function recurse_bags(d, (n,b))
    if isempty(d[b])
        n
    else
        n * (1 + sum(map(x -> recurse_bags(d,x), d[b])))
    end
end

n = recurse_bags(d, (1, "shiny gold")) - 1

println(n)
