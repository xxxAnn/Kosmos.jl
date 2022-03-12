k = Kosmo()

mutable struct Health <: Component
    v::Int 
end

ply = Entity!(k, Health(100))

system!(k) do x::Health
    x.v = x.v-3
    println(x.v)
end 

t = Kosmos.run_systems(k)

