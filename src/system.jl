struct System 
    _f::Function
    _raw::Vector{Vector{ComponentPoolIndex}}
    _scheme::Tuple
end

function system!(f::Function, k::Kosmo)
    type_tup = func_types(f)
    s = System(f, create_combinations(type_tup, k._component_pool), type_tup) 
end

"""
Returns the Function's argument types in order.
"""
func_types(f::Function) = Tuple(first(methods(f)).sig.types[2:end]) 