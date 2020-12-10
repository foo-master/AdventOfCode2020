using Memoize
using BenchmarkTools

cd(dirname(@__FILE__))
lines = open("ten.txt", "r") do f
    readlines(f)
end
values = map(x -> parse(Int, x), lines)

push!(values, 0)
push!(values, maximum(values) + 3)

sort!(values)
d = diff(values)

j1s = count(==(1),d)
j3s = count(==(3),d)
println(j1s)
println(j3s)
println(j1s*j3s)
println()

println(values)

# using Memoize feels like cheating, but who cares ...
@memoize function chain1(values, i)
    len = length(values)
    if i == len
        return 1
    else
        value = values[i]
        j = i + 1
        acc = 0
        while (j <= len) && ((values[j] - value) <= 3)
            acc += chain1(values, j)
            j += 1
        end
        return acc
    end
end
n1 = 0
@btime n1 = chain1(values, 1)
println(n1)


# OK, let's also do it with manually memoizing the results
cache = Dict{Int64,Int64}()

function chain2(values, i)
    len = length(values)
    if i == len
        return 1
    else
        value = values[i]
        j = i + 1
        acc = 0
        while (j <= len) && ((values[j] - value) <= 3)
            if !haskey(cache, j)
                c = chain2(values, j)
                cache[j] = c
            else
                c = cache[j]
            end
            acc += c
            j += 1
        end
        return acc
    end
end

n2 = 0
@btime n2 = chain2(values,1)
println(n2)
