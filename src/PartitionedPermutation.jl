import Base: # TODO remove
    deepcopy,
    <=,
    length,
    ==,
    hash

using Oscar

####################################################################
# Functions for Set Partitions
####################################################################
# TODO Types for Sets Dicts Arrays like explained below
"""
    <=(V::SetPartition, W::SetPartition)

Check if the set partition `V` is dominated by the set partition `W`. This is the case if every block of `V`
is contained in exactly one block of `W`.
"""
function <=(V::SetPartition, W::SetPartition)
    @req size(V) == size(W) "arguments must have the same size"

    # obtain vectors describing the partitions V and W
    V_vec = deepcopy(V.upper_points)
    append!(V_vec, V.lower_points)
    W_vec = deepcopy(W.upper_points)
    append!(W_vec, W.lower_points)

    # introduce a dictionary to store a mapping from the blocks of V to the blocks of W
    block_map = Dict{Int, Int}()

    for (index, block) in enumerate(V_vec)
        # if the block of the index in V has already been mapped to a block of W,
        # check if the mapping is consistent, otherwise add the mapping
        if (haskey(block_map, block) && W_vec[index] != block_map[block])
            return false
        else
            block_map[block] = W_vec[index]
        end
    end
    return true
end

"""
    cycle_partition(p::Perm{Int})

Return the set partition whose blocks are the cycles of the permutation `p`. This set partition has no lower points.
"""
function cycle_partition(p::Perm{Int})
    cycle_list = collect(cycles(p))
    n = parent(p).n
    partition_vector = zeros(Int64, n)

    for (index, cycle) in enumerate(cycle_list)
        for element in cycle
            partition_vector[element] = index
        end
    end

    return SetPartition(partition_vector, Int64[])
end

"""
    join(V::SetPartition, W::SetPartition)

Return the join of `V` and `W`.
"""
function join(V::SetPartition, W::SetPartition)
    @req length(V.upper_points) == length(W.upper_points) "V and W must have the same number of upper points"
    @req length(V.lower_points) == length(W.lower_points) "V and W must have the same number of lower points"

    _V = SetPartition(vcat(V.upper_points, V.lower_points), vcat(V.upper_points, V.lower_points))
    _W = SetPartition(vcat(W.upper_points, W.lower_points), vcat(W.upper_points, W.lower_points))

    join_V_W = compose(_V, _W).upper_points

    return SetPartition(join_V_W[1:length(V.upper_points)], join_V_W[(length(V.upper_points)+1):end])
end



############################################################
# Partitioned Permutations
############################################################

# Constructor for Partitioned Permutations
"""
    PartitionedPermutation

The type of partitioned permutations. Fieldnames are
- p::Perm{Int} - a permutation
- V::SetPartition - a partition
If the permutation has length `n`, then the partition must have `n` upper points and 0 lower points. 
Further, if `W` is the partition given by the cycles of `p`, then `W` must be dominated by `V` in the 
sense that every block of `W` is contained in one block of `V`. There is one inner constructer of PartitionedPermutation:
- PartitionedPermutation(_p::Perm{Int}, _V::Vector{Int}) constructs the partitioned permutation where the partition is given by the vector _V.
"""
struct PartitionedPermutation
    p::Perm{Int}
    V::SetPartition

    function PartitionedPermutation(_p::Perm{Int}, _V::Vector{Int}) # ?
        __V = SetPartition(_V, Int[])
        @req parent(_p).n == length(_V) "permutation and partition must have the same length"
        @req cycle_partition(_p) <= __V "permutation must be dominated by partition"
        new(_p, __V)
    end
end

function ==(pp_1::PartitionedPermutation, pp_2::PartitionedPermutation)
    return pp_1.p == pp_2.p && pp_1.V == pp_2.V
end

function hash(pp::PartitionedPermutation, h::UInt)
    return hash(pp.p, hash(pp.V, h))
end

function deepcopy_internal(pp::PartitionedPermutation, stackdict::IdDict)
    if haskey(stackdict, pp)
        return stackdict[pp]
    end
    q = PartitionedPermutation(deepcopy_internal(pp.p, stackdict), 
                     deepcopy_internal(pp.V, stackdict))
    stackdict[pp] = q
    return q
end

# all kinds of length
function length(pp::PartitionedPermutation)
    return parent(pp.p).n
end

function length2(pp::PartitionedPermutation)
    p = pp.p
    V = pp.V
    return parent(p).n - (2*number_of_blocks(V) - length(cycles(p)))
end

# take into consideration:
# always comment your code, example from SetPartitions:
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