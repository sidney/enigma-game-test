-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- Oxyd single #038

levelw = 61
levelh = 61
hour = enigma.date("%H")

create_world(levelw, levelh)

oxyd_default_flavor = "d"
fill_floor("fl-wood", 0, 0, levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "#" then
         set_stone("st-rock3",i-1,line)
      elseif c == "h" then
         set_stone("st-rock3_hole",i-1,line)
      elseif c == "c" then
         set_stone("st-rock3_break",i-1,line)
      elseif c == "M" then
         set_stone("st-rock3_move",i-1,line)
      elseif c == "H" then
         hammer(i-1,line)
      elseif c == "." then
         set_item("it-extralife",i-1,line)
      elseif c == "0" then
         set_item("it-hollow",i-1,line)
      elseif c == "k" then
         set_item("it-key_b",i-1,line)
      elseif c == "D" then
         set_stone("st-death",i-1,line)
      elseif c == "g" then
         set_stone("st-grate1",i-1,line)
      elseif c=="m" then
	 set_item("it-coin1", i-1,line)
      elseif c == "*" then
         set_item("it-hill",i-1,line)
      elseif c == "+" then
         set_item("it-tinyhill",i-1,line)
      elseif c == "I" then
         set_floor("fl-ice_001",i-1,line)
      elseif c == "j" then
         set_floor("fl-ice_001",i-1,line)
	 set_item("it-crack0",i-1,line)
      elseif c == "n" then
         set_floor("fl-normal",  i-1,  line)
      elseif c == ">" then
         set_floor("fl-gradient",  i-1,  line, {type=4})
      elseif c == "<" then
         set_floor("fl-gradient",  i-1,  line, {type=3})
      elseif c == "C" then
         set_stone("st-rock3_break",i-1,line)
	 document(i-1,line, "Business hours from 8am to 4pm")
      elseif c == "T" then
         set_stone("st-rock3",i-1,line)
         if (hour >= "08") and (hour < "16") then     -- only open between 8-16
           set_stone("st-rock3_break",i-1,line) end
         if difficult == false then                   -- and while easy mode
           set_stone("st-rock3_break",i-1,line) end
      elseif c == "1" then
         set_item("it-vortex-closed", i-1,line, {name="vortex1", targetx = 33.5, targety =  43.5})
      elseif c == "w" then
         set_stone("st-timeswitch",i-1,line,{target = "vortex1", action = "open"})
      elseif c == "2" then
         set_item("it-vortex-closed", i-1,line, {name="vortex2", targetx = 1.5, targety =  5.5})
         set_floor("fl-ice_001",i-1,line)
      elseif c == "x" then
         set_stone("st-timeswitch",i-1,line,{target = "vortex2", action = "open"})
      elseif c == "3" then
         set_item("it-vortex-closed", i-1,line, {name="vortex3", targetx = 1.5, targety =  59.5})
      elseif c == "y" then
         set_stone("st-timeswitch",i-1,line,{target = "vortex3", action = "open"})
      elseif c == "4" then
         set_item("it-vortex-closed", i-1,line, {name="vortex4", targetx = 59.5, targety =  1.5})
      elseif c == "z" then
         set_stone("st-timeswitch",i-1,line,{target = "vortex4", action = "open"})
      elseif c == "O" then
         oxyd( i-1, line)
      elseif c == "a" then
         set_actor("ac-blackball", i-.5,line+.5)
        end
    end
end

--              0123456789012345678901234567890123456789012345678901234567890
renderLine(00, "###########################################################y#")
renderLine(01, "#a                    H                                    3#")
renderLine(02, "# ######D ########################################### ##### #")
renderLine(03, "#       #                           #               # #   # #")
renderLine(04, "# ####D # ######################### # ############# # # O # #")
renderLine(05, "#1    #    >nnn<>nnnnnnn<           #                 #   # #")
renderLine(06, "#w #D # #####################c############### ########## ## #")
renderLine(07, "#   # # #                    cccccccccc       #   #   #   # #")
renderLine(08, "# # # # # ###########################c####### # # # # # ### #")
renderLine(09, "# # # #           #     #   #       #c#     # # # # # # #   #")
renderLine(10, "# # # # ## ###### # ### # # # #######c# # # # # # # # # # # #")
renderLine(11, "# # # #         #       # # #       #c# # # #   #   # # # # #")
renderLine(12, "# # # ######### # ##### # # # ##### ### # # # #####   # # # #")
renderLine(13, "# # #             #     # # # #   #     # # #       ### # # #")
renderLine(14, "# # # ########### ### ### # # # O ####### # # ##### # # # # #")
renderLine(15, "# # #           #     #   # # #   #       # #     # #   # # #")
renderLine(16, "# # # ######### # # ### ### # ## ## ##### # # # # # # ### # #")
renderLine(17, "# # # #         # #         # #         # #   # # #   #   # #")
renderLine(18, "# # # # # ##### # ######### # # ### ### # # ### # ##### ### #")
renderLine(19, "# # # # # #  .#           # # # #     # # # #   # #   # # # #")
renderLine(20, "# # # # # # # # ####### # # # # # ### # # # ##### # # # # # #")
renderLine(21, "# #     # # # #   #   # # # # # #   # #     #     # # # #   #")
renderLine(22, "# # ##### # # # # # # # # # # # # # # ######### # # # # # # #")
renderLine(23, "#         # # # # # #   #         # #           # # #     # #")
renderLine(24, "# ##### # # # # # # ############# # ########### # # ####### #")
renderLine(25, "#       #   #   # #       #     # #           #           # #")
renderLine(26, "####### # ##### #k####### ##### # ########### ##### ####### #")
renderLine(27, "# #       #####       0       # #         #       #       # #")
renderLine(28, "# ##### # ##### ############# # ######### # ##### ####### # #")
renderLine(29, "#     # #   ### #           # #           #     #         # #")
renderLine(30, "### # # ####### # ######### # #################### ######## #")
renderLine(31, "#   # # ####### # hhhhhhhhh #                               #")
renderLine(32, "# # # # ####### # #h####### # ###### ###################### #")
renderLine(33, "# # # # #         #hhhhh*   #                             # #")
renderLine(34, "# # # # ############# # ################################# # #")
renderLine(35, "# # # D #   #       # # #                                 # #")
renderLine(36, "# # # ### # # ##### # # # ################################# #")
renderLine(37, "#   #       # #     #                  ++++++++++        O# #")
renderLine(38, "#######g### # ### # ### ################################### #")
renderLine(39, "# #    g  #  M    #   #                       #           # #")
renderLine(40, "# # #m#g  # # ##### # ################# ##### # #######D# D #")
renderLine(41, "#   # #g    #       # # IIIIIIIIIjIIIIIIIIII# # #       # # #")
renderLine(42, "# ### #g    # ### ### # # #################I# # # ### # # # #")
renderLine(43, "#     #ggggg# #   #   # #IIIIIIII2IIIIIIIIII# # #   # # # # #")
renderLine(44, "# #########g# # ### ### # #######x########### # # # # # # # #")
renderLine(45, "#     #ggggg    #   #   #             #         # # # # # # #")
renderLine(46, "##### # ######### # # # # # ######### # ##### # # # # # # # #")
renderLine(47, "#   #   #           # # # # #       # #     # #   # # # # # #")
renderLine(48, "# # # # # ########### # # # # ##### # # ### # ### # # # # # #")
renderLine(49, "# # # #               # # #   #   # # #   #     #+++++# # # #")
renderLine(50, "# # # # ############### # # # # # # # # # # ### ##### # # # #")
renderLine(51, "# #   # #             # # # # # # # #   # #   #       # # # #")
renderLine(52, "# ### # # ########### # # # # # # # # ### # # ####### # # # #")
renderLine(53, "#     #             # # # # # D # #   #             D #   #H#")
renderLine(54, "##### # ########### # # # # D # # # ### # ### ### #########c#")
renderLine(55, "#   #             # # # # # # # # # #   #   #   #     #ccc#c#")
renderLine(56, "# # ############# # # # # # # # # # # ##### # # ##### #cOc#c#")
renderLine(57, "# #               # # #   #   # # # #   #   # #       #ccc#c#")
renderLine(58, "# ############ #### # ### ##### # # D # # # # ##########T##c#")
renderLine(59, "z4                  #                 # # # #         ccCccc#")
renderLine(60, "#############################################################")
--              0123456789012345678901234567890123456789012345678901234567890


oxyd_shuffle()

