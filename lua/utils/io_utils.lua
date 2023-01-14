require "lua/utils/string_utils";
require "lua/utils/text_utils";

io_utils = {};

function io_utils.In()
  return io.read("*line");
end

function io_utils.Out(...)
  io.write(to_text(...));
  io.write('\n');
end

function io_utils.Error(...)
  local text = to_text(...);
  io_utils.Out(text);
  error(text, 2);
end

function io_utils.__ToBoolean(s, s_yes, s_no)
  if s == s_yes then
    return true;
  elseif s == s_no then
    return false;
  end
  io_utils.Error("%s MUST be boolean.\n", s);
end

function io_utils.InBoolean(s_yes, s_no)
  io_utils.Out("Please, input the boolean (%s or %s):", s_yes, s_no);
  return io_utils.__ToBoolean(io_utils.In(), s_yes, s_no);
end

function io_utils.InBooleanLoop(s_yes, s_no)
  io_utils.Out("Please, input the boolean (%s or %s):", s_yes, s_no);
  local success, to_return;
  repeat
    success, to_return = pcall(io_utils.__ToBoolean, io_utils.In(), s_yes, s_no);
  until success;
  return to_return;
end

function io_utils.__ToNumber(s, n_min, n_max)
  local to_return = tonumber(s);
  if to_return == nil then
    io_utils.Error("%s MUST be number.", s);
  end
  if (n_min ~= nil and to_return < n_min) or (n_max ~= nil and to_return > n_max) then
    io_utils.Error("%s MUST be in range %s-%s.", to_return, n_min, n_max);
  end
  return to_return;
end

function io_utils.InNumber(n_min, n_max)
  io_utils.Out("Please, input the number (%s-%s):", n_min, n_max);
  return io_utils.__ToNumber(io_utils.In(), n_min, n_max);
end

function io_utils.InNumberLoop(n_min, n_max)
  io_utils.Out("Please, input the number (%s-%s):", n_min, n_max);
  local success, to_return;
  repeat
    success, to_return = pcall(io_utils.__ToNumber, io_utils.In(), n_min, n_max);
  until success;
  return to_return;
end

function io_utils.__ToP2D(s, n_min_x, n_max_x, n_min_y, n_max_y)
  local ss = string_utils.Split(s, " ");
  if #ss ~= 2 then
    io_utils.Error("%s MUST be p2d.", s);
  end
  return io_utils.__ToNumber(ss[1], n_min_x, n_max_x), io_utils.__ToNumber(ss[2], n_min_y, n_max_y);
end

function io_utils.InP2D(n_min_x, n_max_x, n_min_y, n_max_y)
  io_utils.Out("Please, input the p2d (example: %s-%s %s-%s):", n_min_x, n_max_x, n_min_y, n_max_y);
  return io_utils.__ToP2D(io_utils.In(), n_min_x, n_max_x, n_min_y, n_max_y);
end

function io_utils.InP2DLoop(n_min_x, n_max_x, n_min_y, n_max_y)
  io_utils.Out("Please, input the p2d (example: %s-%s %s-%s):", n_min_x, n_max_x, n_min_y, n_max_y);
  local success, to_return_x, to_return_y;
  repeat
    success, to_return_x, to_return_y = pcall(io_utils.__ToP2D, io_utils.In(), n_min_x, n_max_x, n_min_y, n_max_y);
  until success;
  return to_return_x, to_return_y;
end
