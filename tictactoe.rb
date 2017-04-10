# Tic Tac Toe game

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
		# 3. adjacent indeces in adjacent triplets are the same plaer (diagonal)
		winning_criteria = {
			1: @values.any?{|triple| triple.all?{|x| x == triple.first}},
			2: [0,1,2].any?{|index| @values.all?{|triple| triple[index] == triple.first}},
			3: [@values, @values.reverse].all?{|values| values[0] == values[1] == values[2]}
		winning_criteria.values.any?
	end

	def draw?
		
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



