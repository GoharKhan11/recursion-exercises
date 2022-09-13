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
            @root = build_tree(tree_array, 0, tree_array.length)
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
        pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
        # Adds end of branch and data of current node
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        # recursively calls on right subtree
        pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
    end

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

    def delete (value)
        # int -> nil
        # Removes the desires node if it exists
        # Restores BST to maintain BST properties.
        # Note: raises InvalidNodeError when node doesn't exist

        node_to_delete = get_node_by_value(value)
        if node_to_delete.nil?

    end

    def get_node_by_value (value)
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

    private

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

end

main_tree = BinarySearchTree.new([4,4,7,14,25,1,6,1,20,25,22])
puts "get value 14 (exists):"
p main_tree.get_node_by_value(22).data