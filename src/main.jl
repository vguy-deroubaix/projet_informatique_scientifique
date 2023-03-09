include("convertion.jl")
include("Dijkstra_algorithm/dijkstra.jl")
include("A*_algorithm/A*_algorithm.jl")
include("affichage/affMatrix.jl")


function Dijk(map::String)

    #affichageMap(map,(80,126),(115,90))
    affichageChemin(pathLaing!(convColor(map),pathFindingAStar(convert(map),(80,126),(115,90))))
    #pathFinding(convert(map),(80,126),(115,90))
end