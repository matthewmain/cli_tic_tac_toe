
###############################################################################
##                                                                           ##
##                           TERMINAL TIC-TAC-TOE                            ##
##                               (Version 3.0)                               ##
##                                                                           ##
##                               Matthew  Main                               ##
##                                                                           ##
###############################################################################


class Game

	def initialize
		@user_mark = "⨉"; @computer_mark = "◯"
		@wins_index = [[0,1,2],[3,4,5],[6,7,8],  	#horizontal wins
							 		 [0,3,6],[1,4,7],[2,5,8],		#vertical wins
							 		 [0,4,8],[2,4,6]]  					#diagonal wins	
		generate_cell_data(3,3)							 		 	
		display_board		
		intro
		user_turn
	end



	#### CELL DATA GENERATOR ####
	# This method populates an empty game board (of any dimensions) with cell 
	# data. It creates a two-dimensional array that stores each cell's  
	# coordinates (e.g., "a1" or "c3"), and that cell's status as empty or 
	# marked (with an x/o). Because this method has been called for a 3x3 grid 
	# in "intitialize", the resulting array is:
	# 
	# 	@cells_arr = [@a1,@a2,@a3,@b1,@b2,@b3,@c1,@c2,@c3]
	# 	=>
	#   [["a1", " "], ["a2", " "], ["a3", " "], 
	#  	 ["b1", " "], ["b2", " "], ["b3", " "],
	# 	 ["c1", " "], ["c2", " "], ["c3", " "]]

	def generate_cell_data(grid_width, grid_height)
	@cells_arr = []
		letter = "a"
    grid_width.times do 		
      number = 1 		
      grid_height.times do 	
        @cells_arr.push(instance_variable_set("@" + letter + number.to_s, [
            letter + number.to_s," "]))
        number = number.next
      end
      letter = letter.next
    end		
	end



	#### INTRO SEQUENCE ####			
	def intro

		#clears Terminal screen up to maximum (fullscreen) dimensions 
		puts "\n" * 55 	
		
		puts "W E L C O M E\n".center(80)
		puts "T O\n".center(80)		
		puts "T I C  -  T A C  -  T O E\n".center(80)		
		puts "\n" * 9
		sleep 2

		#animates the title
		for i in 9..19 do
			puts "\n" * 55; puts "T I C  -  T A C  -  T O E\n".center(80)		
			puts "\n" * i; sleep 0.075
		end

		sleep 0.33; display_board("To make a move, just type a letter and number,"+
			" like \"a3\" or \"b1\". Got it? Good.", "HIT ENTER TO START")
		gets
		display_board; sleep 0.3

	end



	#### DISPLAY BOARD & MESSAGES ####
	# This method creates a centered, fixed game-play interface based on
	# Terminal's default dimensions of 80x24. Because the ASCII shapes, text, and 
	# blank spaces are set on a total of 24 specified lines, each time
	# the method is called, the interface appears to remain fixed on the screen.

	def display_board(message1=' ', message2 = ' ')
	  puts "\n" * 34; puts "T I C  -  T A C  -  T O E".center(80); puts "\n" * 3
	  puts "    a   b   c    ".center(80)
	  puts "  ╔═══╦═══╦═══╗  ".center(80)
	  puts "1 ║ #{@a1[1]} ║ #{@b1[1]} ║ #{@c1[1]} ║  ".center(80)
	  puts "  ╠═══╬═══╬═══╣  ".center(80)
	  puts "2 ║ #{@a2[1]} ║ #{@b2[1]} ║ #{@c2[1]} ║  ".center(80)
	  puts "  ╠═══╬═══╬═══╣  ".center(80)
	  puts "3 ║ #{@a3[1]} ║ #{@b3[1]} ║ #{@c3[1]} ║  ".center(80)
	  puts "  ╚═══╩═══╩═══╝  ".center(80)
	  puts "\n" * 3; puts "#{message1}".center(80)
	  puts "\n" * 2; puts "#{message2}".center(80); puts "\n" * 2
	  print "".rjust(38)
	end



	#### USER'S TURN SEQUENCE ####
	def user_turn
	  def get_user_entry
	  	@move = gets.chomp.downcase

	  	#creates a variable called "move_index", which represents the move's 
	  	#corresponding index number in "cell_arr", from 0 to 8.
			index = 0
			for cell in @cells_arr
				move_index = index if @move == cell[0]
				index += 1
			end

			#checks that the entry is a valid letter-number coordinate
			if @cells_arr.all? {|all_cells| all_cells[0] != @move}
		    display_board; sleep 0.5;
		    display_board("So, yeah . . . \"#{@move}\" isn't a valid"+
		    	" entry.", "It's letter first, then number. Like"+
		    	"\"b2\". Maybe try again?")
		    get_user_entry

		  #checks that the entry is a move that hasn't already been played  
			elsif @cells_arr[move_index][1] != " "
	      display_board; sleep 0.5;
	      display_board("That move has already been made!","Try something "+
	      	"other than \"#{@move}\".")
	      get_user_entry

	    #places the user's mark on the board  
			else
	  		place_mark(@user_mark, move_index)
			end

	  end

	  display_board("What's your move?")
	  get_user_entry
	  check_endgame
	  display_board; sleep 0.33; display_board("Nice move."); sleep 1
	  computer_turn

	end



	#### COMPUTER'S TURN SEQUENCE ####
	def computer_turn
		def get_computer_entry
			@made_move = false

			def check_for_twos(o_or_x)
				#iterates through each win line
				@wins_index.each do |i|
					#logs line data: [['x/o/e', 'x/o/e', 'x/o/e'], x-count, o-count]
					line = [[],0,0]
					i.each do |j|
						if @cells_arr[j][1] == "⨉"
							line[0] << 'x'	
							line[1] += 1
						elsif @cells_arr[j][1] == "◯"
							line[0] << 'o'
							line[2] += 1
						else
							line[0] << 'e'  #'e' for empty
						end
					end
					#searches for a line with two o's and an empty cell
					if o_or_x == 'o'
						#if finds one, plays for the win
						if line[1] == 0 && line[2] == 2
							move_index = i[line[0].index('e')]	
							place_mark(@computer_mark, move_index)
							@made_move = true	
							break					
						end	
					#searches for a line with two x's and an empty cell
					else
						#if finds one, plays to block user's win
						if line[2] == 0 && line[1] == 2			
							move_index = i[line[0].index('e')]
							place_mark(@computer_mark, move_index)
							@made_move = true	
							break											
						end		
					end	
				end
			end		

			check_for_twos('o')
			check_for_twos('x') if @made_move == false

			#if computer hasn't yet moved, marks a random empty cell
			if @made_move == false
				move_index = rand 0..8
				if @cells_arr[move_index][1] != " "
					get_computer_entry
				else
					place_mark(@computer_mark, move_index)
					@made_move = true
				end
			end 

		end

		display_board; sleep 0.33;
	  display_board(" Computer's turn.  "); sleep 0.5
	  display_board(" Computer's turn.. "); sleep 0.5
	  display_board(" Computer's turn..."); sleep 0.75
		get_computer_entry
	  display_board; sleep 0.5
	  check_endgame
	  user_turn

	end



	#### PLACE MARK ON BOARD ####
	def place_mark(whose_mark, cell_arr_index)

		#makes the new mark blink after entry
		def position_mark(whose_mark, cell_arr_index)
			@cells_arr[cell_arr_index][1] = whose_mark
		end
		2.times do	
			position_mark(whose_mark,cell_arr_index); display_board; sleep 0.33
			position_mark(" ",cell_arr_index); display_board; sleep 0.25
		end

		#fixes the new mark on the board
		position_mark(whose_mark, cell_arr_index); display_board; sleep 0.33

	end



	#### CHECK FOR WIN, LOSS, OR DRAW ####
	def check_endgame

		#makes winning line flash
		def win_flash(i, x_or_o, message)
  		10.times do	
  			display_board(message)
	  		@cells_arr[i[0]][1] = " "
	  		@cells_arr[i[1]][1] = " "
	  		@cells_arr[i[2]][1] = " "
	  		display_board(message);sleep 0.1
	  		@cells_arr[i[0]][1] = x_or_o
	  		@cells_arr[i[1]][1] = x_or_o
	  		@cells_arr[i[2]][1] = x_or_o
	  		display_board(message);sleep 0.1
	  	end
		end 					

	  @wins_index.each do |i|

	  	#checks for win
			if @cells_arr[i[0]][1] == "⨉" && 
	  		 @cells_arr[i[1]][1] == "⨉" && 
	  		 @cells_arr[i[2]][1] == "⨉"
	  		win_message = "You won! Congratulations!"
	  		win_flash(i, "⨉", win_message)	
	  		play_again?(win_message)

	  	# checks for loss	
			elsif @cells_arr[i[0]][1] == "◯" && 
	  				@cells_arr[i[1]][1] == "◯" && 
	  				@cells_arr[i[2]][1] == "◯"	 
	  		lose_message = "Oh no! You lost..."
	  		win_flash(i, "◯", lose_message)	
	  		play_again?(lose_message)	 

			#checks for draw
			elsif @cells_arr.all? {|cell| cell[1] != ' '} 
				draw_message = "...Well, looks like it's a draw."
		  	display_board; sleep 0.5
		  	display_board(draw_message); sleep 1
		  	play_again?(draw_message)
			end

		end

	end



	#### END SEQUENCE ####
	def play_again?(message1)
		display_board(message1, "Wanna play again?")
		answer = gets.downcase
		if answer =~ /no|na|neg|n't|sor/ && !(answer =~ /why not/)
			display_board; sleep 0.33
			display_board("Okay. Thanks for playing! Bye!"); sleep 2
			exit
		elsif answer =~ /ye|yup|sure|ok|hu|aff|right|gue|sup|go|do|would|I'd|ly|
			  why not|\n/
			display_board; sleep 0.33
			display_board("Great!"); sleep 1
			Game.new
		else
			display_board; sleep 0.33;
			play_again?("Sorry, didn't quite get that. Answer \"yes\" or \"no\".")
		end
	end  

end


Game.new




###########################   MAKE A TIC-TAC-TOE GAME   #########################


#*************** Version 1 *****************#

#[X] -Create board: a 3x3 grid with a coordinate var for each cell 
#[x]  -create a cell generator so future version can automatically populate
#         grids larger than 3x3.
#[x]	  -generate an arr of cell vars, each named with a letter-number coords 
#		        based on input dimensions
#[x]		-generate sub-arrs for 0) coords with string values & 1) empty/X/O 
#           status
#[x]  -create vars for X's and O's marks
#[x]  -create a putsable ASCII str grid for the board that includes cell vars
#[x]  -create a method that displays the board in its current state
#
#[X] -Create a wins array for all combinations of grid vars that result in win
#	
#[X] -Create a method for updating open cells and wins vars
#
#[X] -Create method for marking the board 
#
#[X] -Create a method for processing user's moves & displaying them
#[x]  -ask user for entry
#[x]	-create a number var assigned to move's coorsponding cell-arr index
#[x]    -check that entry is valid syntax; if not, ask again until valid
#[x]    -check that entry is an open cell; if not, ask again until open cell
#[x]  -use marking method to assign move to corresponding grid var
#[x]  -check for win or draw
#[x]  -display updated board	
#
#[X] -Create a method for processing computer's moves & displaying them
#[x]   -create a number var assigned to a random number from 0 to 8
#[x]     -check if cell value is an open cell; if not, re-run method
#[x]   -use marking method to assign move to corresponding grid var
#[x]   -check for win or draw
#[x]   -display updated board	
#
#[X] -Create a method to check for wins then draws after every turn
#[x]   -check for wins
#[x]     -check wins array for sequences of three X's or O's
#[x]     -if win found, announce result
#[x]				-announce win
#[x]				-announce loss
#[x]   -check for draws
#[x]     -check each element in the open cell arr for open cells
#[x]     -if no open cells, announce draw
#[x]   -offer option to play again or quit
#[x]     -if play again, re-start game
#[x]     -if quit, exit program
#
#[X] -Create game-flow sequence
#[x]   -welcome message
#[x]   -user's turn
#[x]     -unless win or draw, pass turn to computer
#[x]   -computer's turn
#[x]     -unless win or draw, pass turn to user



#*************** Version 2 *****************#

#[X] -Add a simple animated intro
#[x]   -create animated welcome to Tic-Tac-Toe message ->
#[x]   -basic instructions for using grid (-> enter gameplay)	
#
#[X] -Enhance game flow 
#[x]   -create display "screen" method that centers/fixes board and messages
#[x]     -include puts-newlines to make each refresh appear to be on a fixed
#            screen
#[x]     -include variables for 2 lines of messages beneath board
#[x]   -write messages for each step/response
#[x]   -add brief sleep delays between messages and turns
#
#[X] -Animate each move so new X/O blinks before becoming fixed
#[x]   -create method that toggles mark method from ' ' to X/O with 
#          sleep-delays
#[x]   -then pass control to mark method to log move
#
#[X] -Make wins flash


#*************** Version 3 *****************#

#[X] -Make computer think
#[x] 	-computer looks for lines of two x's to block
#[x]  -computer looks for lines of two o's to extend






#*********** (later versions) **************#

# -improve opening sequence
# -after animated intro, first ask whether X or O ->
# -instructions for entering coordinates ->
# -coin toss to see who goes first (-> enter game)




##### code-improvement possibities:

#...


##### more game-play possibilities:

#[ ] medium computer option? (*at least this: plays/blocks twos-in-a-row)

# +easy/medium/hard computer option?
# +two-player option? 
# +score tracker?


##### more aesthetics possibilities:

# +make larger board with 2x2 ASCII-shape X's & O's?
# +center for repl.it?
# +try to alter or respond to terminal dimensions?
# +put on web page 