--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 39
levelh = 25

create_world(levelw, levelh)
draw_border("st-invisible")
enigma.ConserveLevel = FALSE
oxyd_default_flavor = "a"
fill_floor("fl-normal")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="#" then
         fill_floor("fl-abyss", i-1,line, 1,1)
      elseif c == "o" then
         oxyd( i-1, line)
      elseif c == "?" then
         set_floor("fl-gradient",  i-1,  line, {type=24})
      elseif c == "!" then
         set_floor("fl-gradient",  i-1,  line, {type=23})
      elseif c == "0" then
         set_floor("fl-gradient",  i-1,  line, {type=21})
      elseif c == "3" then
         set_floor("fl-gradient",  i-1,  line, {type=3})
      elseif c == "1" then
         set_floor("fl-gradient",  i-1,  line, {type=1})
      elseif c == "2" then
         set_floor("fl-gradient",  i-1,  line, {type=2})
      elseif c == "4" then
         set_floor("fl-gradient",  i-1,  line, {type=4})
      elseif c == "9" then
         set_floor("fl-gradient",  i-1,  line, {type=22})
      elseif c == "5" then
         set_floor("fl-gradient",  i-1,  line, {type=5})
      elseif c == "6" then
         set_floor("fl-gradient",  i-1,  line, {type=6})
      elseif c == "7" then
         set_floor("fl-gradient",  i-1,  line, {type=7})
      elseif c == "8" then
         set_floor("fl-gradient",  i-1,  line, {type=8})
      elseif c == "r" then
         set_stone("st-rock4",i-1,line)
      elseif c == "g" then
         set_stone("st-grate2",i-1,line)
      elseif c == "z" then
         set_actor("ac-blackball", i-.5,line+.5)
      elseif c == "b" then
         set_stone("st-stone_break",i-1,line)
      elseif c == "w" then
         set_stone("st-wood",i-1,line)
      elseif c == "v" then
         set_stone("st-break_invisible",i-1,line)
      elseif c == "y" then
         set_stone("st-stonebrush",i-1,line)
      elseif c=="h" then
         set_item("it-hammer",i-1,line)
      elseif c=="x" then
         set_item("it-brush",i-1,line)
      elseif c=="l" then
         set_stone("st-oneway-s", i-1,line)
      elseif c=="m" then
         set_stone("st-oneway-n", i-1,line)
      elseif c=="n" then
         set_stone("st-oneway-e", i-1,line)
      elseif c=="p" then
         set_stone("st-oneway-w", i-1,line)
        end
    end
end

renderLine(00, "511111111111111111111111111111111111116")
renderLine(01, "3 ??????????????????????????????????? 4")
renderLine(02, "30rmrmrrrmrrrrrmrrrrrmrrmrrrrrrrrrrrr94")
renderLine(03, "30r r r r     r   r   r w w rr   yy r94")
renderLine(04, "30r r r   rrrrrrr r rrrw b b r  yvvvr94")
renderLine(05, "30r     r   r     r r v w w wr yyvvyr94")
renderLine(06, "30rrrrr ror   r r r rrrr whw ryvoyvyr94")
renderLine(07, "30rbbbb rrrrrrror r    rw w wryvyyvyr94")
renderLine(08, "30rbrrr r  gg rrrrrrrr r w w ryvvvvyr94")
renderLine(09, "30rbbrb    rr r      r rw w wryyyyyyr94")
renderLine(10, "30rrrrrrrr gg r rr z r rrrrrrrrrrrrrr94")
renderLine(11, "30r      r rr r  r   r #############r94")
renderLine(12, "30rrrrrr r gg rr rrrrr    ##  ###  xr94")
renderLine(13, "30ro r   r rr r        #############r94")
renderLine(14, "30rr r r r gg r #####  rrrrrrrrrrrrrr94")
renderLine(15, "30r  r r r rr r ##r##           r   r94")
renderLine(16, "30r  r r r gg r #####  rrrrrrr rr r r94")
renderLine(17, "30rr r r r rr r                   r r94")
renderLine(18, "30p    r r gg r yyy yyvyvy yyy rrrr r94")
renderLine(19, "30r rr r r rr r yoy yovyoy yoy    r n94")
renderLine(20, "30r  r r r gg r yvy yyvyyy yvy r  rrr94")
renderLine(21, "30r  r   r rr r                r    r94")
renderLine(22, "30rrlrrrrrlrrlrrrrrrrrlrrrlrrrrrrrlrr94")
renderLine(23, "3 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 4")
renderLine(24, "722222222222222222222222222222222222228")

oxyd_shuffle()

SetDefaultAttribs("it-wormhole", {range=1.0, strength=10})

set_item("it-wormhole", 1, 1, {targetx="19.5",targety="10.5"})
set_item("it-wormhole", 1,23, {targetx="24.5",targety="8.5"})
set_item("it-wormhole",21, 5, {targetx="35.5",targety="3.5"})
set_item("it-wormhole",37, 1, {targetx="13.5",targety="16.5"})
set_item("it-wormhole",37,23, {targetx="8.5",targety="18.5"})

display.SetFollowMode(display.FOLLOW_SCROLLING)

set_item("it-trigger",10,10, {invisible=1, action="close", target="door1"})
set_item("it-trigger",13,14, {invisible=1, action="close", target="door1"})
set_item("it-trigger",13,16, {invisible=1, action="close", target="door1"})
set_item("it-trigger",10,10, {invisible=1, action="close", target="door1"})
set_item("it-trigger",13,18, {invisible=1, action="open", target="door1"})
set_stone("st-door_a", 8, 9, {name="door1"})

set_item("it-trigger",15, 9, {invisible=1, action="open", target="door2"})
set_item("it-trigger",16,11, {invisible=1, action="close", target="door2"})
set_stone("st-door_a",15,10, {name="door2"})

set_item("it-spring1", 4, 9)

document(35, 3, "press F3 or finish")
