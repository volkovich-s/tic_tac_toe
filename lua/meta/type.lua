dofile("lua/meta/instance.lua");

if not meta.type_meta then
  meta.type_meta = {};
end

local type_meta = meta.type_meta;

function type_meta:__index(v_i)
  if rawget(self, "__base_type") then
    return self.__base_type[v_i];
  end
end

function type_meta:__tostring()
  if self.ToString then
    return self:ToString();
  end
  return self.__type.TypeName;
end

function type_meta:__call(...)
  local to_return = {
    __type = self
  };
  setmetatable(to_return, meta.instance_meta);
  to_return[self.TypeName](to_return, ...);
  return to_return;
end

function meta.Type(s_name, t_base)
  local to_return = {
    TypeName = s_name,
    __base_type = t_base,
    __instance = {}
  };
  to_return.__instance.__type = to_return;
  if t_base then
    to_return.__instance[s_name] = function(self, ...)
      t_base.__instance[t_base.TypeName](self, ...);
    end
  else
    to_return.__instance[s_name] = function(self)
    end
  end
  setmetatable(to_return, meta.type_meta);
  setmetatable(to_return.__instance, meta.instance_meta);
  return to_return;
end
