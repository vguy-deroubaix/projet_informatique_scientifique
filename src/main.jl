include("convertion.jl")
include("dijkstra.jl")
include("A*_algorithm.jl")
include("affMatrix.jl")
include("WA*.jl")


function algoDijkstra(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Int64 = 0
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingDijkstra(fileToMatrix(fname),D,A)
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end

function algoAstar(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Int64 = 0
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingAstar(fileToMatrix(fname),D,A)
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end

function algoWAstar(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64},w::Float64)
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Float64 = 0
    pathFindingWAstar(fileToMatrix(fname),D,A,w)
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingWAstar(fileToMatrix(fname),D,A,w)
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end

function DijkstraAffichage(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Int64 = 0
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingDijkstra(fileToMatrix(fname),D,A)
    affichageChemin(pathLaing!(convColor(fname),shortestPath,visitedBox))
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end

function AStarAffichage(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Int64 = 0
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingAstar(fileToMatrix(fname),D,A)
    affichageChemin(pathLaing!(convColor(fname),shortestPath,visitedBox))
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end

function WAStarAffichage(fname::String,D::Tuple{Int64,Int64},A::Tuple{Int64,Int64},w::Float64)
    shortestPath::Vector{Tuple{Int64,Int64}} = []
    visitedBox::Vector{Tuple{Int64,Int64}} = []
    nombreEtatvisite::Int64 = 0
    pathCost::Float64 = 0
    (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingWAstar(fileToMatrix(fname),D,A,w)
    if pathCost > 0.0  
        affichageChemin(pathLaing!(convColor(fname),shortestPath,visitedBox))
    end
    println("la distance de D -> A : ", pathCost)
    println("nombre de case visité : ", size(visitedBox,1))
end



#=function testEnSerieMaze(fname::String,w::Float64)
    open("../Scenario/maze-scen/"*fname*".scen","r") do io
        f::Vector{String} = readlines(io)
        coor::Vector{Tuple{Tuple{Int64,Int64},Tuple{Int64,Int64}}} = []
        line::Vector{String} = []

        for i = 2:(size(f,1)-1)
            line = split(f[i])
            pushfirst!(coor,((parse(Int64,line[4]),parse(Int64,line[5])), (parse(Int64,line[6]),parse(Int64,line[7]))))
        end
        println("fin de parsing")
        shortestPath::Vector{Tuple{Int64,Int64}} = []
        visitedBox::Vector{Tuple{Int64,Int64}} = []
        nombreEtatvisite::Int64 = 0
        pathCost::Int64 = 0

        shortestPathW::Vector{Tuple{Int64,Int64}} = []
        visitedBoxW::Vector{Tuple{Int64,Int64}} = []
        nombreEtatvisiteW::Int64 = 0
        pathCostW::Float64 = 0

        data::Vector{Tuple{Float64,Float64}} = []
        timeA::Float64 = 0.0
        timeWA::Float64 = 0.0

        for i = 1:(size(f,1)-3)
           timeA = @elapsed (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingAstar(fileToMatrix(fname),coor[i][1],coor[i][2])
           timeWA = @elapsed (shortestPathW,visitedBoxW,nombreEtatvisiteW,pathCostW) = pathFindingWAstar(fileToMatrix(fname),coor[i][1],coor[i][2],w)
            if pathCost > 0 
                pushfirst!(data,((convert(Float64,pathCost)/pathCostW),timeA-timeWA))
            end
            if mod(i,1000) == 0 && pathCostW > 0.0
                WAStarAffichage(fname,coor[i][1],coor[i][2],w)
            end
        end

        return data
    end

end =#