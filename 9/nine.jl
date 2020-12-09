using IterTools

cd(dirname(@__FILE__))
lines = open("nine.txt", "r") do f
    readlines(f)
end
values = map(x -> parse(Int, x), lines)

const N = 25
deq = values[1:N]

pair_sums(v) = (i+j for (i,j) in subsets(v,2))

function check_sum(value, deq)
    for _ in (s for s in pair_sums(deq) if s == value)
        return true
    end

    return false
end

weak = 0
len = length(values)
for n in N+1:len
    value = values[n]
    if !check_sum(value, deq)
        global weak = value
        break
    end
    popfirst!(deq)
    push!(deq, value)
end

println(weak)

function acc(init)
    acc = init
    x -> (acc += x; acc)
end

# cumsum() is eager, but we need a lazy version for takewhile()
lazy_cumsum(values) =
    (acc(0)(x) for x in values)

function sum_range(limit, n, m, values)
    sum = 0
    count = 0
    for x in takewhile(x -> x <= limit, lazy_cumsum(values[n:m]))
        sum = x
        count += 1
    end
    (sum == limit, n, n + count - 1)
end

found, i, j = first(filter(x -> x[1] == true, [sum_range(weak, i, len, values) for i in 1:len-1]))
s = values[i:j]
println(s)
println(sum(s))
println(minimum(s) + maximum(s))
