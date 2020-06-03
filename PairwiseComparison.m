function PairwiseComparison(Tpwc, Sub_list)
texto = string(Sub_list);
getSubsystem = texto(1:end,1); %create column vector with subsystems data
compile1 = [];
compile2 = [];
compile3 = [];
for iPWC = 1:size(Tpwc,1) % Pairwise comparison gSuc-gMix
    ind1 = Tpwc(iPWC,2);
    ind2 = Tpwc(iPWC,1);
    ind3 = Tpwc(iPWC,4);
    ind4 = Tpwc(iPWC,3);
    if (ind1 < ind4) || (ind2 > ind3)
        indice = 1;
    else
        indice = 0;
    end
    Subsys = getSubsystem(iPWC);
    Subsystem{iPWC,:} = Subsys;
    Pairwise1(iPWC,:) = indice;
end
    
for iPWC2 = 1:size(Tpwc,1) % Pairwise comparison gSuc-gGly
    ind1 = Tpwc(iPWC2,2);
    ind2 = Tpwc(iPWC2,1);
    ind3 = Tpwc(iPWC2,6);
    ind4 = Tpwc(iPWC2,5);
    if (ind1 < ind4) || (ind2 > ind3)
        indice = 1;
    else
        indice = 0;
    end
    Pairwise2(iPWC2,:) = indice;
end
    
for iPWC3 = 1:size(Tpwc,1) % Pairwise comparison gMix-gGly
    ind1 = Tpwc(iPWC3,4);
    ind2 = Tpwc(iPWC3,3);
    ind3 = Tpwc(iPWC3,6);
    ind4 = Tpwc(iPWC3,5);
    if (ind1 < ind4) || (ind2 > ind3)
        indice = 1;
    else
        indice = 0;
    end
    Pairwise3(iPWC3,:) = indice;
end
sub = cellstr(Subsystem);
n = length(Pairwise1);
T = table(sub, Pairwise1, Pairwise2, Pairwise3);
T.sub = categorical(T.sub);
T{1:n,5} = sum(T{1:n,2:4},2);

for iPWC4 = 1:size(T,1)
    MyIndex = T{iPWC4,5};
    if MyIndex == 1
        getPairwise = T{iPWC4,1};
        getSubsystem = cellstr(getPairwise);
        compile1 = [compile1; getSubsystem, MyIndex];
    elseif MyIndex == 2
            getPairwise = T{iPWC4,1};
            getSubsystem = cellstr(getPairwise);
            compile2 = [compile2; getSubsystem, MyIndex];
    elseif MyIndex == 3
                getPairwise = T{iPWC4,1};
                getSubsystem = cellstr(getPairwise);
                compile3 = [compile3; getSubsystem, MyIndex];
    else
        continue
    end
end

% Generate histograms
if isempty(compile1) == 0
    TPairwise1 = categorical(compile1(1:end,1));
    [count1,bin1] = hist(TPairwise1);
else
    disp('No single pairwise comparison found');
    bin1 = {};
    count1 = [];
end

if isempty(compile2) == 0
    TPairwise2 = categorical(compile2(1:end,1));
    [count2,bin2] = hist(TPairwise2);
else
    disp('No two pairwise comparison found');
end
if isempty(compile3) == 0
    TPairwise3 = categorical(compile3(1:end,1));
    [count3,bin3] = hist(TPairwise3);
else
    disp('No three pairwise comparison found');
end

% Get data for stacked graphs
x = {};
y = [];
Index3 = [];
Index4 = [];
Index5 = [];
Index6 = [];
Index7 = [];
if isempty(bin1) == 0
    for iPWC5 = 1:length(bin1)
        indX = bin1(1,iPWC5); %get index to search for coincidences in arrays of bin 2-3
        getCount1 = count1(1,iPWC5); % get number of events for pairwise 1
        
        Index1 = find(strcmp(bin2, indX)); % get index of matching data in array of bin 2
        if isempty(Index1) == 0
            getCount2 = count2(1,Index1); % get number of events for pairwise 2
            Index4 = [Index4; Index1];
            x = [x; indX]; %create new vectors with matching values subsystem
            y = [y; getCount1, getCount2, 0]; %create new vectors with matching values pairwise
        else
            getCount2 = 0;
            x = [x; indX]; %create new vectors with matching values subsystem
            y = [y; getCount1, getCount2, 0]; %create new vectors with matching values pairwise
        end
        
        Index2 = find(strcmp(bin3, indX)); % get index of matching data in array of bin 3
        getCount3 = count3(1,Index2); % get number of events for pairwise 3
        if isempty(getCount3) == 0
            Index5 = [Index5; Index2];
            y(end,3) = getCount3; % Add values of Pairwise 3 to previously created vector
        else
            getCount3 = 0;
            y(end,3) = getCount3; % Add values of Pairwise 3 to previously created vector
        end
    end
    count2(Index4) = []; % erase matching values in count 2
    bin2(Index4) = []; % erase matching values in bin 2
    count3(Index5) = []; % erase matching values in count 3
    bin3(Index5) = []; % erase matching values in bin 3
    
    for iiPWC = 1:length(bin2)
        indX1 = bin2(1,iiPWC);
        getCount2 = count2(1,iiPWC);
        Index2 = find(strcmp(bin3, indX1));
        if isempty(Index2) == 0
            getCount3 = count3(1,Index2);
            x = [x; indX1];
            y = [y; 0, getCount2, getCount3];
            Index7 = [Index7; Index2];
        else
            getCount3 = 0;
            x = [x; indX1];
            y = [y; 0, getCount2, getCount3];
        end
    end
    
    count3(Index7) = [];
    bin3(Index7) = [];
    x = [x; bin3'];
    b = length(count3);
    a1 = zeros(b,3);
    a1(1:end,3) = count3';
    y2 = vertcat(y, a1);   
end
        
% Plot results in a stacked bar graph
x1 = categorical(x);
figure(3);
bar(x1,y2, 'stacked')
ylabel('No. Reactions');
legend({'Single pairwise comparison (S-PWC)','Two pairwise comparison (Two-PWC)','Three pairwise comparison (Three-PWC)'});
        
%Create inlay figure
x2 = categorical({'Overlapping';'S-PWC';'Two-PWC';'Three-PWC'});
TPairw1 = sum(y2(:,1));
TPairw2 = sum(y2(:,2));
TPairw3 = sum(y2(:,3));
y4 = [(size(Tpwc,1)-(TPairw1+TPairw2+TPairw3)); TPairw1; TPairw2; TPairw3];

barColorMap(1,:) = [0.4660 0.6740 0.1880];  % Green Color for segment 1.
barColorMap(2,:) = [0.3010 0.7450 0.9330];  % Blue Color for segment 2.
barColorMap(3,:) = [.9290 .6940 .1250];  % Red Color for segment 3.
barColorMap(4,:) = [0.4940 0.1840 0.5560];  % Yellow Color for segment 4.

axes('position',[0.7 0.7 0.2 0.2]);
box on

for iiPWC6 = 1:length(x2)
    barSeries = bar(x2(iiPWC6),y4(iiPWC6));
    set(barSeries, 'FaceColor', barColorMap(iiPWC6,:));
    hold on;
end
ax = get(barSeries,'Parent');
set(ax,'XTickMode','auto');
set(gca,'XTickLabelRotation',0)
box off
end