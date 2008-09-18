NB. built from project: ~user/projects/work1/pcc2

coclass 'spcc'

Note 'Copyright'

This program is copyright by L.Fraser Jackson. 2006, 2008.
It may be freely used for non-commercial purposes, and can 
be freely distributed, provided the script is unchanged 
and this notice is included unchanged in the distribution.
)  


NB.  summarypcc formats result of sequence of pcc steps
load 'files jfiles keyfiles stats plot strings validate primitives'

load 'grid'
coinsert_base_'spcc'

Note 'Main Functions'

summarypcc may have as right argument either a J numeric array
           or  a boxed list of variable names as a string followed by the data
           e.g. data =.  'a b';2 2 $4 10 13 28

           it has an optional left argument of the form
              F  for a variable which is not collapsed
              N  for a nominal variable
              O  for an ordinal variable, and using only adjacent variables
                 at each stage of the collapsing process
           The list must have the same number of items as variables.
           e.g.  'ON' summarypcc data

           After execution of summarypcc the variable Kp is available in
           locale containing these functions.  Note if the same locale is
           used Kp is overwritten and contains the calculations for the
           most recent execution of summarypcc.

summarypccnokey  performs the same functions as summarypcc, but does not list 
           the key field in the output.  For variables with large
           numbers of categories, that listing can become long and make it
           difficult to list and display the output.

pccbyvars  has right argument the result of summarypcc
           It separates the rows of the output table and lists them
           for each variable in the order in which collapsing steps 
           are performed.
)

summarypcc =: 3 : 0
y =. vtable y
'v dat' =. y
((#$dat)#'N') summarypcc y
:
y =. vtable y
r =. x summarypccn y
head =. 'r';'d';'key';'dim';'dev  dfmod dfres ';'dev(term) df';'AdRsq'
r =. (<0j3 6j0 6j0":>4{r) 4}r
r =. (<0j3 6j0 ":>5{r) 5}r
r =. (<0j3  ":>6{r) 6}r
head,:  r 
)

NB.  omit long key fields
summarypccnokey =: (0 1 3 4 5 6{"1 summarypcc ) :  (0 1 3 4 5 6{"1 [summarypcc ])



NB.  forms numeric arrays for output describing PCC steps
NB.  and global Kp for analysis.  Note that Kp may need some
NB.  post processing

summarypccn =: 3 : 0
y =. vtable y
'v dat' =. y
((#$dat)#'N') summarypccn y
:
y =. vtable y
Kp =: x pccall y
NB. Kp =: deltail ^:_1 Kp
r  =.  ,.  i.#Kp
dk =. >{."1 Kp
d  =. ,.>{."1 dk
dk =. > ": each  {:"1 dk
dim =. >$ each 2{"1 Kp
devterm =. 2 pcctest \ ({.Kp), Kp
cumdev  =.   +/\ devterm
dfmax   =. _1 + */ >0{dim
dfmod   =. dfmax - {:"1 cumdev
rr =. r;d;dk;dim;(0 2 1{"1  cumdev,.dfmod);devterm;,.adjRsq cumdev
Kpn =: (<getn rr) 2}rr
)

outputKp =: 3 : 0
r  =.  ,.  i.#Kp
dk =. >{."1 Kp
d  =. ,.>{."1 dk
dk =. > ": each  {:"1 dk
dim =. >$ each 2{"1 Kp
devterm =. 2 pcctest \ ({.Kp), Kp
cumdev  =.   +/\ devterm
dfmax   =. _1 + */ >0{dim
dfmod   =. dfmax - {:"1 cumdev
rr =. r;d;dk;dim;(0 2 1{"1  cumdev,.dfmod);devterm;,.adjRsq cumdev
(<getn rr) 2}rr
)

NB. extract model for original table from collapsed model
fitpcc =: 3 : 0
Ke =: expandall Kp
if. isempty y do.  Ke  else. y{Ke  
end.
)

NB.* pccbyvars  summarypcc (vars;data)
NB.  extracts key sequence for each variable and deviance for step

pccbyvars =: 3 : 0
d1 =.    1 {:: y
d2 =.    2 {:: y
d5 =.    5 {:: y
((d1 < /. d2) /: ~. d1) ,. (d1 < /. d5) /: ~. d1
)

pcctotinfo =: 3 : '{.@{:@ > @(4&{) Kpn'


NB.  MAIN ROUTINES

NB.  pccall returns array of results for each PCC step
NB.  pccall  vars;data
NB.  method  pccall vars;data  
NB.  method is one of 'FNO' for each variable
NB.  'F' fixed 'N' nominal 'O' ordinal

pccall =: 3 : 0
((#$dat)#'N') pccall y
:
'v dat' =. y
yc =. a:,y
n =. +/ <:($dat)
Kp=. (n+1) {. ,:yc
for_i.
  i.n
do.
dk =. x ming }. i{Kp
nyc=. dk collapsep i{Kp
Kp =. nyc (i+1)}Kp  
end.
Kp
)


NB.  Find minimum gradients

ming  =: 3 : 0
'v d' =. y
((#$d)$'N') ming y
:
'vars d' =. y
m  =. x minv y
mv =. {."1 m
v  =. mv ~: a:
klg =. %/"1 ],. v# >0 2{"1 m
mklg=. <./klg
i  =.(v #^:_1 klg) i. mklg
ii =. >(<i,1){m
i ; ({.ii)  ii} i. i{$d
)

NB.  minv =: ([: <./ ,) &. >  @ {."1   NB.  finds min of each row of
                                   NB.  result of klstatcases

minv  =: 3 : 0
minv0 "1 (klstatcases y)
:
minv0"1 x klstatcases y
)

minv0 =: 3 : 0
'r s' =. y
if. isempty r do. a:,a:,<s return. end.
if. 1=#r do. _ ; 0 0; s  return. end.
if. isvector r do. 
    m =. <./r 
    m ; (0 1 + r i. m );s
    return. 
end.
if. =/$r do. 
     nd   =.   , ~: /~ (i.#r)
     ndv  =. nd # ,r
     minv =. <./ndv
     mini =. ndv i. minv
     minr =. mini { nd#i. #,r
     m =. <./ (, ~:/~ (i.#r)) # ,r 
     minv ; (($r)#: minr) ; s 
end.

)

NB.  test 6!:2 '0 1 2 3 (<@klgrad) "0 _ td5'

NB.  Find (r,c) for min entry in matrix and its value 
minmat =: 3 : 0
 v =. ,y
 minv =. <./(v>0)#v
 i =. {. I. v = minv
 rc =. ($y)#:i
 rc;minv
)





NB.  alt version  - using xtable
klstatcases =: 3 : 0
dat =. xtable y
((#$dat)$'N') klstatcases y
:
n =. #x
r =. 0 0$a:
for_i.
  i.n
do.
  select. i{x
   case. 'F' do. r =. r,(a:,a:)
   case. 'N' do. r =. r, i klstat y
   case. 'O' do. r =. r, i klstat2 y
  end.
end.
)

klvec =: 4 : 0 
 xm =. , x indepxy y
 xa =. x,y
xa gsq xm
)


klvec2 =: 3 : 0
'r s' =. y
r klvec s 
)

klstat2 =: 4 : 0
 yt =. xtable y
 t  =. x, (i.#$yt)-. x
 if. 1 =x{$yt do.  (1 1$  0);0 return. end.
 dfy =. ((i.#$yt) -. x){$yt
 df =. <: */dfy 
 ty =. ,. t|:yt
 ndy =. x{$yt
 r =. (i. ~:/ i.) ndyt
 (2 klvec2 \ ty); df
)


NB.  Find array of KL distances between rows and df
NB.  for each distance.  Functions are a set of utilities

klstat =: 4 : 0
 yt =. xtable y
 t  =. x, (i.#$yt)-. x
 if. 1 =x{$yt do.  (1 1$  0);0 return. end.
 dfy =. ((i.#$yt) -. x){$yt
 df =. <: */dfy 
 ty =. ,. t|:yt
 ndy =. x{$yt
 r =. (i. ~:/ i.) ndy
 (r *ty klvec"1 1/ty);df
)

klmat  =: 0 {:: klstat  NB.  d klmat v;data
klgrad =: ((0{::])%1{::])@ klstat

infoloss =: klmat

listinfoloss =: 4 : 0
'y0 y1' =. y
d =.0j2": x klmat y
v =. i. x{$y1
labels =. ({. >x{;: y0),. ":,.v
labels ;d
)
 

NB.  collapsing and expansion steps
collapsep   =: 4 : 0
 'd k' =. x 
 if. isempty >d do. (x );}.y  return. end.
 'scs vars source ' =. y 
 k =. (~. k) i. k          NB.  re-index classifier
 ii =. (#$source)-d        NB.  Find rank to be used 
 v =. k +/ /."(ii) source  NB.  Form aggregated data.
 x ;vars;v
)


NB.  expand expands model back to dimension of source
NB.  imposing the constraints associated with the key k
expandt=: 3 : 0          NB.  "inverts" a collapse  step .
 y
: 
 'm0 vars source' =. x 
 'mm vars model' =. y
 NB. if. ($source)=$model do. x return. end.

 if. isempty mm do. y  return. end.
 'd k' =. mm
 if. isempty d do. y  return. end.
 mi    =. d summ source               NB.  2.2.1.1
 k     =. (~. k) i. k   NB.  sort and re-index classifier
 ii    =. d { >: i. -(#$source)  NB.  Find rank to be used 
 sik   =. k +/ /. mi    NB.  form sums
 divi  =. k { sik       NB.  form divisors
 multi =. mi % divi     NB.  form multipliers
 modi  =. k { "ii model
 modi =. multi *"ii modi
 m0;vars;modi
)

expandall =: }."1 @ (expandt /\)


NB.  Expansion using keys alone is useful for
NB.  viewing model structure.

keyvecs =: 3 : 0
keyd =. (<@i.) "0 >(3;0){::y
dims =. <"0 ,>1{y
keylist =. <"1 >2{y
dims,.keylist
)

keymerge =: 4 : 0
'd key' =. x
key  d} y
)



expkey =: 4 : 0
'd key' =. x
tab =. y
n =. #$y
key{"(n-d) tab
)



pcctest =: 3 : 0
a0 =. {.y
a1 =. {:y
'dk0 v0 source' =. a0
'dk1 v1 mod'    =. a1
df1 =. */$source
df2 =.  */$mod
df =. <: df1 - df2
if. df = _1 do. df =. 0 end.
m2  =. >{:  a0 expandt a1
(source dsq  m2),df
)

adjRsq =: 3 : 0
 gminusr =. {:"1 y
 gsquared =. {."1 y
 gratio =. gsquared % gminusr
 1 - gratio% {: gratio
)

NB.  Independence model for two vectors
indepxy =: 4 : 0  "1
 t =. x + y
 tr =. t % +/t
 ,((+/ x),+/ y)*/tr
)

NB.  General independence model

indep =: 3 : 0
z =. xtable y
select. (# $ z) <. 2
 case. 0
  do.  z
 case. 1
  do.  (#z)#(+/z)%#z
 case. 2
  do.  zm =. (i. #$z) (<@summ)"0 _ z
       n =. +/ >{.zm
       zm =. (%&n each }:zm) (i. <:#$z)}zm
       > */&.> / zm
end.
)


NB.  find KL distance of x from y
gsq =: 4 : 0
s =. ,xtable x
a =. ,xtable y
v =. (s>0) *. a>0
s =. v#s
a =. v#a
2*+/,s*^. s%a
)

NB.  find KL distance for individual cells
NB.  Identifies all zeros
gsqc =: 4 : 0
s =. ,xx =. xtable x
a =. ,xtable y
v =. (s>0) *. a>0
s =. v#s
a =. v#a
($xx)$ v #^:_1] 2*s*^. s%a
)

NB.  obs xsq exp
xsq =: 4 : 0
s =. ,xtable x
a =. ,xtable y
v =.  a>0
s =. v#s
a =. v#a
+/(*:s-a)%a
)

NB.  obs xsq exp
xsqc =: 4 : 0
s =. ,xx =. xtable x
a =. ,xtable y
v =.  a>0
s =. v#s
a =. v#a
($xx)$ v #^:_1](*:s-a)%a
)
dsq =: gsq f.  NB.  Find KL distance from independence model




deltail =: 3 : 0
if. =/{:"1 (_2{. y) do. }: y 
 else. y
end.
)

NB.  functions for constructing key vectors
NB.  and degrees of freedom.  Note df calculations
NB.  assume no structural zeros and make no 
NB.  adjustment for sampling zeros 

getk =: 3 : 0
kv =.". each }. <"1 > 2{y
kd =.}. >1{y
ke =. kd < /. kv
newlist =. |. each dkk each |. each ke
ki =. kd < /. i.#kd
(> ,&.> / newlist) /: > ((,&.>)/ki)
)

getn =: 3 : 0
a =. getk y
' ',>": each a
)


dkk =: 3 : 'nf/\.y'


nf =: 3 : 0
x
:
<(nni >y) { nni > x
)

nni =: ~. i. ]


ne =: {&nni
nni =: ~. i. ]

NB.  function for analysis of sensitive cells
NB.  Only required for confidentiality applications.

fnsens =: 3 : 0
 'm v mod' =. y
 v =. ,mod
 +/v =/0 1 2 3
)

NB.  Utility for retrieving data
 
getpcc =: 3 : 0
1 2{y{Kp
)

tabdata =: {:"1

NB.  Note also use of fetch  e.g. 1 3{::
NB.  permits extracting items from Jf



NB.  to partition matrix requires xp (rows) yp (cols)

NB.  to subset data with boxed arrays
NB.  keys part data  - along first dimension

part =: 4 : 0
x < /.y
)
partb =:  [part[:>]

rseq=: [: +/\ 0, }.~:}:

partitions =: 4 : 0
if. (1=#x ) +. -. isboxed x do. x =. x;x=.>x end.
 'xp yp' =.rseq each x
 |: ,. > xp&partb each |:each  yp part |:y
)

partition  =: 4 : 0
if. (1=#x ) +. -. isboxed x do. x =. x;x=.>x end.
'xp yp' =. x
 |: ,. > xp&partb each |:each  yp part |:y
)

Note 'Pearsons ratios'

Goodman (1996) uses the ratio of the cell values
to their expected values under independence as a
key feature of his exposition of measures of association
in two way tables. 

The function pearson when used monadically returns
the pearson ratios for two way tables.  If the argument
is a larger array it returns the results for 
applying the function at rank 2 to the argument.

Note this permits study of conditional independence
in any array by transposition of the argument.

When used dyadically the concept is expanded to give
the ratio of the observed values to the model values, 
thus permitting more complex models for multivariate
data.

Both arguments may be numeric or tables in (vars;data) 
form.
) 


NB.  pearsons ratios for table  applied to rank 2 arrays 
NB.  as base


NB.  utilities to convert between vars;data and  data forms
xtable =: 3 : 0
if. (isboxed y) *.  (#y) e. 2 3 4 
 do. >{:y
 else.
  a =. >y
  assert. isnumeric a
  a return.
end.
)

vtable =: 3 : 0
if. isnumeric y 
 do. 
   v =. ,(i.#$y) { ((97+i.26){a.),.' '
   v;y  
 else.
   if. (isboxed y) 
    do.
     select. (#y)
      case. 0 do. assert. 1=2
      case. 1 do. yo =: >y
                  assert. isnumeric yo
                  vtable yo  
      case. 2 do. 
                'v tab' =. y
               if. (ischaracter v) *. (#;:v) = #$tab
                    do. y
                else. vtable tab
               end.
      end.
   end.
end.
)

pearson =: 3 : 0
yy =. xtable y
yy %>indep yy 
:
s =. , xx =. xtable x
a =. , xtable y
v =. (s>0) *. a>0
s =. v#s
a =. v#a
($xx)$ v #^:_1] s%a
)


NB.  find marginals for either numeric arry 
summ =: 3 : 0 "_ 1 _
 y =. xtable y
 +/y
 :
 y =. xtable y
 nd =. #$y
 assert.  nd > >./x
 if. 1 >:#$y do. +/y  return. end.
 ds =. i.#$y
 t =. (ds -. x),x
 ns=. #ds -. x
 +/^:ns t|:y
)

sumv =: 4 : 0
'v dat' =. vtable y
vx =.  ;:^:_1 x{;:v
vx;x summ y
)


relp  =: 3 : 0
'v dat' =. vtable y
v ; (]%+/@:]) "1 dat
:
'v dat' =. vtable y
vv =: ;:v
vn =. (;:^:_1 (vv -. x{vv)),x{vv
vn; (]%+/@:])"1 x|:dat
)


NB.  New utilities  pearson and expansion


pearsonmodels =: 3 : 0
r =. y
rd =. ,  1{::r
rk =. (<@".) "1 ]2 {:: r
rdim =. (<@i.)"0  {.3{::r
rkeys =: ((#rd),#rdim)$rdim
for_j.
  }. i.#rd
do.
  jd =. j{rd
  jr =. (j{rk)  jd}(j-1){rkeys 
  rkeys =. jr  j} rkeys
end.
)

pmodelexpand =: 4 : 0
nx =. #x
xx =. (~.i.]) each x
yy =. >tabdata y
for_i.
  i.nx
 do. 
  
 yy =. (> i{xx) {"(nx-i) yy
end.
<yy
)

pearsonpcc =: 3 : 0
rk =. pearsonmodels Kpn
rt =. (<@pearson) "1 Kp
rk pmodelexpand"1 0 rt
)

modelpcc =: 3 : 'expandall Kp'
modelhll =: 3 : 'tabdata " 1  Kh'

FMTPCC =: 0j3 6j0 6j0

NB.  Modified to place data in locale

Note 'Data required for paper examples'

Bivariate tables 

coxw1

Multivariate table

abort 2 2 3 6 from Christensen

Note data is entered in row major order
)

coxw1 =: 5 5 $12 13 12 20 7 215 507 493 460 137 277 300 192 126 38 52 91 47  15 6 233 225 102 74 19
 
coxw1 =: 'S A';coxw1

NB.  from Christensen  Table 3.1
NB.  abortion opinion data variables: race sex opinion age


abort1 =. 96 138 117 75 72 83 44 64 56 48 49 60 1 2 6 5 6 8
abort2 =. 140 171 152 101 102 111 43 65 58 51 58 67 1 4 9 9 10 16
abort3 =. 24 18 16 12 6 4 5 7 7 6 8 10 2 1 3 4 3 4
abort4 =. 21 25 20 17 14 13 4 6 5 5 5 5 1 2 1 1 1 1
# each abort1;abort2;abort3;abort4
abort =: 'r s o a';2 2 3 6$abort1,abort2,abort3,abort4






NB. built from project: ~user/projects/work/paper2
NB. built from project: ~Projects/nanny/nanny2
NB.  Listing for HLL models
NB.  adjust small deviances for some cases

script_z_ '~system/main/validate.ijs'


Note 'Main function for hll models with IG selection'

Data in form   var list ; table
Result is formatted table
)


N =: 0

summaryhll =: 3 : 0 
y =. vtable y     
'Kh Khd'=: decseq2 y 
mods =.  {."1 Kh
k =. adj0 Khd
heads =. 'r';'terms';' dev    dfmod dfres';'dev(term) df';'AdRsq'
size =. ((": #$>{:y ),' Vars');('Shape  ',":$>{:y )
rows =. a:,(<'r')
aa =.  ( <  k), ( < ] 0 0 , 0 2{"1 (}.-}:)k), <,. Rsq Khd
ab =. (<>tohterms each mods) 
r =. (<,. i.#k),ab,aa
Khn=: r
r =. (< 0j3 6j0 6j0":>2{r) 2}r
r =. (<0j3 6j0 ":>3{r) 3}r
r =. (<0j3  ":>4{r) 4}r
heads ,:r
)

NB.  Utilities
NB.  Adjust for small deviances
adj0 =: 3 : '(-. y<0.0001)* y' "0   NB. 0.0
NB.  Convert form model references 
tohterms =: 3 : ' deb ,'' '',.ntoa1 htermsmax y'   NB. 0.0


NB.  Model Uses local info stats for selection

decseq2 =: 3 : 0
j0 =. setupmodel y 
nd =. #$>2{j0
m0 =. >./i. 2^nd
m1 =. 2^i.nd
js =. (<m0),1 2 2{ j0
j0 =. m1 MFit j0
bb =.  ,: js
bi =.  ,: idata js

mm =.  <m0 
n =. 0
label_one.
  bb0  =. ,{: bb
  NB.  if. bb0 = < 0 do. bb;bi return. end.
  m1 =. hdecseq2 bb0
  m1 =. m1 -. mm
  if. isempty m1 do.
       bb;bi return. 
  end.
  j1 =. m1 MFit"0 _ j0
  t1 =. idata"_1 j1
  w  =. mini (0{"1 t1) % 2{"1 t1
  nb =. w{j1
  mm =. mm,{.nb
  bb =. bb,nb
  bi =. bi,w{t1
  n =. n+1
goto_one.
)

Note ''
decseq, hdecseq 
See script nanny\59.ijs for additional functions
)

NB.  check hdecseq2

hdecseq2 =: 3 : 0
nd =. #;:VARS
n1 =. 0,2^i.nd
if. isboxed y do. y =. >{.y end.
a =. < htermsnorm  y
b =. <"0  y
c =. ~. htermsmax each a -.&.> / b
d =. htermsmax y
e =. c -. < d
f =. htermsnorm each e
g =. -.&n1 each f
h =. > ([: *./ n1 &e.) each f
i =.  > (#>:0:) each g
(h *. i) # e
)

hlowseq =: 4 : 0
x =. >x 
ht  =. htermsnorm each hdecseq y1 =. (>y),x,0
ht1 =. *./@ (x & e.)   each  ht
ht2 =. # each ht
ht2a =. -&2 each h2
ht2b =. >&
hs3 =. htermsnorm (>y),x,0
ht3 =. -. each *./ @ (hs3 & e.) each ht
ht,ht1,ht2,ht3,:htermsmax each ht
NB. v =. (1 = >ht1) *. (>ht2)>: 2+#>x
NB. htermsmax each v#ht
)


NB.  functions for tests and degrees freedom

mini =: ] i. <./

itest =: 3 : 0
'm1 v1 s1 a1' =. y 
s =. ,s1
a =. ,a1
v =. (s>0) *. (a>0)
s =. v # s
a =. v # a
2 * +/, s * ^. s%a 
)

dfdata =: 3 : 0
'm1 v1 s1 a1' =. y 
mh =. htermsnorm m1
dfmodel =. +/ mh{HDF
dfresid =. (+/HDF) - dfmodel
dfmodel,dfresid
)

idata =: itest,dfdata
dfmod =: [: {. dfdata
dfres =: [: {: dfdata 

NB.  Utility
mean =: +/%#


Note 'Term Utilities'

Terms in a hierarchic model can be referred to in 
several different ways.  We use three 
representations.

Alphabetic    'a b d c'
Numeric       an integer specifying location in
              a list of all hierarchic terms
Dimensions    the dimensions in the marginal 
              associated with the term  e.g.  1 3

A fourth representation, the model specification 
used in R could readily be added. 

For any table there is a list  of names of the 
variables associated with each dimension.  That 
list provides a standard order for all alphabetic
name lists. 

We provide functions to transfer in any direction
between the above representations

aton   ntoa 
atod   dtoa
ntod   dton

The standard order for the numeric representation 
is illustrated in the listing below

To generate the following table use:
,.(": ,.i.16) ,.' ',.( ntoa "0 i.16),.' ' ,. > ": each ,.(<@ntod) "0 i.16

VARS  is  'A M Q F'

 n            alphabetic         dimension
 0                                 
 1            A             0      
 2            M             1      
 3            A M           0 1    
 4            Q             2      
 5            A Q           0 2    
 6            M Q           1 2    
 7            A M Q         0 1 2  
 8            F             3      
 9            A F           0 3    
10            M F           1 3    
11            A M F         0 1 3  
12            Q F           2 3    
13            A Q F         0 2 3  
14            M Q F         1 2 3  
15            A M Q F       0 1 2 3

Examples:

   ntoa 3  
A M
   dton 1 2 3 
14

Note selection occurs using the reverse of the
binary representation of the dimensions 
commencing with the first dimension.  Note the 
dimension numbering begins with 0, and that the
term n=0 represents an empty set of dimensions.

aton and ntoa can be used dyadically with a left
argument replacing the standard list VARS derived
from a model representation.
)

Note 'Indexing and Sorting'
The following functions are useful utilities

sortwords     puts word in alphabetic order

varlist indexalpha sublist  finds locations
              of words in sublist within varlist

Examples:
   sortwords 'the last is not first'
first is last not the
   'd c b a' indexalpha 'a b d'
3 2 0
)

indexalpha =: i. & ;:
sortwords  =: /:~ &. ;:


NB.  alpha to numeric and inverse

aton =: 3 : 0 "1
if. LF e. y do. y =. >< ;._2 y end.
VARS aton y 
:
if. LF e. y do. y =. >< ;._2 y end.
i =: x  indexalpha y 
#. |. 1 i} (#;:x )#0
)

ntoa =: 3 : 0 "1 0
VARS ntoa y 
:
;: ^:_1 ( |.(-#;:x ){. #: y ) #  ;: x 
)

ntoa1 =: 3 : 0 "1 0
db =. ([:-.' '=])#]
db "1 VARS ntoa y 
:
db =. ([:-.' '=])#]
db"1 x  ntoa y 
)

NB.  dimensions to numeric and inverse

dton =: 3 : 0
n =. $;:VARS
#. |.(i.n) e. y 
)

Note 'conversion from dimension vector start 1 to n'
This is necessary for some common model descriptions used
by Fienberg and others.  Dimensions start counting at 1
)

d1ton =: 3 : 0
v =. >y 
n =. #;:VARS
#.(>: i. -n) e. v
)


ntod =: 3 : 0 "0
n =. $;:VARS
(|.(-n){.(#:y )) # i.n
)

NB. alpha to dimensions and inverse

atod =: 3 : 0
(;:VARS) i. ;: y 
)

dtoa =: 3 : 0
;: ^:_1 y { ;:VARS
)


Note 'Hierarchic terms'
If we have a set of variables we need all
hierachic components of that set. The following 
functions provide a means of finding related
sets of terms.  The standard arguments are the
term number

hterms   finds all the hierarchic components of n
dterms   finds all terms containing n

htermsnorm  finds the list of all hierarchic 
         components of a list of terms
dtermsnorm  finds the list of all hierarchic
         components containing all items in a list.

htermsmax   finds the minimal list of terms required
         to include all hierarchic components in a
         list of terms
dtermsmin   finds the minimal list of terms which
         contain all higher components in the list. 

dhterms     take all hierarchic components out and 
            find the minimal dterms 
hdterms     take all dterms out and find the maximal
            hierarchic components left.
)

hterms =: 3 : 0
if. y  = 0 do. 0 return. end.
v =. #: y 
m =. v #|. 2^ i.#v
+/"1 (#: i. 2^#m) * "1 _ m
)

dterms =: 3 : 0
n =. #;:VARS
v =. (-n){.#: y 
sv =. +/v
n2 =. #: i. 2^n
d =. (sv = +/"1 n2*"1 _ v)# n2
d +/ . * |. 2^i.n
)


htermsnorm =: 3 : 0
h =. ''
~.  >  ,&.> / (<@ hterms ) "0 y 
)

dtermsnorm =: 3 : 0
d =. ''
~.  >  ,&.> / (<@ dterms ) "0 y 
)

htermsmax =: 3 : 0
y =. /:~ y 
t =. i.0
while. (#y)>0
 do. 
   max =. >./y
   t   =. t , max
   y   =. y -. hterms max
end.
t
)

dtermsmin =: 3 : 0
y =. dtermsnorm y 
t =. i.0
while. (#y)>0
 do. 
   min =. <./y
   t   =. t , min
   y   =. y -. dterms min
end.
t
)

dhterms =: 3 : 0
d =. (i. 2^#;:VARS) -. htermsnorm y 
dtermsmin d
)

hdterms =: 3 : 0
h =. (i. 2^#;:VARS) -. dtermsnorm y 
htermsmax h
)

Note 'Hierarchic terms degrees of freedom'

In a saturated model with all terms 
hdf X  returns the degrees of freedom for
all hierarchic model terms for the nv =. #$X 
dimensions of the array X.  There are 2^nv
possible terms in such models. The values 
sum to */$ X.  Note the first value is 0
to match the total +/,X in a uniform model.

Usage:   HDF =: hdf XMAT

)

hdf =: 3 : 0
n =. 2^ nv =. # $ y 
ht=. #:i.n
g =.  |. <: $y  
comp =. [: */ [#] 
v =. ht comp"1 _ g
0 (0)}v
)

Note 'Comparison of two models and model df.'

For two numerically specified models we can find
the additional terms required with the function and 
the corresponding df with

mod1 incterms mod2
mod1 incdf mod2

For a model

moddf mod1
resdf mod1
)


incterms =: 4 : 0
/:~ (htermsnorm y ) -. htermsnorm x 
)

incdf =: 4 : 0
df1 =. ( +/ (htermsnorm y ){HDF)- (+/(htermsnorm x ){HDF) 
)

moddf =: 3 : 0
+/(htermsnorm y ){HDF
)

resdf =: 3 : 0
+/ ((i.#HDF)-. htermsnorm y ){HDF
)

Note 'Level - Factor Interaction levels'

For many purposes we need the number of factors
associated with a particular hierarchic term.
The level is just the number of dimensions 
associated with the term.  

We also often need the level associated with all
hierarchic components of a term.

lterm  gives the level of a term
lterms gives the level of all hierarchic components.
)

lterm =: #@ntod

lterms =: 3 : 0 
lterm "0 y
)

Note 'terms at various levels and some recursions'

First we define the sets of terms at each level as the 
interactions of the same number of factors.

Form a list of terms for each of these.
)

termlevel =: 3 : 0
'mod vars zdata fit' =. y 
n =. #$zdata
nt =. +/ "1 #: i. 2^n
nt < /. i. 2^n
:
> ,&.> / x  { termlevel y 
)

setdata =: 3 : 0
1['VARS TABDATA' =. y
)




NB.  ==============================================
NB.  Marginals and iteration for DS algorithm

Note 'Marginals'

These functions provide tools for generating marginals.

The marginal required is specified using either the dimension
form or the numeric form. The data matrix has been extracted
from a model object before the function call.

marginald   forms the marginal using the dimension form
marginaln   forms the marginal using the numeric form
marginalH   forms all hierarchic marginal terms as a list of
            boxed array arrays

The result of the call is a marginal object with
(dimensions of marginal) ; (transpose indices); (marginal array)

)


marginald =: 4 : 0
x ; (x,vi); +/ ^:(n-#x) (  (vi =. (i.(n =. #$y)) -. x),x)|: y
)

marginaln =: ((ntod@[) marginald ])"0 _ 

marginalH =: 3 : '(i. 2^#$y) marginaln y'
 








NB. 5c==============================================
NB.  Environment for DS calculations

LOG =: 3 : 'if. y >0 do. ^. y  else. 0 end.' "0


Note 'Globals'
EPS 	maximal dev for IPF routine
XMAT	data array
VARS	variable names as string

FIT0  	initial fit - assumes no structural zeros
NV		number of variables - dimensions of table
NT		number of terms in hierarchic model
NTV		vector of  i. NT

HDF	 	degrees of freedom for all hierarchic terms
HMARG	all hierarchic marginal tables
HDIV	divisor for sum terms to obtain means

LXMAT	log of XMAT
LHMARG	marginal tables for LXMAT
LMARG	marginal tables divided by HDIV

H		deviations of marginal table from overall mean
)

NMAX =: 20   NB.  maximum number of iterations

NB.  adjust all tables 
ADJ =: 0

tabadj =:  3 : 0
ADJ tabadj y
:
y + (y=0)*x
)

FITC =: $ $ ([: +/ ,)% ([: */ $)   NB.  Complete model - no structural zeros
FITZ0 =: FITC * ]>0:   NB.  With structural zeros on sample zeros
FITZ  =: 3 : 0
yp =. FITZ0 y
yp * (+/,y)%+/,yp
)

FIT  =: FITC

setupmodel =: 3 : 0
EPS =: 0.001 
'VARS XMAT' =: y 
XMAT =: tabadj XMAT
HDF   =: hdf XMAT    NB.  Vector of df of terms
NV    =: #;:VARS     NB.  Number of factors
NT    =: 2^NV        NB.  Number of terms
NTV   =: i. NT       NB.  List of terms
FIT0  =: FIT XMAT    NB.  Modify FIT for structural zeros
HMARG =: NTV marginaln XMAT  NB. boxed list of marginals
LXMAT =: LOG XMAT
H     =: (0{"1 HMARG) ((>@[) dtmean ]) "0 _ LXMAT

NB. HDIV  =: hdivcalc "0 NTV     
NB. LHMARG=: NTV marginaln LXMAT
NB. LMARG =: HDIV  %~ &. >  2{"1 LHMARG

'';VARS;XMAT;FIT0
)

setupsat =: 3 : 0
EPS =: 0.001 
'VARS XMAT' =: y 
XMAT =: tabadj XMAT
HDF   =: hdf XMAT    NB.  Vector of df of terms
NV    =: #;:VARS     NB.  Number of factors
NT    =: 2^NV        NB.  Number of terms
NTV   =: i. NT       NB.  List of terms
FIT0  =: FIT XMAT    NB.  Modify FIT for structural zeros
HMARG =: NTV marginaln XMAT  NB. boxed list of marginals
LXMAT =: LOG XMAT
H     =: (0{"1 HMARG) ((>@[) dtmean ]) "0 _ LXMAT

NB. HDIV  =: hdivcalc "0 NTV     
NB. LHMARG=: NTV marginaln LXMAT
NB. LMARG =: HDIV  %~ &. >  2{"1 LHMARG

NTV;VARS;XMAT;XMAT
)




NB.  5dr1============================================

Note 'ds5dr1'

Functions to do iterations in IPF.
These functions operate on global data
so they are constrained to operate in a locale.

Note comparison is with required marginals - so is 
a direct test of iteration to required result, rather 
than a sufficiently small iterative step.

MstepN is of form  MStepN y   with the argument the
term in the 2^n sequence

A model is expressed as the set of maximal terms 
in the hierarchic model formulation.

Each iteration consists of MStepN terms for each
term in the model



)

MStepN =: 3 : 0  "0
'dims ni margx' =. y {HMARG
vF =: ni |:^:_1 (  margx % (>{: dims marginald vF)) * ni |: vF
)

MStepNM =: 3 : 0  "0
'dims ni margx' =. y{HMARG
>./ ,|margx - (>{: dims marginald vF)
)


MIter  =: 3 : 0
for_i.
  i. # y
do.
  MStepN  i{y
end.
vF
)

MIterM  =: 3 : 0 
  MStepNM "0  y 
)
Note 'Model Fitting'
To fit a model we need to run this process until there is no
further change in the terms. We could use  ^:_ to do so but
prefer to use a criterion with a bounded change for an
iterative step.

Can simplify references to vF
)

MFit =: 4 : 0
if. 2 = # y do. y =. setupmodel y end.
'modt vars zdata vF' =: y
if. isboxed x do. x =. >x end.
x =. ~.x
if.  *./x e. modt  do. y return. end.
vF0 =: vF
newmod =. modt,x -. modt
N =: 0
label_one.
 vF =: MIter newmod
 N =: 1 + N
if. ((>./ , MIterM newmod)>EPS) *. N < NMAX
 do.  vF0 =: vF
      goto_one.
 else.  newmod;vars;zdata;vF
end.
)


HFit =: 4 : 0
( htermsmax x ) MFit y 
)

NB.  Subtractive Fit
SFit =: 4 : 0
'modt vars zdata vF' =: y
vF0 =: vF
vF  =: ($vF)$1
newmod =. (modt,x) -. x
N =: 0
label_one.
 vF =: MIter newmod
 N =: 1 + N
if. (>./ , MIterM newmod)>EPS
 do.  vF0 =: vF
      goto_one.
 else.  newmod;vars;zdata;vF
end.
) 

NB.  Test statistics

NB.  Wilks statistic

Gsq =: 3 : 0
'mod vars xx M' =. y 
pos =. ,(xx>0)*. M>0
px =. pos#,xx
pm =. pos#,M
(2*+/ px * (^.px)-^.pm) , (moddf mod), resdf mod
:
<Gsq y , x  moddfres y 
)

Gsqinc =: 4 : 0
'g1 df1 rdf1' =. Gsq x 
'g0 df0 rdf0' =. Gsq y 
gsq =. g0-g1
df  =. df1 - df0
pgsq=. df chisqpv "0 0 gsq
gsq, df,pgsq
)

NB.  Rsq for deviance data

Rsq =: 3 : 0
v =. y
gminusr =. {:"1 v
gsquared =. {."1 v
gratio =. gsquared % gminusr
1 - gratio% {: gratio
)

NB. adjRsq =: Rsq f.

NB.  Pearsons Xsq

Xsq =: 3 : 0
'mod vars xx  M' =. y 
pos =. , M>0
px =. pos#,xx
pm =. pos#,M
+/(*: px-pm)%pm
:
<(Xsq y ), x  moddfres y 
)


chisqpv =: 4 : 0
if. (x <100) *. ((y -x )%%:2*x )<5 
 do. x  chisqpval y 
 elseif. (x <100) *. ((y -x )%%:2*x )>5 
  do. 0.001
 elseif. (x  >: 100) *. (y  < 1.5*x )
  do.  -. (x , 2*x ) Normal y 
 elseif. (x  >: 100) *. y  >: 1.5*x 
  do.  0.001
end.
)     



Normal=: 3 : 0
t=. %>:0.2316419*|y 
c=. %%:o.2
z=. c*^--:*:y 
p=. t*_1.821255978+t*1.330274429
p=. t*0.319381530+t*_0.356563782+t*1.781477937+p
((y >0)*1-z*p) + (y <:0)*z*p
:
Normal (y -0{x )%(%:1{x )
)
   NB.  Normal Cumulative based on Abramovitz and Stegum 26.2.17

NormalTail =: -.@Normal



compare =: 3 : 0
w =. ]
'' compare y 
:
NB.
NB. select. tolower x
NB.  case. 'log' do. w=.    (0:`^.)@.(]>0:) 
NB.  case.       do. w =. ]
NB. end.
w =. ]
if. ischaracter y
 do. z =. ".y
     yt =. y
 else. z =. y
     yt =. ''
end.
a =. summaryhll z
b =. summarypcc z
da =. ". {. >}. 2{"1 a
db =. ". {. >}. 4{"1 b
na =. ({:; w"0 @ {.) @ (2{.|:)
NB. nb =. ({:; w"0 @ {.) @ (2{.|:) 

pd 'reset'
   pd 'title ',x, ' Information Loss ',yt 
   pd 'xcaption Number Fitted Parameters'
   pd 'ycaption ',x, ' Information Loss'
   pd 'keycolor blue, red'
   pd 'key "PCC" "HLL"'
   pd 'keypos rti'
   pd 'type line'  
   NB. pd 'xrange 0  600;yrange 13 17;'
   pd  nnb =. na db
   pd 'type dot; pensize 4;'
   pd  nnb
   pd 'type line;pensize 1;'
   pd 'color red;'
   pd nna =. na da
   pd 'type dot ; pensize 4;'
   pd nna

   pd 'show'
   pd 'pdf ',yt,PDFWH 
)

PDFWH =: ' 480 360;'
gethll =: 3 : '1 _1 { y{Kh'
gethllmod =: 3 : '0 { y{Kh'


NB.  Functions to construct tables of counts for classified data

NB.  There are two main functions
NB.			Tabulate  var1; .. ;varn   to construct tables
NB.         Tables    tabulation       to list tables

NB.  The key to understanding the function structure is to 
NB.  define the result of a tabulation as a boxed list of 
NB.  the sorted nub of each classification variable, and
NB.  an array of counts whose shape is given by the tally of
NB.  each of the lists.

NB.  
NB.  The main function to construct tables of counts is 
NB.  Tabulate  which has the syntax
NB.          Tabulate  a
NB.  the argument a may have the forms:

NB.		a boxed vector or array with items identifying 
NB.     the categories

NB.     a list of boxed arrays each having the same tally
NB.     with each array giving a distinct method of classifying
NB.     the items
  
NB.     a scalar

NB.  When there are n items in the argument of Tabulate 
NB.  the result consists of n+1 boxed items.  The first n 
NB.  items are the boxed nub of the corresponding item in the
NB.  argument list.  The final item is a count of the number
NB.  of cases for each combination of the arguments in the 
NB.  standard ravel order.

NB.  Example    


NB.  Tabulate is main function to construct counts in table
NB.  Tabulate var1;var2;var3
NB.  Number of arguments is user determined

Tabulate =: 3 : 0
NB.  Define local functions
sn   =. /:~ @ ~.             NB. Sort nub
snb  =. sn &. >              NB. Sort nub boxed items
si   =. (i. &.>)"0           NB. Generate indices

if. -. 32 = 3!:0 y           NB. right argument must be boxed
    do.
'Domain Error in Tabulate - boxed argument required' return. 
    elseif. 1<#y 
    do.
a =. snb"0 y                NB. construct sorted nub of arguments
b =. a si  y                 NB. index all items with sorted nub

anos =. (#@>)"0 a            NB. find base for table calculation
bi   =. anos #. |:>b         NB. calculate cell locations in vector
                             NB. of table locations
a ,< anos TableCount bi      NB. form table values
    elseif. 1=#y
    do.
a1 =: snb y
b1 =: (>a1) i.> y
anos =: (b1  # /. b1) /: ~.> y
(>a1);anos
end.
)  


NB.  In some cases the data may already be in index form
NB.  and in this case the following function is much more 
NB.  efficient.   If multiple tables are required for large
NB.  mapped files, then it is probably best to construct
NB.  an index file for each variable and use the index files
NB.  with the following function.

TabulateI =: 3 : 0
NB.  Function to construct table using indexed values of the 
NB.  variables.  Avoids all of the indexing and nub finding parts of
NB.  Tabulate
imax =. (>./ &.>)"0  y      NB.  find maximal index for each variable
nos  =. >: >imax             NB.  
bi   =. nos #. |:>y         NB.  construct index in table required
a    =. (*/nos)#0
anos =. bi #/.bi             NB.  tally in nub order
binub=. ~. bi
((<@i.)"0 nos) ,<nos $ anos binub}a
)

NB.  Form tally for each cell of a table of shape in left argument
NB.  Right argument is location calculated in function Tabulate, i.e.
NB.  index of eleement in vectorized form of the table

TableCount =: 4 : 0
n      =. (*/x ) $ 0         NB. left argument is shape of table
nuby   =. ~. y
counts =. y # /. y         NB. tally number identical items
n   =. counts nuby}n         NB. merge counts at correct locations
x$n					     NB. reshape
)

NB.  Display Table 

TableList2 =: 3 : 0
}. (<' ') TableList2 y
: 
rows =. <"_1 > 0{y
cols =. <"_1 > 1{y
tab  =. <"0 > 2{y
t =. ((<' '),cols) , rows,.tab
NB. (": x),": t 
(,x) ,  t
)

NB.  Form catalogue of items irrespective of type

Catb =:  [: { [: <" _1 &.>"_1 ] NB.  Box items and form catalogue
Catbt=:  [: Catb }:           NB.  Drop table from Tabulate to form
                              NB.  catalogue of terms in table

Tabheads =: 3 : ' Catb _3}. y'
Tabfront =: 3 : '($ Catb _3}. y)$ < _3 _2{ y'
Tabdata  =: 3 : '{. <"2 >_1{.y'

TableListM =: 3 : 0
a =.ToList"1  (Tabfront y) ,"0 0  Tabdata y
)

ToList =: 3 : '(>0{y),1{y'

NB.  To list a general table without heading information it is now
NB.  possible to use the form
NB.  TableList2 "2  TableListM 

NB.  Function to list the results of tabulate in a form which
NB.  assists the user see exactly what data combination has 
NB.  generated each count

Tables =: 3 : 0
if. 2=#y do.
(,.>0{y) ; (<,.>1{y)
elseif. 3 = # y do.
TableList2 y
elseif. 3 < #y do.
(Tabheads  y) TableList2 "0 1 TableListM y  NB. was rank _1 1
end.
) 


NB.  It is convenient to have a function which elides the 
NB.  intermediate step

Tab =: 3 : 'Tables Tabulate y'



Note  'Coefficient matrices'

Coefficient matrices are formed from means of logarithmic
terms.  This function constructs those means using the
dimension form of term definition.

This function is used in setupmodel to construct the 
estimates of the parameters for the means.  Note all
elements are deviations from the mean, except in the 
case where the left argument is empty.  

To find model parameters level based alternating 
sums are used.  See  functions in  hcoeffmat.ijs.
)


dtmean =: 4 : 0
nd =. $y
if. 0<#x  do. y =. y - mean ,y  end.
n =. #nd
d =. ((i.n) -. x) , x 
n1 =. n - #x 
e =. d |: ^:_1   (d |: nd$0) + "( #x )  mean ^:n1 d|:y
)

dtlast =: 4 : 0
nd =. $y
if. 0<#x  do. y =. y - mean ,y  end.
n =. #nd
d =. ((i.n) -. x) , x 
n1 =. n - #x 
e =. d |: ^:_1   (d |: nd$0) + "( #x )  mean ^:n1 d|:y
)

T  =: 4 : ' ({:^:&x)  y'   NB.  Get tail

