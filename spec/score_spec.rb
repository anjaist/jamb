require 'score'

describe '::score' do
  test_score = Score.new
  describe '#tris?' do
    it 'should return true if current dice values contain at least 3 of x' do
      expect(test_score.tris?([1, 2, 2, 4, 2])).to be true
    end
    it "should return false if current dice values don't contain 3 of x" do
      expect(test_score.tris?([1, 2, 4, 4, 2])).to be false
    end
  end
  describe '#kenta?' do
    it 'should return true if current dice values contain values 1-5 or 2-6' do
      expect(test_score.kenta?([1, 2, 3, 4, 5])).to be true
      expect(test_score.kenta?([2, 3, 4, 5, 6])).to be true
    end
    it 'should return false if current dice values don\'t
        contain values 1-5 or 2-6' do
      expect(test_score.kenta?([1, 2, 3, 5, 6])).to be false
    end
  end
  describe '#full?' do
    it 'should return true if dice values contain 3 of x and 2 of y' do
      expect(test_score.full?([2, 2, 6, 6, 6])).to be true
    end
  end
  describe '#poker?' do
    it 'should return true if dice values contain 4 of x' do
      expect(test_score.poker?([1, 1, 1, 6, 1])).to be true
      expect(test_score.poker?([5, 5, 5, 5, 5])).to be true
    end
    it 'should return false if dice values don\'t contain 4 of x' do
      expect(test_score.poker?([1, 1, 6, 6, 1])).to be false
    end
  end
  describe '#jamb?' do
    it 'should return true if dice values contain all the same values' do
      expect(test_score.jamb?([6, 6, 6, 6, 6])).to be true
    end
  end
  describe '#calculate_tris' do
    it 'should calculate tris correctly' do
      expect(test_score.calculate_tris([1, 2, 2, 4, 2])).to be 16
    end
  end
  describe '#calculate_kenta' do
    it 'should calculate kenta correctly' do
      expect(test_score.calculate_kenta([1, 2, 3, 4, 5])).to be 20
      expect(test_score.calculate_kenta([2, 3, 4, 5, 6])).to be 30
    end
  end
  describe '#calculate_full' do
    it 'should calculate full correctly' do
      expect(test_score.calculate_full([4, 2, 2, 4, 4])).to be 56
    end
  end
  describe '#calculate_poker' do
    it 'should calculate poker correctly' do
      expect(test_score.calculate_poker([4, 2, 2, 2, 2])).to be 58
    end
  end
  describe '#calculate_jamb' do
    it 'should calculate jamb correctly' do
      expect(test_score.calculate_jamb([4, 4, 4, 4, 4])).to be 120
    end
  end
  describe '#show_options' do
    expected_result = { 'down' => { 'one' => 1 },
                        'up-down' => { 'one' => 1, 'two' => 4, 'five' => 10,
                                       'max' => 15, 'min' => 15 },
                        'up' => {} }
    it 'should show options correctly' do
      expect(test_score.show_options([2, 1, 5, 2, 5])).to eq(expected_result)
    end
  end
  describe '#field_free?' do
    it 'should return true if field is free, false otherwise' do
      puts(test_score.user_score_card)
      test_score.user_score_card['up-down']['three'] = 9
      expect(test_score.field_free?('up-down', 'three')).to be false
      expect(test_score.field_free?('up-down', 'one')).to be true
    end
  end
end
