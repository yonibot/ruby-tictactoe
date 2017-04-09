# Tic Tac Toe game

# 3 consecutive picks wins. How do you define consecutive?
# Cannot go on a space where other player is.
# Check the board after each player goes to see if there's a winner.

# players = ['joe', 'andy', 'sheena'];
# currentPlayer = 0;
# board = [[0,0,0], [0,0,0], [0,0,0]];
# Draw criteria:
# None of the win criteria are possible.
# (Could've simplified by supplying rules)

# Keep track of board and currentPlayerIndex.
# Keep looping over players

require 'yaml'
require 'pry'

class Board
	def initialize
		@values = [[0,0,0], [0,0,0], [0,0,0]]
	end

	def draw
		puts "     0   1   2"
		@values.each_with_index do |row, i|
			puts "#{i} -- #{row.join(' | ')}"
		end
	end

	def can_select?(coordinates)
		row,col = coordinates
		@values[row][col] == 0 && (row < 3 && col < 3)
	end

	def won?
		# Win criteria:
		# 1. All of ONE triplet are the same player
		# 2. All of a single index in all 3 triplets are the same player
		# 3. adjacent indeces in adjacent tuplets are the same plaer (diagonal)
		criteria = {
			1: @values.any?{|triple| triple.all?{|x| x == triple.first}},
			2: row_is_same = false
				indices = [0,1,2]
				indices.each do |index|
					row_is_same = @values.all?{|triple| triple[index]}
				end
		}
		criteria.values.any?
	end

	def completed?
		won? || draw?
	end

	def select_tile(player, coordinates)
		row,col = coordinates
		@values[row][col] = player
	end
end


class TicTacToeGame

	def initialize
		@messages = YAML.load_file('messages.yml')
		@game_board = Board.new
		@current_player = true
	end

	def player_name
		@current_player ? 'X' : 'Y'
	end

	def move
		# select tile for player (space must be free)
		# Check if board is won or draw
		puts @messages["q_move"] + " (#{player_name}'s move)"
		coordinates = gets.chomp.split(',').map!(&:to_i)
		if @game_board.can_select?(coordinates)
			@game_board.select_tile(player_name, coordinates)
			@current_player = !@current_player
		else
			puts "This move is invalid. Try again."
			move
		end
		@game_board.draw
	end

	def start
		@messages["header"].each{|h| puts h}
		puts
		@game_board.draw
		puts @messages["welcome"]
		until @game_board.completed?
			move
		end
	end

end

game = TicTacToeGame.new
game.start



