gamma=: ! & <:
ig0=: 4 : '(1 H. (1+x) % x&((* ^) * (^ -)~)) y'
incgam=: ig0 % gamma@[  NB. incomplete gamma
chisqcdf=: incgam&-:


t26d8a=: 0.411740 0.554300 0.831211 1.145476 16.7496 20.515 22.105 25.745
t26d8b=: 15.137 18.421 21.108 23.513 25.745 27.856 29.877 31.828 33.720 35.564

Note 'tests'
5 chisqcdf t26d8a
0.00499995 0.0100001 0.025 0.05 0.995042 0.999 0.9995 0.9999


(1+i.10) chisqcdf t26d8b
0.9999 0.9999 0.9999 0.9999 0.9999 0.9999 0.9999 0.9999 0.9999 0.9999
)


ts=: 6!:2,7!:2@]
randx01=: ?.@$ 0:

normalrand=: 3 : 0
  (2 o. +: o. rand01 y) * %: - +: ^. rand01 y
)

normalranda=: 3 : 0
  (2 o. +: o. rand01 y) * %: _2* ^. rand01 y
)

normalrand2=: 3 : 0
  n=. >. -: y
  a=. %: - +: ^. rand01 n
  b=. +: o. rand01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  NB. y{.,r1,.r2        NB. not required
  y{.r1,r2
)

normalrand2a=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. rand01 n
  b=. +: o. rand01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)
normalrand2b=: 3 : 0
  n=. >. -: */y
  a=. %: - +: ^. rand01 n
  b=. +: o. rand01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)

normalrand2b1=: 3 : 0
  n=. >. -: */y
  a=. %: - +: ^. rand01 n
  b=. (o. 2) * rand01 n
  r1=. a * 2 o. b
  r2=. a * 1 o. b
  y$r1,r2
)


normalrand2c=: 3 : 0
  n=. >. -: */y
  a=. %: _2* ^. rand01 n
  b=. +: o. rand01 n
  y$, a (*"1) 2 1 o."0 1 b
)



normalrand3=: 3 : 0
  n=. >. -: y
  y{.,((2&o.,.1&o.) +: o. rand01 n) *"1 0 %: - +: ^. rand01 n
)

normalrand3a=: 3 : 0
  n=. >. -: y
  y{.,((2 1&o.)"1 0 +: o. rand01 n) *"1 0 %: - +: ^. rand01 n
)

normalrand3c=: 3 : 0
  n=. >. -: y
  y{.,(2 1 o."0 1 +: o. rand01 n) *"1 %: - +: ^. rand01 n
)

normalrand3b=: 3 : 0
  n=. >. -: y
  y{.,((2&o.,.1&o.) +: o. rand01 n) *"1 0 %: _2* ^. rand01 n
)

normalrand4=: ({.,)(2 1&o."1 0@ +:@o.@rand01 * [:%:-@+:@^.@rand01)@>.@-:
normalrand4a=: ({.,)(2 1&o."1 0@: +:@:o.@:rand01 * [:%:-@:+:@:^.@:rand01)@>.@-:
normalrand4b=: ({.,)(2 1&o."1 0@: +:@:o.@:rand01 * [:%:_2&*@:^.@:rand01)@>.@-:

normalrand5=: ({.,)(2 1&o."1 0@(+:@o.@rand01) * [:%:-@+:@^.@rand01)@>.@-:
normalrand5a=: ({.,)(2 1&o."1 0@:(+:@:o.@:rand01) * [:%:-@:+:@:^.@:rand01)@>.@-:
normalrand5b=: ({.,)(2 1&o."1 0@:(+:@:o.@:rand01) * [:%:_2&*@:^.@:rand01)@>.@-:
normalrand5c=: ({.,)(2 1&o."1 0@(+:@o.@rand01) * [:%:_2&*@^.@rand01)@>.@-:

normalrand6a=:  ({.,) ((2 1 o."0 1 +:@:o.@:rand01) *"1 [: %: -@:+:@:^.@:rand01)@>.@-:
normalrand6a1=: ] $ ,@((2 1 o."0 1 +:@:o.@:rand01) *"1 [: %: -@:+:@:^.@:rand01)@>.@-:@(*/)
normalrand6b=:  ] $ ,@((2 1 o."0 1 +:@:o.@:rand01) *"1 [: %: _2&*@:^.@:rand01)@>.@-:@(*/)
normalrand6c=:  ] $ ,@((2 1 o."0 1 (o.2) * rand01) *"1 [: %: _2&*@:^.@:rand01)@>.@-:@(*/)
normalrand6d=:  ] $ ,@((2 1 o."0 1 (2p1) * rand01) *"1 [: %: _2&*@:^.@:rand01)@>.@-:@(*/)

NB. Viktor's normalrand6
normalrand7=:  ({.,)(%:@-@+:@^.@rand01 * 2 1 o."1 0(o.2)*rand01)@>.@-:
normalrand7a=: ({. ,) (%:@:-@:+:@:^.@:rand01 (*"1) 2 1 (o."0 1) (o. 2) * rand01)@>.@-:
normalrand7b=: ] $ ,@(%:@:-@:+:@:^.@:rand01 (*"1) 2 1 (o."0 1) (o.2) * rand01)@>.@-:@(*/)

BM=:(2 1 o."0 1 o.@+:@[ * rand01@])*"1(* [:%:_2*^.@:rand01@])
normalrandom=:] $ ,@(BM >.@-:@(*/))

normalrand01=: normalrand6c

normalrandoma=: {.@[ + {:@[ * normalrand01@:]

normalrandomb=: 3 : 0
  normalrand01 y
:
  'mu sd'=. x
  mu + sd * normalrand01 y
)
normalrandomc=: 3 : 0
  normalrand01 y
:
  'mu sd'=. x
  mu&+@:(sd&*@:normalrand01) y
)

normalrandP=: 3 : 0
  r=. i.0
  while. y ~: #r do.
    j=. >.0.65*y-#r
    t=. (2,j)$<:+: rand01 +:j
    b=. 1>s=. +/*:t
    s=. 0.5^~(_2*^.s)%s=. b#s
    r=. r,,(b#"1 t)*(2,#s)$s
    r=. (y<.#r){.r
  end.
)

Note 'tests'
numb=: 100000
10 ts 'normalrand   numb'
10 ts 'normalranda  numb'
10 ts 'normalrand2  numb'
10 ts 'normalrand2a numb'
10 ts 'normalrand3  numb'
10 ts 'normalrand3a numb'
10 ts 'normalrand3b numb'
10 ts 'normalrand3c numb'
10 ts 'normalrand4  numb'
10 ts 'normalrand4a numb'
10 ts 'normalrand4b numb'
10 ts 'normalrand5  numb'
10 ts 'normalrand5a numb'
10 ts 'normalrand5b numb'
10 ts 'normalrand6a numb'
10 ts 'normalrand6a1 numb'
10 ts 'normalrand6b numb'
10 ts 'normalrandP  numb'

10 ts 'normalrand   numb'
10 ts 'normalranda  numb'
10 ts 'normalrand2  numb'
10 ts 'normalrand2a numb' NB. best explicit
10 ts 'normalrand2b numb'
10 ts 'normalrand2b1 numb'
10 ts 'normalrand6a numb' NB. best vector version
10 ts 'normalrand6b numb' NB. best tacit
10 ts 'normalrand6c numb'
10 ts 'normalrand01 numb'
10 ts '1 normalrandom numb'
10 ts '0 1 normalrandoma numb'
10 ts 'normalrandomb numb'
10 ts 'normalrandomc numb'
10 ts '2 normalrandom numb'
10 ts '3 2 normalrandoma numb'
10 ts '3 2 normalrandomb numb'
10 ts '3 2 normalrandomc numb' NB. saves space

10 ts 'normalrand7  numb'
10 ts 'normalrand7a numb'
10 ts 'normalrand7b numb'
)

