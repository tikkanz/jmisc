coerase<'rgtVisual' NB. debug - clear traces of globals
coclass 'rgtVisual'

NB. ---------------------------------------------------------
NB. This script creates a form that takes tacit sentences
NB. entered by the user in a text box and displays the
NB. selected format in a listbox.
NB. ---------------------------------------------------------

styles=: (4 : 0)"0 _
  ".'zzz=. ' , y
  res=. 5!: x <'zzz'
  <LF,~ , ,&LF@ucpboxdraw_jijs_"1 ": res
)

DISPLAY=: 0 : 0
pc display dialog;
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

FORMATS=: ;:'Box Linear Tree Parens'
RBFORMAT=: 'cbFormat'&,each FORMATS

display_run=: 3 : 0
  wd DISPLAY
  wd 'set box *',y
  wd 'setfont box ',FIXFONT,';setfocus box;'
  wd 'setfont tdisp ',FIXFONT,'; setenable tdisp 1;'
  syschild=: 0{::RBFORMAT
  wd 'set ',syschild,' 1;'
  box=: y
  update ''
  wd 'pshow;'
)

display_resume=: 3 : 0
  wd 'psel display'
  wd 'set box *',box=: y
  update''
)

display_close=: 3 : 0
  wd'pclose'
)

update=: 3 : 0
try.
  sidx=. 2 5 4 6 #~ 99".> RBFORMAT wdget wd 'qd'
  wd 'set tdisp *', utf8 ; sidx styles box
  catch.
  wd 'set tdisp *',13!:12 ''
end.
)

display_box_button=: update
('display_'&,each RBFORMAT,each<'_button')=: update

display=: display_run`display_resume@.((<'display') e. {."1@wdforms)

display=: 3 : 0
  if. (<'display') e. {."1@wdforms '' do.
    display_resume y
  else.
    display_run y
  end.
)

display_z_=: display_rgtVisual_

display '+/ % #'
