module Kosmos

using Dates, Distributed

export Component,
    system,
    Kosmo,
    Clock

include("component.jl")
include("entity.jl")
include("clock.jl")
include("kosmo.jl")
include("system.jl")
include("smartlock.jl")

end