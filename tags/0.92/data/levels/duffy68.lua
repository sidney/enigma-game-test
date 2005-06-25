-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: What a Mess

levelw=20
levelh=13

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

fill_floor("fl-leaves", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="T" then
            set_stone( "st-thief", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "&" then
            set_floor("fl-water",i-1,line)
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "%" then
            set_stone( "st-block", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c == "~" then
            set_floor("fl-water",i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-1,line)
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c == "u" then
            set_stone("st-bolder-n", i-1,line)
        elseif c == "r" then
            set_stone("st-bolder-e", i-1,line)
        elseif c == "d" then
            set_stone("st-bolder-s", i-1,line)
        elseif c == "l" then
            set_stone("st-bolder-w", i-1,line)
        elseif c=="D" then
            set_stone("st-oneway-s", i-1,line)	
        elseif c=="L" then
            set_stone("st-oneway-w", i-1,line)
        elseif c=="R" then
            set_stone("st-oneway-e", i-1,line)
        elseif c=="U" then
            set_stone("st-oneway-n", i-1,line)
        elseif c=="V" then
            set_stone("st-oneway-n", i-1,line)
            set_item("it-blackbomb",i-1,line)
        elseif c =="^" then
            set_stone( "st-greenbrown", i-1, line)
            set_item("it-blackbomb",i-1,line)
        elseif c =="b" then
            set_item("it-blackbomb",i-1,line)
        elseif c == "S" then
            set_item("it-ring",i-1,line)
        elseif c=="f" then	
            set_item("it-floppy", i-1,line)
        elseif c=="F" then
            set_stone( "st-floppy", i-1,line,{action="callback",target="funcc1"})
        elseif c=="k" then
            set_item("it-key_a", i-1,line)
        elseif c=="K" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc2"})
        elseif c == "1" then
            set_stone("st-door_a", i-1,line, {name="door1", type="h"})
        elseif c == "2" then
            set_stone("st-door_a", i-1,line, {name="door2", type="h"})
        elseif c == "3" then
            set_stone("st-door_a", i-1,line, {name="door3", type="h"})
        elseif c == "4" then
            set_stone("st-door_a", i-1,line, {name="door4", type="h"})
        elseif c=="A" then
            puzzle(i-1,line,PUZ_0100)
        elseif c=="B" then
            puzzle(i-1,line,PUZ_0000)
        elseif c=="C" then
            puzzle(i-1,line,PUZ_0001)
        elseif c=="I" then
            puzzle(i-1,line,PUZ_0011)
        elseif c=="J" then
            puzzle(i-1,line,PUZ_1000)
        elseif c=="s" then
            set_stone( "st-stoneimpulse", i-1, line)
        end
    end
end

renderLine(00,"sssTTTT#######ssssss")
renderLine(01,"s+ T===R    L ABCAIs")
renderLine(02,"sb+ !T###DD###   J##")
renderLine(03,"#^#V###      ###U###")
renderLine(04,"sbbb  #      #     #")
renderLine(05,"s+  ++L      R     #")
renderLine(06,"s+ + +L   z  R * * #")
renderLine(07,"s+  + #      #  *  #")
renderLine(08,"#~~~~~#      # *u* #")
renderLine(09,"#~~~~~###12###!u*u!#")
renderLine(10,"#&~~~&#o#34#o#!*u*!#")
renderLine(11,"#f~~~SK      FSu uk#")
renderLine(12,"####################")

oxyd_shuffle()

function funcc1()
    SendMessage("door1","openclose")
    SendMessage("door2","openclose")
end

function funcc2()
   SendMessage("door3","openclose")
   SendMessage("door4","openclose")
end
