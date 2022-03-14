require_relative "tile"

class Board
    attr_reader :grid, :bombed

    def initialize
        @grid = Array.new(9) do
            Array.new(9) do
                Tile.new
            end
        end

        @bombed = false
    end

    def addBombs(num)
        @generated_nums = generateRandomPositions(num)
    
        @generated_nums.each do |pos|
            row = pos[0]
            col = pos[1]
            @grid[row][col].bomb = true; 
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

    def alreadyRevealed?(row, col)
        @grid[row][col].revealed
    end

    def isFlagged?(row, col)
        @grid[row][col].flagged
    end

    def isBomb?(row, col)
        @grid[row][col].bomb
    end

    def reveal(pos)
        row = pos[0]
        col = pos[1]

        if isFlagged?(row, col) || pos.length == 3
            @grid[row][col].toggleFlag
        else
            if @generated_nums.include?([row, col])
                @bombed = true
                puts "\nYou've hit a bomb, game over!"
            else
                revealAdjPositions(pos)
            end
        end
    end

    def revealAdjPositions(pos)     #top, top right, right, bottom right, bottom, bottom left, left, top left
        @grid[pos[0]][pos[1]].revealed = true
        bomb_num = bombAdjCount(pos)

        return @grid[pos[0]][pos[1]].bomb_count = bomb_num if bomb_num != 0

        possible_moves = findPossibleMoves(pos)
        possible_moves.each do |pos|
            revealAdjPositions(pos)
        end
    end 

    def findPossibleMoves(pos)
        row_num = pos[0]
        col_num = pos[1]

        moves = []

        if row_num - 1 >= 0 #top
            moves << [row_num - 1, col_num] if !@grid[row_num - 1][col_num].revealed && !@grid[row_num - 1][col_num].flagged
            moves << [row_num - 1, col_num + 1] if col_num + 1 < @grid.size && !@grid[row_num - 1][col_num + 1].revealed && !@grid[row_num - 1][col_num + 1].flagged #top right
            moves << [row_num - 1, col_num - 1] if col_num - 1 >= 0 && !@grid[row_num - 1][col_num - 1].revealed && !@grid[row_num - 1][col_num - 1].flagged #top left
        end 

        moves << [row_num, col_num + 1] if col_num + 1 < @grid.size && !@grid[row_num][col_num + 1].revealed && !@grid[row_num][col_num + 1].flagged #right
        

        if row_num + 1 < @grid.size  #bottom
            moves << [row_num + 1, col_num] if !@grid[row_num + 1][col_num].revealed && !@grid[row_num + 1][col_num].flagged
            moves << [row_num + 1, col_num + 1] if col_num + 1 < @grid.size && !@grid[row_num + 1][col_num + 1].revealed && !@grid[row_num + 1][col_num + 1].flagged #bottom right
            moves << [row_num + 1, col_num - 1] if col_num - 1 >= 0 && !@grid[row_num + 1][col_num - 1].revealed && !@grid[row_num + 1][col_num - 1].flagged #bottom left
        end

        moves << [row_num, col_num - 1] if col_num - 1 >= 0 && !@grid[row_num][col_num - 1].revealed && !@grid[row_num][col_num - 1].flagged #left

        moves
    end 
    
    def bombAdjCount(pos)
        bomb_count = 0
        
        possible_moves = findPossibleMoves(pos) 

        possible_moves.each do |pos|
            row_num = pos[0]
            col_num = pos[1]

            bomb_count += 1 if @grid[row_num][col_num].bomb
        end

        bomb_count
    end

    def render(finished = false)
        puts "\n    #{(0...@grid.size).to_a.join(" ")}"
        puts "   ------------------"
        @grid.each_with_index do |row, row_num|
            print "#{row_num} | "
            row.each do |col|
                if finished && col.bomb
                    print "B "
                elsif col.flagged
                    print "F "
                elsif col.revealed && col.bomb
                    print "B "
                elsif col.bomb_count != 0
                    print "#{col.bomb_count} "
                elsif col.revealed == false
                    print "* "
                else
                    print "  "
                end
            end
            puts
        end
        puts
    end


end
