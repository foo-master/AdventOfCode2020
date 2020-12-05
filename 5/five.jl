cd(dirname(@__FILE__))
lines = open("five.txt", "r") do f
    readlines(f)
end

b = Dict('F' => '0', 'B' => '1', 'L' => '0', 'R' => '1')
bin_str(s::String)::String =
    join([b[c] for c in s])

row(s::String) = parse(Int8, s[1:7], base=2)
seat(s::String) = parse(Int8, s[8:10], base=2)
id(s::String) = row(s) * 8 + seat(s)

ids = map(id ∘ bin_str, lines)
min_id = minimum(ids)
max_id = maximum(ids)
all_ids = Set(min_id:max_id)
my_seat = setdiff(all_ids, ids)

println(max_id)
println(my_seat)
