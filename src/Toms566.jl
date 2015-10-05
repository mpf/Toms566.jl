module Toms566

lib566 = joinpath(Pkg.dir(),"Toms566","src","lib566")

import Base.show
export Problem, show

type Problem
    n::Int
    name::AbstractString
    x0::Vector
    obj::Function
    grd::Function
    grd!::Function
    hes::Function
    hes!::Function
end

function Problem(prob::Int)

    # Name and initial point.
    (n, name) = nvars(prob)
    x0 = Vector{Float64}(n)
    initpt_(n, x0, prob)

    # Hessian storage.
    hesd = Vector{Float64}(n)
    hesl = Vector{Float64}(n*(n-1)÷2)

    # Functions.
    obj(x::Vector) = objfcn_(n, x, prob)
    grd(x::Vector) = grdfcn(n, x, prob)
    grd!(x::Vector, g::Vector) = grdfcn_(n, x, g, prob)
    hes(x::Vector) = hesfcn(n, x, hesd, hesl, prob)
    hes!(x::Vector, H::Array) = hesfcn!(n, x, H, hesd, hesl, prob)
    
    # Constructor
    Problem(n, name, x0, obj, grd, grd!, hes, hes!)
end

function show(io::IO, p::Problem)
    println(io, summary(p), ":")
    println(io, " name: $(p.name)")
    print(io, " n: $(p.n)")
end

function nvars(prob::Int)
    if prob == 1
        (3, "Hellical valley")
    elseif prob == 2
        (6, "Bigg's EXP6")
    elseif prob == 3
        (3, "Gaussian")
    elseif prob == 4
        (2, "Powell")
    elseif prob == 5
        (3, "Box 3-dim")
    elseif prob == 6
        (40, "Variably dimensioned")
    elseif prob == 7
        (50, "Watson")
    elseif prob == 8
        (60, "Penalty I")
    elseif prob == 9
        (65, "Penalty II")
    elseif prob == 10
        (2, "Brown badly scaled")
    elseif prob == 11
        (4, "Brown and Denis")
    elseif prob == 12
        (3, "Gulf research and development")
    elseif prob == 13
        (40, "Trigonometric")
    elseif prob == 14
        (50, "Extended rosenbrock")
    elseif prob == 15
        (60, "Extended Powell singular")
    elseif prob == 16
        (2, "Beale")
    elseif prob == 17
        (4, "Wood")
    elseif prob == 18
        (60, "Chebyquad")
    else
        error("Not a valid problem.")
    end
end

# ######################################################################
# Create a symmetric matrix from the diagonal and the upper triangle,
# both stored in vectors.
function updtosymm!(hesd::Vector, hesl::Vector, H::Array)
    n = length(hesd)
    k = 0
    for j = 1:n
        H[j,j] = hesd[j]
        for i = j+1:n
            k += 1
            H[i,j] = H[j,i] = hesl[k]
        end
    end
end

function grdfcn(n::Int, x::Vector, prob::Int)
    g = similar(x)
    grdfcn_(n, x, g, prob)
    return g
end

function hesfcn(n::Int, x::Vector, hesd::Vector, hesl::Vector, prob::Int)
    H = Array{Float64}(n,n)
    hesfcn!(n, x, H, hesd, hesl, prob)
    return H
end

function hesfcn!(n::Int, x::Vector, H::Array, hesd::Vector, hesl::Vector, prob::Int)
    hesfcn_(n, x, hesd, hesl, prob)
    updtosymm!(hesd, hesl, H)
end

# ######################################################################
# Interfaces to Fortran routines.
# ######################################################################
function initpt_(n::Int, x::Vector, prob::Int)
    factor = Cdouble[1.0]
    ccall( (:initpt_, lib566), Void,
           (Ptr{Cint},Ptr{Cdouble},Ptr{Cint},Ptr{Cdouble}),
           &n, x, &prob, factor)
end

function objfcn_(n::Int, x::Vector{Float64}, prob::Int)
    f = Cdouble[1.0]
    ccall( (:objfcn_, lib566), Void,
           (Ptr{Cint},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint}),
           &n, x, f, &prob)
    return f[1]
end

function grdfcn_(n::Int, x::Vector{Float64}, g::Vector{Float64}, prob::Int)    
    ccall( (:grdfcn_, lib566), Void,
           (Ptr{Cint},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint}),
           &n, x, g, &prob)
end

function hesfcn_(n::Int, x::Vector{Float64}, hesd::Vector, hesl::Vector, prob::Int)
    ccall( (:hesfcn_, lib566), Void,
           (Ptr{Cint},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cdouble},Ptr{Cint}),
           &n, x, hesd, hesl, &prob)
end

end # module
