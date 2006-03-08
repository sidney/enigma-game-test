--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 25

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "d"
fill_floor("fl-rough")
SetDefaultAttribs("it-wormhole", {range = 1.0, strength = 10})

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "b" then
         set_stone("st-break_bolder",i-1,line)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "g" then
         set_stone("st-grate1",i-1,line)
      elseif c == "x" then
         set_stone("st-blocker",i-1,line)
      elseif c == "r" then
         set_stone("st-stone1",i-1,line)
      elseif c == "i" then
         set_stone("st-stoneimpulse",i-1,line)
      elseif c == "y" then
         set_stone("st-brake",i-1,line)
      elseif c == "w" then
         set_floor("fl-water",i-1,line)
      elseif c == "s" then
         set_stone("st-swap",i-1,line)
      elseif c == "L" then
         set_stone("st-rotator_move-left",i-1,line)
      elseif c == "R" then
         set_stone("st-rotator_move-right",i-1,line)
      elseif c == "B" then
         set_stone("st-bolder-n", i-1,line)
      elseif c == "E" then
         set_stone("st-oneway-e",i-1,line)
      elseif c == "1" then
         set_stone("st-timeswitch",i-1,line, {action="openclose", target="door1"})
      elseif c == "2" then
--         set_stone("st-door",i-1,line, {name="door1",  type="h"})
         set_stone("st-door_a",i-1,line, {name="door1",  type="h"})
      elseif c == "3" then
         set_stone("st-timeswitch",i-1,line, {action="openclose", target="door2"})
      elseif c == "4" then
--         set_stone("st-door",i-1,line, {name="door2",  type="h"})
         set_stone("st-door_a",i-1,line, {name="door2",  type="h"})
      elseif c == "5" then
         set_stone("st-timeswitch",i-1,line, {action="openclose", target="door3"})
      elseif c == "6" then
--         set_stone("st-door",i-1,line, {name="door3",  type="h"})
         set_stone("st-door_a",i-1,line, {name="door3",  type="h"})
      elseif c == "z" then
         set_item("it-wrench",i-1,line)
      elseif c == "f" then
         set_item("it-flagblack",i-1,line)
      elseif c == "W" then
         set_item("it-wormhole",i-1,line, {targetx=" 1.5",targety="20.5"})
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
        end
    end
end
--              01234567890123456789
renderLine(00, "rrrrrrrrrrrrrrrrrrrr")
renderLine(01, "rrR     R          r")
renderLine(02, "rR                 r")
renderLine(03, "r      rxrr        r")
renderLine(04, "rrxrrrrrzar        r")
renderLine(05, "r    Wryfsrrrrr    r")
renderLine(06, "r b   rggxggggr    r")
renderLine(07, "r b   rgsrrRrgr    r")
renderLine(08, "r b   rgR   rgr    r")
renderLine(09, "r b   rgr rBrgr    r")
renderLine(10, "r b   rgr   Rgr    r")
renderLine(11, "r b   rgrRrrrgr    r")
renderLine(12, "r b   rgggggggr    r")
renderLine(13, "r b   rrrrrrrrr    r")
renderLine(14, "r b   r            r")
renderLine(15, "r b   r            r")
renderLine(16, "r b   r            r")
renderLine(17, "r   rrr            r")
renderLine(18, "r   riiiiiiiiiiiiiii")
renderLine(19, "r         i     i  i")
renderLine(20, "r L iiii1 iiiii E  i")
renderLine(21, "rwwwi     i   i6i ri")
renderLine(22, "rwwwi23iiii45 i rosi")
renderLine(23, "rwowi       i   i ri")
renderLine(24, "rrrriiiiiiiiiiiiiiii")
--              01234567890123456789










