NB. built from project: user\projects\reg\reg

NB.  This script is Copyright, MasterWork Software.  1997.
NB.  All rights reserved.


NB.  Some essential stats for Reg functions

NObs    =: # : (+/ @([+((0&*)@])))
NObs1   =: <:@NObs

Mean    =: (+/%#) : ((+/@([*]))%([NObs]))
Dev     =: ]-"_1 _ Mean
Relative=: ]%"_1 _ +/
Sum     =: (+/) : (+/@([*]))
Diff    =: (}.-}:) : ( ([}.]) - (([:-[)}.]))

NB.  Matrix Utilities for regression and other statistics

NB.  Utilities

NB.  Convert vectors into columns of a matrix
NB.  All must be of same length 
NB.  ToMatrix 'x x1 x2 x3 x4'
NB.  Explicit form ToMatrix  ". _2}. , (>,. ;: y.),"1 _ ',.'

ToMatrix =: [: ". _2: }. [: , ([: > [: ,. [: ;: ]) ,"1 _ ',.'"_

NB.  Write columns of matrix to set of variables
NB.  'x x1 x2 x3 x4' FromMatrix X
NB.  'x x1 x2 x3 x4' FromMatrix i. 10 5

FromMatrix =: 3 : 0
:
'' [ ". '''', x ,'''','=: |: y'
)

QR         =: 128!:0
InverseT   =: 128!:1
MatDiagonal=:  (<0 1) & |:



NB.  REGRESSION     Version 0.01

NB.  This script is Copyright, MasterWork Software.  1997,1999.
NB.  All rights reserved.

NB.  The script  reg2.js contains functions to generate 
NB.  predictions, forecasts, and linear combinations 
NB.  of the coefficients, together with confidence intervals
NB.  for them.

NB.  This script is used in conjunction with the scripts
NB.      reg0.js      which loads all of the scripts
NB.      reg2.js      which contains further fucntions
NB.      input1.js    for numeric data input
NB.      bstat1.js    some statistical utility functions from
NB.                   the basic statistics package being prepared
NB.      distfns1.js  some functions to evaluate essential
NB.                   distribution functions for regression
NB.      utils1.js    a few utilities

NB.  The following notation is used for data elements
NB.  y    a vector of dependent variable values
NB.  X    a vector or matrix of independent variable values
NB.  w    a vector of weights for the elements of y and X
NB.  r    the result of a regression
NB.  i    indices of coefficients required
NB.  loc  index of the lagged dependent variable in the 
NB.       matrix  X (required for Durbin's h statistic)

NB.  The main functions

NB.  y RegN X         numerical core for regression
NB.  y Reg X          simple and multiple regression, with a constant
NB.                   which is not included in X
NB.  'y' Reg 'x x1'   simple and multiple regression using variable names               
NB.  y Reg0 X         regression through origin (variable names also permitted)
NB.                   X must not have a constant column for some derived 
NB.                   statistics to be treated correctly 


NB.  Subsidiary functions for special cases, require numeric arguments

NB.  y RegF X         fastest program,  short output, does not accept variable names
NB.  y ProjectOn X    equivalent to  Fit y Reg0 X but only projection
NB.  y ProjectOff X   residuals of Y orthogonal to column space of X
NB.  y ProjectOnOff X equivalent to  (Fit,.Residuals) r but numerically better
NB.  OLS X,.y         regression, but with both variables in single argument
NB.  w OLS X,.y       weighted regression,  weights w

NB.  The following extract part of the regression result, they are listed
NB.  also as part of a group of functions below when appropriate.
 
NB.  Fit r            fitted values for regression
NB.  Residuals r      residuals for regression
NB.  DepVar r         DepVar =. Fit+Residuals
NB.  Hi r             diagonals of the Prediction Matrix
NB.  Coefficients r   the estimated coefficients
NB.  XTXInv r         the matrix  (inverse X'X)
NB.  MeansReg r       Means of depvar and indepvars, including constant
NB.  RegFunction r    Function name and variables in regression call
NB.  NObsReg r        number of observations in data set
NB.  NCoefficients r  number of coefficients
NB.  DFReg r          degrees of freedom of regression residuals   

NB.  Functions to analyse the coefficients

NB.  [i] Coefficients r        the regression coefficients [for indices i]
NB.  [i] CoefficientsSE r      the standard errors of the coefficients [for i]
NB.  [i] Coefficientst r       the t statistics of the coefficients [for i]
NB.  [i] Coefficientsbt r      the value and the t statistic for the 
NB.                            coefficients [for i]
NB.  [i] CoefficientsCovar r   the covariance matrix of the coefficients [for i]
NB.  XTXInv r                  inverse of (X'X) from regression results
NB.                            with submatrix specified by [i] if required

NB.  X0 Predictions r          use coefficients to find predicted values at X0

NB.  X RegHC r        regression result adjusted to have an heteroscedasticity 
NB.                   consistent covariance estimator.


NB.  Functions to provide various forms of output for the regression

NB.  [f] RegList r    standard regression output   if  from 'Reg0' then
NB.                   standard regression output adjusted for no constant
NB.                   left argument permits formatting the coefficient and 
NB.                   anova tables.  Standard J formats w.d  are used and 
NB.                   _w.d for exponential form and (d+1) digits.

NB.  RegEquation r    A simple equation form suitable for publication.
NB.                   Requires output from the 'y' Reg 'x1 x2 w'  form of
NB.                   function call.  
NB.  RegPublish r1;r2;..;rn  layout of multiple equations for publication
NB.                   variables in rows,  equations in columns(incomplete)      
NB.                   Requires the 'y' Reg 'x1 z1 w'  form for generating
NB.                   the regression results used.  


NB.  InfluenceTable r returns table of 
NB.  InfluenceList r  listing of influence statistics

NB.  Criteria r       calculates a range of selection criteria for regressions
NB.  CriteriaList r   lists criteria
NB.  MSEReg r         the mean squared error
NB.  PRESS r          the sum of squares of PRESS residuals
NB.  RSq  r           the squared correlation coefficient

NB.  Hi r             the hat statistics for each observation
NB.  HatMatrix X      prediction matrix for X  (Note add constant if required)
NB.  SMinusI r        the SE for PRESS residuals
NB.  PRESSResiduals r the prediction error sum of squared residuals
NB.  StudentisedResiduals r  the standardised PRESSResiduals
NB.  RSTUDENT r       the externally standardised residuals. Have t distn.
NB.  CooksD  r        Cook's D statistic
NB.  DFFITS r         the BKW diagnostic statistic
NB.  X DFBETA r       the BKW measure of influence of coefficients



NB.  r1 Cp r2         the Mallows statistic with r1 the more general model
NB.  r1 Wald r2       the Wald statistic for the restrictions imposed on r1
NB.  r1 WaldUR r2     the same as  Wald



NB.  DW r               the Durbin-Watson statistic
NB.  loc Durbinsh r     Durbins h statistic when loc is index of y(t-1) in X
NB.  X DurbinshReg r    Durbin's regression test result is coeff and t-statistic

NB.  Utilities
NB.  r RegQ fnnames     returns true if name of regression function generating r
NB.                     is included in the list  fnnames
NB.  ToMatrix varnames  generates a data matrix with variables in columns.
NB.  QR X               QR decomposition of X.  Result is boxed  Q  R
NB.  InverseT R         Inverse of the triangular matrix R from QR


NB.  

NB.  Regression program using QR decomposition
NB.  See e.g. R Davidson and JG MacKinnon,  Estimation and Inference in 
NB.  Econometrics.  Oxford.  1993.  p.29-31.


NB.  RegN is the basic numerical procedure based on the QR algorithm
NB.  This is slower than the usual formation of cross product matrices
NB.  but is much less likely to give serious numerical analysis error
NB.  when the variables are nearly collinear.

NB.  In Version 0.01 the left argument is deliberately restricted to be
NB.  a vector.  With removal of a comma in the line defining q below,
NB.  and the second line in the dyadic component of RegN,
NB.  this restriction is removed.  Many other functions calling regression 
NB.  results do not function correctly if this restriction is removed, 
NB.  and they are applied to the result of RegN

RegN =:   3 : 0
:
if. (0=$$y) do. y1 =. (#x)#y  else. y1 =. y end.
if. ((>./$y1)<#x) +. ({.$y1)~:#x do. 'Domain Error in Reg 5' return. end.
if. 1 = MatrixQ x do. if. (1{$x)>1 do. 'Domain Error in Reg 6' return. end. end.
if. ({.(1=$$y1) +. 0=$$y1   ) *. *./({.,y1)=y1 do. RegConst x return. end.
qr=. 128!:0 y1
q=. >0{qr
r=. >1{qr
rinv=. 128!:1  r
g=. (|:q) +/ . * ,x
b=. rinv +/ . * g
yest=. q +/ . * g
yres=. x - yest
xtxinv=. rinv +/ . * |: rinv
hi=. +/"1 *:q
(yest,.yres,.hi);b;xtxinv;(Mean x,.y1) 
)

NB.  RegConst is case where fitting a constant

RegConst =: 3 : 0
(((#y)#Mean y),.(y-Mean y),.(#y)#%#y);(Mean y);(+/*: y-Mean y); y 
)


NB.  New Regression Functions

NB.  The result consists of empty objects if there is a domain error in the rank of the arguments
NB.  It returns 4 empty boxes and a descriptor of the call if the error occurs in RegN
NB.  which is the core numerical function. this includes the case where dependent and independent
NB.  variables do not have the same length or the independent variables form a singular matrix.  
NB.  The objective of this function is to trap all errors
NB.  in a regression call.  An invalid result will always have an empty boxed object
NB.  in its first position.

NB.  For regression with a constant term as default use  Reg

Reg  =: 4 : 0
if. LiteralQ x. do.   if.   1 ~: {. $ ;: x. do. 5$a: return. NB. y not vec 
                      end.
                      yz =. ". x. 
                else. yz =. x.
end.            NB.  sets up dependent variable

if. (LiteralQ x.) *. LiteralQ y.  do.    yxlab =. <'Reg ',x.,' ',y.                                   
                                  else.  yxlab =. <'Reg '
end.            NB. sets up description when available

if. 1 ~: $$yz  do. 5$a: return.   NB.  Checks dependent variable is vector
end.
 
if. LiteralQ y. do.  nx =. $;: y.
                if.  nx= 0 do. xz =. (#y)#1
                          elseif. nx  = 1 do. xz =. 1,.". y.                     
                          elseif. nx >: 2 do. 
                                  try. xz=. 1,.ToMatrix y. catch. 5$a: return.
                                  end. 
                end.
                else.
                select.     <./3,nx =. $$y.
                     case. 0 do. xz =. (#y)#1    NB. empty - constant only
                     case. 1 do. xz =. 1,.y.     NB. vector, add constant
                     case. 2 do. xz =. 1,.y.     NB. matrix, add constant
                     case. 3 do. 5$a: return.    NB. array - invalid argument
                end.
end.               .
try. (yz RegN xz),yxlab catch. 5$a: return. end.
)

NB.  For regression through the origin use  Reg0
Reg0  =: 4 : 0
if. LiteralQ x. do.   if.   1 ~: {. $ ;: x. do. 5$a: return. NB. y not vec 
                      end.
                      yz =. ". x. 
                else. yz =. x.
end.            NB.  sets up dependent variable

if. (LiteralQ x.) *. LiteralQ y.  do.    yxlab =. <'Reg0 ',x.,' ',y.                                   
                                  else.  yxlab =. <'Reg0'
end.            NB. sets up description when available

if. 1 ~: $$yz  do. 5$a: return.   NB.  Checks dependent variable is vector
end.
 
if. LiteralQ y. do.  nx =. $;: y.
                if.  nx= 0 do.    5$a: return.
                          elseif. nx  = 1 do. xz =. ". y.                     
                          elseif. nx >: 2 do. 
                                  try. xz=. ToMatrix y. catch. 5$a: return.
                                  end. 
                end.
                else.
                select.     <./3,nx =. $$y.
                     case. 0 do. 5$a: return.    NB. empty - invalid case
                     case. 1 do. xz =. y.        NB. vector, no constant
                     case. 2 do. xz =. y.        NB. matrix, no   constant
                     case. 3 do. 5$a: return.    NB. array - invalid argument
                end.
end.               .
try. (yz RegN xz),yxlab catch. 5$a: return. end.
)

ToVec =. 3 : ', '' '',.> y.'


NB.  RegF will execute faster but is subject to numerical
NB.  problems when data is close to collinear or poorly scaled

RegF  =: 3 : 0
:
x=. 1,.y.
y=. x.
xtxinv =. %. (|: x) +/ . * x
b=. xtxinv +/ . * (|:x) +/ . * y
yest=. x +/ . * b
yres=. y - yest
(yest,.yres) ; b ; xtxinv; 0 ;'RegF'
)


ProjectOn    =: 3 : 0
:
qr=. 128!:0 y.
q=. >0{qr
q +/ . * (|:q) +/ . * x.
)

ProjectOff  =: [-ProjectOn
ProjectOnOff =: [(],.[-])ProjectOn

OLS  =: 3 : 0
(,_1{."1 y.) Reg }:"1 y.
:
OLS ((#x.)* Relative %:x.)*y.
)

OLS0  =: 3 : 0
(_1{."1 y.) Reg0 }:"1 y.
:
OLS0 ((#x.)* Relative %:x.)*y.
)

NB.  Sample data for testing   From Davidson and McKinnon
y   =: 2.88 3.62 5.64 3.43 3.21 4.49 4.5 4.28 2.98 5.57
x   =: 1.51 2.33 3.57 2.12 1.54 1.71 2.68 2.25 1.32 2.80
x1  =: 1.51 2.33 3.57 2.12 1.54 1.71 7.68 2.25 1.32 2.80
X   =: 1,.x
X1  =: 1,.x1

Fit           =: [: {."1 [: > ([:{.])  
Residuals     =: 1: {"1 [: > ([:{.])
DepVar        =: Fit+Residuals
XTXInv        =: (>@(2:{])) :  ([{[{"1[:XTXInv])   NB.  XTXInv r
MeansReg      =: >@(3:{])
RegFunction   =: >@(4:{])
NObsReg       =: #@Fit
NCoefficients =: #@(Coefficients@])
DFReg         =: NObsReg - NCoefficients
MSEReg        =: ([: +/ [: *: Residuals) % DFReg

Coefficients      =: ([:> 1:{]) : ([{[: > 1:{])
CoefficientsSE1   =: [: %: MSEReg * [: MatDiagonal [: > 2: { ]
CoefficientsSE    =: ( CoefficientsSE1)  :  ([{CoefficientsSE1)
Coefficientst     =:  Coefficients%CoefficientsSE
Coefficientsbt    =: Coefficients,.Coefficients%CoefficientsSE
CoefficientsCovar =: (MSEReg * XTXInv) :  (([: MSEReg ]) * [ { [ {"1 [: XTXInv ])


NB.  X0 Predictions r
NB.  X0 must contain constant term if it is required

PredictionsAdj =: 3 : 0
:
if. 1 = x. RegQ 'Reg0' do. x =. y. end.
if. (1 = #Coefficients x.) *. 1 = x. RegQ 'Reg0' 
    do.
        ({.Coefficients x.) * y.  
    return. 
end. 
if. 1 = x. RegQ 'Reg RegF'
    do. 
    if. (($$y.)<:1) *. (<: # Coefficients x.) = #y. do. x =. 1,y. 
elseif. (2 = # Coefficients x.) *. (#y. )>1     do. x =. 1,.y.
elseif. (2 < # Coefficients x.) *. (#y. )>1     do. x =. 1,.y.
    end.
end.
x
)

Predictions =: [(+/ . * )[:>1:{]

NB.  r PredictionsCI X;a
Comment =: 0 : 0
PredictionsCI  =. 3 : 0
:
xtxinv =. >2{x.
b =. >1{x.
n =. # Fit x.
p =. # b
if. (BoxedQ y.) *. 2 = # y.  
    do.  X =. >0{y.
         a =. 1 - -: 1 - > 1{y.
    else. X =. y.
          a =. 0.975
    end.
X =. x. PredictionsAdj X
y0 =. X +/ . * b
tval =. (n-#b) TInverse a
s =. %: MSEReg x.
v0 =.  X (+/ . *)"1 _ xtxinv (+/ . *) "_ 1 X
v1 =. 1+v0
v0t =. %: v0
v1t =. %: v1 
3 1 0 2 4{"1 y0,. y0 + ((tval*s*v0t) */ _1 1),. (tval*s*v1t) */ _1 1
)

NB.  White's heteroscadasticity consistent estimator of the 
NB.  covariance of the estimates.  Replaces the usual estimator in the
NB.  regression result.

RegHC  =: 3 : 0
:      
r =. y. 
X =. x.
NB.  if. (-. r RegQ 'Reg0') do. X =. 1,.X end.
xtxinv =. >2{r
u =. Residuals r
n=. #u
p=. #Coefficients r
i =. 0
s =. (p,p)$0
while. i<n do.
      s =. s + (*:i{u)*xx */xx =. i{X
	  i =. >:i
           end.
newcovar =. xtxinv +/ . * s +/ . * xtxinv
(<newcovar) 2}r
)
    

NB.   next group generate a simple report from the regression calculation
   Regh1=:1 47$'  Var         Coeff         SE(b)          t(b)'
   Regh2=:1 55$'Source     d.f.        SumSq         MeanSq           F'
   Regh3=: 3 11$'Regression Residuals  Total        '
   Regh4=: 1 70$'           Rsq        RBarsq     Rsq(Unc)     S.E.Resid       DW stat '

NB.  main calculations using regression output

NB.  Analysis for case with regression through origin

RegList0  =: 3 : 0
kconst =. 0              NB.  Adjustment for df if through origin
if. (# ;: >4{y.) >1 do. nam =. 1 else. nam =. 0 end.
varnames =. ,:'Constant'
reg0 =. y. RegQ 'Reg0'
if. (nam=0) +. reg0=1 do. varnames =. 0 5$' ' end.
if.  reg0 
   do.  kconst =. 1
   end.
if.  nam=1  do.  varnames =. ,. varnames,2}. ,. >,. ;: >4{y.  end.
ydat=. >0{y.
yres=. 1{"1 ydat 
yest=. 0{"1 ydat
ess=. +/ *: yres
devy =. yres+ Dev yest
if. reg0 
    do. ssr=. +/ *:  yest
        sst =. +/*: Dev yest+yres
    else.  ssr =. +/ *: Dev yest
        sst =. ess+ssr
    end.
b=. ,>1{y.
n=. #ydat
k=. #b
errms=. ess%n-k
regms=. ssr%kconst+k-1
xtxinv=. >2{y.
xtxdiag=. (,(k,k)$1,k#0)#,xtxinv
seb=. %: errms * xtxdiag
t=. b%seb
coefftable=. |:(i.k),b,seb,:t
anovatable=. ((n-k),ess,errms,0),:(kconst+<:n),(ess+ssr)
anovatable=. ((kconst + <:k),ssr,regms,regms%errms),anovatable
rsqc=. 1 - ess % sst
rsqu=. (+/*: yest)% +/*: yest+yres
rbarsq=. 1 - errms%(sst)%<:n
seres=. %: errms
dw=. (+/ *: (}.-}:) yres) % (+/ *: yres)
summary=. ,. rsqc, rbarsq,rsqu, seres,dw
coefftable;anovatable;summary;varnames
)

RegList =: 3 : 0
14.5 RegList y.
:  
y =.  RegList0 y.
if. (-. *./' '=,>3{y )>0 do. r1 =. Regh1, (>3{y) ,. x.": 1}."1 >0{y
                else. r1=. Regh1,(1 3#5,x.)": >0{y
                end.
r2=. Regh2, Regh3,"1 (1 3#5,x. )": >1{y
r4=. Regh4,14.5":  ,>2{y
bl=. 1 10$' '
r1,bl,r2,bl,r4,' '
)

NB.  format  Reg results as equation

RegEquation =: 3 : 0
nam =.,.  > ,. ;: >4{y.
depnam =. 1{nam
indepnam =. 2}.nam
if. -. 1 = y. RegQ 'Reg0' do. indepnam =. (,:' '),indepnam end.
nam  =. depnam,indepnam
bt   =.  Coefficientsbt y.
b    =. 0{"1 bt
fb   =. ": ,. |b
t    =. 1{"1 bt
ft   =. (((_1{. $fb)+0.2)   ": ,.t)  
ft   =.  rplc&( '_' ; '-') "1 ft
p    =. #b
sb   =. *b
sign =. ,. ' =',((_1 0 1)i. 1}.sb){ '- +'
r1   =. sign,.(' ' ,. ' ',' ',.((fb),.' '),.' '),. nam
r2   =. ' ',.(' ' ,. ' ','(',.((ft),.')'),.' '),.($nam)$' '
NB.  Calculate summary statistics
res  =. Residuals y.
fit  =. Fit y.
n    =. # res
rsq  =. 1 - (ssres =. +/ *: res) % +/ *: Dev res+fit
rbarsq =. 1 - (1-rsq)* (n-1)%n-p
sereg  =. %: ssres%n-p
dw     =. (+/ *: Diff res) % ssres
NB.  add text and summary statistics
fin  =. ' RSq = ',(10.5":rsq),'  RBarSq = ',(10.5":rbarsq),' Std Error Reg = '
fin  =. fin ,(12.5 ": sereg), '  DW = ',5.2": dw
fin  =. ' ', fin ,: ' Bracketed terms are t-statistics'
((,r1) ,: ,r2) , fin,' '
)

DepVarN   =: ({.@}.@;:) @ RegFunction
IVN1      =: (2:}.;:)@RegFunction
 
IndepVarN =: 3 : 0
ivn =. IVN1 y.
if. y. RegQ 'Reg ' do. (<'Constant'),ivn end.
)

ForItems =: "_1
NubIV1    =: [: ~. [: , [: IndepVarN ForItems ]
NubIV     =: 3 : '(NubIV1 y.) -. a:'
Indices   =: NubIV i. ([:IndepVarN ForItems ])
UseIV     =: [: -. ([:,Indices) = ([:{.[:$NubIV)


NB.  Rewrite the following to increase efficiency later
LocIV =: 3 : 0
i =. Indices y.
locs =. (,i),.(1{$i)#i.#i
)

Fmtcbt =: 3 : 0
v1 =. ": 0{y.
v2 =. '(',(":1{y.),')'
v1,:v2
)


NB.  RegEquations is ambivalent

NB.  In monadic mode requires a matrix of regression results as right argument
NB.  In dyadic mode requires a matrix of boxed elements as left argument

RegEquations =: 3 :  0
a: RegEquations y.
:
notempty =: */"1 -. y. = a:
x =: a:,notempty#x.
y =. notempty#y.
locs =. LocIV y
use =. UseIV y
cbt =. ,/Coefficientsbt "1 y
t =. (< "1 use#locs) ,. (<@Fmtcbt) "1 use#cbt
out =. ((# NubIV y),# y)$ a:
r =. ((<'Dep Var'),NubIV y) ,.(DepVarN"1  y),(1{"1 t) (0{"1 t) } out
m0 =. 'RSquared' ; (<@RSq) "1 y
m1 =. 'MSE' ; (<@MSEReg) "1 y
m2 =. 'NObs' ; (<@NObsReg) "1 y
m3 =. 'NCoefficients' ; (<@NCoefficients) "1 y
m4 =. 'DW Statistic' ; (<@DW)"1 y
m  =: r,m0,m1,m2,m3,:m4
if. (0=$$x.) +. 2<$$x do. m  return.
            elseif. 2=$$x do. (|:x),m  return.
            elseif. 1 = $$x do. x,m  return.

end.
)




RegQ =: 3 : 0       NB.  r RegQ  fnlist    e.g.   r RegQ 'RegF Reg '
:
nam =. {. ;: >4{x.
nam e. ;: y.
)
               
NB.  Influence table lists
NB.  Obs no,  y(t), yest(t), u(t), hi, (u*hi)%(1-hi)
NB.  (u*hi)%(1-hi) is effect on i'th resid of omitting i'th observation

InfluenceTable =: 3 : 0
NB.  regf =. *./ 'RegF' = >4{y.
regf =. y. RegQ 'RegF'
if. regf do.  'Domain Error in InfluenceTable' return. end.
   a    =. >0{y.
   yest =. 0{"1 a
   yres =. 1{"1 a
   hi   =. 2{"1 a
   k    =. #>1{y.
   n    =. #yest
   ssres=. +/ *: yres
   s    =. %: ssres % n-k 
   si   =. %: (ssres - (*:yres)%1-hi)%(n-k+1)
   stures=. yres%si* %: -. hi
   (>:i.$yest),.(yest+yres),.yest,. yres ,. hi,. (yres%s* %: 1-hi),. stures
)

NB.  InfluenceList
InfluenceList0 =: 3 : 0
regf =. r RegQ 'RegF'
if. regf do.  'Domain Error in InfluenceList' return. end.
d1=. 'Obs   y(t)   yest(t)   uest(t)    h(t)   uest(t)%(s*Sqrt(1-hi))   RSTUDENT'
)

InfluenceList =: 3 : 0
d1 =. InfluenceList0 y.
d1,' ',": InfluenceTable y.
:
d1 =. InfluenceList0 y.
d1,' ',x.": InfluenceTable y.
)

NB.  Regression selection criteria

NB.  Information measures with penalty functions

Criteria =: 3 : 0
    regf =. y. RegQ 'RegF'
    y=. >0{y.
    n=. #y
    k=. #>1{y.
    u=. 1{"1 y
    if. -. regf
        do.  hi=. 2{"1 y
        else.  hi =. 0
        end.
    sn=. (+/ *: u)%n
    aic=. ^+:k%n
    afpe=. n(+%-)k
    gcv=. %*:-.k%n
    hq=. (^.n)^+:k%n
        rice=. %(-. +:k%n)
    schwartz=. n^k%n
    shibata=. (n++:k)%n
if. -. regf
        do.  press=. (+/ *: u%-.hi)%n
        else.  press =. 0
        end.
    (sn*aic,afpe,gcv,hq,rice,schwartz,shibata),press
)

    RC=: 0 : 0
Akaike's AIC
Akaike's FPE
Generalised Cross Validation
Hannan and Quinn
Rice
Schwarz  BIC
Shibata
Mean Prediction Error Sum Sq
)

RC     =: >;._2 RC

CriteriaList =: 3 : 0
RC,.' ',.' ',.":,. Criteria y.
)

PRESS  =: [: +/ [: *: [: PRESSResiduals ]
RSq    =: [:-.(([:+/*:"_)@Residuals)%(([:+/ *:"_)@Dev@(Fit+Residuals))


NB.  Influence diagnostics

Hi     =:  2: {"1 [: > ({.@])
HatMatrix =: (] (+/ . *) |:) @ (>@{.@QR)

SMinusI =: 3 : 0
n =. #usq =. *: u =. Residuals y.
p =. # Coefficients y.
mhi =. -. Hi y.
%: ((+/usq) - usq%mhi) % n-p+1
)

PRESSResiduals =: Residuals % 1:-Hi
StudentisedResiduals =: Residuals%[:Sqrt MSEReg * [: -. Hi

NB.  RStudent duplicates much of calculation of SMinusI  for efficiency

RSTUDENT  =: 3 : 0
n =. # usq =. *: u =. Residuals y.
p =. # Coefficients y.
mhi =. -. Hi y.
sminusi =. %: ((+/,usq) - usq%mhi) % n - (p+1)
u%sminusi*%:mhi
:
RStudent y.
)

CooksD  =: ((]%-.@])@Hi)*(Sq @ StudentisedResiduals) %[:#(Coefficients@])
DFFITS  =:  RStudent * [: Sqrt (]%(-.@]))@Hi

DFBETAS =: 3 : 0
:
X =. x.
R =. (XTXInv y.) +/ . * |: X
R =. R % %:  +/"1 R*R 
(|:R)*(RStudent y.)% %: -. Hi y.
)

COVRATIO =: ((([: Sq SMinusI)%MSEReg)^NCoefficients) * [: % [: -. Hi




NB. Functions for Comparing Regressions with additional regressors 

Cp =: 3 : 0         NB.  Mallows Cp
:
p1 =. # Coefficients x.
p2 =. # Coefficients y.
n1 =. # u1 =. Residuals x.
n2 =. # u2 =. Residuals y.
if. (-. n1=n2) +. p2>p1  do.
     'Domain Error in Cp' return. end.
s1 =. (+/ *: u1) % n1-p1
s2 =. (+/ *: u2) % n2-p2
(p2 + (n2-p2) * (s2 - s1) % s1) 
)

Wald =: WaldUR =: 3 : 0
:
ssq =. [:+/*:
u1 =. 1{"1 >0{x.
n1 =. #u1
k1 =. #>1{x.
s1 =. ssq u1
u2 =. 1{"1 >0{y.
n2 =. #u2
k2 =. #>1{y.
s2 =. ssq u2
if. n1 ~: n2 do. 'Domain error in WaldRU' return. end.
(((s2-s1)%k1-k2)%s1%n1-k1),(k1-k2),n1-k1
)




NB.  Functions looking at serial structure of residuals

DW =: ([:+/([:*:([:Diff Residuals)))%([:+/([:*:Residuals))

NB.  If X contains lagged values of y then use Durbinsh
NB.  See  JHGLL  1982 Intro. to the theory and practice of Econometrics  Chap 15.5.3
NB.  loc Durbinsh r   where   loc is index of y(t-1)

Durbinsh =: 3 : 0
:
u =. Residuals y.
rho =. 1 - -:DW y.
T =. #u
Vb1 =. *: x. CoefficientsSE y.
if. (T*Vb1)>1 do.  'Use Regression method  DurbinshReg' return. end.
rho * %: T%1 - T*Vb1
)

NB.  for Durbin's h Reg  result is  coefficient, t-statistic

DurbinshReg =: 3 : 0
:
NB.  X DurbinshReg r
X =. x.
u =. Residuals y.
r =. (1}.u) Reg0 (_1}.u),.1}.X
0 Coefficientsbt r
) 


NB.  Utilities

ToMatrix   =: [: ". _2: }. [: , ([: > [: ,. [: ;: ]) ,"1 _ ',.'"_
NB.  Explicit form ToMatrix  ". _2}. , (>,. ;: y.),"1 _ ',.'
QR         =: 128!:0
InverseT   =: 128!:1



NB.  Script utilities from ISI scripts

NB.  a utility to replace characters - from ISI script

rplc=: 3 : 0
NB. replace characters in text string
NB. syntax: text rplc old;new
:
'o n'=. ,&.>y.
l=. #o
c=. o E. x=. ,x.
if. (0<l) *: 1 e. c do. x return. end.
bx=. #i.@#
c=. bx c
while. 0 e. d=. 1,<:/\(#o)<:(}.-}:)c
do. c=. d#c end.
p=. (i.#x) e. 0,c
x=. p <;.1 x
b=. o&-:@(l&$) &> x
f=. n&,@(l&}.) &.>
;(f b#x) (bx b) }x
)

NB.  Test Functions

BooleanQ  =: [:*./,e. 0 1 "_ 1   NB.  compare isboolean omits final 1
LiteralQ  =: 3!:0 = 2:
IntegerQ  =: (-:<.) :: 0:
FloatingQ =: 3!:0 = 8:
RealQ     =: (-: +) :: 0:
ComplexQ  =: -.@RealQ f.
BoxedQ    =: 0:<L.

ScalarQ   =: 0:=[:#$
VectorQ   =: 1:=[:#$
MatrixQ   =: 2:=[:#$

inrange=: ([: *./ (>: {.) , (<: {:))~
isbalanced=: [: (-: +/\. + 0: >. +/\) [: -/ =/
isboolean=: [: *./ , e. 0 1"_
iscounter=: -: |@<.