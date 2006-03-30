-- Designed with love
-- JuSt 20.01.2005 Rev.1

levelw = 58
levelh = 49

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE
fill_floor("fl-sahara", 0,0, level_width,level_height)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "#" then
          set_stone("st-rock3",i-1,line)
      elseif c == "y" then
          set_stone("st-rock3_hole",i-1,line)
      elseif c == "Y" then
          set_stone("st-rock3_hole",i-1,line)
          set_item("it-wormhole", i-1, line, {strength=1,targetx="45.5",targety="3.5", name="wh1"})
      elseif c == "Z" then
          set_stone("st-rock3_hole",i-1,line)
          set_item("it-hammer",i-1,line)
      elseif c == "W" then
          set_stone("st-rock3_hole",i-1,line)
          set_item("it-magicwand",i-1,line)
      elseif c == "1" then
	    set_item("it-wormhole", i-1, line, {strength=1,targetx="24.5",targety="1.5", name="wh2"})
      elseif c == "2" then
    	    set_item("it-wormhole", i-1, line, {strength=1,targetx="13.5",targety="47.5", name="wh3"})
      elseif c == "3" then
    	    set_item("it-wormhole", i-1, line, {strength=1,targetx="54.5",targety="25.5", name="wh4"})
      elseif c == "+" then
          set_item("it-coin1",i-1, line)
      elseif c == "*" then
          set_item("it-coin2",i-1, line)
      elseif c == "v" then
          set_stone("st-oneway", i-1, line, {orientation=SOUTH})
      elseif c == "o" then
          set_stone("st-glass", i-1, line)
      elseif c == "/" then
          mirrorp(i-1,line,FALSE,FALSE, 2)
	elseif c=="_" then
	    set_stone( "st-wood", i-1, line)
      elseif c == "a" then
          doorh(i-1, line, {name="door1"} )
      elseif c == "b" then
          doorv(i-1, line, {name="door2"} )
      elseif c == "c" then
          doorh(i-1, line, {name="door3"} )
      elseif c == "d" then
          doorv(i-1, line, {name="door4"} )
      elseif c == "e" then
          doorv(i-1, line, {name="door5"} )
      elseif c == "f" then
          doorh(i-1, line, {name="door6"} )
      elseif c == "g" then
          doorh(i-1, line, {name="door7"} )
      elseif c == "h" then
          doorv(i-1, line, {name="door8"} )
      elseif c == "i" then
          doorh(i-1, line, {name="door9"} )
      elseif c == "j" then
          doorh(i-1, line, {name="door10"} )
      elseif c == "k" then
          doorv(i-1, line, {name="door11"} )
      elseif c == "l" then
          doorv(i-1, line, {name="door12"} )
      elseif c == "m" then
          doorv(i-1, line, {name="door13"} )
      elseif c == "A" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door1"})
      elseif c == "B" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door2"})
      elseif c == "C" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door3"})
      elseif c == "D" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door4"})
      elseif c == "E" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door5"})
      elseif c == "F" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door6"})
      elseif c == "G" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door7"})
      elseif c == "H" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door8"})
      elseif c == "I" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door9"})
      elseif c == "J" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door10"})
      elseif c == "K" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door11"})
      elseif c == "L" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door12"})
      elseif c == "M" then
          set_stone( "st-coinslot", i-1, line, {action="openclose", target="door13"})
      elseif c == "?" then
          set_stone("st-rock3_break", i-1, line)
      elseif c == "$" then
          set_stone("st-rock3_hole",i-1,line)
          set_item ("it-dynamite", i-1, line)
      elseif c == "S" then
          set_stone("st-switch", i-1,line, {action="callback",target="funcc"})
      elseif c == "." then
          set_floor("fl-swamp", i-1, line)
      elseif c == "," then
          set_floor("fl-swamp", i-1, line)
          set_item("it-seed", i-1, line)
      elseif c == "0" then
          set_stone("st-death", i-1, line)
      elseif c == "-" then
          set_item("it-trigger", i-1,line, {invisible=1, action="callback", target="s1"})
      elseif c == "|" then
	    set_floor("fl-gradient",  i-1,  line, {type=2})
      elseif c == "Q" then
          set_stone("st-knight", i-1, line)
      elseif c == "!" then
          set_stone("st-laser-n", i-1, line, {name="laser"})
      elseif c == ":" then
          set_item("it-trigger", i-1,line, {invisible=0, action="onoff", target="laser"})
      elseif c == "x" then
          oxyd( i-1, line)
      elseif c == "X" then
          fakeoxyd( i-1, line)
      elseif c == "=" then
          set_actor("ac-blackball", i-.5,line+.5, {player=0})
        end
    end
end
--                        1         2         3         4         5
--              0123456789012345678901234567890123456789012345678901234567
renderLine(00, "#######################Y##################################")
renderLine(01, "#                  #                  #                  #")
renderLine(02, "#                  #                  #          ++++    #")
renderLine(03, "#                  #                  #    1     +++++   #")
renderLine(04, "#                  #                  #          ++++    #")
renderLine(05, "#                  #                  #                  #")
renderLine(06, "#     X  =   X     #                  #                  #")
renderLine(07, "#                  y                  #                  #")
renderLine(08, "#                  #                  #                  #")
renderLine(09, "#                  #                  #                  Z")
renderLine(10, "#                  #                  #                  #")
renderLine(11, "#                  #                  #                  #")
renderLine(12, "############################v#############################")
renderLine(13, "#              #############    A#########        J#######")
renderLine(14, "#              ################a##########i####j##########")
renderLine(15, "#    QQQ       ################ ########   I### #W#K######")
renderLine(16, "#    QxQ       ########       b ######## ######      k  ##")
renderLine(17, "#    QQQ       oo/####C #######B######## ############## ##")
renderLine(18, "#              # ! ####c###D############ h  ########### L#")
renderLine(19, "#              # : ####       d    ######## ########### ##")
renderLine(20, "#              #   #############E# ####     #####     l ##")
renderLine(21, "#              #   ##yyyyy    e    #### ##H###### ########")
renderLine(22, "#0000000000 0  M   ##$####fF###########g#########      ###")
renderLine(23, "#|||||||||||0  m   #######              G############# ?S#")
renderLine(24, "####.###### ########################################## ###")
renderLine(25, "###0....0##  #########yyyy###  y####y##                  #")
renderLine(26, "###0000.0###yy###  yyyy######y#yyyyyy##                  #")
renderLine(27, "######0.0000#y?##?#### yyyyy#y?# ### ##                  #")
renderLine(28, "######0....0##yy#y#### ####y## #   #y##                  #")
renderLine(29, "######0000.0###  y####y#### ##y###y####                  #")
renderLine(30, "###0000000.0##########y#### ##y###y? ##         2        #")
renderLine(31, "###0.......0#########  ######  yyy## ##                  #")
renderLine(32, "###0.00000 0########  #yyy#yyy##y#yyy##                  #")
renderLine(33, "###0.000#000########y##y#   ####y#y####                  #")
renderLine(34, "###0...00###########y  y####yyyyy# ####                  #")
renderLine(35, "###000..00##############yyyyy#####   @#                  #")
renderLine(36, "#####00..0000000####################################?#####")
renderLine(37, "######00.......0####                  #                  #")
renderLine(38, "#######0000000.0####                  #  _               #")
renderLine(39, "###00000000000.0####                  ?___               #")
renderLine(40, "###0 ..........0####                  #  _               #")
renderLine(41, "###000.000000000####                  #_                 #")
renderLine(42, "#####0...0##########                  #                  #")
renderLine(43, "####0000.0##00000###                  #_                 #")
renderLine(44, "####0....0##0-  0###   x              #                  #")
renderLine(45, "####0,0000##000 0###                  #                  #")
renderLine(46, "####0.000000000 000#                  #                  #")
renderLine(47, "####0.......    3 0#                  #                  #")
renderLine(48, "##########################################################")
--              0123456789012345678901234567890123456789012345678901234567
--                        1         2         3         4         5


door1=enigma.GetNamedObject("door1")
door2=enigma.GetNamedObject("door2")
door3=enigma.GetNamedObject("door3")
door4=enigma.GetNamedObject("door4")
door5=enigma.GetNamedObject("door5")
door6=enigma.GetNamedObject("door6")
door7=enigma.GetNamedObject("door7")
door8=enigma.GetNamedObject("door8")
door9=enigma.GetNamedObject("door9")
door10=enigma.GetNamedObject("door10")
door11=enigma.GetNamedObject("door11")
door12=enigma.GetNamedObject("door12")

function funcc()
    enigma.SendMessage(door1, "open", nil)
    enigma.SendMessage(door2, "open", nil)
    enigma.SendMessage(door3, "open", nil)
    enigma.SendMessage(door4, "open", nil)
    enigma.SendMessage(door5, "open", nil)
    enigma.SendMessage(door6, "open", nil)
    enigma.SendMessage(door7, "open", nil)
    enigma.SendMessage(door8, "open", nil)
    enigma.SendMessage(door9, "open", nil)
    enigma.SendMessage(door10, "open", nil)
    enigma.SendMessage(door11, "open", nil)
    enigma.SendMessage(door12, "open", nil)
end

status = 0
function s1()
    if status == 0 then
        status = 1
        x = 37.5
        y = 35.5
    else
        status = 0
        x = 13.5
        y = 47.5
    end
    set_attribs(enigma.GetNamedObject("wh3"), {targetx=x, targety=y})
end 

--document(20,7, "Hast du wirklich gedacht, es sei so einfach?")
--document(56,26, "Hast du nicht etwas vergessen?")
--document(36,35, "Weiter jetzt! Es gibt keinen Weg zurueck!")
--document(4,40, "HALT! Nicht hier entlang! Es gibt eine Abkuerzung...")
--document(14,44, "Da ist ein Trigger einen Schritt links von hier. Wenn du ihn gedrueckt halten kannst und zurueckgehst, wuerde es dir sehr helfen!")
document(20,7, "Did you really think, this one is so easy?")
document(56,26, "Did you forget something?")
document(36,35, "Go on! There's no way back now!")
document(4,40, "STOP! Not this way! There's a short-cut...")
document(14,44, "There's a trigger one step to the left. If you could keep it depressed, it would help you a lot if you go back!")





























