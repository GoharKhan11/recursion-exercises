module TreeSort

    def tree_merge_sort (initial_array)
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
            sorted_left_array = tree_merge_sort(initial_array[0..(array_middle_index-1)])
            # Get sorted right side
            sorted_right_array = tree_merge_sort(initial_array[array_middle_index..-1])
            # call merge_helper to merge to sides and return sorted array

            return _tree_merge_helper(sorted_left_array, sorted_right_array)
        end
    end

    private

    def _tree_merge_helper (left_array, right_array)
        # Array, Array -> Array
        # Takes two sorted arrays (ascending order)
        # and merges them to make a single
        # sorted array (ascending order)
        # Note: Removes duplicate entries
        # Note: used in merge_sort

        # Make array to store result sorted array
        result = []
        # Keep sorting until both of the arrays are empty
        until left_array.empty? && right_array.empty?
            # If the next left array entry already exists in the result, discard it
            # Note: we are removing duplicates
            if !result.empty? && result[-1] == left_array.first
                left_array.shift
            # If the next right array entry already exists in the result, discard it
            # Note: we are removing duplicates
            elsif !result.empty? && result[-1] == right_array.first
                right_array.shift
            # If left array is empty we can only add from right array
            elsif left_array.empty?
                result.push(right_array.shift)
            # If right_array is empty we can only add from left array
            elsif right_array.empty?
                result.push(left_array.shift)
            # Check if left array has a smaller first value
            elsif left_array.first <= right_array.first
                # Add first left array element to result
                result.push(left_array.shift)
            # Check if right array has smaller first value
            elsif left_array.first > right_array.first
                # Add first right array element to result
                result.push(right_array.shift)
            end
        end
        result

    end

end
