%% SOM-MQE 
clc
clear;close;

%% Top Matter
format long; format compact;
set(0,'defaultTextInterpreter','latex'); %trying to set the default

sz = 60; %Marker Size
szz = sz/35;
lw = 1;
ms=8;
fs=25;
txtsz = 30;
txtFactor = 0.8;
ax = [0.9,1.4,0.0,2.0];
loc = 'southwest';
pos = [218,114,1478,796];
% txtsz = 24;

%%
% Load the data
load FeatMat_test.mat
load FeatMat_train.mat
addpath('F:\NOTES\Classes\Industrial AI\HW4\HW4\HW4\Useful Code\SOM-Toolbox-master\som');% add the path

%only need 1st harmonic
FeatMat_train(:,2:end) = []
FeatMat_test(:,2:end) = []

% load FeatMat_test.mat
% load FeatMat_train.mat
%% Training of SOM with Normal condition data
% 

TrainData=FeatMat_train(1:20);
TestData=FeatMat_test;
sM=som_make(TrainData);


%% Calculate the MQE values for the testing data set
S=size(TestData);
S=S(1);
for ii=1:S
    qe=som_quality(sM,TestData(ii,:)); % calculate MQE value for each sample
    MQEt(ii)=qe;
end

MQEtn=(1-(MQEt)./(max(MQEt))); % normalize MQE
MQEtn=MQEtn';
%% Plot the calculated MQE values 
% observe the difference between normal condition and faluty conditions
plot(MQEtn,'-o','Color','Blue');
xlabel('Data file No.','FontSize',fs);
ylabel('Confidence value (MQE)','FontSize',fs);
% title('Health Assessment Plot','FontSize',fs);
figure(1)
grid on; hold on; box on; 
axis square;
ax=gca;
% pbaspect([2 1 1])
ax.FontSize = fs;
ylim([0 1]);
