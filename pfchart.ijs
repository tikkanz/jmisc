require 'files dates tables/csv'

pfchartrgs=: 3 : 0

NB. constants (should be input by user instead?):
nBox=. 150    NB. size of charting box (related to nMaxRows below))
nRevBoxes=. 3    NB. number of boxes needed for reversal
nMaxColumns=. 125
nMaxRows=. 50    NB. this can affect value of "nBox" if calculated by formula
nShowDate=. 1    NB. flag to display dates or not

NB. initialize variables:
nBoxHigh=. 0
nBoxLow=. 0
nHigh=. 0
nLow=. 0
nClose=. 0
nNewHigh=. 0
nNewLow=. 0
nCurrCol=. 0
sColType=. 1
sSymbol=. 'OX'
nLastMonthPlotted=. 0
nLastYearPlotted=. 0
nYr=. 0
nMn=. 0
sMonth=. ''
nRowOffset=. 0

if. nShowDate do.
  nRowOffset=. 4  NB. 4 extra rows needed for 4 vertical digits of year
  nMaxRows=. nMaxRows + nRowOffset
end.

sChart=. (nMaxRows,nMaxColumns) $ ' '    NB. chart array

NB. read in (Yahoo) market data file and cull out date/high/low/close values:
NB. bMktData=. readcsv (jpath '~user\data\DJI-r-pf.csv')
'bHdr bMktData'=. split readcsv jpath '~home\downloads\table(2).csv'
bMktData=. |. bMktData
bDate=.  getdate"1 > 0 {"1 bMktData   NB. column 0 is date (format: yyyy-mm-dd)
'bHigh bLow bClose'=. <"1 |: makenum 2 3 4 {"1 bMktData
NB. two ways chart range might be done --
NB.   (1) look for max and min of prices (nBox = (max-min)/boxsize),
NB. or
NB.   (2) take first price and calculate range of 50% higher
NB.       and 50% lower

NB. for testing purposes (DJIA 2007-2008):
nChartLow=. 7000
nChartHigh=. 14500    NB. midpoint = 10750, nBox = 150

for_i. i. <:#bMktData do.

  'nYr nMn nDy'=.  i { bDate
  sMonth=. (<:nMn) { '123456789abc'

  nHigh=.  (i { bHigh) - nChartLow
  nLow=.   (i { bLow)  - nChartLow
  nClose=. (i { bClose) - nChartLow

  if. (nChartHigh < (i { bHigh)) +. nLow < 0 do.
    sChart=. |. sChart
    smoutput 'Data for ',(": i { bDate),' exceeded chart range'
    return.
  end.

  NB. (initialize starting point of chart in the first column)
  NB. is this the first entry?
  if. i = 0 do.

    sColType=. nClose >: ((nHigh - nLow) % 2)
NB.    nOldVal=. 
    nNewLow=. nBoxHigh=. <. (nLow % nBox)
    nBoxLow=. nNewHigh=. <. (nHigh % nBox)
    b=. i. >: (<. nHigh % nBox) - (<. nLow % nBox)
    NB.      sColType (< (nRowOffset + nBoxLow - b);nCurrCol) } sChart
    sChart=. sColType (< (nRowOffset + nBoxHigh + b);nCurrCol) } sChart 

    if. nShowDate *. nYr ~: nLastYearPlotted do.
        sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart        
        nLastYearPlotted=. nYr
    end.

  else.    NB. the following is the normal (i.e., non-first) procedure:

    NB. convert prices to boxes:
    nNewHigh=. <. (nHigh % nBox)
    nNewLow=. <. (nLow % nBox)


    if. sColType -: 'X' do. NB. currently upward?

      if. nNewHigh < nBoxHigh do. NB. new high?

        b=. 1 + i. nNewHigh-nBoxHigh
        sChart=. sColType (< (nBoxHigh+b+nRowOffset);nCurrCol) } sChart

        if. nShowDate *. nMn ~: nLastMonthPlotted do.
          sChart=. sMonth (< (nBoxHigh+1+nRowOffset);nCurrCol) } sChart
          nLastMonthPlotted=. nMn
          if. (nMn = 1) *. nYr ~: nLastYearPlotted do.
            sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
            nLastYearPlotted=. nYr
          end.
        end.
        nBoxHigh=. nNewHigh
        nBoxLow=. nBoxHigh - 1    NB. for drawing purposes, 1 box below highest 'X'

      NB. no new high, so test for downside reversal:
      elseif. nRevBoxes <: nBoxHigh - nNewLow do.

        if. nCurrCol < nMaxColumns-1 do.
          nCurrCol=. >: nCurrCol
        else.
          sChart=. |. sChart
          return.
        end.
        sColType=. 'O'  NB. nOCol
        b=. i. >: nBoxLow-nNewLow
        sChart=. sColType (< ((nBoxLow-b)+nRowOffset);nCurrCol) } sChart

        if. nShowDate *. nMn ~: nLastMonthPlotted do.
          sChart=. sMonth (< ((nBoxLow-2)+nRowOffset);nCurrCol) } sChart
          nLastMonthPlotted=. nMn
          if. (nMn = 1) *. nYr ~: nLastYearPlotted do.
            sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
            nLastYearPlotted=. nYr
          end.
        end.
        nBoxLow=. nNewLow
        nBoxHigh=. nBoxLow + 1    NB. for drawing purposes, 1 box above lowest 'O'

      end.


    else. NB. current direction downward (sColType is 'O')

      if. nBoxLow < nNewLow do.  NB. new low?

        b=. >: i. nBoxLow-nNewLow
        sChart=. sColType (< ((nBoxLow-b)+nRowOffset);nCurrCol) } sChart

        if. nShowDate *. nMn ~: nLastMonthPlotted do.
          sChart=. sMonth (< ((nBoxLow-1)+nRowOffset);nCurrCol) } sChart
          nLastMonthPlotted=. nMn
          if. (nMn = 1) *. nYr ~: nLastYearPlotted do.
            sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
            nLastYearPlotted=. nYr
          end.
        end.
        nBoxLow=. nNewLow
        nBoxHigh=. nBoxLow + 1    NB. for drawing purposes, 1 box above lowest 'O'

      NB. no new low, so test for upside reversal:
      elseif. nRevBoxes <: nNewHigh - nBoxLow do.

        if. nCurrCol < nMaxColumns-1 do.
          nCurrCol=. >: nCurrCol
        else.
          sChart=. |. sChart
          return.
        end.
        sColType=. 'X' NB. nXCol
        b=. i. >: nNewHigh-nBoxHigh
        sChart=. sColType (< (nBoxHigh+b+nRowOffset);nCurrCol) } sChart

        if. nShowDate *. nMn ~: nLastMonthPlotted do.
          sChart=. sMonth (< (nBoxHigh+2+nRowOffset);nCurrCol) } sChart
          nLastMonthPlotted=. nMn
          if. (nMn = 1) *. nYr ~: nLastYearPlotted do.
            sChart=. (":nYr) (< (i.-nRowOffset);nCurrCol) } sChart
            nLastYearPlotted=. nYr
          end.
        end.
        nBoxHigh=. nNewHigh
        nBoxLow=. nBoxHigh - 1    NB. for drawing purposes, 1 box below highest 'X'

      end.

    end. NB. O/X loop

  end. NB. "first/rest" loop

end.  NB. "for" loop

NB. flip chart array so that smallest coords are at lower left
NB. rather than at upper left:
sChart=. |. sChart
)

NB. #################################################################
