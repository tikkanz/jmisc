NB. http://juggle.gaertner.de/bnp/c2j.html
NB. A very simple structure compiler by Martin Neitzel

   require 'dll winapi'
   midiOutGetNumDevs =:'mmsystem midiOutGetNumDevs n' & cd

NB. int midiOutGetDevCapsA (int deviceNumber, MIDIOUTCAPSA *buf, int buflen);
midiOutGetDevCapsA =: 'winmm midiOutGetDevCapsA i i *c i' & cd
   r=.midiOutGetDevCapsA 0 ; (100#' ') ; 100
   caps =. > 2 { r

NB. typedef struct tagMIDIOUTCAPSA {
NB.     WORD    wMid;                  /* manufacturer ID */
NB.     WORD    wPid;                  /* product ID */
NB.     MMVERSION vDriverVersion;      /* version of the driver */
NB.     CHAR    szPname[MAXPNAMELEN];  /* product name (NULL terminated string) */
NB.     WORD    wTechnology;           /* type of device */
NB.     WORD    wVoices;               /* # of voices (internal synth only) */
NB.     WORD    wNotes;                /* max # of notes (internal synth only) */
NB.     WORD    wChannelMask;          /* channels used (internal synth only) */
NB.     DWORD   dwSupport;             /* functionality supported by driver */
NB. } MIDIOUTCAPSA

char=:{.                                NB. character (singleton to salar)
ctoi =: 3 : '256 #. a. i. |. y'        NB. C bytes to J integer.
NUL=.0{a.
zerocut =: {.~ i.&NUL                   NB. C string to J string.

NB.  (I wish I knew a more elegant mapping than the complicated Amend here:)
middlenum =. ".&.>@(1&{)@]`1:`]}~ "1

NB. Type declarations
TypeTable =: middlenum <;._1 ;._2 noun define
	w	2	ctoi
	W	4	ctoi
	c	1	char
	s	1	zerocut
	v	4	ctoi
)

NB. Structure declaration
MOCAPS_SD =: middlenum <;._1 ;._2 noun define
	w	1	wMid
	w	1	wPid
	v	1	vDriverVersion
	s	32	szPname
	w	1	wTechnology
	w	1	wVoices
	w	1	wNotes
	w	1	wChannelMask
	W	1	dwSupport
)

TZI_SD =: middlenum <;._1 ;._2 noun define
	w	1	wYear
	w	1	wMonth
	w	1	wDayOfWeek
	w	1	wDay
	w	1	wHour
	w	1	wMinute
	w	1	wSecond
	w	1	wMilliseconds
)


expand_field =: monad define "1
        i=.({."1 TypeTable) i. {. y
        y , }. i { TypeTable
)

expand_structure =: monad define
        y =. expand_field y
        sizes =. */"1 > 1 3 { "1 y
        offsets =. 0, }: +/\ sizes
        y ,. <"0 sizes ,. offsets
)

cutter =: dyad define "1 1
        'basetype arraycnt name typelen conv length offset' =. x
        datachars =. (offset + i. length) { y
        name ; conv~ datachars
)

   ] MOCAPS_ESD =. expand_structure MOCAPS_SD

   MOCAPS_ESD cutter caps

GetTZI=: 'GetTimeZoneInformation'win32api
'result buffer'=: GetTZI <(,43#0)
6 u: 2 ic 16{. }.buffer  NB. convert J integers to sets of 4 bytes to unicode (*i to WCHAR)
_1 ic 2 ic 4{. 17}.buffer NB. convert J integers to sets of 4 bytes and then sets of 2 bytes to J integers(*i to WORD)


tst=: 0 : 0
1 (<:+/\ 4 64 16 4 64 16 4)}172#0
         1 16  4 1 16  4 1
)