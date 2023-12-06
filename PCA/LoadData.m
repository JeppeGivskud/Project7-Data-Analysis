%% Outline
% Principal component analysis for Beer sensory analysis
% This program loads a file called RawDataCombined.csv. 
% The beernames are picked from column two only appending when a name is unique. 
% The attributes names are picked from row 1 column 3 till end 

clear all
close all
clc
%
[BeerData,delimiterOut,headerlinesOut]=importdata("RawDataCombined.csv",',',1);

% Takes unique data from columns or rows and converts that array to string
Participants=string(unique(BeerData.textdata(2:end,1),'stable'));
BeerNames=string(unique(BeerData.textdata(2:end,2),'stable'));
AttributeNames=string(BeerData.textdata(1,3:end));
IDs=string(unique(BeerData.textdata(1:end,2),'stable'));

