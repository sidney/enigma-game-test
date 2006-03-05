-- Lissajous, a level for Enigma
-- Copyright (C) 2005/06 Andreas Lochmann
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
enigma.SlopeForce=20
enigma.ElectricForce=30
cells={}
items={}
actors={}
stones={}
actors[" "]=cell{}
stones[" "]=cell{}
cells[" "]=cell{}
items[" "]=cell{}
cells["!"]=cell{floor="fl-space"}
stones["!"]=cell{stone="st-glass3"}
cells["#"]=cell{floor="fl-bumps"}
stones["#"]=cell{parent={{file_oxyd,"b"}}}
function ac_blackball(x,y)
n=""
p=0
f=0
 if (x==2) and (y==6) then
  n="ac2x6"
  p=0
  mf=1,66666666666667
 end
set_actor("ac-blackball",x+0.5,y+0.5,{player=p,name=n,mouseforce=mf})
end
actors["!"]=cell{parent={{ac_blackball}}}
function ac_whiteball_small(x,y)
n=""
p=0
f=0
 if (x==9) and (y==3) then
  n="ac9x3"
  p=0
  mf=1,66666666666667
 end
 if (x==10) and (y==9) then
  n="ac10x9"
  p=0
  mf=1,66666666666667
 end
set_actor("ac-killerball",x+0.5,y+0.5,{player=p,name=n,mouseforce=mf})
end
actors["#"]=cell{parent={{ac_whiteball_small}}}
level={"####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################",
       "####################"}
   acmap={"                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "  !                 ",
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
        "!#                #!",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!#       ##       #!",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!#                #!",
        "!!!!!!!!!!!!!!!!!!!!"}
create_world_by_map(level)
draw_map(0,0,stmap,stones)
draw_map(0,0,itmap,items)
draw_map(0,0,acmap,actors)

TIMER_INTERVAL1 = 0.1
TIMER_INTERVAL2 = 0.1631
LOOP_DURATION = 7.0
TICK_ANGLE1_DELTA = 360.0 * TIMER_INTERVAL1/LOOP_DURATION
TICK_ANGLE2_DELTA = 360.0 * TIMER_INTERVAL2/LOOP_DURATION
RADIUS_X = 8.0
RADIUS_Y = 5.0

angle1 = 90.0
angle2 = 90.0
coord_x = 9.0   -- this is the position of one of the oxyd-stones,
coord_y = 6.0   -- so there won't be fl-space drawn at the beginning
old_x = coord_x
old_y = coord_y

function lissajous1()
    angle1 = mod( angle1 + TICK_ANGLE1_DELTA, 360.0 )
    angle2 = mod( angle2 + TICK_ANGLE2_DELTA, 360.0 )
    old_x = coord_x
    old_y = coord_y
    coord_x = cos(angle1) * RADIUS_X + 10.0
    coord_y = sin(angle2) * RADIUS_Y + 6.5
    coord_x = coord_x - mod( coord_x, 1.0 )
    coord_y = coord_y - mod( coord_y, 1.0 )
    lissajous2()
  -- Initiate the second death-stone by inverting positions
    old_x = 19.0 - old_x
    coord_x = 19.0 - coord_x
    -- lissajous2() -- four was too difficult!
    old_y = 12.0 - old_y
    coord_y = 12.0 - coord_y
    if difficult then
      lissajous2()
    end
    old_x = 19.0 - old_x
    coord_x = 19.0 - coord_x
    -- lissajous2()
  -- restore positions for correct values in the next iteration
    --coord_x = 19.0 - coord_x
    coord_y = 12.0 - coord_y
end

function lissajous2()
    if not((old_x == coord_x) and (old_y == coord_y)) then
      if not(((old_x == 9) or (old_x == 10)) and (old_y == 6)) then
      --  if not(((old_x == 1) or (old_x == 
        set_floor( "fl-space", old_x, old_y )
        kill_stone( old_x, old_y )
      end
      if not(((coord_x == 9) or (coord_x == 10)) and (coord_y == 6)) then
        set_stone( "st-death", coord_x, coord_y )
        set_floor( "fl-abyss", coord_x, coord_y )
      end
    end
end

set_stone( "st-timer", 0, 0,
           {target="lissajous1", action="callback",
            name="timer", interval=0.1} )

enigma.ConserveLevel = FALSE
oxyd_shuffle()






















