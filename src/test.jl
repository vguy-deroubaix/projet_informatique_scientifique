using Plots

include("main.jl")

function dataJAnalyse(donne::Vector{Tuple{Float64,Float64}})

    compteurOpti::Int64 = 0
    compteurTemps::Int64 = 0

    for i = 1:size(donne,1)
        if donne[i][1] == 1.0
            compteurOpti = compteurOpti +1
        end
        if donne[i][2] >= 0.0
            compteurTemps = compteurTemps +1
        end
    end
    return (compteurOpti/size(donne,1)*100.0,compteurTemps/size(donne,1)*100.0)

end


function dataJAnalyse2(donne::Vector{Tuple{Float64,Float64}},avgTime::Float64)

    compteurOpti::Float64 = 0.0
    compteurTemps::Float64 = 0.0

    for i = 1:size(donne,1)
        compteurOpti = compteurOpti + donne[i][1]
        compteurTemps = compteurTemps + donne[i][2]
    end
    return (compteurOpti/size(donne,1),(compteurTemps/size(donne,1))/avgTime)


end


function reajustement(size::Int64)

    return floor(Int64,convert(Float64,size)*0.9)

end

function reajustementFile(size::Int64)

    return floor(Int64,convert(Float64,size)*0.85)

end

function testEnSerie(dname::String,w::Float64)
    dir::Vector{String} = readdir("../Scenario/"*dname*"/")
    donne::Vector{Tuple{Float64,Float64}} = []
    dataJ::Vector{Tuple{Float64,Float64}} = []
    timeA::Float64 = 0.0
    timeWA::Float64 = 0.0
    iter::Int64 = 1

    println("dir size : ", size(dir,1))
    for j = 1:(size(dir,1)-reajustement(size(dir,1)))
        fname = split(dir[j],".")[1]*".map"
        open("../Scenario/"*dname*"/"*dir[j],"r") do io
            f::Vector{String} = readlines(io)
            D::Tuple{Int64,Int64} = (0,0)
            A::Tuple{Int64,Int64} = (0,0)
            line::Vector{String} = []
            shortestPath::Vector{Tuple{Int64,Int64}} = []
            visitedBox::Vector{Tuple{Int64,Int64}} = []
            nombreEtatvisite::Int64 = 0
            pathCost::Int64 = 0

            shortestPathW::Vector{Tuple{Int64,Int64}} = []
            visitedBoxW::Vector{Tuple{Int64,Int64}} = []
            nombreEtatvisiteW::Int64 = 0
            pathCostW::Float64 = 0

            cpt::Int64 = 0
            times::Vector{Float64} = []
            
            for i = 2:(size(f,1)-reajustementFile(size(f,1)))
                line = split(f[i])
                D = ((parse(Int64,line[5]),parse(Int64,line[6])))
                A = ((parse(Int64,line[7]),parse(Int64,line[8])))

                #println("ligne ",i," : ",D,A, " dossier :",dir[j], ", file : ", fname)
                if !(D[1] == 0 || D[2] == 0 || A[1] == 0 || A[2] == 0) && !()
                    timeA = @elapsed (shortestPath,visitedBox,nombreEtatvisite,pathCost) = pathFindingAstar(fileToMatrix(line[2]),D,A)
                    timeWA = @elapsed (shortestPathW,visitedBoxW,nombreEtatvisiteW,pathCostW) = pathFindingWAstar(fileToMatrix(line[2]),D,A,w)
                    if pathCost > 0 
                        pushfirst!(dataJ,((convert(Float64,pathCost)/pathCostW),timeA-timeWA))
                    end
                end 
            end
            push!(donne,dataJAnalyse(dataJ))
            #push!(times,timeA)
            #push!(donne,dataJAnalyse2(dataJ,moyenne2(times)))
            dataJ = []
        end
    end
    return moyenne(donne)
end


function moyenne(donne::Vector{Tuple{Float64,Float64}})

    compteurOpti::Float64 = 0.0
    compteurTemps::Float64 = 0.0

    for i = 1:size(donne,1)
        compteurOpti = compteurOpti + donne[i][1]
        compteurTemps = compteurTemps + donne[i][2]
    end
    return (compteurOpti/size(donne,1),compteurTemps/size(donne,1))
end

function moyenne2(donne::Vector{Float64})

    compteurTime::Float64 = 0.0

    for i = 1:size(donne,1)
        compteurTime = compteurTime +donne[i]
    end
    return compteurTime/size(donne,1)

end

function splitOT(donne::Tuple{Float64,Float64},OT::Bool)
    if OT
        return donne[1]
    else
        return donne[2]
    end
end

function printCourbOpti(dname::String)

    x = range(0,1,length=10)
    y1 = splitOT.(testEnSerie.(dname*"-scen",x),true)
    y2 = splitOT.(testEnSerie.(dname*"-scen",x),false)
    #plot(x,y2)
    plot(x,[y1,y2])
end


function testStandar()

    w::Vector{Float64} = [0.1,0.3,0.5,0.7,0.9]
    dname::Vector{String} = ["room-scen","maze-scen","random-scen","street-scen"]  
    donne::Vector{Vector{Tuple{Float64,Float64}}} = [[],[],[],[]]
    tmp::Tuple{Float64,Float64} = (0.0,0.0)

    for j = 1:size(dname,1)
        println("début de test pour : ", dname[j]," ---------------")
        for i = 1:size(w,1)
            tmp = testEnSerie(dname[j],w[i])
            pushfirst!(donne[j],tmp)
            println("pour w = ",w[i],", ",tmp)
        end
        println("fin de test pour : ", dname[j])
    end
    println(donne)

end 

function testStandarU(dname::String)

    w::Vector{Float64} = [0.1,0.3,0.5,0.7,0.9]
    donne::Vector{Tuple{Float64,Float64}} = []
    tmp::Tuple{Float64,Float64} = (0.0,0.0)


    println("début de test pour : "*dname*"-scen ---------------")
    for i = 1:size(w,1)
        tmp = testEnSerie(dname*"-scen",w[i])
        pushfirst!(donne,tmp)
        println("pour w = ",w[i],", ",tmp)
    end
    println("fin de test pour : "*dname*"-scen")
end 

function test()

    w::Vector{Float64} = [0.1,0.3,0.5,0.7,0.9]
    donne::Vector{Tuple{Float64,Float64}} = []
    tmp::Tuple{Float64,Float64} = (0.0,0.0)


    println("début de test pour : maze-scen ---------------")
    for i = 1:size(w,1)
        tmp = testEnSerie("maze-scen",w[i])
        pushfirst!(donne,tmp)
        println("pour w = ",w[i],", ",tmp)
    end
    println("fin de test pour : maze-scen")
end 



function slitpOTV(donne::Vector{Tuple{Float64,Float64}},OT::Bool)

    opti::Vector{Float64} = []
    time::Vector{Float64} = []

    if OT
        for i = 1:size(donne,1)
            push!(opti,donne[i][1])    
        end
        return opti
    else
        for i = 1:size(donne,1)
            push!(time,donne[i][2])    
        end
        return time
    end
end 


