# o1
function findset(x)
    if(x != x.p)
        x.p = findset(x.p)
    end
    return x.p
end

# o2
function union!(x, y)
    y = findset(y)
    x = findset(x)
    if(x.rank > y.rank)
        y.p = x
    elseif(y.rank > x.rank)
        x.p = y
    else
        y.p = x
        x.rank += 1
    end
end

# o3
function hammingdistance(s1, s2)
    distance = 0;
    for i in 1:length(s1)
        if(s1[i] != s2[i])
            distance += 1
        end
    end
    return distance
end

# o4
function findclusters(E, n, k)
    # E = edges
    # n = number of nodes in the forest
    # k = number of clusters we want in the end

    # Initialization
    sort!(E)
    nodes = Array{DisjointSetNode}(undef, n)
    for i in 1:n
        nodes[i] = DisjointSetNode()
        nodes[i].rank = 0
    end

    # Number of trees we currently have, nad our index
    numberOfTrees = n
    i = 1

    # Kruskal's 
    # find the lightest edge not making a cycle
    # add it 
    while(numberOfTrees > k)
        w = E[i][1]
        u = E[i][2]
        v = E[i][3]
        
        if(findset(nodes[u]) != findset(nodes[v]))
            union!(nodes[u], nodes[v])
            numberOfTrees -= 1
        end

        i += 1
    end

    # Get all sets
    retval = []
    for i in 1:length(nodes)
        push!(retval, findset(nodes[i]))
    end

    # Return all unique sets
    return findall.(isequal.(unique(retval)), [retval])
end

# using Test
# @testset "Tester" begin
#     @test sort([sort(x) for x in findclusters([(1, 3, 4), (3, 1, 3), (5, 1, 4), (6, 2, 1), (7, 2, 3), (8, 3, 1), (9, 3, 2), 
#     (10, 4, 1), (11, 4, 2), (12, 4, 3), (4, 2, 4), (2, 1, 2)], 4, 2)]) == sort([[1, 2], [3, 4]])
#     @test sort([sort(x) for x in findclusters([(1, 3, 4), (3, 1, 3), (5, 1, 4), (6, 2, 1), (7, 2, 3), (8, 3, 1), (9, 3, 2), 
#     (10, 4, 1), (11, 4, 2), (12, 4, 3), (4, 2, 4), (2, 1, 2)], 4, 3)]) == sort([[1], [2], [3, 4]])
# end


# o4
function findanimalgroups(animals, k)
    # First, find the edges (with weight)
    edges = []
    for i in 1:length(animals)
        for j in i+1:length(animals)
            push!(edges, (hammingdistance(animals[i][2], animals[j][2]), i, j) )
        end
    end

    # Second, find clusters
    clusters = findclusters(edges, length(animals), k)

    # Third, now the easy part of the algorithm and the hard part of the assignment starts (thanks Julia)
    # Empty array, this will be where the finela clusters will be stored
    # If you had the brilliant idea of "why don't we just overwrite the index
    # from findclusters() with the animal name", I will tell you that
    # NOPE! Julia doesn't let you do that. Why, you ask? Because Julia, while
    # a dynamically typed language, lets you get away with not specifying type
    # before you compile the program. It does not, however, let you overwrite
    # a variable with another type. Why would anyone do this and not warn you 
    # that you're doing an illegal action at compile time? Because fuck you, 
    # that's why.
    animalclusters = []
    for i in 1:length(clusters)

        # The clusters that we will push into animalclusters
        cluster = []

        # Making the cluster with animal names instead of index
        for j in 1:length(clusters[i])
            push!(cluster, animals[clusters[i][j]][1])
        end

        # Pushing it to the array of clusters
        push!(animalclusters, cluster)
    end
    return animalclusters
end

# using Test
# @testset "Tester" begin
#     @test sort([sort(x) for x in findanimalgroups([("Ugle", "CGGCACGT"), ("Elg", "ATTTGACA"), ("Hjort", "AATAGGCC")], 2)]) == sort([["Ugle"], ["Elg", "Hjort"]])

#     @test sort([sort(x) for x in findanimalgroups([("Hval", "CGCACATA"), ("Ulv", "AGAAACCT"), ("Delfin", "GGCACATA"), ("Hund", "GGAGACAA"), 
#     ("Katt", "TAACGCCA"), ("Leopard", "TAACGCCT")], 3)]) == sort([["Hund", "Ulv"], ["Delfin", "Hval"], ["Katt", "Leopard"]])
# end