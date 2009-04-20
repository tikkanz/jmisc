require 'files dates tables/csv grid'

Note 'example'
  pfgrid pfchartrgs ''
)

pfgrid=: (2 2$'GRIDMARGIN';0 0 0 0;'GRIDZOOM';0.5) grid <"0

pfchartrgs=: 3 : 0
NB. constants (should be input by user instead):
nBox=. 150    NB. size of charting box (related to nMaxRows below))
nRev=. 3    NB. number of boxes needed for reversal
nMaxCols=. 125
nMaxRows=. 50    NB. this can affect value of "nBox" if calculated by formula
nShowDate=. 1    NB. flag to display dates or not
sFname=. jpath '~temp\DJIA20072008.csv'

NB. initialize variables:
nCurrCol=. 0
sSymb=. 'OX'
nLastMonthPlotted=. 0
nLastYearPlotted=. 0
nRowOffset=. 0

NB. 4 extra rows needed for 4 vertical digits of year
if. nShowDate do. nRowOffset=. 4 end.
nMaxRows=. nMaxRows + nRowOffset
sChart=. (nMaxRows,nMaxCols) $ ' '    NB. chart array

NB. read in (Yahoo) market data file and pull out date/high/low/close values:
'bHdr bMktData'=. split readcsv sFname
nDate=.  getdate"1 > (bHdr i. <'Date') {"1 bMktData   NB. column 0 is date (format: yyyy-mm-dd)
NB. if newest data always at top could just |. bMktData
nOrder=. /: nDate  NB. sort order
nDate=. nDate /: nOrder
nHighLow=. nOrder /:~ makenum (bHdr i. 'High';'Low') {"1 bMktData
nClose=. nOrder /:~ makenum (bHdr i. <'Close') {"1 bMktData  NB. only used for working out start direction
NB. could now erase bMktData to save space

NB. two ways chart range might be done --
NB.   (1) look for max and min of prices (nBox = (max-min)/boxsize),
NB. or
NB.   (2) take first price and calculate range of 50% higher
NB.       and 50% lower

NB. for testing purposes (DJIA 2007-2008):
nChartLow=. 7000
nChartHigh=. 14500    NB. midpoint = 10750, nBox = 150

for_i. i. #nDate do.
  'nYr nMn nDy'=.  i { nDate
  sMonth=. (<:nMn) { '123456789ABC'

  nLowHigh=.  |. i { nHighLow NB. reverse order so low is index 0

  assert. (nLowHigh < nChartHigh) *. nLowHigh > nChartLow
  NB.  smoutput 'Data for ',(": i { bDate),' exceeded chart range'
  nLowHigh=. nLowHigh - nChartLow

  NB. (initialize starting point of chart in the first column)
  if. i = 0 do.   NB. is this the first entry?
    nClose=. (i { nClose) - nChartLow
    nColType=. nClose >: -: --/ nLowHigh
    nLHBox=. <. nLowHigh % nBox

    b=. i. >: --/ nLHBox
    sChart=. (nColType{sSymb) (< (nRowOffset + b + {.nLHBox);nCurrCol) } sChart

    nOldVal=. nColType { nLHBox

    if. nShowDate do.
      sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
      nLastYearPlotted=. nYr
    end.

  else.    NB. the following is the normal (i.e., non-first) procedure:

    NB. convert prices to boxes:
    nLHBox=. <. nLowHigh % nBox
    nNewDiffs=. (-`+@.nColType) nLHBox - nOldVal

    NB. new high or low?
    if. nChg=. 1 <: ({.`{:@.nColType) nNewDiffs do.
      nNewVal=. nColType { nLHBox

    NB. no new high or low, so test for reversal:
    elseif. nChg=. nRev <: ({:`{.@.nColType) -nNewDiffs do.
      nCurrCol=. >: nCurrCol
      nColType=. -.nColType
      nNewVal=. nColType { nLHBox
    end.

    if. nChg do. NB. Does sChart need updating?
      NB. update Os & Xs
      b=. (* * >:@i.) nNewVal - nOldVal
      sChart=. (nColType{sSymb) (< (nRowOffset + nOldVal + b);nCurrCol) } sChart
      
      NB. update Dates if necessary
      if. nShowDate *. nMn ~: nLastMonthPlotted do.
        b=. nColType { _1 1
        sChart=. sMonth (< (nRowOffset + nOldVal + b);nCurrCol) } sChart
        nLastMonthPlotted=. nMn
        if. (nMn = 1) *. nYr ~: nLastYearPlotted do.
          sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
          nLastYearPlotted=. nYr
        end.
      end.

      nOldVal=. nNewVal
      nChg=.0
    end.

  end. NB. "first/rest" loop
end.  NB. "for" loop

NB. flip chart array so that smallest coords are at lower left
NB. rather than at upper left:
sChart=. |. sChart
)
