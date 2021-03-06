require 'dice'

describe '::dice' do
  test_game = Dice.new

  it 'each dice should have a random value between 1 and 6' do
    test_game.first_roll
    expected_values = [1, 2, 3, 4, 5]
    test_game.current_dice_values.each do |dice|
      expect(expected_values.include? dice[:value]).to be true
    end
  end

  describe '#roll_one_dice' do
    it 'should not allow user to roll one dice more than three times' do
      random_dice = rand(0...5)
      4.times { |_x| test_game.roll_one_dice(random_dice) }
      expect(test_game.current_dice_values[random_dice][:rolls]).to be <= 3
    end
  end

  # it "player's round ends if player presses 'f'" do
  #   allow_any_instance_of(Object).to receive(:gets).and_return 'f'
  #   test_game.players_round('player1')
  #   expect(test_game.players['player1'][:active]).to be false
  #   expect(test_game.players['player2'][:active]).to be true
  # end

  describe '#determine_active_player' do
    it 'should return active player' do
      expect(test_game.determine_active_player).to eq 'player1'
    end
  end

  describe '#update_active_player' do
    it 'should change player\'s active status each round' do
      test_game.update_active_player
      expect(test_game.players['player1'][:active]).to be false
      expect(test_game.players['player2'][:active]).to be true
      test_game.update_active_player
      expect(test_game.players['player1'][:active]).to be true
      expect(test_game.players['player2'][:active]).to be false
    end
  end

  describe '#game_over?' do
    test_game.player1_score.field_names.each do |field_name|
      test_game.player1_score.user_score_card['up'][field_name] = 0
      test_game.player1_score.user_score_card['up-down'][field_name] = 0
      test_game.player1_score.user_score_card['down'][field_name] = 0
    end
    test_game.player2_score.field_names.each do |field_name|
      test_game.player2_score.user_score_card['up'][field_name] = 0
      test_game.player2_score.user_score_card['up-down'][field_name] = 0
      test_game.player2_score.user_score_card['down'][field_name] = 0
    end
    it 'should return true if both players completed all field in score card' do
      expect(test_game.game_over?).to be true
    end
    it 'should return false if either player still has empty fields in
        score card' do
      test_game.player2_score.user_score_card['up'].delete('one')
      expect(test_game.game_over?).to be false
    end
  end
end
