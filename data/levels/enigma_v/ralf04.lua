-- A level for Enigma
-- Name:        Enigris
-- Filename: 	ralf04.lua
-- Copyright: 	(C) Mar 2003 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

--warning_raises_error = 1

-- modifies by raoul
-- Anpassung an /levels/lib Struktur
-- original:
-- Require("levels/lib/ralf.lua")

Require("levels/lib/ralf.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

floorface      = "fl-marble"
areafloorface  = "fl-sahara"
prevfloorface  = "fl-bluegray"

uncountedface  = "st-brick"
countedface    = "st-glass"
wallface       = "st-glass"

floorcell      = cell{floor={face=floorface}}
areafloorcell  = cell{floor={face=areafloorface}}
prevfloorcell  = cell{floor={face=prevfloorface}}

marble         = cell{actor={face="ac-blackball", attr={player=0}, mode=3}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

level = {
   "O!!!!!!!!!!!O.......",
   "%!!!!!!!!!!!%.@@@@@.",
   "%!!!!!!!!!!!%.@@@@@.",
   "%!!!!!!!!!!!%.@@@@@.",
   "%!!!!!!!!!!!%.@@@@@.",
   "%!!!!!!!!!!!%.@@@@@.",
   "%!!!!!!!!!!!%...T...",
   "%!!!!!!!!!!!%.#####.",
   "%!!!!!!!!!!!%.#1 2#.",
   "%!!!!!!!!!!!%.# o #.",
   "%!!!!!!!!!!!%.#3 4#.",
   "%!!!!!!!!!!!%.##5##.",
   "L!!!!!!!!!!!L..###..",
}

cells={}
cells["."] = abyss
cells["o"] = marble

cells["@"] = prevfloorcell

cells["!"] = areafloorcell
cells["%"] = cell{parent=areafloorcell,stone={face=uncountedface}}
cells["L"] = cell{parent=areafloorcell,stone={face="st-laser",attr={on=TRUE, dir=enigma.NORTH,name="soundstone"}}}
cells["O"] = cell{parent={areafloorcell,oxyd}}

cells[" "] = floorcell
cells["#"] = cell{parent=floorcell,stone={face=wallface}}
cells["T"] = cell{parent=floorcell,stone={face="st-timer",attr={action="callback", target="tick",interval=0.1}}}
cells["1"] = cell{parent=floorcell,item={face="it-trigger",attr={action="callback", target="trigger1"}}}
cells["2"] = cell{parent=floorcell,item={face="it-trigger",attr={action="callback", target="trigger2"}}}
cells["3"] = cell{parent=floorcell,item={face="it-trigger",attr={action="callback", target="trigger3"}}}
cells["4"] = cell{parent=floorcell,item={face="it-trigger",attr={action="callback", target="trigger4"}}}
cells["5"] = cell{parent=floorcell,item={face="it-trigger",attr={action="callback", target="trigger5"}}}

triggers = 5

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- The drop field:
dfieldx,dfieldy = 1,0
dfieldw,dfieldh = 11,13

-- The preview field:
pfieldx,pfieldy = 14,0
pfieldw,pfieldh = 5,5

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- The stones:

stone1={
   "xx",
   "x ",
   "x ",
}
stone2={
   "x ",
   "x ",
   "xx",
}
stone3={
   "x",
   "x",
   "x",
   "x",
}
stone4={
   "x ",
   "xx",
   " x",
}
stone5={
   " x",
   "xx",
   "x ",
}
stone6={
   " x ",
   "xxx",
}
stone7={
   "xx",
   "xx",
}
--stone8={
--   " x ",
--   "xxx",
--   " x ",
--}
--stone9={
--   "  x",
--   "xxx",
--   "x  ",
--}
--stone10={
--   "x  ",
--   "xxx",
--   "  x",
--}
--stone10={
--   "x   ",
--   "xxxx",
--   "x   ",
--}


stonedef = {
   stone1, stone2, stone3, stone4, stone5,
   stone6, stone7,
--   stone8, stone9, stone10
} -- list all stones here

stoneface = { -- define different faces for the stones
   "st-brownie",
   "st-rock5",
   "st-glass",
   "st-bluegray",
   "st-wood_001",

   "st-rock2",
   "st-stone_break",
   "st-fakeoxyd",
--   "st-wood",
--   "st-brick",
--   "st-grate1",
--   "st-grate2",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

randomseed(enigma.GetTicks())
realstonenum = getn(stonedef) -- number of real different stones
stonefacenum = getn(stoneface)
stonexsize = {} -- calculated below
stoneysize = {} -- calculated below

-- precalculate sizes of stones
for s=1,realstonenum do
   stonexsize[s],stoneysize[s] = get_map_size(stonedef[s])
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function sound(sound)
   enigma.EmitSound(enigma.GetNamedObject("soundstone"), sound)
end

function gen_map(width,height)
   local map={}
   for h=1,height do
      map[h] = strrep(" ",width)
   end
   return map
end

function plot_stone(smap,x,y)
   local row = smap[y]
   local nrow = strsub(row,1,x-1).."x"..strsub(row,x+1)
   smap[y] = nrow
end

-- generate rotated stones:
stonenum = realstonenum*4 -- including rotated stones
for s=realstonenum+1,stonenum do
   local left = s-realstonenum -- index of same stone (rotated leftwards)
   stonexsize[s],stoneysize[s] = stoneysize[left],stonexsize[left]
   stonedef[s] = gen_map(stonexsize[s],stoneysize[s])
   for y=1,stoneysize[left] do
      local row = stonedef[left][y]
      for x=1,stonexsize[left] do
         if (strsub(row,x,x) == "x") then
            plot_stone(stonedef[s],stonexsize[s]-y+1,x)
         end
      end
   end
end

-- plots into a map
-- returns 1 if successfull, 0 otherwise
-- typ == 0 -> empty (always successfull)
--     >= 1 -> number of stoneface
function plot_map(tomap,x,y,typ)
--   print(format("x=%i y=%i typ=%i",x,y,typ))
   local row = tomap[y]
   if (typ > 0) then
      local pos = strsub(row,x,x)
      if (pos >= "1") then return 0 end  -- error, pos already used
   end
   local nrow = strsub(row,1,x-1)
   if (typ==0) then
      nrow = nrow.."-"
   else
      nrow = nrow..tostring(typ)
   end
   nrow = nrow..strsub(row,x+1)
   tomap[y] = nrow
   return 1
end

function dump_map(themap)
   for y,str in pairs(themap) do
      print(y,"'",str,"'")
   end
end

-- inserts a stone into a map
-- returns 1, if stone has been inserted
function insert_stone(tomap,x0,y0,stonenr,facenr)
   local stone = stonedef[stonenr]

--   print(format("x=%i y=%i stone=%i face=%i",x0,y0,stonenr,facenr))

   for y=1,stoneysize[stonenr] do
      local idx = y+y0-1
      if (idx >= 1) then
         local srow = stone[y]
--         print(format("y=%i srow='%s'",y,srow))

         for x=1,stonexsize[stonenr] do
            local c = strsub(srow,x,x)
--            print(format("x=%i y=%i c=%s", x,y,c))
            if (c=="x") then
               local ok = plot_map(tomap,x+x0-1,idx,facenr)

               if (ok == 0) then

                  -- error occurred -> remove already inserted part
                  local xe,ye = x,y -- error position
                  for y=1,ye do
                     idx = y+y0-1
                     if (idx >= 1) then
                        local xm = stonexsize[stonenr]
                        if (y==ye) then xm = xe-1 end
                        srow = stone[y]
                        for x=1,xm do
                           if (strsub(srow,x,x)=="x") then
                              plot_map(tomap,x+x0-1,idx,0)
                           end
                        end
                     end
                  end
                  return 0

               end
            end
         end
      end
   end
--   dump_map(tomap)
   return 1
end

function remove_stone(frommap,x,y,stonenr)
   return insert_stone(frommap,x,y,stonenr,0)
end

function ds(x,y,facenr)
   set_stone(stoneface[facenr],x,y)
end
function rs(x,y)
   enigma.KillStone(x,y)
end
function skull(x,y)
   enigma.KillStone(x,y)
   set_stone("st-death",x,y)
   sound("shatter");
end
function breakout(x,y)
   enigma.KillStone(x,y)
end

function nothing(x,y)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- display defs for preview and game map

dcells={} -- draw
dcells[" "] = cell{{nothing}}
dcells["-"] = cell{parent={{rs}}}
dcells["S"] = cell{parent={{skull}}}
dcells["X"] = cell{parent={{breakout}}}
for i=1,stonefacenum do
   dcells[tostring(i)] = cell{parent={{ds,i}}}
end

pmap = gen_map(pfieldw,pfieldh)
dmap = gen_map(dfieldw,dfieldh)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
curr_s = {} -- current stone
next_s = {} -- next stone

showx = { 3, 3, 2, 2, 1}
showy = { 3, 3, 2, 2, 1}

broken_lines = {}

normalspeed = 10
points = 0

function show_points()
   local p = points
   local x1,x2 = 0,(dfieldx+dfieldw)
   for y=dfieldh-2,1,-1 do
      enigma.KillStone(x1,y)
      if (p>0) then
         set_stone(countedface,x1,y)
         p = p-1
      else
         set_stone(uncountedface,x1,y)
      end
   end
   for y=dfieldh-2,1,-1 do
      enigma.KillStone(x2,y)
      if (p>0) then
         set_stone(countedface,x2,y)
         p = p-1
      else
         set_stone(uncountedface,x2,y)
      end
   end
end

function check_breakouts()
   local oldpoints = points
   for y,str in pairs(dmap) do
      local spacefound = 0
      for x=1,dfieldw do
         local c = strsub(str,x,x)
         if ((c==" ") or (c=="-")) then
            spacefound = spacefound+1
         end
      end
      if (spacefound == 0) then
         dmap[y] = strrep("X",dfieldw)
         broken_lines[y] = 1
         points = points+1
      end
   end
   if (oldpoints ~= points) then
      show_points()
      if (points ~= 0) then
         sound("stonetransform");
      end
   end
end

function fit_broken_lines()
   local maxy = 99
   for y,broken in pairs(broken_lines) do
      if (broken == 1) then
         if (y < maxy) then
            maxy = y
         end
      end
   end
   if (maxy ~= 99) then
      broken_lines[maxy] = 0
      for y=maxy-1,1,-1 do
         dmap[y+1] = dmap[y]
      end
      dmap[1] = strrep("-",dfieldw)
   else
      broken_lines = {}
   end
end

function stone_done(init)
   if (init==0) then
      remove_stone(pmap,next_s.x,next_s.y,next_s.stone)
      curr_s = next_s
      curr_s.x = random(1,dfieldw-stonexsize[curr_s.stone]+1)
      curr_s.y = 2-stoneysize[curr_s.stone]
   end
   local nr = random(1,stonenum)
   next_s = { x=showx[stonexsize[nr]], y=showy[stoneysize[nr]], stone=nr,face=random(1,stonefacenum)}
   check_breakouts()
   insert_stone(pmap,next_s.x,next_s.y,next_s.stone,next_s.face)
   draw_map(pfieldx,pfieldy,pmap,dcells)
end

game_over = 0 -- end of game flag

-- triggerState    player on        perform
--                 trigger?         action?
--       0           NO               NO
--       1           YES              YES
--       2           NO               YES
--       3           YES              YES
--
-- triggerState changes by player:
--       0 -> 1      step onto trigger
--       1 -> 2      leave trigger (but signal stays valid)
--       2 -> 1      step again onto trigger before signal was received
--       3 -> 0      leave trigger after signal has been received
--
-- triggerState changes by tick():
--       0 -> 0      no trigger -> no action
--       1 -> 3      player on trigger, mark signal as received
--       2 -> 0      player already left trigger, nevertheless perform action
--       3 -> 3      player resting on trigger, perform action as long he rests there
--
-- NOTE: odd trigger means:  player is on trigger
--       even trigger means: player is NOT on trigger

triggerState = {}
for x=1,triggers do triggerState[x] = 0 end -- reset triggers

function trigger(which) -- by player
   if     (triggerState[which]==0) then triggerState[which] = 1
   elseif (triggerState[which]==1) then triggerState[which] = 2
   elseif (triggerState[which]==2) then triggerState[which] = 1
   elseif (triggerState[which]==3) then triggerState[which] = 0
   end
end

function readTrigger(which) -- by tick()
   local action = 1
   if     (triggerState[which]==0) then action = 0
   elseif (triggerState[which]==1) then triggerState[which] = 3
   elseif (triggerState[which]==2) then triggerState[which] = 0
   end
   return action
end

function trigger1() trigger(1) end -- move left
function trigger2() trigger(2) end -- move right
function trigger3() trigger(3) end -- turn left
function trigger4() trigger(4) end -- turn right
function trigger5() trigger(5) end -- drop/restart

function end_game()
   if (game_over == 0) then
      game_over = 1
      for key,str in pairs(dmap) do
         dmap[key] = gsub(str,"%d","S")
      end
   end
end

speed = normalspeed
ticker = 0

function game_tick(fall)
   if (game_over == 0) then
      local stop = 0
      if ((curr_s.y + stoneysize[curr_s.stone]-1) >= dfieldh) then
         stop = 1
      else
         remove_stone(dmap,curr_s.x,curr_s.y,curr_s.stone,curr_s.face)
         local lastx,lasty,laststone = curr_s.x,curr_s.y,curr_s.stone
         local next_sound = ""

         -- move/rotate stone
         local user_move = 0
         if (fall == 1) then
            curr_s.y = curr_s.y+1
            if (speed == 1) then
               next_sound = "pickup"
            else
               next_sound = "movebig"
            end
         end
         fit_broken_lines()
         if (speed ~= 1) then
            -- move left
            if ((readTrigger(1) == 1) and (curr_s.x > 1)) then
               curr_s.x = curr_s.x-1
               user_move = 1
               next_sound = "movebig"
            end

            -- move right
            if ((readTrigger(2) == 1) and ((curr_s.x + stonexsize[curr_s.stone]) <= dfieldw)) then
               curr_s.x = curr_s.x+1
               user_move = 1
               next_sound = "movebig"
            end

            local stoneRotated = 0
            -- rotate left
            if (readTrigger(3) == 1) then
               curr_s.stone = curr_s.stone - realstonenum
               if (curr_s.stone < 1) then
                  curr_s.stone = curr_s.stone + stonenum
               end
               stoneRotated = 1
               next_sound = "mirrorturn"
            end

            -- rotate right
            if (readTrigger(4) == 1) then
               curr_s.stone = curr_s.stone + realstonenum
               if (curr_s.stone > stonenum) then
                  curr_s.stone = curr_s.stone - stonenum
               end
               stoneRotated = 1
               next_sound = "mirrorturn"
            end

            -- correct position if stone was rotated
            if (stoneRotated == 1) then
               if ((curr_s.x + stonexsize[curr_s.stone] - 1) > dfieldw) then
                  curr_s.x = dfieldw - (stonexsize[curr_s.stone] - 1)
               end
               user_move = 1
            end

            -- drop
            if (readTrigger(5) == 1) then
               speed = 1
               ticker = 0
            end
         end

         local ok = insert_stone(dmap,curr_s.x,curr_s.y,curr_s.stone,curr_s.face)
         if ((ok == 0) and (user_move == 1)) then
            -- try again with user move skipped
            curr_s.x     = lastx
            curr_s.stone = laststone
            ok = insert_stone(dmap,curr_s.x,curr_s.y,curr_s.stone,curr_s.face)
         end

         if (ok == 0) then -- if error occurred while falling
            curr_s.x,curr_s.y = lastx,lasty
            insert_stone(dmap,curr_s.x,curr_s.y,curr_s.stone,curr_s.face)
            if (curr_s.y <= 1) then -- end of game
               end_game()
            else
               stop = 1
            end
         else
            if (sound ~= "") then
               sound(next_sound)
            end
         end
      end
      if (stop == 1) then
         stone_done(0)
         sound("cloth")
         speed = ceil(normalspeed-(points/3))
         insert_stone(dmap,curr_s.x,curr_s.y,curr_s.stone,curr_s.face)
      end
      draw_map(dfieldx,dfieldy,dmap,dcells)
   else
      if (readTrigger(5) == 1) then -- restart game
         game_over = 0
         points = 0
         show_points()
         local line = strrep("-", dfieldw)
         for y,str in pairs(dmap) do
            dmap[y] = line
         end
         stone_done(0)
         draw_map(dfieldx,dfieldy,dmap,dcells)
      end
   end
end

function tick()
   ticker = ticker+1
   local xmove1 = floor(speed/3)
   local xmove2 = floor(speed/3*2)
   if (ticker == speed) then
      game_tick(1)
      ticker = 0
   else
      if ((ticker == xmove1) or (ticker == xmove2)) then
         game_tick(0)
      end
   end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

rs_create_world(level,cells,floorcell)
stone_done(1)
stone_done(0)













