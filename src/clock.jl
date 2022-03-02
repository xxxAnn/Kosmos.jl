# A Rudimentary clock built with papers and scissors
mutable struct Clock
    local_origin::DateTime # Time of clock creation
    _last::Millisecond # last pass of _tick
    delta::Millisecond # Cached version of Millisecond(now()-Clock.local_origin)
    tick::Float64 # Frequency of the clock in hertz
    _tick::Float64 # 1000/tick
    on_fire::Function # Handle for when the clock fires
end

function Clock(f::Function; tick::Float64=100.0) # default to 100hz
    if tick>1000.0 error("Tick must be below 1000hz") end
    c = Clock(now(), Millisecond(0), Millisecond(0), tick, 1000.0/tick, f) 
    @spawn begin 
        clock_running = true
        count = 0
        @sync while clock_running 
            c.delta = Millisecond(now()-c.local_origin)
            if c.delta.value>c._tick+c._last.value
                count+=1
                if f(count, Millisecond(round(Int, datetime2unix(c.local_origin))), c.delta) == -1 
                    clock_running = false 
                end
                c._last = c.delta
            end
        end
    end
end
