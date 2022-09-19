class ReverseTreeNode
    # A tree where the children point to the parent rather than the parent pointing to the
    # children

    def initialize (data=nil, parent=nil)
        @data = data
        @parent = parent
    end

    attr_accessor :data
    attr_accessor :parent

    def trace_ancestory
        # nil -> array
        # Returns a list of elements in order from the current node till the "root" of the tree

        result = [@data]
        current_node = @parent
        until current_node.nil?
            result.push(current_node.data)
            current_node = current_node.parent
        end
        result
    end

end

