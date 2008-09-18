
require 'misc'
main=:3 :0
  tot=.0
  nq=.0
  while.1 do.
    'x y'=. ":&.>3+2?@$10
    'op'=.({~ ?@#) '+-*'
    if. 0=#z=. 0".prompt (exp=. x,op,y),' = '
    do.  break. end.
    corr=. z=".exp
    smoutput (10#' '), corr>@{'Boo'; 'Yay!'
    tot=.tot+corr
    nq=.nq+1
  end.
  idx=.<:+/ (100*tot%nq)<30 50 80 100
  eval=.idx {::'You are a Legend!';'That''s not bad.';'You need more practice.';'You are a peabrain!!'
  msg=.'You got ',(":tot),' right out of ',(":nq),' questions.'
  msg,LF,eval,LF,'Bye now!'
)