dofile("lua/game/ai.lua");

function game.GetField()
  return game.__field;
end

function game.__InDimensionsLoop()
  io_utils.Out("Please, select the dimensions:");
  game.__field = Field(io_utils.InNumberLoop(3, 5));
end

function game.__ToGamemode(s)
  if s == "pp" then
    game.player1 = Player("Player 1");
    game.player2 = Player("Player 2");
  elseif s == "pai" then
    game.player1 = Player("Player");
    game.player2 = AI("AI");
  elseif s == "aiai" then
    game.player1 = AI("AI 1");
    game.player2 = AI("AI 2");
  else
    io_utils.Error("%s MUST be either pp, either pai, either aiai.", s);
  end
end

function game.__InGamemode()
  io_utils.Out("Please, select the gamemode (pp (player against player), pai (player against ai) or aiai (ai against ai)):");
  game.__ToGamemode(io_utils.In());
end

function game.__InGamemodeLoop()
  io_utils.Out("Please, select the gamemode (pp (player against player), pai (player against ai) or aiai (ai against ai)):");
  repeat
    pcall(game.__ToGamemode, io_utils.In());
  until game.player1;
end

function game.Begin()
  game.__InDimensionsLoop();
  game.__InGamemodeLoop();
  game.Move();
  return game.End();
end

function game.Move()
  io_utils.Out("The players are: %s and %s. The first one to move will be determined by random...", game.player1, game.player2);
  local active_player = number_utils.Random(0, 1);
  if active_player == 0 then
    active_player = game.player1;
    game.player2.character = '0';
  else
    active_player = game.player2;
    game.player1.character = '0';
  end
  active_player.character = 'x';
  io_utils.Out("The first to move is: %s.", active_player);

  local has_winner, is_draw = false, false;
  repeat
    game.__field:Draw();
    active_player:Move();
    has_winner = game.__field:IsWinner(active_player);
    is_draw = game.__field:IsDraw();
    if not has_winner then
      if active_player == game.player1 then
        active_player = game.player2;
      else
        active_player = game.player1;
      end
    end
  until has_winner or is_draw;
  game.__field:Draw();
  if has_winner then
    io_utils.Out("The winner is: %s.", active_player);
  else
    io_utils.Out("It's a draw.");
  end
end

function game.End()
  game.__field = nil;
  game.player1 = nil;
  game.player2 = nil;
  io_utils.Out("Restart?");
  return io_utils.InBooleanLoop("yes", "no");
end
