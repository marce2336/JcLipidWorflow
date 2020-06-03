function CalculateReductant(Trc,nRedCalc)
RedCalcList = './InputFiles/List_rxnsRedox.txt';
fid = fopen(RedCalcList);
listRxnRd = textscan(fid,'%s','delimiter',',');
fclose(fid);
listRxnsReductant = listRxnRd{1};
compileRd1 = [];
compileRd2 = [];
compileRd3 = [];
excelObject = actxserver('Excel.Application');
RCoutput = './OutputFiles/ReductantCalculations.xlsx';
fullFileName = fullfile(pwd, RCoutput);
excelWorkbook = excelObject.workbooks.Open(fullFileName);
excelObject.Visible = true;
if nRedCalc == 1
    for iRd = 1:length(listRxnsReductant)
        MyCellArray = listRxnsReductant(iRd,1);
        MyIndex = find(strcmp(Trc{1,1}{1,1},MyCellArray));
        getFlux = Trc{1,1}{1,2}(MyIndex);
        compileRd1 = [compileRd1; getFlux];
    end
    MtMDH = (compileRd1(1,1)+compileRd1(2,1))/2;
    excelWorkbook.ActiveSheet.Range('D5').Formula = MtMDH;
    excelWorkbook.ActiveSheet.Range('D6:D11').Formula = compileRd1(3:8,1);
    excelWorkbook.ActiveSheet.Range('D35:D40').Formula = compileRd1(9:14,1);
    excelWorkbook.ActiveSheet.Range('D59:D65').Formula = compileRd1(15:21,1);
elseif nRedCalc == 2
    for iRd = 1:length(listRxnsReductant)
        MyCellArray = listRxnsReductant(iRd,1);
        MyIndex = find(strcmp(Trc{1,1}{1,1},MyCellArray));
        getFlux = Trc{1,1}{1,2}(MyIndex);
        compileRd2 = [compileRd2; getFlux];
    end
    MtMDH = (compileRd2(1,1)+compileRd2(2,1))/2;
    excelWorkbook.ActiveSheet.Range('F5').Formula = MtMDH;
    excelWorkbook.ActiveSheet.Range('F6:F11').Formula = compileRd2(3:8,1);
    excelWorkbook.ActiveSheet.Range('F35:F40').Formula = compileRd2(9:14,1);
    excelWorkbook.ActiveSheet.Range('F59:F65').Formula = compileRd2(15:21,1);
elseif nRedCalc == 3
    for iRd = 1:length(listRxnsReductant)
        MyCellArray = listRxnsReductant(iRd,1);
        MyIndex = find(strcmp(Trc{1,1}{1,1},MyCellArray));
        getFlux = Trc{1,1}{1,2}(MyIndex);
        compileRd3 = [compileRd3; getFlux];
    end
    MtMDH = (compileRd3(1,1)+compileRd3(2,1))/2;
    excelWorkbook.ActiveSheet.Range('H5').Formula = MtMDH;
    excelWorkbook.ActiveSheet.Range('H6:H11').Formula = compileRd3(3:8,1);
    excelWorkbook.ActiveSheet.Range('H35:H40').Formula = compileRd3(9:14,1);
    excelWorkbook.ActiveSheet.Range('H59:H65').Formula = compileRd3(15:21,1);
end
excelWorkbook.Save;
excelWorkbook.Close;
excelObject.Quit;
end