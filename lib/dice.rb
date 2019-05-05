require 'pry-byebug'
require_relative 'score'

class Dice
  attr_reader :current_dice_values, :players
  def initialize
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
      puts("\n+ + + + + + JAMB: #{active_player} + + + + + +\n")
      players_round(active_player)
    end
  end

  def players_round(player)
    first_roll
    roll_until_finished
    score = choose_score_to_commit
    puts('=================')
    puts("score for current round: #{score}")
    add_current_round_to_user_score(player, score)
    update_active_player
    puts 'round finished!'
    @current_dice_values = @clear_dice_values
  end

  def first_roll
    (0...5).each { |x| roll_one_dice(x) }
    @current_dice_values.each { |d| d[:rolls] += 1 }
    display_current_board
  end

  def players_choice
    puts('-> Press R to roll a dice again')
    puts('-> Press F to finish round')
    while true
      choice_str = gets.chomp
      return false if choice_str.upcase == 'F'
      if choice_str.upcase == 'R'
        puts('which dice do you want to roll again?')
        choice_str = gets.chomp
        return choice_str.to_i - 1
      else
        puts('press either R or F, you dweeb')
      end
    end
  end

  def roll_until_finished
    available_dice = [0, 1, 2, 3, 4]
    while available_dice != []
      choice = players_choice
      break unless choice
      if available_dice.include? choice
        available_dice.delete(choice) if roll_limit_reached?(choice)
        roll_one_dice(choice)
        display_current_board
      else
        puts 'you already rolled this dice 3 times'
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
    puts('====================')
    puts('=> your options:')
    puts(current_score.show_options(dice_values_only))
    puts('====================')
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
    if @players['player1'][:active]
      @players['player1'][:active] = false
      @players['player2'][:active] = true
    else
      @players['player2'][:active] = false
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

  def choose_column
    puts('-> Choose column: press u, d or ud')
    while true
      column = gets.chomp
      break if ['u', 'd', 'ud'].include? column.downcase
      puts('Dude, it\'s u, d or ud')
    end
    return 'up' if column.downcase == 'u'
    return 'down' if column.downcase == 'd'
    return 'up-down' if column.downcase == 'ud'
  end

  def choose_row
    current_score = determine_score_class_for_player
    puts('-> Choose row: type full word')
    while true
      all_fields = current_score.field_names
      row = gets.chomp.downcase
      break if all_fields.include? row.downcase
      puts('-> Gotta type the full word...')
    end
    row
  end

  def choose_score_to_commit
    current_score = determine_score_class_for_player
    options = current_score.show_options(dice_values_only)
    while true
      column = choose_column
      row = choose_row
      score = options[column][row]
      zero_score = commit_zero_score? if score.zero?
      next if zero_score == false
      break if current_score.field_free?(column, row)
    end
    current_score.update_fields(column, row, score)
    score
  end

  def commit_zero_score?
    while true
      puts('Are you sure you want to commit a score of 0? [y/n]')
      answer = gets.chomp
      return false if answer.downcase == 'n'
      return true if answer.downcase == 'y'
      puts("Please type 'y' or 'n'...")
    end
  end

  def add_current_round_to_user_score(player, score)
    @players[player][:score] += score
  end

  def game_over?
    # TODO: true if all players fulfilled all fields
  end
end

# gameplay:
# my_game = Dice.new
# my_game.game_loop
