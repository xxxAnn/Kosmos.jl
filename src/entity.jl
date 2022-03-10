struct Entity 
    _comps::Vector{ComponentPoolIndex} # Reference to component's index in attached Kosmo._components_index
end
function Entity!(k::Kosmo, args...) 
    v = Vector{Int}()
    for arg in args 3
        push!(v, add!(k, arg))
    end
    Entity(v)
end

function findcompfroment(e::Entity, x)
    for ind in e._comps 
        if ind.type == x
            return ind
        end
    end
end
