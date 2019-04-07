require_relative 'score'

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
    @player1_score = Score.new
    @player2_score = Score.new
    @active = 'player1'
    @game_over = false
  end

  def game_loop
    until @game_over
      active_player = determine_active_player
      players_round(active_player)
    end
  end

  def players_round(player)
    first_roll
    roll_until_finished
    score = 1 # temp line
    add_current_round_to_user_score(player, score)
    @players[player][:active] = false
    update_active_player
    puts 'round finished!'
    @current_dice_values = @clear_dice_values
  end

  def first_roll
    (0...5).each { |x| roll_one_dice(x) }
    @current_dice_values.each { |d| d[:rolls] += 1 }
    display_current_board
  end

  def choose_dice
    puts('which dice do you want to roll again? Press F to finish round')
    choice_str = gets.chomp
    choice = choice_str.to_i - 1
    return false if choice_str.upcase == 'F'
    choice
  end

  def roll_until_finished
    available_dice = [0, 1, 2, 3, 4]
    while available_dice != []
      choice = choose_dice
      break unless choice
      if available_dice.include? choice
        available_dice.delete(choice) if roll_limit_reached?(choice)
        roll_one_dice(choice)
        display_current_board
      else
        puts 'you alredy rolled this dice 3 times'
      end
    end
  end

  def dice_values_only
    values = []
    @current_dice_values.each do |dice|
      values << dice[:value]
    end
    values
  end

  def display_current_board
    puts('====================')
    @current_dice_values.each { |d| puts(d[:value]) }
    current_score = determine_score_class_for_player
    current_score.show_options(dice_values_only)
    # TODO: fix show_options options
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

  def determine_active_player
    @players.each { |name, info| return name if info[:active] }
  end

  def determine_score_class_for_player
    player = determine_active_player
    return @player1_score if player == 'player1'
    return @player2_score if player == 'player2'
  end

  def display_current_score
    # TODO: show possibilities at each dice roll
  end

  def add_current_round_to_user_score(player, score)
    @players[player][:score] += score
  end

  def game_over?
    # TODO: true if all players fulfilled all fields
  end
end

# gameplay:
#
my_game = Dice.new
my_game.players_round('player1')
