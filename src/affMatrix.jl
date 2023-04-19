using Images,ImageView,Gtk.ShortNames

include("convertion.jl")
include("dijkstra.jl")

const boxToRGB::Dict{Char,RGB{Float64}} = Dict{Char,RGB{Float64}}(
    '.' => RGB{Float64}(1.0,1.0,1.0), #white
    'G' => RGB{Float64}(0.149, 0.950, 0.0760), 
    'T' => RGB{Float64}(0.0570, 0.570, 0.254), #darck green
    'O' => RGB{Float64}(0.404, 0.430, 0.414), #grey
    '@' => RGB{Float64}(0.404, 0.430, 0.414), #grey
    'S' => RGB{Float64}(0.730, 0.361, 0.131), #brown
    'W' => RGB{Float64}(0.0940, 0.235, 0.940), #blue
    'X' => RGB{Float64}(0.0,0.0,0.0), #black
    'Q' => RGB{Float64}(0.770, 0.759, 0.100) #yellow
)

function convColor(fname::String)

    M::Matrix{Path} = fileToMatrix(fname)

    height::Int64 = size(M,1)
    witdh::Int64 = size(M,2)

    rgbMap::Matrix{RGB{Float64}} = fill(RGB{Float64}(1.0,1.0,1.0),height,witdh)

    for i in 1:height
        for j in 1:witdh
            rgbMap[i,j] = get(boxToRGB,M[i,j].type,3) 
        end
    end
    return rgbMap
end

function  affichageMap(fname::String,S::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    rgbMap::Matrix{RGB{Float64}} = convColor(fname)
    rgbMap[S[1],S[2]] = RGB{Float64}(0.268, 0.900, 0.126)
    rgbMap[A[1],A[2]] = RGB{Float64}(0.970, 0.0582, 0.119)
    height::Int64 = 512 
    witdh::Int64 = 512
    gui = imshow_gui((height, witdh),(1,1))
    canvases = gui["canvas"]
    imshow(canvases,rgbMap)
    Gtk.showall(gui["window"])
end

function affichageChemin(carte::Matrix{RGB{Float64}})
    height::Int64 = 512 
    witdh::Int64 = 512
    gui = imshow_gui((height, witdh),(1,1))
    canvases = gui["canvas"]
    imshow(canvases,carte)
    Gtk.showall(gui["window"])
end

function pathLaing!(rgbMap::Matrix{RGB{Float64}},path::Vector{Tuple{Int64,Int64}},visitedBox::Vector{Tuple{Int64,Int64}})
    for i in eachindex(visitedBox)
        rgbMap[visitedBox[i][1],visitedBox[i][2]] = get(boxToRGB,'Q',3)
    end
    for i in eachindex(path)
        rgbMap[path[i][1],path[i][2]] = get(boxToRGB,'X',3)
    end 
    return rgbMap
end