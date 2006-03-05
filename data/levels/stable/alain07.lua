-- Pirates Island, a level for Enigma
-- Copyright (C) 2006 Alain Busser
-- Licensed under GPL v2.0 or above 

levelw = 40
levelh = 23

create_world(levelw, levelh)
oxyd_default_flavor = "a"
fill_floor("fl-leaves")

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="." then
			set_floor( "fl-sand", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
            elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5, {player=0})
		elseif c=="w" then
			set_floor("fl-water",i-1,line)
		elseif c=="b" then
			set_floor("fl-himalaya",i-1,line)
		elseif c=="c" then
			set_stone("st-coinslot",i-1,line,{action="callback", target="sand1"}) 
		elseif c=="d" then
			set_stone("st-coinslot", i-1,line,{action="callback", target="sand2"})
		elseif c=="e" then
			document(i-1,line,"The pirates have lost several hidden things on this island...")
		elseif c=="g" then
			set_item("it-seed",i-1,line)
		elseif c=="h" then
			set_item("it-coin4",i-1,line)
		elseif c=="f" then
			set_stone("st-wood",i-1,line)
		elseif c=="1" then
			set_item("it-booze",i-1,line)
     		elseif c == "2" then
         		set_item("it-banana",i-1,line)
		end
	end	
end

function sand1()
	set_floor("fl-sand",8,20)
	set_floor("fl-sand",8,19)
	set_floor("fl-sand",9,20)
	set_floor("fl-sand",9,21)
	set_floor("fl-sand",10,21)
	set_floor("fl-sand",7,19)
	set_floor("fl-sand",7,20)
	set_floor("fl-sand",6,20)
	set_floor("fl-sand",5,20)
	set_floor("fl-sand",4,20)
end

function sand2()
	set_floor("fl-sand",31,8)
	set_floor("fl-sand",32,8)
	set_floor("fl-sand",33,8)
	set_floor("fl-sand",31,7)
	set_floor("fl-sand",32,7)
	set_floor("fl-sand",31,6)
end


for i=1,4 do
	for j=1,4 do
		set_stone("st-chameleon",5+i,10+j)
	end
end

for i=1,4 do
	for j=1,2 do
		set_stone("st-chameleon",11+i,7+j)
	end
end

for i=1,6 do
	for j=1,2 do
		set_stone("st-chameleon",29+i,13+j)
	end
end

for j=1,2 do
	set_stone("st-chameleon",2,17+j)
end

for i=1,8 do
	for j=1,5 do
		set_stone("st-chameleon",18+i,14+j)
	end
end


--               0123456789012345678901234567890123456789
renderLine(00 , "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
renderLine(01 , "wwwwww...wwwwwwwwwwww..wwwwwwwwowwwwwwww")
renderLine(02 , "wwwww..o..wwwwwwwww.. ..wwwwwwwwwwwwwwww")
renderLine(03 , "wwwwww...wwwwwwwww.. 1 ..wwwww...wwwwwww")
renderLine(04 , "wwwwwwwwwwwwwwwwwww.. ..wwwwwwfo..wwwwww")
renderLine(05 , "wwwwwwwwwwwww.wwwwww...wwwwwww...wwwwwww")  
renderLine(06 , "wwwwwwwwwwww...wwwwwwwwwwwwwwwwwwwwwwwww")
renderLine(07 , "www.......... ....wwwwwwwwwwwwwwwwwwwwww")
renderLine(08 , "ww...           ...wwwwwwwwwwwwwwwwwwwww")
renderLine(09 , "w..            h..wwwwwwwwwwww.....wwwww")
renderLine(10 , "w..      z      ..wwwwwwwwwww..   ..wwww")
renderLine(11 , "ww..          ......wwwwwwwww..  ..wwwww")
renderLine(12 , "www..         ..f  ...wwwww...   1..wwww")
renderLine(13 , "www..   g    ..     ........       ..www")
renderLine(14 , "wwww..                             h.www")
renderLine(15 , "wwwww..      bb                2    .www")
renderLine(16 , "ww.www..    bbbbe      g      22   ..www")
renderLine(17 , "w...www..    bcbbb          222   ..wwww")
renderLine(18 , "w.g.wwww..    bbdb          22   ..wwwww")
renderLine(19 , "w. ..wwww..    bb    ...    2   ..wwwwww")
renderLine(20 , "w.o.wwwwww....    .......      ..wwwwwww")
renderLine(21 , "w...wwwwwww.........wwww........wwwwwwww")
renderLine(22 , "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww") 
--               0123456789012345678901234567890123456789

oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)
















