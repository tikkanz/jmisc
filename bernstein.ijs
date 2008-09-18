NB. bernstein - Bernstein polymonials
NB. http://www.jsoftware.com/jwiki/Essays/Bernstein_Polynomials

require 'plot'
ts=: 6!:2 , 7!:2@]

NB. Basis Polynomials
'`t i k'=: (])`({.@[)`({:@[)
b=: (i!k) * (t^i) * (1-t)^(k-i)

NB. interval 0..1
T=: (% <:@#)i.101

NB. Linear Combination
'`p ik'=: [ ` ( (i. ,. <:)@#@[ )
B=: p +/ . * ik b"1 t

linplot=: 3 : 0 NB. y=control points
  pd 'reset;pensize 2'
  pd (;~ (i. % <:)@#) y
  pd T;y B T
  pd 'show'
)

NB. Expansion Coefficients
bik=: 2 : '((*&(u!v))@(^&u * ^&(v-u)@-.))'
bc=: <: 4 : 'x bik y t. i.>:y'"0~ i.

psig=: _1^(+ i.@>:)
pcoef=: i.@-@>:@] ! -~
bcoef=: (psig * ! * pcoef)/"1

bp=: bcoef@[ p. ]

NB. Reduced Linear Combination
C=: bc@#@p
BC=: p +/ . * C p."1 t

V =: i.@#@p ^~/ t               NB. transposed Vandermonde
BV=: (p +/ .* C) +/ .* V

BP=: (p +/ .* C) p. t

bernenv=: 4 : 0 NB. x=powers number, y=interval points
  pd 'reset;type dot;yrange 0 1;pensize 2'
  pd y;((i.x+1),.x) b"1 y
  pd 'type line'
  pd y; % %: 2 * 1p1 * x * y * 1 - y
  pd 'show'
)

NB. =========================================================
0 : 0
plot T;((i.4),.3) b"1 T
plot T;((i.7),.6) b"1 T
linplot 1 4 2 3

1 bik 3 t. i.4
bc&.> >:i.5
(i.4) (psig"0 ; ,.@:! ; pcoef"0 ; bcoef@,"0) 3
'surface'plot bcoef (,.~ i.@>:) 9

1 4 2 3 (B -: BC) T
1 4 2 3 (B -: BV) T
1 4 2 3 (p +/ .* C) 0
1 4 2 3 (B -: BP) T

8 bernenv T
)
