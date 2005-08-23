-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Snakes

levelw=25
levelh=15

create_world( levelw, levelh)

fill_floor("fl-hay",0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="r" then
            set_stone( "st-invisible", i-1, line)
            abyss(i-1,line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c =="." then
            set_floor( "fl-hay", i-1, line)
            -- Mark original positions of abysses
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5)
        end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"####o##########o####")
renderLine(01,"#                  #")
renderLine(02,"o ................ o")
renderLine(03,"#                  #")
renderLine(04,"o   .............. o")
renderLine(05,"#   .              #")
renderLine(06,"o   .              o")
renderLine(07,"#           ..     #")
renderLine(08,"o            .     o")
renderLine(09,"#            .  z  #")
renderLine(10,"o ............     o")
renderLine(11,"#                  #")
renderLine(12,"####o##########o####")

oxyd_shuffle()


s0x=17
s0y=2
s1x=16
s1y=2
s2x=15
s2y=2
s3x=14
s3y=2
s4x=13
s4y=2
s5x=12
s5y=2
s6x=11
s6y=2
s7x=10
s7y=2
s8x=9
s8y=2
s9x=8
s9y=2
sax=7
say=2
sbx=6
sby=2
scx=5
scy=2
sdx=4
sdy=2
sjx=3
sjy=2
skx=2
sky=2

px=2


s0x2=2
s0y2=10
s1x2=3
s1y2=10
s2x2=4
s2y2=10
s3x2=5
s3y2=10
s4x2=6
s4y2=10
s5x2=7
s5y2=10
s6x2=8
s6y2=10
s7x2=9
s7y2=10
s8x2=10
s8y2=10
s9x2=11
s9y2=10
sax2=12
say2=10
sbx2=13
sby2=10
scx2=13
scy2=9
sdx2=13
sdy2=8
sjx2=13
sjy2=7
skx2=12
sky2=7

px2=4


s0x3=4
s0y3=6
s1x3=4
s1y3=5
s2x3=4
s2y3=4
s3x3=5
s3y3=4
s4x3=6
s4y3=4
s5x3=7
s5y3=4
s6x3=8
s6y3=4
s7x3=9
s7y3=4
s8x3=10
s8y3=4
s9x3=11
s9y3=4
sax3=12
say3=4
sbx3=13
sby3=4
scx3=14
scy3=4
sdx3=15
sdy3=4
sjx3=16
sjy3=4
skx3=17
sky3=4

px3=3


set_floor( "fl-abyss", s0x, s0y)
set_floor( "fl-abyss", s1x, s1y)
set_floor( "fl-abyss", s2x, s2y)
set_floor( "fl-abyss", s3x, s3y)
set_floor( "fl-abyss", s4x, s4y)
set_floor( "fl-abyss", s5x, s5y)
set_floor( "fl-abyss", s6x, s6y)
set_floor( "fl-abyss", s7x, s7y)
set_floor( "fl-abyss", s8x, s8y)
set_floor( "fl-abyss", s9x, s9y)
set_floor( "fl-abyss", sax, say)
set_floor( "fl-abyss", sbx, sby)
set_floor( "fl-abyss", scx, scy)
set_floor( "fl-abyss", sdx, sdy)
set_floor( "fl-abyss", sjx, sjy)
set_floor( "fl-abyss", skx, sky)


set_floor( "fl-abyss", s0x2, s0y2)
set_floor( "fl-abyss", s1x2, s1y2)
set_floor( "fl-abyss", s2x2, s2y2)
set_floor( "fl-abyss", s3x2, s3y2)
set_floor( "fl-abyss", s4x2, s4y2)
set_floor( "fl-abyss", s5x2, s5y2)
set_floor( "fl-abyss", s6x2, s6y2)
set_floor( "fl-abyss", s7x2, s7y2)
set_floor( "fl-abyss", s8x2, s8y2)
set_floor( "fl-abyss", s9x2, s9y2)
set_floor( "fl-abyss", sax2, say2)
set_floor( "fl-abyss", sbx2, sby2)
set_floor( "fl-abyss", scx2, scy2)
set_floor( "fl-abyss", sdx2, sdy2)
set_floor( "fl-abyss", sjx2, sjy2)
set_floor( "fl-abyss", skx2, sky2)


set_floor( "fl-abyss", s0x3, s0y3)
set_floor( "fl-abyss", s1x3, s1y3)
set_floor( "fl-abyss", s2x3, s2y3)
set_floor( "fl-abyss", s3x3, s3y3)
set_floor( "fl-abyss", s4x3, s4y3)
set_floor( "fl-abyss", s5x3, s5y3)
set_floor( "fl-abyss", s6x3, s6y3)
set_floor( "fl-abyss", s7x3, s7y3)
set_floor( "fl-abyss", s8x3, s8y3)
set_floor( "fl-abyss", s9x3, s9y3)
set_floor( "fl-abyss", sax3, say3)
set_floor( "fl-abyss", sbx3, sby3)
set_floor( "fl-abyss", scx3, scy3)
set_floor( "fl-abyss", sdx3, sdy3)
set_floor( "fl-abyss", sjx3, sjy3)
set_floor( "fl-abyss", skx3, sky3)


function timer_callback()

set_floor( "fl-hay", skx, sky)
set_floor( "fl-hay", skx2, sky2)
set_floor( "fl-hay", skx3, sky3)

if s0x<2 then
   if s0y<2 then
      x=random(2)
      if x==1 then
	 x=2
      elseif x==2 then
	 x=3
      end
   elseif s0y>10 then
      x=random(2)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=2
      end
   else
      x=random(3)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=2
      elseif x==3 then
	 x=3
      end
   end
elseif s0x>17 then
   if s0y<2 then
      x=random(2)
      if x==1 then
	 x=3
      elseif x==2 then
	 x=4
      end
   elseif s0y>10 then
      x=random(2)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=4
      end
   else
      x=random(3)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=3
      elseif x==3 then
	 x=4
      end
   end
else
   if s0y<2 then
      x=random(3)
      if x==1 then
	 x=2
      elseif x==2 then
	 x=3
      elseif x==3 then
	 x=4
      end
   elseif s0y>10 then
      x=random(3)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=2
      elseif x==3 then
	 x=4
      end
   else
      x=random(4)
      if x==1 then
	 x=1
      elseif x==2 then
	 x=2
      elseif x==3 then
	 x=3
      elseif x==4 then
	 x=4
      end
   end
end

skx=sjx
sky=sjy
sjx=sdx
sjy=sdy
sdx=scx
sdy=scy
scx=sbx
scy=sby
sbx=sax
sby=say
sax=s9x
say=s9y
s9x=s8x
s9y=s8y
s8x=s7x
s8y=s7y
s7x=s6x
s7y=s6y
s6x=s5x
s6y=s5y
s5x=s4x
s5y=s4y
s4x=s3x
s4y=s3y
s3x=s2x
s3y=s2y
s2x=s1x
s2y=s1y
s1x=s0x
s1y=s0y

if x==1 then
   if px==3 and s0y<11 then
      s0y=s0y+1
      px=3
   else
      if px==3 then
	 x=random(2)
	 if x==1 then
	    if s0x<18 then
	       s0x=s0x+1
	       px=2
	    else
	       s0x=s0x-1
	       px=4
	    end
	 elseif x==2 then
	    if s0x>1 then
	       s0x=s0x-1
	       px=4
	    else
	       s0x=s0x+1
	       px=2
	    end
	 end
      else
	 s0y=s0y-1
	 px=1
      end
   end
elseif x==2 then
   if px==4 and s0x>1 then
      s0x=s0x-1
      px=4
   else
      if px==4 then
	 x=random(2)
	 if x==1 then
	    if s0y>1 then
	       s0y=s0y-1
	       px=1
	    else
	       s0y=s0y+1
	       px=3
	    end
	 elseif x==2 then
	    if s0y<11 then
	       s0y=s0y+1
	       px=3
	    else
	       s0y=s0y-1
	       px=1
	    end
	 end
      else
	 s0x=s0x+1
	 px=2
      end
   end
elseif x==3 then
   if px==1 and s0y>1 then
      s0y=s0y-1
      px=1
   else
      if px==1 then
	 x=random(2)
	 if x==1 then
	    if s0x<18 then
	       s0x=s0x+1
	       px=2
	    else
	       s0x=s0x-1
	       px=4
	    end
	 elseif x==2 then
	    if s0x>1 then
	       s0x=s0x-1
	       px=4
	    else
	       s0x=s0x+1
	       px=2
	    end
	 end
      else
	 s0y=s0y+1
	 px=3
      end
   end
elseif x==4 then
   if px==2 and s0x<18 then
      s0x=s0x+1
      px=2
   else
      if px==2 then
	 x=random(2)
	 if x==1 then
	    if s0y>1 then
	       s0y=s0y-1
	       px=1
	    else
	       s0y=s0y+1
	       px=3
	    end
	 elseif x==2 then
	    if s0y<11 then
	       s0y=s0y+1
	       px=3
	    else
	       s0y=s0y-1
	       px=1
	    end
	 end
      else
	 s0x=s0x-1
	 px=4
      end
   end
end

set_floor( "fl-abyss", s0x, s0y)
set_floor( "fl-abyss", s1x, s1y)
set_floor( "fl-abyss", s2x, s2y)
set_floor( "fl-abyss", s3x, s3y)
set_floor( "fl-abyss", s4x, s4y)
set_floor( "fl-abyss", s5x, s5y)
set_floor( "fl-abyss", s6x, s6y)
set_floor( "fl-abyss", s7x, s7y)
set_floor( "fl-abyss", s8x, s8y)
set_floor( "fl-abyss", s9x, s9y)
set_floor( "fl-abyss", sax, say)
set_floor( "fl-abyss", sbx, sby)
set_floor( "fl-abyss", scx, scy)
set_floor( "fl-abyss", sdx, sdy)
set_floor( "fl-abyss", sjx, sjy)
set_floor( "fl-abyss", skx, sky)











if s0x2<2 then
   if s0y2<2 then
      x2=random(2)
      if x2==1 then
	 x2=2
      elseif x2==2 then
	 x2=3
      end
   elseif s0y2>10 then
      x2=random(2)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=2
      end
   else
      x2=random(3)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=2
      elseif x2==3 then
	 x2=3
      end
   end
elseif s0x2>17 then
   if s0y2<2 then
      x2=random(2)
      if x2==1 then
	 x2=3
      elseif x2==2 then
	 x2=4
      end
   elseif s0y2>10 then
      x2=random(2)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=4
      end
   else
      x2=random(3)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=3
      elseif x2==3 then
	 x2=4
      end
   end
else
   if s0y2<2 then
      x2=random(3)
      if x2==1 then
	 x2=2
      elseif x2==2 then
	 x2=3
      elseif x2==3 then
	 x2=4
      end
   elseif s0y2>10 then
      x2=random(3)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=2
      elseif x2==3 then
	 x2=4
      end
   else
      x2=random(4)
      if x2==1 then
	 x2=1
      elseif x2==2 then
	 x2=2
      elseif x2==3 then
	 x2=3
      elseif x2==4 then
	 x2=4
      end
   end
end

skx2=sjx2
sky2=sjy2
sjx2=sdx2
sjy2=sdy2
sdx2=scx2
sdy2=scy2
scx2=sbx2
scy2=sby2
sbx2=sax2
sby2=say2
sax2=s9x2
say2=s9y2
s9x2=s8x2
s9y2=s8y2
s8x2=s7x2
s8y2=s7y2
s7x2=s6x2
s7y2=s6y2
s6x2=s5x2
s6y2=s5y2
s5x2=s4x2
s5y2=s4y2
s4x2=s3x2
s4y2=s3y2
s3x2=s2x2
s3y2=s2y2
s2x2=s1x2
s2y2=s1y2
s1x2=s0x2
s1y2=s0y2




if x2==1 then
   if px2==3 and s0y2<11 then
      s0y2=s0y2+1
      px2=3
   else
      if px2==3 then
	 x2=random(2)
	 if x2==1 then
	    if s0x2<18 then
	       s0x2=s0x2+1
	       px2=2
	    else
	       s0x2=s0x2-1
	       px2=4
	    end
	 elseif x2==2 then
	    if s0x2>1 then
	       s0x2=s0x2-1
	       px2=4
	    else
	       s0x2=s0x2+1
	       px2=2
	    end
	 end
      else
	 s0y2=s0y2-1
	 px2=1
      end
   end
elseif x2==2 then
   if px2==4 and s0x2>1 then
      s0x2=s0x2-1
      px2=4
   else
      if px2==4 then
	 x2=random(2)
	 if x2==1 then
	    if s0y2>1 then
	       s0y2=s0y2-1
	       px2=1
	    else
	       s0y2=s0y2+1
	       px2=3
	    end
	 elseif x2==2 then
	    if s0y2<11 then
	       s0y2=s0y2+1
	       px2=3
	    else
	       s0y2=s0y2-1
	       px2=1
	    end
	 end
      else
	 s0x2=s0x2+1
	 px2=2
      end
   end
elseif x2==3 then
   if px2==1 and s0y2>1 then
      s0y2=s0y2-1
      px2=1
   else
      if px2==1 then
	 x2=random(2)
	 if x2==1 then
	    if s0x2<18 then
	       s0x2=s0x2+1
	       px2=2
	    else
	       s0x2=s0x2-1
	       px2=4
	    end
	 elseif x2==2 then
	    if s0x2>1 then
	       s0x2=s0x2-1
	       px2=4
	    else
	       s0x2=s0x2+1
	       px2=2
	    end
	 end
      else
	 s0y2=s0y2+1
	 px2=3
      end
   end
elseif x2==4 then
   if px2==2 and s0x2<18 then
      s0x2=s0x2+1
      px2=2
   else
      if px2==2 then
	 x2=random(2)
	 if x2==1 then
	    if s0y2>1 then
	       s0y2=s0y2-1
	       px2=1
	    else
	       s0y2=s0y2+1
	       px2=3
	    end
	 elseif x2==2 then
	    if s0y2<11 then
	       s0y2=s0y2+1
	       px2=3
	    else
	       s0y2=s0y2-1
	       px2=1
	    end
	 end
      else
	 s0x2=s0x2-1
	 px2=4
      end
   end
end





set_floor( "fl-abyss", s0x2, s0y2)
set_floor( "fl-abyss", s1x2, s1y2)
set_floor( "fl-abyss", s2x2, s2y2)
set_floor( "fl-abyss", s3x2, s3y2)
set_floor( "fl-abyss", s4x2, s4y2)
set_floor( "fl-abyss", s5x2, s5y2)
set_floor( "fl-abyss", s6x2, s6y2)
set_floor( "fl-abyss", s7x2, s7y2)
set_floor( "fl-abyss", s8x2, s8y2)
set_floor( "fl-abyss", s9x2, s9y2)
set_floor( "fl-abyss", sax2, say2)
set_floor( "fl-abyss", sbx2, sby2)
set_floor( "fl-abyss", scx2, scy2)
set_floor( "fl-abyss", sdx2, sdy2)
set_floor( "fl-abyss", sjx2, sjy2)
set_floor( "fl-abyss", skx2, sky2)




















if s0x3<2 then
   if s0y3<2 then
      x3=random(2)
      if x3==1 then
	 x3=2
      elseif x3==2 then
	 x3=3
      end
   elseif s0y3>10 then
      x3=random(2)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=2
      end
   else
      x3=random(3)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=2
      elseif x3==3 then
	 x3=3
      end
   end
elseif s0x3>17 then
   if s0y3<2 then
      x3=random(2)
      if x3==1 then
	 x3=3
      elseif x3==2 then
	 x3=4
      end
   elseif s0y3>10 then
      x3=random(2)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=4
      end
   else
      x3=random(3)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=3
      elseif x3==3 then
	 x3=4
      end
   end
else
   if s0y3<2 then
      x3=random(3)
      if x3==1 then
	 x3=2
      elseif x3==2 then
	 x3=3
      elseif x3==3 then
	 x3=4
      end
   elseif s0y3>10 then
      x3=random(3)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=2
      elseif x3==3 then
	 x3=4
      end
   else
      x3=random(4)
      if x3==1 then
	 x3=1
      elseif x3==2 then
	 x3=2
      elseif x3==3 then
	 x3=3
      elseif x3==4 then
	 x3=4
      end
   end
end

skx3=sjx3
sky3=sjy3
sjx3=sdx3
sjy3=sdy3
sdx3=scx3
sdy3=scy3
scx3=sbx3
scy3=sby3
sbx3=sax3
sby3=say3
sax3=s9x3
say3=s9y3
s9x3=s8x3
s9y3=s8y3
s8x3=s7x3
s8y3=s7y3
s7x3=s6x3
s7y3=s6y3
s6x3=s5x3
s6y3=s5y3
s5x3=s4x3
s5y3=s4y3
s4x3=s3x3
s4y3=s3y3
s3x3=s2x3
s3y3=s2y3
s2x3=s1x3
s2y3=s1y3
s1x3=s0x3
s1y3=s0y3




if x3==1 then
   if px3==3 and s0y3<11 then
      s0y3=s0y3+1
      px3=3
   else
      if px3==3 then
	 x3=random(2)
	 if x3==1 then
	    if s0x3<18 then
	       s0x3=s0x3+1
	       px3=2
	    else
	       s0x3=s0x3-1
	       px3=4
	    end
	 elseif x3==2 then
	    if s0x3>1 then
	       s0x3=s0x3-1
	       px3=4
	    else
	       s0x3=s0x3+1
	       px3=2
	    end
	 end
      else
	 s0y3=s0y3-1
	 px3=1
      end
   end
elseif x3==2 then
   if px3==4 and s0x3>1 then
      s0x3=s0x3-1
      px3=4
   else
      if px3==4 then
	 x3=random(2)
	 if x3==1 then
	    if s0y3>1 then
	       s0y3=s0y3-1
	       px3=1
	    else
	       s0y3=s0y3+1
	       px3=3
	    end
	 elseif x3==2 then
	    if s0y3<11 then
	       s0y3=s0y3+1
	       px3=3
	    else
	       s0y3=s0y3-1
	       px3=1
	    end
	 end
      else
	 s0x3=s0x3+1
	 px3=2
      end
   end
elseif x3==3 then
   if px3==1 and s0y3>1 then
      s0y3=s0y3-1
      px3=1
   else
      if px3==1 then
	 x3=random(2)
	 if x3==1 then
	    if s0x3<18 then
	       s0x3=s0x3+1
	       px3=2
	    else
	       s0x3=s0x3-1
	       px3=4
	    end
	 elseif x3==2 then
	    if s0x3>1 then
	       s0x3=s0x3-1
	       px3=4
	    else
	       s0x3=s0x3+1
	       px3=2
	    end
	 end
      else
	 s0y3=s0y3+1
	 px3=3
      end
   end
elseif x3==4 then
   if px3==2 and s0x3<18 then
      s0x3=s0x3+1
      px3=2
   else
      if px3==2 then
	 x3=random(2)
	 if x3==1 then
	    if s0y3>1 then
	       s0y3=s0y3-1
	       px3=1
	    else
	       s0y3=s0y3+1
	       px3=3
	    end
	 elseif x3==2 then
	    if s0y3<11 then
	       s0y3=s0y3+1
	       px3=3
	    else
	       s0y3=s0y3-1
	       px3=1
	    end
	 end
      else
	 s0x3=s0x3-1
	 px3=4
      end
   end
end






set_floor( "fl-abyss", s0x3, s0y3)
set_floor( "fl-abyss", s1x3, s1y3)
set_floor( "fl-abyss", s2x3, s2y3)
set_floor( "fl-abyss", s3x3, s3y3)
set_floor( "fl-abyss", s4x3, s4y3)
set_floor( "fl-abyss", s5x3, s5y3)
set_floor( "fl-abyss", s6x3, s6y3)
set_floor( "fl-abyss", s7x3, s7y3)
set_floor( "fl-abyss", s8x3, s8y3)
set_floor( "fl-abyss", s9x3, s9y3)
set_floor( "fl-abyss", sax3, say3)
set_floor( "fl-abyss", sbx3, sby3)
set_floor( "fl-abyss", scx3, scy3)
set_floor( "fl-abyss", sdx3, sdy3)
set_floor( "fl-abyss", sjx3, sjy3)
set_floor( "fl-abyss", skx3, sky3)













end

set_stone("st-timer", 21,0, {loop=1, action="callback", target="timer_callback", interval=.12})