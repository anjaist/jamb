require 'gosu'
require_relative 'dice'

class JambGame < Gosu::Window
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = 'Jamb: The Game'
    # TODO: draw game_loop in the window
    # my_game = Dice.new
    # my_game.game_loop
  end
end

JambGame.new.show
