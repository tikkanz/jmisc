coclass 'rgtVisual'
NB. ---------------------------------------------------------
NB. This script creates a form that takes tacit sentences
NB. entered by the user in a text box and displays the
NB. selected format in a listbox.
NB. ---------------------------------------------------------

DISPLAY=: 0 : 0
pc display closeok dialog;
xywh 291 167 44 12;cc cancel button leftmove topmove rightmove bottommove;cn "Close";
xywh 9 156 216 22;cc box edit topmove rightmove bottommove;
xywh 248 24 60 11;cc rbFormatBox radiobutton leftmove rightmove;cn "Box Format";
xywh 248 40 60 11;cc rbFormatLinear radiobutton leftmove rightmove group;cn "Linear Format";
xywh 248 55 60 11;cc rbFormatTree radiobutton leftmove rightmove group;cn "Tree Format";
xywh 248 72 60 11;cc rbFormatParen radiobutton leftmove rightmove group;cn "Paren Format";
xywh 240 11 95 80;cc format groupbox leftmove rightmove;cn "Display Style";
xywh 0 0 225 150;cc tdisp listbox ws_hscroll ws_vscroll lbs_multiplesel rightmove bottommove;
pas 6 6;pcenter;
rem form end;
)

NB. ---------------------------------------------------------
NB. form creation
NB. ---------------------------------------------------------

NB. box=: 'NB. Function here'

display_run=: 3 : 0
wd DISPLAY
wd 'set box "',y,'";'
wd 'setfont box ',FIXFONT,';setfocus box;'
wd 'setfont tdisp ',FIXFONT,'; setenable tdisp 1;'
wd 'set rbFormatBox 1;'
RBFORMAT=: 'rbFormat'&,&.> ;:'Box Tree Linear Paren'
NB.if. 0 ~: 4!:0 <'wdq' do. wdq=: '' end.
update y
wd 'pshow;'
)

display_close=: 3 : 0
  wd'pclose'
)

NB. ---------------------------------------------------------
NB.  repaint if the form already exists, otherwise create it
NB. ---------------------------------------------------------

display=: 3 : 0
try.
   wd 'psel display;'
   if. 0=#y do. y=. box end.
   wd 'set box "',y,'";'
   update y
catch.
   display_run y          NB. create form
end.
)

NB. ---------------------------------------------------------
NB. repaint tdisp according to STYLE of box contents
NB. ---------------------------------------------------------

update=: 3 : 0
try.
  sidx=. {. 2 4 5 6 2 {~ I. 99".> RBFORMAT wdget wd'qd' 
  NB.sidx=. {.RBFORMAT (2 4 5 6 2 {~ 99 I.@:". >@:wdget) :: 2: wdq
  ".'ZZZ=. ' , y NB. ZZZ is a global dummy that holds the tacit entry
  NB.wd 'set tdisp *',;(<"1 ": STYLE < 'ZZZ'), each LF
  wd 'set tdisp *', ,LF,~"1 utf8@ucpboxdraw_jijs_"1 ": sidx style <'ZZZ'
  catch.
  wd 'set tdisp *',13!:12 ''
end.
)

NB. ---------------------------------------------------------
NB. event controls for objects on the text form
NB. ---------------------------------------------------------


display_cancel_button=: display_close

display_box_button=: display
display_rbFormatLinear_button=: display
display_rbFormatBox_button=: display
display_rbFormatTree_button=: display
display_rbFormatParen_button=: display

style=: 5!:
display_z_=: display_rgtVisual_

NB. display ''
