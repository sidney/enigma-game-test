-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Almost There

levelw=140
levelh=75

create_world( levelw, levelh)

fill_floor("fl-hay", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-1,line+.5, {player=0})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
			set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="I" then
			set_floor("fl-ice_001",i-1,line)
			set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="x" then
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="X" then
  		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="i" then
		   set_stone("st-invisible",i-1,line)
		elseif c=="F" then
		   set_stone("st-fart",i-1,line)
		elseif c=="H" then
		   set_item("it-hammer",i-1,line)
		elseif c=="w" then
		   set_item("it-wormhole", i-1, line, {strength=0,targetx="28",targety="6.5"})
		elseif c == "d" then --1-d
			set_floor("fl-gradient",  i-1,  line, {type=1})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "u" then --2-u
			set_floor("fl-gradient",  i-1,  line, {type=2})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "r" then --3-r
			set_floor("fl-gradient",  i-1,  line, {type=3})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "l" then --4-l
			set_floor("fl-gradient",  i-1,  line, {type=4})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "1" then --ur
			set_floor("fl-gradient",  i-1,  line, {type=11})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "3" then --dl
			set_floor("fl-gradient",  i-1,  line, {type=9})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "7" then --dr
			set_floor("fl-gradient",  i-1,  line, {type=12})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c == "9" then --ul
			set_floor("fl-gradient",  i-1,  line, {type=10})
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="A" then
		   set_item("it-hollow", i-1, line)
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="a" then
		   set_item("it-tinyhollow", i-1, line)
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="B" then
		   set_item("it-hill", i-1, line)
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="b" then
		   set_item("it-tinyhill", i-1, line)
		   set_stone("st-greenbrown_hole",i-1,line)
		elseif c=="J" then
  		   set_item("it-vortex-open", i-1, line, {targetx="106.5",targety="14.5"})
		elseif c=="K" then
  		   set_item("it-vortex-open", i-1, line, {targetx="3.5",targety="43.5"})
		elseif c=="L" then
  		   set_item("it-vortex-open", i-1, line, {targetx="106.5",targety="26.5"})
		elseif c=="M" then
  		   set_item("it-vortex-open", i-1, line, {targetx="3.5",targety="41.5"})
	     end
	end	
end

renderLine(00,"#######################################################################################################################")
renderLine(01,"#################### o              o #################################################################################")
renderLine(02,"####xxxxxxxxxxxxx###      F           #xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#########################")
renderLine(03,"####xxxxxxxxxxxxx###              o   Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#########################")
renderLine(04,"####xxxxxxxxxxxxx###          o       #xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx#########################")
renderLine(05,"####ddd##xxx##xxx###                  ######################xxx############################xxx#########################")
renderLine(06,"####ddd##xxx##xxx###         z        #xxxxxxxxxxxxxxxxxxxx#xxx#xxxxxxxxxxxxxxxxxxxxxxxxxA#xxx#########################")
renderLine(07,"####ddd##xxx##xxx###o                 #xxxxxxxxxxxxxxxxxxxx#xxx#xxxxxxxxxxxxxxxxxxxxxxxxxA#xxx#########################")
renderLine(08,"####ddd##xxx##xxx###                ii#xxxxxxxxxxxxxxxxxxxx#xxx#xxxxxxxxxxxxxxxxxxxxxxxxxA#xxx#########################")
renderLine(09,"####ddd#xxxxx#xxx###    o           ioXxx###############xxx#xxx#xxx########################xxx#########################")
renderLine(10,"####ddd#x###x#xxx###                ii####xxxABABABABABAxxx#xxx#xxxxxxxxBABABABABABABAxxxxxxxx#########################")
renderLine(11,"####ddd#x#xxx#xxx###      F      o    ####xxxBABABABABABxxx#xxx#xxxxxxxxABABABABABABABxxxxxxxx#########################")
renderLine(12,"####ddd#x#x###xxx#########X###############xxxABABABABABAxxx#xxx#xxxxxxxxBABABABABABABAxxxxxxxx#########################")
renderLine(13,"####ddd#x#xxx#xxx#xxxxxxxxxxxxxxxxxrrIII##aba###############xxx########################################################")
renderLine(14,"####ddd###x#x#xxx#xxxxxxxxxxxxxxxxxrrIII##bab#xxxxxxxxxxxxxx===###xxxxxxxxxaaaxxxxxxxxxxxxxxxx############K############")
renderLine(15,"####ddd#xxx#x#xxx#xxxxxxxxxxxxxxxxxrrIII##aba#xxxxxxxxxxxxxx===###xxxxxxxxxaaaxxxxxxxxxxxxxxxx#########################")
renderLine(16,"####ddd#x###x#xxx###############xxx##III##bab#xxxxxxxxxxxxxx===###xxxxxxxxxaaaxxxxxxxxxxxxxxxx#########################")
renderLine(17,"####ddd#xxx#x#xxxxxxxxxxxxxxxxx#xxx##III##aba#BBB###########xxx###xxx#################xxx##xxx#########################")
renderLine(18,"####ddd#####x#xxxxxxxxxxxxxxxxx#xxx##III##bab#BBB###########xxx###xxxxxxxxxxxxxxxxxx##xxx##xxx#########################")
renderLine(19,"####ddd#xxxxx#xxxxxxxxxxxxxxxxx#xxx##III##aba#BBB##3rrrrrd1#xxx###xxxxxxxxxxxxxxxxxx##xxx##xxx#########################")
renderLine(20,"####ddd#x###x###############uuu#xxx##III##bab#BBB##u3rrrr1d#xxx###xxxxxxxxxxxxxxxxxx##xxx##xxx#########################")
renderLine(21,"####ddd#x###xxxxxxxxxxxxxxx#uuu#xxx##III##aba#BBB##uu3rr1dd#xxx#########xxx######xxx##xxx##xxx#########################")
renderLine(22,"####ddd#x###xxxxxxxxxxxxxxx#uuu#xxx##III##bab#xxx##uuu##ddd#xxxxxxxxxxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(23,"####xxx#=###xxxxxxxxxxxxxxx#uuu#xxx#######aba#AAA##uuu##ddd#xxxxxxxxxxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(24,"####xxx#=###################uuu#xxxrrrxABAxxx#AAA##uuu##xxx#xxxxxxxxxxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(25,"####xxx#x#####xxxxxxxxxxxxx#uuu#xxxrrrxBABxxx#AAA##uuu##xxx#xxx#####xxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(26,"########x#####x#############uuu#xxxrrrxABAxxx#AAA##uuu##xxx#xxxxxxx#xxx#xxx#xxx##xxx##xxx##xxx############M############")
renderLine(27,"########x#xxxxx#############uuu###############AAA##uuu##############xxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(28,"###xxxxxx#x###x###xxxlllllllxxxrrrrrrrrrrrrrrrxxx##xxxxxxxxxxxxxxxxxxxx#xxx#xxx##xxx##xxx##xxx#########################")
renderLine(29,"########x#x###x###xxxlllllllxxxrrrrrrrrrrrrrrrxxx##xxxxxxxxxxxxxxxxxxxx#xxx#xxx#######xxx##xxx#########################")
renderLine(30,"###xxx##I#x###x###xxxlllllllxxxrrrrrrrrrrrrrrrxxx##xxxxxxxxxxxxxxxxxxxx#xxx#xxxxxxxxxxxxx##xxx#########################")
renderLine(31,"###x#x##I#x###x###xxx#########################xxx#######################xxx#xxxxxxxxxxxxx##xxx#########################")
renderLine(32,"###x#x##I#x###x###xxx#xxxxxxxxxxxxxxxxxxxxxxx#xxxxxxxxxx=========xxxxxxxxxx#xxxxxxxxxxxxx##xxx#########################")
renderLine(33,"###x#x##Ixx###x###xxx#xxxxxxxxxxxxxxxxxxxxxxx#xxxxxxxxxx=========xxxxxxxxxx################xxx#########################")
renderLine(34,"###x#x##I#####x###xxx#xxxxxxxxxxxxxxxxxxxxxxx#xxxxxxxxxx=========xxxxxxxxxx#xxxxxxxxxxxxxx#xxx#########################")
renderLine(35,"###x#x##I#xxxxx###xxx#xxx#################xxx###############################xxxxxxxxxxxxxx#xxx#########################")
renderLine(36,"###x#x##I#x#######xxx#xxx#xxxxxxxxxxxxxxx====lllllllxxxxxxxxx#Illlllllllll1#xxxxxxxxxxxxxx#xxx#########################")
renderLine(37,"###x#x##x#x###xxx#xxx#bbb#xxxxxxxxxxxxxxx====lllllllxxxxxxxxx#Illllllllll1u############xxxxxxx#########################")
renderLine(38,"###x#x##x#xxxxx#x#xxx#bbb#xxxxxxxxxxxxxxx====lllllllxxxxxxxxx#Illlllllll1uu############xxxxxxx#########################")
renderLine(39,"###x#x##########x#===#bbb#xxx#############################xxx###########uuu############xxxxxxx#########################")
renderLine(40,"###x#xxxxxxxxxxxx#===#xxx#xxxababa##xxABabXHw#xxxxxx#xxx##xxxxaaaxxxxxxAAAAAxxxxxx#########ddd#########################")
renderLine(41,"###J#x##########x#===#xxx#xxxbabab##x#########xxxxxx#xxx##xxxxaaaxxxxxxAAAAAxxxxxx#rrrxxxx#ddd#########################")
renderLine(42,"#####xxxxx##xxxxx#xxx#xxx#xxxababa##x#########xxxxxx#xxx##xxxxaaaxxxxxxAAAAAxxxxxx#rrrxxxx#ddd#########################")
renderLine(43,"###L#####x##x#####xxx#xxx###########x#xxxxxxxxxxx####xxx#######################xxx#rrrxxxx#ddd#########################")
renderLine(44,"###x#xxxxx##xxxxx#xxx#aaa#xxxxx#xxxxx#xxxxxxxxxxx####xxxxxxxxxxxxxxxxxxxxxxxx##xxx#####xxx#ddd#########################")
renderLine(45,"###x#x##########x#xxx#aaa#x#x#xxx#####xxxxxxxxxxx####xxxxxxxxxxxxxxxxxxxxxxxx##xxx#####xxx#ddd#########################")
renderLine(46,"###x#xxxxx##xxxxx#xxx#aaa#x#######x#x#xxx############xxxxxxxxxxxxxxxxxxxxxxxx##xxx#xxxxxxx#xxx#########################")
renderLine(47,"###x#####x##x#####xxx#xxx#xxxxxxxxxxx#xxx#xxxxxxxxxx#xxx##########xxx#####III##xxx#xxxxxxx#xxx#########################")
renderLine(48,"###x#xxxxx##xxxxx#xxx#xxx###########x#xxx#xxxxxxxxxx#xxx##########xxx#xxx#III##xxx#xxxxxxx#uuu#########################")
renderLine(49,"###x#x##########x#xxx#xxxxxxxxxxxxxxx#xxx#xxxxxxxxxx#xxx#xxxxxxxxxxxx#xxx#III##xxx#xxx#####uuu#########################")
renderLine(50,"###x#xxxxx##xxxxx#xxx#################xxx########xxx#xxx#xxxxxxxxxxxx#xxx#III##xxxxxxxllll#uuu#########################")
renderLine(51,"###x#####x##x#####xxxxxxxxxrrrrrxxxxxxxxxxxxxxxxxxxx#xxx#xxxxxxxxxxxx#xxx#III##xxxxxxxllll#xxx#########################")
renderLine(52,"###x#xxxxx##xxxxx#xxxxxxxxxrrrrrxxxxxxxxxxxxxxxxxxxx#xxx#xxx######xxx#xxx#III##xxxxxxxllll#xxx#########################")
renderLine(53,"###x##############xxxxxxxxxrrrrrxxxxxxxxxxxxxxxxxxxx#xxx#xxx######xxx#xxx#III######xxx#####ddd#########################")
renderLine(54,"###xrrrrrrrrrrrrA#####################################x##xxx######xxx#xxx#III######xxx#####ddd#########################")
renderLine(55,"###x##############xxxxxxx#x#xxx#xxxxxxx#x#xxxxxxx#xxx#x##xxx##########xxx##########xxx#####ddd#########################")
renderLine(56,"###xxxxrrrrrxxxxAxx###x#x#xxx#xxx#####xxxxx#######x#x#x##xxxxxxxxxxxxxxxxxxxxABABxxxxxxxxx#xxx#########################")
renderLine(57,"###xxxxrrrrrxxxxAxx#x#x###x#######x#x#x#x###xxx#xxx#x#x##xxxxxxxxxxxxxxxxxxxxBABAxxxxxxxxx#xxx#########################")
renderLine(58,"###xxxxrrrrrxxxxAxxxx#xxxxxxxxxxxxx#xxx#xxxxx#xxx#x#xxx##xxxxxxxxxxxxxxxxxxxxABABxxxxxxxxx#xxx#########################")
renderLine(59,"#######################################################################################################################")
renderLine(60,"#######################################################################################################################")
renderLine(61,"#######################################################################################################################")
renderLine(62,"#######################################################################################################################")
renderLine(63,"#######################################################################################################################")
renderLine(64,"#######################################################################################################################")
renderLine(65,"#######################################################################################################################")
renderLine(66,"#######################################################################################################################")
renderLine(67,"#######################################################################################################################")
renderLine(68,"#######################################################################################################################")
renderLine(69,"#######################################################################################################################")
renderLine(70,"#######################################################################################################################")
renderLine(71,"#######################################################################################################################")
renderLine(72,"#######################################################################################################################")
renderLine(73,"#######################################################################################################################")

oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)















