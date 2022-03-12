struct Entity 
    _comps::Vector{ComponentPoolIndex} # Reference to component's index in attached Kosmo._components_index
end
function Entity!(k::Kosmo, args...) 
    v = Vector{ComponentPoolIndex}()
    for arg in args
        push!(v, add!(k, arg))
    end
    for set in k._component_pool._sets
        make_set(k, set, v)
    end
    Entity(v)
end

function make_set(k::Kosmo, set::Type{ComponentSet{T}}, v::Vector{ComponentPoolIndex}) where T
    add!(k, ComponentSet([filter(z->z.type==x, v)[1] for x in T]...))
end