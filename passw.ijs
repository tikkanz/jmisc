NB. literate program from http://www.jsoftware.com/jwiki/AndrewNikitin/Literate#passw.ijs

NB. (C) 1997 Andrew Nikitin
NB. This is free software. You may use, copy, modify and distribute it at your
NB. own risk.
NB. May start external editor (originally, notepad).
NB. May contain toxic waste. Do not eat.
ALPH_LOW=:a.{~ (a.i.'a')+i.26
ALPH_UP=:a.{~ (a.i.'A')+i.26
ALPH_DIG=:a.{~ (a.i.'0')+i.10
ALPH_HEX=:a.{~ (a.i.'a')+i.6
SIMILAR=:'OQ0Do';'Il1';'2Zz';'5Ss';'8B';'9g';'6G'
OPENFILECMD=:'notepad c:\password.txt' NB. please, no double quotes (")
GPSW=: 0 : 0
pc gpsw;pn "Generate password";
xywh 3 3 124 11;cc pwd edit ws_border es_autohscroll;
xywh 3 15 64 9;cc al checkbox;cn "allow &lowercase";
xywh 3 25 64 9;cc au checkbox;cn "allow &uppercase";
xywh 3 35 64 9;cc ad checkbox;cn "allow &digits (0-9)";
xywh 3 45 76 9;cc ah checkbox;cn "allow &hex digits (a-h)";
xywh 3 55 64 9;cc es checkbox;cn "exclude &similar";
xywh 85 15 43 9;cc static static ss_center;cn "Password l&ength";
xywh 128 15 12 9;cc len static ss_center;cn "8";
xywh 85 25 52 9;cc size scrollbar;
xywh 85 35 52 9;cc strength static;
xywh 85 45 63 14;cc runvim button;cn "Open password list";
xywh 24 65 40 14;cc gp button bs_defpushbutton;cn "&Generate";
xywh 69 65 40 14;cc save button;cn "&Save";
pas 3 3;pcenter;
rem form end;
)

gpsw_cancel_button=: 3 : 0
wd 'pclose;'
)

gpsw_exit_button=: 3 : 0
gpsw_cancel_button ''
)

gpsw_close=: 3 : 0
gpsw_cancel_button ''
)
gpsw_run=: 3 : 0
wd GPSW
wd 'pshow;'
wd 'set size 6 8 32 5'
wd 'set al 1'
9!:1 [ 60 60 24 #. |. _3 {. <. (6!:0 '')
)
rsel=: ;@:(({~ ?@#)&.>)@(-.&a:)
flt=: ;@[ -. ;@[ -. ]
rrsame =: 3 : 0
x=.(flt&y)&.>SIMILAR
(y -. ;x) , rsel x
)
gpsw_gp_button=: 3 : 0
alph=.;("."0 al,au,ad,ah)#(ALPH_LOW;ALPH_UP;ALPH_DIG;ALPH_HEX)
alph=.~.alph,'01'#~0=#alph
if. '1'=es do.
  alph=.rrsame alph
end.
wd 'set strength *entropy ',(":<.(".size)*2^.#alph),' bits'
p=.alph {~ ? (". size)##alph
wd 'set pwd *',p
wdclipwrite p
)
gpsw_au_button=: gpsw_gp_button
gpsw_al_button=: gpsw_gp_button
gpsw_ah_button=: gpsw_gp_button
gpsw_ad_button=: gpsw_gp_button
gpsw_es_button=: gpsw_gp_button
gpsw_size_button=: 3 : 0
  wd 'set len *',size
  gpsw_gp_button ''
)
gpsw_save_button=: 3 : 0
 wdinfo 'Save password to password list';'Not implemented yet'
)
gpsw_runvim_button=: 3 : 0
wd 'winexec "',OPENFILECMD,'"'
)
gpsw_run ''
