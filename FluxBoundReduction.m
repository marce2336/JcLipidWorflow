function FluxBoundReduction(Tfva)
min_gSucR = [];
max_gSucR = [];
min_gMixR = [];
max_gMixR = [];
min_gGlyR = [];
max_gGlyR = [];
for iFBR = 1:length(Tfva)
    min_gSuc = 100-(Tfva(iFBR,1)*100)/Tfva(iFBR,3);
    if min_gSuc > 0 && min_gSuc <= 100
        min_gSucR = [min_gSucR; min_gSuc];
    end
    max_gSuc = 100-(Tfva(iFBR,2)*100)/Tfva(iFBR,4);
    if max_gSuc > 0 && max_gSuc <= 100
        max_gSucR = [max_gSucR; max_gSuc];
    end
    min_gMix = 100-(Tfva(iFBR,5)*100)/Tfva(iFBR,7);
    if (min_gMix > 0) && (min_gMix <= 100)
        min_gMixR = [min_gMixR; min_gMix];
    end
    max_gMix = 100-(Tfva(iFBR,6)*100)/Tfva(iFBR,8);
    if (max_gMix > 0) && (max_gMix <= 100)
        max_gMixR = [max_gMixR; max_gMix];
    end
    min_gGly = 100-(Tfva(iFBR,9)*100)/Tfva(iFBR,11);
    if (min_gGly > 0) && (min_gGly <= 100)
        min_gGlyR = [min_gGlyR; min_gGly];
    end
    max_gGly = 100-(Tfva(iFBR,10)*100)/Tfva(iFBR,12);
    if (max_gGly > 0) && (max_gGly <= 100)
        max_gGlyR = [max_gGlyR; max_gGly];
    end
end
count_min_gSucR = hist(min_gSucR(1:length(min_gSucR),1),10);
count_max_gSucR = hist(max_gSucR(1:length(max_gSucR),1),10);
count_min_gMixR = hist(min_gMixR(1:length(min_gMixR),1),10);
count_max_gMixR = hist(max_gMixR(1:length(max_gMixR),1),10);
count_min_gGlyR = hist(min_gGlyR(1:length(min_gGlyR),1),10);
count_max_gGlyR = hist(max_gGlyR(1:length(max_gGlyR),1),10);

FBRx = categorical(["0-10"; "11-20"; "21-30"; "31-40"; "41-50"; "51-60"; "61-70"; "71-80"; "81-90"; "91-100"]);
y_min = [count_min_gSucR',count_min_gMixR',count_min_gGlyR'];
y_max = [count_max_gSucR',count_max_gMixR',count_max_gGlyR'];

figure(1);
Lower_bound = barh(FBRx,y_min);
xlabel('No. Reactions')
ylabel('% Reduction flux range lower bound')
legend({'gSuc','gMix','gGly'})

figure(2);
Upper_bound = barh(FBRx,y_max);
xlabel('No. Reactions')
ylabel('% Reduction flux range upper bound')
legend({'gSuc','gMix','gGly'})

end