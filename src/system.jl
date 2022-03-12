function system!(f::Function, k::Kosmo)
    type_tup = func_types(f)
    v = create_combinations(type_tup, k._component_pool)
    s = System(f, v, type_tup) 
    push!(k._system_pool, s)
end

"""
Returns the Function's argument types in order.
"""
func_types(f::Function) = Tuple(first(methods(f)).sig.types[2:end]) 