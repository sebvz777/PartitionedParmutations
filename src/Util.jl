# number of blocks in a partition
function number_of_blocks(V::SetPartition)
    # obtain one vector describing the partition V
    vec = deepcopy(V.upper_points)
    append!(vec, V.lower_points)

    # return the maximum number in vec
    if length(vec) != 0
        return maximum(vec)
    else
        return 0
    end
end

"""
    <=(V::Vector{Int}, W::Vector{Int})

Check if the vector of a set partition `V` is dominated by the vector of a set partition `W`. 
This is the case if every block of `V` is contained in exactly one block of `W`.
```
"""
function <=(V::Vector{Int}, W::Vector{Int})
    @req length(V) == length(W) "arguments must have the same size"

    # introduce a dictionary to store a mapping from the blocks of V to the blocks of W
    block_map = Dict{Int, Int}()

    for (index, block) in enumerate(V)
        # if the block of the index in V has already been mapped to a block of W,
        # check if the mapping is consistent, otherwise add the mapping
        if (haskey(block_map, block) && W[index] != block_map[block])
            return false
        else
            block_map[block] = W[index]
        end
    end
    return true
end