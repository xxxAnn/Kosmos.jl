x = 0 
c = Clock(tick=10.0) do count, origin, delta
    global x
    x = x + 1
    if count>10 return -1 end
end

sleep(1)

@test x == 11