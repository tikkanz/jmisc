NB. quadexplorer.ijs Quadratic Equation Explorer
NB. See INFOTEXT at end of this file.

NB. Things we need...
require 'files isigraph numeric plot'

NB. Define this class (see end of script for invocation)
coclass  'quadExplorer'


NB. =========================================================
NB.
NB. 2005-02-06 1.00 KF Initial Release
NB. 2005-02-07 1.01 KF Plot reset and other fixes suggested
NB.                    by Oleg Kobchenko on J Forum
NB.                    (Actually a major refactoring,
NB.                     and coding style change.
NB.                     also much faster due to pd reset)
NB. 2005-02-09 1.02 KF Minor improvement, enterable data
NB.                     runs under Java version
NB. 2005-02-14 1.03 KF Format equation display and
NB.                     factorized display
NB. 2007-06-02 2.00 KF J6.01
NB. =========================================================
NB.
QUADVER=: 2.00
TITLE=: 'Quadratic Explorer V',(4j2 ": QUADVER)

NB. =========================================================
NB. Form definition
QUADFORM=: 0 : 0
pc quadform closeok;
menupop "&Options";
menu reset "&Reset" "" "" "";
menusep;
menu clip "&Copy to Clipboard" "" "" "";
menu saveeps "Save as &EPS" "" "" "";
menu savepdf "Save as &PDF" "" "" "";
menu print "P&rint" "" "" "";
menusep;
menu about "&About" "" "" "";
menusep;
menu exit "E&xit" "" "" "";
menupopz;
xywh 0 0 260 260;cc plotq isigraph;
xywh 276  70 130 70;cc quadtext static;cn "";
xywh 276 142 160  8;cc eqninfo1 static;cn "";
xywh 276 152 160  8;cc eqninfo2 static;cn "";
xywh 276 162 160  8;cc eqninfo3 static;cn "";
xywh 276 172 160  8;cc discrinfo static;cn "";
xywh 276 182 160  8;cc rootinfo1 static;cn "";
xywh 276 192 160  8;cc rootinfo2 static;cn "";
xywh 276 202 160  8;cc focallen static;cn "";
xywh 276 212 160  8;cc focalpt static;cn "";
xywh 276 222 160  8;cc vertexpt static;cn "";
xywh 267   4   8  8;cc ax static;cn "";
xywh 274   4  12  8;cc spina  spin;
xywh 286   2 180 10;cc avalue trackbar tbs_autoticks tbs_both tbs_enableselrange tbs_top;
xywh 468   2  30 10;cc avalx  edit;
xywh 267  16   8  8;cc bx static;cn "";
xywh 274  16  12  8;cc spinb  spin;
xywh 286  14 180 10;cc bvalue trackbar tbs_autoticks tbs_both tbs_enableselrange tbs_top;
xywh 468  14  30 10;cc bvalx  edit;
xywh 267  28   8  8;cc cx static;cn "";
xywh 274  28  12  8;cc spinc  spin;
xywh 286  26 180 10;cc cvalue trackbar tbs_autoticks tbs_both tbs_enableselrange tbs_top;
xywh 468  26  30 10;cc cvalx  edit;
xywh 267  40   8  8;cc hx static;cn "";
xywh 274  40  12  8;cc spinh  spin;
xywh 286  38 180 10;cc hvalue trackbar tbs_autoticks tbs_both tbs_enableselrange tbs_top;
xywh 468  38  30 10;cc hvalx  edit;
xywh 267  52   8  8;cc kx static;cn "";
xywh 274  52  12  8;cc spink  spin;
xywh 286  50 180 10;cc kvalue trackbar tbs_autoticks tbs_both tbs_enableselrange tbs_top;
xywh 468  50  30 10;cc kvalx  edit;
pas 0 0;pcenter;
rem form end;
)

NB. =========================================================
NB. Constructor
create=: 3 : 0
  wd QUADFORM
  HWND=: wd'qhwndp'
  wd 'pn *',TITLE

  NB. Create plot object
  pl=: conew 'jzplot'
  PForm__pl=: 'quadform'
  PFormhwnd__pl=: HWND
  NB. connect to plot on form
  PId__pl=: 'plotq'

  PShow__pl=: 0

  wd 'set quadtext *',TEXT1
  wd 'set ax *a'
  wd 'set bx *b'
  wd 'set cx *c'
  wd 'set hx *h'
  wd 'set kx *k'

  NB. trackbar data
  tsteps=: 0.1
  tcount=: 4
  titems=: 2 * tcount % tsteps
  thighv=: tcount
  tlowv=: - thighv
  tmid=: -: titems
  toffset=: - tmid

  reset_values ''

  do_quadratic ''

  wd 'pshow;'
)

NB. =========================================================
NB. Destructor
destroy=: 3 : 0
  wd 'pclose'
  codestroy ''
)

NB. =========================================================
NB. Formatters - formats sign based on value
plusf=: 3 : '((y<0){''+-''),'' '',": |y'
minusf=: 3 : '((y<0){''-+''),'' '',": |y'
plusfx=: 3 : '((y<0){'' -''),": |y'


NB. =========================================================
NB. Reset values
reset_values=: 3 : 0
  NB. Initial values
  a=: +: tsteps
  b=: 0
  c=: 0
  h=: 0
  k=: 0
)


NB. =========================================================
NB. Display Quadratic
do_quadratic=: 3 : 0
  pd__pl 'reset'

  set_trackbars ''

  focalL=: 1 % 4 * a               NB. Focal Length
  focalPY=: k + focalL             NB. Focal Point (Y axis)
  focalL=: | focalL                NB. Now make abs value
  discrim=: (*: b) - (4 * a * c)   NB. Discriminant
  sqrdisc=: %: discrim             NB. Square root of Discriminant
  roota=: ((-b) + sqrdisc) % +: a  NB. Roots
  rootb=: ((-b) - sqrdisc) % +: a
  wd 'set eqninfo1 *Equation: y = ',(plusfx a),'x^2 ',(plusf b),'x ',(plusf c),'   - or -'
  wd 'set eqninfo2 *Equation: y = ',(plusfx a),'(x ',(minusf h),')^2 ',(plusf k)

  if. (discrim < 0) +. (a = 0) do.
      wd 'set eqninfo3 *Not factored, no real roots'
  else.
      polyr=: p. c,b,a
      fx=: >0{polyr
      fa=: 0{ >1{polyr
      fb=: 1{ >1{polyr
      wd 'set eqninfo3 *Factored: y = ',(plusfx fx),'(x ',(minusf fa),')(x ',(minusf fb),')'
  end.

  wd 'set discrinfo *Discriminant: = ',(": discrim)
  wd 'set rootinfo1 *Root 1: = ',(": roota)
  wd 'set rootinfo2 *Root 2: = ',(": rootb)
  wd 'set focallen *Focal length: = ',(": focalL)
  wd 'set focalpt *Focal point: ( ',(": h),' , ',(": focalPY),' )'
  wd 'set vertexpt *Vertex: ( ',(": h),' , ',(": k),' )'

  NB. ploting...
  pd__pl 'textfont arial 36 bold italic'
  pd__pl 'textcolor darkslateblue'
  pd__pl 'textc 500 _10x Quadratic Explorer'
  pd__pl 'new 40x 20x -40x -70x'
  pd__pl 'xrange _8 8'
  pd__pl 'yrange _8 8'
  pd__pl 'ytic 0.5 1'
  pd__pl 'xtic 0.5 1'

  x=. steps _8 8 320
  pd__pl 'color green,blue,red'
  pd__pl 'type line;color green'
  pd__pl x;c + (b * x) + a * *:x
  pd__pl 'type line;color blue'
  pd__pl (h,h);(k,focalPY)
  pd__pl 'type marker;color red'
  pd__pl (h,h);(focalPY,focalPY)

  pd__pl 'show'
)


NB. =========================================================
NB. set trackbars based on values a,b,c,h,k
set_trackbars=: 3 : 0
  wd 'set avalx *',(0j5": a)
  wd 'set bvalx *',(0j5": b)
  wd 'set cvalx *',(0j5": c)
  wd 'set hvalx *',(0j5": h)
  wd 'set kvalx *',(0j5": k)

  apos=: 0 >. titems <. tmid + a % tsteps
  bpos=: 0 >. titems <. tmid + b % tsteps
  cpos=: 0 >. titems <. tmid + c % tsteps
  hpos=: 0 >. titems <. tmid + h % tsteps
  kpos=: 0 >. titems <. tmid + k % tsteps

  wd 'set avalue 0 ', (4j0":apos) ,' ', (0":titems) ,' 1 1'
  wd 'set bvalue 0 ', (4j0":bpos) ,' ', (0":titems) ,' 1 1'
  wd 'set cvalue 0 ', (4j0":cpos) ,' ', (0":titems) ,' 1 1'
  wd 'set hvalue 0 ', (4j0":hpos) ,' ', (0":titems) ,' 1 1'
  wd 'set kvalue 0 ', (4j0":kpos) ,' ', (0":titems) ,' 1 1'
)


NB. =========================================================
NB. Exit buttons
quadform_close=: quadform_exit_button=: destroy


NB. =========================================================
NB. About message
quadform_about_button=: 3 : 0
  ver=. 'Quadratic Explorer V',(4j2 ": QUADVER),INFOTEXT
  wdinfo 'Quadratic Explorer';ver
)


NB. =========================================================
NB. Slide controls
quadform_avalue_button=: 3 : 0
  apos=: ".avalue
  a=: tsteps * toffset + apos
  recalc_hk ''
  do_quadratic ''
)

quadform_bvalue_button=: 3 : 0
  bpos=: ".bvalue
  b=: tsteps * toffset + bpos
  recalc_hk ''
  do_quadratic ''
)


quadform_cvalue_button=: 3 : 0
  cpos=: ".cvalue
  c=: tsteps * toffset + cpos
  recalc_hk ''
  do_quadratic ''
)

quadform_hvalue_button=: 3 : 0
  hpos=: ".hvalue
  h=: tsteps * toffset + hpos
  recalc_bc ''
  do_quadratic ''
)

quadform_kvalue_button=: 3 : 0
  kpos=: ".kvalue
  k=: tsteps * toffset + kpos
  recalc_bc ''
  do_quadratic ''
)


NB. =========================================================
NB. Recalcs
recalc_hk=: 3 : 0
  NB. implicit change to h and/or k when a,b or c change
  h=: (-b) % +: a
  k=: c + (b * h) + a * *:h
)

recalc_bc=: 3 : 0
  NB. implicit change to b and/or c when h or k change
  b=: _2 * a * h
  c=: k + a * *:h
)

NB. =========================================================
NB. Spin controls
quadform_spina_button=: 3 : 0
  apos=: 0 >. titems <. (".avalue) + ".spina
  a=: tsteps * toffset + apos
  recalc_hk ''
  do_quadratic ''
)

quadform_spinb_button=: 3 : 0
  bpos=: 0 >. titems <. (".bvalue) + ".spinb
  b=: tsteps * toffset + bpos
  recalc_hk ''
  do_quadratic ''
)

quadform_spinc_button=: 3 : 0
  cpos=: 0 >. titems <. (".cvalue) + ".spinc
  c=: tsteps * toffset + cpos
  recalc_hk ''
  do_quadratic ''
)

quadform_spinh_button=: 3 : 0
  hpos=: 0 >. titems <. (".hvalue) + ".spinh
  h=: tsteps * toffset + hpos
  recalc_bc ''
  do_quadratic ''
)

quadform_spink_button=: 3 : 0
  kpos=: 0 >. titems <. (".kvalue) + ".spink
  k=: tsteps * toffset + kpos
  recalc_bc ''
  do_quadratic ''
)

NB. =========================================================
NB. Field entry
quadform_avalx_button=: 3 : 0
  a=: tlowv >. thighv <. 0".avalx
  recalc_hk ''
  do_quadratic ''
)

quadform_bvalx_button=: 3 : 0
  b=: tlowv >. thighv <. 0".bvalx
  recalc_hk ''
  do_quadratic ''
)

quadform_cvalx_button=: 3 : 0
  c=: tlowv >. thighv <. 0".cvalx
  recalc_hk ''
  do_quadratic ''
)

quadform_hvalx_button=: 3 : 0
  h=: tlowv >. thighv <. 0".hvalx
  recalc_bc ''
  do_quadratic ''
)

quadform_kvalx_button=: 3 : 0
  k=: tlowv >. thighv <. 0".kvalx
  recalc_bc ''
  do_quadratic ''
)


NB. =========================================================
NB. Reset button
quadform_reset_button=: 3 : 0
  reset_values ''
  do_quadratic ''
)

NB. =========================================================
NB. Output formats
NB. do a refresh first (do_quadratic)
quadform_clip_button=: 3 : 0
  do_quadratic ''
  pd__pl 'clip'
)

quadform_saveeps_button=: 3 : 0
  do_quadratic ''
  pd__pl 'eps'
)

quadform_savepdf_button=: 3 : 0
  do_quadratic ''
  pd__pl 'pdf'
)

quadform_print_button=: 3 : 0
  do_quadratic ''
  pd__pl 'print'
)


NB. =========================================================
NB. Resize
quadform_plot_size=: 3 : 0
  isi_show__pl 0
)

NB. =========================================================
NB. Key bindings
quadform_f1_fkey=: quadform_about_button
quadform_f10_fkey=: quadform_saveeps_button
quadform_f11_fkey=: quadform_savepdf_button



NB. =========================================================
NB. Text block
TEXT1=: 0 : 0
Quadratic equations can be expressed as:
   y =. c + (b * x) + a * *:x  i.e. y = ax^2 + bx + c
or in the vertex form of
   y =. k + a * *:(x - h)      i.e. y = a(x - h)^2 + k
This explorer also shows the vertex (h,k),
focal length and focal point of the
parabola described by the quadratic equation.

Move the slides to change the values of a,b,c,h and k.
)

NB. =========================================================
NB. INFOTEXT
INFOTEXT=: 0 : 0

A simple tool for exploring quadratic equations.

See: http://www.farnik.com

Copyright (c) 2005,2007 Kym Farnik (kym@farnik.com)

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software
and associated documentation files (the "Software"),
to deal in the Software without restriction, including
without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission
notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS.
)


NB. =========================================================
NB. Instantiate the class
cocurrent 'base'
'' conew 'quadExplorer'

NB. end.
