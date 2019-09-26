# mutable struct Node
#     next::Union{Node, Nothing} # next kan peke på et Node-objekt eller ha verdien nothing.
#     value::Int
# end

# Q1
# function createlinkedlist(length)
#     # Creates the list starting from the last element
#     # This is done so the last element we generate is the head
#     child = nothing
#     node = nothing

#     for i in 2:length
#         node = Node(child, rand(1:800))
#         child = node
#     end
#     return node
# end


# function findindexinlist(node, index)
#     println(node)

#     for i in 1:index
#         if node.next == nothing
#             return -1
#         end
#         node = node.next
#     end
#     println(node)
#     println(node.value)
#     return node.value
# end

# findindexinlist(createlinkedlist(10), 5)



# Q2
# function reverseandlimit(array, maxnumber)
#     new = []
#     for i in length(array):-1:1
#         push!(new, if (array[i] < maxnumber) array[i] else maxnumber end )
#         println(new)
#     end
#     return new
# end

# s = [1,2,3,4,6,7,3,6,8]
# println(reverseandlimit(s, 6))

function reverseandlimit(array, maxnumber)
    len = length(array)
    new = Array{Int64}(undef, len)
    for i in len:-1:1
        new[len+1-i] = if (array[i] < maxnumber) array[i] else maxnumber end
    end
    
    return new
end

function reverseandlimit2(array, maxnumber)
    len = length(array)
    new = Array{Int64}(undef, len)
    for i in len:-1:1
        new[len+1-i] = min(array[i], maxnumber)
    end
    
    return new
end
s = [1,2,3,4,6,7,3,6,8]
@time reverseandlimit(s, 6)
@time reverseandlimit2(s, 6)

# # Q3
# # mutable struct NodeDoublyLinked
# #     prev::Union{NodeDoublyLinked, Nothing} # Er enten forrige node eller nothing
# #     next::Union{NodeDoublyLinked, Nothing} # Er enten neste node eller nothing
# #     value::Int # Verdien til noden
# # end
# function createlinkedlist(length)
#     # Creates the list starting from the last element
#     # This is done so the last element we generate is the head
#     child = nothing
#     node = nothing

#     for i in 1:length
#         node = NodeDoublyLinked(nothing, child, rand(1:800))
#         if child != nothing
#             child.prev = node
#         end


#         child = node
#     end
#     return node.next
# end

# function maxofdoublelinkedlist(start)
#     max = -10000
#     node = start

#     while node != nothing
#         if(max < node.value) max = node.value end
#         node = node.next
#     end

#     node = start
#     while node != nothing
#         if(max < node.value) max = node.value end
#         node = node.prev
#     end

# end

# println(createlinkedlist(5))

