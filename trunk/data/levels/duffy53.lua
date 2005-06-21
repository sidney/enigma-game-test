-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Turnstile Maze

levelw=40
levelh=13

create_world( levelw, levelh)

fill_floor("fl-rough", 0,0,levelw,levelh)
enigma.SetCompatibility("oxyd1")
enigma.ConserveLevel=FALSE

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-greenbrown", i-1, line)
		elseif c =="X" then
			set_stone( "st-death", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
--			fill_floor("fl-water", i-1,line, 1,1)
                elseif c == "~" then
--			abyss(i-1,line)
			fill_floor("fl-water", i-1,line, 1,1)
		elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5)
		elseif c=="=" then
		   set_stone("st-turnstile",i-1,line)
		   set_stone("st-turnstile-w",i-2,line)
		   set_stone("st-turnstile-e",i,line)
		elseif c=="i" then
		   set_stone("st-turnstile",i-1,line)
		   set_stone("st-turnstile-n",i-1,line-1)
		   set_stone("st-turnstile-s",i-1,line+1)
		elseif c=="x" then
		   set_stone("st-turnstile",i-1,line)
		   set_stone("st-turnstile-n",i-1,line-1)
		   set_stone("st-turnstile-e",i,line)
		   set_stone("st-turnstile-s",i-1,line+1)
		   set_stone("st-turnstile-w",i-2,line)
   		elseif c =="A" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge1"})
   		elseif c =="B" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge2"})
   		elseif c =="C" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge3"})
   		elseif c =="D" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge4"})
   		elseif c =="E" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge5"})
   		elseif c =="F" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge6"})
   		elseif c =="G" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge7"})
   		elseif c =="H" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge8"})
   		elseif c =="I" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge9"})
   		elseif c =="J" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge10"})
   		elseif c =="K" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge11"})
   		elseif c =="L" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge12"})
   		elseif c =="M" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge13"})
   		elseif c =="N" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge14"})
   		elseif c =="O" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge15"})
   		elseif c =="P" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge16"})
   		elseif c =="Q" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge17"})
   		elseif c =="R" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge18"})
   		elseif c =="S" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge19"})
   		elseif c =="T" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge20"})
   		elseif c =="U" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge21"})
   		elseif c =="V" then
			set_item("it-trigger", i-1,line, {action="openclose", target="bridge22"})
		elseif c=="a" then
		   set_floor("fl-bridge",i-1,line,{name="bridge1"})
		elseif c=="b" then
		   set_floor("fl-bridge",i-1,line,{name="bridge2"})
		elseif c=="c" then
		   set_floor("fl-bridge",i-1,line,{name="bridge3"})
		elseif c=="d" then
		   set_floor("fl-bridge",i-1,line,{name="bridge4"})
		elseif c=="e" then
		   set_floor("fl-bridge",i-1,line,{name="bridge5"})
		elseif c=="f" then
		   set_floor("fl-bridge",i-1,line,{name="bridge6"})
		elseif c=="g" then
		   set_floor("fl-bridge",i-1,line,{name="bridge7"})
		elseif c=="h" then
		   set_floor("fl-bridge",i-1,line,{name="bridge8"})
		elseif c==";" then
		   set_floor("fl-bridge",i-1,line,{name="bridge9"})
		elseif c=="j" then
		   set_floor("fl-bridge",i-1,line,{name="bridge10"})
		elseif c=="k" then
		   set_floor("fl-bridge",i-1,line,{name="bridge11"})
		elseif c=="l" then
		   set_floor("fl-bridge",i-1,line,{name="bridge12"})
		elseif c=="m" then
		   set_floor("fl-bridge",i-1,line,{name="bridge13"})
		elseif c=="n" then
		   set_floor("fl-bridge",i-1,line,{name="bridge14"})
		elseif c==":" then
		   set_floor("fl-bridge",i-1,line,{name="bridge15"})
		elseif c=="p" then
		   set_floor("fl-bridge",i-1,line,{name="bridge16"})
		elseif c=="q" then
		   set_floor("fl-bridge",i-1,line,{name="bridge17"})
		elseif c=="r" then
		   set_floor("fl-bridge",i-1,line,{name="bridge18"})
		elseif c=="s" then
		   set_floor("fl-bridge",i-1,line,{name="bridge19"})
		elseif c=="t" then
		   set_floor("fl-bridge",i-1,line,{name="bridge20"})
		elseif c=="u" then
		   set_floor("fl-bridge",i-1,line,{name="bridge21"})
		elseif c=="v" then
		   set_floor("fl-bridge",i-1,line,{name="bridge22"})
		elseif c == "%" then
                        set_stone("st-door_b", i-1,line, {name="door1", type="v"})
	     end
	end	
end

function yy1( color, x, y)
       stone = format( "st-%s4", color)
        set_stone( stone, x, y)
     end

renderLine(00,"###############################!!!!!!!!")
renderLine(01,"# z%abcdefgh;jklmn:pqrstuv    #!!!!!!!!")
renderLine(02,"# ##########################  #!!!!!!!!")
renderLine(03,"# A  B  C  D  E  F #!!!!!!!#  #!!!!!!!!")
renderLine(04,"# =  i  =  i  =  i #!!!!!#o#  #o#!!!!!!")
renderLine(05,"#  G  H  I  J  K   #!!!!!o      o!!!!!!")
renderLine(06,"#  =  i  =  i  =   #!!!!!# x  x #!!!!!!")
renderLine(07,"#   L  M  N  O  P  #!!!!!o      o!!!!!!")
renderLine(08,"#   =  i  =  i  =  #!!!!!o      o!!!!!!")
renderLine(09,"# Q  R  S  T  U  V #!!!!!# x  x #!!!!!!")
renderLine(10,"# i  =  i  =  i  = #!!!!!o      o!!!!!!")
renderLine(11,"#                  #!!!!!#o#oo#o#!!!!!!")
renderLine(12,"####################!!!!!!!!!!!!!!!!!!!")

oxyd_shuffle()

function timer_handler()
    SendMessage("door1","open")
end

set_stone( "st-timer", 39, 12, {action="callback",target="timer_handler",interval=1})