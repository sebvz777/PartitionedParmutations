"""
    enumerate_all_partitions(n::Int, start::Int=0)

Return and efficiently calculate vector of all partitions of length `n`.
This function is a helper function for `enumerate_partitioned_perm`.

# Examples
```jldoctest
julia> length(enumerate_all_partitions(6))
203
```
"""
function enumerate_all_partitions(n::Int, start::Int=0)
    partitions = start == 0 ? [[1]] : [[start]]
    first_element = start == 0 ? 1 : start
    
    index_to_cut = 0
    count = false
    for i in partitions
        blocks = maximum(i)
        length(i) == n && continue
        count = (length(i) == n - 1)
        for ii in (first_element):(blocks+1)
            push!(partitions, vcat(i, ii))
            if count
                index_to_cut += 1
            end
        end
    end
    return last(partitions, index_to_cut)
end

"""
    enumerate_permutations_recursive(elements::Array{Int})

Return and calculate vector of all permutations of `elements`.
This function is a helper function for `enumerate_partitioned_perm`.

# Examples
```jldoctest
julia> length(enumerate_permutations_recursive(1:6))
720
```
"""
function enumerate_permutations_recursive(elements::Union{Array{Int}, UnitRange{Int}})
    if length(elements) == 1
        return [elements]
    end
    perms = []
    for i in eachindex(elements)
        remaining_elements = [elements[j] for j in eachindex(elements) if j ≠ i]
        sub_perms = enumerate_permutations_recursive(remaining_elements)
        for p in sub_perms
            push!(perms, vcat(elements[i], p))
        end
    end
    return perms
end

"""
    enumerate_partitioned_perm(n::Int)

Return and calculate all `PartitionedPermutation` objects of length `n`

# Examples
```jldoctest
julia> length(enumerate_partitioned_perm(6))
4051
```
"""
function enumerate_partitioned_perm(n::Int)
    partitioned_permutations = []
    for i in enumerate_all_partitions(n)
        for ii in enumerate_permutations_recursive(1:n)
            ii_p = cycle_partition(Perm(ii))
            if ii_p.upper_points <= i
                push!(partitioned_permutations, PartitionedPermutation(Perm(ii), i))
            end
        end
    end
    return partitioned_permutations
end
