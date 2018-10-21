%automate simulations and solve for coefficients yielding best results
%stop simulation command:
%set_param(gcs, 'SimulationCommand', 'stop')

%prevent warnings from showing in command window
warning('off','all');

%Set up sim values
addpath('M_Files/Sim_Setup');
run('AWD_Test_W_FUZ_Control.m');

%add paths for sim files
addpath('All_Combined');
addpath('Fuzzy_Controller_Files');

%Legend for VMC
% 15 - yaw error
% 16 - Vx
% 17 - Vy
% 18 - r
% 19 - dyaw
% 20 - beta
% 21 - dbeta
% 22 - dyaw error

%test setup values
%TEST_V = [35.76];
TEST_V = [13.41 22.35 35.76];
TEST_SA_A = [2 4 6 8 10 12];
kount = 1;

[m1,sim_pts_V] = size(TEST_V);
[m2,sim_pts_SA_A] = size(TEST_SA_A);

%cntr1 = 3; kount = 13; 
for cntr1=1:sim_pts_V 
    for cntr2=1:sim_pts_SA_A
        
        %Setup new variables
        Vx0 = TEST_V(cntr1);
        SA_SAT_p = TEST_SA_A(cntr2);
        SA_SAT_n = -TEST_SA_A(cntr2);
        
        
        %simulate LQR-STA
        sim('All_Combined\AWD_EV_MODEL_rev2.mdl')%, 'CaptureErrors', 'on')
        
        %collect data
        x_pos_LQR(kount,:,:) = VMC(:,1);
        y_pos_LQR(kount,:,:) = VMC(:,2);
        r_pos_LQR(kount,:,:) = VMC(:,3);
        Vx_LQR(kount,:,:) = VMC(:,16);
        Vy_LQR(kount,:,:) = VMC(:,17);
        r_LQR(kount,:,:) = VMC(:,18);
        beta_LQR(kount,:,:) = VMC(:,20);
        dbeta_LQR(kount,:,:) = VMC(:,21);
        YE_LQR(kount,:,:) = VMC(:,15);
        dYE_LQR(kount,:,:) = VMC(:,22);
        rd_LQR(kount,:,:) = VMC(:,19);
        
        %simulate SMC
        sim('All_Combined\AWD_EV_MODEL_rev2_SMC.mdl')%, 'CaptureErrors', 'on')
        
        %collect data
        x_pos_SMC(kount,:,:) = VMC(:,1);
        y_pos_SMC(kount,:,:) = VMC(:,2);
        r_pos_SMC(kount,:,:) = VMC(:,3);
        Vx_SMC(kount,:,:) = VMC(:,16);
        Vy_SMC(kount,:,:) = VMC(:,17);
        r_SMC(kount,:,:) = VMC(:,18);
        beta_SMC(kount,:,:) = VMC(:,20);
        dbeta_SMC(kount,:,:) = VMC(:,21);
        YE_SMC(kount,:,:) = VMC(:,15);
        dYE_SMC(kount,:,:) = VMC(:,22);
        rd_SMC(kount,:,:) = VMC(:,19);
        
        kount = kount + 1
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save all the data!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Filename_ABS = sprintf('SMC_and_LQR_CSA_Test_%s.mat', datestr(now,'mm-dd-yyyy_HH-MM'));
%save(Filename_ABS);
%save('D:\SkyDrive\Thesis MATLAB Working Directory\Excel_Files_Global\LQR_STA_Data\CSA_Test\SMC_REFERENCE_DATA_CSA_Test.mat');

