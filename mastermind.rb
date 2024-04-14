class CodeGenerator
  COLORS = %w[red green blue yellow orange purple].freeze
  CODE_LENGTH = 4

  def self.generate_secret_code
    Array.new(CODE_LENGTH) { COLORS.sample }
  end
end

class Game

  def initialize

  end

end

class Player
  def initialize
    
  end
end

