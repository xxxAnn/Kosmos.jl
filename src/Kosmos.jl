module Kosmos

using Dates, Distributed

export Component,
    system,
    Kosmo,
    Clock

include("component.jl")
include("clock.jl")
# TODO: move type definitions to a separate folder
struct Kosmo 
    _dispatch_index::Dict{Tuple, Function} #// Raw dispatch entries
    _components_index::Vector{Union{<:Component, Nothing}} #// Raw components entries
    _state::Int
    _dispatch_state::Int
    _cached_dispatch::Union{Missing, Function}
end
Kosmo() = Kosmo(Dict(), Vector(), 1, 0, missing)
(k::Kosmo)(args...) = k._dispatch_index[Tuple(typeof.(args))](args...)

function create_dispatch!(k::Kosmo)
    #// Checks if Kosmo has been modified  
    #// since last dispatch cache.
    if k._state>k._dispatch_state
        v = iter(k)
        todos = []
        for c in v
            tup = Tuple(typeof.(c))
            if tup in keys(k._dispatch_index)
                push!(todos, (k._dispatch_index[tup], c))
            end
        end
        k._cached_dispatch = () -> begin 
            for x in todos
                x[1](x[2]...)
            end
        end
        k._dispatch_state = k._state
    end 
    return k._cached_dispatch
end

include("utils.jl")
include("system.jl")

end