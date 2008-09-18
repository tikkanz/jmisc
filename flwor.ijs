NB. literate program from http://www.jsoftware.com/jwiki/DB/Flwor#flwor.ijs

NB. flwor - for/let/where/order/return prototype

coclass 'dbDate'

create=: 3 : 0
  schema=: 2&}.&.>'tb'nl_dbDate_ 0
  (schema)=: cocreate&.> a:#~#schema
  for_t. schema do. ('tdefine__',>t)~ ('tb',>t)~ end.
)

destroy=: 3 : 0
  coerase ".&> schema
  codestroy''
)

NB. =========================================================
NB. utility

dtb_z_=: #~ [: +./\. ' '&~:       NB. delete trailing blanks
cut2_z_=: ] ({.~ ; (}.~ >:)) i.~  NB. cut in two at x

tdefine_z_=: 3 : 0
  y=. <@dtb ;. _1 ;. _2 y
  h=. {. y    NB. header
  d=. }. y    NB. data
  'n t'=. <"1 |: ':' cut2&> h      NB. name, type
  o=. ('n'i.{.&>t) { '0&".&>';']'  NB. type operation
  c=. o (128!:2)&.>"_ 1 <"1|:d     NB. columns of data
  (n)=: c
)

NB. =========================================================
NB. data

tbJ=: 0 : 0
|JID|JNAME  |CITY
|J1 |Sorter |Paris
|J2 |Display|Rome
|J3 |OCR    |Athens
|J4 |Console|Athens
|J5 |RAID   |London
|J6 |EDS    |Oslo
|J7 |Tape   |London
)

tbP=: 0 : 0
|PID|PNAME|COLOR|WEIGHT:n|CITY
|P1 |Nut  |Red  |12      |London
|P2 |Bolt |Green|17      |Paris
|P3 |Screw|Blue |17      |Oslo
|P4 |Screw|Red  |14      |London
|P5 |Cam  |Blue |12      |Paris
|P6 |Cog  |Red  |19      |London
|P7 |Cog  |Red  |19      |London
)

tbS=: 0 : 0
|SID|SNAME|STATUS:n|CITY
|S1 |Smith|20      |London
|S2 |Jones|10      |Paris
|S3 |Blake|30      |Paris
|S4 |Clark|20      |London
|S5 |Adams|30      |Athens
)

tbSP=: 0 : 0
|SID|PID|QTY:n
|S1 |P1 |300
|S1 |P2 |200
|S1 |P3 |400
|S1 |P4 |200
|S1 |P5 |100
|S1 |P6 |100
|S2 |P1 |300
|S2 |P2 |400
|S3 |P2 |200
|S4 |P2 |200
|S4 |P4 |300
|S4 |P5 |400
)

tbSPJ=: 0 : 0
|SID|PID|JID|QTY:n
|S1 |P1 |J1 |200
|S1 |P1 |J4 |700
|S2 |P3 |J1 |400
|S2 |P3 |J2 |200
|S2 |P3 |J3 |200
|S2 |P3 |J4 |500
|S2 |P3 |J5 |600
|S2 |P3 |J6 |400
|S2 |P3 |J7 |800
|S2 |P5 |J2 |100
|S3 |P3 |J1 |200
|S3 |P4 |J2 |500
|S4 |P6 |J3 |300
|S4 |P6 |J7 |300
|S5 |P2 |J2 |200
|S5 |P2 |J4 |100
|S5 |P5 |J5 |500
|S5 |P5 |J7 |100
|S5 |P6 |J2 |200
|S5 |P1 |J4 |100
|S5 |P3 |J4 |200
|S5 |P4 |J4 |800
|S5 |P5 |J4 |400
|S5 |P6 |J4 |500
)

NB. =========================================================
Note 'Test'
  cocurrent '' conew 'dbDate'

NB. job ID,name whose city is Athens
(JID__J,.JNAME__J) #~ CITY__J=<'Athens'

NB. cities whose supplier has job in Athens
~.CITY__S #~ SID__S e. SID__SPJ #~ JID__SPJ e. JID__J #~ CITY__J=<'Athens'

NB. number of parts by color
(~.COLOR__P) ,.<"0 #/.~COLOR__P

NB. count,min,max,average of part weight by city
(~.CITY__P) ,.<"0 CITY__P (# , <./ , >./ , +/ % #)/. WEIGHT__P

  destroy ''
  cocurrent_z_ 'base'
)
