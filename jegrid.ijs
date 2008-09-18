NB. literate program from http://www.jsoftware.com/jwiki/Scripts/Edit_Grid#jegrid.ijs

script_z_ '~system/classes/grid/jzgrid.ijs'

coclass 'jegrid'
coinsert 'jzgrid'

defineGrid=: 3 : 0
  errmsg=.''
  if. 0=4!:0 <'CELLDNAME' do.
    cdname=. CELLDNAME 
  else. NB. CELLDNAME not defined
    cdname=. 'celldata_ed' 
  end.
  if. -. (-: cofullname) cdname do. NB. add default locale
    cdname=. cdname,'__locD'
  elseif. 1 e. '__' E. cdname do. NB. get referenced locale
    try.
      idx=. _2 { I. '_' = cdname
      loc=. >((cdname }.~ 2+idx),'__locD')~
      cdname=. (idx{.cdname),'_',loc,'_'
    catch. NB. locale reference not found
      cdname=. (idx{.cdname),'__locD'
      errmsg=. 0{::<;._2 ]13!:12 ''
      errmsg=. errmsg,LF,'|Grid defined in ',(idx{.cdname),'_',(>locD),'_'
    end.
  end.
  try. (cdname)=. CELLDATA__grid
  catch. NB. ill-formed name
    ('celldata_ed__locD')=. CELLDATA__grid
    errmsg=. 0{::<;._2 ]13!:12 ''
    errmsg=. errmsg,LF,'|Grid defined in celldata_ed','_',(>locD),'_'
  end.
  if. #errmsg do. smoutput errmsg end.
)

gridpdestroy=: 3 : 0
  defineGrid''
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
