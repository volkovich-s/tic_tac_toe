dofile("lua/game/base_player.lua");

Player = meta.Type("Player", BasePlayer);

function Player.__instance:Move()
  BasePlayer.__instance.Move(self);
  local x, y;
  repeat
    x, y = io_utils.InP2DLoop(1, game.GetField():GetDimensions(), 1, game.GetField():GetDimensions());
  until game.GetField():SetValue(x, y, self);
end
