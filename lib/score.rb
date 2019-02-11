class Score
  def initialize(player)
    @player = player
    @score = 0
    @field_names = ['one', 'two', 'three', 'four', 'five', 'six', 'max', 'min',
                    'tris', 'kenta', 'full', 'poker', 'jamb']
    @down_column = @field_names
    @up_column = @field_names
    @updown_column = {}
    @dice_values = nil
  end

  def show_options(dice_values)
    all_options = all_options(dice_values)
    show = { 'down' => {}, 'up-down' => {}, 'up' => {} }
    @field_names.each do |f|
      show['up-down'][f] = all_options[f] unless @updown_column.key? f
      if @up_column != []
        show['up'][f] = all_options[f] if @up_column[-1] == f
        @up_column.delete(f)
      end
      if @down_column != []
        show['down'][f] = all_options[f] if @down_column[0] == f
      end
    end
  end

  # TODO: write test for show_options

  def all_options(dv)
    options = {}
    options['one'] = calculate_dice_of_number(dv, 1) if dv.include? 1
    options['two'] = calculate_dice_of_number(dv, 2) if dv.include? 2
    options['three'] = calculate_dice_of_number(dv, 3) if dv.include? 3
    options['four'] = calculate_dice_of_number(dv, 4) if dv.include? 4
    options['one'] = calculate_dice_of_number(dv, 5) if dv.include? 5
    options['six'] = calculate_dice_of_number(dv, 6) if dv.include? 6
    options['max'] = calculate_max_or_min(dv)
    options['min'] = calculate_max_or_min(dv)
    options['tris'] = calculate_tris(dv) if tris?(dv)
    options['kenta'] = calculate_kenta(dv) if kenta?(dv)
    options['full'] = calculate_full(dv) if full?(dv)
    options['poker'] = calculate_poker(dv) if poker?(dv)
    options['jamb'] = calculate_jamb(dv) if jamb?(dv)
    options
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
