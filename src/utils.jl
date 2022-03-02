# gets all combinations and all their permutations as one Vector
iter(k::Kosmo) = reduce(vcat, collect.(permutations.(combinations((k._components)))))
