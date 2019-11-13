# 01
function general_dijkstra!(G, w, s, reverse=false)
    initialize!(G, s)
    
    # Make queue, either backwards or forwards
    Q = PriorityQueue()
    if(reverse)
        Q = PriorityQueue(Base.Order.Reverse, u => u.d for u in G.V)
    else
        Q = PriorityQueue(u => u.d for u in G.V)
    end
    
    # Always find the next edge with the least weight and add it to the tree
    while(length(Q) > 0)
        u = dequeue!(Q)
        for v in G.Adj[u]
            
            update!(u, v, w)
            if (haskey(Q, v))
                Q[v] = v.d
            end
        end
    end
end



# o2
function initialize!(G, s)
    for v in G.V
        v.d = -typemax(Float64)
        v.p = nothing
    end
    s.d = typemax(Float64)
end


function update!(u, v, w)
    if(v.d < min(u.d, w[(u, v)]))
        v.d = min(u.d, w[(u, v)])
        v.p = u
    end
end


# o3
function floyd_warshall(adjacency_matrix, nodes, f, g)
    n = size(adjacency_matrix, 1)
    D = []
    
    
    for k in 1:n
        push!(D, copy(adjacency_matrix)) #Julia is stupid
        for i in 1:n
            for j in 1:n
                if(k==1)
                    a1 = adjacency_matrix[i, j]
                    a2 = adjacency_matrix[i, k]
                    a3 = adjacency_matrix[k, j]

                    D[k][i, j] = f(a1, g(a2, a3))
                else
                    D[k][i, j] = f(D[k-1][i, j], g(D[k-1][i, k], D[k-1][k, j]))
                end
            end
        end
    end
    return D[n]
end

# o4
function transitive_closure(adjacency_matrix, nodes)
    T = copy(adjacency_matrix)
    for i in 1:nodes
        for j in 1:nodes
            if(i==j || adjacency_matrix[i, j] < 10000)
                T[i, j] = 1
            else
                T[i, j] = 0
            end
        end
    end
    # println(T)
    return floyd_warshall(
        T, 
        nodes, 
        (x, y) -> (x>=1 || y>=1) ? 1 : 0,
        (x, y) -> (x>=1 && y>=1) ? 1 : 0)
end

println(transitive_closure([0.0 3.0 8.0; Inf 0.0 Inf; Inf 4.0 0.0], 3))