NB. literate program from http://www.jsoftware.com/jwiki/Scripts/Edit_Grid#jegrid.ijs

script_z_ '~system/classes/grid/jzgrid.ijs'

coclass 'jegrid'
coinsert 'jzgrid'

NB.! error handling needs improvement
NB.! eg: what if name is invalid?
gridpdestroy=: 3 : 0
  if. 0~:4!:0 <'CELLDNAME' do. 
    CELLDNAME=. 'celldata_ed' end.
  if. -. (-: cofullname) CELLDNAME do. NB. add default locale
    CELLDNAME=. CELLDNAME,'__locD'
  elseif. 1 e. '__' E. CELLDNAME do. NB. get referenced locale
    idx=. _2 { I. '_' = CELLDNAME
    loc=. >((ref=.(2+idx)}.CELLDNAME),'__locD')~
    try. CELLDNAME=: (idx{.CELLDNAME),'_',loc,'_'
    catch. NB. reference not found
      CELLDNAME=. (idx{.CELLDNAME),'__locD'
      smoutput ref,'__',(>locD),' not found, grid defined in ',(idx{.CELLDNAME),'_',(>locD),'_'
    end.
  end.
  (CELLDNAME)=. CELLDATA__grid
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
