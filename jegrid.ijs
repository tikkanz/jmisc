NB. literate program from http://www.jsoftware.com/jwiki/Scripts/Edit_Grid#jegrid.ijs

script_z_ '~system/classes/grid/jzgrid.ijs'

coclass 'jegrid'
coinsert 'jzgrid'

gridpdestroy=: 3 : 0
  if. 0~:4!:0 <'CELLDNAME' do. 
    CELLDNAME=. 'celldata_ed' end.
  if. -. (-: cofullname) CELLDNAME do. NB. add default locale
    CELLDNAME=. CELLDNAME,'__locD'
  elseif. 1 e. '__' E. CELLDNAME do. NB. get referenced locale
    try.
      idx=. _2 { I. '_' = CELLDNAME
      loc=. >((CELLDNAME }.~ 2+idx),'__locD')~
      CELLDNAME=: (idx{.CELLDNAME),'_',loc,'_'
    catch. NB. locale reference not found
      CELLDNAME=. (idx{.CELLDNAME),'__locD'
      errmsg=. 0{::<;._2 ]13!:12 ''
      errmsg=. errmsg,LF,'|Grid defined in ',(idx{.CELLDNAME),'_',(>locD),'_'
    end.
  end.
  try. (CELLDNAME)=. CELLDATA__grid
  catch. NB. ill-formed name
    ('celldata_ed__locD')=. CELLDATA__grid
    errmsg=. 0{::<;._2 ]13!:12 ''
    errmsg=. errmsg,LF,'|Grid defined in celldata_ed','_',(>locD),'_'
  end.
  smoutput errmsg
  wd 'pclose'
  destroy__grid''
  codestroy''
)

egridp=: 4 : 0
  a=. conew 'jegrid'
  x gridpshow__a y
)

NB.*editgrid v Displays editable grid containing array y.
NB. result: On close the grid data is assigned to a noun.
NB.         Noun is defined in locale editgrid was called from.
NB. eg: 'myarray' editgrid i. 4 3
NB. y is: an array displayable in a grid control
NB. x is: Optional literal or 2-column table of grid options.
NB.       Literal is name of noun grid data is assigned to.
NB.       Defaults to celldata_ed.
NB.       Grid option name is CELLDNAME.
editgrid_z_=: 3 : 0
  (0 0$0) editgrid y
:
  if. (2>#$x) *. 2= 3!:0 x do.
  x=. ,:'CELLDNAME';x end.
  opts=. x,,:'CELLEDIT';1
  opts=. opts,'GRIDESCCANCEL';1
  (opts;coname'') egridp_jegrid_ y
)
