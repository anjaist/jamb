require 'gosu'

class Board
  def initialize
    @x_start = DiceGame::WINDOW_WIDTH / 5 - 1.3 * DiceGame::DICE_SIZE
    @y_start = DiceGame::WINDOW_HEIGHT / 2 - DiceGame::DICE_SIZE
  end

  def draw(dice_values, font)
    x = @x_start
    y = @y_start
    dice_ids = (1..5).to_a
    current_id = dice_ids.clone
    dice_values.each do |dice|
      dice_image = Gosu::Image.new("lib/images/#{dice}.png")
      dice_image.draw(x, y, 0, 0.5, 0.5)
      font.draw_text(current_id.shift.to_s, x + DICE_SIZE / 1.55,
                     y - DICE_SIZE / 2, 0, 1.0, 1.0, WHITE)
      x += DICE_SIZE * 2
    end
  end
end
