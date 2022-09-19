# Coordinate storage x and y

# Get start and end squares
# Store moves made
# Make queue to go through breadth first search
# Add initial square to queue

# Keep going through queue until it is empty:
    # Get next square from queue
    # Check if desired square is reached
    # Add all neighbours of square (neighbours are squares the knight can go to)
    # Ignore neighbours outside the board
    # Track already visited squares

require "./lib/reverse_tree.rb"

class KnightTravalis

    def initialize (board_size=8)
        @board_size = board_size
        @movement_set = [
            [ 2, 1],
            [ 2,-1],
            [-2, 1],
            [-2,-1],
            [ 1, 2],
            [ 1,-2],
            [-1, 2],
            [-1,-2]
        ]
    end

    def knight_moves (start_square, end_square)
        # Array, Array -> str

        # Store history of traversed nodes
        history = []
        # Create queue to traverse a breadth first search of movements
        # Add reverse node with start square
        traversal_queue = [ReverseTreeNode.new(start_square)]
        # Bool to see if we have reached the desired square
        square_reached = false

        # Continue search while there are still nodes in the traversal queue and desired node
        # not reached
        until traversal_queue.empty? || square_reached
            # Get next node in traversal queue (this is a ReverseTreeNode)
            current_square = traversal_queue.shift
            # Add current square data to history of visited nodes
            history.push(current_square.data)
            # If the coordinates of current square are the end square set square reached to true
            square_reached = true if current_square.data == end_square
            unless square_reached
                # Add all potential valid squares from current square to traversal queue
                # Square is valid to move to if:
                # (1) We haven't already visited it (not in history)
                # (2) A knight could move to it from the current square (use @movement_set)
                # if desired square is found set square reached to true
                # For each possible movement we check the new square
                @movement_set.each do |movement|
                    # Store coordinates for new square
                    new_square_coordinates = _add_arrays(current_square.data, movement)
                    # Create new node for new square if square is valid and insert in traversal queue
                    if _valid?(new_square_coordinates, history)
                        # Insert node for this square descending from current square storing moves
                        traversal_queue.push(
                            ReverseTreeNode.new(new_square_coordinates, current_square)
                        )
                    end
                end
            end  
        end
        puts _min_moves_data(current_square)
    end

    # private

    def _min_moves_data (given_node)
        # ReverseTreeNode -> str
        # Takes a Reverse Tree representing a move order from one chess board square to another
        # with a knight and gives a string of the number of moves and move order

        # Store the moves needed to get from start square to end
        moves_needed = 0
        # Start traversing at the given node
        current_node = given_node
        # Store the squares traversed in order
        square_order = []
        # Traverse nodes till nil reached (there is no parent above so root is reached)
        # (root is the starting square)
        until current_node.nil?
            # Add each node data to the start of the queue to have a start square to end square
            # move order
            square_order.unshift(current_node.data)
            # Move one level above in move order
            current_node = current_node.parent
            # Increase moves needed by one
            moves_needed += 1
        end
        # Add to result string to show moves needed
        result = "Minimum moves needed to get from #{square_order[0]} to #{square_order[-1]}:" +
            " #{moves_needed} moves\n"
        result += "traversal order:\n"
        # Add each square's data in a line to result string to show move order
        square_order.each do |square|
            result += "[#{square.join(", ")}]\n"
        end
        result
    end

    def _valid?(current_data, history)
        # Reverse

        # current_data = current_node.data
        # If current node is in history
        # or not 0 <= x-coordinate < board_size
        # or not 0 <= y-coordinate < board_size
        # Then we want false (the node value is invalid)
        if history.include?(current_data) ||
            current_data[0] < 0 ||
            current_data[0] >= @board_size ||
            current_data[1] < 0 ||
            current_data[1] >= @board_size
            return false
        # Else return true
        else
            return true
        end
    end

    def _add_arrays (array1, array2)
        # Array, Array -> Array
        # Takes to equal size arrays and returns array whose elements are the sum of the
        # corresponding elements of the other two arrays

        # Store length of first array
        array_length = array1.length
        # Check if arrays are same size
        raise IndexError.new("The array sizes do not match") unless array_length == array2.length
        # Create add counter to go through each array element
        add_counter = 0
        # Result array to hold summations
        result = []
        while add_counter < array_length
            result.push(array1[add_counter] + array2[add_counter])
            add_counter += 1
        end
        result
    end

end
