
struct Path
    type::Char
    cost::UInt16
    coord::Tuple{UInt16,UInt16}
end


function convertion(map::String,ct::Int64,ci::Int64,cd::Int64)
    open(map,"r") do io
        f::Vector{String} = readlines(io)
        
        height::UInt16 = parse(Int64,split(f[2]," ")[2]) 
        widht::UInt16 = parse(Int64,split(f[3], " ")[2])
        
        M::Matrix{Path} = Matrix{Path}(undef,height,widht)
        
        for i = 1:height
            
            for j = 1:widht
                c::Char = f[i+4][j]
                if c == '.' || c == 'G' #terrain traversable
                    @inbounds M[i,j] = Path(c,1,(i,j))
                elseif c == '@' || c == 'O' #terrain hord carte
                    @inbounds M[i,j] = Path(c,100,(i,j))
                elseif c == 'T' #terrain intrversable (arbre)
                    @inbounds M[i,j] = Path(c,100,(i,j))
                else #terrain difficile
                    @inbounds M[i,j] = Path(c,25,(i,j))
                end   
            end
        end
        return M
    end
end


function convert(map::String)
    
    return convertion(map,1,100,25)
    
end
 
