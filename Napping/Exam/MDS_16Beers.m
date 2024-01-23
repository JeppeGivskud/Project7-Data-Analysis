% There is not a lot of documentation in this code... sorry. 
% But its just some basic multidimensional scaling functions and som plot parameters
clear
clc
T = readcell('16 Beers.xlsx','UseExcel',true,'Sheet','For Matlab');
Beernames=T(2:end,1);
Beernames=string(Beernames);

T=T(2:end,2:end);
T = cell2table(T);
T = table2array(T);


%% Create a scree plot
A = [0 0 0 0 0 0];
for c = 1:6
    [Y,stress1] = mdscale(T,c,'Start','random');

    %[Y1,stress1,eigvals1] = mdscale(T,p);
    A(c)=stress1;
end
fprintf('Stress for Test1: %.4f\n',A);
figure;
hold on

plot(A,'DisplayName','Collected Data')
xlabel('Dimensions')
ylabel('Stress')
title('Scree Plot 16 beers NaN values')
set(gca, 'xtick', 0:1:10);
set(gca, 'ytick', 0:0.02:10);
lgd = legend;
hold off

%% - Multidimensional scaling plot

[Y1,stress1] = mdscale(T,3,'Start','random')
figure;
plot3(Y1(:,1),Y1(:,2),Y1(:,3),'o');
hold on
for i=1:length(Y1)
    top = [Y1(i,1) Y1(i,2) Y1(i,3)];
    bottom = [Y1(i,1) Y1(i,2) -15];
    together = [top ; bottom];
    plot3(together(:,1),together(:,2),together(:,3),'--oblack')
    text(Y1(i,1), Y1(i,2), Y1(i,3),Beernames(i))

end
title("Multidimensional scaling of napping results");
%text(Y1(:,1)+1,Y1(:,2),Y1(:,3),Beernames)

%xlabel('Fruityness (Frugtighed) -->') %Dim1
%ylabel('<-- Power (Kraftighed)') %Dim2
%zlabel('Color (Farve)-->') %Dim3
grid on
axis([-30 30 -25 25 -15 20]);

hold off

%%
% Run a loop for a while
%for ii = 1:5000
   
    % Draw our plots
  %  drawnow;
  %  view(gca,[ii, 35]);

  %  pause(0.2)
    
%end
%%

%% Shepards plot for testing if the model is off from the original data
% straight line
x=0:50;
y=x

Test1_vector=squareform(T);
% Calculate pairwise distances from original data

% and make a Shepard plot of the results.
[Y,stress,disparities] = mdscale(Test1_vector,3,'Start','random');
distances = pdist(Y);
[dum,ord] = sortrows([disparities(:) Test1_vector(:)]);
figure;
hold on
%line([0 0],[50 50],'b--')
plot(Test1_vector,distances,'bo', ...
Test1_vector(ord),disparities(ord),'r.-');
plot(x,y,'m-')

xlabel('Dissimilarities'); ylabel('Distances/Disparities')
legend({'Distances' 'Disparities' 'x=y'},'Location','NW');
hold off
