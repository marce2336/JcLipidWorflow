function LipidNetworkWorkflow
initCobraToolbox()
fileName = [];
model = [];
supportedFileExtensions = {'*.xml;*.sbml;*.sto;*.xls;*.xlsx;*.mat'};
[filepath,~,~] = fileparts(mfilename('fullpath'));
while isempty(fileName) == 1 
    disp('Enter a model: ');
    [fileName, pathName] = uigetfile([supportedFileExtensions, {'Model Files'}], 'Please select the model file');
    
    if isempty(model) == 1
        cd(pathName)
        model = readCbModel(fileName);
        cd(filepath);
        A = model;
        break
    end
end
   
% Calculate GAM and NGAM values
prompt = 'Enter number of conditions to evaluate [1-3] '; % Select number of growth conditions to analyze
conditions = input(prompt);
prompt = 'Perform NGAM calculations? Y/N [Y]: ';
performNGAM = input(prompt,'s');
if isempty(performNGAM)
    performNGAM = 'Y';
end

if performNGAM == 'Y' || performNGAM == 'y'
    for nNGAM = 1:conditions
        if nNGAM == 1 % Obtain data for NGAM calculation growth condition 1 (gSuc)
            pathNGAM = './InputFiles/NGAMConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathNGAM,1); %Obtain lower bound constrains
            gCondition1 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathNGAM,2); %Obtain upper bound constrains
            gCondition1 = changeRxnBounds(gCondition1, rxnNameList, value, 'u'); %Change upper bounds
            gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM'); %Change objective
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
            Trc_cond1 = T;
            fillNGAMtable(nNGAM,T);
        elseif nNGAM == 2 % Obtain data for NGAM calculation growth condition 2 (gMix)
            pathNGAM = './InputFiles/NGAMConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathNGAM,3); %Obtain lower bound constrains
            gCondition2 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathNGAM,4); %Obtain upper bound constrains
            gCondition2 = changeRxnBounds(gCondition2, rxnNameList, value, 'u'); %Change upper bounds
            gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM'); %Change objective
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
            Trc_cond2 = T;
            fillNGAMtable(nNGAM,T);
        elseif nNGAM == 3 % Obtain data for NGAM calculation growth condition 3 (gGly)
            pathNGAM = './InputFiles/NGAMConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathNGAM,5); %Obtain lower bound constrains
            gCondition3 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathNGAM,6); %Obtain upper bound constrains
            gCondition3 = changeRxnBounds(gCondition3, rxnNameList, value, 'u'); %Change upper bounds
            gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM'); %Change objective
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
            Trc_cond3 = T;
            fillNGAMtable(nNGAM,T);
        end
    end
end

% Calculate Reductant-per-cellular compartment
prompt = 'Perform Reductant-per-compartment calculations? Y/N [Y]: ';
performRedCalc = input(prompt,'s');
if isempty(performRedCalc)
    performRedCalc = 'Y';
end
if performRedCalc == 'Y' || performRedCalc == 'y'
    for nRedCalc = 1:conditions
        if nRedCalc == 1 % Obtain data for NGAM calculation growth condition 1 (gSuc)
            if exist('Trc_cond1','var') == 1
                CalculateReductant(Trc_cond1,nRedCalc);
            else
                pathNGAM = './InputFiles/NGAMConstrains.xlsx';
                [value,rxnNameList] = xlsread(pathNGAM,1); %Obtain lower bound constrain
                gCondition1 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
                [value,rxnNameList] = xlsread(pathNGAM,2); %Obtain upper bound constrain
                gCondition1 = changeRxnBounds(gCondition1, rxnNameList, value, 'u'); %Change upper bounds
                gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM'); %Change objective to optimize biomass growth
                [MinimizedFlux]= minimizeModelFlux(gCondition1);
                T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
                Trc_cond1 = T;
                CalculateReductant(Trc_cond1,nRedCalc);
            end
            
        elseif nRedCalc == 2 % Obtain data for NGAM calculation growth condition 2 (gMix)
            if exist('Trc_cond2','var') == 1
                CalculateReductant(Trc_cond2,nRedCalc);
            else
                pathNGAM = './InputFiles/NGAMConstrains.xlsx';
                [value,rxnNameList] = xlsread(pathNGAM,3); %Obtain lower bound constrains
                gCondition2 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
                [value,rxnNameList] = xlsread(pathNGAM,4); %Obtain upper bound constrain
                gCondition2 = changeRxnBounds(gCondition2, rxnNameList, value, 'u'); %Change upper bounds
                gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM'); %Change objective to optimize biomass growth
                [MinimizedFlux]= minimizeModelFlux(gCondition2);
                T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
                Trc_cond2 = T;
                CalculateReductant(Trc_cond2,nRedCalc);
            end
            
        elseif nRedCalc == 3 % Obtain data for NGAM calculation growth condition 3 (gGly)
            if exist('Trc_cond3','var') == 1
                CalculateReductant(Trc_cond3,nRedCalc);
            else
                pathNGAM = './InputFiles/NGAMConstrains.xlsx';
                [value,rxnNameList] = xlsread(pathNGAM,5); %Obtain lower bound constrains
                gCondition3 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
                [value,rxnNameList] = xlsread(pathNGAM,6); %Obtain upper bound constrain
                gCondition3 = changeRxnBounds(gCondition3, rxnNameList, value, 'u'); %Change upper bounds
                gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM'); %Change objective to optimize biomass growth
                [MinimizedFlux]= minimizeModelFlux(gCondition3);
                T = table({A.rxns,MinimizedFlux.x(1:length(A.rxns),1)});
                Trc_cond3 = T;
                CalculateReductant(Trc_cond3,nRedCalc);
            end
        end
    end
end

% Calculate Flux bound reduction and Pairwise comparison
prompt = 'Perform calculation of flux bound reduction and pwc? Y/N [Y]: ';
boundReduction = input(prompt,'s');
if isempty(boundReduction)
    boundReduction = 'Y';
end
if boundReduction == 'Y' || boundReduction == 'y'
    for nBoundR = 1:conditions
        if nBoundR == 1
            pathREDC = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathREDC,1); %Obtain lower bound constrain
            gCondition1 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathREDC,2); %Obtain upper bound constrain
            valuewKFP = value(:,1);
            gCondition1 = changeRxnBounds(gCondition1, rxnNameList, valuewKFP, 'u'); %Change upper bounds
            gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM'); %Change objective to optimize biomass growth
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            Tcond1wKFP = [minFlux,maxFlux];
            valueNoKFP = value(:,2);
            gCondition1 = changeRxnBounds(gCondition1, rxnNameList, valueNoKFP, 'u'); %Change upper bounds
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            Tcond1noKFP = [minFlux,maxFlux];
        elseif nBoundR == 2
            pathREDC = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathREDC,3); %Obtain lower bound constrain
            gCondition2 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathREDC,4); %Obtain upper bound constrain
            valuewKFP = value(:,1);
            gCondition2 = changeRxnBounds(gCondition2, rxnNameList, valuewKFP, 'u'); %Change upper bounds
            gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM'); %Change objective to optimize biomass growth
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            Tcond2wKFP = [minFlux,maxFlux];
            valueNoKFP = value(:,2);
            gCondition2 = changeRxnBounds(gCondition2, rxnNameList, valueNoKFP, 'u'); %Change upper bounds
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            Tcond2noKFP = [minFlux,maxFlux];
        elseif nBoundR == 3
            pathREDC = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathREDC,5); %Obtain lower bound constrain
            gCondition3 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathREDC,6); %Obtain upper bound constrain
            valuewKFP = value(:,1);
            gCondition3 = changeRxnBounds(gCondition3, rxnNameList, valuewKFP, 'u'); %Change upper bounds
            gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM'); %Change objective to optimize biomass growth
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            Tcond3wKFP = [minFlux,maxFlux];
            valueNoKFP = value(:,2);
            gCondition3 = changeRxnBounds(gCondition3, rxnNameList, valueNoKFP, 'u'); %Change upper bounds
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            Tcond3noKFP = [minFlux,maxFlux];
        end
    end
    TfluxBound = [Tcond1wKFP,Tcond1noKFP,Tcond2wKFP,Tcond2noKFP,Tcond3wKFP,Tcond3noKFP];
    FluxBoundReduction(TfluxBound);
    Tpwc = [Tcond1wKFP,Tcond2wKFP,Tcond3wKFP];
    SubsystemList = A.subSystems;
    PairwiseComparison(Tpwc, SubsystemList);
end

% Perform Flux Scanning based on Enforced Objective Function (FSEOF)
prompt = 'Perform FSEOF? Y/N/Q[quit] [Y]: ';
performFSEOF = input(prompt,'s');
if isempty(performFSEOF)
    performFSEOF = 'Y';
end
if performFSEOF == 'Q'
    return;
end
if performFSEOF == 'Y' || performFSEOF == 'y'
    for nFSEOF = 1:conditions
        if nFSEOF == 1
            %Obtain reference flux distribution
            pathFSEOF = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathFSEOF,1); %Obtain lower bound constrains
            gCondition1 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathFSEOF,2); %Obtain upper bound constrains
            valuewKFP = value(:,1);
            gCondition1 = changeRxnBounds(gCondition1, rxnNameList, valuewKFP, 'u');
            gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM'); %Change objective to biomass optimization
            SolutiongCondition1 = optimizeCbModel(gCondition1,'max',0,true); % Obtain predicted optimal biomass production rate
            x = SolutiongCondition1.f;
            gCondition1 = changeRxnBounds(gCondition1, 'BIOMASS_Jc_Glcw_GAM', x, 'l'); 
            gCondition1 = changeRxnBounds(gCondition1, 'BIOMASS_Jc_Glcw_GAM', x, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            Tref1 = [zeros(length(A.rxns),1),MinimizedFlux.x(1:length(A.rxns),1)]; % reference flux distribution condition 1
            Tref1(end+2,:) = 0;

            
            %Obtain theoretical maximum for Reaction 1 (LBF) and Reaction 2 (SACPD), followed by flux
            %minimization and FVA
            gCondition1 = addExchangeRxn(gCondition1, {'18c1acyl_d[d]'}); % Add exchange reaction for product of Reaction 2 (SACPD)
            gCondition1 = addExchangeRxn(gCondition1, {'LBglc_c[c]'}); % Add exchange reaction for product of Reaction 1 (LBF)
            gCondition1 = changeObjective(gCondition1, 'LBF_Glc'); %Change objective to maximize product of Reaction 1 (LBF_Glc)
            SolutiongCondition1 = optimizeCbModel(gCondition1,'max',0,true); %Find theoretical maximum for product of Reaction 1 (LBF)
            LBFmax = SolutiongCondition1.f; %Theoretical maximum for product of Reaction 1 (LBF_Glc)
            gCondition1 = changeObjective(gCondition1, 'SACPD'); %Change objective o maximize product of Reaction 2 (SACPD)
            SolutiongCondition1 = optimizeCbModel(gCondition1,'max',0,true); % find theoretical maximum for product of Reaction 2 (SACPD)
            SACPDmax = SolutiongCondition1.f; %Theoretical maximum for product of Reaction 2 (SACPD)
            
            % Obtain theoretical maximum for LBF & SACPD: perform Pareto optimality analysis for two objective
            % functions by simultaneously optimizing the two mentioned reactions
            gCondition1 = changeObjective(gCondition1, 'BIOMASS_Jc_Glcw_GAM'); %Change objective to default conditions
            figure(4);
            [ParetoFrontier] = computeParetoOptimality(A,'LBF_Glc','SACPD')
            prompt = 'Select the flux values from the Pareto front by entering the row number: '; %Choose flux values for the two reactions from the Pareto front
            nParetoFront = input(prompt);
            if isempty(nParetoFront)
                prompt = 'Please enter the row number: ';
                nParetoFront = input(prompt);
            end
            LBF_SACPDmax = ParetoFrontier(nParetoFront+1,2:3);
            LBFpareto = LBF_SACPDmax{1,1};
            SACPDpareto = LBF_SACPDmax{1,2};
            format short g 
            
            % Flux minimization and FVA analysis
            gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', LBFmax, 'l'); %Constrain Reaction 1 (LBF) to theoretical maximum
            gCondition1 = changeRxnBounds(gCondition1, 'BIOMASS_Jc_Glcw_GAM', 1000, 'u'); %Remove constrain in upper bound of biomass reaction
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            LBF2 = LBFmax;
            prompt = 'Choose assign a value to n for feasible flux distribution iteration [< 0.05]: ';
            nFFD = input(prompt); % Value assigned to n during the iterations to find a feasible flux distribution
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduce the LBF value at each iteration
                gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', LBF2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition1);
            end
            TminimizedLBF = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 1 (LBF)
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            TfvaLBF = [minFlux,maxFlux]; % Flux vector FVA Reaction 1 (LBF)
            
            gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', 0, 'l'); %Constrain lower bound of Reaction 1 (LBF) to 0
            gCondition1 = changeRxnBounds(gCondition1, 'SACPD', SACPDmax, 'l'); %Constrain Reaction 2 (SACPD) to its theoretical maximum
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractSACPD = SACPD2*nFFD; 
                SACPD2 = SACPD2-SubtractSACPD; %Reduce the SACPD value at each iteration
                gCondition1 = changeRxnBounds(gCondition1, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition1);
            end
            TminimizedSACPD = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 2 (SACPD)
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            TfvaSACPD = [minFlux,maxFlux]; % Flux vector FVA Reaction 2 (SACPD)
            
            gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', LBFmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            gCondition1 = changeRxnBounds(gCondition1, 'SACPD', SACPDmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            LBF2 = LBFmax;
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduce the LBF value at each iteration
                SubtractSACPD = SACPD2*nFFD;
                SACPD2 = SACPD2-SubtractSACPD; %Reduce the SACPD value at each iteration
                gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', LBF2, 'l');
                gCondition1 = changeRxnBounds(gCondition1, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition1);
            end
            Tminimized_Rxns1_2 = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization for LBF&SACPD combined overexpression
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            Tfva_Rxns1_2 = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined analysis
            
            % Perform beta-Oxidation knockout
            [value,rxnNameList] = xlsread(pathFSEOF,2); %Obtain upper bound constrains
            valuewKFP = value(:,3);
            gCondition1 = changeRxnBounds(gCondition1, rxnNameList, valuewKFP, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition1);
            LBFKout = LBFpareto;
            SACPDKout = SACPDpareto;
            
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBFKout*nFFD; 
                LBFKout = LBFKout-SubtractLBF; %Reduction of 5% the LBF value at each iteration
                SubtractSACPD = SACPDKout*nFFD;
                SACPDKout = SACPDKout-SubtractSACPD; %Reduction of 5% the SACPD value at each iteration
                gCondition1 = changeRxnBounds(gCondition1, 'LBF_Glc', LBFKout, 'l');
                gCondition1 = changeRxnBounds(gCondition1, 'SACPD', SACPDKout, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition1);
            end
            
            Tminimized_Kout = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux minimization for LBF&SACPD combined with beta-Oxidation knockout
            [minFlux, maxFlux] = fluxVariability(gCondition1,100,'max');
            T_Kout = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined with beta-Oxidation knockout
            
            Tfseof_Condition1 = [Tref1,TminimizedLBF,TfvaLBF,TminimizedSACPD,TfvaSACPD,Tminimized_Rxns1_2,Tfva_Rxns1_2,Tminimized_Kout,T_Kout];
            FSEOFsubSystemsList = [gCondition1.rxns,gCondition1.subSystems];
            MiningFSEOF(Tfseof_Condition1,nFSEOF,FSEOFsubSystemsList);
        end
        
        if nFSEOF == 2
            %Obtain reference flux distribution
            pathFSEOF = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathFSEOF,3); %Obtain lower bound constrains
            gCondition2 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathFSEOF,4); %Obtain upper bound constrains
            valuewKFP = value(:,1);
            gCondition2 = changeRxnBounds(gCondition2, rxnNameList, valuewKFP, 'u');
            gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM'); %Change objective to biomass optimization
            SolutiongCondition2 = optimizeCbModel(gCondition2,'max',0,true); % Obtain predicted optimal biomass production rate
            x = SolutiongCondition2.f;
            gCondition2 = changeRxnBounds(gCondition2, 'BIOMASS_Jc_Gly90w_GAM', x, 'l'); 
            gCondition2 = changeRxnBounds(gCondition2, 'BIOMASS_Jc_Gly90w_GAM', x, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            Tref1 = [zeros(length(A.rxns),1),MinimizedFlux.x(1:length(A.rxns),1)]; % reference flux distribution condition 2
            Tref1(end+2,:) = 0;

            
            %Obtain theoretical maximum for Reaction 1 (LBF) and Reaction 2 (SACPD), followed by flux
            %minimization and FVA
            gCondition2 = addExchangeRxn(gCondition2, {'18c1acyl_d[d]'}); % Add exchange reaction for product of Reaction 2 (SACPD)
            gCondition2 = addExchangeRxn(gCondition2, {'LBgly90_c[c]'}); % Add exchange reaction for product of Reaction 1 (LBF)
            gCondition2 = changeObjective(gCondition2, 'LBF_Gly90'); %Change objective to maximize product of Reaction 1 (LBF_Gly90)
            SolutiongCondition2 = optimizeCbModel(gCondition2,'max',0,true); %Find theoretical maximum for product of Reaction 1 (LBF)
            LBFmax = SolutiongCondition2.f; %Theoretical maximum for product of Reaction 1 (LBF_Gly90)
            gCondition2 = changeObjective(gCondition2, 'SACPD'); %Change objective o maximize product of Reaction 2 (SACPD)
            SolutiongCondition2 = optimizeCbModel(gCondition2,'max',0,true); % find theoretical maximum for product of Reaction 2 (SACPD)
            SACPDmax = SolutiongCondition2.f; %Theoretical maximum for product of Reaction 2 (SACPD)
            
            % Obtain theoretical maximum for LBF & SACPD: perform Pareto optimality analysis for two objective
            % functions by simultaneously optimizing the two mentioned reactions
            gCondition2 = changeObjective(gCondition2, 'BIOMASS_Jc_Gly90w_GAM'); %Change objective to default conditions
            figure(5);
            [ParetoFrontier] = computeParetoOptimality(gCondition2,'LBF_Gly90','SACPD')
            prompt = 'Select the flux values from the Pareto front by entering the row number: '; %Choose flux values for the two reactions from the Pareto front
            nParetoFront = input(prompt);
            if isempty(nParetoFront)
                prompt = 'Please enter the row number: ';
                nParetoFront = input(prompt);
            end
            LBF_SACPDmax = ParetoFrontier(nParetoFront+1,2:3);
            LBFpareto = LBF_SACPDmax{1,1};
            SACPDpareto = LBF_SACPDmax{1,2};
            format short g 
            
            % Flux minimization and FVA analysis
            gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', LBFmax, 'l'); %Constrain Reaction 1 (LBF) to its theoretical maximum
            gCondition2 = changeRxnBounds(gCondition2, 'BIOMASS_Jc_Gly90w_GAM', 1000, 'u'); %Remove constrain in upper bound of biomass reaction
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            LBF2 = LBFmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduce 1% the LBF value at each iteration
                gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', LBF2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition2);
            end
            TminimizedLBF = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 1 (LBF)
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            TfvaLBF = [minFlux,maxFlux]; % Flux vector FVA Reaction 1 (LBF)
            
            gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', 0, 'l'); %Constrain lower bound of Reaction 1 (LBF) to 0
            gCondition2 = changeRxnBounds(gCondition2, 'SACPD', SACPDmax, 'l'); %Constrain Reaction 2 (SACPD) to its theoretical maximum
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractSACPD = SACPD2*nFFD; 
                SACPD2 = SACPD2-SubtractSACPD; %Reduce 1% the SACPD value at each iteration
                gCondition2 = changeRxnBounds(gCondition2, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition2);
            end
            TminimizedSACPD = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 2 (SACPD)
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            TfvaSACPD = [minFlux,maxFlux]; % Flux vector FVA Reaction 2 (SACPD)
            
            gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', LBFmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            gCondition2 = changeRxnBounds(gCondition2, 'SACPD', SACPDmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            LBF2 = LBFmax;
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduction of 1% the LBF value at each iteration
                SubtractSACPD = SACPD2*nFFD;
                SACPD2 = SACPD2-SubtractSACPD; %Reduction of 1% the SACPD value at each iteration
                gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', LBF2, 'l');
                gCondition2 = changeRxnBounds(gCondition2, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition2);
            end
            Tminimized_Rxns1_2 = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization for LBF&SACPD combined overexpression
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            Tfva_Rxns1_2 = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined analysis
            
            % Perform beta-Oxidation knockout
            [value,rxnNameList] = xlsread(pathFSEOF,4); %Obtain upper bound constrains
            valuewKFP = value(:,3);
            gCondition2 = changeRxnBounds(gCondition2, rxnNameList, valuewKFP, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition2);
            LBFKout = LBFpareto;
            SACPDKout = SACPDpareto;
            
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBFKout*nFFD; 
                LBFKout = LBFKout-SubtractLBF; %Reduction of 5% the LBF value at each iteration
                SubtractSACPD = SACPDKout*nFFD;
                SACPDKout = SACPDKout-SubtractSACPD; %Reduction of 5% the SACPD value at each iteration
                gCondition2 = changeRxnBounds(gCondition2, 'LBF_Gly90', LBFKout, 'l');
                gCondition2 = changeRxnBounds(gCondition2, 'SACPD', SACPDKout, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition2);
            end
            
            Tminimized_Kout = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux minimization for LBF&SACPD combined with beta-Oxidation knockout
            [minFlux, maxFlux] = fluxVariability(gCondition2,100,'max');
            T_Kout = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined with beta-Oxidation knockout
            
            Tfseof_Condition2 = [Tref1,TminimizedLBF,TfvaLBF,TminimizedSACPD,TfvaSACPD,Tminimized_Rxns1_2,Tfva_Rxns1_2,Tminimized_Kout,T_Kout];
            FSEOFsubSystemsList = [gCondition2.rxns,gCondition2.subSystems];
            MiningFSEOF(Tfseof_Condition2,nFSEOF,FSEOFsubSystemsList);
        end
        
        if nFSEOF == 3
            %Obtain reference flux distribution
            pathFSEOF = './InputFiles/FluxBoundConstrains.xlsx';
            [value,rxnNameList] = xlsread(pathFSEOF,5); %Obtain lower bound constrains
            gCondition3 = changeRxnBounds(A, rxnNameList, value, 'l'); %Change lower bounds
            [value,rxnNameList] = xlsread(pathFSEOF,6); %Obtain upper bound constrains
            valuewKFP = value(:,1);
            gCondition3 = changeRxnBounds(gCondition3, rxnNameList, valuewKFP, 'u');
            gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM'); %Change objective to biomass optimization
            SolutiongCondition3 = optimizeCbModel(gCondition3,'max',0,true); % Obtain predicted optimal biomass production rate
            x = SolutiongCondition3.f;
            gCondition3 = changeRxnBounds(gCondition3, 'BIOMASS_Jc_Gly100w_GAM', x, 'l'); 
            gCondition3 = changeRxnBounds(gCondition3, 'BIOMASS_Jc_Gly100w_GAM', x, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            Tref1 = [zeros(length(A.rxns),1),MinimizedFlux.x(1:length(A.rxns),1)]; % reference flux distribution condition 3
            Tref1(end+2,:) = 0;

            
            %Obtain theoretical maximum for Reaction 1 (LBF) and Reaction 2 (SACPD), followed by flux
            %minimization and FVA
            gCondition3 = addExchangeRxn(gCondition3, {'18c1acyl_d[d]'}); % Add exchange reaction for product of Reaction 2 (SACPD)
            gCondition3 = addExchangeRxn(gCondition3, {'LBgly100_c[c]'}); % Add exchange reaction for product of Reaction 1 (LBF)
            gCondition3 = changeObjective(gCondition3, 'LBF_Gly100'); %Change objective to maximize product of Reaction 1 (LBF_Gly100)
            SolutiongCondition3 = optimizeCbModel(gCondition3,'max',0,true); %Find theoretical maximum for product of Reaction 1 (LBF)
            LBFmax = SolutiongCondition3.f; %Theoretical maximum for product of Reaction 1 (LBF_Gly100)
            gCondition3 = changeObjective(gCondition3, 'SACPD'); %Change objective o maximize product of Reaction 2 (SACPD)
            SolutiongCondition3 = optimizeCbModel(gCondition3,'max',0,true); % find theoretical maximum for product of Reaction 2 (SACPD)
            SACPDmax = SolutiongCondition3.f; %Theoretical maximum for product of Reaction 2 (SACPD)
            
            % Obtain theoretical maximum for LBF & SACPD: perform Pareto optimality analysis for two objective
            % functions by simultaneously optimizing the two mentioned reactions
            gCondition3 = changeObjective(gCondition3, 'BIOMASS_Jc_Gly100w_GAM'); %Change objective to default conditions
            figure(6);
            [ParetoFrontier] = computeParetoOptimality(gCondition3,'LBF_Gly100','SACPD')
            prompt = 'Select the flux values from the Pareto front by entering the row number: '; %Choose flux values for the two reactions from the Pareto front
            nParetoFront = input(prompt);
            if isempty(nParetoFront)
                prompt = 'Please enter the row number: ';
                nParetoFront = input(prompt);
            end
            LBF_SACPDmax = ParetoFrontier(nParetoFront+1,2:3);
            LBFpareto = LBF_SACPDmax{1,1};
            SACPDpareto = LBF_SACPDmax{1,2};
            format short g 
            
            % Flux minimization and FVA analysis
            gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', LBFmax, 'l'); %Constrain Reaction 1 (LBF) to its theoretical maximum
            gCondition3 = changeRxnBounds(gCondition3, 'BIOMASS_Jc_Gly100w_GAM', 1000, 'u'); %Remove constrain in upper bound of biomass reaction
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            LBF2 = LBFmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduce 1% the LBF value at each iteration
                gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', LBF2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition3);
            end
            TminimizedLBF = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 1 (LBF)
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            TfvaLBF = [minFlux,maxFlux]; % Flux vector FVA Reaction 1 (LBF)
            
            gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', 0, 'l'); %Constrain lower bound of Reaction 1 (LBF) to 0
            gCondition3 = changeRxnBounds(gCondition3, 'SACPD', SACPDmax, 'l'); %Constrain Reaction 2 (SACPD) to its theoretical maximum
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF values to obtain feasible flux distribution
                SubtractSACPD = SACPD2*nFFD; 
                SACPD2 = SACPD2-SubtractSACPD; %Reduce 1% the SACPD value at each iteration
                gCondition3 = changeRxnBounds(gCondition3, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition3);
            end
            TminimizedSACPD = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization Reaction 2 (SACPD)
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            TfvaSACPD = [minFlux,maxFlux]; % Flux vector FVA Reaction 2 (SACPD)
            
            gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', LBFmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            gCondition3 = changeRxnBounds(gCondition3, 'SACPD', SACPDmax, 'l'); %Constrain lb for LBF&SACPD combined overexpression
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            LBF2 = LBFmax;
            SACPD2 = SACPDmax;
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBF2*nFFD; 
                LBF2 = LBF2-SubtractLBF; %Reduction of 1% the LBF value at each iteration
                SubtractSACPD = SACPD2*nFFD;
                SACPD2 = SACPD2-SubtractSACPD; %Reduction of 1% the SACPD value at each iteration
                gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', LBF2, 'l');
                gCondition3 = changeRxnBounds(gCondition3, 'SACPD', SACPD2, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition3);
            end
            Tminimized_Rxns1_2 = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux vector total sum minimization for LBF&SACPD combined overexpression
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            Tfva_Rxns1_2 = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined analysis
            
            % Perform beta-Oxidation knockout
            [value,rxnNameList] = xlsread(pathFSEOF,6); %Obtain upper bound constrains
            valuewKFP = value(:,3);
            gCondition3 = changeRxnBounds(gCondition3, rxnNameList, valuewKFP, 'u');
            [MinimizedFlux]= minimizeModelFlux(gCondition3);
            LBFKout = LBFpareto;
            SACPDKout = SACPDpareto;
            
            while isempty(MinimizedFlux.x) == 1 %Iteration loop to find LBF&SACPD values to obtain feasible flux distribution
                SubtractLBF = LBFKout*nFFD; 
                LBFKout = LBFKout-SubtractLBF; %Reduction of 5% the LBF value at each iteration
                SubtractSACPD = SACPDKout*nFFD;
                SACPDKout = SACPDKout-SubtractSACPD; %Reduction of 5% the SACPD value at each iteration
                gCondition3 = changeRxnBounds(gCondition3, 'LBF_Gly100', LBFKout, 'l');
                gCondition3 = changeRxnBounds(gCondition3, 'SACPD', SACPDKout, 'l');
                [MinimizedFlux]= minimizeModelFlux(gCondition3);
            end
            Tminimized_Kout = (MinimizedFlux.x(1:length(A.rxns)+2,1)); % Flux minimization for LBF&SACPD combined with beta-Oxidation knockout
            [minFlux, maxFlux] = fluxVariability(gCondition3,100,'max');
            T_Kout = [minFlux,maxFlux]; % Flux vector FVA for LBF&SACPD combined with beta-Oxidation knockout
            
            
            Tfseof_Condition3 = [Tref1,TminimizedLBF,TfvaLBF,TminimizedSACPD,TfvaSACPD,Tminimized_Rxns1_2,Tfva_Rxns1_2,Tminimized_Kout,T_Kout];
            FSEOFsubSystemsList = [gCondition3.rxns,gCondition3.subSystems];
            MiningFSEOF(Tfseof_Condition3,nFSEOF,FSEOFsubSystemsList);
        end
        
    end
end

end