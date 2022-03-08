# Lock state of a specific Component
# also has metadata regarding whether its 
# locked only for specific operations
struct LockState 
    locked::Bool
    _read::Bool # true by default (if false no read permission even if locked)
    _write::Bool # true by default (if false no write permission even if locked)
end

# A smart, distributed smart lock built out of bamboo 
# and sticks I found in the streets of los angeles
# This basically locks used components
struct SmartLock
    r::Dict{ComponentPoolIndex, LockState}
end