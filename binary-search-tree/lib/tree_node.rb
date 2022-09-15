class BinaryTreeNode

    include Comparable

    def initialize(data=0, left_child=nil, right_child=nil)
        # any, TreeNode, TreeNode -> TreeNode
        @data = data
        @left_child = left_child
        @right_child = right_child
    end

    attr_accessor :data
    attr_accessor :left_child
    attr_accessor :right_child

    def <=>(other_tree_node)
        # TreeNode -> bool
        # Compares the data in the TreeNodes using
        # the comparable module
        @data <=> other_tree_node.data
    end

    def has_left?
        # BinaryTreeNode -> bool
        # returns true if the node has a left child
        # else returns false

        # Return false if left child empty (nil)
        if self.left_child.nil?
            return false
        # else return true
        else
            return true
        end
    end

    def has_right?
        # BinaryTreeNode -> bool
        # returns true if the node has a right child
        # else returns false

        # Return false if right child empty (nil)
        if self.right_child.nil?
            return false
        # else return true
        else
            return true
        end
    end

    def has_children?
        # BinaryTreeNode -> bool
        # returns true if the node has any children
        # else returns false

        # If both children are nil, return false (no children)
        if self.left_child.nil? && self.right_child.nil?
            return false
        # else return true
        else
            return true
        end

    end

end