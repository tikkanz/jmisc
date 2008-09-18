NB. Shuffle the deck and deal a hand:
combs=: #~ #: i.@^              NB. Combs of y selections from x choices.
deck=: 3: combs 4:              NB. Deck is 3 choices for 4 features,
shuffle=: {~ ?~@#               NB. shuffle it,
hand=: 12&{.                    NB. and pick off a single hand.

NB. Determine if some cards form a set:
allsod=: (#@~. e. 1: , #)"1     NB. Is list ALL Same Or Different
isset=: *./@:allsod@|:"2        NB. Do cards form a set?

NB. All combinations of cards:
btab=: 2&combs                  NB. Make binary table,
sumsof=: ] #~ [ = +/"1@]        NB. rows of y whose total matches x,
outof=: (sumsof btab) # i.@]    NB. and return indices of 1's.
all3=: (3 outof 12)&{           NB. Select all 3-tuples.

NB. Test all combinations for a set:
allsets=: (#~ isset)@all3       NB. Select all sets.

NB. A verb to display cards:
Props=: _3]\;:}: 0 : 0          NB. Table of properties x labels.
one two three red green blue solid outline shaded diamond oval squiggle
)
see=: }.@;@:(' '&,&.>)@({"0 1&Props)"1  NB. Display a card.

NB. And finally put it together:
newhand=: hand@shuffle@deck     NB. Return freshly-dealt hand.
play=: see&.>@(];allsets)       NB. Display hand and all sets. 
