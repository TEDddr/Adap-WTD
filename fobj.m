function [lb,ub,dim,fobj] = fobj(F)
switch F
    case 'F1'              
        fobj = @F1;
        lb=0;%下限
        ub=30;%上限
        dim=2;%维度
 end
end
% F1
function o = F1(x)
close all;
%% 第四步d：参数获取  
d_thr=x(1); % √去噪的阈值选择
d_a = x(2);
% 可以选择sqtwolog平均值、heursure启发式阈值、rigrsure无偏风险估计原理、minimaxi极大极小原理
%% 第五步e：阈值函数选择3：   
% SORH=s，软阈值;Sorh=h，硬阈值；
e_ysoft5=wthresh_i(c_d5,'s',d_thr,d_a);%软阙值处理
e_ysoft4=wthresh_i(c_d4,'s',d_thr,d_a); 
e_ysoft3=wthresh_i(c_d3,'s',d_thr,d_a);
e_ysoft2=wthresh_i(c_d2,'s',d_thr,d_a);
e_ysoft1=wthresh_i(c_d1,'s',d_thr,d_a);
e_c1=[c_a5;e_ysoft5;e_ysoft4;e_ysoft3;e_ysoft2;e_ysoft1];
%% 第六步f：重构信号4
f_CgXh=waverec(e_c1,l,'sym4'); %多尺度一维小波重构   
f_bdz=f_CgXh-b_x;%降噪后波动值
f_fin=[a_ZaoYinB(:,1),b_x,f_CgXh,f_bdz]
%% 评价指标
%信噪比
%         g_JzHou_rank=sortrows(g_JzHou);%降噪后，按序号排序
%         h_yXh=sum(abs(g_JzHou_rank(:,2)).^2)/a_m; %原始信号
%         h_JzXh=sum(abs(g_JzHou_rank(:,4)).^2)/a_m;%去噪后信号
%         SNR=10*log10(h_yXh/h_JzXh);
%波动均值
 h_JzH_Bdz=mean(abs(f_fin(:,4)),1);
%F噪音分
h_Qzz=xlsread('权重值.xlsx');
h_JzH_Score=h_Qzz(:,4)* h_JzH_Bdz;%噪音分均值
%% 输出最佳评价指标
mean_error = h_JzH_Score;%适应度函数：噪音分（信噪比）
disp(mean_error);
o =  mean_error;
end
