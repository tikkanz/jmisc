cocurrent 'rgtVisual'
NB. ---------------------------------------------------------
NB. This script creates a form that takes tacit sentences
NB. entered by the user in a text box and displays the
NB. selected format in a listbox.
NB. ---------------------------------------------------------

DISPLAY=: 0 : 0
pc display dialog;
xywh 386 330 44 12;cc cancel button leftmove topmove rightmove
bottommove;cn "Close";
xywh 9 309 317 22;cc box edit topmove rightmove bottommove;
xywh 343 24 60 11;cc rbFormatBox radiobutton leftmove rightmove;cn "Box Format";
xywh 344 40 60 11;cc rbFormatLinear radiobutton leftmove rightmove
group;cn "Linear Format";
xywh 344 55 60 11;cc rbFormatTree radiobutton leftmove rightmove
group;cn "Tree Format";
xywh 344 72 60 11;cc rbFormatParen radiobutton leftmove rightmove group;cn "Paren Format";
xywh 333 11 95 80;cc format groupbox leftmove rightmove;cn "Display Style";
xywh 0 0 326 299;cc tdisp listbox ws_hscroll ws_vscroll
lbs_multiplesel rightmove bottommove;
pas 6 6;pcenter;
rem form end;
)

NB. ---------------------------------------------------------
NB. form creation
NB. ---------------------------------------------------------

display_run=: 3 : 0
wd DISPLAY
wd 'setfont box ',FIXFONT,';setfocus box;set box "+/%#";'
wd 'setfont tdisp ',FIXFONT,'; setenable tdisp 1;'
wd 'set rbFormatBox 1;'
RBFORMAT=: 'rbFormat'&,&.> ;:'Box Tree Linear Paren'
box=: uucp '+/%#'              NB. set default display directly
update ''
wd 'pshow;'
)

NB. ---------------------------------------------------------
NB.  repaint if the form already exists, otherwise create it
NB. ---------------------------------------------------------

display=: 3 : 0
try.
   wd 'psel display;'
   update ''
catch.
   display_run''          NB. create form
end.
)

NB. ---------------------------------------------------------
NB. repaint tdisp according to STYLE of box contents
NB. ---------------------------------------------------------

update=: 3 : 0
try.
   sidx=: {. 2 4 5 6 2 {~ I. 99".> RBFORMAT wdget wdq 
   ".'ZZZ=: ' , box NB. ZZZ is a global dummy that holds the tacit entry
   NB.wd 'set tdisp *',;(<"1 ": STYLE < 'ZZZ'), each LF
   wd 'set tdisp *', ,LF,~"1 utf8@ucpboxdraw_jijs_"1 ": sidx style <'ZZZ'
   catch.
   wd 'set tdisp *', 'Not a valid tacit expression'
end.
)

NB. ---------------------------------------------------------
NB. event controls for objects on the text form
NB. ---------------------------------------------------------

display_close=: 3 : 0
wd'pclose'
)

display_cancel_button=: display_close

display_box_button=: update
display_rbFormatLinear_button=: update
display_rbFormatBox_button=: update
display_rbFormatTree_button=: update
display_rbFormatParen_button=: update

style=: 5!:

display_run ''
