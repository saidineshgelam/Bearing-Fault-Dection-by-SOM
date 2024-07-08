%% SOM for Rotor-Bearing Diagnosis
% Created by Brian O'Malley
% University of Maryland-College Park
% 2024.04.09
%
% somtoolbox is required
% more information abuot the toolbox: http://www.cis.hut.fi/somtoolbox/
clc;clear;close
%% Load paths for SOM toolbox
addpath('F:\NOTES\Classes\Industrial AI\HW4\HW4\HW4\Useful Code\SOM-Toolbox-master\dijkstra');
addpath('F:\NOTES\Classes\Industrial AI\HW4\HW4\HW4\Useful Code\SOM-Toolbox-master\som');%

%% load the data
% load FeatMat_test.mat
% load FeatMat_train.mat

load FeatMat_train.mat
load FeatMat_test.mat
%using both 1st and 2nd harmonics for this one
% FeatMat_train(:,2) =FeatMat_train(:,1) ;
% FeatMat_test(:,2) = FeatMat_test(:,1) ;

%% Create SOM data structure
  sDBear = som_data_struct(FeatMat_train,'name','Rotor-Bearing',...
        			  'comp_names',{'1X','2X'});


%%


for i = 1:length(FeatMat_train)/3
    labelTrain{i} = 'Healthy';
    labelTrain{i+20} = 'Faulty1';
    labelTrain{i+40} = 'Faulty2';

end
%% Add labels to the data  
sDBear = som_label (sDBear,'add',[1:20],labelTrain{1});
sDBear = som_label (sDBear,'add',[21:40],labelTrain{21});
sDBear = som_label (sDBear,'add',[41:60],labelTrain{41});
%% Initialization and training of the maps   

sMap = som_make(sDBear);

sMap = som_autolabel(sMap,sDBear,'vote');
%% Visualize the maps

som_show(sMap);

% U-matrix with labels
figure;
som_show(sMap,'umat','all','empty','Labels');
som_show_add('label',sMap,'Textsize',8,'TextColor','r','Subplot',2)

%% See the hit points for healthy and faulty sets

colormap(1-gray)
som_show(sMap,'umat','all','empty','Labels');

% Add labels to the map
som_show_add('label',sMap,'Textsize',8,'TextColor','r','Subplot',2)

% sampels for test
h1 = som_hits(sMap,sDBear.data(1,:)); % data from healthy (Red)
h2 = som_hits(sMap,sDBear.data(21,:)); % data faulty 1 (Green)
h3 = som_hits(sMap,sDBear.data(41,:)); % data faulty 2 (Blue)

% diagnosis result
h1_label = sMap.labels(h1==1);
h2_label = sMap.labels(h2==1);
h3_label = sMap.labels(h3==1);

% Use hit point to show diagnosis result
som_show_add('hit',[h1, h2, h3],'MarkerColor',[1 0 0 ; 0 1 0 ; 0 0 1 ],'Subplot',1)


%% Results for testing data
colormap(1-gray)
som_show(sMap,'umat','all','empty','Labels');

% Add labels to the map
som_show_add('label',sMap,'Textsize',8,'TextColor','r','Subplot',2)

h1 = som_hits(sMap,FeatMat_test(1:10,:)); % test data healthy - red
h2 = som_hits(sMap,FeatMat_test(11:20,:)); % test data faulty 1 - green
h3 = som_hits(sMap,FeatMat_test(21:30,:)); % test data faulty 2 - blue

% diagnosis result
h1_label = sMap.labels(h1==1);
h2_label = sMap.labels(h2==1);
h3_label = sMap.labels(h3==1);

% Use hit point to show diagnosis result
som_show_add('hit',[h1, h2, h3],'MarkerColor',[1 0 0 ; 0 1 0 ; 0 0 1 ],'Subplot',1)


%%
clear h1 h2 h3 h1_label h2_label h3_label
for i=1:10
    h1 = som_hits(sMap,FeatMat_test(i,:)); % test data healthy - red
    h2 = som_hits(sMap,FeatMat_test(i+10,:)); % test data faulty 1 - green
    h3 = som_hits(sMap,FeatMat_test(i+20,:)); % test data faulty 2 - blue
    h1_label{i} = sMap.labels(h1==1);
    h2_label{i}  = sMap.labels(h2==1);
    h3_label{i}  = sMap.labels(h3==1);
    temp = convertCharsToStrings(cell2mat(h1_label{i}));
    predicted_result(i) = temp; clear temp;
    temp = convertCharsToStrings(cell2mat(h2_label{i}));
    predicted_result(i+10) = temp; clear temp;
        temp = convertCharsToStrings(cell2mat(h3_label{i}));
    predicted_result(i+20) = temp; clear temp;
end



%%
for i=1:10
    testLabels(i) = "Healthy";
    testLabels(i+10) = "Faulty1";
    testLabels(i+20) = "Faulty2";

end
%%  Confusion Matrix
%need to exclude 5 data points that are unlabeled for the formatting to
%work
cm = confusionchart(testLabels(1:25),predicted_result(1:25))
