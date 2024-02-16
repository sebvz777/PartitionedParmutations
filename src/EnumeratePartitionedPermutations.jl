using Oscar.Generic # TODO: Why is this necessary?

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
function _enumerate_all_partitions(n::Int, start::Int=0)
    # TODO: Fix the problem that the function does not work correctly for n = 1, below is only a quick fix
    if n==1
        return [[1]]
    end

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
function _enumerate_permutations_recursive(elements::Union{Array{Int}, UnitRange{Int}})
    if length(elements) == 1
        return [elements]
    end
    perms = []
    for i in eachindex(elements)
        remaining_elements = [elements[j] for j in eachindex(elements) if j ≠ i]
        sub_perms = _enumerate_permutations_recursive(remaining_elements)
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
function enumerate_partitioned_perm_old(n::Int)
    partitioned_permutations = []
    for i in _enumerate_all_partitions(n)
        for ii in _enumerate_permutations_recursive(1:n)
            ii_p = cycle_partition(Perm(ii))
            if ii_p.upper_points <= i
                push!(partitioned_permutations, PartitionedPermutation(Perm(ii), i))
            end
        end
    end
    return partitioned_permutations
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

    # Iterate over all permutations
    for i in _enumerate_permutations_recursive(1:n) # TODO replace with Oscar function
        pp = cycle_partition(Perm(i)).upper_points
        partitions_dominating = [pp]
        
        # For every new fitting partition found, get more variations
        first_iteration = true
        for partition_iter in partitions_dominating
            blocks = Set{Int}(partition_iter)
            first_iteration ? (length(blocks) == 1 && continue) : (length(blocks) < 3 && continue)
            first_iteration = false

            # Retrieve variations by merging all different subsets of the blocks of a partition
            for ii in [i for i in subsets(blocks)]
                length(ii) == 1 && continue
                block_to_merge = !isempty(ii) ? first(ii) : continue
                merge_blocks = Dict{Int, Int}([(x, block_to_merge) for x in ii])

                # apply merge
                new_partition = []
                for b in partition_iter
                    push!(new_partition, get(merge_blocks, b, b))
                end

                # push into output set and iterate again over partititons so that we apply every
                # merge by subset to the partition (example (TODO delete later): for the permutation
                # (1)(234)(5)(6) we do not merge f.e. 1 and 5 AND 234 and 6 since we 
                # only merge one subset per iteration, we only merge 1 5 and 234 6 in different new_partitions)
                push!(partitions_dominating, new_partition)
            end
        end

        # finally produce PartititonedPermutations without double checking properties
        for ii in Set{Vector{Int}}(partitions_dominating)
            push!(partitioned_permutations, PartitionedPermutation(Perm(i), ii, false))
        end
    end

    return partitioned_permutations
end


function enumerate_partitioned_perm_new(n::Int)
    
    partitioned_permutations = []

    # Iterate over all permutations
    for p in Generic.elements!(Generic.SymmetricGroup(n))
        cycle_part = cycle_partition(p)
        number_of_cycles = number_of_blocks(cycle_part)
        cycle_part_vec = cycle_part.upper_points


        # Iterate over all partitions dominating p, 
        # those are obtained by merging blocks of the cycle partition of p
        for block_partition in _enumerate_all_partitions(number_of_cycles)
            
            # merge blocks of cycle_part according to block_partition
            part_vec = map(cycle_part_vec) do index
                block_partition[index]
            end

            # add the obtained partitioned permutation to the list
            push!(partitioned_permutations, PartitionedPermutation(deepcopy(p), part_vec, false))
        end
    end

    return partitioned_permutations
end
