require_relative "tile"

class Board
    attr_reader :grid

    def initialize
        @grid = Array.new(9) do
            Array.new(9) do
                Tile.new
            end
        end
    end

    def addBombs(num)
        generated_nums = generateRandomPositions(num)
    
        generated_nums.each do |pos|
            row = pos[0]
            col = pos[1]
            grid[row][col].bomb = true; 
        end
    end

    def generateRandomPositions(num)
        arr = []
        until arr.length == (num + 1)
            random_row = rand(num)
            random_col = rand(num)
            position = [ random_row, random_col ]
            arr << position if !arr.include?(position)
        end
        arr
    end 

    def render
        grid.each do |row|
            row.each do |col|
                if col.bomb == false
                    print "* ";
                else
                    print "B "
                end
            end
            puts
        end
    end
end

boop = Board.new
boop.addBombs(9)
boop.render