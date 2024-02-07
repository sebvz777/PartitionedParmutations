
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