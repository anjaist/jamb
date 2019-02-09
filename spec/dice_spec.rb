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

  random_dice = rand(0...5)
  4.times { |_x| test_game.roll_one_dice(random_dice) }
  it 'should not allow user to roll one dice more than three times' do
    expect(test_game.current_dice_values[random_dice][:rolls]).to be <= 3
  end
end

# TODO: write test that game ends after all dice have been
# rolled 3 times
