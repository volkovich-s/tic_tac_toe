dofile("lua/game/player.lua");

AI = meta.Type("AI", BasePlayer);

function BasePlayer.__instance:__IsMoveWinning(n_x, n_y, player)
  self.__field:SetValue(n_x, n_y, player);
  local to_return = self.__field:IsWinner(player);
  self.__field:SetValue(n_x, n_y, 0);
  return to_return;
end

function BasePlayer.__instance:__DefinePriority(n_x, n_y)
  -- Impossible
  if self.__field[n_y][n_x] ~= 0 then
    return -1;
  end
  -- Win
  if self:__IsMoveWinning(n_x, n_y, self) then
    return 1;
  end
  local other_player;
  if game.player1 == self then
    other_player = game.player2;
  else
    other_player = game.player1;
  end
  -- Not lose
  if self:__IsMoveWinning(n_x, n_y, other_player) then
    return 0.75;
  end
  -- Centre
  if n_x == (self.__field.__dimensions + 1) / 2 and n_y == (self.__field.__dimensions + 1) / 2 then
    return 0.5;
  end
  -- Corner
  if (n_x == 1 and n_y == 1) or (n_x == self.__field.__dimensions and n_y == 1) or (n_x == 1 and n_y == self.__field.__dimensions) or (n_x == self.__field.__dimensions and n_y == self.__field.__dimensions) then
    return 0.25;
  end
  return 0;
end

function BasePlayer.__instance:__FindMove()
  self.__field = game.GetField():Copy();
  local priority, max_priority = {}, 0;
  for y = 1, self.__field:GetDimensions() do
    priority[y] = {};
    for x = 1, self.__field:GetDimensions() do
      priority[y][x] = self:__DefinePriority(x, y);
      if priority[y][x] > max_priority then
        max_priority = priority[y][x];
      end
    end
  end
  local possible_moves = {};
  for y = 1, self.__field:GetDimensions() do
    for x = 1, self.__field:GetDimensions() do
      if priority[y][x] == max_priority then
        table.insert(possible_moves, { x, y });
      end
    end
  end
  local move = possible_moves[number_utils.Random(1, #possible_moves)];
  self.__field = nil;
  return move[1], move[2];
end

function AI.__instance:Move()
  BasePlayer.__instance.Move(self);
  local x, y = self:__FindMove();
  game.GetField():SetValue(x, y, self);
end
