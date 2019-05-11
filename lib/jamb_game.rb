require 'gosu'
require_relative 'dice'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
WHITE = Gosu::Color::WHITE
DICE_SIZE = 55

class JambGame < Gosu::Window
  def initialize(dice_values)
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = 'Jamb: The Game'
    @dice_values = dice_values
    @x_start = WINDOW_WIDTH / 5 - 1.3 * DICE_SIZE
    @y_start = WINDOW_HEIGHT / 2 - DICE_SIZE
    @font = Gosu::Font.new(self, 'Arial', 15)
    # TODO: draw game_loop in the window
    # my_game = Dice.new
    # my_game.game_loop
  end

  def draw
    # TODO: use actual current_dice_values
    x = @x_start
    y = @y_start
    dice_ids = (1..5).to_a
    current_id = dice_ids.clone
    @dice_values.each do |dice|
      dice_image = Gosu::Image.new("lib/images/#{dice}.png")
      dice_image.draw(x, y, 0, 0.5, 0.5)
      @font.draw_text(current_id.shift.to_s, x + DICE_SIZE / 1.55,
                      y - DICE_SIZE / 2, 0, 1.0, 1.0, WHITE)
      x += DICE_SIZE * 2
    end
  end
end

JambGame.new([4, 4, 2, 4, 6]).show
