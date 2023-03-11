using DataStructures

include("../convertion.jl")

# changer le paramètre origines par des tableaux de step qui seront les chemins sinon c'est la galères 

function pathFindingDijkstra(map::Matrix{Path},D::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    
    if !(traversable(map[D[1],D[2]].type) && traversable(map[A[1],A[2]].type))
        println(D, " : ", map[D[1],D[2]].type)
        println(A, " : ", map[A[1],A[2]].type)
        r::Vector{Tuple{Int64,Int64}} = [] #vector vide
        println("le départ ou l'arrivé sont dans une zone innacesssible")
        return (r,r,0,0)
    end

    visited::Matrix{Tuple{Bool,Bool}} = fill((false,false),size(map,1),size(map,2)) #non visiter et non ferme
    prev::Matrix{Tuple{Int64,Int64}} = fill((0,0),size(map,1),size(map,2)) # matrice des précédent chaque case contient le pas précédent
    dist::Matrix{Int64} = fill(typemax(Int64)-10_000_000,size(map,1),size(map,2)) #matrice des distance chaque case est associer a la distance trouvé , typemax a changé

    P::PriorityQueue = PriorityQueue{Tuple{Int64,Int64},Int64}(Base.Order.Forward)  
    next::Vector{Tuple{Int64,Int64}} = [] #le vector des cases acessible depuis la case sur laquelle on est
    Q::Vector{Tuple{Int64,Int64}} = [] #vector dans lesquelles on stoke les états visités pour l'affichage 

    cost::Int64 = 0
    pathCost::Int64 = 0
    visited[D[1],D[2]] = (true,true) #la source est considérer visité et n'est pas mis dans la PriorityQueue
    dist[D[1],D[2]] = 0 #la distance de la source est 0 quand on est sur la source
    numbreBoxVisited::Int64 = 0
    point::Tuple{Int64,Int64} = D

    while !(point == A)  
        next = getNext(map,point) #vector des voisins accessible depuis le point sur le quel on est
        for i in eachindex(next)
            u = next[i] #le voisin que l'on va traité
            if !(visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) && traversable(map[u[1],u[2]].type) #si non visiter et non ferme et traversable alors
                cost = map[u[1],u[2]].cost + dist[point[1],point[2]]
                #si la case est traversable alors on l'ajoute a la Priority Queue
                dist[u[1],u[2]] = cost
                prev[u[1],u[2]] = point
                visited[u[1],u[2]] = (true,visited[u[1],u[2]][2])
                enqueue!(P,u,cost)
                push!(Q,u)
                numbreBoxVisited = numbreBoxVisited + 1
            elseif (visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) #si visiter et non ferme 
                cost = map[u[1],u[2]].cost +dist[point[1],point[2]] 
                #sinon elle est traversable car on l'a deja teste et on mets a jour la distance si besoin
                if cost < dist[u[1],u[2]]
                    dist[u[1],u[2]] = cost
                    prev[u[1],u[2]] = point
                    P[u] = cost
                end
            end
        end
        (point,pathCost) = dequeue_pair!(P)
        visited[point[1],point[2]] = (visited[point[1],point[2]][1],true) 
    end
    return (vectorWay(D,point,prev),Q,numbreBoxVisited,pathCost)
end

function vectorWay(D::Tuple{Int64,Int64},point::Tuple{Int64,Int64},prev::Matrix{Tuple{Int64,Int64}})

    shortest::Vector{Tuple{Int64,Int64}} = []
    while point != D
        push!(shortest,point)
        point = prev[point[1],point[2]] 
    end
    push!(shortest,D)
    return shortest
end

function traversable(c::Char) 
    return (c == '.') || (c == 'G') || (c == 'D') || (c == 'W') || (c == 'S')
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

