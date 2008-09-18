NB. literate program from http://www.jsoftware.com/jwiki/OlegKobchenko/Tag#tag.ijs

NB. tag name;attrs;tags
tag=: 3 : 0
  if. 0=L.y do. htsafe ":y return. end.
  'e a c'=. y
  if. 0=#e do. htsafe ":c return. end.
  if. -.(<e) e. tagsC,tagsNC do. TAGERR=: 'invalid tag: ',e throw. end.
  A=. C=. ''
  for_i. ,:^:((0<#) *. 1=#@$) a do.
    'n v'=. i
    if. -.(<n) e. a:,attrV,attrNV do. TAGERR=: 'invalid attribute: ',n throw. end.
    if. (<n) e. attrNV do. v=. n end.
      A=. A,<' ',n,'="',(htsafe ":v),'"'
  end.
  for_i. ,:^:((0<#) *. 1=#@$) c do.
    C=. C,<tag i
  end.
  r=. '<',e,;A
  if. (0<#C) +. -.(<e) e. tagsNC do. 
    r,'>',(;C),'</',e,'>'
  else. r,' />' end.
)

buildTag=: 3 : 0
  TAGERR=:''
  try.
    tag y
  catcht.
    TAGERR
  end.
)

NB. htsafe v replaces `&<>"` with character entities
rp=.  2 : '; }. ,(<m) ,. ,.<;._1 n , y'
htsafe=: [:'&gt;'rp'>'[:'&lt;'rp'<'[:'&quot;'rp'"' '&amp;'rp'&'

tagsC=: ;: noun define-.LF  NB. elements with closing tags
  a abbr acronym address applet
  area b base basefont big
  blockquote body button caption cite
  code col colgroup dd del
  dfn dir div dl dt
  em fieldset font form frameset
  h1 h2 h3 h4 h5
  h6 head html i iframe
  ins kbd label legend li
  link menu noframes noscript object
  ol optgroup option p pre
  q samp script select small
  span strike strong style sub
  sup table tbody td textarea
  tfoot th thead title tr
  tt u ul var xmp
)
tagsNC=: ;: noun define-.LF  NB. elements with no closing tag
  br hr img input isindex map meta param
)
attrV=: ;: noun define-.LF  NB. attributes with value
  abbr accept accesskey action align
  alink alt archive axis bgcolor
  border cellpadding cellspacing char charoff
  charset cite class classid clear
  codebase codetype color cols colspan
  content coords data datetime dir
  enctype face for frame framebordersize
  headers height href hreflang hspace
  id lang language link longdesc
  marginheight marginwidth maxlength media method
  name object onblur onchange onclick
  ondblclick onfocus onkeydown onkeypress onkeyup
  onload onmousedown onmousemove onmouseout 
  onmouseover onmouseup onreset onselect onsubmit 
  onunload prompt rel rel rev rows
  rowspan rules scope scrolling shape
  span src standby start style
  summary tabindex target text title
  type usemap value valuetype vlink
  vspace width
)

attrNV=: ;: noun define-.LF  NB. attributes with no value
  checked compact declare defer disabled ismap 
  multiple nohref noresize noshade nowrap 
  readonly selected
)

Note 'test'  NB. select and Ctrl+E
  ]t1=. 'td';(_2]\;:'name n1 class c1');<'';'';'test 1'
  tag t1
  ]t2=. 'td';'';'test <2>'   NB. text alone
  tag t2
  ]t3=. 'td';((;:'name class');&>1 2);''
  tag t3
  ]t=. 'tr';'';<t1,S,t2,S,:t3 [ S=. '';'';LF
  tag t
  ]t=. 'br';('class';'b"1"');''
  tag t
  ]t=. 'input';('checked';'');''
  tag t
  ]e1=. 'td';(_2]\;:'NotAnAttrib n1 class c1');<'';'';'test 1'
  tag e1
  buildTag e1
  ]e2=. 'NotATag';'';'test <2>'   NB. text alone
  tag e2
  buildTag e2
  ]e=. 'tr';'';<t1,S,t2,S,:t3 [ S=. 'NotATagDeep';'';LF
  tag e
  buildTag e
)
