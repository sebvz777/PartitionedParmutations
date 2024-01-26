using Oscar

#If you can run this you are fine!
a = SetPartition([1, 3], [3, 1])
b = SetPartition([1, 3], [3, 3])

println(tensor_product(a, b))

# Constructor for Partitioned Permuations

# Join
# Given permutaion pi, construct O_pi
# all kinds of lengths 


# take into consideration:
# always comment yout code, example from SetPartitions:
"""
    tensor_product(p::SetPartition, q::SetPartition)

Return the tensor product of `p` and `q`.

The tensor product of two partitions is given by their horizontal concatenation.
See also Section 4.1.1 in [Gro20](@cite).

# Examples
```jldoctest
julia> tensor_product(set_partition([1, 2], [2, 1]), set_partition([1, 1], [1]))
SetPartition([1, 2, 3, 3], [2, 1, 3])
```
"""
# for more complex functions with more arguments also comment on the different arguments like for example:
"""
    construct_category(p::Vector{AbstractPartition}, n::Int, tracing::Bool = false, 
        max_artifical::Int = 0, spatial_rotation::Union{Functi on,Nothing}=nothing)

Return a list of all partitions of size `n` which can be constructed from category 
operations using partitions in `p` and without using partitions of size greater than 
`max(n, maxsize(p), max_artifical)`.

Category operations include composition, tensor product, involution, 
rotation and reflection. See Section 4.1.1 in [Gro20](@cite) 
for more information on categories of partitions and these operations. 

See also Section 4 in [Vol23](@cite) for a description of the underlying algorithm.

# Arguments
- `p`: list of partitions
- `n`: size of partitions to construct
- `tracing` (optional): return additional data to allow tracing using `print_trace` 
- `max_artifical` (optional): allow partitions to grow larger then `n` and `maxsize(p)`
- `spatial_rotation` (optional): function which performs a rotation on `SpatialPartition`

# Returns
- list of all partitions of size `n` constructed from partitions in `p`

# Examples
```jldoctest
julia> length(construct_category([SetPartition([1, 2], [2, 1])], 6))
105
```
"""
# make code short an easy
# -> use helper functions and implement them in Util.jl
# helper functions always start with _ 
# function names are small with _ like "tensor_product". Constructors start with a capital letter like "SetPartition"
# instead of copy always use deep_copy
# eventhough julia returns the last expression, the Oscar people want us to use return stmts
# use for complex data structures like dicts, Sets, Arrays, Vectors etc. types, example from SetPartitions:
"""all_partitions_by_size = Dict{Int, Set{Int}}()""" # instead of all_partitions_by_size = Dict()
# I would recommend using VS Code for programming in julia 