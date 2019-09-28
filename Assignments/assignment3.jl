# o1
# x og y er to sorterte tabeller, coordinate angir koordinat
function mergearrays(x,y,coordinate)
    if(y==0) return x end
    xsize = size(x)[1]
    ysize = size(y)[1]
    i = 1
    j = 1
    retval = Array{Int64}(undef, xsize + ysize, 2)
    while(i <= xsize || j <= ysize)

        if(j > ysize || i <= xsize && x[i,coordinate] <= y[j,coordinate])
            retval[i+j-1,:] = x[i,:]
            i = i+1
        else 
            retval[i+j-1,:] = y[j,:]
            j = j+1
        end
    end
    return retval
end

# x er en usortert tabell, coordinate angir koordinat vi skal sortere langs
function mergesort(x, coordinate)
    len  = size(x)[1]
    hlen = trunc(Int, floor(size(x)[1]/2))
    retval = nothing
    if(len > 1)
        # don't ask, you won't get any answers
        left  = mergesort(x[1:hlen,:], coordinate) # x[start:stop,:]
        right = mergesort(x[hlen+1:len,:], coordinate)
        retval = mergearrays(left, right, coordinate)
    else
        retval = x
    end
    return retval
end
# mergesort([1 2; 4 6; 2 2; 2 1; 2 2],2)



# o2
function binaryintervalsearch(x, delta, coordinate)
    # lage median
    median = (x[trunc(Int, floor((size(x)[1] + 1)/2)), coordinate] + x[trunc(Int, ceil((size(x)[1] + 1)/2)), coordinate])/2
    
    # high/low target
    ltarget = median - delta
    htarget = median + delta

    # sjekke om vi kommer til å få et gyldig svar
    if(x[trunc(Int, floor(size(x)[1]/2))] < ltarget && x[trunc(Int, floor(size(x)[1]/2))+1] > htarget)
        return (-1, -1)
    end

    # hvis vi får gyldig svar, finn det og returner det
    return (bsearchn(x, 1, size(x)[1], ltarget, coordinate, true),
            bsearchn(x, 1, size(x)[1], htarget, coordinate, false))
end
function bsearchn(x, start, stop, target, coordinate, negative)

    # hvis start of stopp er ved siden av hverandre, må det være en av dem
    if(stop-start <= 1)
        if(negative && x[start, coordinate] < target)
            return stop
        elseif(negative)
            return start
        elseif(!negative && x[stop, coordinate] > target)
            return start
        else
            return stop
        end
    end
    
    # normalt binærsøk
    rangedelta = stop - start
    halfrange = trunc(Int, floor(rangedelta/2))
    if(x[start + halfrange, coordinate] > target)
        return bsearchn(x, start, start+halfrange, target, coordinate , negative)
    elseif(x[start+halfrange, coordinate] < target)
        return bsearchn(x, start+halfrange, stop, target, coordinate , negative)
    else
        return start+halfrange
    end
end
# println(binaryintervalsearch([1.0 0.0; 2.0 0.0; 3.0 0.0; 4.0 0.0], 0.1, 1))




# o3
function bruteforce(x)
    # startverdi som mest sannsynlig er større enn den minste avstanden
    retval = 1000000

    # for alle elementer i x
    for i in 1:size(x)[1]

        # sjekk mot alle elementer som ikke er sjekket
        for j in i+1:size(x)[1]

            # avstanden mellom to koordinater
            testval = sqrt(abs(x[i,1]-x[j,1])^2 + abs(x[i,2]-x[j,2])^2)

            # sjekk hvilken av verdiene som er mist
            retval = if(testval < retval) testval else retval end
        end
    end

    return retval
end
# println(bruteforce([-1.0 -1.0; 1.0 1.0; 100.0 100.0]))



# o4
function splitintwo(x,y)
    # x/y left/right
    xl = x[1:trunc(Int, ceil(size(x)[1]/2)),:]
    xr = x[  trunc(Int, ceil(size(x)[1]/2))+1:size(x)[1],:]
    yl = Array{Float64}(undef, size(xl)[1], 2)
    yr = Array{Float64}(undef, size(xr)[1], 2)

    # indexes
    yli= 1
    yri= 1
    i = 1
    xx = size(xl)[1]

    # dict to save y-values for when splitting is hard
    dict = Dict{Float64,Float64}()
    median = (x[trunc(Int, floor((size(x)[1] + 1)/2)), 1] + x[trunc(Int, ceil((size(x)[1] + 1)/2)), 1])/2
    while(xx>0 && xl[xx] == median)
        if(haskey(dict, xl[xx]))
            dict[xl[xx, 2]] += 1
        else
            dict[xl[xx, 2]] = 1
        end
        xx-= 1
    end
    
    # put the correct values in the y-arrays
    while(yli <= size(yl)[1] || yri <= size(yr)[1])
        # stupid long if-sentence
        # checks if there's space in the array
        checkSpace = (yri > size(yr)[1] || yli <= size(yl)[1])
        # logic for if the dict is relevant
        ckeckIfDictIsRelevant = (y[i,1]==median && haskey(dict, y[i,2]) && dict[y[i,2]] > 0 || !(y[i,1]==median))
        # since x is also sorted, we can use that to partially know which side to put it in
        checkThatItsNotTooLarge = y[i,1]<=xl[size(xl)[1],1]
        if(checkSpace && ckeckIfDictIsRelevant && checkThatItsNotTooLarge)
            
            # updates the dict if it's nessecary
            if(haskey(dict, y[i,2]) && dict[y[i,2]] > 0)
                dict[y[i,2]] -= 1
            end

            yl[yli,:] = y[i,:]
            yli += 1
        else 
            yr[yri,:] = y[i,:] 
            yri += 1
        end
        i += 1
    end
    # println(xl, xr)
    # println(yl, yr)
    return (xl, xr, yl, yr)
end

x1 = [-1.0 -1.0; -1.0 1.0; -1.0 0.0; 0.0 0.0; 2.0 5.0; 3.0 5.0; 4.0 5.0; 5.0 4.0; 10.0 0.0]
y1 = [-1.0 -1.0; -1.0 1.0; -1.0 0.0; 0.0 0.0; 10.0 0.0; 5.0 4.0; 2.0 5.0; 3.0 5.0; 4.0 5.0]
x2 = [5.0 5.0; 5.0 10.0; 5.0 9.0; 5.0 1.0; 5.0 2.0]
y2 = [5.0 1.0; 5.0 2.0; 5.0 5.0; 5.0 9.0; 5.0 10.0]

# println(splitintwo(x1, y1))