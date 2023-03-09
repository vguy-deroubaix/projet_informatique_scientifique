include("convertion.jl")
include("Dijkstra_algorithm/dijkstra.jl")
include("A*_algorithm/A*_algorithm.jl")
include("affichage/affMatrix.jl")

S::Tuple{Int64,Int64} = (10,10) #(10,223)
A::Tuple{Int64,Int64} = (508,505) #(435,155)

function Dijk(map::String)
    affichageChemin(pathLaing!(convColor(map),pathFinding(convert(map),S,A))) #(80,126),(115,90)))))
end

function AStar(map::String)
    affichageChemin(pathLaing!(convColor(map),pathFindingAStar(convert(map),S,A)))
end

function testDijk(map::String)
    pathFinding(convert(map),S,A)
end

function testAStar(map::String)
    pathFindingAStar(convert(map),S,A)
end