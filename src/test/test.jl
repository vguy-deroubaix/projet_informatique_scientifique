
struct Path
    type::Char
    cost::Int16
end


function convertion(map::String,ct::Int64,ci::Int64,cd::Int64)
    open(map,"r") do io
        f::Vector{String} = readlines(io)
        
        height::UInt16= parse(UInt16,split(f[2]," ")[2]) 
        widht::UInt16 = parse(UInt16,split(f[3], " ")[2])
        
        M::Matrix{Path} = Matrix{Path}(undef,height,widht)
        
        @simd for i = 1:height
            for j = 1:widht
                c::Char = f[i+4][j]
                if c == '.' || c == 'G' #terrain traversable
                   @inbounds M[i,j] = Path(c,1)
                elseif c == '@' || c == 'O' #terrain hord carte
                   @inbounds M[i,j] = Path(c,100)
                elseif c == 'T' #terrain intrversable (arbre)
                   @inbounds M[i,j] = Path(c,100)
                elseif c == 'W' || c == 'S'
                   @inbounds M[i,j] = Path(c,25)
               end   
            end
            #if mod(i,10) == 0
            #    println(M[i,:])
            #end
        end
        return M
    end
end

function main(map::String)
    
    return convertion(map,1,100,25)
    
end
 
