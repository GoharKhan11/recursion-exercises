class InvalidEntryError < StandardError

    def initialize(msg="The value entered is not valid.")
        super
    end

end

def fibonnaci_sequence (sequence_length)
    # int -> array

    if sequence_length < 0
        raise InvalidEntryError
    else
        return fib_rec(sequence_length)
    end

end

def fib_rec (sequence_length)
    # int, array -> array
    # Gives an array containing the fibonacci sequence
    # till the desired length

    if sequence_length == 0
        return [0]
    elsif sequence_length == 1
        return [0, 1]
    else
        result = fib_rec(sequence_length-1)
        return result.push(result[-1] + result[-2])
    end

end
