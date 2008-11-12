cocurrent 'surfaceplot'

NB. Sample matrix
NB. To plot matrix, type graph_3d matrix
NB.

caa=: 210796 26450 232147 49752 10592 1693 561 54 37
caa=: caa,: 43630 270068 58591 308775 45479 13970 7722 1690 215
caa=: caa, 47948 68430 238394 109814 159203 57948 4497 409 296
caa=: caa, 751706 79933 65107 274518 72827 90617 31977 15441 5668
caa=: caa, 70536 384467 118960 160723 110852 62506 22595 6345 2693
caa=: caa, 106916 58166 285361 201097 120223 111911 41257 21271 7039
caa=: caa, 144167 173662 106170 113561 75593 93620 50022 36618 7536
caa=: caa, 649254 71984 148516 77207 75384 49065 48700 26055 13792
caa=: caa, 29656 562616 109530 34422 25562 19361 17604 19836 9661
caa=: caa, 118301 45600 616206 53199 15254 8120 5313 10964 5787
caa=: caa, 235590 158941 92356 384646 50599 9357 3239 3481 2842
caa=: caa, 19922 161637 130597 72334 219788 18960 4967 3556 1835
caa=: caa, 55634 19468 192823 106061 55066 150588 12466 2873 1253

NB.

NB.===========================================================
NB.
NB. Create form
NB.

GRAPH =: 0 : 0
pc graph;
pn "Graph Generator";
menupop "File";
menu new "&New" "" "" "";
menu open "&Open" "" "" "";
menusep;
menu exit "&Exit" "" "" "";
menupopz;
xywh 10 5 44 12;cc ok button;cn "OK";
xywh 265 2 44 12;cc cancel button;cn "Cancel";
xywh 21 23 281 221;cc graphinform isigraph ws_border;
xywh 63 255 177 11;cc xaxis scrollbar;
xywh 63 271 177 11;cc yaxis scrollbar;
xywh 63 288 176 11;cc zaxis scrollbar;
xywh 15 256 35 11;cc xvalue static ss_center;
xywh 15 271 33 12;cc yvalue static ss_center;
xywh 16 287 46 11;cc zvalue static ss_center;
pas 6 6;
rem form end;
)

NB.================================================

GRAPH_3D =: 3 : 0
require 'jzplot'
matrix =: y
wd GRAPH
wd 'set xaxis 100 150 200 5'
wd 'set yaxis 100 150 200 5'
wd 'set zaxis 100 150 200 5'
formplot=: conew 'jzplot'
PForm__formplot =: 'graph'
PFormhwnd__formplot =: wd 'qhwndp'
PId__formplot =: 'graphinform'
xa=: 1
ya=: 1
za=: 1
wd 'pshow;'
)

graph_close=: 3 : 0
wd'pclose'
)

graph_cancel_button=: 3 : 0
graph_close''
)

graph_ok_button=: 3 : 0
wdinfo 'OK button pressed'
)

graph_chart_char=: 3 : 0
vp=. 'viewpoint',' ',(":xa),' ',(":ya),' ',(":za),';'
('surface;viewsize 1 1 0.5;',vp) plot__formplot matrix
)

graph_xaxis_button =: 3 : 0
xa =: 10 *  ((". xaxis)-100)%(200 - 100)
wd 'set xvalue *','X = ',": xa
graph_chart_char''
)

graph_yaxis_button =: 3 : 0
ya =: 10 *  ((". yaxis)-100)%(200 - 100)
wd 'set yvalue *','Y = ',": ya
graph_chart_char''
)

graph_zaxis_button =: 3 : 0
za =: 10 *  ((". zaxis)-100)%(200 - 100)
wd 'set zvalue *','Z = ',": za
graph_chart_char''
)

GRAPH_3D caa