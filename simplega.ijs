NB. Genetic algorithm
NB. http://www.nabble.com/Simple-GA-tf4937358s24193.html
NB. Groenenveld, McCormick
ord=: a. i.]
chr=: a.{~] 

ffit2=: [:+/[ (**)@:- ]

evolueer2=: 4 : 0
   'x oud'=. ord &.> x;y
   s=. x ffit2 oud
   g=. 0
   (('gen: '),(":g),'(',(":s),')',chr oud) (1!:2) 2
   while. 0<s do.
       'kind kinds'=. |:(<x) evo2 &> 10$<oud
       wh=. kinds i. <./kinds,s
       's oud'=. wh{&.>(kinds,s);<kind,oud
       g=.g+1
   end.
   'gen: ',(":g),'(',(":s),') ',chr oud
)

evo2=: 4 : 0
   p=. ?#y
   tc=. p{y
   vk=. (?3){(32+?95),tc+1 _1
   kind=. vk p}y
   kinds=. x ffit2 kind
   kind;<kinds
)

NB. (] evolueer [:chr 32+[:?95$~#) 'Perfect creature!'