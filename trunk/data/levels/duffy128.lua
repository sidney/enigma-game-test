-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Patterns

rooms_wide=15
rooms_high=1

levelw=1+(19*rooms_wide)+4
levelh=1+(12*rooms_high)

create_world( levelw, levelh)

fill_floor("fl-rough-blue", 0,0,levelw,levelh)

usnum=1
rsnum=1
dsnum=1
lsnum=1

usnum2=1
rsnum2=1
dsnum2=1
lsnum2=1

msnum=1
nsnum=1
osnum=1
psnum=1

zeropos=random(4)

pos1=0
pos2=0
pos3=0
pos4=0

pos1=random(4)
pos2=pos1

while pos1==pos2 do
pos2=random(4)
end
pos3=pos2

while (pos3==pos2 or pos3==pos1) do
   pos3=random(4)
end
pos4=pos3

while (pos4==pos3 or pos4==pos2 or pos4==pos1) do
   pos4=random(4)
end

function funcc1()
--    if ff1==1 then
--       ff1=2
--    elseif ff1==2 then
--       ff1=3
--    elseif ff1==3 then
--       ff1=4
--    elseif ff1==4 then
--       ff1=1
--    end
end


function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-blue-sand", i-1, line)
		elseif c =="w" then
			set_stone( "st-glass", i-1, line)
		elseif c ==">" then
			set_stone( "st-thief", i-1, line)
			set_floor("fl-space",i-1,line)
		elseif c == "o" then
			oxyd( i-1, line)
		   set_floor("fl-normal",i-1,line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-1,line+.5, {player=0})
		elseif c=="y" then
		   set_actor("ac-whiteball", i-1,line+.5, {player=1})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
		elseif c=="U" then
		   set_stone("st-fourswitch",i-1,line,{name="s1",action="callback",target="funcc1"})
		elseif c=="R" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		elseif c=="D" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		elseif c=="L" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		elseif c=="u" then
		   set_stone("st-fourswitch",i-1,line,{name=("sa"..usnum),action="callback",target=("funcca"..usnum)})
usnum=usnum+1
		elseif c=="r" then
		   set_stone("st-fourswitch",i-1,line,{name=("sb"..rsnum),action="callback",target=("funccb"..rsnum)})
rsnum=rsnum+1
		elseif c=="d" then
		   set_stone("st-fourswitch",i-1,line,{name=("sc"..dsnum),action="callback",target=("funccc"..dsnum)})
dsnum=dsnum+1
		elseif c=="l" then
		   set_stone("st-fourswitch",i-1,line,{name=("sd"..lsnum),action="callback",target=("funccd"..lsnum)})
lsnum=lsnum+1
		elseif c=="A" then
			doorv( i-1,line, {name="door1"})
		elseif c=="B" then
			doorv( i-1,line, {name="door2"})
		elseif c=="5" then
			doorv( i-1,line, {name="door3"})
		elseif c=="1" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if zeropos==1 then

		   elseif zeropos==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="2" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if zeropos==1 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==4 then

		   end
		elseif c=="3" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if zeropos==1 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==3 then

		   elseif zeropos==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="4" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if zeropos==1 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==2 then

		   elseif zeropos==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif zeropos==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="a" then
		   set_stone("st-fourswitch",i-1,line,{name=("sssa"..usnum2),action="callback",target=("funccqa"..usnum2)})
usnum2=usnum2+1
		elseif c=="b" then
		   set_stone("st-fourswitch",i-1,line,{name=("sssb"..rsnum2),action="callback",target=("funccqb"..rsnum2)})
rsnum2=rsnum2+1
		elseif c=="c" then
		   set_stone("st-fourswitch",i-1,line,{name=("sssc"..dsnum2),action="callback",target=("funccqc"..dsnum2)})
dsnum2=dsnum2+1
		elseif c=="`" then
		   set_stone("st-fourswitch",i-1,line,{name=("sssd"..lsnum2),action="callback",target=("funccqd"..lsnum2)})
lsnum2=lsnum2+1
		elseif c=="e" then
		   set_stone("st-fourswitch",i-1,line,{name="t1",action="callback",target="funcct1"})
		elseif c=="f" then
		   set_stone("st-fourswitch",i-1,line,{name="t2",action="callback",target="funcct2"})
		elseif c=="G" then
		   set_stone("st-fourswitch",i-1,line,{name="t3",action="callback",target="funcct3"})
		elseif c=="h" then
		   set_stone("st-fourswitch",i-1,line,{name="t4",action="callback",target="funcct4"})
		elseif c=="Q" then
		   set_floor("fl-normal",i-1,line)
		elseif c == "8" then --2-u
			set_floor("fl-gradient",  i-1,  line, {type=2})
		elseif c == "6" then --3-r
			set_floor("fl-gradient",  i-1,  line, {type=3})
		elseif c == "0" then --1-d
			set_floor("fl-gradient",  i-1,  line, {type=1})
		elseif c == ";" then --4-l
			set_floor("fl-gradient",  i-1,  line, {type=4})
		elseif c == "k" then --1-dl
			set_floor("fl-gradient",  i-1,  line, {type=11})
		elseif c == "m" then --3-dr
			set_floor("fl-gradient",  i-1,  line, {type=9})
		elseif c == "q" then --7-ul
			set_floor("fl-gradient",  i-1,  line, {type=12})
		elseif c == "s" then --9-ur
			set_floor("fl-gradient",  i-1,  line, {type=10})
		elseif c == "t" then --9-ur
		   set_stone("st-timer",  i-1,  line, {loop=1,interval=.45,name="tt",action="callback",target="funcctchange"})
		elseif c=="C" then
			set_attrib(laser(i-1,line, FALSE, EAST), "name", "laser1")
 		elseif c=="/" then
 			mirrorp(i-1,line,FALSE,FALSE, 4)
 		elseif c==":" then
 			mirrorp(i-1,line,FALSE,FALSE, 2)
 		elseif c=="?" then
 			mirrorp(i-1,line,FALSE,TRUE, 4)
 		elseif c=="." then
 			mirrorp(i-1,line,FALSE,TRUE, 2)
		elseif c=="T" then
		   set_item("it-trigger",i-1,line,{action="callback",target="funcctstart"})
		elseif c=="H" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if pos1==1 then

		   elseif pos1==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos1==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos1==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
end
		elseif c=="I" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if pos2==1 then

		   elseif pos2==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos2==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos2==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="J" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if pos3==1 then

		   elseif pos3==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos3==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos3==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="K" then
		   set_stone("st-fourswitch",i-1,line,{name="cs",action="callback",target="funcc1"})
		   if pos4==1 then

		   elseif pos4==2 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos4==3 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   elseif pos4==4 then
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		      enigma.SendMessage(enigma.GetNamedObject("cs"),"trigger",nil)
		   end
		elseif c=="M" then
		   set_stone("st-fourswitch",i-1,line,{name=("ssa"..msnum),action="callback",target=("funccxm"..msnum)})
msnum=msnum+1
		elseif c=="N" then
		   set_stone("st-fourswitch",i-1,line,{name=("ssb"..nsnum),action="callback",target=("funccxn"..nsnum)})
nsnum=nsnum+1
		elseif c=="O" then
		   set_stone("st-fourswitch",i-1,line,{name=("ssc"..osnum),action="callback",target=("funccxo"..osnum)})
osnum=osnum+1
		elseif c=="P" then
		   set_stone("st-fourswitch",i-1,line,{name=("ssd"..psnum),action="callback",target=("funccxp"..psnum)})
psnum=psnum+1
	     end
	end	
end

renderLine(00,"#############################################################################################################################################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##############################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ")
renderLine(01,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!QQQQQQQQQQQQ!!!!!!!!!!!!!#/w       Cwwwwwwwwwwwwwww..:#!!!!!!!!m00000000000000000000000000000000000k!!!!!!!!!!!!!! ")
renderLine(02,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!QQQQQQQQQ!!!!!!!!!!Q!!!!!!!!!!!!!#ww  www   wHwKwJwHwKwIwHwwww#!!!!!!!!6QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ;!!!!!!!!!!!!!! ")
renderLine(03,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!#    wew   wwwwwwwwwwwwwww   #!!!!!!!!6QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQoQ;!!!!!!!!!!!!!! ")
renderLine(04,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!!!m00000k!!!!!!!!!!#    www   wKwHwIwKwHwJwKw   #!!!!!!!!6QQq8888888888888888888888888888sQQQ;!!!!!!!!!!!!!! ")
renderLine(05,"#    wwwwwwwwwwwwwwwwwwwwwwwwwwwww               #  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                               #!!!!!!!!q8s!!!!!!q8s!!!!!!Q!!!!!!!!!!!!!!!6QQQQQ;!!!!!!!!!!#    wfw   wwwwwwwwwwwwwww   #!!!!!!!!6QQ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!s888q!!!!!!!!!!!!!! ")
renderLine(06,"#  z wULLDRURLRURDLLULLDRURURDLLLw  drurdldrd    A  w114w123w132w141w144w213w222w231w234w243w312w321w324w333w c`b `aa `a` `bc `cb ``a ```   BQQQQQQQQ;Q6QQQQQQ;Q6QQQQQQQ!!!!!!!!!!!!!!!6QQQQQ;QQQQQQQQQQT    www   wJwHwKwIwHwKwJw   5QQQQQQQQ6QQ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!t")
renderLine(07,"#    wwwwwwwwwwwwwwwwwwwwwwwwwwwww               #  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                               #!!!!!!!!k0m!!!!!!k0m!!!!!!Q!!!!!!!!!!!!!!!6QQQQQ;!!!!!!!!!!#    wGw   wwwwwwwwwwwwwww   #!!!!!!!!6QQ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!m000k!!!!!!!!!!!!!! ")
renderLine(08,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!!!s88888q!!!!!!!!!!#    www   wHwJwP M N P M    #!!!!!!!!6QQk0000000000000000000000000000mQQQ;!!!!!!!!!!!!!! ")
renderLine(09,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!!!!!!Q!!!!!!!!!!!!!#    whw   wwwww             #!!!!!!!!6QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQoQ;!!!!!!!!!!!!!! ")
renderLine(10,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!QQQQQQQQQ!!!!!!!!!!Q!!!!!!!!!!!!!#ww  www    P N M P O M P  ww#!!!!!!!!6QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ;!!!!!!!!!!!!!! ")
renderLine(11,"#                                                #                                                                                          #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!QQQQQQQQQQQQ!!!!!!!!!!!!!#:w                        w/#!!!!!!!!s88888888888888888888888888888888888q!!!!!!!!!!!!!! ")
renderLine(12,"#############################################################################################################################################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##############################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ")


--                                                 DRURDLDRD                                                                 342 411 414 423 432 441 444                                                                  4 1 2 4 1                                                              
--                                                                                                                                                                                                                                                                                               
--                                                 321234323                                                                                                                                                          4 2 1 4 3 1 4                                                              


oxyd_shuffle()

display.SetFollowMode(display.FOLLOW_SCROLLING)

enigma.SendMessage(enigma.GetNamedObject("tt"),"off",nil)

-- ff1=2
function funcc1()
--    if ff1==1 then
--       ff1=2
--    elseif ff1==2 then
--       ff1=3
--    elseif ff1==3 then
--       ff1=4
--    elseif ff1==4 then
--       ff1=1
--    end
end

fnum=1

ffa1=1
function funcca1()
   ffa1=ffa1+1
   if ffa1==5 then
      ffa1=1
   end
   funcccheck1()
end

ffb1=1
function funccb1()
   ffb1=ffb1+1
   if ffb1==5 then
      ffb1=1
   end
   funcccheck1()
end

ffb2=1
function funccb2()
   ffb2=ffb2+1
   if ffb2==5 then
      ffb2=1
   end
   funcccheck1()
end

ffb3=1
function funccb3()
   ffb3=ffb3+1
   if ffb3==5 then
      ffb3=1
   end
   funcccheck1()
end

ffc1=1
function funccc1()
   ffc1=ffc1+1
   if ffc1==5 then
      ffc1=1
   end
   funcccheck1()
end

ffc2=1
function funccc2()
   ffc2=ffc2+1
   if ffc2==5 then
      ffc2=1
   end
   funcccheck1()
end

ffc3=1
function funccc3()
   ffc3=ffc3+1
   if ffc3==5 then
      ffc3=1
   end
   funcccheck1()
end

ffc4=1
function funccc4()
   ffc4=ffc4+1
   if ffc4==5 then
      ffc4=1
   end
   funcccheck1()
end

ffd1=1
function funccd1()
   ffd1=ffd1+1
   if ffd1==5 then
      ffd1=1
   end
   funcccheck1()
end

ffcheck1=0

function funcccheck1()
if ffcheck1==1 then
enigma.SendMessage(enigma.GetNamedObject("door1"),"close",nil)
ffcheck1=0
end
if ffa1==1 and ffb1==2 and ffb2==2 and ffb3==2 and ffc1==3 and ffc2==3 and ffc3==3 and ffc4==3 and ffd1==4 and ffcheck1==0 then
   enigma.SendMessage(enigma.GetNamedObject("door1"),"open",nil)
ffcheck1=1
end
end

-- 4,3,3,11

ffqa1=1
function funccqa1()
   ffqa1=ffqa1+1
   if ffqa1==5 then
      ffqa1=1
   end
   funcccheck2()
end


ffqa2=1
function funccqa2()
   ffqa2=ffqa2+1
   if ffqa2==5 then
      ffqa2=1
   end
   funcccheck2()
end

ffqa3=1
function funccqa3()
   ffqa3=ffqa3+1
   if ffqa3==5 then
      ffqa3=1
   end
   funcccheck2()
end

ffqa4=1
function funccqa4()
   ffqa4=ffqa4+1
   if ffqa4==5 then
      ffqa4=1
   end
   funcccheck2()
end

ffqb1=1
function funccqb1()
   ffqb1=ffqb1+1
   if ffqb1==5 then
      ffqb1=1
   end
   funcccheck2()
end


ffqb2=1
function funccqb2()
   ffqb2=ffqb2+1
   if ffqb2==5 then
      ffqb2=1
   end
   funcccheck2()
end

ffqb3=1
function funccqb3()
   ffqb3=ffqb3+1
   if ffqb3==5 then
      ffqb3=1
   end
   funcccheck2()
end

ffqc1=1
function funccqc1()
   ffqc1=ffqc1+1
   if ffqc1==5 then
      ffqc1=1
   end
   funcccheck2()
end


ffqc2=1
function funccqc2()
   ffqc2=ffqc2+1
   if ffqc2==5 then
      ffqc2=1
   end
   funcccheck2()
end

ffqc3=1
function funccqc3()
   ffqc3=ffqc3+1
   if ffqc3==5 then
      ffqc3=1
   end
   funcccheck2()
end

ffqd1=1
function funccqd1()
   ffqd1=ffqd1+1
   if ffqd1==5 then
      ffqd1=1
   end
   funcccheck2()
end


ffqd2=1
function funccqd2()
   ffqd2=ffqd2+1
   if ffqd2==5 then
      ffqd2=1
   end
   funcccheck2()
end

ffqd3=1
function funccqd3()
   ffqd3=ffqd3+1
   if ffqd3==5 then
      ffqd3=1
   end
   funcccheck2()
end

ffqd4=1
function funccqd4()
   ffqd4=ffqd4+1
   if ffqd4==5 then
      ffqd4=1
   end
   funcccheck2()
end

ffqd5=1
function funccqd5()
   ffqd5=ffqd5+1
   if ffqd5==5 then
      ffqd5=1
   end
   funcccheck2()
end

ffqd6=1
function funccqd6()
   ffqd6=ffqd6+1
   if ffqd6==5 then
      ffqd6=1
   end
   funcccheck2()
end

ffqd7=1
function funccqd7()
   ffqd7=ffqd7+1
   if ffqd7==5 then
      ffqd7=1
   end
   funcccheck2()
end

ffqd8=1
function funccqd8()
   ffqd8=ffqd8+1
   if ffqd8==5 then
      ffqd8=1
   end
   funcccheck2()
end

ffqd9=1
function funccqd9()
   ffqd9=ffqd9+1
   if ffqd9==5 then
      ffqd9=1
   end
   funcccheck2()
end

ffqd10=1
function funccqd10()
   ffqd10=ffqd10+1
   if ffqd10==5 then
      ffqd10=1
   end
   funcccheck2()
end

ffqd11=1
function funccqd11()
   ffqd11=ffqd11+1
   if ffqd11==5 then
      ffqd11=1
   end
   funcccheck2()
end

ffcheck2=0

function funcccheck2()
   z=zeropos
     if ffqa1==z and ffqa2==z and ffqa3==z and ffqa4==z then
        if ((ffqb1==z+1 and ffqb2==z+1 and ffqb3==z+1) or (ffqb1==z-3 and ffqb2==z-3 and ffqb3==z-3)) then
  	 if ((ffqc1==z+2 and ffqc2==z+2 and ffqc3==z+2) or (ffqc1==z-2 and ffqc2==z-2 and ffqc3==z-2)) then
  	    if ((ffqd1==z+3 and ffqd2==z+3 and ffqd3==z+3 and ffqd4==z+3 and ffqd5==z+3 and ffqd6==z+3 and ffqd7==z+3 and ffqd8==z+3 and ffqd9==z+3 and ffqd10==z+3 and ffqd11==z+3) or (ffqd1==z-1 and ffqd2==z-1 and ffqd3==z-1 and ffqd4==z-1 and ffqd5==z-1 and ffqd6==z-1 and ffqd7==z-1 and ffqd8==z-1 and ffqd9==z-1 and ffqd10==z-1 and ffqd11==z-1)) then
  	       if ffcheck2==0 then
  		  enigma.SendMessage(enigma.GetNamedObject("door2"),"open",nil)
  		  ffcheck2=1
  	       else
  		  enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
  		  ffcheck2=0
  	       end
  	    else
  	       enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
  	       ffcheck2=0
  	    end
  	 else
  	    enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
  	    ffcheck2=0
  	 end
        else
  	 enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
  	 ffcheck2=0
        end
     else
        enigma.SendMessage(enigma.GetNamedObject("door2"),"close",nil)
        ffcheck2=0
   end
end


tstart1=1
tstart2=1
tstart3=1
tstart4=1

tpos1=1

function funcct1()
tstart1=0
   tpos1=tpos1+1
   if tpos1==5 then
      tpos1=1
   end
--   funcctcheck()
end


tpos2=1

function funcct2()
tstart2=0
   tpos2=tpos2+1
   if tpos2==5 then
      tpos2=1
   end
--   funcctcheck()
end


tpos3=1

function funcct3()
tstart3=0
   tpos3=tpos3+1
   if tpos3==5 then
      tpos3=1
   end
--   funcctcheck()
end


tpos4=1

function funcct4()
tstart4=0
   tpos4=tpos4+1
   if tpos4==5 then
      tpos4=1
   end
--   funcctcheck()
end

changet=0

fftchange=0

function funcctchange()
    if changet==1 then
       enigma.SendMessage(enigma.GetNamedObject("t1"),"trigger",nil)
       if tpos1==1 and tstart1==0 then
 	 enigma.SendMessage(enigma.GetNamedObject("t2"),"trigger",nil)
 	 if tpos2==1 and tstart2==0 then
 	    enigma.SendMessage(enigma.GetNamedObject("t3"),"trigger",nil)
 	    if tpos3==1 and tstart3==0 then
 	       enigma.SendMessage(enigma.GetNamedObject("t4"),"trigger",nil)
 	       if tpos4==1 and tstart4==0 then
  		  if fftchange==0 then
  		     enigma.SendMessage(enigma.GetNamedObject("laser1"),"on",nil)
  		     changet=0
  		     fftchange=1
  		  end
 	       end
 	    end
 	 end
       end
    end
end

ffs=0

function funcctstart()
    if changet==0 and ffs==0 then
       changet=1
       ffs=1
       enigma.SendMessage(enigma.GetNamedObject("tt"),"on",nil)
    end
end

ffc=0
   
function funcctcheck()
   if tpos4==3 and ffc==0 then
      enigma.SendMessage(enigma.GetNamedObject("laser1"),"on",nil)
      ffc=1
   end
end


-- 4,2,1,5

ffxm1=1
function funccxm1()
   ffxm1=ffxm1+1
   if ffxm1==5 then
      ffxm1=1
   end
   funcccheck3()
end

ffxm2=1
function funccxm2()
   ffxm2=ffxm2+1
   if ffxm2==5 then
      ffxm2=1
   end
   funcccheck3()
end

ffxm3=1
function funccxm3()
   ffxm3=ffxm3+1
   if ffxm3==5 then
      ffxm3=1
   end
   funcccheck3()
end

ffxm4=1
function funccxm4()
   ffxm4=ffxm4+1
   if ffxm4==5 then
      ffxm4=1
   end
   funcccheck3()
end

ffxn1=1
function funccxn1()
   ffxn1=ffxn1+1
   if ffxn1==5 then
      ffxn1=1
   end
   funcccheck3()
end

ffxn2=1
function funccxn2()
   ffxn2=ffxn2+1
   if ffxn2==5 then
      ffxn2=1
   end
   funcccheck3()
end

ffxo1=1
function funccxo1()
   ffxo1=ffxo1+1
   if ffxo1==5 then
      ffxo1=1
   end
   funcccheck3()
end

ffxp1=1
function funccxp1()
   ffxp1=ffxp1+1
   if ffxp1==5 then
      ffxp1=1
   end
   funcccheck3()
end

ffxp2=1
function funccxp2()
   ffxp2=ffxp2+1
   if ffxp2==5 then
      ffxp2=1
   end
   funcccheck3()
end

ffxp3=1
function funccxp3()
   ffxp3=ffxp3+1
   if ffxp3==5 then
      ffxp3=1
   end
   funcccheck3()
end

ffxp4=1
function funccxp4()
   ffxp4=ffxp4+1
   if ffxp4==5 then
      ffxp4=1
   end
   funcccheck3()
end

ffxp5=1
function funccxp5()
   ffxp5=ffxp5+1
   if ffxp5==5 then
      ffxp5=1
   end
   funcccheck3()
end

ffcheck3=0

function funcccheck3()
   if ffxm1==pos1 and ffxm2==pos1 and ffxm3==pos1 and ffxm4==pos1 and ffxn1==pos2 and ffxn2==pos2 and ffxo1==pos3 and ffxp1==pos4 and ffxp2==pos4 and ffxp3==pos4 and ffxp4==pos4 and ffxp5==pos4 and ffcheck3==0 then
      enigma.SendMessage(enigma.GetNamedObject("door3"),"open",nil)
      ffcheck3=1
   else
      if ffcheck3==1 then
	 enigma.SendMessage(enigma.GetNamedObject("door3"),"close",nil)
	 ffcheck3=0
      end
   end
end
