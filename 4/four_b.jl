using IterTools

cd(dirname(@__FILE__))
const lines = open("four.txt", "r") do f
    readlines(f)
end

const StringDict = Dict{String, String}

valid_set = Set(["hcl", "iyr", "eyr", "ecl", "pid", "byr", "hgt"])
valid_keys(d::StringDict) = issubset(valid_set, keys(d))

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
valid_byr(s::String) = length(s) == 4 && 1920 <= parse(Int64, s) <= 2002
valid_byr(d::StringDict) = valid_byr(d["byr"])

# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
valid_iyr(s) = length(s) == 4 && 2010 <= parse(Int64, s) <= 2020
valid_iyr(d::StringDict) = valid_iyr(d["iyr"])

# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
valid_eyr(s) = length(s) == 4 && 2020 <= parse(Int64, s) <= 2030
valid_eyr(d::StringDict) = valid_eyr(d["eyr"])

# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
valid_hgt(s::String) = begin
    m = match(r"^([0-9]{2,3})(in|cm)$", s)
    if m !== nothing
        v,u = m.captures
        h = parse(Int64,v)
        if u == "cm"
            150 <= h <= 193
        else # must be "in"
            59 <= h <= 76
        end
    else
        false
    end
end
valid_hgt(d::StringDict) = valid_hgt(d["hgt"])

# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
valid_hcl(s::String) = nothing !== match(r"^#[a-f,0-9]{6}$", s)
valid_hcl(d::StringDict) = valid_hcl(d["hcl"])

# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
ecls = Set(["amb" "blu" "brn" "gry" "grn" "hzl" "oth"])
valid_ecl(s::String) = s in ecls
valid_ecl(d::StringDict) = valid_ecl(d["ecl"])

# pid (Passport ID) - a nine-digit number, including leading zeroes.
valid_pid(s::String) = nothing !== match(r"^[0-9]{9}$", s)
valid_pid(d::StringDict) = valid_pid(d["pid"])

is_valid(d::StringDict) = (
    valid_keys(d)
    && valid_byr(d)
    && valid_iyr(d)
    && valid_eyr(d)
    && valid_hgt(d)
    && valid_hcl(d)
    && valid_ecl(d)
    && valid_pid(d)
)

parse_line(l::String)::Dict{String,String} =
    Dict(split(s,":") for s in split(l))

join_by_space(l) = join(l, " ")

n = (groupby(!isempty, lines) 
    |> l -> map(join_by_space, l)
    |> l -> filter(!isempty, l)
    |> l -> map(parse_line, l)
    |> s -> map(is_valid, s)
    |> sum)

println(n)
