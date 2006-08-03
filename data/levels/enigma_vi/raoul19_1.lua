-- Zeus - The master of flashes, a level for Enigma
-- Copyright (C) 2006 Raoul Bourquin
-- Licensed under GPL v2.0 or above

enigma.ConserveLevel = TRUE
enigma.FrictionFactor = 0.5

CreateWorld(20,13)
oxyd_default_flavor = "d"

function writeLine( line, cells)
  for i=1, strlen(cells) do
    local c = strsub(cells,i,i)

    if(c =="#") then
      set_stone("st-blue-sand",i-1,line)

    elseif(c == "-") then
      set_floor("fl-rough",i-1,line)

    elseif(c == " ") then
      set_floor("fl-water",i-1,line)

    elseif(c == "e") then
      set_stone("st-white4",i-1,line)
      set_floor("fl-rough",i-1,line)

    elseif(c == "x") then
      set_stone("st-grate1",i-1,line)
      set_floor("fl-rough",i-1,line)

    elseif(c =="o") then
      oxyd(i-1,line)
      set_floor("fl-rough",i-1,line)

    elseif(c =="f") then
      set_stone("st-flash",i-1,line)

    elseif c =="A" then
        set_stone("st-bigbluesand-n", i-1, line)
    elseif c == "B" then
        set_stone("st-bigbluesand-e", i-1, line)
    elseif c == "C" then
        set_stone("st-bigbluesand-s", i-1, line)
    elseif c == "D" then
        set_stone("st-bigbluesand-w", i-1, line)

    elseif c == "E" then
        set_stone("st-bigbluesand-ne", i-1, line)
    elseif c == "F" then
        set_stone("st-bigbluesand-es", i-1, line)
    elseif c == "G" then
        set_stone("st-bigbluesand-sw", i-1, line)
    elseif c == "H" then
        set_stone("st-bigbluesand-nw", i-1, line)

    elseif c == "I" then
        set_stone("st-bigbluesand-ew", i-1, line)
    elseif c == "J" then
        set_stone("st-bigbluesand-ns", i-1, line)

    elseif c =="L" then
        set_stone( "st-bigbluesand-esw", i-1, line)
    elseif c == "M" then
        set_stone( "st-bigbluesand-nsw", i-1, line)
    elseif c == "N" then
        set_stone( "st-bigbluesand-new", i-1, line)
    elseif c == "O" then
        set_stone( "st-bigbluesand-nes", i-1, line)

    elseif c == "P" then
        set_stone( "st-bigbluesand-nesw", i-1, line)

    end
  end
end

if not difficult then
  writeLine(00,"FIIID##########BIIIG")
  writeLine(01,"J---x----------x---J")
  writeLine(02,"J-o-#   BIIIG  C-o-J")
  writeLine(03,"J---x---x---J  J---J")
  writeLine(04,"OIIID   #-o-J  EIDxA")
  writeLine(05,"J---x---x---J     -#")
  writeLine(06,"J-o-# BIIILIHFIIIDeC")
  writeLine(07,"J---x-x---J  J-----J")
  writeLine(08,"OIIID #-o-J  J-----J")
  writeLine(09,"J---x-x---J  J--f--J")
  writeLine(10,"J-o-# BIIIH  A-----J")
  writeLine(11,"J---x--------e-----J")
  writeLine(12,"EIIID########BIIIIIH")
else
  writeLine(00,"FD#BD##########BD#BG")
  writeLine(01,"A------------------A")
  writeLine(02,"#-o-    BD BG   -o-#")
  writeLine(03,"C-----------A  C---C")
  writeLine(04,"OD BD    -o-   ED -A")
  writeLine(05,"A-----------C     -#")
  writeLine(06,"#-o-  BDBIGBHFID##eC")
  writeLine(07,"C---------A  J-----J")
  writeLine(08,"OD BD  -o-   A-----A")
  writeLine(09,"A---------C  #--f--#")
  writeLine(10,"#-o-  BD BH  #-----C")
  writeLine(11,"C------------e-----J")
  writeLine(12,"ED#BD########BID#BIH")
end

set_actor("ac-blackball",18.5,11.5,{player="0"})
set_actor("ac-whiteball",14.5,7.5)

oxyd_shuffle()

