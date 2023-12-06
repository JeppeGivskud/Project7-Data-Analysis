%Eigenvalue analyse:
    correlation_matrix=corr(AllMeans);
    %Calculate eigenvalues
        eigenvalues=eig(full(correlation_matrix));
    
    %Plot Scree-plot of eigenvalues (sorted from large to small)
        plot([1:length(eigenvalues)],flipud(sort(eigenvalues)));
        xlabel('Factors');
        ylabel('Eigenvalues');
        grid on 
        xlim([1 10])
        xticks(1:1:10)

        %%
%Faktor analyse - No rotate
        [Loadings, SpecVar, Rotation, stats, scores]=factoran(AllMeans,2,'rotate','none');
    
    %Bi plot - non rotation
    biplotnorotate = biplot(Loadings,"VarLabels",AttributeNames,"Scores",scores)
            xlabel('Factor 1');
            ylabel('Factor 2');
            zlabel('Factor 3');
    %Find en scaling factor for car 4
        %bil 4 i "bi-plottet" 0.40124
        %bil 4 i "scores" 1.21980993217158
    scaling_factor= 0.40124/1.21980993217158;
    scaled_Scores=scaling_factor*scores;
     for i = 1:length(BeerNames)
     text (scaled_Scores(i,1), scaled_Scores(i,2), Car_names(i))
     end

%%
%Faktor analyse -  rotate
        [VarimaxLoadings, SpecVar, Rotation, stats, scores]=factoran(cars,2,'rotate','varimax');
    
    %Bi plot -  rotation
    biplotVarimaxrotate = biplot(VarimaxLoadings,"VarLabels",Attributes,"Scores",scores);
            xlabel('Factor 1');
            ylabel('Factor 2');
            zlabel('Factor 3');
    %Find en scaling factor for car 4
        %bil 4 i "bi-plottet" 0.40124
        %bil 4 i "scores" 1.21980993217158
    scaling_factor= 0.40124/1.21980993217158;
    scaled_Scores=scaling_factor*scores;
     for i = 1:23
     text (scaled_Scores(i,1), scaled_Scores(i,2), Car_names(i))
     end

%Faktor analyse -  oblique rotation
        [PromaxLoadings, SpecVar, Rotation, stats, scores]=factoran(cars,2,'rotate','promax');
    
    %Bi plot -  oblique rotation
    biplotPromaxrotate = biplot(PromaxLoadings,"VarLabels",Attributes,"Scores",scores);
            xlabel('Factor 1');
            ylabel('Factor 2');
            zlabel('Factor 3');
    %Find en scaling factor for car 4
        %bil 4 i "bi-plottet" 0.40124
        %bil 4 i "scores" 1.21980993217158
    scaling_factor= 0.40444/1.21980993217158;
    scaled_Scores=scaling_factor*scores;
     for i = 1:23
     text (scaled_Scores(i,1), scaled_Scores(i,2), Car_names(i))
     end

Car_names
