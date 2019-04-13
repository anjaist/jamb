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

  it 'should not allow user to roll one dice more than three times' do
    random_dice = rand(0...5)
    4.times { |_x| test_game.roll_one_dice(random_dice) }
    expect(test_game.current_dice_values[random_dice][:rolls]).to be <= 3
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
end
