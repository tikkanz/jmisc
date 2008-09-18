
circle=: ];._2 ] 0 : 0
.....XXXXXX.....
...XX+--+--XX...
..X-+--+--+--X..
.X-+--+--+--+-X.
.X+--+--+--+--X.
X---+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+--+X
X+--+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+---X
.X--+--+--+--+X.
.X-+--+--+--+-X.
..X--+--+--+-X..
...XX--+--+XX...
.....XXXXXX.....
)

square=: ];._2 ] 0 : 0
XXXXXXXXXXXXXXXX
X-+--+--+--+--+X
X+--+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+--+X
X+--+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+--+X
X+--+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+--+X
X+--+--+--+--+-X
X--+--+--+--+--X
X-+--+--+--+--+X
X+--+--+--+--+-X
XXXXXXXXXXXXXXXX
)

squiggle=: ];._2 ] 0 : 0
........XXX.....
.......X+--X....
......X+--X.....
.....X+--X......
....X+--X.......
....X--+X.......
....X-+--X......
.....X--+-X.....
......X+--+X....
.......X-+-X....
.......X+--X....
.......X--X.....
......X--+X.....
.....X--+X......
....X--+X.......
....XXXX........
)

outline=: e.&'X'
shaded=:  e.&'X+'
solid=:   e.&'X+-'

red=: 249&*
green=: 250&*
blue=: 252&*
grey=: 248&*
white=: 255&*

on=: 4 : '96{.(24#0),"1 (24#0),~"1 (0$~y,16),x' " _ 0
bg=:  1 : '+ [: x 0: = ]'

one=:       on&40
two=:   +/@(on&30 50)
three=: +/@(on&20 40 60)

pal=: _256{. ".;._2 ] 0 : 0
192 192 192
255   0   0
  0 255   0
255 255   0
  0   0 255
255   0 255
  0 255 255
255 255 255
)

combs=: #~ #: i.@^

verbs=: ;:;._2 ] 0 : 0
one two three
red green blue
outline shaded solid
circle square squiggle
)
genbmps=: 3 : 0
  NB. Generate bitmaps for "Set" game.
  NB.    genbmps 'dirname'
  NB.    genbmps jpath '~user/usercontrib/set'
  all=. 3 combs 4  NB. All combinations
  fn=. ('set'"_ , {&'012')"1 all
  bmps=.  all ({"0 1)"1 _ verbs
  q=. ''''"_ , ] , ''''"_
  bmparg=. pal"_ ; white bg  NB. white was grey in the original code
  NB.  bmps (bmparg@".@(;:^:_1)@[ writebmp8  y&,@('\'&,)@(,&'.bmp')@])"1 fn 
  fbmps=.({~every/"1(bmparg@".@(;:^:_1)) bmps) NB. added
  fnmes=.y&,@('\'&,)@(,&'.bmp')"1 fn           NB. added
  (<"3 fbmps) writebmp every <"1 fnmes         NB. added
) 
