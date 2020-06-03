function fillNGAMtable(nNGAM,T)
NGAMrxnList = './InputFiles/NGAMrxnList.txt';
fid = fopen(NGAMrxnList);
list1 = textscan(fid,'%s','delimiter',',');
fclose(fid);
list2 = list1{1};
rxnID = length(list2);
compile = [];
excelObject = actxserver('Excel.Application');
if nNGAM == 1
    NGAMfilloutput = './OutputFiles/Cofactor1.xlsx';
    fullFileName = fullfile(pwd, NGAMfilloutput);
elseif nNGAM == 2
    NGAMfilloutput = './OutputFiles/Cofactor2.xlsx';
    fullFileName = fullfile(pwd, NGAMfilloutput);
elseif nNGAM == 3
    NGAMfilloutput = './OutputFiles/Cofactor3.xlsx';
    fullFileName = fullfile(pwd, NGAMfilloutput);
end
excelWorkbook = excelObject.workbooks.Open(fullFileName);
excelObject.Visible = true;
for itNGAM = 1:rxnID
    MyCellArray = list2(itNGAM,1);
    MyIndex = find(strcmp(MyCellArray,T.Var1{1,1}(:)));
    getFlux = T.Var1{1,2}(MyIndex);
    if getFlux > 10
        getFlux = 0;
    end
    compile = [compile; getFlux];
end
excelWorkbook.ActiveSheet.Range('C117').Formula = sum(compile(1:3,1));
excelWorkbook.ActiveSheet.Range('C118').Formula = sum(compile(4:8,1));
excelWorkbook.ActiveSheet.Range('C119').Formula = sum(compile(9:11,1));
excelWorkbook.ActiveSheet.Range('C120').Formula = sum(compile(12:15,1));
MtAKD = ((compile(16,1)*2)+(compile(17,1)))/3;
excelWorkbook.ActiveSheet.Range('C124').Formula = MtAKD;
MtMDH = (sum(compile(18:19,1))/2);
excelWorkbook.ActiveSheet.Range('C125').Formula = MtMDH;
Anp = sum(compile(20:21,1));
excelWorkbook.ActiveSheet.Range('C126').Formula = Anp;
excelWorkbook.ActiveSheet.Range('C89').Formula = sum(compile(22:23,1));
excelWorkbook.ActiveSheet.Range('C90').Formula = sum(compile(24:25,1));
OAA_metab = sum(compile(26:27,1));
if (OAA_metab > Anp) && (Anp > 0)
    OAA_metab2 = (OAA_metab + Anp)/2;
    excelWorkbook.ActiveSheet.Range('C92').Formula = OAA_metab2;
else
    excelWorkbook.ActiveSheet.Range('C92').Formula = OAA_metab;
end
excelWorkbook.ActiveSheet.Range('C127').Formula = sum(compile(28:29,1));
excelWorkbook.ActiveSheet.Range('C121:C123').Formula = compile(30:32,1); 
excelWorkbook.ActiveSheet.Range('C128').Formula = compile(33,1);
excelWorkbook.ActiveSheet.Range('C54:C65').Formula = compile(34:45,1);
excelWorkbook.ActiveSheet.Range('C68:C87').Formula = compile(46:65,1);
excelWorkbook.ActiveSheet.Range('F91').Formula = sum(compile(66:67,1));
excelWorkbook.ActiveSheet.Range('E91').Formula = sum(compile(68:69,1));
excelWorkbook.ActiveSheet.Range('D91').Formula = sum(compile(70:87,1));
excelWorkbook.ActiveSheet.Range('F88').Formula = compile(88,1);
excelWorkbook.ActiveSheet.Range('D88').Formula = sum(compile(89:93,1));
excelWorkbook.ActiveSheet.Range('C67').Formula = sum(compile(94:96,1));
excelWorkbook.ActiveSheet.Range('C66').Formula = sum(compile(97:98,1));
excelWorkbook.ActiveSheet.Range('C93').Formula = sum(compile(99:102,1));
excelWorkbook.ActiveSheet.Range('C94').Formula = sum(compile(103:104,1));
excelWorkbook.ActiveSheet.Range('C95').Formula = compile(124,1);
excelWorkbook.ActiveSheet.Range('C129').Formula = sum(compile(105:123,1));
excelWorkbook.Save;
excelWorkbook.Close;
excelObject.Quit;
end