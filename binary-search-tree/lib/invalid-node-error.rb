class InvalidNodeError < StandardError

    def initialize (msg = "The node choice is invalid")
        super
    end

end