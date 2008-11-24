require 'plot'

plot_ohlc1=: 3 : 0
 ''plot_ohlc1 y
:
 hl=. 1 2{y
 oc=. 0 3{y
 ntics=. {:$hl
 pd 'reset'
 pd 'xticpos ',": i.ntics
 pd 'pensize 3'
 pd 'color blue'
 pd x
 pd 'type symbol'
 pd 'symbolfont Arial 18'
 pd 'symbols ',u: 9488 9484
 pd oc
 pd 'type hilo'
 pd hl
 pd 'show'
)

plot_ohlc2=: 3 : 0
  ''plot_ohlc2 y
:
  hl=. 1 2{y
  oc=. 0 3{y
  ntics=. {:$hl
  oc=. ,|:oc
  oc=. (2#i.ntics);oc
  pd 'reset'
  pd 'xticpos ',": i.ntics
  pd 'pensize 2'
  pd x
  pd 'type line'
  pd oc
  pd 'type hilo'
  pd 'color red'
  pd hl
  pd 'show'
)

plot_ohlc3=: 3 : 0
 ''plot_ohlc3 y
:
 hl=. 1 2{y
 oc=. 0 3{y
 pd 'reset'
 pd 'pensize 1'
 pd 'markersize 1'
 pd x
 pd 'color green,red'
 pd 'type marker'
 pd 'markers lineleft,lineright'
 pd oc
 pd 'color blue'
 pd 'type hilo'
 pd hl
 pd 'show'
)

plot_ohlc=: 3 : 0
 ''plot_ohlc y
:
 hl=. 1 2{y
 oc=. 0 3{y
 xs=. i.{:$y
 msk=. (0 > -/) oc
 updwn=. #"1 ; -.@[ #"1 ] NB. separate up & down series
 pd 'reset'
 pd x
 pd 'type marker'
 pd 'markers lineleft,lineright'
 opts=. 'color blue';'color red'
 pd &.> opts,. <"1 (msk updwn xs),. msk updwn oc
 pd 'type hilo'
 pd &.> opts,. <"1 (msk updwn xs),. msk updwn hl
 pd 'show'
)

plot_candlestick=: 3 : 0
 ''plot_candlestick y
:
 hl=. 1 2{y
 oc=. 0 3{y
 oc=. (<./ , (] (|@:*"1) 0&> ,: 0&<:)@:-/) oc
 pd 'reset'
 pd 'xrange ',": _0.5+0, {:$hl
 pd 'barwidth 0.4'
 pd x
 pd 'color blue'
 pd 'type hilo'
 pd hl
 pd 'color white,blue'
 pd 'type fbar'
 pd oc
 pd 'show'
)

Note 'examples'
require 'csv'
data2=: |: 0". >1 2 3 4{"1 readcsv jpath '~system\examples\data\dm0396.txt'
plot_ohlc1 data
'color red;pensize 2' plot_ohlc1 data
plot_ohlc2 data
plot_ohlc3 data
plot_ohlc data
'xlabel Feb Mar Apr May Jun' plot_ohlc1 data
'xticpos 0 1 2 3 4;xlabel Feb Mar Apr May Jun' plot_ohlc data
'xtic 2 1;xticpos 0 2 4;xlabel Feb Apr Jun' plot_ohlc data
'xticpos 2 50 97;xlabel Aug Oct Jan' plot_ohlc _100{."1 data2

plot_candlestick data
'yrange 60 80' plot_candlestick data
'yrange 0 10' plot_candlestick data-65

lbls=: ;:^:_1 (8!:0 lbl) (<:lbl=.(>:i.10)*50%10)} 50#<'""'
('yrange 0 10;xlabel ',lbls) plot_candlestick _65+_250{."1 data2
)

data=: 0".> <;._2 ] 0 : 0
71.93 72.99 73.32 71.89 73.86
   72    73  73.6  72.2  74.3
 71.5 72.25  73.2  71.8  73.2
 71.7  72.3  73.5    72    74
)

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
