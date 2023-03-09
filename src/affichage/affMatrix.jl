using Images,ImageView,Gtk.ShortNames

include("../convertion.jl")
include("../Dijkstra_algorithm/dijkstra.jl")

const Rgb::Dict{Char,RGB{Float64}} = Dict{Char,RGB{Float64}}(
    '.' => RGB{Float64}(1.0,1.0,1.0),
    'G' => RGB{Float64}(0.149, 0.950, 0.0760),
    'T' => RGB{Float64}(0.0570, 0.570, 0.254),
    'O' => RGB{Float64}(0.404, 0.430, 0.414),
    '@' => RGB{Float64}(0.404, 0.430, 0.414),
    'S' => RGB{Float64}(0.730, 0.361, 0.131),
    'W' => RGB{Float64}(0.0940, 0.235, 0.940),
    'X' => RGB{Float64}(0.0,0.0,0.0)
    )

function convColor(map::String)

    M::Matrix{Path} = convert(map)

    height::Int64 = size(M,1)
    witdh::Int64 = size(M,2)

    carte::Matrix{RGB{Float64}} = fill(RGB{Float64}(1.0,1.0,1.0),height,witdh)

    for i in 1:height
        for j in 1:witdh
            carte[i,j] = get(Rgb,M[i,j].type,3) 
            if mod(i,1000) == 0 
                println(carte[i,j])
            end
        end
    end
    return carte
end

function  affichageMap(map::String,S::Tuple{Int64,Int64},A::Tuple{Int64,Int64})
    carte::Matrix{RGB{Float64}} = convColor(map)
    carte[S[1],S[2]] = RGB{Float64}(0.268, 0.900, 0.126)
    carte[A[1],A[2]] = RGB{Float64}(0.970, 0.0582, 0.119)
    #Gtk.showall(imshow(carte)["gui"]["window"])
    height::Int64 = 512 
    witdh::Int64 = 512
    gui = imshow_gui((height, witdh),(1,1))
    canvases = gui["canvas"]
    imshow(canvases,carte)
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

function pathLaing!(carte::Matrix{RGB{Float64}},path::Vector{Tuple{Int64,Int64}})
    for i in eachindex(path)
        carte[path[i][1],path[i][2]] = get(Rgb,'X',3)
        #println((path[i].coor[1],path[i].coor[2]))
    end 
    return carte
end