-- Enignimm=Nim, a level for Enigma
-- Copyright (C) 2006 Alain Busser
-- Licensed under GPL v2.0 or above 
-- with the usual and valuable help by Andreas Lochmann

levelw = 20
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "a"
draw_border("st-rock1")
fill_floor("fl-sahara", 0,0, level_width,level_height)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-glass1", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
            elseif c=="d" then
         		document(i-1,line, "You play against Big Brother; each player in turn deletes 1, 2 or 3 stones; the one who deletes the last stone LOOSES !!!") 
            elseif c =="b" then
			document(i-1,line, "Now you begin this game")
  		elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5, {player=0})
		elseif c=="+" then
			set_stone("st-wood", i-1, line)
		elseif c=="*" then
			set_stone("st-rock1", i-1,line)
		elseif c=="f" then
			doorh(i-1,line, {name="door3"})
		elseif c=="g" then
			doorv(i-1,line, {name="door1"})
		elseif c=="h" then
			doorv(i-1,line, {name="door2"})
		elseif c == "1" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch1"})
     		elseif c == "2" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch2"})
     		elseif c == "3" then
         		set_stone("st-switch",i-1,line, {action="callback", target="switch3"})
     		elseif c == "T" then
         		set_stone("st-switch",i-1,line, {action="callback", target="turn1"})
     		elseif c == "S" then
         		set_stone("st-switch",i-1,line, {action="callback", target="turn2"})
		end
	end	
end


--               01234567890123456789
renderLine(00 , "                    ")
renderLine(01 , " ################## ")
renderLine(02 , " #++++++++++++++++# ")
renderLine(03 , " ################## ")
renderLine(04 , "  ###############   ")
renderLine(05 , "  #+++++++++++++#   ")  
renderLine(06 , "  ###############   ")
renderLine(07 , "  1 2 3 *  1 2 3    ")
renderLine(08 , "   z d  g       b   ")
renderLine(09 , "       S*         T ")
renderLine(10 , " ************f***** ")
renderLine(11 , " o                o ")
renderLine(12 , "                    ") 
--               01234567890123456789

oxyd_shuffle()


-- initial settings
nimstone="st-wood"
markedstone="st-glass3"
num1=16
num2=13
nc=random(3)
--for i=1,nc do
--	num2=num2-1
--	enigma.KillStone(num2+3,5)
--end
num2=num2-nc
nd=1
nim1=0
nim2=0
game=1


-- drawing functions
function redraw_upper_line()
	if num1 - nd >= 1 then
		for i = 1, num1 - nd do
			set_stone(nimstone, i + 1, 2)
		end
	end
	if num1 - nd + 1 >= 1 then
		for i = num1 - nd + 1, num1 do
			set_stone(markedstone, i + 1, 2)
		end
	end
	if num1 + 1 < 16 then
		for i = num1 + 1, 16 do
			enigma.KillStone(i + 1, 2)
		end
	end
end

function redraw_lower_line()
	if num2 - nd >= 1 then
		for i = 1, num2 - nd do
			set_stone(nimstone, i + 2, 5)
		end
	end
	if num2 - nd + 1 >= 1 then
		for i = num2 - nd + 1, num2 do
			set_stone(markedstone, i + 2, 5)
		end
	end
	if num2 + 1 < 16 then
		for i = num2 + 1, 13 do
			enigma.KillStone(i + 2, 5)
		end
	end
end

-- initial drawing
--redraw_upper_line()
redraw_lower_line()

function switch1()
	nd = 1 
	if game == 2 then
		redraw_upper_line()
	else
		redraw_lower_line()
	end
end

function switch2()
	nd = 2 
	if game == 2 then
		redraw_upper_line()
	else
		redraw_lower_line()
	end
end

function switch3()
	nd = 3 
	if game == 2 then
		redraw_upper_line()
	else
		redraw_lower_line()
	end
end

function turn1() --this is the second game, with 16 stones
	if num1>=nd then
		--for i=1,nd do
		--	num1=num1-1
		--	enigma.KillStone(num1+2,2)
		--end
		num1 = num1 - nd
		redraw_upper_line()
		if num1>0 then
			if num1==15 then
				nc=2
			elseif num1==14 then
				nc=1
			elseif num1==13 then
				nc=random(3)
			elseif num1==12 then
				nc=3
			elseif num1==11 then
				nc=2
			elseif num1==10 then
				nc=1
			elseif num1==9 then
				nc=random(3)
			elseif num1==8 then
				nc=3
			elseif num1==7 then
				nc=2
			elseif num1==6 then
				nc=1
			elseif num1==5 then
				nc=random(3)
			elseif num1==4 then
				nc=3
			elseif num1==3 then
				nc=2
			elseif num1==2 then
				nc=1
			elseif num1==1 then
				nc=1
				nim1=1
				--enigma.KillStone(3,2)
			end
			num1 = num1 - nc
			redraw_upper_line()
			--for i=1,nc do
			--	num1=num1-1
			--	enigma.KillStone(num1+2,2)
			--end
		end
		if num1==0 then
			if nim1==0 then
				document(12,8, "Poor little blackball... SHIFT+F3!!!")
			else
				SendMessage("door3", "open")
			end
		end			
	end
end

function turn2()  --this is the first "Nim" game, with 13 stones
	if num2>=nd then
		num2 = num2 - nd
		redraw_lower_line()
		--for i=1,nd do
		--	num2=num2-1
		--	enigma.KillStone(num2+3,5)
		--end
		if num2>0 then
			if num2==15 then
				nc=2
			elseif num2==14 then
				nc=1
			elseif num2==13 then
				nc=random(3)
			elseif num2==12 then
				nc=3
			elseif num2==11 then
				nc=2
			elseif num2==10 then
				nc=1
			elseif num2==9 then
				nc=random(3)
			elseif num2==8 then
				nc=3
			elseif num2==7 then
				nc=2
			elseif num2==6 then
				nc=1
			elseif num2==5 then
				nc=random(3)
			elseif num2==4 then
				nc=3
			elseif num2==3 then
				nc=2
			elseif num2==2 then
				nc=1
			elseif num2==1 then
				nc=1
				nim2=1
				--enigma.KillStone(4,5)
			end
			num2 = num2 - nc
			redraw_lower_line()
			--for i=1,nc do
			--	num2=num2-1
			--	enigma.KillStone(num2+3,5)
			--end
		end
		if num2==0 then
			if nim2==0 then
				document(2,8, "Poor little blackball... SHIFT+F3!!!")
			else
				SendMessage("door1", "open")
				game = 2
			end
		end			
	end
end


















