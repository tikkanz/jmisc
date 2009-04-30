coclass 'rgtVisual'
NB. ---------------------------------------------------------
NB. This script creates a form that takes tacit sentences
NB. entered by the user in a text box and displays the
NB. selected format in a listbox.
NB. ---------------------------------------------------------

style=: 5!:   NB. adverb

style2=: (4 : 0)"0 _
  rep=. 5!: x boxopen y
  LF,~ , ,&LF@ucpboxdraw_jijs_"1 ": rep
)

DISPLAY=: 0 : 0
pc display dialog;
xywh 291 167 44 12;cc cancel button leftmove topmove rightmove bottommove;cn "Close";
xywh 9 156 216 22;cc box edit topmove rightmove bottommove;
xywh 248 24 60 11;cc cbFormatBox checkbox leftmove rightmove;cn "Box Format";
xywh 248 40 60 11;cc cbFormatLinear checkbox leftmove rightmove group;cn "Linear Format";
xywh 248 55 60 11;cc cbFormatTree checkbox leftmove rightmove group;cn "Tree Format";
xywh 248 72 60 11;cc cbFormatParens checkbox leftmove rightmove group;cn "Parens Format";
xywh 240 11 95 80;cc format groupbox leftmove rightmove;cn "Display Style";
xywh 0 0 225 150;cc tdisp editm ws_hscroll ws_vscroll es_readonly rightmove bottommove;
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
wd 'setfont box ',FIXFONT,';setfocus box;' NB. FIXFONT is specified in user session
wd 'setfont tdisp ',FIXFONT,'; setenable tdisp 1;'
wd 'set cbFormatBox 1;'
RBFORMAT=: 'cbFormat'&,&.> ;:'Box Tree Linear Parens'
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
  sidx=. 2 4 5 6 2 {~ I. 99".> RBFORMAT wdget wd 'qd' 
  ".'ZZZ=: ' , y NB. ZZZ is a global dummy that holds the tacit entry
  rep=. ''
  bxset=. 9!:6''
  9!:7 ]0{BOXES_j_
NB.   for_s. sidx do.
NB.     rep=.rep, LF,~ , ,&LF@ucpboxdraw_jijs_"1 ": s style <'ZZZ'
NB.   end.
  rep=.rep, sidx style2 'ZZZ'
  9!:7 bxset
  wd 'set tdisp *', utf8 rep
  catch.
  wd 'set tdisp *',13!:12 ''
end.
)

NB. ---------------------------------------------------------
NB. event controls for objects on the text form
NB. ---------------------------------------------------------


display_cancel_button=: display_close

display_box_button=: display
display_cbFormatLinear_button=: display
display_cbFormatBox_button=: display
display_cbFormatTree_button=: display
display_cbFormatParens_button=: display

display_z_=: display_rgtVisual_

NB. display ''
