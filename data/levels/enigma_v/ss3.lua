-- A level for Enigma
-- Name:	Psycho Pushing
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

enigma.ConserveLevel = TRUE
levelw = 39
levelh = 25

create_world(levelw, levelh)
oxyd_default_flavor = "c"  
set_actor("ac-blackball", 2.5,2.5)
draw_border("st-rock1")
fill_floor("fl-rough", 0,0, levelw,levelh)

-- Randsteine verschiebbar
--------------------------------------------------------------------------------------------
   for x=1,7 do
   	y=5*x
	set_stone("st-rock1_move",1,y)
	set_stone("st-rock1_move",37,y)
	set_stone("st-rock1_move",y,1)
	set_stone("st-rock1_move",y,23)	
   end
   
set_item("it-floppy",5,1)
set_item("it-blackbomb",10,1)
set_item("it-magnet",15,1)
if difficult then
            set_item("it-flagblack",20,1)
      else
            set_item("it-umbrella",20,1)
end
set_item("it-sword",25,1)
set_item("it-key_a",30,1)
set_item("it-brush",35,1)
set_item("it-yinyang",5,23)
set_item("it-hammer",10,23)
shogundot3(15,23)
set_item("it-whitebomb",20,23)
set_item("it-tinyhollow",25,23)
set_item("it-spade",30,23)
set_item("it-key_c",35,23)
set_item("it-tinyhill",37,5)
document(37,10,"If I only had a bag")
set_item("it-hollow",37,15)
set_item("it-crack3",37,20)
set_item("it-hill",1,5)
set_item("it-springboard",1,10)
set_item("it-key_b",1,15)
set_item("it-extralife",1,20)

-- Einzelrahmen
--------------------------------------------------------------------------------------------
-- Definition eines Rahmens
function draw_border_SS(name,xx0,yy0,w,h)
draw_stones (name,{xx0,yy0}, {1,0},w)   
draw_stones (name,{xx0,(yy0+h-1)}, {1,0},w)
draw_stones (name,{xx0,yy0}, {0,1},h)   
draw_stones (name,{(xx0+w-1),yy0}, {0,1},h)   
end

y0=3
x0=3
draw_border_SS("st-rock1",x0,y0,8,8)
x0=11
x0=20
draw_border_SS("st-rock1",x0,y0,8,8)
x0=28
draw_border_SS("st-rock1",x0,y0,8,8)

y0=14
x0=3
draw_border_SS("st-rock1",x0,y0,8,8)
x0=11
draw_border_SS("st-death",x0,y0,8,8)
x0=20
draw_border_SS("st-rock1",x0,y0,8,8)
x0=28
draw_border_SS("st-rock1",x0,y0,8,8)

-----------------------------------------------------------------------------------------

-- Box 1
y0=3
x0=3
set_stone("st-bolder-s", x0+4,y0-2, {name="startbolder"}) 
fakeoxyd(x0+4,y0-1)
set_stone("st-switch", 0, 14, {action="callback", target="start"})

function start()
        kill_stone(7,2) --blocker weg
end

kill_stone(x0+4,y0)
draw_items("it-seed",{x0+4,y0}, {0,1},2)
set_stone("st-rock1",x0+3,y0+3)
draw_stones("st-rock1",{x0+4,y0+6}, {1,0},3)
draw_stones("st-rock1",{x0+1,y0+4}, {0,1},3)
set_stone("st-rock1",x0+4,y0+4)
draw_stones("st-rock1",{x0+6,y0+1}, {0,1},3)

set_stone("st-wood",x0+2,y0+2)
set_stone("st-wood",x0+5,y0+3)
set_stone("st-wood",x0+2,y0+5)
oxyd(x0+5,y0+1)

document(x0+6,y0+5,"shh...listen!")

set_item("it-trigger", x0+3,y0+1, {invisible=1,action="callback", target="box1trig1"})
set_item("it-trigger", x0+3,y0+2, {invisible=1,action="callback", target="box1trig2"})
set_item("it-trigger", x0+4,y0+2, {invisible=1,action="callback", target="box1trig3"})

-- Ansrechbar als door1
local door1 = set_stone("st-door-v", x0+7, y0+5)

-- Ansprechbar als switchesbox1
local switchesbox1={0, 0, 0}
doorsopenbox1=0

function box1trig1 () triggerbox1(1) end 
function box1trig2 () triggerbox1(2) end 
function box1trig3 () triggerbox1(3) end 

function triggerbox1(num)
   switchesbox1[num] = 1-switchesbox1[num]
   allbox1=1
   for x=1,3 do
      if (switchesbox1[x]==0) then
         allbox1 = 0
      end
   end
   if (doorsopenbox1==0 and allbox1==1) then
      SendMessage(door1, "open")
      doorsopenbox1 = 1
   elseif (doorsopenbox1==1 and allbox1==0) then
      SendMessage(door1, "close")
      doorsopenbox1 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=3
x0=11
-- Box 2
fill_stones("st-rock1",x0,y0,8,2)
fill_stones("st-rock1",x0,y0,2,5)
fill_stones("st-rock1",x0+6,y0,2,8)
enigma.KillStone(x0+4, y0)
enigma.KillStone(x0+4, y0+1)
draw_stones("st-rock1",{x0,y0+7}, {1,0},8 )
draw_floor("fl-water",{x0+4,y0}, {0,1},2 )
set_floor("fl-water",x0,y0+6)
set_floor("fl-water",x0+4,y0+3)

set_stone("st-thief",x0+1,y0+1)
set_stone("st-thief",x0+2,y0+1)
oxyd(x0,y0+2)
enigma.KillStone(x0+1, y0+2)
set_stone("st-thief",x0+1,y0+3)
set_stone("st-thief",x0+2,y0+3)
set_stone("st-rock1",x0+2,y0+4)

set_item("it-magicwand",x0+3,y0+3)

set_stone("st-wood",x0+3,y0+5)
set_stone("st-wood",x0+4,y0+5)
set_stone("st-wood",x0+4,y0+6)

set_item("it-trigger", x0+5,y0+3, {action="callback", target="box2trig1"})
set_item("it-trigger", x0+5,y0+4, {action="callback", target="box2trig2"})
set_item("it-trigger", x0+3,y0+6, {action="callback", target="box2trig3"})

local switchesbox2={0, 0, 0}
doorsopenbox2=0

function box2trig1 () triggerbox2(1) end 
function box2trig2 () triggerbox2(2) end 
function box2trig3 () triggerbox2(3) end 

function triggerbox2(num)
   switchesbox2[num] = 1-switchesbox2[num]
   allbox2=1
   for x=1,3 do
      if (switchesbox2[x]==0) then
         allbox2 = 0
      end
   end
   if (doorsopenbox2==0 and allbox2==1) then
      draw_floor("fl-wood",{15,3}, {0,1},2 )  -- feste Koordinaten
      doorsopenbox2 = 1
   elseif (doorsopenbox2==1 and allbox2==0) then
      draw_floor("fl-water",{15,3}, {0,1},2 )  -- feste Koordinaten
      doorsopenbox2 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=3
x0=20
-- Box 3
fill_stones("st-rock1",x0+1,y0+1,2,3)
fill_stones("st-rock1",x0+5,y0+1,2,2)
draw_stones("st-rock1",{x0+1,y0+6}, {1,0},3)
set_stone("st-rock1",x0+4,y0+4)
set_stone("st-door",x0+3,y0,{name="door3", type="h"})
set_stone("st-coinslot",x0+2,y0,{action="openclose", target="door3"})

oxyd(x0+1,y0+3)

set_stone("st-wood",x0+3,y0+4)
set_stone("st-wood",x0+4,y0+5)
set_stone("st-wood",x0+5,y0+5)

set_stone("st-bolder-e", x0+11,y0+5, {name="bolder1"}) -- in Box4
set_stone("st-blocker", x0+7,y0+5, {name="blocker2"})
set_stone("st-blocker", x0+8,y0+5, {name="blocker3"})

set_item("it-trigger", x0+4,y0+3, {action="callback", target="box3trig1"})
set_item("it-trigger", x0+5,y0+3, {action="callback", target="box3trig2"})
set_item("it-trigger", x0+3,y0+5, {action="callback", target="box3trig3"})

local switchesbox3={0, 0, 0}
doorsopenbox3=0

function box3trig1 () triggerbox3(1) end 
function box3trig2 () triggerbox3(2) end 
function box3trig3 () triggerbox3(3) end 

function triggerbox3(num)
   switchesbox3[num] = 1-switchesbox3[num]
   allbox3=1
   for x=1,3 do
      if (switchesbox3[x]==0) then
         allbox3 = 0
      end
   end
   if (doorsopenbox3==0 and allbox3==1) then
      SendMessage("bolder1", "direction", WEST)
      doorsopenbox3 = 1
   elseif (doorsopenbox3==1 and allbox3==0) then
      SendMessage("bolder1", "direction", EAST)
      doorsopenbox3 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=3
x0=28
-- Box 4
draw_stones("st-rock1",{x0+1,y0+1}, {1,0},2 )
draw_stones("st-rock1",{x0+6,y0+1}, {0,1},6 )
set_stone("st-rock1",x0+4,y0+2)
set_stone("st-rock1",x0+3,y0+4)
set_stone("st-rock1",x0+4,y0+6)
set_stone("st-bombs",x0+5,y0+5)
set_stone("st-bombs",x0+5,y0+6)
set_stone("st-bombs",x0+5,y0+7)
set_stone("st-grate2",x0+4,y0+5)

draw_stones("st-wood",{x0+2,y0+2}, {0,1},2 )
set_stone("st-wood",x0+3,y0+3)
oxyd(x0+6,y0+5)
bomb1 = set_item("it-blackbomb",x0+4,y0+5)
--draw_items("it-blackbomb",{x0+5,y0+5}, {0,1},3)

set_item("it-trigger", x0+5,y0+1, {action="callback", target="box4trig1"})
set_item("it-trigger", x0+4,y0+4, {action="callback", target="box4trig2"})
set_item("it-trigger", x0+2,y0+3, {action="callback", target="box4trig3"})
set_item("it-trigger", x0+2,y0+4, {action="callback", target="box4trig4"})

local switchesbox4={0, 0, 0, 0}
exploded=0

function box4trig1 () triggerbox4(1) end 
function box4trig2 () triggerbox4(2) end 
function box4trig3 () triggerbox4(3) end    
function box4trig4 () triggerbox4(4) end 

function triggerbox4(num)
   switchesbox4[num] = 1-switchesbox4[num]
   allbox4=1
   for x=1,4 do
      if (switchesbox4[x]==0) then
         allbox4 = 0
      end
   end
   if (allbox4==1 and exploded==0) then
      SendMessage(bomb1, "explode")
      exploded=1
   end
end
-----------------------------------------------------------------------------------------
y0=14
x0=3
-- Box 5
enigma.KillStone(x0+3, y0)
set_stone("st-key_a",x0+2,y0, {action="openclose", target="door4"})
doorh( x0+3,y0, {name="door4"})
draw_stones("st-rock1",{x0+3,y0+3}, {0,1},4 )
draw_stones("st-rock1",{x0+6,y0+1}, {0,1},3 )
set_stone("st-rock1",x0+1,y0+1)
set_stone("st-rock1",x0+5,y0+5)

draw_stones("st-wood",{x0+2,y0+2}, {1,0},3 )
set_stone("st-wood",x0+1,y0+5)

set_stone("st-rock1_move",x0+2,y0+5)
set_item("it-coin1", x0+2,y0+5)
set_item("it-wormhole", x0+1,y0+5, {name="warp1",targetx="4.5", targety="18.5",strength=5})

oxyd(x0+3,y0+5)

set_item("it-trigger", x0+3,y0+1, {action="callback", target="box5trig1"})
set_item("it-trigger", x0+6,y0+4, {action="callback", target="box5trig2"})
set_item("it-trigger", x0+4,y0+2, {action="callback", target="box5trig3"})

local switchesbox5={0, 0, 0}
doorsopenbox5=0

function box5trig1 () triggerbox5(1) end 
function box5trig2 () triggerbox5(2) end 
function box5trig3 () triggerbox5(3) end 

function triggerbox5(num)
   switchesbox5[num] = 1-switchesbox5[num]
   allbox5=1
   for x=1,3 do
      if (switchesbox5[x]==0) then
         allbox5 = 0
      end
   end
   if (doorsopenbox5==0 and allbox5==1) then
      set_attribs(enigma.GetNamedObject("warp1"), {targetx="12.5", targety="19.5",strength=0})   
      doorsopenbox5 = 1
   elseif (doorsopenbox5==1 and allbox5==0) then
	set_attribs(enigma.GetNamedObject("warp1"), {targetx="4.5", targety="18.5",strength=5})
      doorsopenbox5 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=14
x0=11
-- Box 6
enigma.KillStone(x0+5, y0)
oxyd(x0,y0+4)
local laser1 = laser(x0+6,y0+1,TRUE,WEST)
draw_stones("st-death",{x0+4,y0+2}, {1,0},3 )
draw_stones("st-death",{x0+1,y0+6}, {1,0},4 )
set_stone("st-death",x0+1,y0+2)
set_stone("st-death",x0+2,y0+4)
set_stone("st-death",x0+4,y0+5)

draw_stones("st-wood",{x0+3,y0+3}, {0,1},2 )
set_stone("st-wood",x0+5,y0+4)

set_item("it-trigger", x0+1,y0+3, {action="callback", target="box6trig1"})
set_item("it-trigger", x0+2,y0+3, {action="callback", target="box6trig2"})
set_item("it-trigger", x0+6,y0+3, {action="callback", target="box6trig3"})
set_item("it-extralife", x0+2,y0+5)

-- Ansprechbar als switches
local switchesbox6={0, 0, 0}
doorsopenbox6=0

function box6trig1 () triggerbox6(1) end 
function box6trig2 () triggerbox6(2) end 
function box6trig3 () triggerbox6(3) end 

function triggerbox6(num)
   switchesbox6[num] = 1-switchesbox6[num]
   allbox6=1
   for x=1,3 do
      if (switchesbox6[x]==0) then
         allbox6 = 0
      end
   end
   if (doorsopenbox6==0 and allbox6==1) then
      SendMessage(laser1, "off")
      doorsopenbox6 = 1
   elseif (doorsopenbox6==1 and allbox6==0) then
	SendMessage(laser1, "on")
      doorsopenbox6 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=14
x0=20
-- Box 7
fill_stones("st-glass1",x0+1,y0+1,3,2)
draw_stones("st-glass1",{x0+6,y0+4}, {0,1},3 )
draw_stones("st-glass1",{x0+5,y0+5}, {0,1},2 )
set_stone("st-glass1",x0+6,y0+1)
set_stone("st-glass1",x0+3,y0+3)
set_stone("st-glass1",x0+1,y0+6)

local door2 = set_stone("st-door-v",x0+7,y0+3)

set_stone("st-glass1",x0+4,y0)

set_stone("st-wood",x0+4,y0+3)
set_stone("st-wood",x0+5,y0+3)
set_stone("st-wood",x0+4,y0+5)

kill_stone(x0+5,y0)
set_item("it-crack3", x0+5,y0)
set_stone("st-glass1_hole",x0+5,y0)

oxyd(x0+2,y0+2)

set_item("it-trigger", x0+1,y0+3, {action="callback", target="box7trig1"})
set_item("it-trigger", x0+1,y0+5, {action="callback", target="box7trig2"})
set_item("it-trigger", x0+2,y0+6, {action="callback", target="box7trig3"})         

local switchesbox7={0, 0, 0}
doorsopenbox7=0

function box7trig1 () triggerbox7(1) end 
function box7trig2 () triggerbox7(2) end 
function box7trig3 () triggerbox7(3) end 

function triggerbox7(num)
   switchesbox7[num] = 1-switchesbox7[num]
   allbox7=1
   for x=1,3 do
      if (switchesbox7[x]==0) then
         allbox7 = 0
      end
   end     
   if (doorsopenbox7==0 and allbox7==1) then
      set_stone("st-glass1_hole",24,14)
      SendMessage(door2, "open")
      doorsopenbox7 = 1
   elseif (doorsopenbox7==1 and allbox7==0) then
      set_stone("st-glass1",24,14)
      SendMessage(door2, "close")
      doorsopenbox7 = 0
   end
end
-----------------------------------------------------------------------------------------
y0=14
x0=28
-- Box 8
draw_stones("st-rock1",{x0+1,y0+1}, {1,0},6 )
draw_stones("st-rock1",{x0+1,y0+5}, {1,0},4 )
set_stone("st-rock1",x0+4,y0+6)
set_stone("st-glass",x0+2,y0+3)
set_stone("st-glass",x0+4,y0+3)

kill_stone(x0,y0+3)

set_stone("st-rock1_move",x0+2,y0+4)
set_stone("st-rock1_move",x0+5,y0+4)
set_stone("st-rock1_move",x0+6,y0+5)

set_item("it-trigger", x0+1,y0+2, {action="callback", target="box8trig1"})
set_item("it-trigger", x0+5,y0+2, {action="callback", target="box8trig2"})
set_item("it-trigger", x0+6,y0+4, {action="callback", target="box8trig3"})
set_item("it-trigger", x0,y0+3, {action="callback", target="box8trig4"})

local laser2 = laser(x0+1,y0+6,FALSE,EAST)
oxyd(x0+3,y0+6)

local switchesbox8={0, 0, 0, 0}
doorsopenbox8=0

function box8trig1 () triggerbox8(1) end 
function box8trig2 () triggerbox8(2) end 
function box8trig3 () triggerbox8(3) end 
function box8trig4 () triggerbox8(4) end 

function triggerbox8(num)
   switchesbox8[num] = 1-switchesbox8[num]
   allbox8=1
   for x=1,4 do
      if (switchesbox8[x]==0) then
         allbox8 = 0
      end
   end
   if (doorsopenbox8==0 and allbox8==1) then
      SendMessage(laser2, "on")
      doorsopenbox8 = 1
   elseif (doorsopenbox8==1 and allbox8==0) then
      SendMessage(laser2, "off")
      doorsopenbox8 = 0
   end
end

oxyd_shuffle()















