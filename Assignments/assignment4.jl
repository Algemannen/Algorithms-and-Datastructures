# o1
function countingsortletters(A,position)
    B = zeros(Int64, 26)
    # B is [0, 0, 0, 0, ..., 0]
    
    for i in 1:length(A)
        B[chartodigit(A[i][position])] += 1
    end
    # B is now a map (B[character] => total count of said character)

    for i in 2:length(B)
        B[i] += B[i-1]
    end
    # B[Char] => total count of characters from 'a', includes count of Char
    # This is also the last possible place Char can be in a sorted list

    C = Array{String}(undef, length(A))
    for i in length(A):-1:1
        C[B[chartodigit(A[i][position])]] = A[i]
        B[chartodigit(A[i][position])] -= 1
    end
    # B is used with the input characters as keys to know where to put the strings
    return C
end

function chartodigit(character)
    #Dette er en hjelpefunksjon for å få omgjort en char til tall
    #Den konverterer 'a' til 1, 'b' til 2 osv.
    #Eksempel: chartodigit("hei"[2]) gir 5 siden 'e' er den femte bokstaven i alfabetet.

    return Int(character) - 96
end
# countingsortletters(["ccc", "cba", "ca", "ab", "abc"], 2)


# o2
# Literally the same code but length(A[i])+1 instead of chartodigit(A[i][position])
# +1 is because empty strings exists and making B 0-indexed is too much work
# length(B) is also 200 becasue long strings exist
function countingsortlength(A)
    B = zeros(Int64, 200)
    
    for i in 1:length(A)
        B[length(A[i])+1] += 1
    end

    for i in 2:length(B)
        B[i] += B[i-1]
    end

    C = Array{String}(undef, length(A))
    for i in length(A):-1:1
        C[B[length(A[i])+1]] = A[i]
        B[length(A[i])+1] -= 1
    end
    return C
end

# countingsortlength(["bbbb", "", "aa", "aaaa", "ccc"])



# o3
# Modified for when position > length(A[i])
function countingsortletters2(A,position)
    B = zeros(Int64, 27)
    
    for i in 1:length(A)
        if(position > length(A[i]))
            B[1] += 1
        else
            B[chartodigit2(A[i][position])] += 1
        end
    end

    for i in 2:length(B)
        B[i] += B[i-1]
    end

    C = Array{String}(undef, length(A))
    for i in length(A):-1:1
        if(position > length(A[i]))
            C[B[1]] = A[i]
            B[1] -= 1
        else
            C[B[chartodigit2(A[i][position])]] = A[i]
            B[chartodigit2(A[i][position])] -= 1
        end
    end
    return C
end
function chartodigit2(character)
    return Int(character) - 95
end
function countingsortlength2(A)
    B = zeros(Int64, 200)
    
    for i in 1:length(A)
        B[length(A[i])+1] += 1
    end

    for i in 2:length(B)
        B[i] += B[i-1]
    end

    C = Array{String}(undef, length(A))
    for i in length(A):-1:1
        C[B[length(A[i])+1]] = A[i]
        B[length(A[i])+1] -= 1
    end
    return C
end
function flexradix(A, maxlength)
    A = countingsortlength2(A)
    
    for i in maxlength:-1:1
        A = countingsortletters2(A, i)
    end
    return A
end
flexradix(["kobra", "aggie", "agg", "kort", "hyblen"], 6)