class TreeNode

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

end