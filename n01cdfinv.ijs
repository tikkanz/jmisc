NB. N(0,1) inverse cdf
NB. Translated from  http://lib.stat.cmu.edu/apstat/241
NB. Ewart Shaw 1-Nov-2006  last modified 6-Nov-2006
NB. http://www.jsoftware.com/jwiki/EwartShaw/N01CdfInv
NB. =========================================================

NB. =========================================================
NB. Utilities (inserted for completeness)
NB.
NB.* vftxt    v  numeric vector from text string
NB.* ratpoly  c  rational polynomial approximation
NB.

vftxt=. 0". ];._2
ratpoly=. 2 : 'm&p. % (1,n)&p.'

NB. =========================================================
NB. ALGORITHM AS241  APPL. STATIST. (1988) VOL. 37, NO. 3
NB.
NB. Produces the normal deviate Z corresponding to a given lower
NB. tail area of P; Z is accurate to about 1 part in 10^16.
NB.

SPLIT1=: 0.425 [ SPLIT2=: 5.0
CONST1=. 0.180625 [ CONST2=. 1.6

NB. Coefficients for P close to 0.5

A=. vftxt 0 : 0
3.3871328727963666080
1.3314166789178437745e2
1.9715909503065514427e3
1.3731693765509461125e4
4.5921953931549871457e4
6.7265770927008700853e4
3.3430575583588128105e4
2.5090809287301226727e3
)

B=. vftxt 0 : 0
4.2313330701600911252e1
6.8718700749205790830e2
5.3941960214247511077e3
2.1213794301586595867e4
3.9307895800092710610e4
2.8729085735721942674e4
5.2264952788528545610e3
)

ratAB=. A ratpoly B

NB. Coefficients for P not close to 0, 0.5 or 1.

C=. vftxt 0 : 0
1.42343711074968357734
4.63033784615654529590
5.76949722146069140550
3.64784832476320460504
1.27045825245236838258
2.41780725177450611770e_1
2.27238449892691845833e_2
7.74545014278341407640e_4
)

D=. vftxt 0 : 0
2.05319162663775882187
1.67638483018380384940
6.89767334985100004550e_1
1.48103976427480074590e_1
1.51986665636164571966e_2
5.47593808499534494600e_4
1.05075007164441684324e_9
)

ratCD=. C ratpoly D

NB. Coefficients for P near 0 or 1.

E=. vftxt 0 : 0
6.65790464350110377720
5.46378491116411436990
1.78482653991729133580
2.96560571828504891230e_1
2.65321895265761230930e_2
1.24266094738807843860e_3
2.71155556874348757815e_5
2.01033439929228813265e_7
)

F=. vftxt 0 : 0
5.99832206555887937690e_1
1.36929880922735805310e_1
1.48753612908506148525e_2
7.86869131145613259100e_4
1.84631831751005468180e_5
1.42151175831644588870e_7
2.04426310338993978564e_15
)

ratEF=. E ratpoly F

qfp=: -&0.5
test1=. SPLIT1 < |@qfp  NB. pretty close to 0 or 1
test2=. >&SPLIT2        NB. really close to 0 or 1
r1fq=. CONST1 - *:
r2fp=: [: %:@:-@:^. ] <. -.

nd1=: (] * ratAB@r1fq)@qfp f.
nd2fr=: (ratCD@-&CONST2)  f.
nd3fr=: (ratEF@-&SPLIT2)  f.

nd=. nd1 ` (*@qfp * (nd2fr`nd3fr @. test2)@r2fp) @. test1

in01=. >&0 * 1 + <&1   NB. test for y in range
n01cdfinv=: (__"0 ` _: `nd @. in01)"0 f.

ndx=: 3 : 0
  s=. ($y)$0
  
  msk=. (SPLIT1 < |@qfp) y  NB. is pretty close to 0 or 1?
  st=. nd1 (-.msk)#y          NB. not close to 0 or 1
  s=. st (I.-.msk)}s
  
  st=. r2fp msk#y             NB. pretty close to 0 or 1
  msk2=. st > SPLIT2          NB. is really close to 0 or 1?
  st2=. nd2fr (-.msk2)#st       NB. not really close to 0 or 1
  st=. st2 (I. -.msk2)}st
  st2=. nd3fr msk2#st           NB. really close to 0 or 1
  st=. st2 (I. msk2)}st
  st=. (st * *@qfp) msk#y
  s=. st (I. msk)}s
)

ndx2=: 3 : 0
  s=. ($y)$0
  msk=. (SPLIT1 < |@qfp) y  NB. is pretty close to 0 or 1?
  s=. (nd1 (-.msk)#y) (I.-.msk)}s  NB. not close to 0 or 1
  st=. r2fp msk#y                  NB. pretty close to 0 or 1
  msk2=. st > SPLIT2        NB. is really close to 0 or 1?
  st=. (nd2fr (-.msk2)#st) (I. -.msk2)}st NB. not really close to 0 or 1
  st=. (nd3fr    msk2 #st)   (I. msk2)}st NB. really close to 0 or 1
  st=. (st * *@qfp) msk#y
  s=. st (I. msk)}s
)


n01cdfinvx=: 3 : 0
  z=. ,y
  tst=. (>&0 * 1 + <&1) z
  z=. tst}__,_,:z  NB. not in-place operation
  n=. ndx (msk=. 2 = tst)#z
  z=. n (I. msk)}z NB. amend values to s
  ($y)$z
)

n01cdfinvx1=: 3 : 0
  z=. ,y
  tst=. (0&= ,. 1&= ,. 1&> *. 0&<) z
  assert. +./"1 tst  NB. y outside meaningful bounds
  tst=. ,I. tst
  z=. tst}__,_,:z  NB. not in-place operation
  n=. ndx (msk=. 2 = tst)#z
  z=. n (I. msk)}z NB. amend values to s
  ($y)$z
)

n01cdfinvx2=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  s=. ($z)$_   NB. initialise result array
  b=. 0 = z
  s=. b}s,:__  NB. in-place operation
  n=. ndx msk#z
  s=. n (I. msk)}s NB. amend values to s
  ($y)$s
)

n01cdfinvx3=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  n=. ndx msk#z
  s=. ($z)$0       NB. initialise result array
  s=. n (I. msk)}s NB. amend values to s
  s=. __ (I. z=0)} s
  s=. _ (I. z=1)} s
  ($y)$s
)

n01cdfinvx3b=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  n=. ndx2 msk#z
  z=. n (I. msk)}z   NB. amend values to z
  ($y)$z
)

n01cdfinvx3a=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  z=. (ndx2 msk#z) (I. msk)}z NB. amend values to z
  ($y)$z
)

n01cdfinvx3c=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  z=. (ndx msk#z) (I. msk)}z NB. amend values to z
  ($y)$z
)

n01cdfinvx3d=: 3 : 0
  z=. ,y
  msk=. (0&< *. 1&>) z     NB. between 0 & 1
  assert. msk +. z e. 0 1  NB. y outside meaningful bounds
  z=. __ (I. z=0)} z
  z=. _ (I. z=1)} z
  n=. ndx msk#z
  z=. n (I. msk)}z NB. amend values to z
  ($y)$z
)