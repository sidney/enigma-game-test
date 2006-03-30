-- Laser Arena, a level for Enigma
-- Copyright (C) 2006 Andreas Lochmann
-- Licensed under GPL v2.0 or above 
-- Created with the help of BBE 1.05

Require("levels/lib/ant.lua")
function file_oxyd(x,y,f)
    oxyd_default_flavor=f
    oxyd(x,y)
end
levelh=13
levelw=20
enigma.FlatForce=30
enigma.SlopeForce=30
enigma.ElectricForce=30
cells={}
items={}
actors={}
stones={}
actors[" "]=cell{}
stones[" "]=cell{}
cells[" "]=cell{}
items[" "]=cell{}
cells["!"]=cell{floor="fl-sand"}
stones["!"]=cell{stone="st-likeoxyda"}
stones["#"]=cell{parent={{file_oxyd,"a"}}}
function ac_blackball(x,y)
n=""
p=0
f=0
 if (x==9) and (y==6) then
  n="ac9x6"
  p=0
  mf=1,66666666666667
 end
set_actor("ac-blackball",x+0.5,y+0.5,{player=p,name=n,mouseforce=mf})
end
actors["!"]=cell{parent={{ac_blackball}}}
level={"!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!"}
   acmap={"                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "         !          ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    "}
  itmap={"                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    "}
 stmap={"!!!!!!!!!!!!!!!!!!!!",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!!!!!!!!!!!!!!!!!!!!"}
create_world_by_map(level)
draw_map(0,0,stmap,stones)
draw_map(0,0,itmap,items)
draw_map(0,0,acmap,actors)

oxydx = {}
oxydy = {}
laserx = {}
lasery = {}
TIMERINT = 1.0
ANZLASER = 3
if difficult then ANZLASER = 5 end

function makelaser(x,y)
  if x == 0 then
    set_stone("st-laser-e", x, y, {on = 1})
  end
  if x == 19 then
    set_stone("st-laser-w", x, y, {on = 1})
  end
  if y == 0 then
    set_stone("st-laser-s", x, y, {on = 1})
  end
  if y == 12 then
    set_stone("st-laser-n", x, y, {on = 1})
  end
end

function nooxyd(x,y)
  nox = 1
  for o = 1,8 do 
    if (oxydx[o] == x) and (oxydy[o] == y) then
      nox = 0
    end
  end
  return nox
end

function timercallback()
  for i = 1,ANZLASER do
    x = laserx[i]
    y = lasery[i]
    if x == 0 then
      lasery[i] = lasery[i] + 1
      if lasery[i] == 12 then laserx[i] = laserx[i] + 1 end
    end
    if x == 19 then
      lasery[i] = lasery[i] - 1
      if lasery[i] == 0 then laserx[i] = laserx[i] - 1 end
    end
    if y == 0 then
      laserx[i] = laserx[i] - 1
      if laserx[i] == 0 then lasery[i] = lasery[i] + 1 end
    end
    if y == 12 then
      laserx[i] = laserx[i] + 1
      if laserx[i] == 19 then lasery[i] = lasery[i] - 1 end
    end
    -- the following didn't work, because lasers happened to disappear!
    --drawit = 1
    --for j = 1,8 do
    --  if(oxydx[j] == x) and (oxydy[j] == y) then  drawit = 0  end
    --end
    --if drawit == 1 then
    --  set_stone("st-likeoxyda", x, y)
    --end
    --drawit = 1
    --for j = 1,8 do
    --  if(oxydx[j] == laserx[i]) and (oxydy[j] == lasery[i]) then  drawit = 0  end
    --end
    --if drawit == 1 then
    --  makelaser(laserx[i], lasery[i])
    --end
  end
  for x = 1,18 do  if nooxyd(x, 0) == 1 then  set_stone("st-likeoxyda", x, 0)  end end
  for x = 1,18 do  if nooxyd(x,12) == 1 then  set_stone("st-likeoxyda", x,12)  end end
  for y = 1,11 do  if nooxyd(0, y) == 1 then  set_stone("st-likeoxyda", 0, y)  end end
  for y = 1,11 do  if nooxyd(19,y) == 1 then  set_stone("st-likeoxyda", 19,y)  end end
  for j = 1,ANZLASER do  if nooxyd(laserx[j], lasery[j]) == 1 then
    makelaser(laserx[j], lasery[j])
  end end
end

-- 1. Set the Timer Stone

set_stone("st-timer", 10, 6, {action="callback", target="timercallback", interval=TIMERINT} )

-- 2. Set 8 Oxyd Stones

for i = 1,8 do
  oxydx[i] = 0
  oxydy[i] = 0
end
for c = 1,100 do  -- We try 100 times. This should be enough (in most cases).
  if oxydx[1] == oxydx[2] then
    oxydx[1] = random(2,17)
    oxydx[2] = random(2,17)
    oxydy[1] = 0
    oxydy[2] = 0
  end
end
for c = 1,100 do
  if oxydx[3] == oxydx[4] then
    --oxydx[3] = random(2,17)
    oxydx[3] = oxydx[1]
    oxydx[4] = random(2,17)
    oxydy[3] = 12
    oxydy[4] = 12
  end
end
for c = 1,100 do
  if oxydy[5] == oxydy[6] then
    oxydy[5] = random(2,10)
    oxydy[6] = random(2,10)
    oxydx[5] = 0
    oxydx[6] = 0
  end
end
for c = 1,100 do
  if oxydy[7] == oxydy[8] then
    --oxydy[7] = random(2,10)
    oxydy[7] = oxydy[5]
    oxydy[8] = random(2,10)
    oxydx[7] = 19
    oxydx[8] = 19
  end
end

-- 3. Set ANZLASER lasers

for i = 1,ANZLASER do
  laserx[i] = 0
  lasery[i] = 0
  for c = 1,100 do   -- again, we try to find a good configuration up to 100 times.
    if laserx[i] == lasery[i] then
      -- In this part we calculate a random laser position on the boundary,
      laserx[i] = random(1,18)
      lasery[i] = random(1,11)
      r = random(1,6)
      if r <  3  then  lasery[i] = 0   end
      if r == 3  then  laserx[i] = 0   end
      if r == 4  then  laserx[i] = 19  end
      if r  > 4  then  lasery[i] = 12  end
      -- but it shouldn't coincide with an oxyd stone,
      for j = 1, 8 do
        if(laserx[i] == oxydx[j]) and (lasery[i] == oxydy[j]) then
          laserx[i] = 0
          lasery[i] = 0
        end
      end
      -- not with another laser,
      for j = 1, i-1 do
        if(laserx[i] == laserx[j]) and (lasery[i] == lasery[j]) then
          laserx[i] = 0
          lasery[i] = 0
        end
      end      
      -- and not with the marble starting place!
      if(laserx[i] == 9) or (lasery[i] == 6) then
        laserx[i] = 0
        lasery[i] = 0
      end
      -- dont say we used all the 100 times?
      if(c == 100) then
        set_stone("st-rock4", 0, 0)
      end
    end
  end  
end

-- Now draw them!

oxyd_default_flavor = "a"
for i = 1,8 do
  oxyd(oxydx[i], oxydy[i])
end
for i = 1,ANZLASER do
  makelaser(laserx[i], lasery[i])
end


oxyd_shuffle()
enigma.ConserveLevel = FALSE























