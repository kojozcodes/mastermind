class CodeGenerator
  COLORS = %w[red green blue yellow orange purple].freeze
  CODE_LENGTH = 4

  def self.generate_secret_code
    Array.new(CODE_LENGTH) { COLORS.sample }
  end
end

class Game
  MAX_TURNS = 12

  def initialize
    @turns_left = MAX_TURNS
    @player = choose_player_role
    @secret_code = @player.create_secret_code
  end

  def play
    puts "Welcome to Mastermind!"
    puts "Try to guess the secret code, consisting of #{CodeGenerator::CODE_LENGTH} colors."
    puts "Valid colors are: #{CodeGenerator::COLORS.join(', ')}"
    puts "You have #{MAX_TURNS} turns. Let's begin!\n\n"

    @turns_left.times do |turn|
      puts "Turn #{turn + 1}:"
      guess = @player.make_guess

      if guess == @secret_code
        puts "Congratulations! You guessed the secret code: #{@secret_code.join(' ')}"
        return
      else
        feedback = provide_feedback(guess)
        puts "Feedback: #{feedback}\n\n"
      end
    end

    puts "Sorry, you've run out of turns. The secret code was: #{@secret_code.join(' ')}"
  end

  private

  def choose_player_role
    loop do
      print "Do you want to create the secret code or guess it? (creator/guesser): "
      choice = gets.chomp.downcase
      return Player.new(:creator) if choice == 'creator'
      return Player.new(:guesser) if choice == 'guesser'

      puts "Invalid choice. Please enter 'creator' or 'guesser'."
    end
  end

  def provide_feedback(guess)
    exact_matches = @secret_code.zip(guess).count { |secret_color, guess_color| secret_color == guess_color }
    color_matches = @secret_code.uniq.sum { |color| [guess.count(color), @secret_code.count(color)].min }
    wrong_position = color_matches - exact_matches
    "#{exact_matches} exact matches, #{wrong_position} correct color in wrong position"
  end
end

class Player
  attr_reader :role

  def initialize(role)
    @role = role
  end

  def create_secret_code
    if @role == :creator
      loop do
        print "Enter the secret code (e.g., red green blue yellow): "
        code = gets.chomp.downcase.split
        return code if valid_code?(code)

        puts "Invalid code. Please enter #{CodeGenerator::CODE_LENGTH} valid colors."
      end
    else
      CodeGenerator.generate_secret_code
    end
  end

  def make_guess
    loop do
      print "Enter your guess (e.g., red green blue yellow): "
      guess = gets.chomp.downcase.split
      return guess if valid_guess?(guess)

      puts "Invalid guess. Please enter #{CodeGenerator::CODE_LENGTH} valid colors."
    end
  end

  private

  def valid_guess?(guess)
    guess.length == CodeGenerator::CODE_LENGTH && guess.all? { |color| CodeGenerator::COLORS.include?(color) }
  end

  def valid_code?(code)
    code.length == CodeGenerator::CODE_LENGTH && code.all? { |color| CodeGenerator::COLORS.include?(color) }
  end
end

