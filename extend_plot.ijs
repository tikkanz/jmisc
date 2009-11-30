require 'plot'
((<'pzplot'),copath 'jwplot') copath 'jwplot'

coclass 'pzplot'
coinsert 'jzplot'

NB.*typereg v register plot type (framework)
typereg=: 4 : 0
  ('plot_',y,'_jzplot_')=: ('plot_',y,'_',(>coname''),'_')~ f.
  for_i. x do.
    ((>i),'_jzplot_')=: (((>i),'_jzplot_')~ -. <y),<y
  end.
  PlotTypes_jzplot_=: ~. PlotTypes2d_jzplot_,PlotTypes3d_jzplot_

  empty''
)

NB. sample custom plot type (plugin)
plot_hilo2=: 3 : 0
  'x y'=. getgrafxy y
  'r c'=. $y
  clr=. getitemcolor 2
  hilo=. ,./x,."1 [ 2{.y
  idx=. (0 > -/) _2{.y
  drawline iDATA;(idx{clr);PENSIZE;hilo
  dx=. 0.33*-/1 0{x
  if. r>:3 do.
    close=. x,.(2{y),.(x+dx),.2{y
    drawline iDATA;(idx{clr);PENSIZE;close
  end.
  if. r=4 do.
    close=. (x-dx),.(3{y),.x,.3{y
    drawline iDATA;(idx{clr);PENSIZE;close
  end.
)

plot_ohlc=: 3 : 0
  'x y'=. getgrafxy y
  'r c'=. $y
  if. r ~: 4 do.
    signal 'Four series required: open,high,low,close.'
  end.
  clr=. getitemcolor 2
  hilo=. ,./x,."1 [ 1 2{y
  idx=. (0 < -/) 0 3{y
  drawline iDATA;(idx{clr);PENSIZE;hilo
  dx=. 0.33*-/1 0{x
  close=. x,.(3{y),.(x+dx),.3{y
  drawline iDATA;(idx{clr);PENSIZE;close
  open=. (x-dx),.(0{y),.x,.0{y
  drawline iDATA;(idx{clr);PENSIZE;open
)

(;:'PlotTypes2d') typereg 'ohlc'
(;:'PlotTypes2d') typereg 'hilo2'


Note 'End-user code'
   HLCO=: (0 3 1 2&{@/:~)"1&.|: 4 30 ?.@$ 100
   'hilo'  plot 3{.HLCO
   'hilo2' plot 3{.HLCO
   'hilo2' plot    HLCO

  NB. Get data
  load 'csv'
  fn=. jpath '~system\examples\data\dm0396.txt'
  data=: 0". >4{.}.|: readcsv fn
  'ohlc' plot _50{."1 data
  'ohlc;pensize 2;markersize 2' plot _15{."1 data
  'ohlc' plot _100{."1 data
)


plot_sbarn=: 3 : 0
'x y'=. 2 {. y { Data
dat=. citemize y
pos=. makestackbarn dat
pos makedrawbar dat
)

makestackbarn_jzplot_=: 3 : 0
'r c'=. $y
wid=. BARWIDTH
w=. Gw * wid % c
t=. Gw * -: (-.wid) % c 
o=. |YMin % YMax-YMin
uh=. (1-o) * Gh
lh=. o * Gh
m=. 0&<:y
y=. m (* ,: -.@[*]) y
y=. +/\."2 y
h=. (uh,lh) * y % YMax,|YMin
h=. (-.m)} h
y=. Gy + lh + ,h
x=. Gx + ($y) $ t + Gw * }: int01 c
x,.y,.(x+w),.y-,h
)

(;:'PlotTypes2d') typereg 'sbarn'

Note 'usage'
   'sbarn' plot (],:|.)@:(,|.@:-) i.5

   dat=: |:(+0.5-[:?0$~#)^:(<100) 0 _4 4 0
   pd 'new'
   pd 'type sbarn; edgesize 0; barwidth 1;xtic 10 2'
   NB. next 2 lines in lieu of getmin, getmax edits to jzplot.ijs
   NB.minmax0=. (<./@:({."1) , >./@:({:"1)) (0&< +//. ])@/:~"1 |:dat
   NB.minmax1=: ('<./',:'>./') apply"1 (0&< ({.@[ |. +//.)"1 ])&.|: dat
   minmax=. ({.@:<./ , {:@:>./) (0&< +//. ])@/:~"1 |:dat
   pd 'yrange ',": _2.5 2.5 <.@:+ minmax
   pd  dat
   pd 'type line;color 0 0 0; pensize 2;xtic 10 2'
   pd +/dat
   pd 'show'    
)
