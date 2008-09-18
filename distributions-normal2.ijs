Note 'Normal Distribution'
The following are functions based on the standard normal 
distribution.
	dnorm   the density
	pnorm	the cumulative distribution function
	qnorm   the quantile function - inverse of pnorm
    rnorm   random deviates

The functions  dnorm, pnorm and qnorm all take an array
argument.  The function rnorm has a single argument, the number of 
random deviates required.

These functions use definitions from the J library, Ewart Shaw,
Brian Schott, Ric Sherlock and the programming forum. qnorm uses the
algorithm from P.J. Acklam reported by John Randall.

The present implementation does not provide for any iterative improvement
as noted in  http://home.online.no/~pjacklam/notes/invnorm/ but 
that is only necessary if very high accuracy is required.

)

NB. Not sure if need to retain this? RGS 
dnorm =: 3 : 0
(% %:2p1) * ^ - -: *:y
)

tomusigma =: 4 : 0
'mu sigma' =. x
mu + sigma*y
)

tostandardnormal =: 4 : 0
'mu sigma' =. x
(y-mu)%sigma
)

dnorm =: 3 : 0
((% %: 2p1) * ^@:(_0.5 * *:))y
:
dnorm  x tostandardnormal y 
)
 
erf   =: (*&(%:4p_1)%^@:*:)*[:1 H. 1.5*:    NB. A&S 7.1.21 (right)

NB.  pnorm from  A&S 26.2.29 (solved for P)
pnorm  =: 3 : 0
([:-:1:+[:erf%&(%:2)) y
:
pnorm x tostandardnormal y
)

NB.*pnormUT v Upper Tail version of pnorm
pnormUT=: [: -. pnorm

NB.  Inverse of Normal Distribution Function
NB.  Right argument may be any numeric array over (0,1)

qnorm =: 3 : 0
z    =. ,y
assert. (0<:z) *. z<:1  NB. y outside meaningful bounds 

a =. _3.969683028665376e01 2.209460984245205e02 _2.759285104469687e02
a =. |.a, 1.383577518672690e02 _3.066479806614716e01 2.506628277459239e00

b =. _5.447609879822406e01 1.615858368580409e02 _1.556989798598866e02
b =. |.b, 6.680131188771972e01 _1.328068155288572e01 1

c =. _7.784894002430293e_03 _3.223964580411365e_01 _2.400758277161838e00
c =. |.c, _2.549732539343734e00 4.374664141464968e00 2.938163982698783e00

d =. 7.784695709041462e_03 3.224671290700398e_01 2.445134137142996e00
d =. |.d,  3.754408661907416e00 1
NB.   Define break-points.
p_low  =. 0.02425
p_high =. 1 - p_low
NB.   Rational approximation for lower region.
v1 =. (0 < z) *. z < p_low 
q1 =. %: _2*^. v1#z                NB.RGS _2 vs -2
s1 =.  (c p. q1) %   d p. q1
NB.   Rational approximation for central region.
v2 =. (p_low <: z) *. z <: p_high
q2 =. (v2 # z) - 0.5
r2 =. *:q2                         NB.RGS *:q2 vs q2*q2
s2 =. q2 * (a p. r2) %   b p. r2
NB.    Rational approximation for upper region.
v3 =.  (p_high < z) *. z < 1 
q3 =. %: _2* ^. 1- v3#z             NB.RGS _2 vs -2
s3 =.  -(c p. q3) %   d p. q3
NB.   equal to 0
v4 =. z = 0
s4 =. __
NB.   equal to 1
v5 =. z = 1
s5 =. _
NB.     Assemble results
s  =. ($z)$0
s  =. s4 (I.v4)}s =. s5 (I.v5)}s 
($y)$s =. s1 (I.v1)}s =. s2 (I.v2)}s =. s3 (I.v3)} s
:
x tomusigma qnorm y
)

qnorm2 =: 3 : 0
z    =. ,y
s  =. ($z)$0

assert. (0<:z) *. z<:1  NB. y outside meaningful bounds 

a =. _3.969683028665376e01 2.209460984245205e02 _2.759285104469687e02
a =. |.a, 1.383577518672690e02 _3.066479806614716e01 2.506628277459239e00

b =. _5.447609879822406e01 1.615858368580409e02 _1.556989798598866e02
b =. |.b, 6.680131188771972e01 _1.328068155288572e01 1

c =. _7.784894002430293e_03 _3.223964580411365e_01 _2.400758277161838e00
c =. |.c, _2.549732539343734e00 4.374664141464968e00 2.938163982698783e00

d =. 7.784695709041462e_03 3.224671290700398e_01 2.445134137142996e00
d =. |.d,  3.754408661907416e00 1
NB.   Define break-points.
p_low  =. 0.02425
p_high =. 1 - p_low
NB.   Rational approximation for lower region.
v =. (0 < z) *. z < p_low 
q =. %: _2*^. v#z
s =.  ((c p. q) % d p. q)    (I.v)} s
NB.   Rational approximation for central region.
v =. (p_low <: z) *. z <: p_high
q =. (v#z) - 0.5
r =. *:q
s =. (q * (a p. r) % b p. r) (I.v)} s
NB.    Rational approximation for upper region.
v =.  (p_high < z) *. z < 1 
q =. %: _2* ^. 1- v#z
s =.  (-(c p. q) % d p. q)   (I.v)} s
NB.   Equal to 0
s =. __ (I.z=0)} s
NB.   Equal to 1
s =. _  (I.z=1)} s

($y)$s
:
x tomusigma qnorm2 y
)


NB.*qnormUT v Upper Tail version of qnorm
qnormUT=: [: -  qnorm


rand01 =: ?@$0:

Note 'Normal Random Deviates'

Brian Schott, Ric Sherlock and others contributed code to the
forum discussion of this function.  The version in the
note follows closely the Box-Muller form of Schott
but does use more space than the tacit version
below.  We include the explicit form to show the 
structure of the steps in the code for those not
experienced with the tacit form.

The right argument is the shape of the result array.

rnorm =: 3 : 0
r =. ?@$0:   NB. defines rand01 within function
n =. >. -: */y
a =. %: _2* ^. r  n
b =.     2* o. r  n
r1 =. a * 2 o. b
r2 =. a * 1 o. b
y$r1,r2
)

BM=. ((2 1 o."0 1 +:@:o.@:rand01) *"1 [: %: _2&*@:^.@:rand01)
NB. RGS I think I like this BM better
BM=. ((2 1 o."0 1 (2p1) * rand01) *"1 [: %: _2&*@:^.@:rand01)
rnorm  =: 3 : 0
(] $ ,@BM@>.@-:@(*/) f.) y
:
x tomusigma rnorm y
)

