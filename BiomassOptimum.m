function [xgSuc, xgMix, xgGly] = BiomassOptimum(A)
pathBopt = './InputFiles/FluxBoundConstrains.xlsx';
%Obtain optimum biomass Condition 1
[value,rxnNameList] = xlsread(pathBopt,1);
value1 = value(:,1);
gCondition1 = changeRxnBounds(A, rxnNameList, value1, 'l'); 
[value,rxnNameList] = xlsread(pathBopt,2); 
value2 = value(:,1);
gCondition1 = changeRxnBounds(gCondition1, rxnNameList, value2, 'u'); 
gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM');
SolutiongCondition1=optimizeCbModel(gCondition1,'max',0,true);
xgSuc = SolutiongCondition1.f;

%Obtain optimum biomass Condition 2
[value,rxnNameList] = xlsread(pathBopt,3);
value1 = value(:,1);
gCondition2 = changeRxnBounds(A, rxnNameList, value1, 'l');
[value,rxnNameList] = xlsread(pathBopt,4);
value2 = value(:,1);
gCondition2 = changeRxnBounds(gCondition2, rxnNameList, value2, 'u');
gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM');
SolutiongCondition2=optimizeCbModel(gCondition2,'max',0,true);
xgMix = SolutiongCondition2.f;

%Obtain optimum biomass Condition 3
[value,rxnNameList] = xlsread(pathBopt,5);
value1 = value(:,1);
gCondition3 = changeRxnBounds(A, rxnNameList, value1, 'l');
[value,rxnNameList] = xlsread(pathBopt,6);
value2 = value(:,1);
gCondition3 = changeRxnBounds(gCondition3, rxnNameList, value2, 'u');
gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM');
SolutiongCondition3=optimizeCbModel(gCondition3,'max',0,true);
xgGly = SolutiongCondition3.f;
end