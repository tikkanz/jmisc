require 'gl2'
coinsert 'jgl2'
loc_z_=: 3 : '> (4!:4 <''y'') { 4!:3 $0'
INSTALLDIR=: getpath_j_ loc ''
load INSTALLDIR,'setengine.ijs'     NB.  ** Location of setengine script.
load INSTALLDIR,'setcardsgl2.ijs'   NB.  ** Location of card drawing script.

NB. base form
SETGL2=: 0 : 0
pc setgl2 closeok dialog;
xywh 6 6 48 32;cc p0 isigraph leftscale topscale rightscale bottomscale;
xywh 56 6 48 32;cc p1 isigraph leftscale topscale rightscale bottomscale;
xywh 106 6 48 32;cc p2 isigraph leftscale topscale rightscale bottomscale;
xywh 156 6 48 32;cc p3 isigraph leftscale topscale rightscale bottomscale;
xywh 6 57 48 32;cc p4 isigraph leftscale topscale rightscale bottomscale;
xywh 56 57 48 32;cc p5 isigraph leftscale topscale rightscale bottomscale;
xywh 106 57 48 32;cc p6 isigraph leftscale topscale rightscale bottomscale;
xywh 156 57 48 32;cc p7 isigraph leftscale topscale rightscale bottomscale;
xywh 6 108 48 32;cc p8 isigraph leftscale topscale rightscale bottomscale;
xywh 56 108 48 32;cc p9 isigraph leftscale topscale rightscale bottomscale;
xywh 106 108 48 32;cc p10 isigraph leftscale topscale rightscale bottomscale;
xywh 156 108 48 32;cc p11 isigraph leftscale topscale rightscale bottomscale;
xywh 6 40 48 10;cc s0 static ss_center leftscale topscale rightscale bottomscale;
xywh 56 40 48 10;cc s1 static ss_center leftscale topscale rightscale bottomscale;
xywh 106 40 48 10;cc s2 static ss_center leftscale topscale rightscale bottomscale;
xywh 156 40 48 10;cc s3 static ss_center leftscale topscale rightscale bottomscale;
xywh 6 91 48 10;cc s4 static ss_center leftscale topscale rightscale bottomscale;
xywh 56 91 48 10;cc s5 static ss_center leftscale topscale rightscale bottomscale;
xywh 106 91 48 10;cc s6 static ss_center leftscale topscale rightscale bottomscale;
xywh 156 91 48 10;cc s7 static ss_center leftscale topscale rightscale bottomscale;
xywh 6 142 48 10;cc s8 static ss_center leftscale topscale rightscale bottomscale;
xywh 56 142 48 10;cc s9 static ss_center leftscale topscale rightscale bottomscale;
xywh 106 142 48 10;cc s10 static ss_center leftscale topscale rightscale bottomscale;
xywh 156 142 48 10;cc s11 static ss_center leftscale topscale rightscale bottomscale;
xywh 216 28 34 34;cc doit button bs_defpushbutton leftscale topscale rightscale bottomscale;cn "Solve";
xywh 216 80 34 34;cc close button leftscale topscale rightscale bottomscale;cn "Close";
pas 6 6;pcenter;
rem form end;
)

solve=: 1

setgl2_run=: 3 : 0
  wd SETGL2
  NB. initialize form here
  deal''
  wd 'pshow;'
)

caption=: wd@('setcaption doit *'"_ , ])

deal=: 3 : 0
  H=: (({"0 1&Props)"1) newhand ''
  setgl2_p0_paint ''
  wd@('set s'"_ , ":@[ , ' ""'"_)"0 i.12
  caption 'Solve'
)
setgl2_p0_paint=:  3 :'(i.#H) setpaint"0 1 H'
setgl2_p1_paint=:  3 :  '1 setpaint  1{H'
setgl2_p2_paint=:  3 :  '2 setpaint  2{H'
setgl2_p3_paint=:  3 :  '3 setpaint  3{H'
setgl2_p4_paint=:  3 :  '4 setpaint  4{H'
setgl2_p5_paint=:  3 :  '5 setpaint  5{H'
setgl2_p6_paint=:  3 :  '6 setpaint  6{H'
setgl2_p7_paint=:  3 :  '7 setpaint  7{H'
setgl2_p8_paint=:  3 :  '8 setpaint  8{H'
setgl2_p9_paint=:  3 :  '9 setpaint  9{H'
setgl2_p10_paint=: 3 : '10 setpaint 10{H'
setgl2_p11_paint=: 3 : '11 setpaint 11{H'

setpaint=: 4 : 0
  glsel 'p'&,@": x
  SYMBSZ=: getSymbSz crdsz=. glqwh''
  glclear ''
  drawcard crdsz
  drawsymb y
  glpaint ''
)

setgl2_doit_button=: 3 : 0
  solve=: -. solve
  if. solve do. deal'' return. end.
  caption 'Solving..'
  s=. (] i."2 allsets) H NB. indices of cards in sets
  t=. (i.12) e."1 s  NB. Mask over cards in solutions
  l=. (|:t) <@# >:i.#s  NB. label for each card
  (i.12) wd@('set s'"_ , ":@[ , ' *'"_ , ":@])&> l
  caption 'Deal'
)

setgl2_close_button=: wd bind 'pclose'
setgl2_enter=: set_doit_button

setgl2_run ''
