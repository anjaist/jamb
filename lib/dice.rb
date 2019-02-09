class Dice
  attr_reader :current_dice_values
  def initialize(use_own_dice = false)
    @dice_value_options = [1, 2, 3, 4, 5]
    @clear_dice_values = []
    5.times { @clear_dice_values << { value: nil, rolls: 0 } }
    @current_dice_values = @clear_dice_values
    @use_own_dice = use_own_dice
  end

  def first_roll
    (0...5).each { |x| roll_one_dice(x) }
    display_current_board
  end

  def roll_again
    available_dice = [0, 1, 2, 3, 4]
    while available_dice
      puts('which dice do you want to roll again? Press Q to finish round')
      choice_str = gets.chomp
      choice = choice_str.to_i - 1
      break if choice == -1 && choice_str.upcase == 'Q'
      if available_dice.include? choice
        roll_one_dice(choice)
        display_current_board
        available_dice.delete(choice) if roll_limit_reached?(choice)
      else
        puts 'you alredy rolled this dice 3 times'
      end
    end
    puts 'round finished!' # temp line
    @current_dice_values = @clear_dice_values
  end

  def display_current_board
    @current_dice_values.each { |d| puts(d[:value]) }
  end

  def roll_one_dice(dice)
    unless roll_limit_reached?(dice)
      @current_dice_values[dice][:value] = @dice_value_options.sample
      @current_dice_values[dice][:rolls] += 1
    end
  end

  def roll_limit_reached?(dice)
    @current_dice_values[dice][:rolls] == 3
  end
end

# gameplay
#
# my_game = Dice.new
# my_game.first_roll
# my_game.roll_again
