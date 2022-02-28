module Kosmos

include("utils.jl")
include("component.jl")

struct Kosmo 
    _dispatch_types::Vector{Vector{<:Type}} #// Vector{<:Type, <:Type, etc...} for types to dispatch on
    _components::Vector{<:Component}
end

end