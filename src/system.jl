function system!(f::Function, k::Kosmo)
    type_tup = func_types(f)
    k._dispatch_index[type_tup] = f
end

"""
Returns the Function's argument types in order.
"""
func_types(f::Function) = Tuple(first(methods(f)).sig.types[2:end]) 