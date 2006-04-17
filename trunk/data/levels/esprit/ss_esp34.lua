-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

-- ESPRIT #034

-- problem: here is a spermbird needed (more intelligent killer)


-- Apr.'06: Changed actor into ghost.  Andreas

Require("levels/lib/andreas_ghosts.lua")


whichside = 1
ontheright = 0

function mydirection(rail,posx,posy,oldx,oldy)
  -- next time, go to the other side; also change range of rotor
  if posx > levelw - 20 then
    if ontheright == 0 then
      set_attribs(enigma.GetNamedObject("ghost_1"), {range=5})
    end
    ontheright = 1
  else
    if ontheright == 1 then
      set_attribs(enigma.GetNamedObject("ghost_1"), {range=0})
      whichside = 3 - whichside   -- switches between 1 and 2
    end
    ontheright = 0
  end
  -- choose speed
  if (posy == 2) or (posy == 10) then
        if (posx < 12) then          enigma.SlopeForce = 8
    elseif (posx < 18) then          enigma.SlopeForce = -50
    elseif (posx > levelw - 5) then  enigma.SlopeForce = 10
    else                             enigma.SlopeForce = 400  end
  elseif (posy == 4) or (posy == 8) then
        if (posx < 5) then           enigma.SlopeForce = 8
    elseif (posx > levelw - 15) then enigma.SlopeForce = 8    
    elseif (posx > levelw - 20) then enigma.SlopeForce = -50
    else                             enigma.SlopeForce = 400  end
  end
  -- choose direction
      if (posx == 1) and (posy ==  2) then  return 2
  elseif (posx == 1) and (posy ==  3) then  return 2
  elseif (posx == 1) and (posy ==  9) then  return 1
  elseif (posx == 1) and (posy == 10) then  return 1
  elseif (posy == 2) or (posy == 10)  then  return 3
  elseif (posx == levelw - 3)         then  return whichside
  else                                      return 4  end
end



levelw = 191

levelh = 13

create_world(levelw, levelh)

oxyd_default_flavor = "d"

set_actor("ac-blackball", 3.5,6.5)

--set_actor("ac-rotor", 188.5,3.5, {range=200, force=60})

ghosts_set_ghost(levelw-3,6,"ac-rotor",1,mydirection,
              {range=5, force=30, gohome=FALSE})
fill_floor("fl-brick",0,0,levelw,levelh)

ghosts_set_railarea( 1, 2, levelw-3, 2,          1,"")
ghosts_set_railarea( 1, 4, levelw-3, 4,          1,"")
ghosts_set_railarea( 1, 8, levelw-3, 8,          1,"")
ghosts_set_railarea( 1,10, levelw-3,10,          1,"")
ghosts_set_railarea( levelw-3, 2, levelw-3, 10,  1,"")
ghosts_set_rail    ( 1, 3,                       1,"")
ghosts_set_rail    ( 1, 9,                       1,"")

ghosts_check_for_walls = 0


enigma.SlopeForce=30

draw_border("st-rock1")

draw_stones("st-rock1", { 1, 1},{ 1, 0},189)

draw_stones("st-rock1", { 1, 11},{ 1, 0},189)

draw_stones("st-rock1", { 3, 3},{ 1, 0},181)

draw_stones("st-rock1", { 3, 9},{ 1, 0},181)

draw_stones("st-rock1", { 1, 5},{ 1, 0},187)

draw_stones("st-rock1", { 1, 7},{ 1, 0},187)

set_stones("st-rock1",{{184,3},{184,9}})

set_stones("st-oneway-e",{{184,4},{184,8},{187,6}})

set_stones("st-oneway-s",{{1,3},{183,5}})

set_stones("st-oneway-n",{{1,9},{183,7}})

oxyd(0,6)

oxyd(2,3)

oxyd(2,9)

oxyd(189,6)

oxyd_shuffle()

ghosts_init(0,0)

