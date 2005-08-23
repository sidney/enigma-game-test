-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Happy New Year

levelw=21
levelh=13

create_world( levelw, levelh)

f1=random(3)
f2=random(3)
f3=random(3)

while f2==f1 do
    f2=random(3)
end

while f3==f2 or f3==f1 do
    f3=random(3)
end

f1=f1-1
f2=f2-1
f3=f3-1

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
            set_floor("fl-space",i-1,line)
            set_stone("st-invisible",i-1,line)
        elseif c == "$" then
            set_floor("fl-ice_001",i-1,line)
            set_stone("st-invisible",i-1,line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c == "~" then
            set_floor("fl-water",i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-1,line, {player=0})
            set_floor("fl-ice_001",i-1,line)
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="I" then
            set_floor("fl-ice_001",i-1,line)
        elseif c == "A" then
            set_stone("st-oxyd",i-1,line,{color="0"})
        elseif c == "B" then
            set_stone("st-oxyd",i-1,line,{color="1"})
        elseif c == "C" then
            set_stone("st-oxyd",i-1,line,{color="2"})
        elseif c == "J" then
            set_stone("st-oxyd",i-1,line,{color="6",name="oxyd1"})
        elseif c == "K" then
            set_stone("st-oxyd",i-1,line,{color="6",name="oxyd2"})
        elseif c == "L" then
            set_stone("st-oxyd",i-1,line,{color="6",name="oxyd3"})
        elseif c == "a" then
            set_stone("st-switch", i-1,line, {action="callback",target="funcc1"})
            set_floor("fl-ice_001",i-1,line)
        elseif c == "b" then
            set_stone("st-switch", i-1,line, {action="callback",target="funcc2"})
            set_floor("fl-ice_001",i-1,line)
        elseif c == "c" then
            set_stone("st-switch", i-1,line, {action="callback",target="funcc3"})
            set_floor("fl-ice_001",i-1,line)
        end
    end
end

renderLine(00,"%%%%%%%%%%%%%%%%%%%% ")
renderLine(01,"%==================% ")
renderLine(02,"%==================% ")
renderLine(03,"%==================% ")
renderLine(04,"%==================% ")
renderLine(05,"%==================% ")
renderLine(06,"%==================% ")
renderLine(07,"%==================% ")
renderLine(08,"%==================% ")
renderLine(09,"$IIIIIIIIIIIIIIIIII$ ")
renderLine(10,"$IIIIIIIIIIIIIIIIII$J")
renderLine(11,"$IIIIIIIIIzIIIIIIII$K")
renderLine(12,"$$$$a$$$$$b$$$$c$$$$L")

ff1=0
function funcc1()
    if ff1==0 then
        ff1=1
    end
end

ff2=0
function funcc2()
    if ff2==0 then
        ff2=1
    end
end

ff3=0
function funcc3()
    if ff3==0 then
        ff3=1
    end
end

tt=0
th=0
function timer_handler()
    tt=tt+1
    if ff1==1 and th==0 then
        tt=0
        th=1
    end
    if th==1 then
        if tt==10 then
            set_stone("st-fakeoxyd",4,8)
        elseif tt==12 then
            set_stone("st-fakeoxyd",4,7)
            enigma.KillStone(4,8)
        elseif tt==14 then
            set_stone("st-fakeoxyd",4,6)
            enigma.KillStone(4,7)
        elseif tt==16 then
            set_stone("st-fakeoxyd",4,5)
            enigma.KillStone(4,6)
        elseif tt==18 then
            set_stone("st-fakeoxyd",4,4)
            enigma.KillStone(4,5)
        elseif tt==20 then
            if f1==0 then
                set_stone("st-oxyd",4,2,{color="0"})
                set_stone("st-oxyd",3,3,{color="0"})
                set_stone("st-oxyd",5,3,{color="0"})
                set_stone("st-oxyd",2,4,{color="0"})
                set_stone("st-oxyd",6,4,{color="0"})
                set_stone("st-oxyd",3,5,{color="0"})
                set_stone("st-oxyd",5,5,{color="0"})
                set_stone("st-oxyd",4,6,{color="0"})
            elseif f1==1 then
                set_stone("st-oxyd",4,2,{color="1"})
                set_stone("st-oxyd",3,3,{color="1"})
                set_stone("st-oxyd",5,3,{color="1"})
                set_stone("st-oxyd",2,4,{color="1"})
                set_stone("st-oxyd",6,4,{color="1"})
                set_stone("st-oxyd",3,5,{color="1"})
                set_stone("st-oxyd",5,5,{color="1"})
                set_stone("st-oxyd",4,6,{color="1"})
            elseif f1==2 then
                set_stone("st-oxyd",4,2,{color="2"})
                set_stone("st-oxyd",3,3,{color="2"})
                set_stone("st-oxyd",5,3,{color="2"})
                set_stone("st-oxyd",2,4,{color="2"})
                set_stone("st-oxyd",6,4,{color="2"})
                set_stone("st-oxyd",3,5,{color="2"})
                set_stone("st-oxyd",5,5,{color="2"})
                set_stone("st-oxyd",4,6,{color="2"})
            end
            SendMessage(set_stone("st-oxyd",4,4,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",3,4,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",4,3,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",5,4,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",4,5,{color="6"}),"trigger")
            SendMessage("oxyd1","trigger")
            abyss(3,4)
            abyss(5,4)
            abyss(4,3)
            abyss(4,5)
            abyss(4,4)
            abyss(4,2)
            abyss(3,3)
            abyss(5,3)
            abyss(2,4)
            abyss(6,4)
            abyss(3,5)
            abyss(5,5)
            abyss(4,6)
        end
    end
end

tt2=0
th2=0
function timer_handler2()
    tt2=tt2+1
    if ff2==1 and th2==0 then
        tt2=0
        th2=1
    end
    if th2==1 then
        if tt2==10 then
            set_stone("st-fakeoxyd",10,8)
        elseif tt2==12 then
            set_stone("st-fakeoxyd",10,7)
            enigma.KillStone(10,8)
        elseif tt2==14 then
            set_stone("st-fakeoxyd",10,6)
            enigma.KillStone(10,7)
        elseif tt2==16 then
            set_stone("st-fakeoxyd",10,5)
            enigma.KillStone(10,6)
        elseif tt2==18 then
            set_stone("st-fakeoxyd",10,4)
            enigma.KillStone(10,5)
        elseif tt2==20 then
            set_stone("st-fakeoxyd",10,3)
            enigma.KillStone(10,4)
        elseif tt2==22 then
            if f2==0 then
                set_stone("st-oxyd",10,2,{color="0"})
                set_stone("st-oxyd",10,4,{color="0"})
                set_stone("st-oxyd",11,3,{color="0"})
                set_stone("st-oxyd",9,3,{color="0"})
            elseif f2==1 then
                set_stone("st-oxyd",10,2,{color="1"})
                set_stone("st-oxyd",10,4,{color="1"})
                set_stone("st-oxyd",11,3,{color="1"})
                set_stone("st-oxyd",9,3,{color="1"})
            elseif f2==2 then
                set_stone("st-oxyd",10,2,{color="2"})
                set_stone("st-oxyd",10,4,{color="2"})
                set_stone("st-oxyd",11,3,{color="2"})
                set_stone("st-oxyd",9,3,{color="2"})
            end
            SendMessage(set_stone("st-oxyd",10,3,{color="6"}),"trigger")
            SendMessage("oxyd2","trigger")
            abyss(10,3)
            abyss(10,2)
            abyss(10,4)
            abyss(11,3)
            abyss(9,3)
        end
    end
end

tt3=0
th3=0
function timer_handler3()
    tt3=tt3+1
    if ff3==1 and th3==0 then
        tt3=0
        th3=1
    end
    if th3==1 then
        if tt3==10 then
            set_stone("st-fakeoxyd",15,8)
        elseif tt3==12 then
            set_stone("st-fakeoxyd",15,7)
            enigma.KillStone(15,8)
        elseif tt3==14 then
            set_stone("st-fakeoxyd",15,6)
            enigma.KillStone(15,7)
        elseif tt3==16 then
            set_stone("st-fakeoxyd",15,5)
            enigma.KillStone(15,6)
        elseif tt3==18 then
            if f3==0 then
                set_stone("st-oxyd",15,3,{color="0"})
                set_stone("st-oxyd",14,4,{color="0"})
                set_stone("st-oxyd",16,4,{color="0"})
                set_stone("st-oxyd",13,5,{color="0"})
                set_stone("st-oxyd",17,5,{color="0"})
                set_stone("st-oxyd",14,6,{color="0"})
                set_stone("st-oxyd",16,6,{color="0"})
                set_stone("st-oxyd",15,7,{color="0"})
            elseif f3==1 then
                set_stone("st-oxyd",15,3,{color="1"})
                set_stone("st-oxyd",14,4,{color="1"})
                set_stone("st-oxyd",16,4,{color="1"})
                set_stone("st-oxyd",13,5,{color="1"})
                set_stone("st-oxyd",17,5,{color="1"})
                set_stone("st-oxyd",14,6,{color="1"})
                set_stone("st-oxyd",16,6,{color="1"})
                set_stone("st-oxyd",15,7,{color="1"})
            elseif f3==2 then
                set_stone("st-oxyd",15,3,{color="2"})
                set_stone("st-oxyd",14,4,{color="2"})
                set_stone("st-oxyd",16,4,{color="2"})
                set_stone("st-oxyd",13,5,{color="2"})
                set_stone("st-oxyd",17,5,{color="2"})
                set_stone("st-oxyd",14,6,{color="2"})
                set_stone("st-oxyd",16,6,{color="2"})
                set_stone("st-oxyd",15,7,{color="2"})
            end
            SendMessage(set_stone("st-oxyd",15,4,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",14,5,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",15,6,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",16,5,{color="6"}),"trigger")
            SendMessage(set_stone("st-oxyd",15,5,{color="6"}),"trigger")
            SendMessage("oxyd3","trigger")
            abyss(14,5)
            abyss(16,5)
            abyss(15,4)
            abyss(15,6)
            abyss(15,5)
            abyss(15,3)
            abyss(14,4)
            abyss(16,4)
            abyss(13,5)
            abyss(17,5)
            abyss(14,6)
            abyss(16,6)
            abyss(15,7)
        end
    end
end

set_stone( "st-timer", 20, 0, {loop=1, action="callback", target="timer_handler",interval=.1})

set_stone( "st-timer", 20, 1, {loop=1, action="callback", target="timer_handler2",interval=.1})

set_stone( "st-timer", 20, 2, {loop=1, action="callback", target="timer_handler3",interval=.1})

enigma.AddConstantForce(0,10)