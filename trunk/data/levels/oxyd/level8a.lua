--
-- A level for Enigma
--
-- Copyright (c) 2002 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-rock4")
fill_floor("fl-tigris")

oxyd_default_flavor = "d"

oxyd ( 19, 1)
oxyd ( 19,11)

set_stones("st-rock4", {{3,3},{5,3},{7,3},{9,3},{11,3},{13,3},{15,3}})
set_stones("st-rock4", {{3,5},{5,5},{7,5},{9,5},{11,5},{13,5},{15,5}})
set_stones("st-rock4", {{3,7},{5,7},{7,7},{9,7},{11,7},{13,7},{15,7}})
set_stones("st-rock4", {{3,9},{5,9},{7,9},{9,9},{11,9},{13,9},{15,9}})
draw_stones("st-rock4", { 3, 1}, {1,0},13)
draw_stones("st-rock4", { 3,11}, {1,0},13)
set_stones("st-wood", {{4,2},{4,4},{4,6},{4,8},{4,10}})
set_stones("st-wood", {{10,2},{10,4},{10,6},{10,8},{10,10}})

function yy1( color, x, y)
        stone = format( "st-%s4", color)
        set_stone( stone, x, y)
end

yy1( "white",  3, 2)
yy1( "white",  3, 6)
yy1( "white",  3,10)
yy1( "white",  9, 4)
yy1( "white",  9, 8)
yy1( "white", 15, 2)
yy1( "white", 15, 6)
yy1( "white", 15,10)
yy1( "white", 18,11)
yy1( "black",  3, 4)
yy1( "black",  3, 8)
yy1( "black",  9, 2)
yy1( "black",  9, 6)
yy1( "black",  9,10)
yy1( "black", 15, 4)
yy1( "black", 15, 8)
yy1( "black", 18, 1)

set_stones("st-yinyang1", {{4,3},{6,3},{8,3},{10,3},{12,3},{14,3}})
set_stones("st-yinyang1", {{4,5},{6,5},{8,5},{10,5},{12,5},{14,5}})
set_stones("st-yinyang1", {{4,7},{6,7},{8,7},{10,7},{12,7},{14,7}})
set_stones("st-yinyang1", {{4,9},{6,9},{8,9},{10,9},{12,9},{14,9}})

set_item("it-yinyang", 2,5)
set_item("it-yinyang", 2,7)

set_actor("ac-blackball", 2.5, 5.5)
set_actor("ac-whiteball", 2.5, 7.5)










