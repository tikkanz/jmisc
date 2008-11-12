NB. astro.ijs - astronomical functions
NB. by Harvey E. Hahn - 17 Oct 2008
NB. based on "Astronomical Algorithms" by Jean Meeus (Willmann-Bell, 1991)


NB.       greg2jdnum  noun  = Gregorian yyyymmdd.nn date to Julian Day number
NB.       greg2mjdnum noun  = Gregorian yyyymmdd.nn date to Modified Julian Day number
NB.       jdnum2greg  noun  = Julian Day number to Gregorian yyyymmdd.nn date
NB.       dotw        noun  = day of the week (0=Sun,etc.) given a date
NB.       leap        noun  = is noun a leap year? (true/false)
NB.       doty        noun  = day number within the year given a date
NB. noun1 revdoty     noun2 = return date given year and day number (reverse doty)


NB. =========================================================

greg2jdnum=: 3 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
NB. y argument has format: yyyymmdd.nn
y1=. ": y
yr=. ". 4{.y1
mn=. ". 2{.(4}.y1)
dy=. ". 6}.y1

NB. handle January and February dates specially (i.e., as if
NB. they were the 13th and 14th months of the preceding year):
if. (3>mn) do.
  yr=. yr - 1
  mn=. mn + 12
end.

a=. <. (yr % 100)
b=. (<. (a % 4)) + 2 - a

jdnum=. (<. (365.25 * (4716 + yr))) + (<. (30.6001 * (1 + mn))) + dy + b - 1524.5
)

NB. =========================================================

greg2mjdnum=: 3 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
NB. y argument has format: yyyymmdd.nn
NB. MJD 0.0 corresponds to 17 Nov 1858 (0h UT)
mjdnum=. (greg2jdnum y) - 2400000.5
)

NB. =========================================================

jdnum2greg=: 3 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
NB. y argument has format: nnnnnn.nn
z=. y + 0.5
f=. z - (<. z )
z=. <. z

if. (2299161>z) do.
  a=. z
else.
  a1=. <. ((z - 1867216.25) % 36524.25)
  a=. z + 1 + a1 - (<. (a1 % 4))
end.

b=. a + 1524
c=. <. ((b - 122.1) % 365.25)
d=. <. (365.25 * c)
e=. <. ((b - d) % 30.6001)

dyz=. f + (b - d) - (<. (30.6001 * e))
f1=. 1 }. (": dyz - (<. dyz ))
z1=. _2 {. ('0',(": <. dyz))
dy=. z1,f1

if. (14>e) do.
  mn1=. e - 1
else.
  mn1=. e - 13
end.
mn=. _2 {. ('0',(": mn1))
if. (2<mn1) do.
  yr=. ": c - 4716
else.
  yr=. ": c - 4715
end.
gdate=. yr,mn,dy
greg=. ". gdate
)

NB. =========================================================

NB. day of the week (0=Sun,1=Mon,2=Tue,3=Wed,4=Thu,5=Fri,6=Sat):
dotw=: 3 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
NB. y argument has format: yyyymmdd.nn
z=. <. (7 | ((greg2jdnum y)+1.5))
)

NB. =========================================================

NB. leap year? (true/false)
NB. by Harvey E. Hahn -- 17 Oct 2008
leap=: 3 : 0
if. 0=(100|y) do.
  if. 0=(400|y) do.
    ly=. 1
  else.
    ly=. 0
  end.
else.
  if. 0=(4|y) do.
    ly=. 1
  else.
    ly=. 0
  end.
end.
)

NB. =========================================================

NB. day of the year
doty=: 3 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
NB. y argument has format: yyyymmdd.nn
y1=. ": y
yr=. ". 4{.y1
mn=. ". 2{.(4}.y1)
dy=. ". 6}.y1
if. 1=(leap yr) do.
  k=. 1
else.
  k=. 2
end.
n=. <. (<. ((275 * mn) % 9) + (dy - 30) - (k * <. ((mn + 9) % 12)) )
)

NB. =========================================================

NB. reverse day of the year--syntax:  year revdoty daynumber
NB. final result has format: yyyymmdd.nn
revdoty=: 4 : 0
precision=. 10
9!:11 precision    NB. set display precision to 10 digits
if. 1=(leap x) do.
  k=. 1
else.
  k=. 2
end.
yr=. ": x
if. (32>y) do.
  m=. 1
else.
  m=. <. (((9 * (k + y)) % 275) + 0.98)
end.
mn=. _2 {. ('0',(": m))
dy=. ": (y + 30 + (k * (<. ((m + 9) % 12))) - (<. ((275 * m) % 9)))
dy=. _2 {. ('0',dy)
gdate=. yr,mn,dy
greg=. ". gdate
)

NB. =========================================================
