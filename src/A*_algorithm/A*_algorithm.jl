using DataStructures

include("../convertion.jl")

# changer le paramètre origines par des tableaux de step qui seront les chemins sinon c'est la galères 

function heuristique(point::Tuple{Int64,Int64},A::Tuple{Int64,Int64})

    return abs(A[1]-point[1])+abs(A[2]-point[2])
end

function pathFindingAStar(map::Matrix{Path},S::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    if !(traversable(map[S[1],S[2]].type) && traversable(map[A[1],A[2]].type))
        println("le départ ou l'arrivé sont dans une zone innacesssible")
        return []
    end

    visited::Matrix{Tuple{Bool,Bool}} = fill((false,false),size(map,1),size(map,2)) #non visiter et non dequeue
    prev::Matrix{Tuple{Int64,Int64}} = fill((0,0),size(map,1),size(map,2)) # matrice des précédent chaque case contient le pas précédent
    P::PriorityQueue = PriorityQueue{Tuple{Int64,Int64},Int64}(Base.Order.Forward)  
    dist::Matrix{Int64} = fill(typemax(Int64)-10000000,size(map,1),size(map,2)) #matrice des distance chaque case est associer a la distance trouvé
    next::Vector{Tuple{Int64,Int64}} = [] #le vector des cases acessible depuis la case sur laquelle on est

    cost::Int64 = 0
    visited[S[1],S[2]] = (true,true) #la source est considérer visité et n'est pas mis dans la PriorityQueue
    dist[S[1],S[2]] = 0 #la distance de la source est 0 quand on est sur la source
    j::Int64 = 1
    point::Tuple{Int64,Int64} = S

    println(S)
    while !(point == A)  
        next = getNext(map,point) #vector des voisins accessible depuis le point sur le quel on est
        #println("par rapport a ", point)
        for i in eachindex(next)
            u = next[i]
            #println("revision ? : " ,u != point && (visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]))
            if !(visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) #si non visiter et non dequeue alors
                #si la case est traversable alors on l'ajoute a la Priority Queue
                if traversable(map[u[1],u[2]].type)
                    cost = map[u[1],u[2]].cost + dist[point[1],point[2]] + heuristique(u,A)
                   #println("insertion dans P ",point, " => ", u," : ",cost)

                    dist[u[1],u[2]] = cost
                    prev[u[1],u[2]] = point
                    visited[u[1],u[2]] = (true,visited[u[1],u[2]][2])
                    enqueue!(P,u,cost)
                    #println("distance apres insertion : ", dist[u[1],u[2]])

                end
            elseif (visited[u[1],u[2]][1]) && !(visited[u[1],u[2]][2]) #si visiter et non dequeue 

                cost = map[u[1],u[2]].cost + dist[u[1],u[2]] + heuristique(u,A)
                #println("coute de la case ",u," : ",map[u[1],u[2]].cost)
                #println("distance parcourus de ", u," : ",dist[u[1],u[2]])
                #sinon elle est traversable car on l'a deja teste et on maj la distance si besoin
                if cost < dist[u[1],u[2]]
                    #println("revision dans P ",point, " => ", u," : ",cost)

                    dist[u[1],u[2]] = cost
                    prev[u[1],u[2]] = point
                    P[u] = cost
                    
                end

            end
        end
        #println("a la coor : ",point," avant dequeue")
        #t = peek(P)[2]
        #println("distance de point : ", dist[point[1],point[2]])
        point = dequeue!(P)
        #println("dist apres dequeue : ",dist[point[1],point[2]])
        visited[point[1],point[2]] = (visited[point[1],point[2]][1],true) 
        #println("a la coor : ",point," après dequeue")
        #println(prev[point[1],point[2]], " => on a dequeue ", point ," : ", t,"\n")
        j = j + 1
        #println(j)
    end
    #println("1   ",prev[point[1],point[2]], " => ", point ,"\n")
    return vectorWay(S,point,prev)
end

function vectorWay(S::Tuple{Int64,Int64},point::Tuple{Int64,Int64},prev::Matrix{Tuple{Int64,Int64}})

    shortes::Vector{Tuple{Int64,Int64}} = []
    while point != S
        push!(shortes,point)
        #println("2   ",prev[point[1],point[2]], " => ", point ,"\n")
        point = prev[point[1],point[2]] 
        #println("4   ",prev[prev[point[1],point[2]][1],prev[point[1],point[2]][2]], " => ", point ,"\n")
    end
    push!(shortes,S)
    #println(shortes)
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
        #println(1)
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    elseif point[1] == 1 && point[2] == 1 #sur le coin haut gauche
        #println(2)
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]+1))#next droite
        
    elseif point[1] == height && point[2] == witdh #sur le coint bas droite
        #println(3)
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == 1 && point[2] == witdh #sur le coin haut droite
        #println(4)
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == height && point[2] == 1 #sur le coin bas gauche
        #println(5)
        push!(next,(point[1]-1,point[2]))#next haut 
        push!(next,(point[1],point[2]+1))#next droite 

    elseif between(1,point[1],height) && point[2] == 1 #sur la colone de gauche
        #println(6)
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]+1))#next droite

    elseif point[1] == 1 && between(1,point[2],witdh)#sur la ligne du haut 
        #println(7)
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    elseif between(1,point[1],height) && point[2] == witdh #sur la colone de droite
        #println(8)
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1]+1,point[2]))#next bas
        push!(next,(point[1],point[2]-1))#next gauche

    elseif point[1] == height && between(1,point[2],witdh) #sur la ligne du bas
        #println(9)
        push!(next,(point[1]-1,point[2]))#next haut
        push!(next,(point[1],point[2]-1))#next gauche
        push!(next,(point[1],point[2]+1))#next droite

    end
    return next            
end

