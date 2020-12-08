using IterTools

cd(dirname(@__FILE__))
lines = open("eight.txt", "r") do f
    readlines(f)
end

parse_op(c::String) =
    let (op, val) = split(c)
        (string(op), parse(Int64, val))
    end

p = map(parse_op, lines)

function check_loop(pc::Int64, acc::Int64, executed::Array{Bool,1})
    if executed[pc]
        throw(ErrorException("Infinite loop at $pc: acc = $acc")) 
    end
    executed[pc] = true
end

function accumulate(x::Int64, pc::Int64, acc::Int64, executed::Array{Bool,1})
    check_loop(pc, acc, executed)

    pc+1, acc+x
end

function noop(_::Int64, pc::Int64, acc::Int64, executed::Array{Bool,1})
    check_loop(pc, acc, executed)

    pc+1, acc
end

function jump(x::Int64, pc::Int64, acc::Int64, executed::Array{Bool,1})
    check_loop(pc, acc, executed)

    pc+x, acc
end

cpu = Dict(
    "acc" => accumulate,
    "nop" => noop,
    "jmp" => jump
    )

const Program = Array{Tuple{String,Int64},1}

function make_execute(p::Program)
    executed = fill(false, length(p))
    function execute((pc,acc)::Tuple{Int64,Int64})
        (i,v) = p[pc]
        pc, acc = cpu[i](v, pc, acc, executed)
    end
end

exec = make_execute(p)

try
    for _ in iterated(exec, (1,0)) end
catch e
    println(e)
end
