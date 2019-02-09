class Dice
  attr_reader :current_dice_values, :number_of_rolls
  def initialize
    @dice_value_options = [1, 2, 3, 4, 5, 6]
    @clear_dice_values = { die1: nil, die2: nil, die3: nil,
                           die4: nil, die5: nil, die6: nil }
    @current_dice_values = @clear_dice_values
    @number_of_rolls = 0
  end

  def roll_dice
    if @number_of_rolls < 3
      @current_dice_values.keys.each do |key|
        @current_dice_values[key] = @dice_value_options.sample
      end
      @number_of_rolls += 1
    else
      puts("New round!")
      @current_dice_values = @clear_dice_values
      @number_of_rolls = 0
    end
  end
end
