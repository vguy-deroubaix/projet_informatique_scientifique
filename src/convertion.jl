
struct Path
    type::Char
    cost::Int64
end


function convertion(fname::String,ct::Int64,cs::Int64,cw::Int64)
    open("../data/"*fname,"r") do io
        f::Vector{String} = readlines(io)
        
        height::Int64 = parse(Int64,split(f[2]," ")[2]) 
        widht::Int64 = parse(Int64,split(f[3], " ")[2])
        
        M::Matrix{Path} = Matrix{Path}(undef,height,widht)
        
        for i = 1:height
            for j = 1:widht
                c::Char = f[i+4][j]
                if c == '.' || c == 'G' #terrain traversable
                    @inbounds M[i,j] = Path(c,ct)
                elseif c == '@' || c == 'O' #terrain hord carte
                    @inbounds M[i,j] = Path(c,typemax(Int64))
                elseif c == 'T' #terrain intrversable (arbre)
                    @inbounds M[i,j] = Path(c,typemax(Int64))
                elseif c == 'S'
                    @inbounds M[i,j] = Path(c,cs)
                else  #pour c == 'W'
                    @inbounds M[i,j] = Path(c,cw)
                end   
            end
        end
        return M
    end
end


function fileToMatrix(fname::String)
    
    return convertion(fname,1,5,8)
    
end