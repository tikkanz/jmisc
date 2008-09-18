getSymbSz=: 3 : 0
  crdh=. ({: <. %&1.9@{.) y  NB. Height is %1.90 of width
  symh=. 0.9 * crdh
  symy=. (0.5 * {:y)-0.5*symh NB. 0.05 * crdh
  symw=. 0.55 * symh
  symx=. (0.5 * {.y)-0.5*symw
  symx, symy, symw, symh
)

drawcard=: 3 : 0
  glrgb cardborder
  glpen 1 0
  glrgb cardbkgrnd
  glbrush ''
  glrect 0 0, y
)

drawsymb=: 3 : 0
  'count color fill shape'=. y
  glrgb color~ 
  glpen 3 0  NB. 3pt solid outline
  glrgb fill~ color~
  glbrush ''
  shape~ count~ SYMBSZ
)

diamond=: setdiamond
oval=: setroundr
squiggle=: setcircle

red=: 255 0 0
green=: 0 255 0
blue=: 0 0 255
white=: 255 255 255
grey=: 192 192 192
darkgrey=: 100 100 100
lightgrey=: 220 220 220

cardborder=: darkgrey
cardbkgrnd=: lightgrey
 
solid=: 1&*
shaded=: grey >. ] NB. light color
outline=: white >. ]

one=: (1 1 1 1)*"1 ]
two=: (0.5 1.5,"0 1] 1 1 1) *"1 ]
three=: (0.1 1 1.9,"0 1] 1 1 1) *"1 ]

Note 'formats for gl commands'
 glpolygon x y x y x y x y
 glroundr  x y w h rw rh
 glellipse x y w h
)

gldiamond=: 3 : 0"1
NB.   'tlx tly wid hgt'=. y
NB.   xs=. tlx+ 0.5 1 0.5 0 * wid
NB.   ys=. tly+ 0 0.5 1 0.5 * hgt
NB.   glpolygon ,xs,.ys
  xywh=._2]\y
  rot=.0 _1|."0 1] 0.5 1 0.5 0
  xys=. rot ((]{.) + (* {:)) xywh
  glpolygon ,|:xys
)

setdiamond=: gldiamond

setroundr=: 3 : 0"1
  arg=. (],2&#@(2&{)) y
  glroundr arg
)

setcircle=: 3 : 0"1
  'xpos ypos wid hgt'=. y
  ypos=. ypos+0.5*hgt-wid
  hgt=. wid
  glellipse xpos,ypos,wid,hgt
)
