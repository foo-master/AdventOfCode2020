lines = open("one.txt", "r") do f
    readlines(f)
end

ints = map(lines) do l
    parse(Int64, l)
end

len = length(ints)
for i in 1:len
    for j in i+1:len
        x = ints[i]
        y = ints[j]
        if x+y == 2020
            println(x," ", y, " ", x+y, " ", x*y)
            break
        end
    end
end
