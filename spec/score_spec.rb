require 'score'

describe '::score' do
  test_score = Score.new('player1')
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
end
