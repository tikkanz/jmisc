NB. =========================================================
NB. Utilities for working with verbs with multiple arguments
NB.  * can specify default values for args
NB.  * arguments given as name-value pairs in 2-col table
NB.  * allows list of first n args in expected order
NB.  * verb user cannot define un-expected arg names

NB. require 'pack'
script_z_ '~system/main/pack.ijs'

coclass 'pargs'

NB.*makeTable v Reshape y as 2-column table
NB. use to coerce list of boxes to 2-column table
makeTable=: _2 [\ ,

NB.*isList v Is y less than rank 2?
isList=: 2 > #@$@]

NB.*paramListToTable v Stiches on the first N parameter names to the input list
NB. adapted from Dan Brons parameterized_verbs script.
paramListToTable=: (([: ({."1@:[ ,. ,@:])&>/ <.&# {.&.> ,&<) boxxopen)^:isList

NB.*packarg v Package namelist
NB. Same as pack from pack.ijs but doesn't sort names
packarg=: [: (, ,&< ".)&> ;:@] :: ]

NB.*getArgs v Resolves defaults and specified parameters as table of 2-col name-value pairs
NB. result: 2-column table of name-value pairs
NB. used at start of multi-param verb to override default values
NB. y is: list of boxed parameter values in expected order
NB.       or 2-column table of name-value pairs in any order
NB. x is: list of argument names in expected order (boxed or space-delimited string)
NB. Names in x must have already been defined (default values)
getArgs=: ([ psel packarg@[ pset~ packarg@[ paramListToTable ]) f.

NB. =========================================================
NB. Export to z locale
makeTable_z_=: makeTable_pargs_
getArgs_z_=: getArgs_pargs_

NB. =========================================================
NB. Example usage

Note 'example usage in verb definition'

getWeaned=: 3 : 0
  args=. ;: 'ndams weanrate sexratio'  NB. Parameters
  (args)=. 100 1 0.5                NB. default values
  (args)=. {:"1 args getArgs y      NB. update defaults
  ((] , -.) sexratio) * weanrate * ndams
) NB. remove this comment to finish verb

NB. use all defaults
getWeaned ''
NB. use list of boxed params
getWeaned 300;1.2;0.5
NB. use partial list of boxed params
getWeaned 300;1.2
NB. use name-value pairs
getWeaned (;:'weanrate ndams sexratio'),.1.2;300;0.5
NB. OR
getWeaned makeTable 'weanrate';1.2;'ndams';300;'sexratio';0.5
NB. use partial list of name-value pairs
getWeaned (;:'weanrate ndams'),.1.2;300

)
