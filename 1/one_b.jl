using BenchmarkTools

cd(dirname(@__FILE__))
const lines = open("one.txt", "r") do f
    readlines(f)
end

ints = map(lines) do l     # don't make this const, otherwise @btime does not give valid results
    parse(Int64, l)
end
const len = length(ints)   # but this can be const and makes a big difference for the benchmarks

x = y = z = 0
@btime for i in 1:len
    for j in i+1:len
        for k in j+1:len
            if ints[i]+ints[j]+ints[k] == 2020
                global x = ints[i]
                global y = ints[j]
                global z = ints[k]
                break
            end
        end
    end
end

println(x," ", y, " ", z, " ", x+y+z, " ", x*y*z)

# More functional-style version that uses list comprehensions as generators for the indices
pair_product(a,b) = ((i,j) for i in a:b for j in i+1:b)
triple_product(a,b) = ((i,j,k) for i in a:b for (j,k) in pair_product(i+1,b))

x = y = z = 0
@btime begin
    (i,j,k) = first((i,j,k) for (i,j,k) in triple_product(1, len) if ints[i]+ints[j]+ints[k] == 2020)
    global x = ints[i]
    global y = ints[j]
    global z = ints[k]
end
println(x," ", y, " ", z, " ", x+y+z, " ", x*y*z)
