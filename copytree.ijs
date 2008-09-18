require 'winapi'
copyDir=: 4 : 0
NB.* copyDir: copy directory x and all its contents to directory y
   fromdir=. endSlash x [ todir=. endSlash y
   assert. dirExists fromdir
   if. -.dirExists todir do. createdir todir end.
   assert. dirExists todir
   fls=. dir fromdir,'*'
   subdirs=. 0{"1 (whd=. 'd' e.&>4{"1 fls)#fls
   fls=. 0{"1 (-.whd)#fls
   sf=. 0 0 NB. Count successes and failures.
   for_fl. fls do. fl=. >fl
       if. fexist todir,fl do. ferase todir,fl end. NB. Overwrite existing
       ct=. 1 0 NB. Assume 1 success, 0 failures...
       try. (fromdir,fl) fcopy todir,fl catch. ct=. 0 1 end.
       sf=. sf+ct
   end.
   for_sbdr. subdirs do. sbdr=. >sbdr
       if. -.dirExists sbdr do. createdir sbdr end.
       ct=. 1 0 NB. Assume 1 success, 0 failures...
       try. ssf=. (fromdir,sbdr) copyDir todir,sbdr catch. ct=. 0 1 end.
       sf=. sf+ssf+ct
   end.
)

NB.* fcopy: copy file x to y using WIN32 API call.
NB.EG 'c:\temp\src.xls' fcopy 'c:\temp\dest.xls' 
NB. Returns 1 iff successful
fcopy=: 'CopyFileA' win32apir @: (; ;&1) 

endSlash=: 3 : 0
NB.* endSlash: ensure terminal path separator char, 
NB. e.g. for directory. 
NB.EG -:/endSlash &.>'C:\ADir\';'C:\ADir'
NB. 1
y,PATHSEP_j_#~PATHSEP_j_~:{:y
)

NB.* dirExists: 0: dir does not exist; 1: exists
dirExists=: 3 : '0&~:#@:dirlist1 (-PATHSEP_j_={:y)}.y=. ,y'

NB.* createdir: Create directory
createdir=: 3 : 'try. 1!:5 y catch. 0 end.'

NB.* createDirPath: create (all elements of) directory path.
createDirPath=: 3 : 0
   ps=. PATHSEP_j_
   dn=. y
NB. Break path into pieces, 
NB. e.g. 'C:\tmp\foo'->'C:';'\tmp';'\foo'
   pdn=. <;.1 (ps#~ps~:{.dn),(-ps={:dn)}.dn
   if. ':' e. dn do. NB. Remove '\' before drive letter
       pdn=. (<dn{.~>:dn i. ':') 0}pdn
NB. Combine drive letter w/1st path element, 
NB. e.g. '\C:';'\tmp';'\foo'->'C:\tmp';'\foo'
       pdn=. ((<ps-.~>0{pdn),&.>1{pdn) 0}}.pdn
   end.
NB. Successive directories to create, 
NB. e.g. 'C:\tmp';'C:\tmp\foo';'C:\tmp\foo\bar'
   d2c=. <"1 pdn#~-.dirExists"1 pdn=. ;\pdn
   rc=. 1 NB. Success too if they're already all there
   if. 0<#d2c do. rc=. createdir&>d2c end.
   rc
)

NB.* dirlist1: list only directories at given path.
dirlist1=: 3 : 0
   y=. y,(PATHSEP_j_={:y)#'*.*' NB. Add wildcards if last char is path sep'r.
   if. 0~:#dl=. 1!:0 y do. jd dl
   else. dl end.
)

NB.* jd: return just directories, not files, from "dir" list
jd=: 3 : '(''d''e.&>4{"1 y)#0{"1 y'
