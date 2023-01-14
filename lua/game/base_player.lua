dofile("lua/game/field.lua");

BasePlayer = meta.Type("BasePlayer");

function BasePlayer.__instance:ToString()
  return to_text("%s[%s]", self.name, self.character);
end

function BasePlayer.__instance:BasePlayer(s_name)
  self.name = s_name;
  self.character = '?';
end

function BasePlayer.__instance:Move()
  io_utils.Out("It's %s move...", self);
end
