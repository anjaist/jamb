require 'dice'

describe '#roll_dice' do
  test_game = Dice.new

  it 'each dice should have a random value between 1 and 6' do
    test_game.roll_dice
    expected_values = [1, 2, 3, 4, 5, 6]
    test_game.current_dice_values.values.each do |value|
      expect(expected_values.include? value).to be true
    end
  end

  4.times { |_x| test_game.roll_dice }
  it 'should not allow user to roll more than three times' do
    expect(test_game.number_of_rolls).to be <= 3
  end
end
