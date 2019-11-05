# o1
# This really shouldn't need any explanation
function dnasimilarity(s1, s2)
    retval = 0
    for i in 1:length(s1)
        if(s1[i] == s2[i])
            retval += 1
        end
    end
    return retval
end

# println(dnasimilarity("ATCG", "ATGC"))
# println(dnasimilarity("ATATATA", "TATATAT"))


# o2
# Iterate through the tree and return the count on whatever
# it ends at. Has check to return 0 if the sequence it's 
# checking for doesn't exist
function searchtree(root, dna)
    i = 1
    node = root
    while(i <= length(dna))
        if(haskey(node.children, dna[i]))
            node = node.children[dna[i]]
            i += 1
        else
            return 0
        end
    end
    return node.count
end


# o3
Node() = Node(Dict(), 0)
function buildtree(dnasequences)
    # Makes root
    root = Node()
    root.count = length(dnasequences)

    # Iterates through the input array of strings
    for i in 1:length(dnasequences)

        # Resets node I'm working on to root (why I need this is clear later)
        node = root

        # Iterates though the letters in the string
        for j in 1:length(dnasequences[i])
            
            # Creates child node if none exists
            if(!haskey(node.children, dnasequences[i][j]))
                node.children[dnasequences[i][j]] = Node()
                node.children[dnasequences[i][j]].count = 0
            end
            
            # Update node I'm working on and updates the count of sequences 
            # that go this far
            node = node.children[dnasequences[i][j]]
            node.count += 1
        end
    end
    return root
end
# println(buildtree(["A", "AG", "TG", "T"]))

# o4
# Same exact thing as o2, but replaces '?' with the four letters and
# includes the sum of the four new strings, recursively
function brokendnasearch(root, dna, i=1)
    node = root
    for j in i:length(dna)
        if(dna[j] == '?')
            sum = 0
            sum += brokendnasearch(node, dna[1:j-1] * 'A' * dna[j+1:end], j)
            sum += brokendnasearch(node, dna[1:j-1] * 'T' * dna[j+1:end], j)
            sum += brokendnasearch(node, dna[1:j-1] * 'C' * dna[j+1:end], j)
            sum += brokendnasearch(node, dna[1:j-1] * 'G' * dna[j+1:end], j)
            return sum
        elseif(haskey(node.children, dna[j]))
            node = node.children[dna[j]]
        else
            return 0
        end
    end
    return node.count
end

