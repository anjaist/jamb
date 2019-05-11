require 'pry-byebug'
require 'gosu'
require_relative 'score'
require_relative 'board'

class DiceGame < Gosu::Window
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  WHITE = Gosu::Color::WHITE
  DICE_SIZE = 55

  attr_reader :current_dice_values, :players, :player1_score, :player2_score

  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT

    @dice_value_options = [1, 2, 3, 4, 5]
    @clear_dice_values = []
    5.times { @clear_dice_values << { value: nil, rolls: 0 } }
    @current_dice_values = @clear_dice_values
    @players = { 'player1' => { active: true, score: 0 },
                 'player2' => { active: false, score: 0 } }
    @player1_score = Score.new
    @player2_score = Score.new
    @active = 'player1'
    @game_over = false
    @board = Board.new
    @font = Gosu::Font.new(self, 'Arial', 15)
  end

  def game_loop
    until @game_over
      active_player = determine_active_player
      puts("\n+ + + + + + JAMB: #{active_player} + + + + + +\n")
      players_round(active_player)
      # TODO: incorporate check for game_over
      # game_over?
    end
  end

  def draw
    # TODO: use actual current_dice_values
    dice_values = dice_values_only
    @board.draw(dice_values, @font) if dice_values[0]
  end

  def update
    game_loop
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
    num_of_fields = @player1_score.field_names.length
    player1_values = @player1_score.user_score_card.values
    player2_values = @player2_score.user_score_card.values
    player1_finished = false
    player2_finished = false
    if player1_values[0].length == num_of_fields &&
       player1_values[1].length == num_of_fields &&
       player1_values[2].length == num_of_fields
      player1_finished = true
    end
    if player2_values[0].length == num_of_fields &&
       player2_values[1].length == num_of_fields &&
       player2_values[2].length == num_of_fields
      player2_finished = true
    end
    player1_finished && player2_finished
  end
end

DiceGame.new.show
