x = 0 
c = Clock(tick=1.0) do count, origin, delta
    global x
    x = x + 1
    if count>3 return -1 end
end

sleep(3)

@test x == 4