class Board
  def initialize
    self._new_board
  end

  def _new_board
    @row1 = (1..3).to_a
    @row2 = (4..6).to_a
    @row3 = (7..9).to_a
  end

  def show_board
    puts @row1.join("|")
    puts @row2.join("|")
    puts @row3.join("|")
  end

  def resetBoard
    self._new_board
  end

  # Takes a the Player's piece and the position and returns the piece if successfully placed
  def mark_board(piece, position)
      case position
      when (1..3)
        index = @row1.index(position)
        if index
          @row1[index] = piece
        else
          return false
        end
      when (4..6)
        index = @row2.index(position)
        if index
          @row2[index] = piece
        else
          return false
        end
      when (7..9)
        index = @row3.index(position)
        if index
          @row3[index] = piece
        else
          return false
        end
      else
        return false
      end
  end

  # Returns true if the elements in the array match each other
  def match?(array)
    first = array[0]
    if array.all? {|x| x == first}
      return true
    else
      return false
    end
  end

  # Returns the true if a player has won otherwise returns false
  def win?
    value = false
    conditions = []
    conditions.push([@row1[0], @row2[1], @row3[2]])
    conditions.push([@row1[2], @row2[1], @row3[1]])
    conditions.push([@row1[0], @row2[0], @row3[0]])
    conditions.push([@row1[1], @row2[1], @row3[1]])
    conditions.push([@row1[2], @row2[2], @row3[2]])
    conditions.push([@row1[0], @row1[1], @row1[2]])
    conditions.push([@row2[0], @row2[1], @row2[2]])
    conditions.push([@row3[0], @row3[1], @row3[2]])

    conditions.each do |condition|
      if self.match?(condition)
        value = true
        return value
      end
    end
    return value
  end

  # Returns true if the game is a draw and false otherwise
  def draw?
    draw = false
    if @row1.any? {|x| x.is_a?(Integer)}
      return draw
    elsif @row2.any? {|x| x.is_a?(Integer)}
      return draw
    elsif @row3.any? {|x| x.is_a?(Integer)}
      return draw
    else
      draw = true
      return draw
    end
  end

  def game_over?
    if self.win?
      return "win"
    elsif self.draw?
      return "draw"
    else
      return false
    end
  end

end

class Player
  attr_accessor :name
  attr_accessor :piece
  def initialize(piece, name)
    @piece = piece
    @name = name
  end
end

class Game
  # attr_accessor :current_player
  def initialize
    @player1 = Player.new("X", "Player 1")
    @player2 = Player.new("O", "Player 2")
    @current_player = @player1
    @board = Board.new
  end

  def set_piece(playerPiece, position)
    if @board.mark_board(playerPiece, position)
      return true
    else
      return false
    end
  end

  def change_turn
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def gameplay
    puts "Lets play"
    until @board.game_over? do
      piece = @current_player.piece
      @board.show_board
      puts "#{@current_player.name} it is your turn."
      puts "Make a selection"
      value = gets.chomp.to_i
      marked = @board.mark_board(piece, value)
      until marked do
        puts "Invalid choice #{@current_player.name}, please pick a number on the board"
        @board.show_board
        value = gets.chomp.to_i
        marked = @board.mark_board(piece, value)
      end
      puts "Your selection has been made"
      self.change_turn
    end
    if @board.game_over? == "draw"
      puts "Sorry you both lost."
      self.reset
      # Ask to begin again
    else
      self.change_turn
      puts "Congrats #{@current_player.name}, you won."
      self.reset
      # Ask to begin again
    end
  end

  def reset
    correct_answers = ["y", "Y", "n", "N"]
    puts "Do you want to play again?"
    puts "Enter y/n"
    ans = gets.chomp.strip
    until correct_answers.include?(ans)
      puts "Invalid response"
      ans = gets.chomp.strip
    end
    if (ans == "y" || ans == "Y")
      @board.resetBoard
      self.gameplay
      @current_player = @player1
    elsif (ans == "n" || ans == "N")
      puts "Thanks for playing."
    else
      puts "Something went wrong"
    end
  end

end

a = Game.new
# a.gameplay
a.reset

# a = Board.new
# puts a.mark_board("X", 4)
# puts a.mark_board("X", 5)
# puts a.mark_board("X", 6)
# a.show_board
# p a.game_over?
