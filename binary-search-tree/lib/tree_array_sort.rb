def merge_sort (initial_array)
    # Array -> Array
    # Returns an array sorted in ascending order

    # If the length of the array is one it is sorted
    if initial_array.length <= 1
        return initial_array
    # If the length of array is more than one
    else
        # get midpoint of initial array to split in two halves
        array_middle_index = initial_array.length/2
        # Get sorted left side
        # (if original array is odd length, left side is one smaller than right)
        sorted_left_array = merge_sort(initial_array[0..(array_middle_index-1)])
        # Get sorted right side
        sorted_right_array = merge_sort(initial_array[array_middle_index..-1])
        # call merge_helper to merge to sides and return sorted array

        return _merge_helper(sorted_left_array, sorted_right_array)
    end
end

def _merge_helper (left_array, right_array)
    # Array, Array -> Array
    # Takes two sorted arrays (ascending order)
    # and merges them to make a single
    # sorted array (ascending order)
    # Note: used in merge_sort

    # Make array to store result sorted array
    result = []
    # Keep sorting until one of the arrays is empty
    until left_array.empty? || right_array.empty?
        # Check if left array has a smaller first value
        if left_array.first <= right_array.first
            # Add first left array element to result
            result.push(left_array.shift)
        # Check if right array has smaller first value
        elsif left_array.first > right_array.first
            # Add first right array element to result
            result.push(right_array.shift)
        end
    end
    # At this stage one array is empty and the other still has remaining elements
    # We check which is empty and append it to result
    # If left array is not empty append it to result
    unless left_array.empty?
        (result << left_array).flatten!
    # If right array is not empty append it to result
    else
        (result << right_array).flatten!
    end

    result

end
