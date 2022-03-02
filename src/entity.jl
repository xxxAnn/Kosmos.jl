struct Entity 
    _comps::Vector{Int} # Reference to component's index in attached Kosmo._components_index
end
function Entity!(k::Kosmo, args...) 
    v = Vector{Int}()
    for arg in args 
        push!(k._components_index, arg)
        push!(v, length(k._components_index))
        # Renders cached dispatch obsolete
        k._state += k._cached_dispatch+1
    end
    Entity(v)
end