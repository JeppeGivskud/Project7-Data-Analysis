%Car ratings
Car_names=["Audi 100" "BMW 5 series" "Citroen AX" "Ferrari" "Fiat Uno" "Ford Fiesta" "Hyundai" "Jaguar" "Lada Samara" "Mazda 323" "Mercedes 200" "Mitsubishi Galant" "Nissan Sunny" "Opel Corsa" "Opel Vectra" "Peugeot 306" "Renault 19" "Rover" "Toyota Corolla" "Trabant 601" "VW Golf " "VW Passat" "Wartburg 1.3" ];
Attributes=["Economy" "Service" "Value" "Price" "Design" "Sport" "Safety" "Easy_handling"];
cars=[
3.9 2.8 2.2 4.2 3.0 3.1 2.4 2.8
4.8 1.6 1.9 5.0 2.0 2.5 1.6 2.8
3.0 3.8 3.8 2.7 4.0 4.4 4.0 2.6
5.3 2.9 2.2 5.9 1.7 1.1 3.3 4.3
2.1 3.9 4.0 2.6 4.5 4.4 4.4 2.2
2.3 3.1 3.4 2.6 3.2 3.3 3.6 2.8
2.5 3.4 3.2 2.2 3.3 3.3 3.3 2.4
4.6 2.4 1.6 5.5 1.3 1.6 2.8 3.6
3.2 3.9 4.3 2.0 4.3 4.5 4.7 2.9
2.6 3.3 3.7 2.8 3.7 3.0 3.7 3.1
4.1 1.7 1.8 4.6 2.4 3.2 1.4 2.4
3.2 2.9 3.2 3.5 3.1 3.1 2.9 2.6
2.6 3.3 3.9 2.1 3.5 3.9 3.8 2.4
2.2 2.4 3.0 2.6 3.2 4.0 2.9 2.4
3.1 2.6 2.3 3.6 2.8 2.9 2.4 2.4
2.9 3.5 3.6 2.8 3.2 3.8 3.2 2.6
2.7 3.3 3.4 3.0 3.1 3.4 3.0 2.7
3.9 2.8 2.6 4.0 2.6 3.0 3.2 3.0
2.5 2.9 3.4 3.0 3.2 3.1 3.2 2.8
3.6 4.7 5.5 1.5 4.1 5.8 5.9 3.1
3.8 2.3 1.9 4.2 3.1 3.6 1.6 2.4
3.1 2.2 2.1 3.2 3.5 3.5 2.8 1.8
3.7 4.7 5.5 1.7 4.8 5.2 5.5 4.0
];

%Reverse the scores so low->high and high->low (i.e. 6 becomes 1)
cars=7-cars;

%Eigenvalue analyse:
    correlation_matrix=corr(cars);
    %Calculate eigenvalues
        eigenvalues=eig(correlation_matrix);
    
    %Plot Scree-plot of eigenvalues (sorted from large to small)
        plot([1:length(eigenvalues)],flipud(sort(eigenvalues)));
        xlabel('Factors');
        ylabel('Eigenvalues');

%Faktor analyse - No rotate
        [Loadings, SpecVar, Rotation, stats, scores]=factoran(cars,2,'rotate','none');
    
    %Bi plot - non rotation
    biplotnorotate = biplot(Loadings,"VarLabels",Attributes,"Scores",scores)
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
