function MiningFSEOF(Tfseof,nFSEOF,nRxnSub)

excelObject = actxserver('Excel.Application');
FSEOFoutput = './OutputFiles/Stacked_FSEOF.xlsx';
fullFileName = fullfile(pwd, FSEOFoutput);
excelWorkbook = excelObject.workbooks.Open(fullFileName);
excelObject.Visible = true;
 
getNames = string(nRxnSub(:,1));
getSubsyst = string(nRxnSub(:,2));
IndeX1 = 0;
Idx = size(Tfseof,1);
IDs{Idx,4} = [];
RxnNames{Idx,4} = [];
Fluxes = zeros(Idx,4);

for iFSEOF = 1:4 %Iterations for the four scenarios evaluated
    iiFSEOF = iFSEOF-1;
    IndeX1 = IndeX1 + 2 + iFSEOF - iiFSEOF;
    IndeX2 = IndeX1 + 1;
    IndeX3 = IndeX1 + 2;
    Max_flux = Tfseof(:,IndeX2);
    Min_flux = Tfseof(:,IndeX3);
    Product_MinMax = Max_flux.*Min_flux;

    for iiiFSEOF = 1:size(Tfseof,1) %Conditions to fulfill for selecting reactions (that flux was increased after FSEOF and that reaction direction was not changed)
        if (Tfseof(iiiFSEOF,2)) >= ((Tfseof(iiiFSEOF,IndeX1))) || (Product_MinMax(iiiFSEOF)) < 0
            continue
        else
            Name = getNames(iiiFSEOF); %Obtain name of reaction that fulfill FSEOF criteria 
            RxnNames{iiiFSEOF,iFSEOF} = Name; %Create vector with selected reaction names 
            Subsys = getSubsyst(iiiFSEOF); %Obtain name of subsystem (for previous corresponding reaction) that fulfill FSEOF criteria
            IDs{iiiFSEOF,iFSEOF} = Subsys; %Create vector with selected subsystem names
            Flux = Tfseof(iiiFSEOF,IndeX1); %Obtain flux value of corresponding reaction that fulfill FSEOF criteria
            Fluxes(iiiFSEOF,iFSEOF) = Flux; %Create vector with selected flux values
            
            %(Tfseof(iiiFSEOF,2)) < (Tfseof(iiiFSEOF,IndeX1))> 0 && ((Product_MinMax(iiiFSEOF)) >= 0)
                    
                %((Tfseof(iiiFSEOF,2)) < 0)  && ((Tfseof(iiiFSEOF,IndeX1)) > (Tfseof(iiiFSEOF,2))) && ((Product_MinMax(iiiFSEOF)) >= 0)
                %(Tfseof(iiiFSEOF,2)) > 0 && (Tfseof(iiiFSEOF,IndeX1))> (Tfseof(iiiFSEOF,2)) == 0 && ((Product_MinMax(iiiFSEOF)) >= 0)
                 
                    
        end
    end
end

% Generate histograms for the selected data for each scenario
FSEOFscenarioA = IDs(:,1); %Select data corresponding to FSEOF scenario 1 (LBF overexpression)
FSEOFscenarioB = IDs(:,2); %Select data corresponding to FSEOF scenario 2 (SACPD overexpression)
FSEOFscenarioC = IDs(:,3); %Select data corresponding to FSEOF scenario 3 (LBF&SACPD overexpression)
FSEOFscenarioD = IDs(:,4); %Select data corresponding to FSEOF scenario 4 (LBF&SACPD overexpression + beta-Oxidation knockout)
scenarioA1 = FSEOFscenarioA(~any(cellfun(@isempty, FSEOFscenarioA),2), :); %Eliminate empty spaces from vector
scenarioB1 = FSEOFscenarioB(~any(cellfun(@isempty, FSEOFscenarioB),2), :);
scenarioC1 = FSEOFscenarioC(~any(cellfun(@isempty, FSEOFscenarioC),2), :);
scenarioD1 = FSEOFscenarioD(~any(cellfun(@isempty, FSEOFscenarioD),2), :);
[count1,bin1] = hist(categorical(cellstr(scenarioA1))); %Histogram FSEOF scenario 1 (LBF overexpression)
[count2,bin2] = hist(categorical(cellstr(scenarioB1))); %Histogram FSEOF scenario 2 (SACPD overexpression)
[count3,bin3] = hist(categorical(cellstr(scenarioC1))); %Histogram FSEOF scenario 3 (LBF&SACPD overexpression)
[count4,bin4] = hist(categorical(cellstr(scenarioD1))); %Histogram FSEOF scenario 4 (LBF&SACPD overexpression + beta-Oxidation knockout)


% Get data for stacked graphs
xAxis = {};
yAxis = [];
Index2 = [];
Index3 = [];
Index4 = [];
Index5 = [];
Index6 = [];
Index7 = [];
Index8 = [];
Index9 = [];
Index10 = [];
Index11 = [];
Index12 = [];
if isempty(bin1) == 0
    for iFSEOF2 = 1:length(bin1)
        indX = bin1(1,iFSEOF2); %get element to search for coincidences in arrays of bin 2-4
        getCount1 = count1(1,iFSEOF2); % get number of events Count 1
        Index1 = find(strcmp(bin2, indX)); % get index of matching data in array of bin 2
        if isempty(Index1) == 0
            getCount2 = count2(1,Index1); % get number of events for Count 2
            if isempty(getCount2) == 0
                Index2 = [Index2; iFSEOF2]; % Index vector for eliminating common elements in Count 1
                Index3 = [Index3; Index1]; % Index vector for eliminating common elements in Count 2
                xAxis = [xAxis; indX]; %create new vectors with matching values subsystem
                yAxis = [yAxis; getCount1, getCount2, 0, 0]; %create new vectors with matching values pairwise
            else
                getCount2 = 0;
            end
            Index4 = find(strcmp(bin3, indX)); % get index of matching data in array of bin 3
            getCount3 = count3(1,Index4); % get number of events for Count 3
            if isempty(getCount3) == 0
                Index5 = [Index5; Index4];
                yAxis(end,3) = getCount3; % Add values of Count 3 to previously created vector
            else
                getCount3 = 0;
            end
            Index12 = find(strcmp(bin4, indX)); % get index of matching data in array of bin 3
            getCount4 = count4(1,Index12); % get number of events for Count 4
            if isempty(getCount4) == 0
                Index6 = [Index6; Index12];
                yAxis(end,4) = getCount4; % Add values of Count 4 to previously created vector
            else
                getCount4 = 0;
            end
        end
    end
    count1(Index2) = []; % erase matching values in count 1
    bin1(Index2) = []; % erase matching values in bin 1
    count2(Index3) = []; % erase matching values in count 2
    bin2(Index3) = []; % erase matching values in bin 2
    count3(Index5) = []; % erase matching values in count 3
    bin3(Index5) = []; % erase matching values in bin 3
    count4(Index6) = []; % erase matching values in count 4
    bin4(Index6) = []; % erase matching values in bin 4
    xAxis = [xAxis; bin1']; % concatenate created vector with non-matching elements of Bin 1
    Ta1(1:length(count1),1:4) = zeros;
    Ta1(1:end,1) = count1';
    yAxis1 = vertcat(yAxis, Ta1); % concatenate created vector with non-matching elements of Count 1



    % Find matching elements in Count 2-4
    for iiFSEOF2 = 1:length(bin2)
        indX1 = bin2(1,iiFSEOF2);
        getCount2 = count2(1,iiFSEOF2);
        Index1 = find(strcmp(bin3, indX1));
        if isempty(Index1) == 0
            getCount3 = count3(1,Index1);
            xAxis = [xAxis; indX1];
            yAxis1 = [yAxis1; 0, getCount2, getCount3, 0];
            Index7 = [Index7; iiFSEOF2];
            Index8 = [Index8; Index1];
        else
            getCount3 = 0;
        end
        Index2 = find(strcmp(bin4, indX1));
        getCount4 = count4(1,Index2);
        if isempty(getCount4) == 0
            Index9 = [Index9; Index2];
            yAxis(end,4) = getCount4; % Add values of Count 4 to previously created vector
        else
            getCount4 = 0;
        end
    end
    count2(Index7) = [];
    bin2(Index7) = [];
    count3(Index8) = [];
    bin3(Index8) = [];
    count4(Index9) = [];
    bin4(Index9) = [];
    xAxis = [xAxis; bin2'];
    Tb = length(count2);
    Ta2 = zeros(Tb,4);
    Ta2(1:end,2) = count2';
    yAxis2 = vertcat(yAxis1, Ta2);


% Find matching elements in Count 3-4
    for iiiFSEOF2 = 1:length(bin3)
        indX1 = bin3(1,iiiFSEOF2);
        getCount3 = count3(1,iiiFSEOF2);
        Index2 = find(strcmp(bin4, indX1));
        if isempty(Index2) == 0
            getCount4 = count4(1,Index2);
            xAxis = [xAxis; indX1];
            yAxis2 = [yAxis2; 0, 0, getCount3, getCount4];
            Index10 = [Index10; iiiFSEOF2];
            Index11 = [Index11; Index2];
        end
    end

    count3(Index10) = [];
    bin3(Index10) = [];
    count4(Index11) = [];
    bin4(Index11) = [];
    xAxis = [xAxis; bin3'; bin4'];
    Tb = length(count3);
    Ta3 = zeros(Tb,4);
    Ta3(1:end,3) = count3';
    yAxis3 = vertcat(yAxis2, Ta3);
    Tb = length(count4);
    Ta4 = zeros(Tb,4);
    Ta4(1:end,4) = count4';
    yAxis4 = vertcat(yAxis3, Ta4);
    wT = {xAxis,yAxis4};
    wT2 = cell2table(wT);
end

% Group subsystems into functional categories
for iFSEOF3 = 1:7 %The subsystems are grouped into 7 functional categories
    FCcompile = [];
    pathFSEOFcategory = './InputFiles/FSEOFunctionalCategoryList.xlsx';
    if iFSEOF3 == 1
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 2
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 3
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 4
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 5
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 6
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    elseif iFSEOF3 == 7
        [~,FClist2] = xlsread(pathFSEOFcategory,iFSEOF3);
    end

   for iiFSEOF3 = 1:length(FClist2)
       MyCellArray = FClist2(iiFSEOF3,1);
       getIndex = find(strcmp(wT2{1,1}{:},MyCellArray));
       getCountAll = wT2{1,2}{1}(getIndex,:);
       if isempty(getCountAll) == 1
           getCountAll = [0 0 0 0];
       end
       
       if size(getCountAll,1) > 1
           FCr = sum(getCountAll);
           FCcompile(iiFSEOF3,1:4) = FCr;
       else
           FCcompile(iiFSEOF3,1:4) = getCountAll;
       end
   end

   if iFSEOF3 == 1
       AAsMetabolism = FCcompile;
   elseif iFSEOF3 == 2
       CentralMetabolism = FCcompile;
   elseif iFSEOF3 == 3
       CofactorsMetabolism = FCcompile;
   elseif iFSEOF3 == 4 
       LipidMetabolism = FCcompile;
   elseif iFSEOF3 == 5
       NutrientAssimilation = FCcompile;
   elseif iFSEOF3 == 6
       OtherRxnsBiomass = FCcompile;
   elseif iFSEOF3 == 7
       Transport_Exch = FCcompile;
   end 
end

if nFSEOF == 1
    excelWorkbook.ActiveSheet.Range('C154:F189').Formula = AAsMetabolism;
    excelWorkbook.ActiveSheet.Range('C14:F22').Formula = CentralMetabolism;
    excelWorkbook.ActiveSheet.Range('C103:F119').Formula = CofactorsMetabolism;
    excelWorkbook.ActiveSheet.Range('C57:F68').Formula = LipidMetabolism;
    excelWorkbook.ActiveSheet.Range('C270:F273').Formula = NutrientAssimilation;
    excelWorkbook.ActiveSheet.Range('C224:F235').Formula = OtherRxnsBiomass;
    excelWorkbook.ActiveSheet.Range('C310:F313').Formula = Transport_Exch;

elseif nFSEOF == 2
    excelWorkbook.ActiveSheet.Range('G154:J189').Formula = AAsMetabolism;
    excelWorkbook.ActiveSheet.Range('G14:J22').Formula = CentralMetabolism;
    excelWorkbook.ActiveSheet.Range('G103:J119').Formula = CofactorsMetabolism;
    excelWorkbook.ActiveSheet.Range('G57:J68').Formula = LipidMetabolism;
    excelWorkbook.ActiveSheet.Range('G270:J273').Formula = NutrientAssimilation;
    excelWorkbook.ActiveSheet.Range('G224:J235').Formula = OtherRxnsBiomass;
    excelWorkbook.ActiveSheet.Range('G310:J313').Formula = Transport_Exch;

elseif nFSEOF == 3
    excelWorkbook.ActiveSheet.Range('K154:N189').Formula = AAsMetabolism;
    excelWorkbook.ActiveSheet.Range('K14:N22').Formula = CentralMetabolism;
    excelWorkbook.ActiveSheet.Range('K103:N119').Formula = CofactorsMetabolism;
    excelWorkbook.ActiveSheet.Range('K57:N68').Formula = LipidMetabolism;
    excelWorkbook.ActiveSheet.Range('K270:N273').Formula = NutrientAssimilation;
    excelWorkbook.ActiveSheet.Range('K224:N235').Formula = OtherRxnsBiomass;
    excelWorkbook.ActiveSheet.Range('K310:N313').Formula = Transport_Exch;
end

excelWorkbook.Save;
excelWorkbook.Close;
excelObject.Quit;
end