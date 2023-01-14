dofile("lua/game/__game.lua")

Field = meta.Type("Field");

function Field.__instance:GetDimensions()
  return self.__dimensions;
end

function Field.__instance:GetValue(n_x, n_y)
  return self[n_y][n_x];
end

function Field.__instance:SetValue(n_x, n_y, player)
  if self[n_y][n_x] ~= 0 and player ~= 0 then
    io_utils.Out("The field is already occupied by %s.", self[n_y][n_x]);
    return false;
  end
  self[n_y][n_x] = player;
  return true;
end

function Field.__instance:Draw()
  local to_draw = "";
  for y = 1, self.__dimensions do
    for x = 1, self.__dimensions do
      if self[y][x] ~= 0 then
        to_draw = to_draw..self[y][x].character.." ";
      else
        to_draw = to_draw.."- ";
      end
    end
    if y < self.__dimensions then
      to_draw = to_draw.."\n";
    end
  end
  io_utils.Out(to_draw);
end

function Field.__instance:__CheckHorizontal(n_y, player)
  for x = 1, self.__dimensions do
    if self[n_y][x] ~= player then
      return false;
    end
  end
  return true;
end

function Field.__instance:__CheckHorizontals(player)
  for y = 1, self.__dimensions do
    if self:__CheckHorizontal(y, player) then
      return true;
    end
  end
  return false;
end

function Field.__instance:__CheckVertical(n_x, player)
  for y = 1, self.__dimensions do
    if self[y][n_x] ~= player then
      return false;
    end
  end
  return true;
end

function Field.__instance:__CheckVerticals(player)
  for x = 1, self.__dimensions do
    if self:__CheckVertical(x, player) then
      return true;
    end
  end
  return false;
end

function Field.__instance:__CheckDiagonal1(player)
  for xy = 1, self.__dimensions do
    if self[xy][xy] ~= player then
      return false;
    end
  end
  return true;
end

function Field.__instance:__CheckDiagonal2(player)
  local x, y = self.__dimensions, 1;
  while x > 0 do
    if self[y][x] ~= player then
      return false;
    end
    x = x - 1;
    y = y + 1;
  end
  return true;
end

function Field.__instance:__CheckDiagonals(player)
  return self:__CheckDiagonal1(player) or self:__CheckDiagonal2(player);
end

function Field.__instance:IsWinner(player)
  return self:__CheckHorizontals(player) or self:__CheckVerticals(player) or self:__CheckDiagonals(player);
end

function Field.__instance:IsDraw()
  for y = 1, self.__dimensions do
    for x = 1, self.__dimensions do
      if self[y][x] == 0 then
        return false;
      end
    end
  end
  return true;
end

function Field.__instance:Field(n_dimensions)
  self.__dimensions = n_dimensions;
  for y = 1, self.__dimensions do
    self[y] = {};
    for x = 1, self.__dimensions do
      self[y][x] = 0;
    end
  end
end

function Field.__instance:Copy()
  local to_return = Field(self.__dimensions);
  for y = 1, to_return.__dimensions do
    to_return[y] = {};
    for x = 1, to_return.__dimensions do
      to_return[y][x] = self[y][x];
    end
  end
  return to_return;
end
