NB. fixargs
NB.
NB. replace x. y. etc args with x y 
NB.
NB. fixargs    - fix args in text
NB. fixfile    - fix args in file
NB. fixpath    - fix all ijs,ijt files in path
NB.
NB. Note: this simply replaces instances of x., y. with x, y etc. 
NB. It does not check if these names were previously used 
NB. in the definition.

9!:49 :: 0: 1
require 'dir files regex'

NB. =========================================================
fixargs=: 3 : 0
for_a. 'xymnuv' do.
  y=. a fixarg y
end.
)

NB. =========================================================
fixfile=: 3 : 0
dat=. fread y.
if. dat -: _1 do. return. end.
new=. fixargs dat
if. new -: dat do. 0 return. end.
new fwrite y.
#new
)

NB. =========================================================
NB. fixpath
NB. fix ijs/t files in path
NB. e.g. fixpath 'e:\deb\libsrc'
fixpath=: 3 : 0
f=. {."1 dirtree y.
m=. (_4 {.each f) e. '.ijs';'.ijt'
fixfile &> m # f
)

NB. =========================================================
NB. fixarg
NB. x = letter
NB. y = text
fixarg=: 4 : 0
if. -. 1 e. (x,'.') E. y do. y return. end.
rx=. '(^|[^[:alnum:]_])(',x,'\.)'
sx=. rx,'[^[:alnum:]\.:]'
y=. ((sx;,2);x) rxrplc y
((rx;,2);x,' ') rxrplc y
)

