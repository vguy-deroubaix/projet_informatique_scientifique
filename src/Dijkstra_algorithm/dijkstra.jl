using DataStructures

include("../convertion.jl")

# changer le paramètre origines par des tableaux de step qui seront les chemins sinon c'est la galères 

function pathFinding(map::Matrix{Path},S::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    #println(S, " : ", map[S[1],S[2]].type)
    #println(A, " : ", map[A[1],A[2]].type)
    if !(traversable(map[S[1],S[2]].type) && traversable(map[A[1],A[2]].type))
        r::Vector{Tuple{Int64,Int64}} = [] #vector rien
        println("le départ ou l'arrivé sont dans une zone innacesssible")
        return (r,r)
    end

    visited::Matrix{Tuple{Bool,Bool}} = fill((false,false),size(map,1),size(map,2)) #non visiter et non ferme
    prev::Matrix{Tuple{Int64,Int64}} = fill((0,0),size(map,1),size(map,2)) # matrice des précédent chaque case contient le pas précédent
    P::PriorityQueue = PriorityQueue{Tuple{Int64,Int64},Int64}(Base.Order.Forward)  
    dist::Matrix{Int64} = fill(typemax(Int64)-10000000,size(map,1),size(map,2)) #matrice des distance chaque case est associer a la distance trouvé
    next::Vector{Tuple{Int64,Int64}} = [] #le vector des cases acessible depuis la case sur laquelle on est
    Q::Vector{Tuple{Int64,Int64}} = []
    cost::Int64 = 0
    totalcost::Int64 = 0
    visited[S[1],S[2]] = (true,true) #la source est considérer visité et n'est pas mis dans la PriorityQueue
    dist[S[1],S[2]] = 0 #la distance de la source est 0 quand on est sur la source
    j::Int64 = 1
    point::Tuple{Int64,Int64} = S

    while !(point == A)  
        next = getNext(map,point) #vector des voisins accessible depuis le point sur le quel on est
        for i in eachindex(next)
            u = next[i]
            #println("revision ? : " ,u != point && (visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]))
            if !(visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) && traversable(map[u[1],u[2]].type) #si non visiter et non ferme et traversable alors
                #si la case est traversable alors on l'ajoute a la Priority Queue
                cost = map[u[1],u[2]].cost + dist[point[1],point[2]]
                dist[u[1],u[2]] = cost
                prev[u[1],u[2]] = point
                visited[u[1],u[2]] = (true,visited[u[1],u[2]][2])
                enqueue!(P,u,cost)
                push!(Q,u)
                j = j + 1
            elseif (visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) #si visiter et non dequeue 
                cost = map[u[1],u[2]].cost + dist[u[1],u[2]]
                #sinon elle est traversable car on l'a deja teste et on maj la distance si besoin
                if cost < dist[u[1],u[2]]
                    dist[u[1],u[2]] = cost
                    prev[u[1],u[2]] = point
                    P[u] = cost
                end
            end
        end
        (point,totalcost) = dequeue_pair!(P)
        visited[point[1],point[2]] = (visited[point[1],point[2]][1],true) 
    end
    println(j)
    println(totalcost)
    return (vectorWay(S,point,prev),Q)
end

function vectorWay(S::Tuple{Int64,Int64},point::Tuple{Int64,Int64},prev::Matrix{Tuple{Int64,Int64}})

    shortes::Vector{Tuple{Int64,Int64}} = []
    while point != S
        push!(shortes,point)
        point = prev[point[1],point[2]] 
    end
    push!(shortes,S)
    return shortes
end

function traversable(c::Char) 
    return (c == '.') || (c == 'G') || (c == 'S') || (c == 'W')
end

function between(a::Int64,n::Int64,b::Int64)
    return a < n && n < b
end

function getNext(map::Matrix{Path},point::Tuple{Int64,Int64})
    height::Int64 = size(map,1)
    witdh::Int64 = size(map,2)

    next::Vector{Tuple{Int64,Int64}} = [] 

    if between(1,point[1],height) && between(1,point[2],witdh)#dans la grille mais pas sur les bord
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    elseif point[1] == 1 && point[2] == 1 #sur le coin haut gauche
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]+1))#next droite
        
    elseif point[1] == height && point[2] == witdh #sur le coint bas droite
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == 1 && point[2] == witdh #sur le coin haut droite
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == height && point[2] == 1 #sur le coin bas gauche
        push!(next,(point[1]-1,point[2]))#next haut 
        push!(next,(point[1],point[2]+1))#next droite 

    elseif between(1,point[1],height) && point[2] == 1 #sur la colone de gauche
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]+1))#next droite

    elseif point[1] == 1 && between(1,point[2],witdh)#sur la ligne du haut 
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    elseif between(1,point[1],height) && point[2] == witdh #sur la colone de droite
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == height && between(1,point[2],witdh) #sur la ligne du bas
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    end
    return next            
end

