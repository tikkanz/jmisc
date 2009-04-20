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
http://home.online.no/~pjacklam/notes/invnorm/
)

coclass 'pnormal'

NB. =========================================================
NB. utils for Normal distribution

tomusigma=: 4 : 0
  'mu sigma'=. x
  mu + sigma*y
)

tonorm01=: 4 : 0
  'mu sigma'=. x
  (y-mu)%sigma
)

NB. =========================================================
NB. Standard normal distribution

NB.*dnorm01 v Standard normal PDF
dnorm01=: (% %: 2p1) * ^@:(_0.5 * *:)

NB. error function
erf=: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:    NB. A&S 7.1.21 (right)
erfc=: >:@-@erf  NB. complementary error function

Note 'pnorm01'

There are two functions here. pnorm01S is more accurate but
considerably slower than pnorm. pnorm01S uses built in primitives
and is due to Ewart Shaw. It is from from A&S 26.2.29 (solved for P).
pnorm01 is coded from a Chebychev expansion in Abramovitz and Stegum 26.2.17

pnorm01 achieves a maximum absolute error of less than 7.46e_8 over the argument
range (_5,5) and less than 0.2 percent relative error.
)

pnorm01S=: ([: -: 1: + [: erf %&(%:2)) f.

NB.*pnorm01 v Standard normal CDF
pnorm01=: 3 : 0
  t=. %>:0.2316419*|y
  c=. %%:o.2
  z=. c*^--:*:y
  p=. t*_1.821255978+t*1.330274429
  p=. t*0.319381530+t*_0.356563782+t*1.781477937+p
  ((y >0)*1-z*p) + (y <:0)*z*p
)

NB. qnorm01 v Inverse of standard normal CDF
NB.  Right argument may be any numeric array over (0,1)
qnorm01=: 3 : 0
  z=. ,y
  s=. ($z)$0
  
  assert. (0<:z) *. z<:1  NB. y outside meaningful bounds
  
  a=. _3.969683028665376e01 2.209460984245205e02 _2.759285104469687e02
  a=. |.a, 1.383577518672690e02 _3.066479806614716e01 2.506628277459239e00
  
  b=. _5.447609879822406e01 1.615858368580409e02 _1.556989798598866e02
  b=. |.b, 6.680131188771972e01 _1.328068155288572e01 1
  
  c=. _7.784894002430293e_03 _3.223964580411365e_01 _2.400758277161838e00
  c=. |.c, _2.549732539343734e00 4.374664141464968e00 2.938163982698783e00
  
  d=. 7.784695709041462e_03 3.224671290700398e_01 2.445134137142996e00
  d=. |.d, 3.754408661907416e00 1
  NB.   Define break-points.
  p_low=. 0.02425
  p_high=. 1 - p_low
  NB.   Rational approximation for lower region.
  v=. (0 < z) *. z < p_low
  q=. %: _2*^. v#z
  s=. ((c p. q) % d p. q) (I.v)} s
  NB.   Rational approximation for central region.
  v=. (p_low <: z) *. z <: p_high
  q=. (v#z) - 0.5
  r=. *:q
  s=. (q * (a p. r) % b p. r) (I.v)} s
  NB.    Rational approximation for upper region.
  v=. (p_high < z) *. z < 1
  q=. %: _2* ^. 1- v#z
  s=. (-(c p. q) % d p. q) (I.v)} s
  NB.   equal to 0 or 1
  s=. __ (I. z=0)} s
  s=. _ (I. z=1)} s
  
  ($y)$s
)

NB.*qnorm01S v Refinement of qnorm01, slower
NB. only necessary if very high accuracy required
qnorm01S=: 3 : 0
  z=. ,y
  s=. qnorm01 z  
  
  NB. Refinement using Halley's rational method
  v=. (0 < z)*.  z < 1
  q=. v#s                         NB. x
  e=. (v#z) -~ -: erfc  -q% %:2   NB. error
  u=. e * (%:2p1) * ^ (*:q) % 2   NB. f(z)/df(z)
  NB. q=. q - u                   NB. Newton's method
  s=. (q - u% >:q*u%2) (I.v)}s    NB. Halley's method
  ($y)$s
)

NB. runif01 v Uniform random deviates
runif01=: ?@$0:

Note 'Normal Random Deviates'

Brian Schott, Ric Sherlock and others contributed code to the
forum discussion of this function. The version in the
note follows closely the Box-Muller form of Schott
but does use more space than the tacit version
below. We include the explicit form to show the
structure of the steps in the code for those not
experienced with the tacit form.

The right argument is the shape of the result array.

rnorm01=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. runif01 n
  b=. 2* o. runif01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)

NB. BM v Box-Mueller
BM=. ((2 1 o."0 1 (2p1) * runif01) *"1 [: %: _2&*@:^.@:runif01)

NB.*rnorm01 v Random deviates from standard normal
NB. y is: shape of desired result array
rnorm01=: ] $ ,@BM@>.@-:@(*/) f.

NB. =========================================================
NB. General Normal distribution

NB.*dnorm v Normal probability density function
dnorm=: 3 : 0
  dnorm01 y
  :
  dnorm x tonorm01 y
)

NB.*pnormS v Normal cumulative distribution function
NB. slower but more accurate than pnorm
pnormS=: 3 : 0
  pnorm01S y
  :
  pnormS x tonorm01 y
)

NB.*pnorm v Normal cumulative distribution function
NB. faster than pnormS
NB. max absolute error < 7.46e_8 for range (_5,5)
NB. < 0.2 percent relative error.
pnorm=: 3 : 0
  pnorm01 y
  :
  pnorm x tonorm01 y
)

NB.*pnormUT v Upper Tail version of pnorm
pnormUT=: [: -. pnorm

NB.*qnorm v Quantile function for normal distribution
NB. inverse of pnorm
qnorm=: 3 : 0
  qnorm01 y
  :
  x tomusigma qnorm y
)

NB.*qnormS v Quantile function for normal distribution
NB. Slower than qnorm.
NB. Only necessary if very high accuracy required.
qnormS=: 3 : 0
  qnorm01S y
  :
  x tomusigma qnormS y
)

NB.*qnormUT v Upper Tail version of qnorm
qnormUT=: [: - qnorm

NB.*rnorm v Random deviates from normal distribution
rnorm=: 3 : 0
  rnorm01 y
  :
  x tomusigma rnorm y
)

NB. =========================================================
NB. Export to z locale

dnorm_z_=: dnorm_pnormal_
NB. pnormS_z_=: pnormS_pnormal_
pnorm_z_=: pnorm_pnormal_
pnormUT_z_=: pnormUT_pnormal_
NB. qnormS_z_=: qnormS_pnormal_
qnorm_z_=: qnorm_pnormal_
qnormUT_z_=: qnormUT_pnormal_
rnorm_z_=: rnorm_pnormal_
