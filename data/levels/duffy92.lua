-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Map It Out

rooms_wide=5
rooms_high=1

levelw=1+(19*rooms_wide)
levelh=1+(12*rooms_high)

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

fill_floor("fl-normal", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone("st-rock6", i-1, line)
		elseif c == "o" then
		   set_stone("st-oxyd", i-1, line,{color="0"})
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball",i-.5,line+.5,{name="b1",player=0})
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc6"})
		elseif c=="y" then
		   set_actor("ac-whiteball", i-1,line+.5, {player=1})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
		   set_floor("fl-space",i-1,line)
		elseif c=="A" then
            set_item("it-wormhole", i-1, line, {strength=0,targetx="10.5",targety="6.5"})
		elseif c=="a" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc5"})
		elseif c=="u" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc1"})
		elseif c=="r" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc2"})
		elseif c=="d" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc3"})
		elseif c=="l" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc4"})
		elseif c==" " then
		   set_item("it-trigger",i-1,line,{invisible=1})
	     end
	end	
end

renderLine(00,"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
renderLine(01,"!!!!!!!!!###!!!!!!!!!!!!!!!!#o#!!!!!!!!!!!!!!!!###!!!!!!!!!!!!!!!!###!!!!!!!!!!!!!!!!#o#!!!!!!!!")
renderLine(02,"!!!!!!!!!#A#!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!#A#!!!!!!!!!!!!!!!!#A#!!!!!!!!!!!!!!!!# #!!!!!!!!")
renderLine(03,"!!!!!!!!!#u#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!")
renderLine(04,"!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!")
renderLine(05,"!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!")
renderLine(06,"!!!!!#Al aza rA#!!!!!!!!# a aaa a #!!!!!!!!# a aaa a #!!!!!!!!# a aaa a #!!!!!!!!# a aaa a #!!!!")
renderLine(07,"!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!!!!!#####a#####!!!!")
renderLine(08,"!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!")
renderLine(09,"!!!!!!!!!#d#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!!!!!!!!!#a#!!!!!!!!")
renderLine(10,"!!!!!!!!!#A#!!!!!!!!!!!!!!!!#A#!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!# #!!!!!!!!!!!!!!!!#A#!!!!!!!!")
renderLine(11,"!!!!!!!!!###!!!!!!!!!!!!!!!!###!!!!!!!!!!!!!!!!#o#!!!!!!!!!!!!!!!!#o#!!!!!!!!!!!!!!!!###!!!!!!!!")
renderLine(12,"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")



 line1= {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
 line2= {1,O,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,1,0,1,1,0,1,O,1}
 line3= {1,0,0,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1}
 line4= {1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,1,1,1,0,1,1,0,1,1,1,0,1,1,0,0,0,1}
 line5= {1,0,1,0,1,0,1,1,1,0,1,0,1,1,0,1,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,1}
 line6= {1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,1,1,0,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1}
 line7= {1,0,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,1}
 line8= {1,0,1,0,1,1,1,0,1,0,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,0,0,1,0,1,1,0,0,0,1}
 line9= {1,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,0,1}
line10= {1,0,1,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0,0,1,0,1,1,1,1,1,0,0,0,1,1,1,0,0,1,0,0,0,1}
line11= {1,0,1,1,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1}
line12= {1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,0,0,0,0,1,0,0,0,0,1,0,1}
line13= {1,0,1,0,1,1,1,0,1,1,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,0,1,0,1}
line14= {1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,0,0,0,1,0,1,0,1,0,1}
line15= {1,0,0,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1}
line16= {1,0,1,1,1,1,1,0,1,0,0,0,0,Z,0,0,0,0,1,1,1,1,1,0,1,1,0,1,0,1,1,0,0,0,1,0,1,0,1}
line17= {1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,0,1,0,1,0,1}
line18= {1,0,1,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,1,1,0,1,0,0,0,1,0,1}
line19= {1,0,1,1,1,0,1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,1,1,0,1,0,1}
line20= {1,0,0,0,1,0,1,0,0,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,0,1,1,1,1,0,0,0,1,0,1,0,1}
line21= {1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,1,1}
line22= {1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,1,0,0,1,1}
line23= {1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,1,0,1,0,0,0,0,1,1,1,0,0,0,1,0,1,1,1}
line24= {1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,1,1,0,0,0,0,0,1,1,1,0,1,0,1}
line25= {1,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1}
line26= {1,0,1,1,1,0,1,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,0,0,1,1,1,0,1,1,1}
line27= {1,0,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,0,1,0,1}
line28= {1,0,1,0,0,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,1,1,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1}
line29= {1,0,1,1,1,0,1,0,1,1,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,0,0,1,0,1,0,1}
line30= {1,0,0,0,0,0,1,0,1,0,0,1,1,0,0,0,0,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1}
line31= {1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1}
line32= {1,0,1,1,1,0,1,0,0,0,0,1,1,0,1,0,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1}
line33= {1,O,1,1,1,1,1,0,1,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,1,0,1,1,0,1,1,0,0,0,1,0,1,O,1}
line34= {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

tab=  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,O,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,1,0,1,1,0,1,O,1,
1,0,0,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,
1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,1,1,1,0,1,1,0,1,1,1,0,1,1,0,0,0,1,
1,0,1,0,1,0,1,1,1,0,1,0,1,1,0,1,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,1,
1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,1,1,0,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,
1,0,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,1,
1,0,1,0,1,1,1,0,1,0,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,0,0,1,0,1,1,0,0,0,1,
1,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,0,1,
1,0,1,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0,0,1,0,1,1,1,1,1,0,0,0,1,1,1,0,0,1,0,0,0,1,
1,0,1,1,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1,
1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,0,0,0,0,1,0,0,0,0,1,0,1,
1,0,1,0,1,1,1,0,1,1,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,0,1,0,1,
1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,0,0,0,1,0,1,0,1,0,1,
1,0,0,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,
1,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,0,1,0,1,1,0,0,0,1,0,1,0,1,
1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,0,1,0,1,0,1,
1,0,1,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,1,1,0,1,0,0,0,1,0,1,
1,0,1,1,1,0,1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,1,1,0,1,0,1,
1,0,0,0,1,0,1,0,0,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,0,1,1,1,1,0,0,0,1,0,1,0,1,
1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,1,1,
1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,1,0,0,1,1,
1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,1,0,1,0,0,0,0,1,1,1,0,0,0,1,0,1,1,1,
1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,1,1,0,0,0,0,0,1,1,1,0,1,0,1,
1,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,
1,0,1,1,1,0,1,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,0,0,1,1,1,0,1,1,1,
1,0,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,0,1,0,1,
1,0,1,0,0,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,1,1,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,
1,0,1,1,1,0,1,0,1,1,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,0,0,1,0,1,0,1,
1,0,0,0,0,0,1,0,1,0,0,1,1,0,0,0,0,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,
1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,
1,0,1,1,1,0,1,0,0,0,0,1,1,0,1,0,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,
1,O,1,1,1,1,1,0,1,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,1,0,1,1,0,1,1,0,0,0,1,0,1,O,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}



tab2=  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,O,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,1,1,0,0,0,1,0,1,1,0,1,O,1,1,0,0,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,1,0,0,0,0,0,1,0,0,1,0,1,0,1,0,1,0,1,1,1,1,0,1,1,0,1,1,1,0,1,1,0,0,0,1,
1,0,1,0,1,0,1,1,1,0,1,0,1,1,0,1,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,1,0,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,1,1,0,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,0,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,0,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,0,0,1,0,1,1,0,0,0,1,
1,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,0,1,1,0,1,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0,0,1,0,1,1,1,1,1,0,0,0,1,1,1,0,0,1,0,0,0,1,1,0,1,1,1,0,1,0,0,0,0,0,1,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,0,0,0,0,1,0,0,0,0,1,0,1,1,0,1,0,1,1,1,0,1,1,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,0,0,0,1,0,1,0,1,0,1,1,0,0,0,1,0,1,0,1,1,1,1,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,1,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,0,1,0,1,1,0,0,0,1,0,1,0,1,1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,1,1,1,1,1,1,0,0,1,1,1,0,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,0,0,1,1,0,1,0,0,0,1,0,1,1,0,1,1,1,0,1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,1,1,0,1,0,1,1,0,0,0,1,0,1,0,0,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,0,1,1,1,1,0,0,0,1,0,1,0,1,1,0,1,1,1,0,1,1,1,1,1,0,1,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,1,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,1,0,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,1,0,1,0,0,0,0,1,1,1,0,0,0,1,0,1,1,11,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,1,1,0,0,0,0,0,1,1,1,0,1,0,1,1,0,0,0,1,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,1,1,0,1,0,0,0,1,1,1,0,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,0,0,1,1,1,0,1,1,1,
1,0,1,0,1,1,1,1,1,0,1,1,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,0,0,1,0,1,1,0,1,0,0,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,1,1,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,0,0,1,0,1,0,1,1,0,0,0,0,0,1,0,1,0,0,1,1,0,0,0,0,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,
1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0,0,0,0,1,1,0,1,0,0,0,1,1,0,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,1,O,1,1,1,1,1,0,1,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,1,0,1,1,0,1,1,0,0,0,1,0,1,O,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}


direc=0

x=14
y=16

width=39

function getval(j,i)
   return tab[width * (i - 1) + j]
   end

--function setval(j,i, val2)
--   tab[width * (i-1) + j] = val2
--end


      

function funcc1()
direc=1
end

function funcc2()
direc=2
end

function funcc3()
direc=3
end

function funcc4()
direc=4
end

function funcc5()
direc=0
end

function funcc6()
if direc==1 then
y=y-1
elseif direc==2 then
x=x+1
elseif direc==3 then
y=y+1
elseif direc==4 then
x=x-1
end
direc=0

--value=getval(x,y-1)

--set_stone("st-greenbrown",value,1)

   enigma.KillItem(10,2)
   enigma.KillItem(14,6)
   enigma.KillItem(10,10)
   enigma.KillItem(6,6)

if getval(x,y-1)==0 then
set_item("it-wormhole", 10, 2, {strength=0,targetx="10.5",targety="6.5"})
else
end

if getval(x+1,y)==0 then
set_item("it-wormhole", 14, 6, {strength=0,targetx="10.5",targety="6.5"})
else
end

if getval(x,y+1)==0 then
set_item("it-wormhole", 10, 10, {strength=0,targetx="10.5",targety="6.5"})
else
end

if getval(x-1,y)==0 then
set_item("it-wormhole", 6, 6, {strength=0,targetx="10.5",targety="6.5"})
else
end

if x==2 and y==3 then
   enigma.KillItem(10,2)
set_item("it-wormhole", 10, 2, {strength=0,targetx="29.5",targety="6.5"})
end

if x==38 and y==32 then
   enigma.KillItem(10,10)
set_item("it-wormhole",10,10, {strength=0,targetx="48.5",targety="6.5"})
end

if x==2 and y==32 then
   enigma.KillItem(10,10)
set_item("it-wormhole",10,10, {strength=0,targetx="67.5",targety="6.5"})
end

if x==38 and y==3 then
   enigma.KillItem(10,2)
set_item("it-wormhole",10,2, {strength=0,targetx="86.5",targety="6.5"})
end




end

oxyd_shuffle()