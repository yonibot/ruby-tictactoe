# Tic Tac Toe game

require 'yaml'
require 'pry'

class Board
	attr_accessor :values

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
		col,row = coordinates
		@values[row][col] == 0 && (row < 3 && col < 3)
	end

	def win_criteria
		# 1. All of ONE triplet are the same player
		# 2. All of a single index in all 3 triplets are the same player
		# 3. adjacent indeces in adjacent triplets are the same plaer (diagonal)
		{ 
			1 => @values.any?{|triple| triple.all?{|x| x == triple.first && x != 0}},
			2 => [0,1,2].any?{|index| @values.all?{|triple| triple[index] == @values[0][index] && triple[index] != 0}},
			3 => [@values, @values.reverse].any?{|values| values[0][0] == values[1][1] && values[1][1] == values[2][2] && values[2][2] != 0}
		}
	end

	def won?
		puts "checking win"
		puts "values are: #{@values}"
		return false if @values.flatten.all?{|x| x.equal?(0)}
		win_criteria.values.any?
	end

	def draw?
		# Can be added:
		# Win is no longer possible
		# IE win criteria cannot be met
		# All of the below must be met:
		# 1. At least 1 X and 1 Y in any triplet
		# 2. At least 1 X and 1 Y in any single index of all triplets
		# 3. opposite of diagonal
		# 4. All tiles filled in
		@values.all?{|triple| triple.all?{|val| val != 0}}
	end

	def completed?
		won? || draw?
	end

	def select_tile(player, coordinates)
		col,row = coordinates
		@values[row][col] = player
	end

end


class TicTacToeGame

	def initialize
		@messages = YAML.load_file('messages.yml')
		@game_board = Board.new
		@current_player = true
	end

	def current_player_name
		@current_player ? 'Y' : 'X'
	end

	def move
		# select tile for player (space must be free)
		# Check if board is won or draw
		@current_player = !@current_player
		puts @messages["q_move"] + " (#{current_player_name}'s move)"
		coordinates = gets.chomp.split(',').map!(&:to_i)
		if @game_board.can_select?(coordinates)
			@game_board.select_tile(current_player_name, coordinates)
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
		move while !@game_board.completed?
		puts @game_board.won? ? @messages["winner"].gsub(/\*/, current_player_name) : @messages["draw"]
	end

end

game = TicTacToeGame.new
game.start



