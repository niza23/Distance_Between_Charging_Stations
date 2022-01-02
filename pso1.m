clc;
clear all;
close all;

%% Parameters
MaxIt = 64;%Maximum iterations
nCS = 24; %Number of charging stations
nSet = 50; %Number of settlements
m = 2; %Average cost per km
c = 0.18; %Power consumption of EV per km
g = 10; %Generation cost of one unit
w = 1; %Inertia Coeff
wdamp = 0.99; %Damping ratio of inertia rate
c1 = 2; %Personal Acceleration Coeff
c2 = 2; %Global/Social Acceleration Coeff

%% Initialization
CS = [30.740541, 76.771028 ;
30.724221, 76.767929 ;
30.724167, 76.792629 ;
30.733638, 76.787394 ;
30.747298, 76.749916 ;
30.709091, 76.782378 ;
30.703509, 76.761203 ;
30.718217, 76.755859 ;
30.735475, 76.818485 ;
30.744317, 76.724895 ;
30.709114, 76.746470 ;
30.728778, 76.721699 ;
30.700698, 76.789619 ;
30.739577, 76.798876 ;
30.742157, 76.755052 ;
30.757710, 76.768735 ;
30.766462, 76.782568 ;
30.739773, 76.765592 ;
30.735458, 76.791863 ;
30.711272, 76.811470 ;
30.743642, 76.766311 ;
30.719137, 76.773799 ;
30.715666, 76.788210 ;
30.756161, 76.806541 ]; %Location of Charging stations

Set = [30.752163, 76.764880 ;
30.748370, 76.784246 ;
30.738823, 76.792417 ;
30.729504, 76.791815 ;
30.716595, 76.792639 ;
30.725279, 76.759838 ;
30.740549, 76.764559 ;
30.741172, 76.739981 ;
30.709509, 76.748219 ;
30.702274, 76.781629 ;
30.709952, 76.774059 ;
30.715409, 76.769050 ;
30.726548, 76.753557 ;
30.736456, 76.756558 ;
30.738336, 76.745934 ;
30.748726, 76.741101 ;
30.742905, 76.729979 ;
30.739033, 76.739517 ;
30.732255, 76.743464 ;
30.723243, 76.741114 ;
30.718519, 76.750785 ;
30.712097, 76.749246 ;
30.708457, 76.764242 ;
30.699357, 76.762175 ;
30.691667, 76.768091 ;
30.688021, 76.759842 ;
30.697182, 76.754800 ;
30.701633, 76.747098 ;
30.708395, 76.743130 ;
30.714794, 76.738341 ;
30.717160, 76.727392 ;
30.724907, 76.725924 ; 
30.728500, 76.719285 ;
30.735827, 76.710167 ;
30.771000, 76.790443 ;
30.746625, 76.794340 ;
30.701302, 76.801686 ;
30.755108, 76.759157 ;
30.739307, 76.715616 ;
30.743234, 76.762355 ;
30.759380, 76.817249 ;
30.756556, 76.743991 ;
30.764118, 76.724618 ;
30.765014, 76.787439 ;
30.767884, 76.749027 ;
30.695343, 76.798299 ;
30.723672, 76.770554 ;
30.742882, 76.806042 ;
30.737188, 76.776540 ;
30.694072, 76.774280]; %Location of settlements;

PersonalBestPosition = zeros(nCS,2);
Cost = zeros(nCS,1);
Velocity = zeros(nCS,2); 
GlobalBestCost = zeros(1,1);
GlobalBestCost(:) = inf;
GlobalBestCostEveryIt = zeros(MaxIt,1);
GlobalBestPosition = zeros(1,2);

%% Main Loop
for i=1:MaxIt
    for j=1:nCS
        dist=0;
        for k=1:nSet
            dist = dist + haversine(CS(j,:), Set(k,:));
        end
        Cost(j,:) = (m+g*c)*dist;
        Cost1 = Cost(1:j,:);
        pos = find(Cost1==min(Cost1));
        PersonalBestPosition(j,:) = CS(pos,:);
        if Cost(j,:) < GlobalBestCost(1,:)
            GlobalBestCost(1,:) = Cost(j,:);
            GlobalBestPosition(1,:) = CS(j,:);
        end
        Velocity(j,:) = w*Velocity(j,:)...
            +c1*vpa(rand(1,2),6).*(PersonalBestPosition(j,:) - CS(j,:))...
            +c2*vpa(rand(1,2),6).*(GlobalBestPosition(1,:) - CS(j,:));
        
        CS(j,:) = CS(j,:) + Velocity(j,:);
    end
    GlobalBestCostEveryIt(i,:) = GlobalBestCost(1,:);
    w = w*wdamp;
    
    disp(['Iteration #' num2str(i) ': Best Cost = ' num2str(GlobalBestCostEveryIt(i,:))]);
end

%% Results
plot(1:MaxIt, GlobalBestCostEveryIt/3.8);
title('Convergence Graph for ChadeMo');
xlabel('Number of Iterations');
ylabel('Optimised Distance');
grid;

disp(['Global Best Cost = ' num2str(GlobalBestCost)]);
disp(['Global Best Position = ' num2str(GlobalBestPosition)]);