== Combining Existing Plot Types ==

These two forum threads (<<link|thread one>><<link|thread two>>) 
explored a number of methods of representing an Open, High, Low, Close or
<<http://www.amcharts.com/stock/ohlc-chart/|OHLC plot>>.

Data often in this form:
{{{
  load 'csv'
  fn=. jpath '~system\examples\data\dm0396.txt'
  data=: 0". >4{.}.|: readcsv fn
}}}


=== hilo and line plot ===
This first 
{{{
plot_hiloline=: 3 : 0
  ''plot_hiloline y
:
  hl=. 1 2{y
  oc=. 0 3{y
  ntics=. {:$hl
  oc=. (2#i.ntics); ,|:oc
  pd 'reset'
  pd 'xticpos ',": i.ntics
  pd x
  pd 'type line'
  pd oc
  pd 'type hilo'
  pd 'color red'
  pd hl
  pd 'show'
)
}}}
=== hilo and symbol plot ===
An appropriate font/symbol combination could be used to create 
the horizontal lines to mark the open & close. However the
symbols used in the example below 
(Box drawings light down and left, light down and right) 
cause problems if the open or close value equals, or is close 
to, the low value.
{{{
plot_hilosymbola=: 3 : 0
 ''plot_hilosymbola y
:
 hl=. 1 2{y
 oc=. 0 3{y
 ntics=. {:$hl
 pd 'reset'
 pd 'xticpos ',": i.ntics
 pd 'pensize 3'
 pd x
 pd 'type symbol'
 pd 'symbolfont Arial 18'
 pd 'symbols ',u: 9488 9484
 pd oc
 pd 'type hilo'
 pd hl
 pd 'show'
)
}}}

This alternative symbol choice is not as close to the traditional OHLC plot, 
but does not give distorted results in the cases described above:

{{{
plot_hilosymbolb=: 3 : 0
 ''plot_hilosymbolb y
:
 hl=. 1 2{y
 oc=. 0 3{y
 ntics=. {:$hl
 pd 'reset'
 pd 'xticpos ',": i.ntics
 pd 'pensize 3'
 pd 'symbolfont Arial 11'
 pd x
 pd 'color green,red'
 pd 'type symbol'
 pd 'symbols ',u: 9658 9668
 pd oc
 pd 'color blue'
 pd 'type hilo'
 pd hl
 pd 'show'
)
}}}

=== hilo and marker plot ===
A symbol that provides the perfect shape may not be available
in which case one solution to the problem is to create 
the desired shape by defining a custom marker.

{{{
Note 'Examples'
  NB. Get data
  load 'csv'
  fn=. jpath '~system\examples\data\dm0396.txt'
  data=: |: 0". >1 2 3 4{"1 readcsv fn
  NB. Plot data
  plot_ohlc _50{."1 data
  'pensize 2;markersize 2' plot_ohlc _5{."1 data
  plot_ohlc _100{."1 data
)

load 'plot'

isimark_lineleft_jzplot_=: 4 : 0
s=. rndint 4 1 * x
p=. (y -"1 s) ,"1 s
gpbuf ,gpcount 2031 ,"1 p
)

isimark_lineright_jzplot_=: 4 : 0
s=. rndint 4 1 * x
p=. (y -"1 s * 0 1) ,"1 s
gpbuf ,gpcount 2031 ,"1 p
)

MarkerNames_jzplot_=: MarkerNames_jzplot_,'lineleft';'lineright'

plot_hilomarker=: 3 : 0
 ''plot_hilomarker y
:
 hl=. 1 2{y
 oc=. 0 3{y
 xs=. i.{:$y
 msk=. (0 > -/) oc
 updwn=. #"1 ; -.@[ #"1 ] NB. box up & down series
 pd 'reset'
 pd 'pensize 1' NB.default
 pd 'markersize 1' NB.default
 pd x
 pd 'type marker'
 pd 'markers lineleft,lineright'
 opts=. 'color blue';'color red'
 pd &> opts ,. <"1 (msk updwn xs),. msk updwn oc
 pd 'type hilo'
 pd &> opts ,. <"1 (msk updwn xs),. msk updwn hl
 pd 'show'
)
}}}

=== hilo and floating bar ===
An alternative representation for OHLC data is the filled/hollow 
<<http://stockcharts.com/school/doku.php?id=chart_school:chart_analysis:what_are_charts|candlesticks chart>>.

A pretty good similie of a candlestick chart can be created
by combining a hilo plot with a floating bar. However because the
floating bar chart forces the yrange to include zero, small changes 
in values a long way from zero, don't show up well. If this problem were solved
the combination could also be useful for box-whisker plots.

{{{
plot_candlestick=: 3 : 0
 ''plot_candlestick y
:
 hl=. 1 2{y
 oc=. 0 3{y
 oc=. (<./ , (] (|@:*"1) 0&> ,: 0&<)@:-/) oc
 ntics=. {:$hl
 pd 'reset'
 pd 'xrange ',": _0.5+0,ntics
 pd x
 pd 'color blue'
 pd 'type hilo'
 pd hl
 pd 'color white,blue'
 pd 'barwidth 0.4'
 pd 'type fbar'
 pd oc
 pd 'show'
)

Note 'Candlestick examples'
'yrange 0 10' plot_candlestick data-65

NB.Here is an example of adding custom x labels:
lbls=: ;:^:_1 (8!:0 lbl) (<:lbl=.(>:i.10)*50%10)} 50#<'""'
('yrange 0 10;xlabel ',lbls) plot_candlestick data-65
)

}}}

== Creating new plot types ==

The Plot framework is quite modular and it is relatively easy to 
extend by creating new plot types. In <<link|this forum post>>, 
OlegKobchenko provided the following code for registering a 
new plot type. Two examples were also provided including an OHLC plot.

{{{
require 'plot'

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
}}}
