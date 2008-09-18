NB. Collected Definitions from
NB. http://www.jsoftware.com/jwiki/Essays/Inverted_Table
coclass=: 'z'

ifa =: <@(>"1)@|:              NB. inverted from atoms
afi =: |:@:(<"_1@>)            NB. atoms from inverted

tassert=: 3 : 0
 assert. (1=#$y) *. 32=3!:0 y  NB. boxed vector
 assert. 1=#~.#&>y             NB. same # items in each box (with at least one box)
 1
)

ttally    =: #@(0&{::)
tindexof  =: i.&>~@[ i.&|: i.&>
tmemberof =: i.&>~ e.&|: i.&>~@]
tless     =: <@:-.@tmemberof #&.> [
tnubsieve =: ~:@|:@:(i.&>)~
tnub      =: <@tnubsieve #&.> ]
tfreq     =: #/.~@:|:@:(i.&>)~  NB. frequency of unique keys RGS
tgrade    =: > @ ((] /: {~)&.>/) @ (}: , <@/:@(_1&{::))
tgradedown=: > @ ((] \: {~)&.>/) @ (}: , <@\:@(_1&{::))
tsort     =: <@tgrade {&.> ]
