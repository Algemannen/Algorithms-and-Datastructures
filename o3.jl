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
        left  = mergesort(x[1:hlen,:], coordinate)
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
    median = (size(x)[1] + 1)/2
    ltarget = median - delta
    htarget = median + delta

    println(bsearchn(x, 1, size(x)[1], ltarget))
end
function bsearchn(x, start, stop, target)
    println(start)
    println(stop)
    if(start-stop == 1)
        if(x[start] < target)
            return stop
        else
            return start
        end
    end

    rangedelta = stop - start
    halfrange = trunc(Int, floor(rangedelta/2))
    println(halfrange)
    if(x[start + halfrange] < target)
        return bsearchn(x, start, start+halfrange, target)
    elseif(x[start+halfrange] > target)
        return bsearchn(x, start+halfrange, stop, target)
    else
        return x[start+halfrange]
    end
end
binaryintervalsearch([1 2; 2 3; 3 0; 4 0; 5 1], 1.5, 1)