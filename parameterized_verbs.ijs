NB. http://www.jsoftware.com/svn/DanBron/trunk/environment/parameterized_verbs.ijs
NB.  ===========  DEPENDENCY SECTION  =========== 
require 'strings'  NB. 'strings' is for 'deb'

coclass 'ddp'

NB.  ===========    UTILITY SECTION   =========== 
NB.  Conjunction that takes a noun LHA and a dyadic verb RHA.
NB.  Derived verb is ambivalent; if no LHA specified, the conjunction's LHA
NB.  is used.
defaultLHA    =:  2 : 'm&$: : v'  NB. [.&$: : ].

NB.  Another translate conjuction, only for scalars.  Replace the scalar LHA to the conjunction with the scalar RHA to the conjunction.
NB.  EG.  0 scalarReplace _1 ] 5 8 0 0 5 6 0 3 0 4  NB. Returns 5 8 _1 _1 5 6 _1 3 _1 4
NB.  scalarReplace      =: 2 : '(m.&=)`(,:&n.) } y.'
sr     =:  scalarReplace  =: 2 : '(m&=)`(,:&n) }' NB.  (&=)`(,:&) }
s      =:  2 : ('(m sr n) :. (n sr m)')

NB.*beginsWith v Tests if beginning of the RHA matches the LHA.  
NB. It ravels the LHA argument if it's a scalar.
beginsWith    =:  ,^:(0: -: #@:$)@:] -: ({.~ #)    NB.  ([ -: ({.~ #)~)

NB.*makeParamTable v Make a name-value pair table from a LF-and-'=' delimited noun.
NB. The characters preceding the first '=' on each line become the name
NB. and the characters trailing the same are executed to produce the value.
makeParamTable=:  ((deb@:{. ,&:< ".@:}.@}.)~ i.&'=')&>@:(LF&splitstring)@:(TAB sr ' ')@:}:

NB.  ===========     LOGIC SECTION    =========== 
NB.*isList v Determines if the input's rank is at least 2.  
NB.  That is, if it's 'less than' a table.
isList        =.  2 > #@$@]

NB.*paramListToTable v Stiches on the first N parameter names to the input list 
NB.  (where N = # list),  allowing the user to pass in a list of parameters 
NB.  without names so long as they're in the correct order (the correct order 
NB.  is as defined by the default parameters).
paramListToTable=.  ([: ({."1@:[ ,. ,@:])&>/ <.&# {.&.> ,&<)^:isList

NB.*appendDefaults v Appends the default param name/value pairs onto the end of the parameter table
NB.  with booleans indicating the source map (0=left, 1=right).
appendDefaults  =.  (paramListToTable ,&:>/@:(,&:<  (,.&.> <^:2">) 0 1"_)  [)

NB.*normalizeNames v  Lowercases and removes spaces, dashes, and underscores from parameter names.
NB.  This is for convenience so that, for example, 'someParameter', 'Some Parameter', 
NB.  'some-parameter', 'SOME_PARAMETER' are treated equivalently.  
NB.  Doing this may result in name conflicts.  Note that the names defined, in the end,
NB.  are in the same format as specified by the default parameter table.
NB.! Make combineMaps an adverb with this verb as the parameter (or maybe a conjunction with a handle-missing-names-verb as the other parameter)
'l u'           =.  (a.i.'aA') +each <i.26
tolower         =.  a.&i. { ((l{a.) u} a.)"_     NB.  Tacit 'tolower' from J5
normalizeNames  =.  tolower@:-.&' _-'&.>@:({."1)

NB.*combineMaps v If two parameters have the same name, use the first one, but only allow defineable names 
NB.  (names specified in the default table).  This allows the user's parameters to over-ride 
NB.  the defaults, without allowing him to define names the function isn't expecting 
NB.  (which could possibly over-ride global names the function needs to access).
combineMaps     =:  ([ ({."1@:[ ,. i.~&normalizeNames { }."1@:]) (appendDefaults boxxopen)) f.

defineAndDefaultParams  =:  conjunction define
NB.  The input to this conjunction is a noun RHA and a explicit monadic verb LHA.
NB.  The noun RHA is a 2xN table of boxes, specifying a default parameter table.
NB.     
NB.  The output of this conjunction will be a derived monadic verb that can be called
NB.  with a parameter table, where the elements of column 0 are the names of the
NB.  parameters and the elements of column 1 are  the values of the parameters.  The
NB.  parameters are then defined as local names (assigned to their respective values)
NB.  which the explicit verb can reference at its convenience.  
NB.
NB.  Further, a second set of names is defined, the same as the first with 
NB.  '_is_default' appended to each name.  These names are booleans indicating
NB.  whether the corresponding parameter came from the default table or was
NB.  specified by the caller.
NB.
NB.  For the caller's convenience, instead of passing in a 2xN parameter table, it
NB.  may use a list of boxes.  These values will be assigned to the first (#y) names
NB.  in the default parameter table.  If the caller passes in an unboxed value, that
NB.  value will be assigned to the first name in the default parameter table, unless
NB.  that value is null (0-:#,y), in which case the default parameter table will be
NB.  used in its entirety, with no caller-defined values.

   if. '3 :' beginsWith~ verbBody  =.  5!:5<'u' do.
     NB.  If this is an explicit monadic verb, then redefine it appropriately.

     NB.  Drop off the '3 : 0' (or '3 : ''')
     verbBody =.  5 }. verbBody

     NB.  If two parameters have the same name, use the first one, but only allow defineable names (names specified in
     NB.  the default table).  This allows the user's parameters to over-ride the defaults, without allowing him to
     NB.  define names the function isn't expecting (which could possibly over-ride global names the function needs to
     NB.  access).
     createParameterTable =.  combineMaps f.

     NB.  We will add these lines to the top of u, thereby redefining it.

     NB.  Apply createParameterTable to y (the input to u)
	 newHeading =.  'NB.  Create parameter name/value table from input and default table.'
     newHeading =.  newHeading , LF , 'params =. x (', (5!:5<'createParameterTable') , ') y'

     NB.  Define some local names from the parameter table we just created.
     newHeading =.  newHeading , LF , 'NB.  From the parameter name/value input table, define local names from column 0 to values from column 1'
     newHeading =.  newHeading , LF , '(, (,. ,&''_is_default''&.>) {."1 params) =. , }."1 params'

     NB.  Erase the noun 'params', so we don't interfere with globals of that name.
     newHeading =.  newHeading , LF , 'NB.  Erase the noun ''params'', so we don''t interfere with globals of that name.'
     newHeading =.  newHeading , LF , '4!:55 ,<''params'''

     NB.  Drop off the trailing ')' (or '''') from u, add our new heading, and output the redefined verb.
     n defaultLHA (4 : (<;._2 toJ newHeading, LF, LF, ,&LF^:(LF&~:@:{:) _1 }. verbBody))
   else.
     NB.  If u isn't an explicit monadic verb, don't do anything to it.
     u
   end.
)

NB.*defn a Convenience adverb.  Instead of 'verb define', use 'verb defn',
NB.  and give the parameter definition first, and the verb definition second.
NB.  See example section for examples.
defn  =:  adverb define
	(verb define) defineAndDefaultParams (makeParamTable noun define)
)


NB.  ===========     EXAMPLE SECTION    =========== 
NB.  Define a parameterized verb.  A noun-define is used to create the default parameter table,
NB.  to enhance readability.
parameterizedVerb__   =:  verb defn
  filename    =  'c:\short.log'
  max         =  42
  color       =  'red'
)

  NB.  Ignore this line; I just use it to avoid cluttering the session window.
  NB. print           =. 'r=.LF,~(r"_ ::]$0),'".@,3 :'5!:5<''y'''

  smoutput LF,'======='

  smoutput 'Logging to:  ', filename
  smoutput 'Max is:  '  , ": max  NB.  Note the format;  we're expecting this parameter to be numeric (but this is not checked).

  if. color_is_default do.
    smoutput 'My favorite color is '  ,color
  else.
    smoutput 'Your favorite color is ',color
  end.

  smoutput '======='
)


Note 'example usage'
NB.  Use all the defaults
parameterizedVerb ''

NB.  Change the first parameter (filename).
parameterizedVerb '\\server\share\app_logs\myapp.log'

NB.  Change the first two parameters (filename & max)
parameterizedVerb '\\server\share\app_logs\myapp.log';906

NB.  Change the specified parameter (color)
parameterizedVerb _2 ]\ ;: 'color blue'

NB.  Ditto - names are normalized before testing for equivalence (see normalizeNames, which can be changed to suit your needs).
parameterizedVerb _2 ]\ ;: 'COLOR blue'

NB.  Supply new default parameter table.
' filename f:\output.log max 999 color verdigris'  parameterizedVerb&:(_2&(]\)@:(<;._1)) ' max 10000'
)


NB.  ===========     EXPORT SECTION    =========== 

export2z=: 3 : 0
  y export2z y
:
  znmes=.  x([:,,&.>/)&.;:'_z_'
  ynmes=.  (;:y),L:0'_'([,],[)>coname''
  (znmes)=: ynmes
  empty''
)

'ddp mpt defn' export2z 'defineAndDefaultParams makeParamTable defn'

NB. ('ddp mpt defn'([:,,&.>/)&.;:'_z_') =: (;:'defineAndDefaultParams makeParamTable defn'),L:0'_'([,],[)>coname''

