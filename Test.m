clc;
clear variables;
close all;

%Taking User Input
n_sample = input('Enter the number of samples: ');
m_trials = input('Enter the number of trials: ');
trial_size = input('Enter the trial size for plot:');
% loading constants file
loadConstants; 

% Sample Mean of X initialize with Zeros case1, case2
SampleMean_X = zeros(1, m_trials);% have to change according to number of trials
StandardD_X = zeros(1, m_trials);

% Seed value calculated using vowels from name
% ex: 'Jane Jones' = a(16) + e(64) + o(512) + e(64)
val = vowelVal(name); 
display(val);

rng(val, "twister"); %Saving the random generator settings
randomSeedSave = rng;

%Since the confidence is 90% we can calculate 1-alpha/2 = 0.95
%Using the equation delta = norminv(0.95, 0, 20/sqroot(n_sample))


%% Calculating for m trials
for i=1:m_trials
    %Generating random values for N
    randomVal_N = randn(1, n_sample);
    %disp(randomVal_N)
    X = sigmaN*randomVal_N + CTrue; %realization of X
    SampleMean_X(i) = mean(X); %Estimation
    StandardD_X(i) = std(X);

end

%% Case1 known variance sigmaN
delta_1 = norminv(1-alpha/2, 0, sigmaN/sqrt(n_sample));
% computing upper and lower confidence intervals for case1
C_CI_1_upper = SampleMean_X + delta_1;
C_CI_1_lower = SampleMean_X - delta_1;
%Computing number of times CTrue lies within CI for Case 1
count_1 = 0;
for i=1:m_trials
    if((C_CI_1_lower(i)<=CTrue) && (CTrue<=C_CI_1_upper(i)))
        count_1 = count_1 + 1;
    end    
end

disp(count_1/m_trials)

%% Case2 unkown variance. Sample Variance estimator.yalpha/2 computed and verfied using Table 6.3 in Gubner = 1.645
yalphaby2 = sqrt(2)*erfinv(conf);
% In practice we do not know sigma so we Subsitute sqrt(Sample Variance)
delta_2 = (StandardD_X*yalphaby2)/sqrt(n_sample);

%computing upper and lower confidence intervals
C_CI_2_upper = SampleMean_X + delta_2;
C_CI_2_lower = SampleMean_X - delta_2;
%Computing number of times CTrue lies within CI for Case 2
count_2 = 0;
for i=1:m_trials
    if(C_CI_2_lower(i)<=CTrue && CTrue<=C_CI_2_upper(i))
        count_2 = count_2 + 1;
    end    
end
disp(count_2/m_trials)
%% Case 3 unknown variance and samples are gaussian 
%Calculating yalphaby2_t using student distribution since assuming gaussian
%samples
yalphaby2_2 = tinv(1-alpha/2, n_sample-1);
% In practice we do not know sigma so we Subsitute sqrt(Sample Variance)
delta_3 = (StandardD_X*yalphaby2_2)/sqrt(n_sample);
%disp(delta)
%computing upper and lower confidence intervals
C_CI_3_upper = SampleMean_X + delta_3;
C_CI_3_lower = SampleMean_X - delta_3;
%Computing number of times CTrue lies within CI for Case 3
count_3 = 0;
for i=1:m_trials
    if(C_CI_3_lower(i)<=CTrue && CTrue<=C_CI_3_upper(i))
        count_3 = count_3 + 1;
    end    
end
disp(count_3/m_trials)


%% Plot 3 different cases
figure();
subplot(3, 1, 1);
p1=plot(1:trial_size, CTrue*ones(1,trial_size));
l1='ChanTrue';
hold on
p2=plot(1:trial_size, SampleMean_X(1:trial_size),'--');
l2='ChanHat';
p3=plot(1:trial_size, C_CI_1_upper(1:trial_size),'-.^');
l3='CI Upper';
p4=plot(1:trial_size, C_CI_1_lower(1:trial_size),'-.v');
l4='CI Lower';
hold off
legend([p1 p2 p3 p4], {l1, l2, l3, l4});
xlabel('Trials');
title('case 1 Known variance');


subplot(3, 1, 2);
p1=plot(1:trial_size, CTrue*ones(1,trial_size));
l1='ChanTrue';
hold on
p2=plot(1:trial_size, SampleMean_X(1:trial_size), '--');
l2='ChanHat';
p3=plot(1:trial_size, C_CI_2_upper(1:trial_size), '-.^');
l3='CI Upper';
p4=plot(1:trial_size, C_CI_2_lower(1:trial_size), '-.v');
l4='CI Lower';
hold off
legend([p1 p2 p3 p4], {l1, l2, l3, l4});
xlabel('Trials');
title('case 2 Unknown variance');

subplot(3, 1, 3);
p1=plot(1:trial_size, CTrue*ones(1,trial_size));
l1='ChanTrue';
hold on
p2=plot(1:trial_size, SampleMean_X(1:trial_size), '--');
l2='ChanHat';
p3=plot(1:trial_size, C_CI_3_upper(1:trial_size), '-.^');
l3='CI Upper';
p4=plot(1:trial_size, C_CI_3_lower(1:trial_size), '-.v');
l4='CI Lower';
hold off
legend([p1 p2 p3 p4], {l1, l2, l3, l4});
xlabel('Trials');
title('case 3 Unnown variance, Guassian Samples');




