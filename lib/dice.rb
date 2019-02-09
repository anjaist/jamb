class Dice
  attr_reader :current_dice_values
  def initialize
    @dice_value_options = [1, 2, 3, 4, 5, 6]
    @clear_dice_values = { die1: nil, die2: nil, die3: nil,
                             die4: nil, die5: nil, die6: nil }
    @current_dice_values = @clear_dice_values
    @number_of_rolls = 0
  end

  def roll_dice
    unless @number_of_rolls > 3
      @current_dice_values.keys.each do |key|
        @current_dice_values[key] = @dice_value_options.sample
        @number_of_rolls += 1
      end
    else
      print("New round!")
      @current_dice_values = @clear_dice_values
    end
  end
end




my_game = Dice.new
my_game.roll_dice
print(my_game.current_dice_values)
