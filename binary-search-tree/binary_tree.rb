require "./lib/tree_array_sort.rb"
require "./lib/tree_node.rb"
require "./lib/invalid-node-error.rb"

class BinarySearchTree
    # Note: BST = Binary SearchTree

    include TreeSort

    attr_reader :root

    def initialize (tree_array=[])
        # Array -> BinarySearchTree
        # Initializes an array as a balanced BST

        # If the tree array is empty set root as nil
        if tree_array == []
            @root = nil
        # If tree array is not empty we make a BST
        else
            # sort tree array and remove duplicates
            # Note: uses TreeSort module
            tree_array = self.tree_merge_sort(tree_array)
            # build a balanced binary tree from the sorted tree array
            @root = build_tree(tree_array, 0, tree_array.length-1)
        end

    end

    def build_tree (tree_array, start_index, end_index)
        # Array, int, int -> BinaryTreeNode
        # Uses a non-empty sorted array without duplicates to make
        # a balanced binary search tree

        # Check if our start and end indexes have crosses meaning
        # no more lementsare left in the array to add to the balanced BST
        # so we return nil

        if start_index > end_index
            return nil
        # Check if there are more elements in the tree array
        else
            # Get the element in the middle of the array (rounded down)
            middle_index = (start_index + end_index)/2

            # Make a tree node with the middle array element
            tree_root = BinaryTreeNode.new(tree_array[middle_index])

            # recursively construct left subtree and set as left child
            # of root
            tree_root.left_child = build_tree(tree_array, start_index, middle_index-1)
            # recursively construct left subtree and set as left child
            # of root
            tree_root.right_child = build_tree(tree_array, middle_index+1, end_index)
            return tree_root
        end

    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        # BinaryTreeNode, str, bool -> str
        # Creates a string representation of the tree going left to right
        # from higher level to lower levels.
        # Note: uses is_left to format branch (to extend down if true or up if false)
        # Note: uses prefix to store how long branch is on a higher level
        #       the higher the level the longer the branch

        # Recursively create string representation of right subtree
        pretty_print(node.right_child,
            "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
        # Adds end of branch and data of current node
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        # recursively calls on right subtree
        pretty_print(node.left_child,
            "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
    end

    # Start: get methods

    def get_node (value)
        # int -> BinaryTreeNode/nil
        # Returns the node in the BST with the desired value.
        # Returns nil if no node was found with desired value.

        # Set initial value of the current node as the root node
        current_node = @root
        # Keep moving down the tree until no more nodes remain (nil value reached)
        # or desired node is found
        until current_node.nil? || current_node.data == value
            # If desired value is lesser than current node data move to
            # left subtree (which would have a smaller value than the parent)
            if value < current_node.data
                current_node = current_node.left_child
            # If desired value is greater than current node data move to
            # right subtree (which would have a bigger value than the parent)
            else
                current_node = current_node.right_child
            end
        end
        current_node
    end

    def get_parent (value)
        # int -> BinaryTreeNode/nil
        # Returns the node in the BST which has a child
        # with the desired child.
        # Returns nil if no node was found with desired value.

        # If the desired value is the root node then raise error
        # as root has no parent
        if value == @root.data
            raise InvalidNodeError.new("Root node has no parent node")
        end

        # Store parent node of desired node
        parent_node = @root
        # Store current node as we look for desired node
        current_node = @root

        # Move down till no more nodes left or desired node reached
        until current_node.nil? || value == current_node.data
            # If desired value is lesser than current node data move to
            # left subtree (which would have a smaller value than the parent)
            if value < current_node.data
                # Set current node as parent before moving to child
                parent_node = current_node
                current_node = current_node.left_child
            # If desired value is greater than current node data move to
            # right subtree (which would have a bigger value than the parent)
            else
                # Set current node as parent before moving to child
                parent_node = current_node
                current_node = current_node.right_child
            end
        end
        raise InvalidNodeError.new("Node with value #{value} does not exist") if current_node.nil?
        parent_node
    end

    def get_min (current_node=@root)
        # BinaryTreeNode -> BinaryTreeNode
        # Get the minimum value node in the subtree
        # Default subtree: @root

        while current_node.has_left?
            current_node = current_node.left_child
        end
        current_node
    end

    def get_max (current_node=@root)
        # BinaryTreeNode -> BinaryTreeNode
        # Get the minimum value node in the subtree
        # Default subtree: @root

        while current_node.has_right?
            current_node = current_node.right_child
        end
        current_node
    end

    def depth (value)
        # int -> int
        # Finds the depth of the desired node if it exists
        # depth is distance (edges) from root to the node
        # NOTE: root node is depth 0

        # Counter for desired node depth
        depth_counter = 0
        # Begin traversing at root node
        current_node = @root
        # Move down tree till nil or desired node reached
        # nil means desired node doesn't exist
        until current_node.nil? || value == current_node.data
            # if desired value is less than current node go to left child
            if value < current_node.data
                current_node = current_node.left_child
            # If desired value is greater than current node go to right child
            else
                current_node = current_node.right_child
            end
            # When moving down raise depth counter
            depth_counter += 1
        end
        # If nil reached, desired node does not exist, raise error
        raise InvalidNodeError.new("node with value #{value} does not exist") if current_node.nil?
        # else return depth counter
        depth_counter
    end

    def height (value)
        # int -> int
        # Finds the height of the desired node if it exists
        # height is distance (edges) from the node to its furthest descendant
        # NOTE: leaf node is height 1

        # Store desired node
        main_node = get_node(value)
        # If the desired node is nil (not found) raise InvalidNodeError
        raise InvalidNodeError.new("node with value #{value} does not exist") if main_node.nil?
        # Else return the height of the node using height_helper
        _height_helper(main_node)

    end

    # End: get methods

    def insert (value)
        # int -> nil
        # If tree is empty sets node with value as root,
        # otherwise insert node with value in a leaf position
        # while maintaining BST conditions

        # Check if child is nil in case root node is nil
        # This case only occurs on the root node
        unless @root.class == BinaryTreeNode
            # Set root as the desired node
            @root = BinaryTreeNode.new(value)
        else
            # Otherwise call insert helper function to insert node
            _insert_helper(value)
        end
    end

    def delete (delete_value, subtree_root=@root)
        # int -> nil
        # Removes the desires node if it exists
        # Restores BST to maintain BST properties.
        # Note: raises InvalidNodeError when node doesn't exist

        if subtree_root.data.nil?
            return subtree_root
        elsif delete_value < subtree_root.data
            subtree_root.left_child = delete(delete_value, subtree_root.left_child)
        elsif delete_value > subtree_root.data
            subtree_root.right_child = delete(delete_value, subtree_root.right_child)
        # delete_value == subtree_root.data
        # We found node to delete
        else

            # Case (1): Deleted node has no children
            return nil unless subtree_root.has_children?
            # Case (2): Deleted node has one child
            # Move up right child if no left child
            return subtree_root.right_child unless subtree_root.has_left?
            # Move up left child if no right child
            return subtree_root.left_child unless subtree_root.has_right?

            # Case (3): Deleted node has two children

            # Get the smallest node in the subtree with deleted node as root
            # This node will replace the deleted node
            # Rather than replacing the whole node we replace the data
            replace_node_value = get_min(subtree_root.right_child).data
            # Since we replaced data we still need to remove the old replacing
            # node, this has no kids so is easy for delete to handle
            delete(replace_node_value, subtree_root)
            # Since we deleted old replacing node we can replace value of
            # deleted node without duplicating values
            subtree_root.data = replace_node_value

        end
        subtree_root

    end

    def rebalance
        # nil -> nil
        # Makes the current binary tree into a balanced binary tree

        # Get the Inorder traversal to get a strictly ascending list
        # of all the tree values
        rebalance_array = inorder()
        # rebuild a balanced binary tree with this array and set as root
        # note build_tree creates a balanced binary tree
        # Note: rebalance array already sorted with no duplicates as required by build_tree
        @root = build_tree(rebalance_array, 0, (rebalance_array.length - 1))
    end

    # Start: traversal methods

    def level (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in inorder traversal of the BST
        # Returns an array representing a level order traversal if no block given
        
        # Check if no block is given
        unless block_given?
            # Set an array to hold inorder traversal
            result = []
            # create lamba to pass inorder_block to add each node data value to result
            tree_block = ->(current_node) {result.push(current_node.data)}
        end
        # Call block using inorder_block method
        _level_block(subtree_root, &tree_block)
        # If no block was given, return result array of traversal from default lambda
        return result unless block_given?
    end

    def inorder (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in inorder traversal of the BST
        # Returns an array representing an inorder traversal if no block given

        # Check if no block is given
        unless block_given?
            # Set an array to hold inorder traversal
            result = []
            # create lamba to pass inorder_block to add each node data value to result
            tree_block = ->(current_node) {result.push(current_node.data)}
        end
        # Call block using inorder_block method
        _inorder_block(subtree_root, &tree_block)
        # If no block was given, return result array of traversal from default lambda
        return result unless block_given?
    end

    def preorder (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in preorder traversal of the BST
        # Returns an array representing a preorder traversal if no block given
        
        # Check if no block is given
        unless block_given?
            # Set an array to hold preorder traversal
            result = []
            # create lamba to pass preorder to add each node data value to result
            tree_block = ->(current_node) {result.push(current_node.data)}
        end
        # Call block using preorder_block method
        _preorder_block(subtree_root, &tree_block)
        # If no block was given, return result array of traversal from default lambda
        return result unless block_given?
    end

    def postorder (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in postorder traversal of the BST
        # Returns an array representing a postorder traversal if no block given
        
        # Check if no block is given
        unless block_given?
            # Set an array to hold postorder traversal
            result = []
            # create lamba to pass postorder to add each node data value to result
            tree_block = ->(current_node) {result.push(current_node.data)}
        end
        # Call block using postorder_block method
        _postorder_block(subtree_root, &tree_block)
        # If no block was given, return result array of traversal from default lambda
        return result unless block_given?
    end

    # End: traversal methods

    # Start: ? methods

    def balanced?
        # nil -> balanced
        # Returns true if the BST is balanced else returns false

        _balanced_helper(@root)[0]
    end

    # End: ? methods

    #private

    # START: height helper methods

    def _height_helper (subtree_root)
        # BinaryTreeNode -> int
        # Takes a tree node and returns its height (edges from it to deepest descendant leaf)
        # NOTE: used in height method

        # If we are on a nil value (child of leaf nodes are nil) return height 0
        return 0 if subtree_root.nil?

        # Get height of left child
        left_height = _height_helper(subtree_root.left_child)
        # Get height of right child
        right_height = _height_helper(subtree_root.right_child)

        # The height of the current node is the max of height of children and add one for the
        # current node
        return (1 + _max(left_height, right_height))

    end

    # END: height helper methods

    # START: insert helper methods

    def _insert_helper (value, current_node=@root)
        # int, BinaryTreeNode -> nil
        # Inserts a new node with the value at a leaf position
        # if the value isn't already present in the tree.

        # We ignore the case when value == current_node.data
        # (we end the process since we do not want duplicates)

        # Bool for wheter value was added to tree (default true)
        # We make this value false when value failed to be added
        # because it already exists in the tree
        value_added = true

        # If value is less than current node data check left child
        if value < current_node.data
            # If there is no left child then we create a new node with the value
            # as the left child
            if current_node.left_child.nil?
                current_node.left_child = BinaryTreeNode.new(value)
            # If there is a left child then we recursively call on that child
            else
                value_added =_insert_helper(value, current_node.left_child)
            end
        # If value is greater than current node data move to right child
        elsif value > current_node.data
            # If there is no left child then we create a new node with the value
            # as the left child
            if current_node.right_child.nil?
                current_node.right_child = BinaryTreeNode.new(value)
            # If there is a right child then we recursively call on that child
            else
                value_added = _insert_helper(value, current_node.right_child)
            end
        # If value == current_node data then we do not add value
        # and change value added bool to false
        else
            value_added = false
        end
        # notify user whether value was added
        value_added

    end

    # END: insert helper methods

    # START: traversal helper methods

    def _level_block (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in level traversal of the BST

        # Create array to act as queue, we push nodes in and shift them out
        tree_queue = [subtree_root]
        # Keep running through levels till we run out of nodes
        until tree_queue.empty?
            # Gets the next node in the queue
            current_node = tree_queue.shift
            # Adds children of current node to the queue (children are on the same level)
            # Notes:
            # - We start with root on level 0
            # - Children of root enter queu together and are on the same level
            # - We shift nodes on the same level and get their children which are all
            # one level down AND on the same level
            # - So we always go through a whole level and then move to the next if it exists
            tree_queue.push(current_node.left_child) unless current_node.left_child.nil?
            tree_queue.push(current_node.right_child) unless current_node.right_child.nil?
            # call block on the current node
            tree_block.call(current_node)
        end
    end
        

    def _inorder_block (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in inorder traversal of the BST

        # While we haven't hit the end of a tree branch keep traversing through
        # the tree
        unless subtree_root.nil?
            # Recursively apply block to left subtree
            _inorder_block(subtree_root.left_child, &tree_block)
            # Call block on current node
            tree_block.call(subtree_root)
            # Recursively apply block to right subtree
            _inorder_block(subtree_root.right_child, &tree_block)
        end
    end

    def _preorder_block (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in preorder traversal of the BST
        
        unless subtree_root.nil?
            # Call block on current node
            tree_block.call(subtree_root)
            # Recursively apply block to left subtree
            _preorder_block(subtree_root.left_child, &tree_block)
            # Recursively apply block to right subtree
            _preorder_block(subtree_root.right_child, &tree_block)
        end
    end

    def _postorder_block (subtree_root=@root, &tree_block)
        # BinaryTreeNode -> Array
        # Runs block on tree nodes in postorder traversal of the BST
        
        unless subtree_root.nil?
            # Recursively apply block to left subtree
            _postorder_block(subtree_root.left_child, &tree_block)
            # Recursively apply block to right subtree
            _postorder_block(subtree_root.right_child, &tree_block)
            # Call block on current node
            tree_block.call(subtree_root)
        end
    end
    
    # END: traversal helper methods

    # START: balanced? helper methods

    def _balanced_helper (subtree_root)
        # BinaryTreeNode -> Array[bool, int]
        # Returns an array where first value shows if subtree is balanced and second value
        # shows height of subtree

        # If the subtree is empty
        # Return that subtree is balanced with height 0
        return [true, 0] if subtree_root.nil?

        # If subtree is not empty
        # Recursively call balanced_helper to get the balanced status array for left and right
        # child 
        left_status = _balanced_helper(subtree_root.left_child)
        right_status = _balanced_helper(subtree_root.right_child)
        # See if left and right subtrees are balanced
        # See if height of both subtrees differ by at most 1 (so current tree is balanced)
        balanced = left_status[0] && right_status[0] &&
            ((left_status[1] - right_status[1]).abs <= 1)
        return [balanced, 1+_max(left_status[1], right_status[1])]

    end

    def _max (*values)
        # var_args(int) -> int
        # Returns the maximum value amongst the integer arguments given

        values.max
    end

    # END: balanced? helper methods


end
