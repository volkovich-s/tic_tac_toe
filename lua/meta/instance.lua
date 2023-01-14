dofile("lua/meta/__meta.lua");

if not meta.instance_meta then
  meta.instance_meta = {};
end

local instance_meta = meta.instance_meta;

function instance_meta:__index(v_i)
  if self ~= self.__type.__instance then
    return self.__type.__instance[v_i];
  elseif self.__type.__base_type then
    return self.__type.__base_type.__instance[v_i];
  end
end

function instance_meta:__tostring()
  if self.ToString then
    return self:ToString();
  end
  return self.__type.TypeName.."[instance]";
end
