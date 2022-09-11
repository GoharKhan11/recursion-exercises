require "./lib/tree_array_sort.rb"
require "./lib/tree_node.rb"

class BinarySearchTree
    # Note: BST = Binary SearchTree

    include TreeSort

    def initialize (tree_array=[])
        # Array -> BinaryTree
        # Initializes an array as a balanced BST

        # If the tree array is empty set root as nil
        if tree_array == []
            @root = nil
        # If tree array is not empty we make a BST
        else
            # sort tree array and remove duplicates
            # Note: uses TreeSort module
            tree_array = tree_array.tree_merge_sort
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
            tree_root.left_child = build_tree(tree_array, middle_index+1, end_index)
            return tree_root
        end

    end

end
