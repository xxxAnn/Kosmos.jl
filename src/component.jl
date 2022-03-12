"""
Abstract type for all Components
"""
abstract type Component end

struct ComponentPoolIndex
    type::Type{<:Component}
    index::Int
end
ComponentPoolIndex(t::Component, i::Int) = ComponentPoolIndex(typeof(t), i)

struct ComponentSet{T<:Tuple} <: Component
    _raw::Vector{ComponentPoolIndex}
end

struct ComponentPool 
    _raw::Dict{Type{<:Component}, Vector{Component}}
    _sets::Vector{Type{<:ComponentSet}}
end
ComponentPool()  = ComponentPool(Dict(), Vector())
Base.getindex(c::ComponentPool, t::Type{<:Component}, i::Int) = c._raw[t][i]
Base.getindex(c::ComponentPool, t::Type{T}) where T<:Component = if t in keys(c._raw) c._raw[t] else Vector() end
function Base.getindex(c::ComponentPool, i::ComponentPoolIndex) 
    res = getindex(c, i.type, i.index)
    if typeof(res) <: ComponentSet 
        res = Tuple(c[v] for v in res._raw)
    end
    res
end

ComponentSet(T::Vararg{Type{<:Component}}) = ComponentSet{T}
ComponentSet(v::Vararg{ComponentPoolIndex}) = ComponentSet(collect(v))
ComponentSet{T}(args...) where T<:Tuple = ComponentSet(args...)
function ComponentSet(c::ComponentPool, v::Vararg{Tuple{<:Component}}) 
    set = ComponentSet(v)
    if !(v in c._sets) push!(c._sets, set) end
end

function indexify(v::Vector{Component}) 
    i = 1
    a = []
    for x in v
        push!(a, ComponentPoolIndex(x, i))
        i+=1
    end
    a
end

tupify(v) = (v,)
veccify(v) = [v]
#+------------------------------------------------------+
#| This is the main idea                                |
#| Combinations are only generated if needed            |
#+------------------------------------------------------+
function create_combinations(scheme, c::ComponentPool)   
    arrs = []
    # Get a ComponentPoolIndex version of the array in the ComponentPool
    # for the Type of each element in the scheme.
    # since we're iterating the scheme in order, 
    # there is no need to worry about passing the
    # args to the system function in the correct order.
    for x in scheme
        # If one of these has no components defined for its type,
        # then the overall combination will just be empty,
        # so we might as well just return []
        if c[x] == [] return c[x] end
        push!(arrs, indexify(c[x])) 
    end
    # if arrs is length 1 then a will be returned straight away,
    # so we need each of its elements to be a tuple for compat.
    a = veccify.(first(arrs))
    k = 2
    # Create pairs until you reach the end of the scheme.
    # This will be ordered since arrs is based on scheme.
    while k<=length(arrs)
        a = create_pair_combinations(a, arrs[k])
        k+=1
    end
    return a
end
create_pair_combinations(a, b) = reduce(vcat, [[ae..., be...] for ae in a for be in b])
