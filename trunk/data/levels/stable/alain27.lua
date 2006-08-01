-- Bomb raider, a level for Enigma
-- Copyright (C) 2005 Alain Busser
-- Licensed under GPL v2.0 or above 
-- Modified by Raoul

Require("levels/lib/andreas_itemfreeze.lua")

levelw = 37
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "b"

if difficult then
       fill_floor("fl-ice")
    else
       fill_floor("fl-bluegray")
end

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="*" then
            set_item("it-blackbomb",i-1,line)
            set_itemfreeze(i-1, line)
        elseif c == "f" then
            set_itemfreeze(i-1, line)
        elseif c == "w" then
            set_floor("fl-water", i-1, line)
        elseif c == "s" then
            set_floor("fl-swamp", i-1, line)
        elseif c=="d" then
            set_item("it-dynamite", i-1,line)
        elseif c == "g" then
            set_floor("fl-ice", i-1,line)
            set_stone("st-glass", i-1, line)
        elseif c == "h" then
            set_floor("fl-ice", i-1,line)
            set_item("it-blackbomb",i-1,line)
            set_stone("st-glass", i-1, line)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5, {player=0})
        end
    end    
end

--               0123456789012345678901234567890123456789
renderLine(00 , " gggggggggggggggggggggggggggggggggggg")
renderLine(01 , "g    www  wwww     f w  gw *      f g")
renderLine(02 , "g   www  wwwwww    h f  gw g g g  ffg")
renderLine(03 , "g  www       oww   f w     h g g    g")
renderLine(04 , "g   www  wwwwww    h g  gw g g gh*h*g")
renderLine(05 , "g z  www  wwwwg    g w  hw h g      g")  
renderLine(06 , "g                  f f  gw g *ggghghg")
renderLine(07 , "g   www g    sss   f w  hw      *   g")
renderLine(08 , "g  wwwww    sssss  h g  gwfwf g g g g")
renderLine(09 , "g wwwowww   ssfss  g w  *wwww * h h g")
renderLine(10 , "g  wwwww    sssss  h f  gw  w g g g g")
renderLine(11 , "gd  wwwg     sss   g w  gwwww h   g g")
renderLine(12 , "ggggggggggggggggggggggggggggggggggggg") 
--               0123456789012345678901234567890123456789

--positions to shuffle:
tx={1,18,13,5,26,27,35,23,35}
ty={1,11,3,9,10,10,11,11,1}

pos1=random(8)
repeat
 pos2=random(8)
until pos2~=pos1
repeat
 pos3=random(8)
until (pos3~=pos1 and pos3~=pos2)

for n=1,9 do
 if n==pos1 then
  set_stone("st-fakeoxyd",tx[n],ty[n])
 elseif n==pos2 then
  set_stone("st-fakeoxyd",tx[n],ty[n])
 elseif n==pos3 then
  set_stone("st-fart",tx[n],ty[n])
 else
  oxyd(tx[n],ty[n])
 end
end

oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)
itemfreeze_init(0,0,0.01)
