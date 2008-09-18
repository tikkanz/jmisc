Note 'Normal Distribution'
The following are functions based on the standard normal
distribution.
dnorm the density
pnorm the cumulative distribution function
qnorm the quantile function - inverse of pnorm
rnorm random deviates

The functions dnorm, pnorm and qnorm all take an array
argument. The function rnorm has a single argument, the number of
random deviates required.

These functions use definitions from the J library, Ewart Shaw,
Brian Schott, Ric Sherlock and the programming forum. qnorm uses the
algorithm from P.J. Acklam reported by John Randall.

The present implementation does not provide for any iterative improvement
as noted in http://home.online.no/~pjacklam/notes/invnorm/

)

dnorm=: (% %: 2p1) * ^@:(_0.5 * *:)

erf=: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:    NB. A&S 7.1.21 (right)
pnorm=: [:-:1:+[:erf%&(%:2)                NB. A&S 26.2.29 (solved for P)

erfc=: [: -. erf

NB.*qnorm v Inverse of Normal Distribution Function
qnorm=: 3 : 0
  pr=. ,y
  z=. (#pr)$0  NB. initialise result
  
  a=. _3.969683028665376e01 2.209460984245205e02 _2.759285104469687e02
  a=. |. a, 1.383577518672690e02 _3.066479806614716e01 2.506628277459239e00
  
  b=. _5.447609879822406e01 1.615858368580409e02 _1.556989798598866e02
  b=. |. b, 6.680131188771972e01 _1.328068155288572e01 1
  
  c=. _7.784894002430293e_03 _3.223964580411365e_01 _2.400758277161838e00
  c=. |. c, _2.549732539343734e00 4.374664141464968e00 2.938163982698783e00
  
  d=. 7.784695709041462e_03 3.224671290700398e_01 2.445134137142996e00
  d=. |. d, 3.754408661907416e00 1
  
  NB.   Define break-points.
  p_low=. 0.02425
  p_high=. 1 - p_low
  
  NB. Rational approximations
  type=. pr (> #.@, =)"0 1] 0, p_low, p_high, 1
  NB. 0 8 128 132 192 194 224 225 240
  assert. -. type e. 0 240     NB. less than 0 or greater than 1
  if. +./ msk=. type e. 8 do. NB. equal to 0
    z=. __ (I.msk)} z
  end.
  
  if. +./ msk=. type e. 128 do. NB. lower region
    q=. %: _2*^. msk#pr
    v=. (c p. q) % d p. q
    z=. v (I.msk)} z
  end.
  
  if. +./ msk=. type e. 132 192 194 do. NB. central region
    q=. (msk#pr) - 0.5
    r=. *:q
    v=. q * (a p. r) % b p. r
    z=. v (I.msk)} z
  end.
  
  if. +./ msk=. type e. 224 do. NB. upper region
    q=. %: _2* ^. 1- msk#pr
    v=. -(c p. q) % d p. q
    z=. v (I.msk)} z
  end.
  
  if. +./ msk=. type e. 225 do. NB. equal to 1
    z=. _ (I.msk)} z
  end.
 ($y)$z 
NB.   NB. Refinement using Halley's rational method
NB.   msk=. -. type e. 0 8 225 240
NB.   q=. msk#pr
NB.   v=. msk#z
NB.   e=. 0.5 * q -~ erfc - v % %:2    NB. error
NB.   u=. e * (%:2p1) * ^ (*:v) % 2    NB. f(z)/df(z)
NB. NB.   NB. z(k) = z(k) - u;         NB. Newton's method
NB. NB.   v=. v - u                        NB. Newton's method
NB. NB.   z(k) = z(k) - u./( 1 + z(k).*u/2 );  NB. Halley's method
NB.   v=. v - u% >: v * u % 2          NB. Halley's method
NB.   z=. v (I.msk)} z
)

rand01=: ?@$ 0:

normalrand=: 3 : 0
  (2 o. +: o. rand01 y) * %: - +: ^. rand01 y
)

NB. BM v Box-Mueller
BM=. ((2 1 o."0 1 +:@:o.@:rand01) *"1 [: %: _2&*@:^.@:rand01)
BM=. ((2 1 o."0 1 (2p1) * rand01) *"1 [: %: _2&*@:^.@:rand01)
NB.*normalrand2 v faster and leaner than version above, leaner than rnorm below
normalrand2=: ] $ ,@BM@>.@-:@(*/) f.  NB. was normalrand6b

rnorm=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. rand01 n
  b=. +: o. rand01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)

Note ''
10 ts 'normalrand   numb'
0.024500181 10488320
10 ts 'rnorm numb'
0.017089022 4196608
10 ts 'normalrand2 numb'
0.017133078 2622656
)
