% A factor analysis is similar to the PCA with the bonus of getting to
% interpret what underlying factors are unfluenced by the attributes and
% naming these factors. This analysis will check if the data is fit for
% % analysis with attributes having all correlations above 0.8 being
% removed and with the Kaiser-Meyer-Olkin Measure of Sampling Adequacy KMO
% test

LoadData
CalculateMeans

%Eigenvalue analyse:
correlation_matrix=corr(AllMeans);
kmo(correlation_matrix)

fprintf("\nFactor analysis is not suitable \nWe will try a rotated PCA to gain some insight into the components even though we can't really interpret them")