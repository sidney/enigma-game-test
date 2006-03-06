-- The Flagstone Reaper, a level for Enigma
-- Copyright (C) 2005 Andreas Lochmann
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
--display.DefineAlias("st-fourswitch", "st-likeoxydc")
cells={}
items={}
actors={}
stones={}
actors[" "]=cell{}
stones[" "]=cell{}
cells[" "]=cell{}
items[" "]=cell{}
cells["!"]=cell{floor="fl-brick"}
stones["!"]=cell{stone="st-rock6"}
cells["#"]=cell{floor="fl-normal"}
stones["#"]=cell{stone="st-switch"}
stones["$"]=cell{stone="st-fourswitch"}
function ac_blackball(x,y)
n=""
p=0
f=0
 if (x==4) and (y==9) then
  n="ac4x9"
  p=0
  mf=1
 end
set_actor("ac-blackball",x+0.5,y+0.5,{player=p,name=n,mouseforce=mf})
end
actors["!"]=cell{parent={{ac_blackball}}}
stones["%"]=cell{stone="st-black4"}
stones["&"]=cell{stone="st-laser-s"}
stones["k"]=cell{stone="st-knight"}
stones["b"]=cell{stone="st-break_acblack"}
stones["m"]=cell{stone="st-brick_magic"}
stones["*"]=cell{parent={{file_oxyd,"a"}}}
cells["$"]=cell{floor="fl-abyss"}
level={"!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!$!",
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
          "                    ",
          "                    ",
          "                    ",
          "    !               ",
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
 stmap={"!!!!!!!!!!!!!!!!!&&!",
        "!               %  #",
        "!               !bm!",
        "!               !kb!",
        "!               !bm!",
        "!               !kb!",
        "!               !bm!",
        "!               !kb!",
        "!               !bm!",
        "!               !kb!",
        "!               !bm!",
        "!               !**!",
        "!!!!!!!!!!!!!!!!!!!!"}
create_world_by_map(level)
draw_map(0,0,stmap,stones)
draw_map(0,0,itmap,items)
draw_map(0,0,acmap,actors)
randomseed( enigma.GetTicks() )

colour = {}
uhrlaeuft = 1.0
richtung = 1.0
posx = 1.0
posy = 1.0
zerstoert = 0.0
--if difficult then
  TIMERINT = 0.8
--else
--  TIMERINT = 1.2
--end

function timercallback()
  if (uhrlaeuft == 1.0) and (zerstoert == 0.0) then
    kill_stone(posx, posy)
    teilchen = enigma.GetItem(posx, posy)
    if not(teilchen == nil) then
      if colour[posx*20 + posy] == 2 then
        set_item("it-magicwand", posx, posy)
      end
      if colour[posx*20 + posy] == 3 then
        set_item("it-umbrella", posx, posy)
      end
      if colour[posx*20 + posy] == 4 then
        set_item("it-sword", posx, posy)
      end
      if colour[posx*20 + posy] == 5 then
        set_item("it-hammer", posx, posy)
      end
      if colour[posx*20 + posy] == 6 then
        set_item("it-pin", posx, posy)
      end
    end
    if colour[posx*20 + posy] == 1.0 then
      abyss(posx,posy)
      colour[posx*20 + posy] = 0.0
    else
      if colour[posx*20 + posy] > 0.0 then
        set_floor("fl-floor_001",posx,posy)
        colour[posx*20 + posy] = 1.0
      end
    end
    if difficult and (random(1,4) == 1) then      
      richtung = richtung + 2*random(1,2) - 3
      if richtung == 0 then richtung = 4.0 end
    end
    if richtung == 1.0 then  posy = posy - 1  end
    if richtung == 2.0 then  posx = posx + 1  end
    if richtung == 3.0 then  posy = posy + 1  end
    if richtung == 4.0 then  posx = posx - 1  end
    if posx > 15 then posx = 15  end
    if posx < 1 then posx = 1  end
    if posy > 11 then posy = 11  end
    if posy < 1 then posy = 1  end
    set_stone("st-fourswitch",posx,posy, {action="callback", target="hitclock"})
    mir = enigma.GetStone(posx,posy)
    richtung2=richtung
    richtung=1
    for j=1,richtung2+3 do
      SendMessage(mir, "trigger")
    end
  end
end
function hitclock()
  richtung = richtung + 1.0
  if richtung == 5.0 then
    richtung = 1.0
  end
end

for j=0,12 do
  for i=0,19 do
    random_number = random(1,5)
    if random_number == 1 then  set_floor("fl-sahara",   i, j)  end
    if random_number == 2 then  set_floor("fl-red",      i, j)  end
    if random_number == 3 then  set_floor("fl-bluegray", i, j)  end
    if random_number == 4 then  set_floor("fl-tigris",   i, j)  end    
    if random_number == 5 then  set_floor("fl-gray",     i, j)  end    
    colour[i*20 + j] = random_number + 1
  end
  abyss(18,j)
end

set_item("it-document", 17, 1, {text="No hint today...    Those flagstones pass away...    The docu stands alone...    Why is it so alone?    --    This hint today...    Why is it on this side...    The reaper passing by...    Could know the reason why!     (orig.by Herman's Hermits)   "})
set_stone("st-timer", 0, 0, {action="callback", target="timercallback", interval=TIMERINT} )
set_stone("st-fourswitch",posx,posy, {action="callback", target="hitclock"})

SetAttrib(enigma.GetStone(17,0),"init",FALSE)
SetAttrib(enigma.GetStone(18,0),"init",FALSE)
Signal ("st(19 1)","st(18 0)")
Signal ("st(19 1)","st(17 0)")
oxyd_shuffle()





























