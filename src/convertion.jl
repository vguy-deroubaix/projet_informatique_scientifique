
struct Path
    type::Char
    cost::Int64
end


function convertion(map::String,ct::Int64,ci::Int64,cd::Int64)
    deb::Int64 = 5
    open(map,"r") do io
        f::Vector{String} = readlines(io)
        
        height::Int64 = parse(Int64,split(f[2]," ")[2]) 
        widht::Int64 = parse(Int64,split(f[3], " ")[2])
        
        M::Matrix{Path} = Matrix{Path}(undef,height,widht)
        
        for i = deb:height
            
            for j = 1:widht
                c::Char = f[i][j]
                if c == '.' || c == 'G' #terrain traversable
                    @inbounds M[i,j] = Path(c,1)
                elseif c == '@' || c == 'O' #terrain hord carte
                    @inbounds M[i,j] = Path(c,100)
                elseif c == 'T' #terrain intrversable (arbre)
                    @inbounds M[i,j] = Path(c,100)
                else #terrain difficile
                    @inbounds M[i,j] = Path(c,25)
                end   
            end
        end
    end
end


function mainConv(map::String)
    
    convertion(map,1,100,25)
    
end
 
