require 'gl2 bmp'
coinsert 'jgl2'
loc_z_=: 3 : '> (4!:4 <''y'') { 4!:3 $0'
INSTALLDIR=: getpath_j_ loc ''
load INSTALLDIR,'setengine.ijs'     NB.  ** Location of setengine script.
BMP=: (INSTALLDIR,'set')"_ , {&'012' , '.bmp'"_   NB.  ** Location of bitmaps

3 : 0 ''
if. -.*./fexist_j_"1 BMP"0 1 ]3 combs 4 do.
  load INSTALLDIR,'setcardsbmp.ijs'
  genbmps INSTALLDIR
end.
)

NB. base form

SET=: 0 : 0
pc set closeok dialog nomax nomin nosize;
xywh 6 6 32 48;cc p0 isigraph;
xywh 40 6 32 48;cc p1 isigraph;
xywh 74 6 32 48;cc p2 isigraph;
xywh 108 6 32 48;cc p3 isigraph;
xywh 142 6 32 48;cc p4 isigraph;
xywh 176 6 32 48;cc p5 isigraph;
xywh 6 73 32 48;cc p6 isigraph;
xywh 40 73 32 48;cc p7 isigraph;
xywh 74 73 32 48;cc p8 isigraph;
xywh 108 73 32 48;cc p9 isigraph;
xywh 142 73 32 48;cc p10 isigraph;
xywh 176 73 32 48;cc p11 isigraph;
xywh 6 56 32 10;cc s0 static ss_center;
xywh 40 56 32 10;cc s1 static ss_center;
xywh 74 56 32 10;cc s2 static ss_center;
xywh 108 56 32 10;cc s3 static ss_center;
xywh 142 56 32 10;cc s4 static ss_center;
xywh 176 56 32 10;cc s5 static ss_center;
xywh 6 126 32 10;cc s6 static ss_center;
xywh 40 126 32 10;cc s7 static ss_center;
xywh 74 126 32 10;cc s8 static ss_center;
xywh 108 126 32 10;cc s9 static ss_center;
xywh 142 126 32 10;cc s10 static ss_center;
xywh 176 126 32 10;cc s11 static ss_center;
xywh 216 13 34 34;cc doit button bs_defpushbutton;cn "Solve";
xywh 216 80 34 34;cc close button;cn "Close";
pas 6 6;pcenter;
rem form end;
)

solve=: 1

set_run=: 3 : 0
  wd SET
  NB. initialize form here
  deal''
  wd 'pshow;'
)

caption=: wd@('setcaption doit *'"_ , ])

deal=: 3 : 0
  H=: newhand ''
  NB. (i.12) wd@('set p'"_ , ":@[ , ' '"_ , BMP@])"0 1 H
  (i.#H) paint"0 1 BMP"0 1 H
  wd@('set s'"_ , ":@[ , ' ""'"_)"0 i.12
  caption 'Solve'
)

paint=: 4 : 0
  glsel 'p'&,@": x
  glclear ''
  dat=. 256 #. |."1 [ 256 256 256 #: readbmp jpath y
  glpixels (0 0,|.$dat),,dat
  glpaint ''
)

set_doit_button=: 3 : 0
  solve=: -. solve
  if. solve do. deal'' return. end.
  caption 'Solving..'
  s=. (] i."2 allsets) H NB. indices of cards in sets
  t=. (i.12) e."1 s  NB. Mask over cards in solutions
  l=. (|:t) <@# >:i.#s  NB. label for each card
  (i.12) wd@('set s'"_ , ":@[ , ' *'"_ , ":@])&> l
  caption 'Deal'
)

set_close_button=: wd bind 'pclose'
set_enter=: set_doit_button

set_run ''
