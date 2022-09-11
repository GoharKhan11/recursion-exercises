require "./lib/tree_array_sort.rb"
require "./lib/tree_node.rb"

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

end

main_tree = BinarySearchTree.new([1,6,2,5,3,4,2,4,3,5,1,6])
puts "show tree:"
main_tree.pretty_print