require_relative "board"
require_relative "utility_classes"

class Game 
    def initialize
        @board = Board.new
        @board.addBombs( @board.grid.length )
    end

    def getPosition
        print "Enter a position on the board ( row,column e.g. '1,2') then followed by a ' -f' if you wish to flag the position (e.g. '1,2 -f'): "
        gets.chomp
    end

    def validPosition?(pos_str)

        begin
            pos_arr = parsePosition(pos_str)
        rescue
            puts "\nInvalid input."
            return false
        end

        if  pos_arr[0] > 8 || pos_arr[0] < 0 || pos_arr[1] > 8 || pos_arr[1] < 0
            puts "\nInvalid position values; use values between 0 and 8 only."
            return false
        end

        if @board.alreadyRevealed?(pos_arr[0], pos_arr[1])
            if pos_arr.length == 3
                puts "\nThis position has already been revealed; you cannot flag this position."
            else 
                puts "\nThis position has already been revealed."
            end

            return false
        end

        if @board.isFlagged?(pos_arr[0], pos_arr[1])
            print "\nThis position is currently flagged, do you wish to unflag this position? (y/n): "
            user_answer = gets.chomp

            return true if user_answer.downcase == 'y' || user_answer.downcase == "yes"

            return false
        end

        true
    end

    def parsePosition(pos_str)
        final_positions = []

        two_halves = pos_str.split(',')

        raise "Invalid Input Format" if two_halves.length != 2

        if two_halves[0].is_int?
            final_positions << two_halves[0].to_i; 
        else
            raise "Invalid format; please enter a valid number"
        end

        if two_halves[1].length > 1
            find_flag = two_halves[1].split

            if find_flag.length == 2 && find_flag[1] == "-f"
                final_positions << find_flag[0].to_i << find_flag[1]
            else
                raise "Invalid Input Format"
            end
        else
            if two_halves[1].is_int?
                final_positions << two_halves[1].to_i
            else
                raise "Invalid format; please enter a valid number"
            end
        end 

        final_positions
    end

    def solved?
        @board.grid.each do |row|
            row.each do |col|
                return false if !col.revealed && !col.bomb
            end
        end

        @board.render(true)

        puts "Great job, you beat the game!"

        true
    end

    def boardBombed?
        if @board.bombed
            @board.render(true)
            return true
        end
        
        false
    end

    def play
        until solved? || boardBombed?
            @board.render
            user_selection = getPosition
            @board.reveal( parsePosition(user_selection) ) if validPosition?(user_selection)   
        end
    end

end

minesweep = Game.new
minesweep.play
