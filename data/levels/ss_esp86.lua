-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #086

levelw = 20
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "c"
enigma.SlopeForce = 90
set_actor("ac-blackball", 10,5)
set_actor("ac-top", 10,10.5, {range=100, force=100})
fill_floor("fl-leaves",0,0,levelw,7)
fill_floor("fl-abyss",0,7,levelw,6)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-plain", i-1,line)
      elseif c=="b" then
         set_stone("st-actorimpulse", i-1,line) 
      elseif c=="x" then
         set_stone("st-door_c", i-1,line, {name="s1"})
      elseif c=="y" then
         set_stone("st-door_c", i-1,line, {name="s2"})
      elseif c=="1" then
         set_stone("st-switch", i-1,line, {action="callback", target="s1"}) 
      elseif c=="2" then
         set_stone("st-switch", i-1,line, {action="callback", target="s2"}) 
      elseif c=="g" then
         set_floor("fl-gradient",  i-1,  line, {type=21})   
         --set_floor("fl-normal",  i-1,  line)
      elseif c=="O" then
	 oxyd(i-1,line)         
        end
    end  
end
--               01234567890123456789
renderLine(00 , "####################")
renderLine(01 , "#O  #          #  O#")
renderLine(02 , "#   #          #   #")
renderLine(03 , "####################")
renderLine(04 , "#   #          #   #")  
renderLine(05 , "#O  #          #  O#")
renderLine(06 , "####################")
renderLine(07 , "                    ")
renderLine(08 , "                    ")
renderLine(09 , "  #b############b#  ")
renderLine(10 , "  2gggggggggggggg1  ")
renderLine(11 , "  #b############b#  ")
renderLine(12 , "                    ") 
--               01234567890123456789

set_stone("st-door_c", 4,2, {name="x1"})
set_stone("st-door_c", 2,3, {name="x2"})
set_stone("st-door_c", 15,5, {name="x3"})
set_stone("st-door_c", 15,1, {name="y1"})
set_stone("st-door_c", 17,3, {name="y2"})
set_stone("st-door_c", 4,4, {name="y3"})
oxyd_shuffle()

function s1()
SendMessage("x1", "openclose")
SendMessage("x2", "openclose")
SendMessage("x3", "openclose")
end

function s2()
SendMessage("y1", "openclose")
SendMessage("y2", "openclose")
SendMessage("y3", "openclose")
end

