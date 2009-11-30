NB. NB. tgsj3ogl.ijs
NB. Brian Schott
NB. 6/8/3
NB. revise 7/15/3
NB. revise 11/20/5
NB. revise 6/6/6
NB. revise 12/18/6 replace eye 1000's with 6's on 249, 1964, 2309

NB. key turtle commands              ***************
NB. yw     yaw turtle(s) clockwise
NB. rl     roll turtle(s) clockwise
NB. pt     pitch turtle(s) upward
NB. fd     move turtle(s) forward
NB. bk     move turtle(s) backward
NB. ju     jump turtle(s) upward
NB. jr     jump turtle(s) n the 90 degrees right direction
NB. goto   move turtle(s) to position(s)
NB. home   move turtle(s) to original position(s)
NB. eyeto  move eye to position and alter its gaze
NB. pu     change penstate(s) to up
NB. pd     change penstate(s) to down
NB. pc     change the pencolor(s)
NB. cs     clear the drawing screen
NB. iTS    initialize the turtle population
NB. re     reset eye to snap position

require 'opengl'

gsgenlist=: 3 : 0
  bgn=. >:>./LISTS,0
  if. 2 = 3!:0 y do.
    nms=. ;: y
    r=. bgn + i.#nms
    (nms)=: r
  else.
    r=. bgn + i.y
  end.
  LISTS=: LISTS,r
  r
)

GS_POSITION_jzopenglutil_ =: 1 1 1 1

gspaint_jzopenglutil_ =: 3 : 'if. paintQ do. GS_PAINTER~'''' end.'
paintQ =: 0

gskey_jzopenglutil_=: 4 : 0
  select. y
  case. 33;34 do.
    ((x { 1 5) * GS_SPEED*GS_UNITROT gschgsign y=34) gsfly GS_VIEWXYZ
    DIR =: 2
  case. 37;39 do.
    ((x { 1 5) * GS_SPEED*GS_UNITROT gschgsign y=37) gsfly GS_VIEWUP
    DIR =: 1
  case. 38;40 do.
    ((x { 1 5) * GS_SPEED*GS_UNITROT gschgsign y=40) gsfly GS_VIEWXYZ gscross GS_VIEWUP
    DIR =: 0
  case. 88;89;90 do.
    b=. y=88 89 90
    (b i. 1) gsrotate GS_SPEED*GS_UNITROT * b gschgsign x
  case. 73;79 do. gszoom (>:GS_SPEED*GS_UNITSCALE) ^ {. (x { 1 5) gschgsign y=73
  case. 74;75;76 do.
    gstranslate GS_SPEED*GS_UNITSTEP * (y=74 75 76) gschgsign x
  case. <@>49+i.10 do.
    GS_SPEED=: GS_SPEEDS {~ y-49
  end.
  EyeQ =: 1   NB. Flag for programmed eye movement
)

gsfly_jzopenglutil_=: 4 : 0
  DEGREE =: x
  ROT =: rot=. (rfd x) gsrotxyz y
  GS_VIEWXYZ=: rot gsmp GS_VIEWXYZ
  GS_VIEWUP=: rot gsmp GS_VIEWUP
)

gsrotate_jzopenglutil_=: 3 : 0
  DIR =: {:GS_ROTNDX
  DEGREE =: -DIR{y
  tmp =. (GS_VIEWXYZ gscross GS_VIEWUP),GS_VIEWUP,:GS_VIEWXYZ
  ROT =: (rfd DEGREE) gsrotxyz DIR{tmp
  GS_ROTXYZ=: 360 | GS_ROTXYZ + y
  :
  if. x ~: {:GS_ROTNDX do. gsflip x end.
  gsrotate y
)

gssnap_jzopenglutil_=: 3 : 0
  j=. 'GS_ROTNDX GS_ROTXYZ GS_SPEED GS_TRNXYZ GS_VIEWUP GS_VIEWXYZ'
  j=. gspack j,' GS_UNITROT GS_UNITSTEP GS_UNITSCALE'
  GS_STATE1=: j,'He0';He0  NB. added initial Heading to list
  if. y=0 do. GS_STATE0=: j ,'He0';eye Heading end. NB. a noop?
    empty''
)

gspdef_jzopenglutil_=: 3 : 0
  if. 0 e. $y do. empty'' return. end.
  names=. {."1 y
  if. #names do. (names)=: {:"1 y end.

  NB. added for synchronizing turtle database
  Heading =: He0 Eye}Heading
  heading =. , allRot rfd ,:He0
  State =: heading (;/Eye,. SN aindex 'Heading')}State
  position =. GS_VIEWXYZ
  Position =: position Eye}Position
  State =: position(;/Eye,.SN aindex'Position')}State  
  EyeQ =: 0   NB. Flag for programmed eye movement

  names
  :
  names=. {."1 y
  nl=. ;: ::] x
  gspdef (names e. nl)#y
)

glaGetMatrix =: 3 : 'r[glGetFloatv  y;r =. 16#0.1'

NB. usage: gluAtLook |:_4]\glaGetMatrix GL_MODELVIEW
gluAtLook_jzopenglutil_=:3 :0
  eye=. -3 7 11 {,y %. y*-.(i.4 4)e.3 7 11
  scale=.+/&.:*: eye
  's up nf'=. 3 3 {.y
  center=. eye-scale*nf
  eye,center,up
)

re =: reseteye =: 3 : 'empty[gspaint gspdef GS_STATE1'

NB. show   report the state of the turtle(s)
NB. delay  change to slow or speed up drawings
delay =: 6!:3
DELAY =: 0

NB. set sm =: smoutput to see  intermediate steps of 
NB.    some multi-step verbs.
sm =: smoutput
sm =: [  

NB. ***********************************************************
NB. Table of Contents
NB. suggesting some example moves    *************** START HERE
NB. setting global parameter values  ***************
NB.    ***begin 'bmsturtle3' locale***
NB. defining some globals            ***************
NB. perspective drawing              ***************
NB. main turtle control              ***************  
NB. main graphics initialization     ***************  
NB. turtle state dbase verbs         ***************  
NB. main graphics update verbs       ***************  
NB. turtle creation                  ***************  
NB. setting turtle parameter values  ***************
NB. turtle initialization verbs      ***************
NB. ***********************************************************

NB. Generally verbs, adverbs and conjunctions in this
NB.    script have names starting with lower case;
NB.    nouns have names beginning with upper case
NB.    except local nouns in explict definitions,
NB.    which are often lower case.

NB. suggesting some example moves    ***************

help =: 0 : 0
  NB. You can experiment with the system after "running"
  NB.   the script file, by placing your cursor on each
  NB.   line in turn and pressing Control-r . 
  NB. It's easier to use the Control-r trick if first
  NB.   you copy this information to a "New ijs" window
  NB.   (created with "^N").
  NB. You should see the graphics screen change and you
  NB.   may get feedback on the text .ijx screen, too.

  yw 0  NB. shows the turtle's or turtles' heading(s) 
  fd 0  NB. shows the turtle's or turtles' position(s)
  fd 10 _20
  yw 30 90
  fd 20 10
  yw 90 30


  cs ''
  iTS 2 NB. restores all params to original values
  yw 0  NB. shows the turtle's or turtles' heading(s)
  fd 0  NB. shows the turtle's or turtles' position(s)
  fd 10 _20
  yw 30 90
  fd 20 10
  yw 90 30  

  cs ''
  ''[iTS 2 NB. output suppressed with ''[
  yw 0
  2 repeats fd 5 _5
  4 repeats do'yw 90[fd 20'   NB. do argument read from right
  4 repeats dO'fd 20[yw 90'   NB. dO argument read from  left
  SC =: SC0  NB. reinitialize StateChange database
  20 repeats do 'yw 18[5 repeats do ''yw 72[fd 43'''
  +/"_1 SC    NB. determine amount of change
  avg"_1 SC   NB. determines average change
  25 _25 (2 repeats fdyw) 30 30[cs'' NB. "fdyw" has left and right args

  cs ''
  yw 0
  fd 0
  penup 0   NB. no change to turtle 1; penup for 0
  fd 25 _25
  fd 25 _25
  show 0

  cs ''
  ''[iTS 3
  pendown 2 0  NB. no change to turtle 1, pendown turtles 0 and 2
  10 5 _5(5 repeats fdyw) 30 30 30
  show 1 2

  cs ''
  ''[iTS _5  NB. negative number for number of turtles!
  yw 0

  NB. Next example shows a pair of helix-like paths.
  cs ''
  ''[iTS 2
  17 (15 repeats poly3)30
  NB. above works but destroys keystroke gldemo commands
  NB.      an open problem may be related to 'repeats'

  Eye goto 0 0 4 
  0.1 0 0 eyeto 0 0 4
  re''    NB. returns Eye to its snap position
)

cocurrent 'bmsturtle3'           NB. give system its own locale
coinsert 'jzopengl jzopenglutil'

NB. setting global parameter values  ***************

''[do COLORTABLE

Bkgrd =: White
Pen =: Black
STIPPLE =: 16b3f07
Safecolors =: }.(,~-:)_1&=_1 ^ #: i.8
Headcolors =: Brown,:LightSalmon
Step_scale =: %250

NB. 3D eye information
Pe0 =: 0 0 6
He0 =: 0 0 _90

Eye =: 1               NB. add one turtle for the eye
eye =: Eye&{           NB. must always be changed after Eye

NB. defining some globals            ***************

NB. matrix and vector verbs
mp =: +/ . *
x =: mp"2
mfv0 =: _3&(]\)"1    NB. matrix from vector
length   =: +/&.:*:"1
sqlength =: +/&: *:"1
nrmlz =: ] % [: length ]

NB. verbs for drawing lines and rotating turtles
tfd =: turtlefromdegrees =: rfd @: (360&|)@:(90&+)  @: -
dft =: degreesfromturtle =: 360&| @: dfr @: (-@:(-&(pi%2)))
dfd =: degreesfromdegrees =: 360&|&.(180&-)

NB. perspective drawing              ***************
vfp =: }:%{:             NB. vector from projection
pfv =: ,&1 :. vfp        NB. projection from vector
hfm =: 0 0 0 1"_,.~], 0: NB. homogeneous from matrix

NB. some parameters
I3 =:  =@i. 3
i3 =: I3"_
I4 =:  =@i. 4
'X Y Z' =: i. 3
'XX YY ZZ' =: 2#"0 i. 3
XYZ =: i. 3

'RlRow YwRow PtRow' =: i. 3
AllRow =: i. 3
PtPlane =: 1 2
YwPlane =: 0 1
RlPlane =: 2 0

NB. for hyp and angle between hyp and side of right triangle
la =: lengthangle =: *.@*@(j./)  NB. extra * provides tolerance
ang =: {:@la
hyp =: {.@la

vfe =: 1 0&(but"0@[ |."1@:{])     NB. distance of view from eye
angFdist =: *@[ * [:dfd@:dfr @:ang"1@] vfe@]

NB. angle between two vectors
sp =: [: +/ *                     NB. sum of products
angle =: [: arccos sp&nrmlz       NB. angle between two vectors
cst =:C.!.2@(#:i.)@:#~
cross1 =: [mp cst@#@[mp]

ywProj =: (([ mp 0&{@]),([ mp 1&{@]))"1 2
ptProj =: (([ mp 1&{@]),([ mp 2&{@]))"1 2
rlProj =: (([ mp 0&{@]),([ mp 2&{@]))"1 2

translate0 =: (-@] , 1:) 3} [
translate =: I4&translate0

but =: [:#&XYZ-.@(XYZ&=)
butbx =: [:<@:;~but
All0Q =: *./@:(0&=)     NB. all values equal 0
nAll0Q =: -.@:All0Q     NB. not all values equal 0
allNNeg =: *./@:(0&<:)  NB. all values nonnegative

axes0y =: (-@{.,{:),:({:-@,{.)
axesy =: axes0y % hyp
yrotaxes0 =: axesy@] (butbx Y)}I4"_
yrotaxes =: (I4"_`yrotaxes0@.nAll0Q)"1

axes0x =: (-@{.,{:),:({:-@,{.)
axesx =: axes0x % hyp
xrotaxes0 =: axesx@] (butbx X)}I4"_
xrotaxes =: (I4"_`xrotaxes0@.nAll0Q)"1

zrotaxes =: xrotaxes

rot90 =: (3 3$1 0 0 0 0 _1 0 1 0)&mp  NB. Eye from opengl Eye
reverseZ =: mp&(3 3$1 0 0 0 1 0 0 0 _1)  NB. Eye from opengl Eye

col =: &({"1)                 NB. adverb for columns
rx0=: (cos,sin),:(-@sin,cos)
ry0 =: (cos,-@sin),:(sin,cos)
ry0 =: rz0 =: rx0
bip=: <"1@(,"0/~)                 NB. Table of boxed index pairs
bipx =: (bip PtPlane)"_
bipy =: (bip RlPlane)"_
bipz =: (bip YwPlane)"_

rx=: ''&(rx0@]`bipx`i3})"0
ry=: ''&(ry0@]`bipy`i3})"0
rz=: ''&(rz0@]`bipz`i3})"0

ptRot =: rx
rlRot =: ry
ywRot =: rz@:-
NB. extra space in AllRot needed for allRot, 
NB.   but must be deleted from rot in turn and advance
AllRot =: ,&' 'each ;:'rlRot ywRot ptRot' NB. for priming Heading
allRot =: [: x/"_1 [: ".&> AllRot"_ ,each"1 [: ] [: <&":"0 ]
A =: @(i.@$@])                            NB. for revising Heading
dtb =: #~ ([: +./\. ' '&~:)

NB. verbs for checking & massaging input and output nouns 
NB.    for verbs and conditions
arow =: ,"1                  NB. append rows
copies =: $,:
yxs =: $~#                   NB. copy x to number of y's
n1s =: ##1:
amend0f1 =: (0:`]`(n1s@[) )} NB. usage: State amend0f1 Eye
pvfc =: [: ; {.&1&.>         NB. Partition vector from count
rankinc =: ,@]$~-@[{.!.1 $@] NB. increase rank of y to x's value
mat =: 2&rankinc             NB. increase rank of y to a matrix
rankincI =: ,:"1             NB. increase rank of y's items
lr=: 3 : '5!:5 <''y'''      NB. linear representation
cleanz =: 1e_10&$: :] * |@] >: [ NB. clean values near 0

neqQ =: =&#                  NB. argument #s     equal?
nneQ =: ~:&#                 NB. argument #s not equal?
okvaluesQ =: [:  *./ +./@(=/) NB. check x values against y values
mtQ =: 0&e.@$                NB. empty

changetodown =: -.@[`[`1:  @.(>:@])"0 NB. change pen
changetoup   =: -.@[`[`0:  @.(>:@])"0 NB. change pen

IVC =: InitialVerbCharacters =: a.{~91,97+i. 26
verbB =: [ e.~ [: {.&> [: ;: ] NB. creates a boolean list marking verbs
dO =: IVC&([: ". [: ; [: |. verbB <@(;:^:_1);.1 ;:@])

NB. Fraser Jackson contributed the next three verbs:
NB.  rep, repeat, and (O)on

NB.  rep Generates code to be executed
rep =: 3 : 0
  'n action' =: y
  (n*#action)$action
)

NB.  repeat displays
repeat =: 3 : 0
  ".rep y
)
NB. *then v laminates two vectors otherwise uses join
then =: 4 : 0
  dx =. $$x
  dy =. $$y
  if. (dx>2)+. dy>2 do. 'Domain Error' return. end.
  if. (dx<2)*. dy<2 do. x,:y return. end.
  x,y
)  

NB.  square
NB. repeat 4 ; 'fd 30' then 'yw 90'

NB.  rotated squares
NB. repeat 24 ; (rep 4; 'fd 30' then 'yw 90') then 'yw 15'

input =: 1!:1@1:
dOO =: verb define
  90 dOO y
  :
  if. y-:'' do.y =. 5 end.
  select. input''
  case. ,'' do. return. 
  case. ,'f' do. fd y 
  case. ,'r' do. rl x 
  case. ,'y' do. yw x 
  case. ,'p' do. pt x
  end.
  x dOO y
)

NB. main turtle control              ***************  

NB. The conjunction "change" is used as follows:
NB. rl =: roll  =: RlRow change 'turn'
NB. yw =: yaw   =: YwRow change 'turn'
NB. pt =: pitch =: PtRow change 'turn'
NB. 
NB. jr =: jumpright =: RlRow change 'advance'
NB. fd =: forward =: YwRow change 'advance'
NB. ju =: jumpup =: PtRow change 'advance'
NB. These definitions are supplied below, 
NB.    below the definitions of their components.

NB.* change c
NB. The conjunction change provides common 
NB.    preprocessing for all the turtle movement changes.
NB. The argument n is usually turn or advance
NB. the argument m is usually RlRow, YwRow, or PtRow
change =: conjunction define
  change0 =. '(',(":m),' ',n,') '
  change1 =. 'change0'~
  numS =. i.#State
  turtles =. Eye -.~ numS
  scanmask =. turtles e.~ numS
  if. 1=#y 
  do.
    y =. 0 Eye}yxs&State y
    ".  change1, lr y 
    return.
  end.
  if. turtles neqQ y 
  do. 
    ".  change1, lr y #^:_1~ scanmask
    return. 
  end.
  if. State neqQ y 
  do. 
    ".  change1, lr y 
    return. 
  end.
  if. State nneQ y 
  do. 
    'Supply ',(":#State),' move values.' 
    return. 
  end.
  'Your inputs are not understood.'
  :
  change0 =. '(',(":m),' ',n,') '
  change1 =. 'change0'~
  numS =. i.#State
  turtles =. Eye -.~ numS
  scanmask =. turtles e.~ numS
  x =. ,x
  if. (y nneQ x) *. 1~:#y 
  do. 
    'The number of moves must be 1 or the same as the number of turtles listed.'
    return.
  end.
  if. (1<#y) *.x  nneQ y 
  do. 
    'Supply 1 or ',(":#x),' move values.' 
    return. 
  end.
  if. ((#State)<:>./x) do. 
    'Supply only turtle values between 0 and ',(":<:#State),' .' 
    return. 
  end.
  if. x nneQ ~: x
  do.
    'Values of x must be unique'
    return.
  end.
  if. x neqQ y 
  do. 
    tmp =. /: x
    x =. tmp{x
    y =. tmp{y
    scanmask =. x e.~ numS
    ". change1, lr y #^:_1~ scanmask
    return. 
  end.
  if. (1=#y) *.x  nneQ y 
  do. 
    y =. (,(#~.x) copies y) (~.x)}0 #~#State
    ". change1, lr y 
    return. 
  end.
  'Your inputs are not understood.'
)

rl =: roll  =: RlRow change 'turn'
yw =: yaw   =: YwRow change 'turn'
pt =: pitch =: PtRow change 'turn'
rt =: right =: yw
lt =: left  =: yw&:- : (yw -)

jr =: jumpright =: RlRow change 'advance'
fd =: forward =: YwRow change 'advance'
ju =: jumpup =: PtRow change 'advance'

jl =: jumpleft =: jr&:- : (jr -)
bk =: back =: fd&:- : (fd -)
jd =: jumpdown =: ju&:- : (ju -)

NB. turn is used to create yw, rl and pt, below
NB.* turn a  degrees of turn for each or all except the Eye turtles
NB. usage: type turn 30  or type turn 30 _60 30 0 for three turtles
NB. the final 0 is for the Eye turtle
turn =: adverb define
  NB. some parameters using the adverb value
  type =. m
  Row =. type  NB. simplified from type&{AllRow
  rot =. (dtb>@(type&{)AllRot)~
  OneHeading =. 'Heading',type&{ 'RHU'
  rotate =. ('rotaxes',~type&{ 'xyz')~

  if. (1=#y) do. 
    y =. 0 Eye}yxs&State ,y 
  end.
  if. State nneQ ,y do. 
    'Supply ',(":#State),' turn values.' 
    return. 
  end.

  oldH =. Heading

  NB. get State info
  localnames =. 'turtleerase turtlestate heading position turtletrait turtlecolor turtletype' 
  statenames =. ;:'Turtleerase Turtlestate Heading Position Turtletrait Turtlecolor Turtletype'
  (localnames) =. state each statenames

  NB. update SC and State
  C =. SCN aindex OneHeading
  D =. 360|y
  SC =: C aC D
  heading =. (mfv0 state 'Heading') x~ rot rfd D
  heading state 'Heading'
  if. eye y 
  do. 
    H =. +/&.:*: GS_VIEWXYZ
    S =.   sin rfd -: eye-D
    C =.   cos rfd -: eye-D
    dsh =. +:H*S
    select. type
    case. 0 do. 
      (-eye D) gsfly GS_VIEWXYZ
    case. 1 do. 
      (-eye D) gsfly GS_VIEWUP
      gstranslate dsh*C,0,0
    case. 2 do. 
      (eye D) gsfly GS_VIEWXYZ gscross GS_VIEWUP 
      gstranslate dsh*0,C,0
    end.
  end.

  paint''

  NB. update user's information
  tmp =. 360|(y+ Row col oldH) Row col A} oldH
  'Heading';rnd Heading =: dfd tmp
  :
  type =. m
  if. (1=#y) *. (State neqQ ~.x)
  do.
    type turn y#^:_1~x e.~i.#State
    return.
  end.
)


NB. advance is used to create fd, bk, ju and jr 
NB.* advance a movement distance for each or all except the Eye turtles
NB. usage: dir advance 10  or dir advance 10 _10 5 for three turtles
advance =: adverb define
  NB. some parameters using the adverb value
  dir =. m
  Row =. dir
  rot =. (dtb>@(dir&{)AllRot)~
  OneHeading =. 'Heading',dir&{ 'RHU'
  OneDistance =. 'Distance',dir&{ 'RHU'

  if. (1=#y) do. 
    y =. 0 Eye}yxs&State y 
  end.

  NB. get State info
  localnames =. 'penstate turtleerase turtlestate heading position turtletrait stepsize turtlecolor turtletype' 
  statenames =. ;:'Penstate Turtleerase Turtlestate Heading Position Turtletrait Stepsize Turtlecolor Turtletype'
  (localnames) =. state each statenames

  NB. update SC and State
  oldposition =. position
  C =. SCN aindex OneDistance
  D =. , stepsize*y
  SC =: C aC D
  position =. oldposition + D * state OneHeading
  position state 'Position'

  NB. draw new path
  maskS =. maskT =. (,penstate)&#
  if. StereoFlag do. maskS =. eye end.
  if. 1<:+/,penstate do.
    lines =. oldposition ; position
    t =. maskT (,.&>/lines) ,. ,.&:>/ state each ;:'Pencolor Pensize Penstyle'
    DrawPathList =: DrawPathList, t
  end.
  if. eye y 
  do. 
    gstranslate -(eye y)* eye state OneHeading
  end.

  paint ''
  NB. update user's information
  'Position';rnd Position =: state  'Position'
  :
  dir =. m
  if. (1=#y) *. (State neqQ ~.x)
  do.
    dir advance y#^:_1~x e.~i.#State
    return.
  end.
)

NB. The conjunction "status" is used as follows:
NB. goto =: 'Position' status 'goto0'   
NB. gazeat =: 'Position' status 'gazeat0' NB. no longer avail   
NB. The n argument of status must be the name of a verb
NB.    which uses a movement verb (like fd) to update State.
NB. These definitions are supplied below, 
NB.    below the definitions of their components.
status =: conjunction define
  trait =. m
  status0 =. n,' '
  status1 =. 'status0'~
  numS =. i.#State
  turtles =. Eye -.~ numS
  if. 2>#$y
  do.
    'The rank of the right argument must be 2: eg ,:100 200 0'
  end.
  if. 1=#y 
  do.
    y =. (,y) turtles}state trait
    ".  status1, lr y
    return.
  end.
  if. turtles neqQ y 
  do. 
    y =. y turtles}state trait 
    ".  status1, lr y
    return. 
  end.
  if. State neqQ ~.y 
  do. 
    ".  status1, lr y
    return. 
  end.
  if. State nneQ y 
  do. 
    'Supply ',(":#State),' goto values.' 
    return. 
  end.
  'Your inputs are not understood.'
  :
  trait =. m
  status0 =. n,' '
  status1 =. 'status0'~
  numS =. i.#State
  turtles =. Eye -.~ numS
  x =. ,x
  if. 2>#$y
  do.
    'The rank of the right argument must be 2: eg ,:100 200 0'
    return.
  end.
  if. (y nneQ x) *. 1~:#y 
  do. 
    'The number of traits must be 1 or the same as the number of turtles listed.'
    return.
  end.
  if. (1<#y) *.x  nneQ y 
  do. 
    'Supply 1 or ',(":#x),' trait values.' 
    return. 
  end.
  if. ((#State)<:>./x) do. 
    'Supply only turtle values between 0 and ',(":<:#State),' .' 
    return. 
  end.
  if. x nneQ ~: x
  do.
    'Values of x must be unique'
    return.
  end.
  if. x neqQ y 
  do. 
    tmp =. /: x
    x =. tmp{x
    y =. tmp{y
    y =. y (~.x)}state trait 
    ". status1, lr y
    return. 
  end.
  if. 1=#y
  do.
    y =. (,/(#~.x) copies y) (~.x)}0 #~#State
    ". status1, lr y
    return.
  end.
  'Your inputs are not understood.'
)

goto0 =: monad define
  geth =. YwRow&{"2             NB. get H row
  getp =. PtRow&{"2             NB. get U row
  NB. get State info
  'position heading stepsize' =. state each ;: 'Position Heading Stepsize'

  NB. put desired turtle position & heading temps
  P =. y
  H =. heading
  heading =. mfv0 heading
  distance =. length P-"1 position

  NB. in 5 steps execute "goto"
  NB. 1: +yw toward the desired point
  NB. 2: +pt toward the desired point
  NB. 3:  fd toward the desired point
  NB. 4: -pt to reverse step 2
  NB. 5: -yw to reverse step 1

  NB. step 1
  tpos =. P-"1 position

  NB. reverse compensates for yw being clockwise
  turn1 =.  tpos (([: ang@:|. "1 nrmlz@:ywProj )) heading
  sm 'yw ',":[tmp =. dfr turn1
  sm yw tmp


  NB. step 2

  heading =. state 'Heading'
  tpos =. P-"1 position

  turn2 =.  tpos (([: ang "1 nrmlz@:ptProj )) mfv0 state 'Heading'
  sm 'pt ',":[tmp =. dfr turn2
  sm pt tmp

  NB. step 3
  sm 'fd ',":[tmp =. distance%,stepsize
  sm fd tmp

  NB. step 4
  sm 'pt ',":[tmp =. dfr -turn2
  sm pt tmp

  NB. step 5
  sm 'yw ',":[tmp =. dfr -turn1
  sm yw tmp
)

NB.* goto v [indices of turtles] goto Position(s) to goto
NB.  goto moves the turtle(s)' Position(s)
NB.      to place(s) specified in y .
NB. left argument can be a list of turtle indices
NB.   (where turtle indices begin with 0).
NB.   If the left argument is omitted, Eye turtle(s) are 
NB.   elided from the list of all turtles moved.
NB. Turtle indices are 0 1 2 ...
goto =: [ ('Position' status 'goto0') mat@]

turnto0 =: monad define
  geth =. YwRow&{"2             NB. get H row
  getp =. PtRow&{"2             NB. get U row
  NB. get State info
  NB. 'position heading stepsize' =. state each ;: 'Position Heading Stepsize'
  'position heading' =. state each ;: 'Position Heading'

  NB. put initial turtle position & heading temps
  P =. y
  heading =. mfv0 heading
  distance =. length P-"1 position


  NB. in 3 steps execute "turnto"
  NB. 1: +yw toward position
  NB. 2: +pt toward position
  NB. 3: -yw back

  tpos =. P-"1 position

  NB. step 1

  heading =. mfv0 state 'Heading'

  NB. reverse compensates for yw being clockwise
  turn1 =. tpos (([: ang@:|. "1 nrmlz@:ywProj )) heading
  sm 'yw ',":[FaceTurn =: tmp =. dfr turn1
  sm yw tmp

  NB. step 2
  heading =. mfv0 state 'Heading'

  turn2 =.  tpos (([: ang"1 nrmlz@:ptProj )) heading
  sm 'pt ',":[tmp =. dfr turn2
  sm pt tmp

  NB. step 3
  NB. sm 'yw ',":[tmp =. dfr -turn1
  NB. sm yw tmp
)
turnto =: [ ('Position' status 'turnto0') mat@]

NB.* eyeto v moves any Eye(s) to y Position 
NB.  usage: [gaze_Position] eyeto new_position
eyeto =: verb define
  0 0 0 eyeto y
  :
  Eye goto y
  Eye turnto x
  EyeGazesAt =: ,: x
)

NB.* home v returns the turtle(s)' Position(s)
NB.         to its/their starting value
NB.         updating StateChange, also.
NB.         Other States remain unchanged.
NB. argument can be '' or a list of turtle numbers
NB.   where turtle numbers begin with 0
NB.   If the argument is '' Eye turtle(s) are elided
NB.   from the list of all turtles moved home.
home =:  monad define NB. home the Turtle State
smoutput 'Only the repositioning works, not reorienting.'
smoutput 'For clearer error messages, use goto directly.'
numS =. i.#State
turtles =. Eye -.~ numS
if. ''-:y
do. turtles goto turtles{P0
else.  y goto mat y{P0
end.
)

NB.* penup v make turtle path for turtles listed by number
NB. usage: penup '' or penup 0 1 2 3 for all four turtles
pu =: penup =: monad define
if. y-:'' do. 
  y =. Eye -.~ i. #State
end. 
y =. ,~. y
if. ((#State)<:>:>./y) do. 
  'Supply only turtle values between 0 and ',(":<:<:#State),' .' 
  return. 
end.

NB. update SC and State
oldpenstate =. state 'Penstate'
penstate =. 0 y} oldpenstate 
D =. penstate - oldpenstate
C =. SCN aindex 'Penstate'
SC =: C aC D
penstate state 'Penstate'

NB. update user's info
Penstate =: ,state 'Penstate'
'Penstate';,Penstate

)

NB.* pendown v make turtle path for turtles listed by number
NB.* pendown v make turtle path for turtles listed by number
NB. usage: pendown '' or pendown 0 1 2 3 for all four turtles
pd =: pendown =: monad define
if. y-:'' do. 
  y =. Eye -.~ i. #State
end. 
y =. ,~. y
if. ((#State)<:>:>./y) do. 
  'Supply only turtle values between 0 and ',(":<:<:#State),' .' 
  return. 
end.

NB. update SC and State
oldpenstate =. state 'Penstate'
penstate =. 1 y} oldpenstate 
D =. penstate - oldpenstate
C =. SCN aindex 'Penstate'
SC =: C aC D
penstate state 'Penstate'

NB. update user's info
Penstate =: ,state 'Penstate'
'Penstate';Penstate
)

NB.* turtledraw v make turtle invisible for turtles listed by number
NB. usage: turtledraw '' or turtledraw 0 1 2 3 for all four turtles
turtledraw =: monad define
  if. y-:'' do. 
    y =. Eye -.~ i. #State
  end. 
  y =. ,~. y
  if. ((#State)<:>./y) do. 
    'Supply only turtle values between 0 and ',(":<:#State),' .' 
    return. 
  end.

  NB. update SC and State
  oldturtlestate =. state 'Turtlestate'
  turtlestate =. 1 y} oldturtlestate 
  D =. turtlestate - oldturtlestate
  C =. SCN aindex 'Turtlestate'
  SC =: C aC D
  turtlestate state 'Turtlestate'

  yw 0

  NB. update user's info
  Turtlestate =: ,state 'Turtlestate'
  'Turtlestate';,Turtlestate
)

NB.* turtlenodraw v make turtle invisible for turtles listed by number
NB. usage: turtlenodraw '' or turtlenodraw 0 1 2 3 for all four turtles
turtlenodraw =: monad define
  if. y-:'' do. 
    y =. Eye -.~ i. #State
  end. 
  y =. ,~. y
  if. ((#State)<:>./y) do. 
    'Supply only turtle values between 0 and ',(":<:#State),' .' 
    return. 
  end.

  NB. update SC and State
  oldturtlestate =. state 'Turtlestate'
  turtlestate =. 0 y} oldturtlestate 
  D =. turtlestate - oldturtlestate
  C =. SCN aindex 'Turtlestate'
  SC =: C aC D
  turtlestate state 'Turtlestate'

  NB. update user's info
  paint ''
  Turtlestate =: ,state 'Turtlestate'
  'Turtlestate';,Turtlestate
)

tolowerstate =: (tolower@{.) 0} ]

NB. cover verbs for statusto are shown below the adverb's definition
NB.* statusto a revise turtle status of trait for turtles x to value y 
NB. usage: turtles trait statusto values
NB. only works after turtles have been created
NB. statusto embeds a dyadic state to update State, 
NB. NB.     and a yw 0 to update graphic turtles 
NB.     and also embeds a monadic state to update graphic turtles 
statusto =: adverb define
  :
  if. 0 =#PARTS do.
    'only works after turtles have been created***'
    return.
  end.
  turtles =. x
  trait =. u
  value =. y
  lowertrait =. tolowerstate trait

  if. 2>#$value
  do.
    'The rank of the right argument must be 2: eg ,:100 200 0'
    return.
  end.
  if. (value nneQ turtles) *. 1~:#value 
  do. 
    'The number of traits must be 1 or the same as the number of turtles listed.'
    return.
  end.
  if. (1<#value) *.turtles nneQ value 
  do. 
    'Supply 1 or ',(":#turtles),' trait values.' 
    return. 
  end.
  if. ((#State)<:>./turtles) do. 
    'Supply only turtle values between 0 and ',(":<:#State),' .' 
    return. 
  end.
  if. turtles nneQ ~: turtles
  do.
    'Values of x must be unique'
    return.
  end.
  if. turtles neqQ value 
  do. 
    tmp =. /: turtles
    turtles =. tmp{turtles
    value =. tmp{value
    value =. value (~.turtles)}state trait
  elseif. 1=#value
  do.
    value =. ((#~.turtles) copies ,value) (~.turtles)}state trait
  elseif.
  do.
    'Your inputs are not understood.'
    return.
  end.
  NB. update SC and State
  oldturtlestate =. state trait
  turtlestate =. value 
  D =. turtlestate 
  C =. SCN aindex trait
  SC =: C aC D
  turtlestate state trait

  NB. update user's info
  NB. paint ''
  (trait) =: state trait
  trait;value
)

turtletypeto =: [ 'Turtletype' statusto mat@]
turtletraitto =: [ 'Turtletrait' statusto mat@]
turtlecolorto =: [ 'Turtlecolor' statusto mat@]  NB. see update below
turtlestateto =: [ 'Turtlestate' statusto mat@]
NB.  eg, 1 turtletypeto 2000
NB.  eg, 1 0 turtletypeto 1000 ,:2000
NB.  eg, 1 turtletraitto ,: 1 0 0  NB. first element is 1 or 0; others ignored
NB.  eg, 1 turtlecolorto ,: Red

turtlecolorto =: dyad define
  x ([ 'Turtlecolor' statusto mat@])y
  NB. get State info
  localnames =. 'turtleerase turtlestate heading position turtletrait turtlecolor turtletype' 
  statenames =. ;:'Turtleerase Turtlestate Heading Position Turtletrait Turtlecolor Turtletype'
  (localnames) =. state each statenames

  NB. redraw turtle
  heading =. (mfv0 state 'Heading')
  turtles =. x
  if. #turtles do. 
    rightArg =.  heading
    leftArg =.  position;turtlecolor;turtletrait;turtletype
    for_j.  i. #turtles 
    do.
      i =. j{turtles
      TID =: ": i
      leftArg drawsetup &:((i&{)each) <rightArg
      TheTurtle =: whichTurtle  i&{,turtletype
      makeanyTurtle TURTLECOLOR
      anyTurtle TURTLECOLOR
    end.
  end.
)

pc =: pencolor =: verb define
NB.* pencolor v [indices of turtles] pencolor colors to assign
NB. See the list of colors by typing COLORTABLE.
NB. Turtle indices are 0 1 2 ...
y pencolor~i.#State
:
if. (y nneQ x) *. (1=#y) *. -. StereoFlag do. 
  y =. (,Bkgrd) Eye}yxs&State y 
end.
x =. ,x
if. (y nneQ x) *. 1~:#y do. 
  'The number of colors must be 1 or the same as the number of turtles listed.'
  return.
end.
if. (1<#y) *.x nneQ y do. 
  'Supply 1 or ',(":#x),' pencolor values.' return. 
end.

NB. update SC and State
oldpencolor =. state 'Pencolor'
newpencolor =. (((#x),3)$,y) x} oldpencolor
D =. newpencolor - oldpencolor
C =. SCN aindex 'Pencolor'
SC =: C aC1 D
newpencolor state 'Pencolor'

NB. update user's info
Pencolor =: state 'Pencolor'
'Pencolor';Pencolor
)

NB. enable one-liner turtle movement sequences
repeats =: conjunction define
  for. i. m
  do. v y
  end.
  :
  for. i. m
  do. x v y
  end.
)

NB. a handy verb that combines J and turtle commands
ywfd =: yawforward =: dyad define
yw x
fd y
)

NB. iTS uses radius of 300 here
NB. ''[iTS 2[cs''
NB. ''[(0,0,:0) state 'Turtlestate'
NB. ''[8 (12 repeats poly3)30
NB. eyeto 10*-:+/ }:Position
NB. ''[5 (11 repeats poly3)30

NB. iTS uses radius of 200 here
NB. ''[iTS 2[cs''
NB. ''[(0,0,:0) state 'Turtlestate'
NB. 2 (60 repeats poly3)10[yw _55[pd ''[rl 110[jr 0[pu ''  
NB. 100 0 0 eyeto ,: 100 0 1000

NB. a handy verb that combines J and turtle commands
poly3 =: fruyrp =: dyad define
if. -. StereoFlag do. pencolor Red    end.
fd x
rl y
if. -. StereoFlag do. pencolor Blue end.
ju x
yw y
if. -. StereoFlag do. pencolor Black end.
jr x
pt -y
empty Headpoly =: Headpoly,{.state 'Heading'
)

NB. a handy verb that combines J and turtle commands
fdyw =: forwardyaw =: dyad define
fd x
yw y
)

NB.* show v show values of the turtle parameters
NB. argument can be '' or a list of turtle numbers
NB.   where turtle numbers begin with 0
NB. also note that output of "heading" is in radians
show =: showTurtleState =: monad define
if. y-:'' do. 
  y =. i. #State
end. 
y =. ,~. y
if. ((#State)<:>./y) do. 
  'Supply only turtle values between 0 and ',(":<:#State),' .' 
  return. 
end.
NB. prints heading in radians, not degrees -- all in columns
NB. BasicTnames,. y&{ each state each BasicTnames 

NB. prints some facts in rows and some in columns
NB. because global singleton values are saved indiviually as rows
BasicTnames,. y&{ each do each BasicTnames 
)

NB. The next two verbs are rather complex and should be used
NB.    with care by experienced users.
NB.* pendownchange v make turtle path show or change status of penstate
NB. usage: pendownchange 1 or pendownchange 0 1 _1 1 for four turtles
NB. arg values of  1 mean put the penstates to pendown
NB. arg values of _1 mean to reverse the current penstates
NB. arg values of 0 mean NOT to change the penstates
pendownchange =: monad define
  if. (1<#,y) *. 0=+/,|y do. 
    'Use penupchage to set penstates to penup.' 
    return. end. 
    if. (-. mtQ,y) *. -. _1 0 1 &okvaluesQ ,y do. 
      'Supply only _1s, zeros and ones.' 
      return. 
    end.
    if. (1<#,y) *.State nneQ ,y do. 
      'Supply 1 or ',(":#State),' pendownchange (_1, 0, or 1) values.' 
      return. 
    end.
    oldpenstate =. state 'Penstate'
    if. (y-:'') +. (y-:1) do. 
      y =.  yxs&State 1
    else. 
      y =. ,y
    end.
    penstate =. oldpenstate changetodown y
    D =. |penstate - oldpenstate
    C =. SCN aindex 'Penstate'
    SC =: C aC D
    N =. SN aindex 'Penstate'
    State =: N aS penstate
    Penstate =: ,state 'Penstate'
    'Penstate';Penstate
)

NB.* penupchange v hide turtle path or change status of penstate
NB. usage: penupchange 1 or penupchange 0 1 _1 1 for four turtles
NB. arg values of 1 mean put the penstates to penup
NB. arg values of _1 mean to reverse the current penstates
NB. arg values of 0 mean NOT to change the penstates
penupchange =: monad define
  if. (1<#,y) *. 0=+/,|y 
  do. 'Use pendownchange to set penstates to pendown.' 
    return. 
  end. 
  if. (-. mtQ,y) *. -. _1 0 1 &okvaluesQ ,y 
  do. 'Supply only _1s, zeros and ones.' 
    return. 
  end.
  if. (1<#,y) *.State nneQ ,y do. 
    'Supply 1 or ',(":#State),' penupchange (_1, 0 or 1) values.' 
    return. 
  end.
  oldpenstate =. state 'Penstate'
  if. (y-:'') +. (y-:1) do. 
    Penstate =:  yxs&State 0
  else. y =. ,y
  end.
  penstate =. oldpenstate changetoup y
  D =. |penstate - oldpenstate
  C =. SCN aindex 'Penstate'
  SC =: C aC D
  N =. SN aindex 'Penstate'
  State =: N aS penstate
  Penstate =: ,state 'Penstate'
  'Penstate';Penstate
)

NB. main graphics initialization     ***************  

TURTLE_SIZE =: 0.05         NB. turtle body size 
TURTLE_SHAPE =: 1 2 0.5     NB. turtle elliptical rescale
TURTLE_HEAD_RELATIVE =: 0.3 NB. head size relative to body
DANCER_SIZE =: 0.15         NB. dancer body size

OPENGL=: 0 : 0
  pc opengl closeok;pn tgsj3D;
  xywh 0 0 200 150;cc g isigraph opengl rightmove bottommove;
  pas 0 0;
  rem form end;
)

tgsj3D_run=: 3 : 0
GS_CLEARCOLOR=: gscolor4 (,Bkgrd,0)
wd OPENGL
wdmove _1 0
ogl=: ''conew'jzopengl'
wd'setfocus g'
wd'pcenter;pshow;'
gsinit GS_LIGHT
Init''
QUADS=: {.>gluNewQuadric''
if. y do. firsttime'' end.
gssnap 1
glCallLists |.LISTS;GL_UNSIGNED_INT;#LISTS
gsfini''
smoutput 'Type "help" to see some examples to try.'
)

opengl_close=: 3 : 0
gluDeleteQuadric QUADS
destroy__ogl''
ogl=: ''
wd 'pclose'
)

opengl_cancel=: opengl_close

opengl_g_paint=: paint
opengl_g_char=: gschar
opengl_default=: gsdefault

NB. turtle state dbase verbs         ***************  

yfx =: {."1~ #@]                 NB. (#y) taken from x
amemb =: ,:@] {."1@:E. yfx       NB. all members of y in x
aindex =: amemb # i.@#@[         NB. all indices of y in x
num =: [:{:2:{.!.1 $             NB. columns of matrix or 1 for vector
rnd =: <.@(0.5&+)                NB. can round off State/SC output


NB. for updating the turtle state array
aS =: alterState =: 4 : 'y ({;&x i.@#State)}State'

NB.  State is queried or modified by state
NB.  Notice that in dyadic use, global State is modified*****
NB.* state v retrieve y in State : x amends y, and State is updated
NB.  usage: heading =. state 'Heading'
NB.         state each ;:'Heading Position'
NB.         ((,"_1 (ywRot rfd 90 0),ptRot rfd 90);0 0 0,250 _200 0,:0 0 200)state each ;:'Heading Position'
state =: verb define
  State {"1~ SN aindex y
  :
  i =. SN aindex y
  targetshape =. ,@:($&>)x;SN aindex y
  if. ($,.x) -: $State {"1~i do.
    State =: (,.x) ({;&i i.@#State)} State
  else.
    smoutput 'The shape of ',y,' in State is different from ',": x
    return.
  end.
)

state =: verb define
  State {"1~ SN aindex y
  :
  i =. SN aindex y
  if. ($,.x) -: $State {"1~i do.
    State =: (,.x) ({;&i i.@#State)} State
  else.
    smoutput 'The shape of ',y,' in State is different from ',": x
    return.
  end.
)

NB.  State is queried or modified by stateEye
NB.  Notice that in dyadic use, global State is modified*****
NB.* stateEye v retrieve y in State : x amends y, and State is updated
NB.  usage: heading =. stateEye 'Heading'
NB.         stateEye each ;:'Heading Position'
NB.         ((,"_1 ptRot rfd 90);,:0 0 200)stateEye each ;:'Heading Position'
stateEye =: (verb define)   NB. "_ 1 _
eye State {"1~ SN aindex y
:
i =. SN aindex y
if. x -:&$&mat eye State {"1~i 
do.
  State =: (x) (mat{;&i Eye)} State
else.
  smoutput 'The shape of ',y,' in State is different from ',": x
  return.
end.
)


NB. below is for summarizing or modifiying SC (StateChange dbase)
NB. useful for averaging state-change dbase
avg =: +/ % +/@(~:&0)  NB. denominator counts ~:0

NB. for updating the turtle state-change history array
NB.   when the trait is a scalar
NB.  Notice that in dyadic use, global SC is modified*****
aC =: appendChange =: dyad define
filler =. 0$~(#y),#SCN
SC,"_1 y x }"0 1 filler
)

NB. for updating the turtle state-change history array
NB.   when the trait is a vector
NB.  Notice that in dyadic use, global SC is modified*****
aC1 =: appendChange =: dyad define
filler =. 0$~(#y),#SCN
SC,"_1 y x }"1 filler
)

NB. main graphics update verbs       ***************  


paint =: monad define
  wd'psel opengl;pactive'
  if. gsinit GS_LIGHT do. initLists <:#State end.

  drawpathlist =. (-.{.),/DrawPathList
  if. # drawpathlist do.
    drawpath drawpathlist
  end.
  NB. get State info
  localnames =. 'turtleerase turtlestate heading position turtletrait turtlecolor turtletype' 
  statenames =. ;:'Turtleerase Turtlestate Heading Position Turtletrait Turtlecolor Turtletype'
  (localnames) =. state each statenames

  NB. draw new turtle
  turtles =. I. ,turtlestate
  if. #turtles do. 
    rightArg =.  heading
    leftArg =.  position;turtlecolor;turtletrait;turtletype
    for_j.  i. #turtles 
    do.
      i =. j{turtles
      TID =: ": i
      leftArg drawsetup &:((i&{)each) <rightArg
      TheTurtle =: whichTurtle  i&{,turtletype
      anyTurtle TURTLECOLOR
    end.
  end.

  if. #DrawPathList do. glCallList 1 end.

  if. EyeQ
  do.
    DEGREE =: dfd DEGREE+(<Eye,2-DIR){Heading
    Heading =:  DEGREE (<Eye,2-DIR)}Heading
    heading =. ,ROT gsmp 3 3$eye state 'Heading'
    State =: heading (;/Eye,. SN aindex 'Heading')}State
    position =. GS_VIEWXYZ- GS_TRNXYZ
    Position =: position Eye}Position
    State =: position(;/Eye,.SN aindex'Position')}State
  end.
  gsfini''
  DEGREE =: 0
  ROT =: GS_ID3
)

drawpath =: monad define
  drawpathlist =. y
  j =. (_6{. rows drawpathlist) </.i.#drawpathlist
  jlines =. j {each <drawpathlist
  glNewList @ (, & GL_COMPILE)  LTurtlepath
  for_i. i. # jlines do.
    temp =. i pick jlines
    'pencolor pensize penstyle' =. 1 0 0 1 1 &(<;.1)_5{.{. temp
    gscolor pencolor
    glLineWidth pensize
    if. penstyle do. 
      glLineStipple penstyle, STIPPLE
      glEnable GL_LINE_STIPPLE
    end.
    glDisable GL_LINE_STIPPLE
    glBegin GL_LINES
    glVertex Step_scale* _3]\,_5}."1 temp
    glEnd ''
  end.
  glEndList ''
)

drawsetup =: dyad define
  'heading' =. y
  'position turtlecolor turtletrait turtletype' =. x
  HEADING =: heading
  position =. position * Step_scale
  POSITION =: position
  TURTLECOLOR =: turtlecolor
  HEADCOLOR =: Headcolors{~ {. turtletrait
  SHOECOLOR =: Safecolors{~1{turtletrait
)

cs =: clearscreen =: monad define
temp =. state 'Turtlestate'
(0:"0 temp) state 'Turtlestate' NB. set all to 0
gspdef GS_STATE1
DrawPathList =: i. 0 0
paint''
temp state 'Turtlestate' NB. set all back
DrawPathList =: i. (#Eye), 0 ,6++/#&> (<SN) aindex each ;:'Pencolor Pensize Penstyle'
)

NB. turtle creation                  ***************  

maketurtle =: verb define
  turtlehead makelist (".'LTurtlehead',TID) y
  turtle     makelist (".'LTheTurtle',TID) y
  :
  x turtlehead makelist (".'LTurtlehead',TID) y
  x turtle     makelist (".'LTheTurtle',TID) y
)

makeanyTurtle =: verb define
  ('make',TheTurtle)~ y
  :
  x ('make',TheTurtle)~ y
)

anyTurtle =: verb define
  glPushMatrix''
  gscolor TURTLECOLOR
  glMultMatrix ,(pfv POSITION) 3}GS_ID4
  glMultMatrix ,hfm"2 ]3 3$,>HEADING
  glCallList ".'LTheTurtle',TID
  glPopMatrix '' 
)

turtle =: monad define  
  glPushMatrix ''  
  scale =. 3&# TURTLE_SIZE
  glPushAttrib GL_CURRENT_BIT  
  color =. TURTLECOLOR  
  gscolor color  
  glEnable GL_NORMALIZE  
  glScale TURTLE_SHAPE * scale   
  glClipPlane  GL_CLIP_PLANE0; 0 0 1 0   
  glEnable     GL_CLIP_PLANE0  
  gluSphere  QUADS, 1 30 30   
  glCallList ".'LTurtlehead',TID  
  glDisable     GL_CLIP_PLANE0  
  glPopAttrib ''  
  glPopMatrix ''
)

turtlehead =: monad define
  glPushMatrix ''
  gscolor HEADCOLOR
  glTranslate 0 1 0
  gluSphere QUADS, TURTLE_HEAD_RELATIVE , 30 30 
  glPopMatrix ''
)

NB. defining dancers

makemale_dancer =: verb define
shoe makelist (".'LShoe',TID) y
leg makelist (".'LLeg',TID) y
rightleg makelist (".'LRightleg',TID) y
leftleg makelist (".'LLeftleg',TID) y
rightforearm makelist (".'LRightforearm',TID) y
leftforearm makelist (".'LLeftforearm',TID) y
rightupperarm makelist (".'LRightupperarm',TID) y
leftupperarm makelist (".'LLeftupperarm',TID) y
head makelist (".'LHead',TID) y
male_dancer makelist (".'LTheTurtle',TID) y
:
x shoe makelist (".'LShoe',TID) y
x leg makelist (".'LLeg',TID) y
x rightleg makelist (".'LRightleg',TID) y
x leftleg makelist (".'LLeftleg',TID) y
x rightforearm makelist (".'LRightforearm',TID) y
x leftforearm makelist (".'LLeftforearm',TID) y
x rightupperarm makelist (".'LRightupperarm',TID) y
x leftupperarm makelist (".'LLeftupperarm',TID) y
x male_dancer makelist (".'LTheTurtle',TID) y
)

makefemale_dancer =: verb define
shoe makelist (".'LShoe',TID) y
leg makelist (".'LLeg',TID) y
rightleg makelist (".'LRightleg',TID) y
leftleg makelist (".'LLeftleg',TID) y
rightforearm makelist (".'LRightforearm',TID) y
leftforearm makelist (".'LLeftforearm',TID) y
rightupperarm makelist (".'LRightupperarm',TID) y
leftupperarm makelist (".'LLeftupperarm',TID) y
head makelist (".'LHead',TID) y
female_dancer makelist (".'LTheTurtle',TID) y
:
x shoe makelist (".'LShoe',TID) y
x leg makelist (".'LLeg',TID) y
x rightleg makelist (".'LRightleg',TID) y
x leftleg makelist (".'LLeftleg',TID) y
x rightforearm makelist (".'LRightforearm',TID) y
x leftforearm makelist (".'LLeftforearm',TID) y
x rightupperarm makelist (".'LRightupperarm',TID) y
x leftupperarm makelist (".'LLeftupperarm',TID) y
x female_dancer makelist (".'LTheTurtle',TID) y
)

male_dancer =: verb define
DANCER_SIZE male_dancer  y
:
scale =. 3&# x
color =:  y
glPushMatrix''
glScale scale
glEnable GL_NORMALIZE
gscolor HEADCOLOR
glCallList ".'LHead',TID
gscolor TURTLECOLOR
glCallList SHOULDER
glCallList TORSO
glCallList ".'LRightleg',TID
gscolor TURTLECOLOR
glCallList ".'LLeftleg',TID
gscolor TURTLECOLOR
glCallList ".'LRightupperarm',TID
gscolor TURTLECOLOR
glCallList ".'LLeftupperarm',TID
glPopMatrix '' 
)

female_dancer =: verb define
DANCER_SIZE female_dancer  y
:
scale =. 3&# x
color =:  y
glPushMatrix''
glScale scale
glEnable GL_NORMALIZE
gscolor HEADCOLOR
glCallList ".'LHead',TID
gscolor TURTLECOLOR
glCallList SHOULDER
glCallList TORSO
glCallList ".'LRightleg',TID
gscolor TURTLECOLOR
glCallList ".'LLeftleg',TID
gscolor TURTLECOLOR
glCallList ".'LRightupperarm',TID
gscolor TURTLECOLOR
glCallList ".'LLeftupperarm',TID
glCallList SKIRT
glPopMatrix '' 
)

normalizer =: %{:
shaper =: [*normalizer@]

TorsoLength =: 2
TorsoShape =: 0.2 0.4 2
TorsoScale =: 1 0.5 1
Torso =: TorsoLength shaper TorsoShape
SkirtLength =: 1
SkirtShape =: (5&* 0&{ TorsoShape) 0} 1 0 2{TorsoShape
SkirtScale =: 1 0.5 1
Skirt =: SkirtLength shaper SkirtShape
LegLength =: 1.5 * TorsoLength
LegShape =: 0.05 0.1 2
LegOutAngle =: 5
Leg =: LegLength shaper LegShape
ShoeScale =: 1 2 0.5            NB. shoe elliptical rescale
ShoeLength =: 6&* {. Leg
ShoulderScale =: TorsoScale         NB. shoulder elliptical rescale
ShoulderLength =: 1&{ Torso
LegShift =:  -: {. Torso
UpperarmLength =: 0.8 * TorsoLength
UpperarmShape =: 0.08 0.1 3
UpperArmOutAngle =: 8
UpperArmFdAngle =: 9
Upperarm =: UpperarmLength shaper UpperarmShape
UpperarmShift =:   1&{ Torso
ForearmLength =: 1.0 * TorsoLength
ForearmShape =: 0.08 0.07 3
ForeArmOutAngle =: 24
ForeArmFdAngle =: _75
Forearm =: ForearmLength shaper ForearmShape
ForearmScale =: 1 0.5 1

genpartslist=: 3 : 0
  bgn=. >:>./PARTS,PARTSSTART
  if. 2 = 3!:0 y do.
    nms=. ;: y
    r=. bgn + i.#nms
    (nms)=: r
  else.
    r=. bgn + i.y
  end.
  PARTS=: PARTS,r
  r
)

shoe =: monad define
  glPushMatrix ''
  gscolor SHOECOLOR
  glMultMatrix ,(ShoeLength%3) (<3 1)}GS_ID4
  glClipPlane  GL_CLIP_PLANE0; 0 0 1 0 
  glEnable     GL_CLIP_PLANE0
  glScale ShoeLength * ShoeScale
  gluSphere  QUADS, ShoeLength, 30 30 
  glDisable     GL_CLIP_PLANE0
  glPopMatrix ''
)

leg =: monad define
  glPushAttrib GL_COLOR_BIT
  gluCylinder  QUADS, Leg , 30 30
  glCallList ".'LShoe',TID
  glPopAttrib ''
)

rightleg =: monad define
  glPushMatrix''
  glMultMatrix ,( LegShift) (<3 0)}GS_ID4
  glRotate (-LegOutAngle), 0 1 0
  glMultMatrix ,(-LegLength) (<3 2)}GS_ID4
  glCallList ".'LLeg',TID
  glPopMatrix ''
)

leftleg =: monad define
  glPushMatrix''
  glMultMatrix ,(-LegShift) (<3 0)}GS_ID4
  glRotate ( LegOutAngle), 0 1 0
  glMultMatrix ,(-LegLength) (<3 2)}GS_ID4
  glCallList ".'LLeg',TID
  glPopMatrix ''
)

forearm =: monad define
  gluCylinder  QUADS, Forearm , 30 30
)

rightforearm =: monad define
  glPushMatrix''
  gscolor HEADCOLOR
  glRotate ( ForeArmFdAngle), 1 0 0
  glRotate ( ForeArmOutAngle), 0 1 0
  glScale ForearmScale
  glCallList FOREARM
  glPopMatrix ''
)

leftforearm =: monad define
  glPushMatrix''
  gscolor HEADCOLOR
  glRotate ( ForeArmFdAngle), 1 0 0
  glRotate (-ForeArmOutAngle), 0 1 0
  glScale ForearmScale
  glCallList FOREARM
  glPopMatrix ''
)

upperarm =: monad define
  gluCylinder  QUADS, Upperarm , 30 30
)

rightupperarm =: monad define
  glPushMatrix''
  glMultMatrix ,( UpperarmShift) (<3 0)}GS_ID4
  glMultMatrix , TorsoLength (<3 2)}GS_ID4
  glRotate ( UpperArmFdAngle), 1 0 0
  glRotate (-UpperArmOutAngle), 0 1 0
  glMultMatrix ,(-UpperarmLength) (<3 2)}GS_ID4
  glCallList UPPERARM
  glCallList ".'LRightforearm',TID
  glPopMatrix ''
)

leftupperarm =: monad define
  glPushMatrix''
  glMultMatrix ,(-UpperarmShift) (<3 0)}GS_ID4
  glMultMatrix , TorsoLength (<3 2)}GS_ID4
  glRotate ( UpperArmFdAngle), 1 0 0
  glRotate ( UpperArmOutAngle), 0 1 0
  glMultMatrix ,(-UpperarmLength) (<3 2)}GS_ID4
  glCallList UPPERARM
  glCallList ".'LLeftforearm',TID
  glPopMatrix ''
)

torso =: monad define
  glPushMatrix''
  glScale TorsoScale
  gluCylinder  QUADS, Torso, 30 30
  glPopMatrix ''
)

skirt =: monad define
  glPushMatrix''
  gscolor BLACK
  glScale SkirtScale
  glMultMatrix ,(-SkirtLength) (<3 2)}GS_ID4
  gluCylinder  QUADS, (2.0&* Skirt), 30 30
  glPopMatrix ''
)

shoulder =: monad define
  glPushMatrix ''
  glClipPlane  GL_CLIP_PLANE0; 0 0 1 0 
  glEnable     GL_CLIP_PLANE0
  glMultMatrix ,TorsoLength (<3 2)}GS_ID4
  glScale 2.5&* ShoulderLength * ShoulderScale
  gluSphere  QUADS, ShoulderLength, 30 30 
  glDisable     GL_CLIP_PLANE0
  glPopMatrix ''
)

neck =: monad define
  glScale TorsoScale
  glMultMatrix ,(_0.6) (<3 2)}GS_ID4
  size =. (2#-:{.Torso),0.4
  gluCylinder  QUADS, size, 30 30
)

head =: monad define
  glPushMatrix ''
  gscolor HEADCOLOR
  glMultMatrix ,(0.4+TorsoLength+ShoulderLength) (<3 2)}GS_ID4
  glScale 1.85&* ShoulderLength * ShoulderScale
  gluSphere  QUADS, ShoulderLength, 30 30 
  glCallList NECK
  glPopMatrix ''
)

NB. setting turtle parameter values  ***************

NB. defining multiple turtle types
TurtleID =: 1 1000 2000
TypeNames =: 'turtle male_dancer female_dancer'
Types =: ;: TypeNames
whichTurtle =: >@({&Types)@ (TurtleID &i.)
selectTurtle =: dyad define
  select. x
  case. 1 do. turtle y
  case. 1000 do. male_dancer y
  case. 2000 do. female_dancer y
  case. do. 
    smoutput 'error in select'
    return.
  end.
)

BasicTnames =: <;._2 noun define
Position
Heading
Pencolor
Pensize
Penstyle
Turtlecolor
Turtletrait
Turtletype
Penstate
Turtlestate
Turtleerase
Stepsize
)

EyesTs =: noun define


  NB. The sequence here must correspond with that assigned
  NB.      in Position, P0, Heading, and H0 
  NB.      here in this noun and in its
  NB.      parallel noun for defining State.
  Eye =: 2 3           NB. add one turtle for the eye
  eye =: Eye&{           NB. must always be changed after Eye

  P0 =: Position =: 4 3$0 0 0 250 _200 0 _10 0 1000 10 0 1000
  P0 =: Position =: 4 3$0 0 0 250 _200 0 _5 0 1000 5 0 1000
  tmp =. Eye angFdist"1 eye P0
  H0 =: Heading =: 4 3$0 0 0 0 90 0 0 0 _90 0 0 _90
  H0 =: Heading =: 4 3$0 0 0 0 90 0 0.572939 0 _90 _0.572939 0 _90
  H0 =: Heading =: 4 3$0 0 0 0 90 0 ,,tmp,._90
  Pe0 =: eye P0
  He0 =: eye H0
  Pencolor  =: Black,Blue,Red,Blue
  Pensize =: 2 2 2 2
  Penstyle =: 0 0 0 0
  Turtlecolor =: Red,Blue,Red,Blue
  Turtletrait =: 12 51 12,9 30 12,9 30 12,:9 30 12 NB. (halfwidth,height,depth)
  Turtletype =: 1 1 1 1
  Penstate =: 1 1 0 0
  Turtlestate =: 1 1 0 0
  Turtleerase =: 1 1 1 1
  Stepsize =: 1 1 1 1
)

EyesTvalues =: <@". ;._2 noun define
4 3$0 0 0 250 _200 0 _10 0 1000 10 0 1000
,"_1 allRot 4 3$0 0 0 0,(pi%2), 0 0.00499996 0 ,(-pi%2), _0.00499996 0 ,-pi%2
Black,Blue,Red,Blue
2 2 2 2
0 0 0 0
Red,Blue,Red,Blue
12 51 12,9 30 12,9 30 12,:9 30 12
1 1 1 1
1 1 0 0
1 1 0 0
1 1 1 1
5 5 5 5
)

SampleTvalues =: <@". ;._2 noun define
3 3$0 0 0 250 _200 0 0 0 6
,"_1 allRot rfd 3 3$0 0 0 0 90 0 0 0 _90
Black,Blue,:Bkgrd
2 2 2
0 0 0
Red,Blue,:Bkgrd
1 1 12,1 0 12,:1 0 12
1 1 1
1 1 0
1 1 0
1 1 1
1 1 1
)

SN =: StateNames =: ];._2 ] 0 : 0
PositionX        
PositionY        
PositionZ        
HeadingRX
HeadingRY
HeadingRZ
HeadingHX
HeadingHY
HeadingHZ
HeadingUX
HeadingUY
HeadingUZ
PencolorR        
PencolorG        
PencolorB        
Penstate         
Pensize          
Penstyle         
Turtlestate 
Turtleerase      
TurtlecolorR     
TurtlecolorG     
TurtlecolorB     
TurtletraitW      
TurtletraitH      
TurtletraitZ      
Turtletype
Stepsize
)

SCN =: StateChangeNames =: ];._2 ] 0 : 0
HeadingRD          
HeadingHD          
HeadingUD          
DistanceRD         
DistanceHD         
DistanceUD         
PencolorRD        
PencolorGD        
PencolorBD        
PenstateD         
PensizeD          
PenstyleD         
TurtlestateD 
TurtleeraseD      
TurtlecolorRD     
TurtlecolorGD     
TurtlecolorBD     
TurtletraitWD      
TurtletraitHD      
TurtletraitZD      
TurtletypeD
Stepsize
)

BasicTvalues =: <@". ;._2 noun define
1 3$0
,:1 0 0 0 1 0 0 0 1
,:Black
2
0
,:Blue
,:1 0 12
1
1
1
0
1
)

NB. turtle initialization verbs      ***************

NB.* tP v ambivalent produces initial Turtle positions on unit circle
NB. usage: [radius] tP no_of_turtles
NB. positive y produces equi-distant turtles
NB. negative y produces turtles of random distance
NB. programmed by Paul Chapman
regular =. i. % ]
irregular =. (? % ])&1000000@|
list =. irregular`regular@.(= |)@]
thetas =. 2p1"_ * list
r =. * (| > 1:)
tP =: turtlePosition =: (1: $: ]) : (r +.@r. thetas) f.

testdlls=: 3 : 0
  0!:0 <jpath'~system\extras\util\testogl.ijs'
  'All OK.'
)

firsttime =: monad define
  iTS 2
  pu''
  0 1 goto 0 0 0,:250 _200 0
  1 rt 90
  Turtlecolor =: Red 0}Turtlecolor
  Turtlecolor state 'Turtlecolor'
  TheTurtle =: whichTurtle 1
  TID =: ": 0
  HEADCOLOR =: LIME
  states =. 0&{ each state each;:'Position Heading Turtlecolor'
  'POSITION HEADING TURTLECOLOR' =: states
  POSITION =: POSITION * Step_scale
  makeanyTurtle RED

  pd''
  H0 =: Heading 
  P0 =: Position
  State0 =: State
  NB. paintQ=:1
  NB. gspaint''
  Headpoly =: ,: {.state 'Heading'  NB.  needed for poly3 initialization
)

Init =: monad define
  GS_CLEARCOLOR=: gscolor4 (,Bkgrd,0)
  GS_COLOR =: Pen
  LISTS =: i. 0
  PARTS =: i. 0
  PARTSSTART =: 2000
  LTurtlepath =: 1
  EyeQ =: 0   NB. Flag for programmed eye movement
  gspdef GS_STATE1
  DIR =: DEGREE =: 0
  ROT =: GS_ID3
)

initLists =: monad define
  glDeleteLists (>:PARTSSTART);#PARTS
  LTheTurtle =.  i. 0
  LHead =.  i. 0
  LLeftforearm =.  i. 0
  LRightforearm =.  i. 0
  LLeftupperarm =.  i. 0
  LRightupperarm =.  i. 0
  LTurtlehead =.  i. 0
  LLeftleg =.  i. 0
  LRightleg =.  i. 0
  LLeg =.  i. 0
  LShoe =.  i. 0

  for_j. i. y
  do.
    LTheTurtle =. LTheTurtle,' '&, 'LTheTurtle',": j
    LHead =. LHead,' '&, 'LHead',": j
    LLeftforearm =. LLeftforearm,' '&, 'LLeftforearm',": j
    LRightforearm =. LRightforearm,' '&, 'LRightforearm',": j
    LLeftupperarm =. LLeftupperarm,' '&, 'LLeftupperarm',": j
    LRightupperarm =. LRightupperarm,' '&, 'LRightupperarm',": j
    LLeftleg =. LLeftleg,' '&, 'LLeftleg',": j
    LRightleg =. LRightleg,' '&, 'LRightleg',": j
    LLeg =. LLeg,' '&, 'LLeg',": j
    LShoe =. LShoe,' '&, 'LShoe',": j
    LTurtlehead =. LTurtlehead,' '&, 'LTurtlehead',": j
  end.

  (''"_) makelist LTurtlepath ''
  genpartslist LTheTurtle
  genpartslist LHead
  genpartslist LLeftforearm
  genpartslist LRightforearm
  genpartslist LLeftupperarm
  genpartslist LRightupperarm
  genpartslist LLeftleg
  genpartslist LRightleg
  genpartslist LLeg
  genpartslist LShoe
  genpartslist LTurtlehead

  genpartslist Partsnames
  forearm makelist FOREARM ''
  upperarm  makelist UPPERARM ''
  torso  makelist TORSO ''
  shoulder  makelist SHOULDER ''
  neck  makelist NECK ''
  skirt  makelist SKIRT ''

  turtles =. i. |y
  localnames =. 'position turtlecolor turtletrait turtletype'
  localvalues =. state each ;:'Position Turtlecolor Turtletrait Turtletype'
  (localnames) =. localvalues
  heading =. (mfv0 state 'Heading')
  rightArg =.  heading
  leftArg =.  position;turtlecolor;turtletrait;turtletype

  for_j.  turtles
  do.
    i =. j{turtles
    TID =: ": i
    leftArg drawsetup &:((i&{)each) <rightArg
    TheTurtle =: whichTurtle  0&{,turtletype
    makeanyTurtle TURTLECOLOR
    anyTurtle TURTLECOLOR
  end.
)


NB.* initTurtleState v (ambivalent)
NB. usage: [rows of (x,y) headings] initTStateBasic (no. of Ts)
NB. eg. (2 3$ 0 90 0 0 45 0 ) iTS 2  NB. create 2 identical turtles
NB.           iTS  4                 NB. create 4 identical turtles 
NB.           iTS _4                 NB. create 4 identical turtles 
iTS =: initTurtleState =: verb define
y iTS~ 0 0 0 copies~|y
:
yy =. | y
if. yy~:#x do. 
  'The number of turtle headings must equal the number of turtles.'
  return. 
end.
if. (~:<.)y do.
  'Number of Turtles must be integer.' 
  return. 
end.

Delay =: 0  NB. initialize wd 'timer'

NB. 3D eye information
Pe0 =: 0 0 6
He0 =: 0 0 _90

Eye =: yy              NB. add one turtle for the eye
yy =. >: Eye           NB. add one turtle for the eye
eye =: Eye&{          NB. must always be changed after Eye

NB. initialize default State
State =:  0$~yy,#StateNames
(yy&# each BasicTvalues) state each BasicTnames
EyeGazesAt =: ,:0 0 0

NB. initialize user info
P0 =: Position =: (3&{."1 [ 200 tP y),Pe0
H0 =: Heading =: x,He0

NB. convert user info to dbase format
heading =. ,"_1 allRot rfd Heading
position =. Position
shoecolors =. (#Safecolors)|i. | y
turtletrait =. (yy{.shoecolors) (1})"0 1 yy copies 3#0
turtlecolor =. state 'Turtlecolor'
turtletype =. state 'Turtletype'

NB. revise default State
(position;heading;turtletrait) state each ;:'Position Heading Turtletrait'
(Blue;(,:0);(,:0);(,:0)) stateEye each ;:'Pencolor Penstate Turtlestate Turtleerase'
StereoFlag =: 0

NB. revise user info
(BasicTnames) =: state each BasicTnames
Position =: P0
Heading =: H0
Turtletrait =: turtletrait
turtletype state 'Turtletype'
turtlecolor state 'Turtlecolor'

NB. keep copy of initial State
State0 =: State 

cs''
glClear GL_COLOR_BUFFER_BIT
initLists y
paintQ =: 1

NB. create State Change shell
SC0 =: SC =: StateChange =: 0$~ yy,0,#StateChangeNames NB. unsparse
NB. SC0 =: SC =: StateChange =: $. 0$~  yy,0,#StateChangeNames NB. sparse

NB. initialize shell drawing database
DrawPathList =: i. (#Eye), 0 ,6++/#&> (<SN) aindex each ;:'Pencolor Pensize Penstyle'

yw 0
StateNames;|: rnd State0
)

NB. each part has an invisible space at the end
Partsnames =: ;<@:}:@:toupper;. 2 noun define NB. (,&:>/)@:
forearm 
upperarm 
torso 
skirt 
shoulder 
neck 
)

cocurrent 'base'
coinsert 'bmsturtle3'           NB. give system its own locale

NB. tgsj3D_run ''
smoutput 'If there is no graphics window, enter this to start:'
smoutput '   tgsj3D_run '''''
