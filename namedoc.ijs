NB. literate program from http://www.jsoftware.com/jwiki/OlegKobchenko/Namedoc#namedoc.ijs

NB. session documentation utility

require 'scriptdoc'

coclass 'jscriptdoc'

NB.*namedoc v scriptdoc for a name
NB. e.g. namedoc 'namedoc'
NB.      namedoc 'split'
NB.      ;(namedoc,LF"_,LF"_) &.> _3{.nl_z_''
namedoc=: 3 : 0
  'n file'=. y
  tbl=. scriptdef1 'b'fread file
  nam=. {."1 tbl
  if. (#nam) <: nmi=. nam i. <n do.
    'defined in ',>file return. end.
  def=. scriptdeffmt ,:nmi{tbl
  (1+#DEFSEP) }. def
)

namedoc_z_=: 3 : 0
  ndx=. 4!:4 :: _1: y=. boxopen y
  if. ndx < 0 do. 'not found' return. end.
  file=. ndx { 4!:3 ''
  namedoc_jscriptdoc_ y,<file
)


