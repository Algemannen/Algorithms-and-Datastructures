# global stuff
# mutable struct Node
#     i::Int
#     j::Int
#     floor::Bool
#     neighbors::Array{Node}
#     color::Union{String,Nothing}
#     distance::Union{Int,Nothing}
#     predecessor::Union{Node,Nothing}
# end
Node(i, j, floor=true) = Node(i, j, floor, [], nothing, nothing, nothing)

# o1
function mazetonodelist(maze)
    # To be 2d matrix containing all floor and wall nodes
    nodearray = Array{Node}(undef, size(maze, 1), size(maze, 2))

    # Make the nodes, maze[y, x] == 1 differentiates between floor and walls
    for y in 1:size(maze, 1)
        for x in 1:size(maze, 2)
            nodearray[y, x] = Node(y, x, maze[y, x] == 1)
        end
    end

    # Correctly sets node neighbors
    for y in 1:size(maze, 1)
        for x in 1:size(maze, 2)
            if(maze[y, x] == 1)
                if(y>1 && nodearray[y-1, x].floor) #Checks that we're not on an edge (top row in this case), and that the neighbor is a floor and not a wall
                    push!(nodearray[y, x].neighbors, nodearray[y-1, x]) #Updates the neighbors array
                end
                if(y<size(maze, 1) && nodearray[y+1, x].floor)
                    push!(nodearray[y, x].neighbors, nodearray[y+1, x])
                end
                if(x>1 && nodearray[y, x-1].floor)
                    push!(nodearray[y, x].neighbors, nodearray[y, x-1])
                end
                if(x<size(maze, 2) && nodearray[y, x+1].floor)
                    push!(nodearray[y, x].neighbors, nodearray[y, x+1])
                end
            end
        end
    end

    # Iterates through the matrix and makes a list/array of all nodes
    retval_yes_this_means_RETurn_VALue_because_Jorgen_wanted_long_and_descriptive_variable_names_this_is_just_the_value_that_will_be_returned_from_the_function = []
    for y in 1:size(maze, 1)
        for x in 1:size(maze, 2)
            if(maze[y, x] == 1)
                push!(retval_yes_this_means_RETurn_VALue_because_Jorgen_wanted_long_and_descriptive_variable_names_this_is_just_the_value_that_will_be_returned_from_the_function, nodearray[y, x])
            end
        end
    end
    return retval_yes_this_means_RETurn_VALue_because_Jorgen_wanted_long_and_descriptive_variable_names_this_is_just_the_value_that_will_be_returned_from_the_function
end


### Tester for o1 ###
# function sortnodelist(nodelist)
#     sort!(sort!(nodelist, by=node->node.i), by=node->node.j)
# end

# function getcoords(nodelist)
#     return [(node.i, node.j) for node in nodelist]
# end

# function getneighborcoords(nodelist)
#     return [sort(sort(
#                [(neighbor.i, neighbor.j) for neighbor in node.neighbors],
#             by = x -> x[1]), by = x -> x[2])
#             for node in nodelist]
# end

# printstyled("\n\n\n---------------\nKjører tester!!\n---------------\n"; color = :magenta)

# using Test
# @testset "LitenLabyrint" begin
#     maze = [0 0 0 0 0
#             0 1 1 1 0
#             0 1 0 0 0
#             0 1 1 1 0
#             0 0 0 0 0]
#     nodelist = mazetonodelist(maze)

#     # Test at nodelist er en 1-dimensjonal liste/array
#     # Merk at følgende tester vil feile dersom dette ikke er tilfelet
#     @test length(size(nodelist)) == 1

#     # Test at grafen inneholder riktig antall noder
#     @test length(nodelist) == 7

#     # Vi sorterer nodelist ut ifra koordinatene, ettersom vi ikke pålegger
#     # en spesifikk rekkefølge på nodene i nodelist
#     sortnodelist(nodelist)

#     # Test at koordinatene til hver node er korrekte
#     @test getcoords(nodelist) ==
#         [(2, 2), (3, 2), (4, 2), (2, 3), (4, 3), (2, 4), (4, 4)]

#     # Test at koordinatene til hver nabonode er korrekte
#     @test getneighborcoords(nodelist) ==
#         [[(3, 2), (2, 3)], [(2, 2), (4, 2)],
#          [(3, 2), (4, 3)], [(2, 2), (2, 4)],
#          [(4, 2), (4, 4)], [(2, 3)], [(4, 3)]]
# end

# @testset "MiddelsLabyrint" begin
#     maze = [0 0 0 0 0 0 0
#             0 1 1 1 1 1 0
#             0 1 0 0 0 1 0
#             0 1 0 1 0 1 0
#             0 1 0 1 0 1 0
#             0 1 1 1 0 1 0
#             0 0 0 0 0 0 0]
#     nodelist = mazetonodelist(maze)

#     @test length(size(nodelist)) == 1

#     @test length(nodelist) == 17

#     sortnodelist(nodelist)

#     @test getcoords(nodelist) ==
#         [(2, 2), (3, 2), (4, 2), (5, 2), (6, 2),
#          (2, 3), (6, 3), (2, 4), (4, 4), (5, 4),
#          (6, 4), (2, 5), (2, 6), (3, 6), (4, 6),
#          (5, 6), (6, 6)]

#     @test getneighborcoords(nodelist) ==
#         [[(3, 2), (2, 3)], [(2, 2), (4, 2)], [(3, 2), (5, 2)],
#          [(4, 2), (6, 2)], [(5, 2), (6, 3)], [(2, 2), (2, 4)],
#          [(6, 2), (6, 4)], [(2, 3), (2, 5)], [(5, 4)],
#          [(4, 4), (6, 4)], [(6, 3), (5, 4)], [(2, 4), (2, 6)],
#          [(2, 5), (3, 6)], [(2, 6), (4, 6)], [(3, 6), (5, 6)],
#          [(4, 6), (6, 6)], [(5, 6)]]
# end




























# o2
using Pkg; Pkg.add("DataStructures")
using DataStructures: Queue, enqueue!, dequeue!


goal = nothing

function bfs!(nodes, start)
    # Sets all nodes to white
    for node in nodes
        node.color = "white" # This is stupid, it should just be a bool if it's seen or not
    end

    # Start node is gray and distance from start to start is 0
    start.color = "gray"
    start.distance = 0

    # Make the queue and add the starting node to it
    q = Queue{Node}() # q is short for queue
    enqueue!(q, start)

    while(length(q) > 0)
        # Checks the node in the front
        node_that_we_are_checking = dequeue!(q)

        # Checks if we have reached our goal
        if(isgoalnode(node_that_we_are_checking))
            return node_that_we_are_checking
        end

        # If not, add all unseen neighbors to the queue
        for neighbor in node_that_we_are_checking.neighbors
            if(neighbor.color == "white")
                neighbor.color = "gray" # Checks the node as seen
                neighbor.distance = node_that_we_are_checking.distance+1
                neighbor.predecessor = node_that_we_are_checking
                enqueue!(q, neighbor)
            end
        end
        node_that_we_are_checking.color = "black"
    end
    return nothing
end


### Tester ###
# function isgoalnode(node)
#     global goal
#     node == goal
# end

# function setgoalnode(node)
#     global goal
#     goal = node
# end

# function nodeattrs(node)
#     return string(node.color, " ", node.distance, " ",
#                   node.predecessor == nothing ? "nothing" :
#                   (node.predecessor.i, node.predecessor.j))
# end

# printstyled("\n\n\n---------------\nKjører tester!!\n---------------\n"; color = :magenta)

# using Test
# @testset "LitenLabyrint" begin
#     # maze = [0 0 0 0 0
#     #         0 1 1 1 0
#     #         0 1 0 0 0
#     #         0 1 1 1 0
#     #         0 0 0 0 0]

#     nodelist = [Node(2, 2), Node(3, 2), Node(4, 2), Node(2, 3),
#                 Node(4, 3), Node(2, 4), Node(4, 4)]

#     nodelist[1].neighbors = [nodelist[2], nodelist[4]]
#     nodelist[2].neighbors = [nodelist[1], nodelist[3]]
#     nodelist[3].neighbors = [nodelist[2], nodelist[5]]
#     nodelist[4].neighbors = [nodelist[1], nodelist[6]]
#     nodelist[5].neighbors = [nodelist[3], nodelist[7]]
#     nodelist[6].neighbors = [nodelist[4]]
#     nodelist[7].neighbors = [nodelist[5]]

#     setgoalnode(nothing)
#     result = bfs!(nodelist, nodelist[1])

#     # Test at å kjøre bfs mot et utilgjengelig mål returnerer nothing
#     @test result == nothing

#     setgoalnode(nodelist[7])
#     result = bfs!(nodelist, nodelist[1])

#     # Test at riktig målnode returneres
#     @test result == nodelist[7]

#     # Test at attributtene til nodene i nodelist ble oppdatert korrekt
#     # Attributtene tilsvarer color, distance og koordinatene til predecessor
#     # (Merk at fargene kan variere noe ut ifra når man returnerer målnoden)
#     @test nodeattrs(nodelist[1]) == "black 0 nothing"
#     @test nodeattrs(nodelist[2]) == "black 1 (2, 2)"
#     @test nodeattrs(nodelist[3]) == "black 2 (3, 2)"
#     @test nodeattrs(nodelist[4]) == "black 1 (2, 2)"
#     @test nodeattrs(nodelist[5]) in ["gray 3 (4, 2)", "black 3 (4, 2)"]
#     @test nodeattrs(nodelist[6]) == "black 2 (2, 3)"
#     @test nodeattrs(nodelist[7]) in ["white 4 (4, 3)", "gray 4 (4, 3)"]
# end

# @testset "MiddelsLabyrint" begin
#     # maze = [0 0 0 0 0 0 0
#     #         0 1 1 1 1 1 0
#     #         0 1 0 0 0 1 0
#     #         0 1 0 1 0 1 0
#     #         0 1 0 1 0 1 0
#     #         0 1 1 1 0 1 0
#     #         0 0 0 0 0 0 0]

#     nodelist = [Node(2, 2), Node(3, 2), Node(4, 2), Node(5, 2), Node(6, 2),
#                 Node(2, 3), Node(6, 3), Node(2, 4), Node(4, 4), Node(5, 4),
#                 Node(6, 4), Node(2, 5), Node(2, 6), Node(3, 6), Node(4, 6),
#                 Node(5, 6), Node(6, 6)]

#     nodelist[1].neighbors = [nodelist[2], nodelist[6]]
#     nodelist[2].neighbors = [nodelist[1], nodelist[3]]
#     nodelist[3].neighbors = [nodelist[2], nodelist[4]]
#     nodelist[4].neighbors = [nodelist[3], nodelist[5]]
#     nodelist[5].neighbors = [nodelist[4], nodelist[7]]
#     nodelist[6].neighbors = [nodelist[1], nodelist[8]]
#     nodelist[7].neighbors = [nodelist[5], nodelist[11]]
#     nodelist[8].neighbors = [nodelist[6], nodelist[12]]
#     nodelist[9].neighbors = [nodelist[10]]
#     nodelist[10].neighbors = [nodelist[9], nodelist[11]]
#     nodelist[11].neighbors = [nodelist[7], nodelist[10]]
#     nodelist[12].neighbors = [nodelist[8], nodelist[13]]
#     nodelist[13].neighbors = [nodelist[12], nodelist[14]]
#     nodelist[14].neighbors = [nodelist[13], nodelist[15]]
#     nodelist[15].neighbors = [nodelist[14], nodelist[16]]
#     nodelist[16].neighbors = [nodelist[15], nodelist[17]]
#     nodelist[17].neighbors = [nodelist[16]]

#     setgoalnode(nodelist[17])
#     result = bfs!(nodelist, nodelist[1])

#     @test result == nodelist[17]

#     @test nodeattrs(nodelist[1]) == "black 0 nothing"
#     @test nodeattrs(nodelist[2]) == "black 1 (2, 2)"
#     @test nodeattrs(nodelist[3]) == "black 2 (3, 2)"
#     @test nodeattrs(nodelist[4]) == "black 3 (4, 2)"
#     @test nodeattrs(nodelist[5]) == "black 4 (5, 2)"
#     @test nodeattrs(nodelist[6]) == "black 1 (2, 2)"
#     @test nodeattrs(nodelist[7]) == "black 5 (6, 2)"
#     @test nodeattrs(nodelist[8]) == "black 2 (2, 3)"
#     @test nodeattrs(nodelist[9]) in ["gray 8 (5, 4)", "black 8 (5, 4)"]
#     @test nodeattrs(nodelist[10]) == "black 7 (6, 4)"
#     @test nodeattrs(nodelist[11]) == "black 6 (6, 3)"
#     @test nodeattrs(nodelist[12]) == "black 3 (2, 4)"
#     @test nodeattrs(nodelist[13]) == "black 4 (2, 5)"
#     @test nodeattrs(nodelist[14]) == "black 5 (2, 6)"
#     @test nodeattrs(nodelist[15]) == "black 6 (3, 6)"
#     @test nodeattrs(nodelist[16]) in ["gray 7 (4, 6)", "black 7 (4, 6)"]
#     @test nodeattrs(nodelist[17]) in ["white 8 (5, 6)", "gray 8 (5, 6)"]
# end




























# o3
function makepathto(goalnode)
    current_node = goalnode
    retval_yes_this_is_still_the_value_we_will_return_at_the_end_of_this_all = []

    # Make a list from the goal to the node before the start node
    while(current_node.predecessor != nothing)
        push!(retval_yes_this_is_still_the_value_we_will_return_at_the_end_of_this_all , (current_node.i, current_node.j)) # Why you'd call it j, i instead of x, y is beyond me
        current_node = current_node.predecessor
    end

    # Include the start node
    push!(retval_yes_this_is_still_the_value_we_will_return_at_the_end_of_this_all , (current_node.i, current_node.j))

    # Return it. That bit at the end means that we reverse the array so that it's from start to end rather than the other way around
    return retval_yes_this_is_still_the_value_we_will_return_at_the_end_of_this_all[end:-1:1]
end

# printstyled("\n\n\n---------------\nKjører tester!!\n---------------\n"; color = :magenta)

# using Test
# @testset "LitenLabyrint" begin
#     # maze = [0 0 0 0 0
#     #         0 1 1 1 0
#     #         0 1 0 0 0
#     #         0 1 1 1 0
#     #         0 0 0 0 0]

#     nodelist = [Node(2, 2), Node(3, 2), Node(4, 2), Node(2, 3),
#                 Node(4, 3), Node(2, 4), Node(4, 4)]

#     # startnode = nodelist[1]
#     # goalnode = nodelist[7]
#     nodelist[1].predecessor = nothing
#     nodelist[2].predecessor = nodelist[1]
#     nodelist[3].predecessor = nodelist[2]
#     nodelist[4].predecessor = nodelist[1]
#     nodelist[5].predecessor = nodelist[3]
#     nodelist[6].predecessor = nodelist[4]
#     nodelist[7].predecessor = nodelist[5]

#     # Test at riktig sti returneres
#     @test makepathto(nodelist[7]) ==
#             [(2, 2), (3, 2), (4, 2), (4, 3), (4, 4)]

# end

# @testset "MiddelsLabyrint" begin
#     # maze = [0 0 0 0 0 0 0
#     #         0 1 1 1 1 1 0
#     #         0 1 0 0 0 1 0
#     #         0 1 0 1 0 1 0
#     #         0 1 0 1 0 1 0
#     #         0 1 1 1 0 1 0
#     #         0 0 0 0 0 0 0]

#     nodelist = [Node(2, 2), Node(3, 2), Node(4, 2), Node(5, 2), Node(6, 2),
#                 Node(2, 3), Node(6, 3), Node(2, 4), Node(4, 4), Node(5, 4),
#                 Node(6, 4), Node(2, 5), Node(2, 6), Node(3, 6), Node(4, 6),
#                 Node(5, 6), Node(6, 6)]

#     # startnode = nodelist[1]
#     # goalnode = nodelist[17]
#     nodelist[1].predecessor = nothing
#     nodelist[2].predecessor = nodelist[1]
#     nodelist[3].predecessor = nodelist[2]
#     nodelist[4].predecessor = nodelist[3]
#     nodelist[5].predecessor = nodelist[4]
#     nodelist[6].predecessor = nodelist[1]
#     nodelist[7].predecessor = nodelist[5]
#     nodelist[8].predecessor = nodelist[6]
#     nodelist[9].predecessor = nodelist[10]
#     nodelist[10].predecessor = nodelist[11]
#     nodelist[11].predecessor = nodelist[7]
#     nodelist[12].predecessor = nodelist[8]
#     nodelist[13].predecessor = nodelist[12]
#     nodelist[14].predecessor = nodelist[13]
#     nodelist[15].predecessor = nodelist[14]
#     nodelist[16].predecessor = nodelist[15]
#     nodelist[17].predecessor = nodelist[16]

#     @test makepathto(nodelist[17]) ==
#             [(2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (3, 6), (4, 6), (5, 6), (6, 6)]
# end