NB.* logger.ijs: display & log info.

NB.* logMsg: log message to file and show in window.  Title window by x
NB.* initStatusWin: initialize status window.
NB.* setBuffLen: set buffer length=number of lines to buffer in var CUMOUT
NB.* initLogFl: set up log file; pick new name for today's file if none spec'd.
NB.* initWin: initialize message window.
NB.* initLog: initialize log file if necessary.
NB.* flushLog: write all text to log file and empty the cumulative output.
NB.* closeLog: write remaining text to log file, clean up vars, close window.
NB.* todayfile: Create unique file name based on today's date.
NB.* lastlines: return only last x lines from message y (text vec w/EOL
NB.* txtEOL2Lns: text delimited by end-of-lines chars -> vec of text vecs.
NB.* deepDisclose: disclose enclose arrays, to simplest level->simple text vec
NB.* pickFontSz: pick 10 or 12 point font size depending on ratio of
NB.* getTempPath: MS Windows API returns designated temporary file dir.
NB.* getTempDir: get name of temporary directory.
NB.* showdate: show given, or current if arg '', date & time in standard form.
NB.* exampleUses: examples of different ways to log messages.

NB. Use "logMsg_logger_" to show messages in a standard window and log
NB. them to a file.  Probably want to avoid "coinsert 'logger'" so this can
NB. be used with anything without danger of name-shadowing.

coclass 'logger'
coinsert 'base'
require 'winapi winlib' NB.  dt'

NB. Global parameters below.  Other globals are CUMOUT (cumulative text
NB. output), BUFLEN (number of lines to accumulate in CUMOUT before writing
NB. to file), and FNM (name of log file).

DISPLAY=: 1                   NB. Display messages on screen; 0: just log them.
LINELEN=: 77                  NB. Maximum length of line to display in window.

logMsg=: 3 : 0
  NB.* logMsg: log message to file and show in window.  Title window by x
  '' logMsg y
  :
  txt=. y                             NB. Text to output; may be matrix.
  x initWin '' [ initLog ''
  setBuffLen ''
  if. (0=L. txt) do.                   NB. Change any simple array
    if. (#$txt)e. 0 1 do.            NB.  from EOL-delimited vector to
      txt=. txtEOL2Lns txt         NB.  encl. vec.
    elseif. 2=#$txt do.              NB. Simple mat to
      txt=. dtsp&.><"1 txt         NB.  encl. text vec.
    end.
  else.                                NB. If txt is already enclosed.
    
  end.                                 NB. Assume encl. already OK.
  CUMOUT=: CUMOUT,,txt                 NB. Accumulate text.
  msg=. lastlines CUMOUT               NB. Show only last bit that fits
  if. DISPLAY do. wdstatus msg  end.   NB.  into window.
  if. BUFLEN<:#CUMOUT do.              NB. Write out accumulated text?
    flushLog ''
  end.
)

NB.* initStatusWin: initialize status window.
initStatusWin=: 4 : 0
  x wdstatus y
  wd 'pmove 10 10 250 100'
  wd 'setxywh s0 1 1 327 96'
  fontsz=. ":pickFontSz ''
  wd 'setfont s0 "Courier New" ',fontsz
  NB. The specific values below were determined by trial-and-error.
  scrsz=. <;._1 ' ',wd 'qm'       NB. Find screen size so we can
  scrsz=. ;".&.>2{.scrsz          NB.  shrink window to about 8x60 chars
  loc=. ":scrsz-654 190           NB.  and put in LR corner; 25=200-175
  wd 'pmovex ',loc,' 654 170'     NB.  to avoid covering task bar at bottom.
)

NB. wd 'qformx'  NB. To find form's location and size.

NB.* setBuffLen: set buffer length=number of lines to buffer in var CUMOUT
NB. before writing to file FNM.
setBuffLen=: 3 : 0
  if. 0={.0$y do. BUFLEN=: y end.
  if. 0>4!:0 <'BUFLEN' do. BUFLEN=: 100 end.
)

initLogFl=: 3 : 0
  NB.* initLogFl: set up log file; pick new name for today's file if none spec'd.
  if. 0>4!:0 <'FNM' do.
    FNM=: todayfile y
  end.
)

initWin=: 3 : 0
  NB.* initWin: initialize message window.
  '' initWin y
  :
  initLogFl ''
  if. DISPLAY do.
    if. -.('status',LF)-:wd 'qp' do.      NB. Need to initialize window?
      if. 0 e. $x do. titleStr=. 'Log@',FNM
      else. titleStr=. x end.
      titleStr initStatusWin ' '        NB. Avoid moving or resizing
    end.                                  NB.  programmatically after this.
  end.
)

initLog=: 3 : 0
  NB.* initLog: initialize log file if necessary.
  initLogFl ''
  if. 0>4!:0 <'CUMOUT' do.             NB. Initialize cumulative log var if
    CUMOUT=: '[Logfile=',FNM,']'     NB.  necessary.
    CUMOUT=: ,<CUMOUT,' at ',(showdate ''),']'
    (;CUMOUT,&.><CRLF) 1!:3 <FNM
    CUMOUT=: ''
  end.                                 NB. Accumulate output, last lines
  if. 0=L. CUMOUT do. CUMOUT=: ,<CUMOUT end.
)

flushLog=: 3 : 0
  NB.* flushLog: write all text to log file and empty the cumulative output.
  initWin '' [ initLog ''
  (deepDisclose CUMOUT) 1!:3 <FNM
  (CRLF,~'Log flushed: ',showdate '') 1!:3 <FNM
  [CUMOUT=: ''
)

closeLog=: 3 : 0
  NB.* closeLog: write remaining text to log file, clean up vars, close window.
  if. 0=4!:0 <'CUMOUT' do. if. 0~:#CUMOUT do. flushLog '' end. end.
  4!:55 'CUMOUT';<'FNM'
  wd 'reset'
)

todayfile=: 3 : 0
  NB.* todayfile: Create unique file name based on today's date.
  if. 0=#y do. y=. 'OUT' end.
  type=. 4{.(y-.' '),4$'_'       NB. 4-letter filename prefix
  tmpdir=. getTempDir ''
  letts=. '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_$'
  dtix=. ((($letts),10)#:{.TS),1 2{TS=. qts ''
  flnm=. tmpdir,type,(dtix{letts),'.LOG'
)

lastlines=: 3 : 0
  NB.* lastlines: return only last x lines from message y (text vec w/EOL
  NB. chars).
  8 lastlines y   NB. 8 lines should fit in 12-pt, 175 pixels high window.
  :
  numlns=. -x
  if. 0=L. msg=. y do.
    msg=. txtEOL2Lns y
  end.
  msg=. ;txtEOL2Lns&.>deepDisclose&.>msg
  msg=. (numlns>.-#msg){.msg
  lens=. ;#&.>msg
  msg=. ((LINELEN<.lens){.&.>msg),&.>(LINELEN<lens)#&.><'...'
  msg=. (+./\0~:;#&.>msg-.&.>' ')#msg  NB. Remove leading blank lines.
  msg=. (-#CRLF)}.;msg,&.><CRLF        NB. Convert back to EOL-delimited chars.
)

NB.* txtEOL2Lns: text delimited by end-of-lines chars -> vec of text vecs.
txtEOL2Lns=: 3 : '<;._1 ((LF~:{.y)#LF),y=. (|.+./\|.y~:LF)#y=. y-.CR'

deepDisclose=: 3 : 0
  NB.* deepDisclose: disclose enclose arrays, to simplest level->simple text vec
  NB. with CRLF end-of-line char delimiters.
  if. 0=L. y do. ,((0~:#y)#CRLF),"1~":y
  else.
    ;deepDisclose&.>y
  end.
)

NB.* pickFontSz: pick 10 or 12 point font size depending on ratio of
NB. screen units to pixels.  The values below were picked by trial-and-error.
pickFontSz=: 3 : 0
  scrnum=. 0.1 <.0.5+({:".wd 'qchildxywhx s0')%{:".wd 'qchildxywh s0'
  closest=. 0 i.~ /:|2 2.5-scrnum NB. See which ratio is closer to.
  closest{12 10                   NB. Closer to 2 for 12-pt, 2.5 for 10-pt.
)

NB. Six general utilities that should reside in a separate script but are
NB. here for completeness.

NB.* getTempPath: MS Windows API returns designated temporary file dir.
getTempPath=: 'GetTempPath' win32api

NB.* getTempDir: get name of temporary directory.
getTempDir=: 3 : 0
  if. 0>4!:0 <'TMPDIR' do.
    td=. >2{getTempPath 256;256$' '
    td=. td{.~td i. 0{a.
  end.
)

NB.* showdate: show given, or current if arg '', date & time in standard form.
NB. Bug: can show 60 in seconds position because rounded to nearest second and
NB. carrying because of rounding gets too complicated.
showdate=: 3 : 0
  y=. ,y                        NB. Must be vector.
  if. 0=#y do. y=. 6!:0 '' end. NB. Arg is timestamp: YYYY MM DD hh mm ss
  dt=. }:;(2 lead0s&.>":&.>3{.y),&.>'/'
  if. 3=#y do. tm=. '' else.
    tm=. }:;(2 lead0s&.>":&.>3}.y),&.>':' NB. Leading 0s
  end.
  dt,((0~:#tm)#' '),tm
  NB.EG showdate 1959 5 24 8 9 0
  NB.EG showdate ''                  NB. Current date and time
  NB.EG >}.<;._1 ' ',showdate ''     NB. Time only
  NB.EG showdate 1992 12 16          NB. Date only
)

qts=: 3 : 0
  NB.* qts: like {quad}TS: return current timestamp.
  6!:0 ''
)

NB.* lead0s: precede integer y with up to x leading zeros.
lead0s=: 4 : '(-x>.$,":y){.(x$''0''),(]`":@.(0={.0$y))y'

wait=: wait_base_=: 3 : '6!:3 y'

NB.* exampleUses: examples of different ways to log messages.
exampleUses=: 0 : 0
NB. Basic:
   logMsg_logger_ 'This line should print in a small gray window in the'
   logMsg_logger_ 'lower-right corner of the screen; also, this message'
   logMsg_logger_ 'gets logged to a file, the name of which is displayed'
   logMsg_logger_ 'on the title-bar of the message window.'
   wait 5                          NB. Give chance to read messages.

   logMsg_logger_ 'Lines that are too long to fit completely into the output window will be elided'
   logMsg_logger_ 'in the window (after BUFLEN chars) but not in the log file.'
   flushLog_logger_ ''             NB. Write CUMOUT to file.
   wait 5                          NB. Give chance to read messages.

   logMsg_logger_ 'Deeply nested arrays';<' are shown very ',:' simply by'
   logMsg_logger_ 'flattening them and turning everything into text';<i. 2 2 3
   wait 5                          NB. Give chance to see message.
   flushLog_logger_ ''             NB. Flush to file to clear out CUMOUT for
                                   NB.  next demo about turning off DISPLAY.
NB. Turn off display: write to logfile without displaying message.
   DISPLAY_logger_=: 0
   logMsg_logger_ 'This message will not appear in window but will get logged.'
   wait 5                          NB. Give chance to see lack of message.

NB. If changing the logfile, be sure to close and re-init the window (or the
NB. title on it will misleadingly refer to the old logfile.)  Alternately,
NB. globally assign the file name "FNM_logger_" before using any log functions.
   DISPLAY_logger_=: 1 [ closeLog_logger_ ''
   FNM_logger_=: 'C:\annoyingRootLevel.log'
   initWin_logger_ ''
   logMsg_logger_ 'This gets logged to a non-default file: ',FNM_logger_,'.'
   wait 5                          NB. Give chance to read message
   closeLog_logger_ ''
)
