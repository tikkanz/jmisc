NB. from Brian Schott forum post
NB. http://www.jsoftware.com/pipermail/programming/2007-June/007186.html

coclass 'bi'   NB. bivariate approach of Devon
coinsert 'base'

corr =: cov % *&stddev
cov =: spdev % <:@#@]
spdev =: +/@(*~ dev)
dev =: -"_1 _ mean
mean =: +/ % #
stddev =: %:@var
var =: ssdev % <:@#
ssdev =: +/@:*:@dev

coclass 'multi'   NB. multivariate approach

coinsert 'base'

sum =: +/
transpose =: |:
at =: @:

ss =: sum@:*:

ctr =: sum%# NB. centroid
mnc =: ] -"1 ctr NB. meancorrected
mp =: sum . * NB. matrix product
sscp =: transpose mp ]
SSCP =: sscp at mnc
stddev =: ss at mnc %:@% <:@#
std =: mnc %"1 stddev NB. standardized
R =: SSCP  std % <:@#

coclass 'base'

NB. be careful on the next looooong line
Y =: 12 3$1 1 1 1 2 1 1 2 2 1 3 2 2 5 4 2 5 6 2 6 5 2 7 4 3 10 8 3 11 7 3 11 9 3 12 10
YY =: |: Y
]a =: corr_bi_ "1/~ |:Y
]b =: corr_bi_ "1/~   YY
]c =: R_multi_ Y
a -: b
a -: c
6!:2 'corr_bi_ "1/~ |:Y'
6!:2 'corr_bi_ "1/~   YY'
6!:2 'R_multi_ Y'