flat=: < :. (}:@}."1@}:@}.)

'LT GT SL'=: '<>/'

tag=: 1 : 'LT,u,GT,y,LT,SL,u,GT'
td=: '<td valign="top">'&,@(,&'</td>')
nbsp=: ;@:('&nbsp;'"_^:(' '&=)&.>@<"0)
  NB. notice how significant spaces are preserved with &nbsp;

html=: 3 : 0
NB. copyright (c) 1998-2003 oleg kobchenko
NB. updated for j5
if. 0=L. y do.
   r=. nbsp ((,&LF@(,&'<br>')"1)@}: ,&, {:) ": &.flat y
   r=. >(r-:''){r;'&nbsp;'
   'tt'tag r                        NB. comment out for non-fixed width font
else.
if. 3>$$y do.  r=. ''
  if. 0=$$y do. r=. r,('tr'tag td html >y),LF
  elseif. 1=$$y do.
    for_i. i.$y do. r=. r,(td html >i{y),LF  end.
    r=. 'tr'tag r
  elseif. 1 do.
    for_k. i.#y do.
      rd=. ''
      for_i. i.{:$y do. rd=. rd,(td html >(<k,i){y),LF  end.
      r=. r,'tr'tag rd
    end.
  end.
  r=. '<table border="1" cellpadding="5" cellspacing="0">',LF,r,'</table>',LF
else.
  r=. ''  for_k. i.#y do.
    r=. r, html k{ y
    if. k < #y do. r=. r,'&nbsp;<br>' end.
  end.
end.
end.
)

dump=: fwrite&(<'test01.htm')"_

NB. ================================ SAMPLE

[data1=: 4 3$(<"0 ; <"1 ; <"2 ,&< <"3) ' '(<"1?4#,:2 3 4)}a.{~65+i. 2 3 4
'html'tag 'body'tag html data1

[data2=: <i.2 3 4
'html'tag 'body'tag html data2

