NB. cars.ijs
NB. 10/10/6
NB. Brian Schott with Oleg Kobchenko

NB. A simulation to observe a common driving BLIND SPOT.

NB. For a quick start press the '+' key repeatedly
NB. and watch the red car pass the blue car both
NB. in the birdseye view and in the 3 mirror views.

NB. All 3 mirrors are in the BLUE car being passed.
NB. Top    window shows the USUAL       adjustment for a center mirror.
NB. Middle window shows the RECOMMENDED adjustment for a left mirror.
NB. Bottom window shows the COMMON      adjustment for a left mirror.

NB. The key is to see that when the RED car gets close to the
NB. BLUE car, it is only visible in the middle RECOMMENDED mirror
NB. and NOT in either of the other two. Thus the RECOMMENDED
NB. adjustment eliminates a common BLIND SPOT.

NB. Other active keys include '-','[', and ']'.

NB. http://www.cs.wisc.edu/~gdguo/driving/BlindSpot.htm


require 'opengl'
cocurrent 'drawCars'
coinsert 'jzopenglutil'

require 'trig'

NB. some parameters
FollowPosition =: _144 _400
CarPosition =: 0 600

yangle =: 0 NB. mirror roll angle

mp =: +/ . *"2
pfv =: ,&1 NB. projection from vector
vfp =: pfv^:_1  NB. vector from projection

length =: +/&.:*:"1 
hyp =: {.@*.@j./

ify =: *&36            NB. inches from yards
cardim =. ify 2 5 1.5

I3 =:  =@i. 3
I4 =:  =@i. 4
'X Y Z' =: i. 3
'XX YY ZZ' =: 2#"0 i. 3
XYZ =: i. 3

Translate0 =: (] , 1:) 3} [
Translate =: I4&Translate0
Sin =: sin@rfd            NB. Sine in degrees
Cos =: cos@rfd            NB. Cosine in degrees
Arctan =: dfr@arctan
NB. for left-hand systems r is different for x, y, and z axis rotations
r=: (Cos,Sin),:(-@Sin,Cos)        NB. 2-dim rotation matrix in degrees
rx0=: (Cos,-@Sin),:(Sin,Cos)      NB. 2-dim rotation matrix in degrees
ry0=: (Cos,Sin),:(-@Sin,Cos)      NB. 2-dim rotation matrix in degrees
rz0=: rx0 
bip=: <"1@(,"0/~)                 NB. Table of boxed index pairs: do i 0 2 
R=: (r@])`(bip@[)`(=@i.@3:)}      NB. 3-dim rm: From axis 0 to 2 is 0 2 R a
rx=: (rx0@])`(bip@[)`(=@i.@3:)}   NB. 3-dim rm: From axis 2 to 1 is 2 1 rx a
ry=: (ry0@])`(bip@[)`(=@i.@3:)}   NB. 3-dim rm: From axis 0 to 2 is 0 2 ry a
rz=: (rz0@])`(bip@[)`(=@i.@3:)}   NB. 3-dim rm: From axis 1 to 0 is 1 0 rz a
r3points =: (2 0"_ ry 0&{) mp (1 2"_ rx 1&{) mp (0 1"_ rz 2&{)
NB. r3points q,p,r is q-rotate from axis 0 to 2 on p-r from 2 to 1 on r-r from 1 to 0

but =: [:#&XYZ-.@(XYZ&=)
butbx =: [:<@:;~but

ReverseX =: _1 (<XX)}I4           NB. reverse x axis
ReverseXYZ =: _1 (;/XX,YY,:ZZ)}I4 NB. Reverse xyz axes
Rotate180y =: (2 0 ry 180-yangle)(<XYZ;XYZ)}I4

placeeye =: dyad define
  NB. x is the mirror coordinates
  mangles =. y 
  Rot4 =. x arbRot Y{r3points yangle , mangles 
  mp&Rot4 &. (pfv"1) 0 0 0
)

arbRot =: dyad define
  'a b c' =. y 
  'aa bb cc' =. -a,b,c
  v =. hyp  a,b
  T =. Translate -x 
  R1in =. v%~(b,a),:aa,b
  R1 =. R1in (butbx Z)}I4
  R2in =. (v,c),:cc,v
  R2 =. R2in (butbx X)}I4
  Rotmain =. T mp R1  mp R2 
  Rotmain mp Rotate180y mp ReverseXYZ mp (%.Rotmain)
)

gsetdefaults''
GS_VIEWXYZ=: 0 0 1.4
GS_CLEARCOLOR=: WHITE
GS_CLEARCOLOR=: 64 148 32
GS_CLEARCOLOR=: 0.8 0.8 0.8
GS_POSITION=: 0 1 1 0
SCALE =: 0.0005
L_MODEL =: 100
BLUECAR =: 101
REDCAR =: 102
WHEEL =: 103

CARMIRROR=: 0 : 0
pc opengl;pn CarMirror;
xywh 0 0 200 150;cc g isigraph opengl rightmove bottommove;
pas 0 0;
rem form end;
)

opengl_run=: 3 : 0
wd CARMIRROR
ogl=: ''conew'jzopengl'
wd'setfocus g'
wd'pcenter;pshow;'
)

opengl_close=: 3 : 0
destroy__ogl''
ogl=: ''
wd 'pclose'
)

opengl_cancel=: opengl_close

init =: monad define
  QUADS=: {. > gluNewQuadric''
  makeWheel SCALE
  gsnewlist BLUECAR
  carlights SCALE
  head SCALE
  wheels SCALE
  gscolor BLUE
  carbody SCALE
  carbottom SCALE
  cargrill SCALE
  gsendlist''
  gsnewlist REDCAR
  carlights SCALE
  head SCALE
  wheels SCALE
  gscolor RED
  carbody SCALE
  carbottom SCALE
  cargrill SCALE
  gsendlist''
  drawmodel''
  gluDeleteQuadric QUADS
)

drawmodel=: monad define
  gsnewlist L_MODEL
  
  gscolor BLACK           NB. lane lines
  glLineStipple 1 ; 16bffcc
  glLineWidth 2
  glEnable GL_LINE_STIPPLE
  glBegin GL_LINES
  glVertex SCALE * _3[\ _36 _750  0 _36 750 0
  glEnd ''
  glDisable GL_LINE_STIPPLE
  glBegin GL_LINES
  glVertex SCALE * _3[\ _180 _750  0 _180 750 0
  glEnd ''
  glBegin GL_LINES
  glVertex SCALE * _3[\ 108 _750  0 108 750 0
  glEnd ''

  gscolor GRAY            NB. road
  glBegin GL_QUADS
  glVertex SCALE * 0,.~_180 _750,_180 750,108 750,:108 _750
  glEnd ''

  NB. cars
  glPushMatrix''
  glTranslate SCALE * CarPosition, 0
  glCallList BLUECAR
  glPopMatrix''
  glPushMatrix''
  glTranslate SCALE * FollowPosition, 0 
  glCallList REDCAR
  glPopMatrix''
  gsendlist ''
)


NB. =========================================================
fs =: (&*)(<.@)  NB. floored scaler

paint=: 3 : 0
  if.  gsinit GS_LIGHT do.
    init ''
  end.
  drawmodel''
  'w h'=. wh__ogl

  (0 0,(0.33 fs w), 1.00 fs h) view GS_VIEWXYZ,:GS_VIEWUP
  glCallList L_MODEL

  NB. ((0.33 fs w),0,(0.67 fs w),(0.33 fs h)) viewmirror sidemirrorcom
  ((0.42 fs w),(0 fs h),(0.5 fs w),(0.33 fs h)) viewmirror sidemirrorcom
  glCallList L_MODEL

  NB. ((0.33 fs w),(0.33 fs h),(0.67 fs w),(0.33 fs h)) viewmirror sidemirror
  ((0.42 fs w),(0.33 fs h),(0.5 fs w),(0.33 fs h)) viewmirror sidemirror
  glCallList L_MODEL

  NB. ((0.33 fs w),(0.66 fs h),(0.67 fs w),(0.34 fs h)) viewmirror centermirror
  ((0.33 fs w),(0.74 fs h),(0.67 fs w),(0.19 fs h)) viewmirror centermirror
  glCallList L_MODEL

  gsfini''
)

sidemirror =: 0
centermirror =: 1
sidemirrorcom =: 2

mfe =: mirrorfromeye =: 3 3$_21 28 _8.5 , 14 18 1.5
madj =: mirroradjustment =: 3 2$ _6  _8 , 3 19 , _7 _15.9
mwh =: mirrorsize =: 3 2$(1 *6 4), 8 2.25 

viewmirror =: 4 : 0
  take =. y&{
  eye2virt =. mfe placeeye&take madj
  eyeincar =.  18 _86 46+CarPosition, 0
  glViewport x
  glMatrixMode GL_PROJECTION
  glLoadIdentity''
  fovy =. +:Arctan -:(1{take mwh)%length take mfe
  aspect =. %/take mwh
  near =. SCALE*length take mfe
  gluPerspective  fovy,aspect,near, 10
  glMatrixMode GL_MODELVIEW 
  glLoadIdentity''
  glMultMatrix ,ReverseX
  eye =. SCALE*eye2virt+eyeincar
  mirror =. SCALE*eyeincar+take mfe
  gluLookAt eye,mirror, 0 0 1
)

view=: 4 : 0
  glViewport x
  glMatrixMode GL_PROJECTION
  glLoadIdentity''
  gluPerspective (-:-:  %/wh__ogl) 1 } GS_PERSPECTIVE
  glMatrixMode GL_MODELVIEW 
  glLoadIdentity''
  gluLookAt ({.y),0 0 0,{:y
  glTranslate GS_TRNXYZ
  glRotate GS_ROTNDX { GS_ROTXYZ ,. GS_ID3
)

carbody =: verb define
  glBegin GL_QUADS
  glVertex y * _3[\  0 _180 10     0 _180 39     0    0 29    0    0 10    NB. left
  glVertex y * _3[\ 72    0 10    72    0 29    72 _180 39   72 _180 10    NB. right
  glVertex y * _3[\  0    0 29    72    0 29    72    0 10    0    0 10    NB. front
  glVertex y * _3[\  0 _180 10    72 _180 10    72 _180 39    0 _180 39    NB. back
  glVertex y * _3[\  0  _72 32.33 72  _72 32.33 72    0 29    0    0 29    NB. hood
  glVertex y * _3[\  0 _180 39    72 _180 39    72 _108 35.67 0 _108 35.67 NB. trunk
  glEnd''
)

carbottom =: verb define
  gscolor BLACK
  glBegin GL_POLYGON
  glVertex y * _3[\ 0    0 10  0 _180 10 72 _180 10 72    0 10 NB. bottom
  glEnd''
)

cargrill =: verb define
  gscolor SILVER
  glBegin GL_POLYGON
  glVertex y * 0 0.2 0+"1]_3[\ 18    0 12    54    0 12    54    0 27   18    0 27   NB. grill
  glEnd''
)

head =: verb define
  glPushMatrix''
  gscolor SALMON
  glTranslate y*21 _98 44
  glRotate  90 1 0 0
  glScale 5 6 8 %8
  sphere (y*  5 ), 10 10
  glPopMatrix''
)

carlights =: verb define
  gscolor YELLOW
  glaMaterial GL_FRONT_AND_BACK,GL_EMISSION, alpha4 1 1 0 1
  glPushMatrix''
  glTranslate y*7 1 22.5
  headlight y
  glPopMatrix''
  glPushMatrix''
  gscolor YELLOW
  glTranslate y*65 1 22.5
  headlight y
  glPopMatrix''
  glaMaterial GL_FRONT_AND_BACK,GL_EMISSION, alpha4 0 0 0 1
)

headlight =: verb define
  glRotate  89 1 0 0
  disk (y *  0 5 ), 10 10
)

wheels =: verb define
  glPushMatrix''
  glTranslate y*_0.5 _30 15.9
  glCallList WHEEL
  glPopMatrix''
  glPushMatrix''
  glTranslate y*_0.5 _150 15.9
  glCallList WHEEL
  glPopMatrix''
  glPushMatrix''
  glTranslate y*72.5 _30 15.9
  glRotate  180 0 1 0
  glCallList WHEEL
  glPopMatrix''
  glPushMatrix''
  glTranslate y*72.5 _150 15.9
  glRotate  180 0 1 0
  glCallList WHEEL
  glPopMatrix''
)

makeWheel =: monad define
  gsnewlist WHEEL
  glPushMatrix''
  glRotate  90 0 1 0
  tread (y* 15 15 7), 10 1
  sideWheel y
  glPushMatrix''
  glTranslate y*0 0 7
  glRotate 180 0 1 0
  sideWheel y
  glPopMatrix''
  glPopMatrix''
  gsendlist ''
)

sideWheel =: monad define
  gscolor BLACK
  disk (y*  7 15 ), 10 10
  gscolor SILVER
  disk (y*  0  7 ), 10 10
)

sphere =: 3 : 0
  glPushMatrix''
  gluQuadricDrawStyle QUADS,GLU_FILL
  gluQuadricNormals QUADS,GLU_SMOOTH
  gluSphere <&> QUADS,y
  glPopMatrix''
)

disk =: 3 : 0
  glPushMatrix''
  gluQuadricDrawStyle QUADS,GLU_FILL
  gluQuadricNormals QUADS,GLU_FLAT  
  gluDisk <&> QUADS,y
  glPopMatrix''
)

tread=: 3 : 0
  glPushMatrix''
  gscolor BLACK
  gluQuadricDrawStyle QUADS,GLU_FILL
  gluQuadricNormals QUADS,GLU_SMOOTH
  gluCylinder <&> QUADS,y
  glPopMatrix''
)


'RIGHT BACK FWD LEFT'=: 0.2 0,_1 1,1 1,:_0.2 0
go=: 4 : 0/
FollowPosition=:((x*GS_SPEED*GS_UNITSTEP%SCALE)+y{FollowPosition)y}FollowPosition
)
NB. =========================================================
opengl_g_paint=: paint
opengl_g_char=:  3 : 0
select. {.sysdata
case. ']';'}' do. go RIGHT
case. '-';'_' do. go BACK
case. '=';'+' do. go FWD
case. '[';'{' do. go LEFT
case. do. gschar'' return.
end.
gspaint''
)
opengl_default=: gsdefault

NB. =========================================================
opengl_run''
