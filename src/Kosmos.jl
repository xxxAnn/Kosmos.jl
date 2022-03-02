module Kosmos

using Dates, Distributed

export Component,
    system,
    Kosmo,
    Clock

include("component.jl")
include("clock.jl")
include("kosmo.jl")
include("system.jl")

end