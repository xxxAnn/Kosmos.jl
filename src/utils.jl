# this assumes the function doesn't contain any kwargs/slurping (TODO: EXPLICITLY ERROR IF THEY DO)
function inspect_func(e::Expr) 
    s = string(e.args[1])
    name = Symbol(s[1:(findfirst("(", s).start)-1])
    params = replace.(string.(split(s[(findfirst("(", s).start)+1:end-1], ",")), " "=>"")
    return (name, (x -> if !(occursin("::", x)) return x*"::Any" else return x end).(params))
end

function find_argtypes(args::Vector{String}) # -> Vector{<:Type}
    return map(a -> eval(Symbol(split(a, "::")[2])), args)
end

# very inefficient, gets all combinations and all their permutations
iter(k::Kosmo) = reduce(vcat, collect.(permutations.(combinations((typeof.(k._components))))))
