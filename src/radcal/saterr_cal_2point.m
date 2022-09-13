% calibration for scene 
% 
% Input:
%       simulation count etc
%
% Output:
%       --calibrated ta of scene, warm-load, cold-space
%       tas,            scene ta,                   [crosstrack,alongtrack,channel]       
%       tas_noise,      scene ta noise,             [crosstrack,alongtrack,channel]       
%       taw,            warm-load ta,               [crosstrack,alongtrack,channel]       
%       taw_noise,      warm-load ta noise,         [crosstrack,alongtrack,channel]       
%       tac,            cold-space ta,              [crosstrack,alongtrack,channel]       
%       tac_noise,      cold-space ta noise,        [crosstrack,alongtrack,channel]       
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

% -------------------------
% setting
% -------------------------
% calibration window
Win_Tail = 2; % 1=valid,2=same
Win_Shape = 'rectwin'; % rectwin/triangle
Win_Num = 7;

% varying stride
opt_vary_stride = 0; % 0=off,1=on

% -------------------------
% calibration
% -------------------------
tas = [];
tas_bias = [];
tas_noise = [];
taw_noise = [];
tac_noise = [];
for nchan = 1: Rad.num_chan
    disp(['Channel = ',num2str(nchan)])
    
    % count
    cs1 = cs(:,:,nchan)'; % [along-track,cross-track]
    cc1 = cc(:,:,nchan)';
    cw1 = cw(:,:,nchan)';
    tc1 = tc(:,:,nchan)';
    tw1 = tw(:,:,nchan)';
    
    % mean of cross-track
    ccm1 = mean(cc1,2); 
    cwm1 = mean(cw1,2);
    tcm1 = mean(tc1,2);
    twm1 = mean(tw1,2);
    
    % calibration regular
    Ind_Cal = 1:Rad.ind_CT_num(2);
    Ind_App = 1:Rad.ind_CT_num(2);
    cwm = mean(cw1(:,Ind_Cal),2);
    ccm = mean(cc1(:,Ind_Cal),2);
    
    nstr = Win_Num;
    [ind,twm1,tcm1,cwm1,ccm1,Gm1,  tas1] = cal2point_win(Win_Tail,Win_Shape,nstr,twm1,tcm1,cwm1,ccm1,  cs1);
    ind1 = ind(1):ind(2);
    cw1 = cw1(ind1,:);
    cc1 = cc1(ind1,:);
    cs1 = cs1(ind1,:);
    twm1 = twm1(ind1);
    tcm1 = tcm1(ind1);
    cwm1 = cwm1(ind1);
    ccm1 = ccm1(ind1);
    tsm1 = ref_tb_scene(:,:,nchan)';
    tsm2 = ref_tb_mainlobe(:,:,nchan)';
    
    if CalPara.nonlinear.onoff==1
        tas1 = saterr_cal_nonlinear(CalPara.nonlinear.T_nl(nchan),tas1,ccm1,cwm1,cs1);
    end
    
    tas(:,:,nchan) = tas1';
    tas_noise(:,:,nchan) = (tas1-tsm1)';
    tas_bias(:,:,nchan) = (tas1-tsm2)';

    n2c = size(cc1,2);
    n2w = size(cw1,2);

    % calibration for taw
    Ind_Cal_CW = 1;%1: round(n2w/2);
    Ind_Cal_CC = 1:n2c;
    Ind_App_CW = 2:n2w;%round(n2w/2+1):n2w;
    Ind_App_CC = 1:n2c;
    cwm1 = mean(cw1(:,Ind_Cal_CW),2);
    ccm1 = mean(cc1(:,Ind_Cal_CC),2);
    
    nstr = Win_Num;
    [ind,twm1,tcm1,cwm1,ccm1,Gm1,  tbw1] = cal2point_win(Win_Tail,Win_Shape,nstr,twm1,tcm1,cwm1,ccm1,  cw1(:,Ind_App_CW));
    ind1 = ind(1):ind(2);
    taw_noise(:,:,nchan) = (tbw1-twm1)';

    % calibration for tac
    Ind_Cal_CW = 1:n2w;
    Ind_Cal_CC = 1;%1:round(n2c/2);
    Ind_App_CW = 1:n2w;
    Ind_App_CC = 2:n2c;%round(n2c/2+1):n2c;
    cwm1 = mean(cw1(:,Ind_Cal_CW),2);
    ccm1 = mean(cc1(:,Ind_Cal_CC),2);
    
    nstr = Win_Num;
    [ind,twm1,tcm1,cwm1,ccm1,Gm1,  tbc1] = cal2point_win(Win_Tail,Win_Shape,nstr,twm1,tcm1,cwm1,ccm1,  cc1(:,Ind_App_CC));
    ind1 = ind(1):ind(2);
    tac_noise(:,:,nchan) = (tbc1-tcm1)';
    
    % calibration for striding
    strides = 1:30;
    ind_cal = 1: round(n2w/2);
    ind_app = round(n2w/2+1):n2w;
    for istride=1: length(strides)
        nstr = strides(istride);

        cwm = mean(cw,2);
        ccm = mean(cc,2);
        [ind,twm1,tcm1,cwm1,ccm1,Gm1,  tas1] = cal2point_win(Win_Tail,Win_Shape,nstr,twm1,tcm1,cwm1,ccm1,  cs1); % cs(:,1:2) similar to tbw
        t = (tas1-ref_tb_scene(:,:,nchan)')';
        [NEDT_total,NEDT_thermal,NEDT_1f,NEDT_per_1f] = decomp_NEDT_2D(t);
        NEDT_stride_tas_total(istride,nchan) = NEDT_total;
        NEDT_stride_tas_per_1f(istride,nchan) = NEDT_per_1f;

        cwm1 = mean(cw1(:,ind_cal),2);
        ccm1 = mean(cc1,2);
        [ind,twm1,tcm1,cwm1,ccm1,Gm1,  tbw1] = cal2point_win(Win_Tail,Win_Shape,nstr,twm1,tcm1,cwm1,ccm1,  cw1(:,ind_app));
        t = (tbw1-twm1)';
        [NEDT_total,NEDT_thermal,NEDT_1f,NEDT_per_1f] = decomp_NEDT_2D(t);
        NEDT_stride_taw_total(istride,nchan) = NEDT_total;
        NEDT_stride_taw_per_1f(istride,nchan) = NEDT_per_1f;
        
    end
    
end
