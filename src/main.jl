include("convertion.jl")
include("Dijkstra_algorithm/dijkstra.jl")
include("A*_algorithm/A*_algorithm.jl")
include("affichage/affMatrix.jl")


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