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
    _component_pool::ComponentPool #// Raw components entries
    _system_pool::Vector{System}
end
Kosmo() = Kosmo(ComponentPool(), Vector())

function run_systems(k::Kosmo) 
    for sys in k._system_pool 
        for r in sys._raw
            # These are ordered
            args = [k._component_pool[x] for x in r] 
            sys._f(args...)
        end
    end
end

function add!(k::Kosmo, cmp::Component)
    c = k._component_pool
    TT = typeof(cmp)
    # update system pool
    for sys in k._cached_dispatch
        if TT in sys._scheme
            scheme = filter(x-> x!=T, sys._scheme)
            t = create_pair_combinations(create_combinations(scheme, k._component_pool), [cmp])
        end
        append!(sys._raw, collect.(t))
    end
    if TT in keys(c._raw)
        push!(c._raw[TT], cmp)
    else 
        c._raw[TT] = [cmp]
    end
    return ComponentPoolIndex(TT, length(c._raw[TT]))
end

function create_dispatch!(k::Kosmo)
    #// Checks if Kosmo has been modified  
    #// since last dispatch cache.
end

include("system.jl")

end