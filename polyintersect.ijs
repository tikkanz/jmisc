== Find the intersection of polynomials ==

Given two polynomials, for example: 
  a) f(x)=3+x and  
  b) f(x)=1+2x+x2 
## NB. replace with Latex versions of polynomials
how can we find their intersection?

The coefficients of the above polynomials from lowest to highest order are 
{{{ 
a=: 3 1
b=: 1 2 1
}}}
We can plot these as follows.
{{{
   load 'plot'
   plot _3 3;'3 1 p. y ` 1 2 1 p. y'
NB. or
   plot _3 3;'a p. y ` b p. y'
}}}
## NB. image of plot

p. evaluates a polynomial of order #x with coefficients x for 
the argument y. So f(_2) for polynomial ''b'' is
{{{
   1 2 1 p. _2
1
}}}

From the plot we can see that the two polynomials intersect
when x is _2 or 1. How can we get that result using J?

This is equivalent to finding the roots 
(the values for x where the polynomial is zero) 
of a polynomial formed by subtracting polynomial a from polynomial b.

subtract one polynomial from another
{{{
   a (-/@,:) b
2 _1 _1
}}}

The monadic form of the verb p. can find the roots for us.
{{{
   p. 2 _1 _1
┌──┬────┐
│_1│_2 1│
└──┴────┘
}}}

The roots are in the 2nd box (the first contains the multiplier) so 
we can put these ideas all together to give a vector of the x values 
where two polynomials intersect:
{{{
   findIntersect=: 1 {:: [: p. -/@,:

   a findIntersect b
_2 1
}}}

We could remove any complex roots from the result as follows
{{{
   a (#~ (= +))@findIntersect b 
(#~ (= +))@(1&{::)@p.@(-/)@,:
(#~ (= +))@(1&{::)@([: p. -/@,:)
}}}

The examples given above are probably the best way to do find the intersection 
of 2 polynomials.  If you want the common intersection of several, here is a
less-succinct method.

You can test whether f0,f1,... are all equal by
forming the sum of (fi-fj)^2 and setting it to zero.

{{{
ppr  =: +//.@(*/)  NB. polynomial product
pdiff=: -/@,:      NB. polynomial difference
pps   =: ppr~      NB. polynomial square

comb=: 4 : 0
 k=. i.>:d=.y-x
 z=. (d$<i.0 0),<i.1 0
 for. i.x do. z=. k ,.&.> ,&.>/\. >:&.> z end.
 ; z
)

NB. findIntersectM <list of boxes of coefficients>
NB. returns x-coordinates of common intersection points
findIntersectM=:3 : 0
a=.>y
c=.2 comb #a
~. (#~ (= +)) 1{:: p. +/ pps@pdiff /"2  c { a
)
}}}

For the polynomials
  c) f(x)= x^2
  d) f(x)= 2-x^2
  e) f(x)= 1
{{{
c=:0 0 1
d=:2 0 _1
e=:1
}}}

We can plot these as follows.
{{{
   require 'plot'
   plot _3 3;'c p. y ` d p. y ` e p. y'
}}}
## NB. image of plot
By inspection these polynomials intersect when x is 1 and _1.

Given a list of boxed coefficients for each polynomial we
can find the x coordinates where they all intersect.
{{{
   ]r=:findIntersectM c;d;e
1 _1
}}}

We can evaluate each polynomial at those x values to show that 
they all have the same f(x).
{{{
   c p. r
1 1
   d p. r
1 1
   e p. r
1 1
}}}

== Contributions ==
This essay was compiled by RicSherlock from posts in this
[wiki:JForum:programming/ forum thread] by JohnRandall, RaulMiller and HenryRich.

== See Also ==
Polynomials Lab