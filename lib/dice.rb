class Dice
  attr_reader :current_dice_values, :players
  def initialize(use_own_dice = false)
    @dice_value_options = [1, 2, 3, 4, 5]
    @clear_dice_values = []
    5.times { @clear_dice_values << { value: nil, rolls: 0 } }
    @current_dice_values = @clear_dice_values
    @use_own_dice = use_own_dice
    @players = { 'player1' => { active: true, score: 0 },
                 'player2' => { active: false, score: 0 } }
    @active = 'player1'
  end

  def first_roll(player)
    if @players[player][:active]
      (0...5).each { |x| roll_one_dice(x) }
      @current_dice_values.each { |d| d[:rolls] += 1 }
      display_current_board
    else
      puts "it's not #{player}'s turn"
    end
  end

  def roll_again(player)
    available_dice = [0, 1, 2, 3, 4]
    while available_dice != []
      puts('which dice do you want to roll again? Press Q to finish round')
      choice_str = gets.chomp
      choice = choice_str.to_i - 1
      break if choice == -1 && choice_str.upcase == 'Q'
      if available_dice.include? choice
        available_dice.delete(choice) if roll_limit_reached?(choice)
        roll_one_dice(choice)
        display_current_board
      else
        puts 'you alredy rolled this dice 3 times'
      end
    end
    @players[player][:active] = false
    update_active_player
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

  def update_active_player
    if !@players['player1'][:active]
      @players['player2'][:active] = true
    elsif !@players['player2'][:active]
      @players['player1'][:active] = true
    end
  end
end

# TODO: write begin_game/game_loop and determine_active_player

# gameplay
# #
# my_game = Dice.new
# my_game.first_roll('player1')
# my_game.roll_again('player1')
