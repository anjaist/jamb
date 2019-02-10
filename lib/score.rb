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
    # shows which score can be marked down; to be called after each dice roll
  end

  def calculate_dice_of_number(dice_values, num)
    dice_values.count(num) * num
  end

  def calculate_max_or_min(dice_values)
    dice_values.sum
  end

  def tris?(dice_values)
    dice_values.each do |value|
      return true if dice_values.count(value) >= 3
    end
    false
  end

  def calculate_tris(dice_values)
    number = 0
    dice_values.each do |value|
      if dice_values.count(value) >= 3
        number += value
        break
      end
    end
    number * 3 + 10
  end

  def kenta?(dice_values)
    dice_values.sort == [1, 2, 3, 4, 5] || dice_values.sort == [2, 3, 4, 5, 6]
  end

  def calculate_kenta(dice_values)
    (dice_values.include? 1) ? score = 20 : score = 30
    score
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

  def calculate_full(dice_values)
    dice_values.sum + 40
  end

  def poker?(dice_values)
    dice_values.each do |value|
      return true if dice_values.count(value) >= 4
    end
    false
  end

  def calculate_poker(dice_values)
    number = 0
    dice_values.each do |value|
      if dice_values.count(value) >= 4
        number += value
        break
      end
    end
    number * 4 + 50
  end

  def jamb?(dice_values)
    dice_values.uniq.length == 1
  end

  def calculate_jamb(dice_values)
    dice_values.sum + 100
  end
end
