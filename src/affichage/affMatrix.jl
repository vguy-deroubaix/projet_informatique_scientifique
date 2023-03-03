using Images

include("../convertion.jl")

const Rgb::Dict{Char,RGB{Float64}} = Dict{Char,RGB{Float64}}(
    '.' => RGB{Float64}(0.149, 0.950, 0.0760),
    'G' => RGB{Float64}(0.149, 0.950, 0.0760),
    'T' => RGB{Float64}(0.0570, 0.570, 0.254),
    'O' => RGB{Float64}(0.404, 0.430, 0.414),
    '@' => RGB{Float64}(0.404, 0.430, 0.414),
    'S' => RGB{Float64}(0.730, 0.361, 0.131),
    'W' => RGB{Float64}(0.0940, 0.235, 0.940)
    )

function refill(map::Matrix{Path})

    height::Int64 = size(map,1)
    witdh::Int64 = size(map,2)

    M::Array{Array{Path}} = Array{Array{Path}}(undef,height,witdh)

    for i in 1:height 
        for j in 1:witdh
            M[i][j] = map[i,j]
        end
    end
    return M
end

function convColor(map::String)

    M::Array{Array{Path}} = refill(convert(map))

    height::Int64 = size(M,1)
    witdh::Int64 = size(M,2)

    carte::Array{Array{RGB{Float64}}} = Array{Array{RGB{Float64}}}(undef,height,width)

    for i in 1:height
        for j in 1:witdh
            carte[i][j] = get(Rgb,M[i][j].type,3) 
            if mod(i,1000) == 0 
                println(carte[i][j])
            end
        end
    end
    return carte
end

function  affichage(carte::Array{RGB{Float64}})
    height::Int64 = size(carte,1)
    witdh::Int64 = size(carte,2)
    gui = imshow_gui((height, witdh))
    canvases = gui["canvas"]
    makeimage(color) = fill(color, 100, 100)
    imgs = makeimage.(carte)
    anns = fill(annotations(),height,witdh)
    roidict = fill(inshow)

end