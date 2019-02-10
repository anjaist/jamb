class Score
  def initialize(player)
    @player = player
    @score = 0
    @field_names = ['one', 'two', 'three', 'four', 'five', 'six', 'max', 'min',
                    'tris', 'kenta', 'full', 'poker', 'jamb']
    @down_column = {}
    @up_column = {}
    @updown_column = {}
  end

  def show_options
    # shows which score can be marked down
  end

  def tris?(dice_values)
    dice_values.each do |value|
      return true if dice_values.count(value) >= 3
    end
    false
  end

  def kenta?(dice_values)
    dice_values.sort == [1, 2, 3, 4, 5] || dice_values.sort == [2, 3, 4, 5, 6]
  end

  def full?(dice_values)
    two = false
    three = false
    dice_values.each do |value|
      two = true if dice_values.count(value) == 2
      three = true if dice_values.count(value) == 3
    end
    jamb?(dice_values) || (two && three)
  end

  def poker?(dice_values)
    dice_values.each do |value|
      return true if dice_values.count(value) >= 4
    end
    false
  end

  def jamb?(dice_values)
    dice_values.uniq.length == 1
  end
end
