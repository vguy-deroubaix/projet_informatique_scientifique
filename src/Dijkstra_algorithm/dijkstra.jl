include("../convertion.jl")
include("../affichage/affMatrix.jl")

struc Step
    origine::Path
    costTogo::UInt16
end

function trouverChemin(map::Matrix{Path},point::Path,coor::Tuple{Int32,Int32})

    steps::Vector{Step} = getQueu(point) [Step(point,M[coor[1]-1,coor[2]].cost),Step(point,M[coor[1]+1,coor[2]].cost),Step(point,M[coor[1]-1,coor[2]].cost)]

end


function getQueu(point::Path)

    if point.coor[1] 

end