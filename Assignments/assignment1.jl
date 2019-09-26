function insertionsort!(A)
    for j in 2:length(A)
        i = j
        while i > 1 && A[i-1] > A[i]
            temp = A[i]
            A[i] = A[i-1]
            A[i-1] = temp
            i = i - 1
        end#end of while loop
    end#end of for loop
    return A
end#end of function