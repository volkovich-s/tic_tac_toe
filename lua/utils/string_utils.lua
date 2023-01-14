string_utils = {};

function string_utils.Split(s, separator)
  local to_return = {};
  for subs in string.gmatch(s, "([^"..separator.."]+)") do
    table.insert(to_return, subs);
  end
  return to_return;
end
