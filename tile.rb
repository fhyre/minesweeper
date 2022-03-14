class Tile 
    attr_accessor :bomb, :revealed, :bomb_count, :flagged

    def initialize
        @bomb = false
        @revealed = false
        @bomb_count = 0
        @flagged = false
    end

    def toggleFlag
        if @flagged 
            @flagged = false
        else 
            @flagged = true
        end
    end

end 