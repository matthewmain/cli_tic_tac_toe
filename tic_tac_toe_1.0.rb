
#################################################################################
##                                                                             ##
##                           TERMINAL TIC-TAC-TOE                              ##
##                                (Version 1.0)                                ##
##                                                                             ##
##                                Matthew  Main                                ##
##                         Flatiron School Application                         ##
##                                                                             ##
#################################################################################


class Game

	def initialize
		@a1=' '; @b1=' '; @c1=' '
		@a2=' '; @b2=' '; @c2=' '
		@a3=' '; @b3=' '; @c3=' ' 
		@coord_array = ["a1","b1","c1","a2","b2","c2","a3","b3","c3"]
		@user_mark = "⨉"; @computer_mark = "◯"
		update_trackers
		display_board
		puts "\nWelcome to Tic Tac Toe!\n\n"
		user_turn
	end

	def display_board
	  puts
	  puts "    a   b   c  ".center(20)
	  puts "  ╔═══╦═══╦═══╗".center(20)
	  puts "1 ║ #{@a1} ║ #{@b1} ║ #{@c1} ║".center(20)
	  puts "  ╠═══╬═══╬═══╣".center(20)
	  puts "2 ║ #{@a2} ║ #{@b2} ║ #{@c2} ║".center(20)
	  puts "  ╠═══╬═══╬═══╣".center(20)
	  puts "3 ║ #{@a3} ║ #{@b3} ║ #{@c3} ║".center(20)
	  puts "  ╚═══╩═══╩═══╝".center(20)
	  puts
	end

	def update_trackers
		@open_cells = [@a1,@b1,@c1,@a2,@b2,@c2,@a3,@b3,@c3]
		@wins = [[@a1,@b1,@c1],[@a2,@b2,@c2],[@a3,@b3,@c3], 
	        	 [@a1,@a2,@a3],[@b1,@b2,@b3],[@c1,@c2,@c3],	
	   	    	 [@a1,@b2,@c3],[@a3,@b2,@c1]]		
	end

	def mark_board(move,mark)
    case move
      when "a1" then @a1 = mark
      when "b1" then @b1 = mark
      when "c1" then @c1 = mark
      when "a2" then @a2 = mark
      when "b2" then @b2 = mark
      when "c2" then @c2 = mark
      when "a3" then @a3 = mark
      when "b3" then @b3 = mark
      when "c3" then @c3 = mark
    end
    update_trackers
	end

	def user_turn
	  def get_user_entry
	  	move = gets.chomp
	  	move_index = @coord_array.index(move)
			if move_index == nil
		    puts "\nSo, um ...yeah. That isn't a valid entry. Maybe try again?\n\n"
		    get_user_entry
			elsif @open_cells[move_index] != ' '
	      puts "\nThat move has already been made! Try again.\n\n"
	      get_user_entry
	  	else
	  		mark_board(move,@user_mark)
			end
	  end	
	  puts "What's your move?"
	  get_user_entry
	  display_board
	  check_endgame
	  computer_turn
	end

	def computer_turn
		def get_computer_entry
			move_as_num = rand 0..8
			move_as_str = @coord_array[move_as_num]		
			move_attempt = @open_cells[move_as_num]
			if move_attempt != ' '
				get_computer_entry
			else
				mark_board(move_as_str,@computer_mark)
			end
		end
	  puts "Computer's turn..."	
		get_computer_entry
	  display_board
	  check_endgame
	  user_turn
	end

	def check_endgame
	  @wins.each do |i|  #checks for win
	  	if i == ["⨉","⨉","⨉"]
	  		display_board
	  		puts "\nYou won! Congratulations!\n\n"
	  		play_again?
	  	elsif i == ["◯","◯","◯"]
	  		display_board
	  		puts "\nOh no! You lost...\n\n"
	  		play_again?						
	  	end	
	  end
		if @open_cells.all? {|cell| cell != ' '}  #checks for draw
			display_board
	  	puts "\n...Well, looks like it's a draw. Yeah. Boring.\n\n"	
	  	play_again?	
		end
	end

	def play_again?
		puts "Wanna play again?\n\n"
		answer = gets.chomp.downcase
		if answer =~ /no|on|na|neg|n't|off|sor/
			puts "\nOkay. Thanks for playing! Bye!\n\n"  
			exit
		elsif answer =~ /ye|sure|ok|af|go|do\Z|do(?=!)|ld\Z|ld(?=!)|ly\Z|ly(?=!)/
			puts "\nGreat!"  
			Game.new
		else
			puts "\nSorry, didn't quite get that. Answer \"yes\" or \"no\".\n\n"
			play_again?
		end
	end  

end

Game.new








###########################   MAKE A TIC-TAC-TOE GAME   #########################


#*************** Version 1 *****************#

#[X] create board: a 3x3 grid with a coordinate var for each cell 
	#[X] create nine cell vars, each named with a cell coordinate
	#[X] create an arr of coordinates as string values for indexing numerically
	#[X] create vars for X's and O's marks
	#[X] create a putsable ASCII grid for the board that includes cell vars
	#[X] create a display_board method that displays board in its current state

#[X] create an arr of cell vars to store cell values and track open cells
#[X] create a wins array for all combinations of grid vars that result in a win	
#[X] creat a method for updating open cells and wins vars

#[X] create method for marking the board using case statement

#[X] create a user_turn method for processing moves & displaying them
	#[X] ask user for entry
		#[X] check that entry is valid syntax; if not, ask again until valid
		#[X] check that entry is an open cell; if not, ask again until open cell
	#[X] use marking method to assign move to corresponding grid var
	#[X] update arr of cell vars to keep track of open cells
	#[X] check for win or draw
	#[X] display updated board	

#[X] create a computer_turn method for processing moves & displaying them
	#[X] create an array of grid coordinates as strings
	#[X] create a number var assigned to a random number from 0 to 8
	#[X] create a string var to store coordinate corresponding to the random number
	#[X] create a string var to store cell value corresponging to the random number
		#[X] check if cell value is an open cell; if not, re-run method
	#[X] use marking method to assign move to corresponding grid var
	#[X] update arr of cell vars to keep track of open cells
	#[X] check for win or draw
	#[X] display updated board	

#[X] create a method to check for wins then draws after every turn
	#[X] check for wins
		#[X] check wins array for sequences of three X's or O's
		#[X] if win found, announce result
  #[X] check for draws
  	#[X] check each element in the open cell arr for open cells
  	#[X] if no open cells, announce draw
	#[X] offer option to play again or quit
		  #[X] if play again, mechanism to re-start game
  		#[X] if quit, mechanism to exit program

#[X] create game-flow sequence
	#[X] weclome message
	#[X] user's turn
		#[X] unless win or draw, pass turn to computer
	#[X] computer's turn
		#[X] unless win or draw, pass turn to user
	#[X] when win or draw, game over; ask to play again or quit

