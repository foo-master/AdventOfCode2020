cd(dirname(@__FILE__))
const lines = open("two.txt", "r") do f
    readlines(f)
end

struct Password
    r::Tuple{Int64, Int64}
    c::Char
    p::String
end

function parse_passwords(l::String)
    r = match(r"^([0-9]+)-([0-9]+) ([a-z]?): ([a-z]+)", l)
    Password((parse(Int64, r[1]), parse(Int64, r[2])), r[3][1], r[4])
end

check_policy_a(p::Password) = p.r[1] <= count(c -> c == p.c, p.p) <= p.r[2]
check_policy_b(p::Password) = (p.p[p.r[1]] == p.c) != (p.p[p.r[2]] == p.c)

valid_a = sum(map(check_policy_a ∘ parse_passwords, lines))
println(valid_a)

valid_b = sum(map(check_policy_b ∘ parse_passwords, lines))
println(valid_b)
