NB. Posted by Raul Miller in J Forum
NB. http://www.jsoftware.com/pipermail/general/2006-February/026497.html
NB.! I think it needs work to handle relative urls 
NB.!  - either that or need to build explict url before call postReq.

safe=: (33}.127{.a.)-.'=&%+'
encode=:  [: toupper ('%',(I.'6'=,3!:3'f') {&, 3!:3)
urlencode=:  [: ; encode^:(safe -.@e.~ ])&.>
nvp=: >@{.,'=',urlencode@":@>@{:

NB.*args v Creates urlencoded string of namevaluepairs.
NB. returns urlencoded string of namevalue pairs for appending to url
NB. y is rank 2 array of boxed namevaluepairs where 0{"1 is names & 1{"1 is values
args=: [: }.@; ('&'<@,nvp)"1

isHttp=:3 :0
assert. 'http://'-:7{.y
y
)

host=: 0 ({:: <;._1) 6 }. ] NB. isHttp
path=: (7 + #@host) }. ]

Vers=: ' HTTP/1.0',CRLF
Type=: 'Content-Type: application/x-www-form-urlencoded',CRLF
Len=:  'Content-Length: '
Host=: 'Host: ',host@],CRLF"_

postFmt=: 'POST ',path@[,Vers,Host@[,Type,Len,":@#@],CRLF,CRLF,]
NB.postFmt=: 'POST ',path

NB.*postReq v Creates a POST request.
NB. returns url with and 
NB. y is rank 2 array of boxed namevaluepairs where 0{"1 is names & 1{"1 is values
NB. x is bare url
NB. e.g. url postReq namevaluepairs
postReq=: postFmt args
